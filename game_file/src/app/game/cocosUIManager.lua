local _ENV, cocosUIManager
_ENV, _ENV, _G.cocosUIManager = nil, _G, cocosUIManager
_G.chatView, (nil).isInstance = nil, true
local Config = _G
function cocosUIManager:init()
	self.cachedInstanceView, _UPVALUE0_ = nil, nil
end
cocosUIManager:init()
function cocosUIManager:createView(luaFileName)
	local cfg = Config[luaFileName]
	local isInstance = cfg and cfg.isInstance
	local uiPanel
	if isInstance then
		uiPanel = self:getCachedInstanceView(luaFileName)
		if not tolua.isnull(uiPanel) then
			uiPanel._isFromCache = true
			uiPanel:setVisible(true)
			if uiPanel.onCreateFromCache then
				uiPanel:onCreateFromCache()
			end
			return uiPanel
		end
	end
	uiPanel = include(luaFileName)
	print("uiPanel,luaFileName======", uiPanel, luaFileName)
	if not uiPanel then
		print("lua 文件不存在:" .. luaFileName)
		return
	end
	local panel = uiPanel.new()
	return panel
end
function cocosUIManager:afterAddToParent(view)
	if view._isFromCache and view.onAddFromCache then
		view:onAddFromCache()
	end
end
function cocosUIManager:recycleInstanceView(view)
	local cfg = Config[view.__cname]
	if cfg and cfg.isInstance then
		self:addCachedInstanceView(view.__cname, view)
		if view.onRemoveToCache then
			view:onRemoveToCache()
		end
		return true
	end
	return false
end
function cocosUIManager:getCachedInstanceView(viewName)
	local cachedView = self.cachedInstanceView[viewName]
	return cachedView
end
function cocosUIManager:addCachedInstanceView(viewName, view)
	view:setIsKeepReference(true)
	print("cocosUIManager:retain")
	self.cachedInstanceView[viewName] = view
end
function cocosUIManager:removeCachedInstanceView(viewName)
	local view = self.cachedInstanceView[viewName]
	if view then
		if view.onClearFromCache then
			view:onClearFromCache()
		end
		view:setIsKeepReference(false)
		print("cocosUIManager:release")
		self.cachedInstanceView[viewName] = nil
	end
end
function cocosUIManager:clearCachedInstanceView()
	for _, v in pairs(self.cachedInstanceView) do
		if v.onClearFromCache then
			v:onClearFromCache()
		end
		v:setIsKeepReference(false)
		print("cocosUIManager:release")
	end
	self.cachedInstanceView, _ENV = pairs(self.cachedInstanceView)
end

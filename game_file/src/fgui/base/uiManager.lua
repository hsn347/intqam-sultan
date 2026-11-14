requireLocal(".panelConfig")
require("fgui.fguiHelper")
local panelLRUCache = require("fgui.base.panelLRUCache")
local packageManager = require("fgui.base.packageManager")
print("uiManager========")
local _ENV, uiManager = print, print
_G.uiManager = uiManager
function uiManager:init()
	self.msgMap, _ENV, self.listOrder, _ENV, self.proxys, _ENV = nil, nil, nil, nil, nil, nil
	FairyGUI.GRoot.inst.onTouchEnd:Add(function()
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINSCEN_COMMON_ICON_TIP"
		SoraDSendMessage(nil)
	end)
	self.cachedInstanceView, _ENV = FairyGUI.GRoot.inst.onTouchEnd.Add, FairyGUI.GRoot.inst.onTouchEnd.Add
	self.InstanceCache = panelLRUCache:new(99)
	self.LRUCache = panelLRUCache:new(10)
end
uiManager:init()
function uiManager:clear()
	packageManager:clear()
end
function uiManager:initLanguage()
	local lan = SoraDGetDefaultLanguage()
	print("lan", lan)
	if lan ~= "ar" then
		fgui.UIPackage:setBranch("en")
	else
		fgui.UIPackage:setBranch("")
	end
	print("branch", fgui.UIPackage:getBranch())
end
local requiredComponent
function uiManager:show(viewName, param)
	if not requiredComponent and not G_IS_UNITY then
		self:initLanguage()
		packageManager:addPackage("baseFguiPanel")
	end
	print("uiManager:show", viewName)
	local panelData = self:getPanelData(viewName)
	if not panelData then
		print("请定义panelConfig", viewName)
		return
	end
	local proxy = self:getOrCreateProxy(viewName)
	if proxy:showPanel(param) then
	end
	return proxy
end
function uiManager:isShow(viewName)
	return self:getProxy(viewName) ~= nil
end
function uiManager:close(viewName)
	local proxy = self:getProxy(viewName)
	if proxy then
		proxy:removeAllView()
	end
end
function uiManager:setGrootNomal(groot_normal)
	self.groot_normal = groot_normal
end
function uiManager:getOrCreateProxy(proxyName)
	local proxyObj = self:getProxy(proxyName)
	if proxyObj then
		return proxyObj
	else
		return self:createProxy(proxyName)
	end
end
function uiManager:createProxy(proxyName)
	local proxyPath = ""
	local panelData = self:getPanelData(proxyName)
	local moduleName = panelData.moduleName or panelData.pkg
	if panelData and panelData.useBaseProxy then
		proxyPath = "fgui.base.baseProxy"
	else
		local _proxyName = panelData.panelName or proxyName
		local className = string.format("%sProxy", _proxyName)
		if moduleName then
			proxyPath = string.format("fgui.views.%s.%s", moduleName, className)
		else
			proxyPath = string.format("fgui.views.%s", className)
		end
	end
	local Proxy = require_ex(proxyPath)
	local proxy = Proxy:create(proxyName)
	self:setProxy(proxyName, proxy)
	self:registerMessages(proxy)
	return self.proxys[proxyName]
end
function uiManager:setProxy(proxyName, proxy)
	self.proxys[proxyName] = proxy
end
function uiManager:getProxy(proxyName)
	return self.proxys[proxyName]
end
function uiManager:pushView(view)
	local viewName = view.viewName
	local parent = self.groot_normal
	local zorder = self:getPanelData(viewName).layer or 1
	parent:AddChild(view)
	local insertIndex = 1
	for i = #self.listOrder, 1, -1 do
		if zorder >= self.listOrder[i].panelConfig.layer then
			insertIndex = i + 1
			break
		end
	end
	table.insert(self.listOrder, insertIndex, view)
	self:logListView()
end
function uiManager:logListView()
end
function uiManager:popView(view)
	local viewName = view
	Log.d("uiManager popView ", viewName)
	for i = #self.listOrder, 1, -1 do
		if view == self.listOrder[i] then
			table.remove(self.listOrder, i)
			self:logListView()
			return
		end
	end
end
function uiManager:getPanelData(viewName)
	return getPanelConfig(viewName)
end
function uiManager:removeProxy(proxy)
	self:unRegisterMessages(proxy)
	self.proxys[proxy.viewName] = nil
end
function uiManager:closeAllUI(listSkip)
	if not listSkip then
		listSkip, _ENV = nil, nil
	end
	local _ENV, skips
	for _, v in pairs(listSkip) do
		skips[v] = true
	end
	self.lock = true
	local _ENV, proxy2Remove = pairs(listSkip)
	for _, v in ipairs(self.listOrder) do
		if not skips[v.viewName] then
			proxy2Remove[v.proxy.viewName] = v.proxy
		end
	end
	for _, v in pairs(proxy2Remove) do
		v:removeAllView()
	end
	self:clearCachedInstanceView()
	self.lock = false
end
function uiManager:registerMessages(proxy, fg)
end
function uiManager:unRegisterMessages(proxy, fg)
end
function uiManager:onMessage(msgName, ...)
end
function uiManager:jumpToPanel(viewName, moduleName, ...)
end
function uiManager:checkJumpByFuncId(funId, extra)
end
function uiManager:jumpToPanelByFuncId(funId, extra)
end
function uiManager:getCachedInstanceView(viewName)
	local cachedView = self.InstanceCache:get(viewName)
	if cachedView == nil then
		cachedView = self.LRUCache:get(viewName)
		print("getCachedInstanceView", viewName, cachedView)
	end
	if not tolua.isnull(cachedView) then
		cachedView:setIsFromCache(true)
		cachedView:setVisible(true)
		if cachedView.onInitByCache then
			cachedView:onInitByCache()
		end
		return cachedView
	end
	return nil
end
function uiManager:addCachedInstanceView(viewName, view)
	if view.isLRU then
		self.LRUCache:put(viewName, view)
	else
		self.InstanceCache:put(viewName, view)
	end
	if view.onExitByCache then
		view:onExitByCache()
	end
	if view.isLRU and view.debug then
		SoraDShowMsgTip("#LRU界面，debug变量无效，重载界面需要使用回车")
	end
end
function uiManager:afterAddToParent(view)
	if view.isFromCache then
		if not G_IS_UNITY then
			view:release()
		end
		if view.onEnterByCache then
			view:onEnterByCache()
		end
	end
end
function uiManager:clearCachedInstanceView()
	self.InstanceCache:clear()
	self.LRUCache:clear()
end
function uiManager:clearLRUCache()
	self.LRUCache:clear()
end
return uiManager

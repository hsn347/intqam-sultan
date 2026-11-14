local packageManager = require("fgui.base.packageManager")
local baseFguiPanel = class("baseFguiPanel", function()
	local gcomp = fgui.UIPackage:createObject("baseFguiPanel", "baseFguiPanel")
	gcomp:MakeFullScreen()
	gcomp:addEventListener(fgui.UIEventType.TouchEnd, function()
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINSCEN_COMMON_ICON_TIP"
		SoraDSendMessage(nil)
	end)
	return gcomp
end)
function baseFguiPanel:ctor(viewName, panelConfig)
	self.isSync = true
	self.isFgui = true
	self:setName(self.__cname)
	self:LuaRegisterScriptHandler()
	self.view = nil
	self._name = viewName
	self.viewName = viewName
	self.proxyName = viewName
	self.panelConfig = panelConfig
	self.isHidePrePanel = not panelConfig.isThrough and (not panelConfig.blackBg or panelConfig.blackBg == 1)
	self.isCanCloseSelf = true
	if not self.isHideCurrentSceneView then
		self.isHideCurrentSceneView = panelConfig.isHideCurrentSceneView or false
	end
	if not self.isLRU then
		self.isLRU = panelConfig.LRU or false
	end
	self.isInstance = panelConfig.isInstance or self.isLRU
	self.isFromCache = false
	self.rootNode = nil
	self.hasAnimation = false
	self.closeCallback = nil
	self.sortingOrder = panelConfig.layer
	self:playBkgMusic(true)
	self:playBkgEffect(true)
	self:addCoverLayer()
	if not self.isInstance then
		self:registerProxy()
	end
	self.basePackageMap, _UPVALUE0_, self.packageAsyncOperation, _UPVALUE0_ = self.registerProxy, self.registerProxy, self.registerProxy, self.registerProxy
	if not panelConfig.ignoreCommoneNew then
		self:_addPackage("CommonNew")
		self:_addPackage("CommonNew2")
		self:_addPackage("CommonUI")
	end
	self:_addPackage(panelConfig.pkg)
end
function baseFguiPanel:LuaRegisterScriptHandler()
	local peertable = xlua.getpeer(self)
	if peertable then
		peertable.__ins = self
	end
	self:SetLuaTable(peertable)
end
function baseFguiPanel:_initView()
	if self.isFromCache then
		self:setVisible(true)
		return
	end
	self._pkgLoaded, _ENV = self.setVisible, self.setVisible
	self:_addPackageList(self:getPackageList())
	for pkgName, __ in pairs(self.basePackageMap) do
		print("addPackage:", pkgName)
		if CS.LuaManager.isLuaExist("fgui/gcomponent/" .. pkgName .. "/components.lua") then
			require("fgui.gcomponent." .. pkgName .. ".components")
		end
		if self.isSync then
			packageManager:addPackage(pkgName)
		else
			self.packageAsyncOperation[pkgName] = packageManager:addPackageAsync(pkgName, function(bResult)
				print("pkg cb：", pkgName)
				self.packageAsyncOperation[pkgName] = nil
				self._pkgLoaded[pkgName] = true
				for k, v in pairs(self.basePackageMap) do
					if not self._pkgLoaded[k] then
						return
					end
				end
				self:onAllPkgLoaded()
			end)
		end
	end
	if self.isSync then
		self:onAllPkgLoaded()
	end
end
function baseFguiPanel:onAllPkgLoaded()
	print("onAllPkgLoaded", self.viewName)
	local gobj = fgui.UIPackage:createObject(self.panelConfig.pkg, self.panelConfig.name)
	if gobj == nil then
		self:close()
		error("undefined uiLayout:" .. self.panelConfig.uiMode.uiLayout .. " " .. self.proxyName)
		return
	end
	self.view = gobj
	self.view:setName(self.viewName)
	self.fields = fguiHelper.get_fields(self.view)
	self.controllers = fguiHelper.get_controllers(self.view)
	self.transitions = fguiHelper.get_transitions(self.view)
	self.Bg_black = self:getChild("Bg_black")
	self.Bg_empty = self:getChild("Bg_empty")
	if self.panelConfig.isThrough then
		self:setOpaque(false)
		self.Bg_black:setVisible(false)
		self.Bg_empty:setVisible(false)
	else
		self.Bg_black:setVisible(not not self.panelConfig.blackBg)
		if self.panelConfig.blackBg and type(self.panelConfig.blackBg) == "number" then
			self.Bg_black:setAlpha(self.panelConfig.blackBg)
		end
	end
	if self.panelConfig.isClickClose then
		self.Bg_black:addClickListener(handler(self, self.onClickBg))
		self.Bg_empty:addClickListener(handler(self, self.onClickBg))
	end
	self.view:setOpaque(not self.panelConfig.isThrough and not self.panelConfig.isClickClose)
	if self.panelConfig.uiLayout == UI_LAYOUT.FullScreen then
		local size = self:getContentSize()
		self.view:setSize(size.width, size.height - display.iPhoneXOffset)
		if self.panelConfig.isBeforeFitIPhoneXBar then
			self.view:setPosition(0, display.iPhoneXOffset / 2)
		else
			self.view:setPosition(0, display.iPhoneXOffset - display.iPhoneXBottom)
		end
	elseif self.panelConfig.uiLayout == UI_LAYOUT.Center then
		local x = (self:getWidth() - self.view:getWidth()) / 2
		local y = (self:getHeight() - self.view:getHeight()) / 2
		y = y + (display.iPhoneXOffset - display.iPhoneXBottom * 2) / 2
		self.view:SetXY(x, y)
	else
		error("undefined uiLayout:" .. self.panelConfig.uiLayout .. " " .. self.proxyName)
	end
	self.view:SetPivot(0.5, 0.5)
	self:_onInit()
	self:_onFitIPad()
end
function baseFguiPanel:_onFitIPad(...)
	local panelData = uiManager:getPanelData(self.viewName)
	if not panelData.fitIPad and not panelData.fitHeight then
		return
	end
	local fitHeight = panelData.fitHeight and 1136 or 900
	if fitHeight <= display.height then
		return
	end
	local fitHeight = 1136
	local fitWidth = fitHeight / display.height * 640
	self:setSize(fitWidth, fitHeight)
	if self.panelConfig.uiLayout == UI_LAYOUT.FullScreen then
		self.view:setSize(fitWidth, fitHeight)
		self.view:setPosition(0, 0)
	elseif self.panelConfig.uiLayout == UI_LAYOUT.Center then
		self.view:setPositionX((self:getWidth() - self.view:getWidth()) / 2)
		self.view:setPositionY((self:getHeight() - self.view:getHeight()) / 2)
	end
	self:setScale(640 / fitWidth)
	if self.controllers.c_fitIPad then
		self.controllers.c_fitIPad:setSelectedIndex(1)
	end
end
function baseFguiPanel:onEnter()
	self.__isOnShowing = true
	self:_initView()
	SoraDShowCurrentViewName(self.__cname, true, self.viewName, self)
	self:_onShow()
	self:addChild(self.view)
	self:doShowAnimation()
	self.__isOnShowing = false
end
function baseFguiPanel:_onInit()
	local btnClose = self.view:getChild("Button_close")
	if btnClose then
		self:bindBtnClose(btnClose)
	end
	self:onInit()
end
function baseFguiPanel:_onShow()
	self:onShow()
	if self.onEnterPanel then
		self:onEnterPanel()
	end
	if self.onShow ~= baseFguiPanel.onShow and self.onEnterPanel then
		Log.e("baseProxy", "onShow 和 onEnterPanel 只需要重写一个即可", self.proxyName)
	end
end
function baseFguiPanel:_clearPackages()
	if self.isSync then
		for pkgName, __ in pairs(self.basePackageMap) do
			packageManager:removePackage(pkgName)
		end
	else
		for i, v in ipairs(self:getPackageList()) do
			packageManager:removePackageASync(v, self.packageAsyncOperation[v])
		end
	end
end
function baseFguiPanel:onExit()
	SoraDShowCurrentViewName(self.__cname, false, self.viewName, self)
	if not self.isInstance then
		self:_clearPackages()
	end
	self:onHide()
	if not self.proxyRemoveView then
		print("fix-proxyRemoveView")
		self.proxy:removeView(self, true)
	end
end
function baseFguiPanel:onCleanup()
	if self.isInstance then
		self:_clearPackages()
	end
	if self.debug then
		fguiHelper.debugClearLua()
	end
	self:onDispose()
end
function baseFguiPanel:addCoverLayer()
end
function baseFguiPanel:removeCoverLayer()
end
function baseFguiPanel:registerProxy()
	self.proxy = uiManager:getProxy(self.proxyName)
	if self.proxy then
		self:onRegisterProxy()
		self.model = self.proxy.model
	else
		print("registerProxy error", self.proxyName)
	end
end
function baseFguiPanel:checkCloseTime()
end
function baseFguiPanel:close()
	self:closePanel()
end
function baseFguiPanel:closePanel()
	self:removeFromParent()
end
function baseFguiPanel:clickBasePanelHide()
	return true
end
function baseFguiPanel:playBkgMusic(isPreLoad)
end
function baseFguiPanel:playBkgEffect(isPreLoad)
end
function baseFguiPanel:getBackGroundColorOpacity()
	return self.Bg_black:getAlpha() * 255 or 0
end
function baseFguiPanel:removeFromParent()
	if not self._comboBoxList then
		_ENV = self._comboBoxList
	end
	for i, v in ipairs(self._comboBoxList) do
		v:HideDropdown()
	end
	if self.__isOnShowing and self.Bg_empty then
		SoraDCreateDelayTimer(self, function()
			print("delay removeFromParent")
			self.proxy:removeView(self)
		end, 0)
	else
		self.proxy:removeView(self)
	end
end
function baseFguiPanel:oldRemoveFromParent()
	fgui.GObject.removeFromParent(self)
end
function baseFguiPanel:onClickBg()
	if self.isCanCloseSelf then
		self:onClickClose()
	end
end
function baseFguiPanel:onClickClose()
	if not self or not self.doHideAnimation then
		print("baseFguiPanel:onClickClose", self, self.doHideAnimation)
		dump("", "baseFguiPanel:onClickClose===", 10)
	end
	if not self:doHideAnimation() then
		SoraDPlaySound("uicontrol", 1)
		self:close()
	end
end
function baseFguiPanel:bindBtnClose(btnClose)
	if btnClose then
		btnClose:addClickListener(handler(self, self.onClickClose))
	end
end
function baseFguiPanel:getPackageList()
	_UPVALUE0_ = nil
	return nil
end
function baseFguiPanel:_addPackage(pkgName)
	if pkgName then
		self.basePackageMap[pkgName] = true
	end
end
function baseFguiPanel:_addPackageList(packageList)

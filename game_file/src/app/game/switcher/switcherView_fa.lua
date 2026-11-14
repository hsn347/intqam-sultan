local switcherView_fa = class("switcherView_fa", function()
	local baseView = include("baseView")
	local switcherView_fa = baseView.new(display.realSize, false)
	return switcherView_fa
end)
function switcherView_fa:ctor()
	self:setPosition(cc.p(display.cx, display.rcy))
	self.viewName = "switcherView_fa"
	self:setName(self.viewName)
	self.size = self:getContentSize()
end
function switcherView_fa:onEnterOther()
	_ENV, _UPVALUE1_ = nil, nil
	;(nil).name = "switcher/switcher_fa"
	local (nil)[1], imgArray
	self:loadImages(imgArray, handler(self, self.finishLoadImages))
end
function switcherView_fa:finishLoadImages()
	print("switcherView_fa:加载资源完毕")
	self.img_bg = display.newSprite("#switcher_bg_ir.png")
	self.img_bg:setAnchorPoint(cc.p(0.5, 0.5))
	self.img_bg:setPosition(cc.p(display.cx, display.rcy))
	self.img_bg:addTo(self, 5)
end
function switcherView_fa:showSwitcher(parent)
	parent = parent or display.getRunningScene()
	parent:addChild(self, 200)
	AudioEngine.stopMusic()
	SoraDPlaySound("worldmap", 1)
end
function switcherView_fa:closeSwitcher()
	self:stepOnGuid()
	self:removeFromParent()
end
function switcherView_fa:stepOnGuid()
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_GUIDE_STEP_ON"
	;(nil).step = 2026
	SoraDSendMessage(nil)
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_GUIDE_STEP_ON"
	;(nil).step = 2035
	SoraDSendMessage(nil)
	if SoraDCurrentSceneShowView("worldMapView") then
		gModuleMgr.sharedMgr("mildGuideManager"):updatePanelShow("worldMapView")
	elseif SoraDCurrentSceneShowView("mainCityView") then
		gModuleMgr.sharedMgr("mildGuideManager"):updatePanelShow("mainCityView")
	end
	if SoraDIsGameGuide() == nil and SoraDConfigGet("Game:SwitcherView:showWorldMapExplainView~bool") == false then
		_ENV = nil
		;(nil).instanceType = 0
		;(nil).classId = 99
		;(nil).title = i18n("common_text_1108")
		uiManager:show("WorldMapExplain", nil)
		SoraDConfigSet("Game:SwitcherView:showWorldMapExplainView~bool", true)
	end
end
return switcherView_fa

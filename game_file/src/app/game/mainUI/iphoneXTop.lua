local IphoneXTop = class("iphoneXTop", function(target)
	if target == nil then
		return SoraDCreateBasePanel("iphoneXTop")
	end
	return target
end)
function IphoneXTop:ctor()
	self.isMove = false
	self.blackCount = 0
	self.swallowCount = 0
	self.btnAccount = SoraDGetChildByName(self, "Button_account")
	self.btnAccount:setPressedActionEnabled(false)
	self.btnRanking = SoraDGetChildByName(self, "Button_ranking")
	self.btnRanking:setPressedActionEnabled(false)
	self.touchPanel = SoraDGetChildByName(self, "Panel_top")
	self.touchPanel:setSwallowTouches(false)
	self.touchPanel:setVisible(false)
	self.btnAccount:addTouchEventListener(handler(self, self.btnClick))
	self.btnRanking:addTouchEventListener(handler(self, self.btnClick))
	SoraDAddMessage(self, "MESSAGE_MAIN_IPHONEX_UPDATE", handler(self, self.updateView))
	if device.platform ~= "ios" then
		local ccsView = self:getChildByName("ccsView")
		local controllers = fguiHelper.get_controllers(ccsView)
		ccsView:setSize(cc.size(display.width, display.iPhoneXOffset))
		controllers.c1:setSelectedIndex(1)
	end
end
function IphoneXTop:btnClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if button == self.btnRanking then
			local gametop = gModuleMgr.getObject("gametop")
			local cityCtrl = gametop.playertop_:getModule("cityCtrl")
			local curLevel = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
			if curLevel < CASTLE_LV6_LIMITED then
				SoraDShowMsgTip(i18n("notice_0115"), nil, button)
			elseif not SoraDSearchPanelFromManagerByName("rankingsView") then
				uiManager:show("rankingsView")
			end
		else
			userSDKManager.showUserCenter()
		end
	end
end
function IphoneXTop:updateView(target, data)
	self.blackCount = 0
	self.swallowCount = 0
	self.touchPanel:setBackGroundColorOpacity(0)
	if data.onEnter then
		if data.opacity then
			self.touchPanel:setBackGroundColorOpacity(data.opacity)
		else
			self.touchPanel:setBackGroundColorOpacity(80)
		end
		self.blackCount = 1
		self.swallowCount = 1
	else
		local topPanel = SoraDCurrentTopPanelFromManager()
		if topPanel and topPanel.isTranslucentView then
			if not tolua.isnull(topPanel) and topPanel:isVisible() then
				self.blackCount = 1
				self.touchPanel:setBackGroundColorOpacity(topPanel:getBackGroundColorOpacity())
			end
			self.swallowCount = 1
		end
	end
	self.touchPanel:setVisible(self.blackCount > 0)
	self:setSwallowTouches(0 >= self.swallowCount)
	self.btnAccount:setSwallowTouches(0 >= self.swallowCount)
	self.btnRanking:setSwallowTouches(0 >= self.swallowCount)
	self.btnAccount:setTouchEnabled(0 >= self.swallowCount)
	self.btnRanking:setTouchEnabled(0 >= self.swallowCount)
end
return IphoneXTop

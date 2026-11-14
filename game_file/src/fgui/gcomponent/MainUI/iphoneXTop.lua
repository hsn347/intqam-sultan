local baseComponent = require("fgui.base.baseComponent")
local iphoneXTop = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MainUI/iphoneXTop", iphoneXTop)
function iphoneXTop:onInit()
	self.isMove = false
	self.blackCount = 0
	self.swallowCount = 0
	self.fields.Button_ranking:addClickEventListener(handler(self, self.btnClick), "ranking")
	self.fields.Button_account:addClickEventListener(handler(self, self.btnClick), "account")
	self.btnRanking = self.fields.Button_ranking
	self.btnAccount = self.fields.Button_account
	self.touchPanel = self.fields.Panel_top
	self.touchPanel:setSwallowTouches(false)
	self.touchPanel:setVisible(false)
end
function iphoneXTop:registerEvent()
	SoraDAddMessage(self, "MESSAGE_MAIN_IPHONEX_UPDATE", handler(self, self.updateView))
end
function iphoneXTop:onShow()
	if device.platform ~= "ios" then
		self:setSize(cc.size(display.width, display.iPhoneXOffset - display.iPhoneXBottom))
		self.controllers.c1:setSelectedIndex(1)
	end
end
function iphoneXTop:updateView(target, data)
	if device.platform ~= "ios" then
		return
	end
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
function iphoneXTop:btnClick(button, param)
	SoraDPlaySound()
	_UPVALUE2_ = nil
	;(nil)[1] = param
	;(nil)[2] = "ranking"
	dump(nil, "iphoneXTop:btnClick")
	if param == "ranking" then
		local gametop = gModuleMgr.getObject("gametop")
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		local curLevel = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
		if curLevel < CASTLE_LV6_LIMITED then
			SoraDShowMsgTip(i18n("notice_0115"), nil, button)
		elseif not SoraDSearchPanelFromManagerByName("rankingsView") then
			uiManager:show("rankingsView")
		end
	elseif param == "account" then
		userSDKManager.showUserCenter()
	end
end
return iphoneXTop

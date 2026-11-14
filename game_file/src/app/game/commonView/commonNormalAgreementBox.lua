local commonNormalAgreementBox = class("commonNormalAgreementBox", function(target)
	if target == nil then
		return SoraDCreateBasePanel("commonNormalAgreementBox")
	end
	return target
end)
function commonNormalAgreementBox:ctor()
	self.isSelected = true
	self.isAddToPopManager = true
	self:setBackGround(204.0, cc.c3b(0, 0, 0))
	self.center_Node = SoraDGetChildByName(self, "Center_Node")
	self.center_Node:setScale(0)
	self.center_Node:runAction(cca.scaleTo(0.2, 1))
	self.lab_title = SoraDGetChildByName(self, "Text_title")
	self.lab_des = SoraDGetChildByName(self, "Text_des")
	self.lab_look = SoraDGetChildByName(self, "Text_look")
	SoraDDrawTextUnderLine(self.lab_look, cc.c4b(170, 140, 98, 255))
	self.lab_look:setTouchEnabled(true)
	self.lab_look:setTouchScaleChangeEnabled(true)
	self.lab_look:addTouchEventListener(handler(self, self.onLookClick))
	self.lab_tip = SoraDGetChildByName(self, "Text_tip")
	self.btn_select = SoraDGetChildByName(self, "Button_select")
	self.btn_select:addTouchEventListener(handler(self, self.btnSelectClickCallBack))
	self.img_select = SoraDGetChildByName(self, "icon_select")
	self.img_select:setVisible(self.isSelected)
	self.btn_contine = SoraDGetChildByName(self, "Button_continue")
	self.btn_contine:setTitleText(i18n("common_text_3425"))
	self.btn_contine:addTouchEventListener(handler(self, self.onBtnContinueClick))
	self.btn_close = SoraDGetChildByName(self, "Button_closeBox")
	self.btn_close:addTouchEventListener(handler(self, self.onBtnCloseClick))
	self.line_top = SoraDGetChildByName(self, "yellow_line_1")
	self.line_bottom = SoraDGetChildByName(self, "yellow_line_2")
	self.img_bg = SoraDGetChildByName(self, "Image_bg")
	self:suitView()
	userSDKManager.onGuideEvent(2801)
end
function commonNormalAgreementBox:suitView()
	local gametop = gModuleMgr.getObject("gametop")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	self.titleKey = i18n("common_text_4330")
	self.url = "https://www.onemt.com/policy.html"
	_ENV = nil
	;(nil).rule = self.titleKey
	local des = i18n("common_text_4329", nil)
	_ENV = self.titleKey
	self.titleKey.rule = self.titleKey
	local title = i18n("common_text_4328", self.titleKey)
	if lordInfoCtrl.lordInfo.base.createTime and lordInfoCtrl.lordInfo.base.createTime >= 1527249600 then
		self.titleKey = i18n("common_text_3422")
		self.url = "https://www.onemt.com/terms_policy.html"
		_ENV = self.titleKey
		self.titleKey.rule = self.titleKey
		des = i18n("common_text_3423", self.titleKey)
		title = self.titleKey
	end
	if userSDKManager.isKO() then
		self.url = "https://privacy.ventumm.com/"
	end
	self.lab_title:setString(title)
	self.lab_des:setString(des)
	_ENV = nil
	;(nil).rule = self.titleKey
	self.lab_look:setString(i18n("common_text_3424", nil))
	_ENV = i18n("common_text_3424", nil)
	i18n("common_text_3424", nil).rule = self.titleKey
	self.lab_tip:setString(i18n("common_text_3426", i18n("common_text_3424", nil)))
	self.lab_look:setPositionY(-40)
	self.lab_des:setPositionY(15)
	self.lab_title:setPositionY(self.lab_des:getPositionY() + SoraDGetAutoHeightLabel(self.lab_des, self.lab_des:getContentSize().width) + 13)
	self.btn_close:setPositionY(self.lab_title:getPositionY() + 39)
	self.line_top:setPositionY(self.lab_title:getPositionY() + 59)
	self.lab_tip:setPositionY(self.lab_look:getPositionY() - 29)
	self.btn_select:setPositionY(self.lab_tip:getPositionY() - SoraDGetAutoHeightLabel(self.lab_tip, self.lab_tip:getContentSize().width) / 2)
	self.btn_contine:setPositionY(self.lab_tip:getPositionY() - SoraDGetAutoHeightLabel(self.lab_tip, self.lab_tip:getContentSize().width) - 54)
	self.line_bottom:setPositionY(self.btn_contine:getPositionY() - 52)
	self.img_bg:setPositionY(self.line_top:getPositionY())
	self.img_bg:setContentSize(cc.size(self.img_bg:getContentSize().width, self.line_top:getPositionY() - self.line_bottom:getPositionY()))
	local period = SoraDGetDayPeriod()
	if period == gDay.DAY_TIME then
		self:setBackGround(204.0, cc.c3b(0, 0, 0))
	else
		self:setBackGround(127.5, cc.c3b(0, 0, 0))
	end
end
function commonNormalAgreementBox:btnSelectClickCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.isSelected = not self.isSelected
		print("self.isSelected=", self.isSelected)
		self.img_select:setVisible(self.isSelected)
		self.btn_contine:setBright(self.isSelected)
		if not self.isSelected then
			_ENV = nil
			;(nil).rule = self.titleKey
			SoraDShowMsgTip(i18n("common_text_3428", nil))
		end
	end
end
function commonNormalAgreementBox:onLookClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local channel = userSDKManager.getChannel()
		if channel == "ar" and SoraDFIsRA() then
			userSDKManager.openSDKLink(self.url)
		else
			userSDKManager.openSDKLink(self.url)
		end
	end
end
function commonNormalAgreementBox:onBtnContinueClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if not self.isSelected then
			_ENV = nil
			;(nil).rule = self.titleKey
			SoraDShowMsgTip(i18n("common_text_3449", nil))
		else
			local gametop = gModuleMgr.getObject("gametop")
			local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
			lordInfoCtrl:sendCheckUserAgreement()
			_ENV = i18n("common_text_3449", nil)
			_ENV, i18n("common_text_3449", nil).isAgree = i18n("common_text_3449", nil)
			i18n("common_text_3449", nil).byUID = true
			SoraDConfigSet("Game:GetCrashlytics:track~table", i18n("common_text_3449", nil))
			_ENV = i18n("common_text_3449", nil)
			userSDKManager.logEvent(gSDKDef.TDonEvent.click_continue_game, i18n("common_text_3449", nil))
			self:removeFromParent()
		end
	end
end
function commonNormalAgreementBox:closeConfirm()
	_ENV = nil
	;(nil).rule = self.titleKey
	local panel = SoraDShowMsgBox(i18n("common_text_3427", nil), i18n("common_text_185"), i18n("common_text_204"), function(eventType)
		if eventType == MSGBOX_CALLBACK_YES then
		elseif eventType == MSGBOX_CALLBACK_NO then
			print("退出游戏===")
			if device.platform == "android" or device.platform == "mac" then
				app:exit()
			else
				os.exit()
			end
		end
	end)
	panel:setLocalZOrder(202)
end
function commonNormalAgreementBox:onBtnCloseClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:closeConfirm()
	end
end
function commonNormalAgreementBox:show(parent)
	parent = parent or display.getRunningScene().panelView
	if parent then
		SoraDAddPanelToManager(self)
		parent:addChild(self, 201)
	end
end
return commonNormalAgreementBox

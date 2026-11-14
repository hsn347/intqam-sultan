local koUserNotifyView = class("koUserNotifyView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("koUserNotifyView")
	end
	return target
end)
function koUserNotifyView:ctor()
	self:setBackGround(204.0, cc.c3b(0, 0, 0))
	self:initData()
end
function koUserNotifyView:initData()
	self.centerNode = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("userPact_text_01"))
	self.textTips = SoraDGetChildByName(self, "Text_Tips")
	self.textTips:setString(i18n("userPact_text_02"))
	self.textTips:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	self.scroll = SoraDGetChildByName(self, "ScrollView")
	self.textDescribe = SoraDGetChildByName(self, "Text_describe")
	self.textDescribe:setString(i18n("userPact_text_07"))
	self.textDescribe:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	self.textDescribe:setPosition(self.textDescribe:getPositionX() + 15, self.textDescribe:getPositionY() + 40)
	SoraDSetTextWidthHeight(self.textDescribe, cc.size(500, 500))
	self.agreeBtn = SoraDGetChildByName(self, "Button_agree")
	self.disAgreeBtn = SoraDGetChildByName(self, "Button_disagree")
	self.agreeBtn:addTouchEventListener(handler(self, self.onBtnAgreeClick))
	self.agreeBtn:setTitleText(i18n("common_text_140"))
	self.disAgreeBtn:addTouchEventListener(handler(self, self.onBtnDisAgreeClick))
	self.disAgreeBtn:setTitleText(i18n("chapter_name_305"))
end
function koUserNotifyView:onBtnAgreeClick(button, event)
	if event == ccui.TouchEventType.ended then
		_ENV = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:MainCityView:ROSKOChoice~bool", true, nil)
		SoraDGetCtrl("lordInfoCtrl"):checkROSKOChoice(true)
		self:closePanel()
		_ENV = self
		self.msg = "MESSAGE_KOCHOICE_REFRESH"
		SoraDSendMessage(self)
	end
end
function koUserNotifyView:onBtnDisAgreeClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDShowMsgBox(i18n("userPact_text_03"), i18n("common_text_204"), i18n("common_text_185"), function(callType, target)
			if callType == MSGBOX_CALLBACK_YES then
				_ENV = nil
				;(nil).byUID = true
				SoraDConfigSet("Game:MainCityView:ROSKOChoice~bool", false, nil)
				SoraDGetCtrl("lordInfoCtrl"):checkROSKOChoice(false)
				target:close(nil, ccui.TouchEventType.ended)
				self:closePanel()
			elseif callType == MSGBOX_CALLBACK_NO then
				target:close(nil, ccui.TouchEventType.ended)
			end
		end)
	end
end
return koUserNotifyView

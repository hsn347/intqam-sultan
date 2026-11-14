local DjTopicView = class("djTopicView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("djTopicView")
	end
	return target
end)
function DjTopicView:ctor()
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.btnOk = SoraDGetChildByName(self, "Button_ok")
	self.tfdTopic = SoraDGetChildByName(self, "TextField_topic")
	self.tfdTopic:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
	self.tfdTopic:addEventListener(fgui.UIEventType.Changed, handler(self, self.OnInputNotice))
	self.tfdTopic:setTextHorizontalAlignment(SoraDFLabelR())
	self.labelTopic = SoraDGetChildByName(self, "Text_topic")
	self.nodeTitle:setTitleName(i18n("Anchor_text_29"))
	self.labelTopic:setString(i18n("Anchor_text_30"))
	if self.btnOk then
		self.btnOk:addTouchEventListener(handler(self, self.btnClickCallBack))
		self.btnOk:setTitleText(i18n("common_text_204"))
		self.btnOk:setTouchEnabled(false)
		self.btnOk:setBright(false)
	end
end
function DjTopicView:OnInputNotice(textField, eventType)
	local input = string.utf8len(self.tfdTopic:getString())
	self.btnOk:setTouchEnabled(0 < input)
	self.btnOk:setBright(0 < input)
end
function DjTopicView:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local str = self.tfdTopic:getString()
		SoraDGetCtrl("djCtrl"):sendChatDJOpenTopic(str)
		SoraDShowLoading()
		self:removeFromParent()
	end
end
return DjTopicView

local RechargeGainGiftView = class("rechargeGainGiftView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("rechargeGainGiftView")
	end
	return target
end)
function RechargeGainGiftView:ctor()
	self:bindBtnClose()
	self.btnOk = SoraDGetChildByName(self, "Button_ok")
	self.txtTitle = SoraDGetChildByName(self, "Text_title")
	self.txtContent = SoraDGetChildByName(self, "Text_content")
	SoraDGetChildByName(self, "Image_bg"):setTouchEnabled(true)
	SoraDGetChildByName(self, "Image_bg"):setFillType(1)
	self.txtTitle:setString(i18n("common_text_316"))
	self.txtContent:setString(i18n("common_text_1448"))
	self.btnOk:addTouchEventListener(handler(self, self.btnOkClick))
	self.btnOk:setTitleText(i18n("common_text_204"))
end
function RechargeGainGiftView:btnOkClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		self:removeFromParent()
	end
end
return RechargeGainGiftView

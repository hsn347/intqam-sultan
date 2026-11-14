local AllianceBlackWhiteHelpView = class("allianceBlackWhiteHelpView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("allianceBlackWhiteHelpView")
	end
	return target
end)
function AllianceBlackWhiteHelpView:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.centerNode = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("common_text_1678"))
	self.btnOk = SoraDGetChildByName(self, "Button_ok")
	self.labelBlack = SoraDGetChildByName(self, "Text_black")
	self.labelBlackDes = SoraDGetChildByName(self, "Text_blackDes")
	self.labelWhite = SoraDGetChildByName(self, "Text_white")
	self.labelWhiteDes = SoraDGetChildByName(self, "Text_whiteDes")
	if self.btnOk then
		self.btnOk:addTouchEventListener(handler(self, self.btnClickCallBack))
	end
	self.btnOk:setTitleText(i18n("common_text_204"))
	self.labelBlack:setString(i18n("common_text_1679"))
	self.labelBlackDes:setString(i18n("common_text_1685"))
	self.labelWhite:setString(i18n("common_text_1680"))
	self.labelWhiteDes:setString(i18n("common_text_1686"))
end
function AllianceBlackWhiteHelpView:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:close(button, type)
	end
end
return AllianceBlackWhiteHelpView

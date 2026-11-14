local djCtrl = SoraDGetCtrl("djCtrl")
local DjMsgScreenView = class("djMsgScreenView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("djMsgScreenView")
	end
	return target
end)
function DjMsgScreenView:ctor()
	self.screenPoint = djCtrl:getScreenPoint()
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.nodeInfo = SoraDGetChildByName(self, "Node_info")
	self.btnOk = SoraDGetChildByName(self, "Button_ok")
	self.labelPoint = SoraDGetChildByName(self, "Text_point")
	self.tfdPoint = SoraDGetChildByName(self, "TextField_point")
	self.tfdPoint:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
	self.tfdPoint:addEventListener(handler(self, self.OnInputNotice))
	self.tfdPoint:setTextHorizontalAlignment(SoraDFLabelR())
	if self.btnOk then
		self.btnOk:addTouchEventListener(handler(self, self.btnClickCallBack))
	end
	self.nodeTitle:setTitleName(i18n("Anchor_text_34"))
	djCtrl = i18n("Anchor_text_34")
	i18n("Anchor_text_34").value = ""
	self.labelPoint:setString(i18n("Anchor_text_64", i18n("Anchor_text_34")))
	self.btnOk:setTitleText(i18n("common_text_204"))
	self.tfdPoint:setString(tostring(self.screenPoint))
	self:updateBtnState()
end
function DjMsgScreenView:OnInputNotice(textField, eventType)
	local input = textField:getString()
	input = tonumber(input) or 0
	local maxVlaue = 9999
	if input > maxVlaue then
		input = maxVlaue
	end
	textField:setString(input)
	if eventType == ccui.TextFiledEventType.detach_with_ime then
		self:updateBtnState()
	end
end
function DjMsgScreenView:updateBtnState()
	local point = tonumber(self.tfdPoint:getString())
	self.btnOk:setTouchEnabled(point ~= self.screenPoint)
	self.btnOk:setBright(point ~= self.screenPoint)
end
function DjMsgScreenView:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		djCtrl:setScreenPoint(tonumber(self.tfdPoint:getString()))
		SoraDShowMsgTip(i18n("Anchor_text_36"))
		self:removeFromParent()
	elseif type == ccui.TouchEventType.began then
		self:updateBtnState()
	end
end
return DjMsgScreenView

local commonHelpShowView = class("commonHelpShowView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("commonHelpShowView")
	end
	return target
end)
function commonHelpShowView:ctor()
	self.Text_title = SoraDGetChildByName(self, "Text_title")
	self.scroll = SoraDGetChildByName(self, "ScrollView_msg")
	self.Text_msg = SoraDGetChildByName(self, "Text_msg")
	self.Button_ok = SoraDGetChildByName(self, "Button_ok")
	self.Button_ok:setTitleText(i18n("common_text_204"))
	self.Button_ok:addTouchEventListener(handler(self, self.btnOKClick))
end
function commonHelpShowView:setMsg(title, msg, other)
	self.Text_title:setString(title)
	if other then
		if other.float then
			self:setFloat(other.float)
		end
		if other.align then
			self.Text_msg:setTextHorizontalAlignment(other.align)
		end
	end
	local labelDesH = 0
	self.Text_msg:setString(msg)
	labelDesH = SoraDGetAutoHeightLabel(self.Text_msg)
	labelDesH = labelDesH < 250 and 250 or labelDesH
	self.scroll:setInnerContainerSize(cc.size(500, labelDesH))
	self.scroll:setBounceEnabled(250 < labelDesH)
	self.Text_msg:setAnchorPoint(cc.p(0.5, 1))
	self.Text_msg:setPositionY(labelDesH)
end
function commonHelpShowView:btnOKClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:removeFromParent()
	end
end
return commonHelpShowView

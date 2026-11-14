local anchorSelectTip = class("anchorSelectTip", function(target)
	if target == nil then
		return SoraDCreateBasePanel("anchorSelectTip")
	end
	return target
end)
function anchorSelectTip:ctor()
	self.btnMatch = SoraDGetChildByName(self, "Button_match")
	self.btnMatch:addTouchEventListener(handler(self, self.onClick_btnMatch))
	self.txtMatchTitle = SoraDGetChildByName(self, "Text_match_title")
	self.txtMatchTitle:setString(i18n("Anchor_btn_06"))
end
function anchorSelectTip:onClick_btnMatch(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDCreatePanel("anchorSearchView"):show()
	end
end
return anchorSelectTip

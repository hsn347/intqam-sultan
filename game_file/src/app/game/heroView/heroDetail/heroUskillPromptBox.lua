local heroUskillPromptBox = class("heroUskillPromptBox", function()
	return SoraDCreateTouchPanel("heroUskillPromptBox")
end)
function heroUskillPromptBox:ctor()
	self.isCheck = false
	self.Text_msg = SoraDGetChildByName(self, "Text_msg")
	self.Button_yes = SoraDGetChildByName(self, "Button_yes")
	self.Button_yes:setTitleText(i18n("common_text_204"))
	self.Button_yes:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.Node_check = SoraDGetChildByName(self, "Node_check")
	self.CheckBox_show = SoraDGetChildByName(self.Node_check, "CheckBox_show")
	self.CheckBox_show:addEventListener(handler(self, self.btnCheckCallBack))
	self.CheckBox_show:setSelected(false)
	self.Text_show = SoraDGetChildByName(self.Node_check, "Text_show")
	self.Text_show:setString(i18n("heroskill_text_11"))
	SoraDToCenter(self.Node_check)
end
function heroUskillPromptBox:initData(msgStr, handle, var)
	self.Text_msg:setString(msgStr)
	self.handle = handle
	self.isCheck = var
end
function heroUskillPromptBox:btnClickCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		if self.handle then
			self.handle(self.isCheck)
		end
		self:removeFromParent()
	end
end
function heroUskillPromptBox:btnCheckCallBack(button, event)
	if event == ccui.CheckBoxEventType.selected then
		SoraDPlaySound()
		self.isCheck = false
	elseif event == ccui.CheckBoxEventType.unselected then
		SoraDPlaySound()
		self.isCheck = true
	end
end
return heroUskillPromptBox

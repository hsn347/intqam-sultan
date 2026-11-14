local CommonPromptBoxTitle = class("commonPromptBoxTitle", function()
	return SoraDCreateTouchPanel("commonPromptBoxTitle")
end)
function CommonPromptBoxTitle:ctor()
	self.txtTitle = SoraDGetChildByName(self, "Text_title")
	self.btnYes = SoraDGetChildByName(self, "Button_yes")
	self.labelMsg = SoraDGetChildByName(self, "Text_msg")
	SoraDAutoSizeButtonText(self.btnYes, cc.size(200, 60))
	self.btnYes:addTouchEventListener(handler(self, self.btnClickCallBack))
end
function CommonPromptBoxTitle:initData(boxData)
	self.txtTitle:setString(boxData.title)
	self.labelMsg:setString(boxData.content)
	self.btnYes:setTitleText(boxData.yes)
	self.callBackHandle = boxData.handle
end
function CommonPromptBoxTitle:btnClickCallBack(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.callBackHandle then
			self.callBackHandle()
			self:close(button, eventType)
		end
	end
end
return CommonPromptBoxTitle

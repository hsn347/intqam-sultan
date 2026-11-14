local baseComponent = require("fgui.base.baseComponent")
local chatFunctions = include("chatFunctions")
local Com_Chat_Quote = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ChatAtSelect/Com_Chat_Quote", Com_Chat_Quote)
function Com_Chat_Quote:onInit()
	self.fields.Button_cancel:addClickListener(handler(self, self.onClick_Button_cancel))
	self.replyMsg = nil
	self.cancelCallback = nil
	self:setVisible(false)
end
function Com_Chat_Quote:onShow()
	self:updateView()
end
function Com_Chat_Quote:setReplyMsg(replyMsg)
	self.replyMsg = replyMsg
	self:updateView()
end
function Com_Chat_Quote:getReplyMsg()
	return self.replyMsg
end
function Com_Chat_Quote:setCancelCallback(callback)
	self.cancelCallback = callback
end
function Com_Chat_Quote:updateView()
	if not self.replyMsg then
		if self.fields.text_quote then
			self.fields.text_quote:setString("")
		end
		return
	end
	if self.fields.text_quote then
		local displayText = chatFunctions.getReplyDisplayText(self.replyMsg)
		local field = self.fields.text_quote
		local maxW = field:getWidth()
		local fontSize = field:getFontSize() or 20
		if maxW and 0 < maxW then
			displayText = SoraDConvertOmissionTextByLines(maxW, displayText, fontSize, 2)
			field:setAutoSize(fgui.AutoSizeType.Height)
		end
		field:setString(displayText)
	end
end
function Com_Chat_Quote:show()
	self:setVisible(true)
	self:updateView()
end
function Com_Chat_Quote:hide()
	self:setVisible(false)
end
function Com_Chat_Quote:onClick_Button_cancel(context)
	SoraDPlaySound()
	if self.cancelCallback then
		self.cancelCallback()
	end
end
return Com_Chat_Quote

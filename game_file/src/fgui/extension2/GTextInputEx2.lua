local m = fgui.GTextInput
_ENV = nil
;(nil).Default = 0
;(nil).ASCIICapable = 1
;(nil).NumbersAndPunctuation = 2
;(nil).URL = 3
;(nil).NumberPad = 4
;(nil).PhonePad = 5
;(nil).NamePhonePad = 6
;(nil).EmailAddress = 7
;(nil).NintendoNetworkAccount = 8
;(nil).Social = 9
;(nil).Search = 10
;(nil).DecimalPad = 11
local (nil).OneTimeCode, TouchScreenKeyboardType = 12, nil
function m:setPromptHolder(s, color)
	self:setUBBEnabled(true)
	self:setPrompt(fguiHelper.getColorString(color or "#746e65", s))
end
function m:getDescription()
	return "EditBox"
end
function m:getMaxLength()
	return self.maxLength
end
function m:getPlaceHolder()
	return self.promptText
end
function m:registerScriptEditBoxHandler(handler)
	self:addEventListener(fgui.UIEventType.Submit, function()
		handler("return", self)
	end)
	self:addEventListener(fgui.UIEventType.Changed, function()
		handler("changed", self)
	end)
	self:addEventListener(fgui.UIEventType.Began, function()
		handler("began", self)
	end)
	self:addEventListener(fgui.UIEventType.Ended, function()
		handler("ended", self)
	end)
end
function m:addEventListener(callback, param2)
	if param2 then
		fgui.GObject.addEventListener(self, callback, param2)
		return
	end
	fgui.GObject.addEventListener(self, fgui.UIEventType.Submit, function()
		local eventType = ccui.TextFiledEventType.detach_with_ime
		callback(self, eventType)
	end)
end
function m:setInputFlag(inputFlag)
	cc.EDITBOX_INPUT_FLAG_PASSWORD = 0
	cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_SENTENCE = 3
	if inputFlag == cc.EDITBOX_INPUT_FLAG_PASSWORD then
		self.displayAsPassword = true
	elseif inputFlag == cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_SENTENCE then
		self.displayAsPassword = false
	else
		error("undefined inputFlag:" .. inputFlag)
	end
end
function m:setInputMode(inputMode)
	if inputMode == cc.EDITBOX_INPUT_MODE_ANY then
		self.keyboardType = TouchScreenKeyboardType.Default
	elseif inputMode == cc.EDITBOX_INPUT_MODE_EMAILADDR then
		self.keyboardType = TouchScreenKeyboardType.EmailAddress
	elseif inputMode == cc.EDITBOX_INPUT_MODE_NUMERIC then
		self.keyboardType = TouchScreenKeyboardType.NumberPad
	elseif inputMode == cc.EDITBOX_INPUT_MODE_PHONENUMBER then
		self.keyboardType = TouchScreenKeyboardType.PhonePad
	elseif inputMode == cc.EDITBOX_INPUT_MODE_URL then
		self.keyboardType = TouchScreenKeyboardType.URL
	elseif inputMode == cc.EDITBOX_INPUT_MODE_DECIMAL then
		self.keyboardType = TouchScreenKeyboardType.DecimalPad
	elseif inputMode == cc.EDITBOX_INPUT_MODE_SINGLELINE then
		self.singleLine = true
	else
		error("undefined inputMode:" .. inputMode)
	end
end
function m:setMaxLength(maxLength)
	self.maxLength = maxLength
end
function m:setPlaceHolder(pText)
	self.promptText = pText
end
function m:setPlaceholderFontColor(color)
	print_warn("暂不处理GTextInput:setPlaceholderFontColor")
end
function m:setPlaceholderFontSize(fontSize)
	print_warn("暂不处理GTextInput:setPlaceholderFontColor")
end

local baseComponent = require("fgui.base.baseComponent")
local UI_input_small = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonUI/UI_input_small", UI_input_small)
fgui.register_extension("ui://CommonUI/UI_input_short", UI_input_small)
fgui.register_extension("ui://CommonUI/UI_input_long", UI_input_small)
function UI_input_small:onInit()
end
function UI_input_small:onShow()
end
function UI_input_small:clearInput()
	self.fields.input:setText("")
end
function UI_input_small:getInputText()
	local keyname = string.match(self.fields.input:getText(), "%s*(.-)%s*$")
	if not keyname or type(keyname) ~= "string" then
		return
	end
	return keyname
end
function UI_input_small:setInputText(text)
	self.fields.input:setText(text)
end
function UI_input_small:getSearchInput()
	local keyname = self:getInputText()
	if not keyname then
		return
	end
	local keyLen = string.utf8len(keyname)
	if keyLen < SEARCH_MIN_LEN then
		SoraDShowMsgTip(i18n("common_text_961"))
		return
	end
	if keyLen > MAX_NICKNAME_LEN then
		SoraDShowMsgTip(i18n("tips_inputLengthLimit"))
		return
	end
	return keyname
end
function UI_input_small:setPrompt(prompt)
	self.fields.input:setPrompt(prompt)
end
return UI_input_small

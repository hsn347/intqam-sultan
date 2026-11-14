local m = fgui.GTextInput
function m:setPromptHolder(s, color)
	self:setUBBEnabled(true)
	self:setPrompt(fguiHelper.getColorString(color or "#746e65", s))
end

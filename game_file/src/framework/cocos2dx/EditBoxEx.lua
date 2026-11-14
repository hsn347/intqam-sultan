local c = ccui
local EditBox = c.EditBox
function EditBox:getString()
	return self:getText()
end
function EditBox:setString(param)
	return self:setText(param)
end
function EditBox:setPlaceHolderColor(param)
	return self:setPlaceholderFontColor(param)
end
function EditBox:closeIME()
	return self:closeKeyboard()
end
function EditBox:setTextColor(param)
	return self:setFontColor(param)
end
function EditBox:getCharCount()
	return string.utf8len(self:getText())
end

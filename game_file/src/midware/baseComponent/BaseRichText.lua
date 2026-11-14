local BaseText = require("midware.baseComponent.BaseText")
local BaseRichText = fgui.extension_class("BaseRichText", fgui.GLabel, BaseText)
fgui.register_extension("ui://Base/BaseRichText", BaseRichText)
function BaseRichText:ctor()
	self.__title = self:getChild("title")
	self.__title:setTouchable(true)
end
function BaseRichText:create(textContent, fontName, fontSize)
	local text = fgui.UIPackage.CreateObject1("Base", "BaseRichText")
	text.isCocos = true
	text:setPosition(0, 0)
	text:setTouchable(false)
	if textContent and textContent ~= "" then
		text:setString(textContent)
	end
	if fontName and fontName ~= "" then
		text:setFontName(fontName)
	end
	if fontSize and 0 < fontSize then
		text:setFontSize(fontSize)
	end
	return text
end
return BaseRichText

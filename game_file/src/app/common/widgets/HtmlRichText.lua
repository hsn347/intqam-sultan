local BaseRichText = require("midware.baseComponent.BaseRichText")
HtmlRichText = class("HtmlRichText", function(gTextField, ...)
	if type(gTextField) == "userdata" then
		return gTextField
	else
		return BaseRichText:create(gTextField, ...)
	end
end)
function HtmlRichText:create(...)
	return HtmlRichText.new(...)
end
return HtmlRichText

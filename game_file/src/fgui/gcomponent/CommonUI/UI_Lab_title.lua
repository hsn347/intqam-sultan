local baseComponent = require("fgui.base.baseComponent")
local UI_Lab_title = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://CommonUI/UI_Lab_title", UI_Lab_title)
fgui.register_extension("ui://CommonUI/UI_Lab_title1", UI_Lab_title)
fgui.register_extension("ui://CommonUI/UI_Lab_title2", UI_Lab_title)
function UI_Lab_title:onInit()
end
function UI_Lab_title:onShow()
end
function UI_Lab_title:setString(title, maxWidth)
	self.fields.title:setString(title)
	if maxWidth and maxWidth < self.fields.title:getTextAreaWidth() then
		self.fields.title:setWidth(maxWidth)
		self.fields.title:setAutoSize(fgui.AutoSizeType.HEIGHT)
	end
end
return UI_Lab_title

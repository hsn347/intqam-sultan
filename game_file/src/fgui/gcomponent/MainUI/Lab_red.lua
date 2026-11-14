local baseComponent = require("fgui.base.baseComponent")
local Lab_red = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://MainUI/Lab_red", Lab_red)
function Lab_red:onInit()
end
function Lab_red:onShow()
end
function Lab_red:setTitle(num)
	if 99 < num then
		self.fields.title:setString("99+")
	else
		self.fields.title:setString(num)
	end
end
return Lab_red

local baseComponent = require("fgui.base.baseComponent")
local Button_middle = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://CommonNew/Button_middle", Button_middle)
fgui.register_extension("ui://CommonNew/Button_small", Button_middle)
function Button_middle:onInit()
end
function Button_middle:onShow()
end
function Button_middle:setBtnColorIndex(index)
	self.controllers.c1:setSelectedIndex(index)
end
function Button_middle:setGrayed(value)
	if self.fields.Img_bg then
		self.fields.Img_bg:setGrayed(value)
	end
	if self.fields.icon then
		self.fields.icon:setGrayed(value)
	end
end
return Button_middle

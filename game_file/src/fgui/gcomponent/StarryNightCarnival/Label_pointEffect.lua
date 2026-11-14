local baseComponent = require("fgui.base.baseComponent")
local Label_pointEffect = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://StarryNightCarnival/Label_pointEffect", Label_pointEffect)
function Label_pointEffect:onInit()
	self.fields.Ani_point:setAllFrameName("dh_zbhd1_%.2d.png", 1)
end
function Label_pointEffect:onShow()
end
return Label_pointEffect

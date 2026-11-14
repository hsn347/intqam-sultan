local baseComponent = require("fgui.base.baseComponent")
local effect_3 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonUI/effect_3", effect_3)
function effect_3:onInit()
	self.fields.mv:setAllFrameName("dh_wangcsj4_%.2d.png", 0)
end
function effect_3:onShow()
end
return effect_3

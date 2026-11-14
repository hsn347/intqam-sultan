local baseComponent = require("fgui.base.baseComponent")
local effect_2 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonUI/effect_2", effect_2)
function effect_2:onInit()
	self.fields.mv:setAllFrameName("dh_chuanqijunwang_%.2d.png", 1)
end
function effect_2:onShow()
end
return effect_2

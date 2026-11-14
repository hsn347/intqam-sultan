local baseComponent = require("fgui.base.baseComponent")
local Lab_t = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://HeroWeapon/Lab_t", Lab_t)
function Lab_t:onInit()
	self.fields.n0:fix()
end
function Lab_t:onShow()
end
return Lab_t

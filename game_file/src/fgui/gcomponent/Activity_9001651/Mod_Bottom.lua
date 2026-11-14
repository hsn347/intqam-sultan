local baseComponent = require("fgui.base.baseComponent")
local Mod_Bottom = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001651/Mod_Bottom", Mod_Bottom)
function Mod_Bottom:onInit()
	self:fixChildrenPos()
end
function Mod_Bottom:onShow()
end
return Mod_Bottom

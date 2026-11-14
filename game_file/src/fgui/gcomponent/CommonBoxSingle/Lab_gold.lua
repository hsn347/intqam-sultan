local baseComponent = require("fgui.base.baseComponent")
local Lab_gold = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://CommonBoxSingle/Lab_gold", Lab_gold)
function Lab_gold:onInit()
	self:fixChildrenPos()
end
function Lab_gold:onShow()
end
return Lab_gold

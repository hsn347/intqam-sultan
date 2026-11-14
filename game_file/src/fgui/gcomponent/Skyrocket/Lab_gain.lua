local baseComponent = require("fgui.base.baseComponent")
local Lab_gain = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://Skyrocket/Lab_gain", Lab_gain)
function Lab_gain:onInit()
	self:fixChildrenPos()
end
function Lab_gain:onShow()
end
return Lab_gain

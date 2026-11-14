local baseComponent = require("fgui.base.baseComponent")
local Lab_heroPower = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://NewHeroView/Lab_heroPower", Lab_heroPower)
function Lab_heroPower:onInit()
	self:fixChildrenPos()
end
function Lab_heroPower:onShow()
end
return Lab_heroPower

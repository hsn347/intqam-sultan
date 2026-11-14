local baseComponent = require("fgui.base.baseComponent")
local Lab_troop = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://heroTrial/Lab_troop", Lab_troop)
function Lab_troop:onInit()
end
function Lab_troop:onShow()
end
function Lab_troop:setIconIndex(index)
	self.controllers.c1:setSelectedIndex(index)
end
function Lab_troop:setPercent(value)
	self.fields.shadow:setScaleX(value)
end
return Lab_troop

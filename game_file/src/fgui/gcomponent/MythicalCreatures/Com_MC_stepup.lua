local baseComponent = require("fgui.base.baseComponent")
local Com_MC_stepup = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MythicalCreatures/Com_MC_stepup", Com_MC_stepup)
function Com_MC_stepup:onInit()
end
function Com_MC_stepup:onShow()
end
function Com_MC_stepup:initData(isSelected)
	self.controllers.c1:setSelectedIndex(isSelected and 1 or 0)
end
function Com_MC_stepup:setStepLvMax()
	self.controllers.c1:setSelectedIndex(2)
end
return Com_MC_stepup

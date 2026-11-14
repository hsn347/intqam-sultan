local armyDesRead = include("armyDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_trap = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://soldiersCampView/Com_trap", Com_trap)
function Com_trap:onInit()
end
function Com_trap:onShow()
end
function Com_trap:initData(armyID)
	self.controllers.c1:setSelectedPage(tostring(armyID))
end
return Com_trap

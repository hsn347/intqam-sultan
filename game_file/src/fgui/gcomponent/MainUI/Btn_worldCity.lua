local funUnlockRead = include("funUnlockRead")
local baseComponent = require("fgui.base.baseComponent")
local Btn_worldCity = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_worldCity", Btn_worldCity)
function Btn_worldCity:onInit()
end
function Btn_worldCity:onShow()
end
function Btn_worldCity:setViewType(viewType)
	self.controllers.c1:setSelectedIndex(viewType)
end
function Btn_worldCity:setStatus()
	local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.WORLD_CITY)
	self.controllers.c2:setSelectedIndex(unlockLv <= SoraDGetCastleLv() and 0 or 1)
end
return Btn_worldCity

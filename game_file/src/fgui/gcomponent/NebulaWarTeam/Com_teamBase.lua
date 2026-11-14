local baseComponent = require("fgui.base.baseComponent")
local Com_teamBase = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://NebulaWarTeam/Com_teamBase", Com_teamBase)
function Com_teamBase:onInit()
end
function Com_teamBase:onShow()
end
function Com_teamBase:setIsSuperTeam(isSuperTeam)
	self.controllers.c_teamType:setSelectedIndex(isSuperTeam and 1 or 0)
end
function Com_teamBase:setString(text)
	self.fields.title:setString(text)
end
return Com_teamBase

local equipDesRead = include("equipDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_equip = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://CheatView/Com_equip", Com_equip)
function Com_equip:onInit()
end
function Com_equip:onShow()
end
function Com_equip:initData(data)
	self.fields.equip:initDataEX(data)
	self.fields.Text_name:setString(equipDesRead.getName(data.eid))
	self.fields.Text_ID:setString(data.eid)
end
return Com_equip

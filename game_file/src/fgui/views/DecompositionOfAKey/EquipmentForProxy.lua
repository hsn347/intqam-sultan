local baseProxy = require("fgui.base.baseProxy")
local EquipmentForProxy = class("EquipmentForProxy", baseProxy)
function EquipmentForProxy:onRegisterEvent()
	print("=======EquipmentForProxy:onRegisterEvent")
end
return EquipmentForProxy

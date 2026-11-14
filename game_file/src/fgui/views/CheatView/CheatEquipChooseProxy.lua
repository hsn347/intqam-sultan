local baseProxy = require("fgui.base.baseProxy")
local CheatEquipChooseProxy = class("CheatEquipChooseProxy", baseProxy)
function CheatEquipChooseProxy:onRegisterEvent()
	print("=======CheatEquipChooseProxy:onRegisterEvent")
end
return CheatEquipChooseProxy

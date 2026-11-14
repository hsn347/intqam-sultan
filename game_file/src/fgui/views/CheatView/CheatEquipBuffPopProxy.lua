local baseProxy = require("fgui.base.baseProxy")
local CheatEquipBuffPopProxy = class("CheatEquipBuffPopProxy", baseProxy)
function CheatEquipBuffPopProxy:onRegisterEvent()
	print("=======CheatEquipBuffPopProxy:onRegisterEvent")
end
return CheatEquipBuffPopProxy

local baseProxy = require("fgui.base.baseProxy")
local kingdomBattleHospitalSwitchProxy = class("kingdomBattleHospitalSwitchProxy", baseProxy)
function kingdomBattleHospitalSwitchProxy:onRegisterEvent()
	print("=======kingdomBattleHospitalSwitchProxy:onRegisterEvent")
end
return kingdomBattleHospitalSwitchProxy

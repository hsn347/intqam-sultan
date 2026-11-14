local baseProxy = require("fgui.base.baseProxy")
local kingdomBattleWarSettingProxy = class("kingdomBattleWarSettingProxy", baseProxy)
function kingdomBattleWarSettingProxy:onRegisterEvent()
	print("=======kingdomBattleWarSettingProxy:onRegisterEvent")
end
return kingdomBattleWarSettingProxy

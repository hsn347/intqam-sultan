local baseProxy = require("fgui.base.baseProxy")
local kingdomBattleInfoProxy = class("kingdomBattleInfoProxy", baseProxy)
function kingdomBattleInfoProxy:onRegisterEvent()
	print("=======kingdomBattleInfoProxy:onRegisterEvent")
end
return kingdomBattleInfoProxy

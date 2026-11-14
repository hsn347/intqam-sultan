local baseProxy = require("fgui.base.baseProxy")
local DeadArmyInfoProxy = class("DeadArmyInfoProxy", baseProxy)
function DeadArmyInfoProxy:onRegisterEvent()
	print("=======DeadArmyInfoProxy:onRegisterEvent")
end
return DeadArmyInfoProxy

local baseProxy = require("fgui.base.baseProxy")
local DesertMiningPreawardProxy = class("DesertMiningPreawardProxy", baseProxy)
function DesertMiningPreawardProxy:onRegisterEvent()
	print("=======DesertMiningPreawardProxy:onRegisterEvent")
end
return DesertMiningPreawardProxy

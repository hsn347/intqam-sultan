local baseProxy = require("fgui.base.baseProxy")
local DesertTreasureLuckProxy = class("DesertTreasureLuckProxy", baseProxy)
function DesertTreasureLuckProxy:onRegisterEvent()
	print("=======DesertTreasureLuckProxy:onRegisterEvent")
end
return DesertTreasureLuckProxy

local baseProxy = require("fgui.base.baseProxy")
local NebulaEmperorEnergyBuffProxy = class("NebulaEmperorEnergyBuffProxy", baseProxy)
function NebulaEmperorEnergyBuffProxy:onRegisterEvent()
	print("=======NebulaEmperorEnergyBuffProxy:onRegisterEvent")
end
return NebulaEmperorEnergyBuffProxy

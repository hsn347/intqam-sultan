local baseProxy = require("fgui.base.baseProxy")
local NebulaEmperorPlayerResultProxy = class("NebulaEmperorPlayerResultProxy", baseProxy)
function NebulaEmperorPlayerResultProxy:onRegisterEvent()
	print("=======NebulaEmperorPlayerResultProxy:onRegisterEvent")
end
return NebulaEmperorPlayerResultProxy

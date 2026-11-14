local baseProxy = require("fgui.base.baseProxy")
local NebulaEmperorRebornBlessProxy = class("NebulaEmperorRebornBlessProxy", baseProxy)
function NebulaEmperorRebornBlessProxy:onRegisterEvent()
	print("=======NebulaEmperorRebornBlessProxy:onRegisterEvent")
end
return NebulaEmperorRebornBlessProxy

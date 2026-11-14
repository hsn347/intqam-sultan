local baseProxy = require("fgui.base.baseProxy")
local marketNoAllianceProxy = class("marketNoAllianceProxy", baseProxy)
function marketNoAllianceProxy:onRegisterEvent()
	print("=======marketNoAllianceProxy:onRegisterEvent")
end
return marketNoAllianceProxy

local baseProxy = require("fgui.base.baseProxy")
local allianceGroupMailViewProxy = class("allianceGroupMailViewProxy", baseProxy)
function allianceGroupMailViewProxy:onRegisterEvent()
	print("=======allianceGroupMailViewProxy:onRegisterEvent")
end
return allianceGroupMailViewProxy

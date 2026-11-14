local baseProxy = require("fgui.base.baseProxy")
local allianceHuntPopViewProxy = class("allianceHuntPopViewProxy", baseProxy)
function allianceHuntPopViewProxy:onRegisterEvent()
	print("=======allianceHuntPopViewProxy:onRegisterEvent")
end
return allianceHuntPopViewProxy

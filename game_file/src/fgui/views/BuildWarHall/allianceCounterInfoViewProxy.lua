local baseProxy = require("fgui.base.baseProxy")
local allianceCounterInfoViewProxy = class("allianceCounterInfoViewProxy", baseProxy)
function allianceCounterInfoViewProxy:onRegisterEvent()
	print("=======allianceCounterInfoViewProxy:onRegisterEvent")
end
return allianceCounterInfoViewProxy

local baseProxy = require("fgui.base.baseProxy")
local allianceCounterLogViewProxy = class("allianceCounterLogViewProxy", baseProxy)
function allianceCounterLogViewProxy:onRegisterEvent()
	print("=======allianceCounterLogViewProxy:onRegisterEvent")
end
return allianceCounterLogViewProxy

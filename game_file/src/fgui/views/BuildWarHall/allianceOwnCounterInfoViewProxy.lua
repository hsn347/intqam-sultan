local baseProxy = require("fgui.base.baseProxy")
local allianceOwnCounterInfoViewProxy = class("allianceOwnCounterInfoViewProxy", baseProxy)
function allianceOwnCounterInfoViewProxy:onRegisterEvent()
	print("=======allianceOwnCounterInfoViewProxy:onRegisterEvent")
end
return allianceOwnCounterInfoViewProxy

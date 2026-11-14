local baseProxy = require("fgui.base.baseProxy")
local FarmResonanceProxy = class("FarmResonanceProxy", baseProxy)
function FarmResonanceProxy:onRegisterEvent()
	print("=======FarmResonanceProxy:onRegisterEvent")
end
return FarmResonanceProxy

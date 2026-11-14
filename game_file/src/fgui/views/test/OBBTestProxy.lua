local baseProxy = require("fgui.base.baseProxy")
local OBBTestProxy = class("OBBTestProxy", baseProxy)
function OBBTestProxy:onRegisterEvent()
	print("=======OBBTestProxy:onRegisterEvent")
end
return OBBTestProxy

local baseProxy = require("fgui.base.baseProxy")
local ForeignsublimationProxy = class("ForeignsublimationProxy", baseProxy)
function ForeignsublimationProxy:onRegisterEvent()
	print("=======ForeignsublimationProxy:onRegisterEvent")
end
return ForeignsublimationProxy

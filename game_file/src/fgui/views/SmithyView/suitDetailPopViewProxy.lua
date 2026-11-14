local baseProxy = require("fgui.base.baseProxy")
local suitDetailPopViewProxy = class("suitDetailPopViewProxy", baseProxy)
function suitDetailPopViewProxy:onRegisterEvent()
	print("=======suitDetailPopViewProxy:onRegisterEvent")
end
return suitDetailPopViewProxy

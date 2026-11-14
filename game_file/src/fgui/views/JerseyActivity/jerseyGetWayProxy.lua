local baseProxy = require("fgui.base.baseProxy")
local jerseyGetWayProxy = class("jerseyGetWayProxy", baseProxy)
function jerseyGetWayProxy:onRegisterEvent()
	print("=======jerseyGetWayProxy:onRegisterEvent")
end
return jerseyGetWayProxy

local baseProxy = require("fgui.base.baseProxy")
local commonGetWayViewProxy = class("commonGetWayViewProxy", baseProxy)
function commonGetWayViewProxy:onRegisterEvent()
	print("=======commonGetWayViewProxy:onRegisterEvent")
end
return commonGetWayViewProxy

local baseProxy = require("fgui.base.baseProxy")
local gameFanActivitiesProxy = class("gameFanActivitiesProxy", baseProxy)
function gameFanActivitiesProxy:onRegisterEvent()
	print("=======gameFanActivitiesProxy:onRegisterEvent")
end
return gameFanActivitiesProxy

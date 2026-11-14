local baseProxy = require("fgui.base.baseProxy")
local NebulaWarScheduleProxy = class("NebulaWarScheduleProxy", baseProxy)
function NebulaWarScheduleProxy:onRegisterEvent()
	print("=======NebulaWarScheduleProxy:onRegisterEvent")
end
return NebulaWarScheduleProxy

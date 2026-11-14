local baseProxy = require("fgui.base.baseProxy")
local Activity_2048_MainProxy = class("Activity_2048_MainProxy", baseProxy)
function Activity_2048_MainProxy:onRegisterEvent()
	print("=======Activity_2048_MainProxy:onRegisterEvent")
end
return Activity_2048_MainProxy

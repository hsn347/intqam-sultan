local baseProxy = require("fgui.base.baseProxy")
local Activity_bubble_MainProxy = class("Activity_bubble_MainProxy", baseProxy)
function Activity_bubble_MainProxy:onRegisterEvent()
	print("=======Activity_bubble_MainProxy:onRegisterEvent")
end
return Activity_bubble_MainProxy

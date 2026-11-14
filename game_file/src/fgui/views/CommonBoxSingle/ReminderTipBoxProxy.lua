local baseProxy = require("fgui.base.baseProxy")
local ReminderTipBoxProxy = class("ReminderTipBoxProxy", baseProxy)
function ReminderTipBoxProxy:onRegisterEvent()
	print("=======ReminderTipBoxProxy:onRegisterEvent")
end
return ReminderTipBoxProxy

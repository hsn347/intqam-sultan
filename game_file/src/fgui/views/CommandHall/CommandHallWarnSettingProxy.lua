local baseProxy = require("fgui.base.baseProxy")
local CommandHallWarnSettingProxy = class("CommandHallWarnSettingProxy", baseProxy)
function CommandHallWarnSettingProxy:onRegisterEvent()
	print("=======CommandHallWarnSettingProxy:onRegisterEvent")
end
return CommandHallWarnSettingProxy

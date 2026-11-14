local baseProxy = require("fgui.base.baseProxy")
local RuneGainViewProxy = class("RuneGainViewProxy", baseProxy)
function RuneGainViewProxy:onRegisterEvent()
	print("=======RuneGainViewProxy:onRegisterEvent")
end
return RuneGainViewProxy

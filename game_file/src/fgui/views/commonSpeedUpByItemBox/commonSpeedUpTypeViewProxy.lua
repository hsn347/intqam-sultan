local baseProxy = require("fgui.base.baseProxy")
local commonSpeedUpTypeViewProxy = class("commonSpeedUpTypeViewProxy", baseProxy)
function commonSpeedUpTypeViewProxy:onRegisterEvent()
	print("=======commonSpeedUpTypeViewProxy:onRegisterEvent")
end
return commonSpeedUpTypeViewProxy

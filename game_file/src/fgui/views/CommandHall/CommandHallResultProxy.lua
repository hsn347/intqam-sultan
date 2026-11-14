local baseProxy = require("fgui.base.baseProxy")
local CommandHallResultProxy = class("CommandHallResultProxy", baseProxy)
function CommandHallResultProxy:onRegisterEvent()
	print("=======CommandHallResultProxy:onRegisterEvent")
end
return CommandHallResultProxy

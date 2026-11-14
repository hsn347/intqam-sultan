local baseProxy = require("fgui.base.baseProxy")
local CommandHallAwardProxy = class("CommandHallAwardProxy", baseProxy)
function CommandHallAwardProxy:onRegisterEvent()
	print("=======CommandHallAwardProxy:onRegisterEvent")
end
return CommandHallAwardProxy

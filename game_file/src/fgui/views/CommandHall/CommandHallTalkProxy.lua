local baseProxy = require("fgui.base.baseProxy")
local CommandHallTalkProxy = class("CommandHallTalkProxy", baseProxy)
function CommandHallTalkProxy:onRegisterEvent()
	print("=======CommandHallTalkProxy:onRegisterEvent")
end
return CommandHallTalkProxy

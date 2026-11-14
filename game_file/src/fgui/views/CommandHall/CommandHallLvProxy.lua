local baseProxy = require("fgui.base.baseProxy")
local CommandHallLvProxy = class("CommandHallLvProxy", baseProxy)
function CommandHallLvProxy:onRegisterEvent()
	print("=======CommandHallLvProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_COMMANDHALL_COMMANDLV_UPDATE", handler(self, self.onMsgUpdateCommandLv))
end
function CommandHallLvProxy:onMsgUpdateCommandLv(...)
	self.view:updateCommandLv(...)
end
return CommandHallLvProxy

local baseProxy = require("fgui.base.baseProxy")
local CommandHallRankProxy = class("CommandHallRankProxy", baseProxy)
function CommandHallRankProxy:onRegisterEvent()
	print("=======CommandHallRankProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_COMMANDHALL_UPDATE_RANK", handler(self, self.onMsgUpdateRank))
end
function CommandHallRankProxy:onMsgUpdateRank(...)
	self.view:onMsgUpdateRank(...)
end
return CommandHallRankProxy

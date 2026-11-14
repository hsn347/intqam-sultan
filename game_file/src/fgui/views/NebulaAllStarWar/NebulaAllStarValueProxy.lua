local baseProxy = require("fgui.base.baseProxy")
local NebulaAllStarValueProxy = class("NebulaAllStarValueProxy", baseProxy)
function NebulaAllStarValueProxy:onRegisterEvent()
	print("=======NebulaAllStarValueProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_GET_RANK", handler(self, self.onMsgGetPlayerRank))
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_ROB_TASK", handler(self, self.onMsgUpdateRobTask))
end
function NebulaAllStarValueProxy:onMsgGetPlayerRank(target, event)
	if event.from ~= "NebulaAllStarValue" then
		return
	end
	if not event.rspdata.myInfo then
		local _UPVALUE0_, myInfo = event.rspdata.myInfo, event.rspdata.myInfo
	end
	self.view:updateMyRankInfo(myInfo)
end
function NebulaAllStarValueProxy:onMsgUpdateRobTask(...)
	self.view:onMsgUpdateRobTask(...)
end
return NebulaAllStarValueProxy

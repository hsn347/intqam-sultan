local baseProxy = require("fgui.base.baseProxy")
local NebulaAllStarReceiveGiftRecordProxy = class("NebulaAllStarReceiveGiftRecordProxy", baseProxy)
function NebulaAllStarReceiveGiftRecordProxy:onRegisterEvent()
	print("=======NebulaAllStarReceiveGiftRecordProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_GET_RANK", handler(self, self.onMsgGetPlayerRank))
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_RECVGIFT_RECORD", handler(self, self.onMsgRecvGiftRecord))
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_RECVGIFT_RANK", handler(self, self.onMsgRecvGiftRank))
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_PLAYER_DATA", handler(self, self.onMsgPlayerData))
end
function NebulaAllStarReceiveGiftRecordProxy:onMsgGetPlayerRank(target, event)
	if event.from ~= self.view:getName() then
		return
	end
	if not event.rspdata.myInfo then
		local _UPVALUE0_, myInfo = event.rspdata.myInfo, event.rspdata.myInfo
	end
	self.view:updateMyRankInfo(myInfo)
end
function NebulaAllStarReceiveGiftRecordProxy:onMsgRecvGiftRecord(target, data)
	self.view:onMsgRecvGiftRecord(target, data)
end
function NebulaAllStarReceiveGiftRecordProxy:onMsgRecvGiftRank(target, data)
	self.view:onMsgRecvGiftRank(target, data)
end
function NebulaAllStarReceiveGiftRecordProxy:onMsgPlayerData(target, data)
	if data.clientData == self.view:getName() then
		self.view:onMsgPlayerData(target, data)
	end
end
return NebulaAllStarReceiveGiftRecordProxy

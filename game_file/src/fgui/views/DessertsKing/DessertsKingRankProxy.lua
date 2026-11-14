local baseProxy = require("fgui.base.baseProxy")
local DessertsKingRankProxy = class("DessertsKingRankProxy", baseProxy)
function DessertsKingRankProxy:onRegisterEvent()
	print("=======DessertsKingRankProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001538_UPDATE", handler(self, self.msgCallBack))
end
function DessertsKingRankProxy:msgCallBack(target, data)
	if data.subMsg == "rank" then
		self.view:onMsgUpdateRank(data)
	end
end
return DessertsKingRankProxy

local baseProxy = require("fgui.base.baseProxy")
local NebulaAllStarRankProxy = class("NebulaAllStarRankProxy", baseProxy)
function NebulaAllStarRankProxy:onRegisterEvent()
	print("=======NebulaAllStarRankProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_GET_RANK", handler(self, self.onMsgGetPlayerRank))
end
function NebulaAllStarRankProxy:onMsgGetPlayerRank(target, event)
	if event.rankType ~= self.view.rankType then
		return
	end
	SoraDCloseLoading(self.view:displayObject())
	self.view:refreshRankData(event.rspdata)
end
return NebulaAllStarRankProxy

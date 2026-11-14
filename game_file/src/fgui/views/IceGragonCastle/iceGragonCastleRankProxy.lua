local baseProxy = require("fgui.base.baseProxy")
local iceGragonCastleRankProxy = class("iceGragonCastleRankProxy", baseProxy)
function iceGragonCastleRankProxy:onRegisterEvent()
	print("=======iceGragonCastleRankProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ICE_WOLF_CASTLE_REFRESH", handler(self, self.updateRank))
end
function iceGragonCastleRankProxy:updateRank(target, data)
	if data.rankList then
		self.view:refreshRankData(data)
	end
end
return iceGragonCastleRankProxy

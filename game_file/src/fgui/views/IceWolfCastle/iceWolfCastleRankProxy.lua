local baseProxy = require("fgui.base.baseProxy")
local iceWolfCastleRankProxy = class("iceWolfCastleRankProxy", baseProxy)
function iceWolfCastleRankProxy:onInit()
	self.myRank, _UPVALUE0_, self.rankList, _UPVALUE0_ = nil, nil, nil, nil
end
function iceWolfCastleRankProxy:onRegisterEvent()
	SoraDAddMessage(self, "MESSAGE_ICE_WOLF_CASTLE_REFRESH", handler(self, self.updateRank))
end
function iceWolfCastleRankProxy:updateRank(target, data)
	if data.rankList then
		self.view:refreshRankData(data)
	end
end
return iceWolfCastleRankProxy

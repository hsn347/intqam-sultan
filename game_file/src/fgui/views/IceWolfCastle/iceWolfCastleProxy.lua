local baseProxy = require("fgui.base.baseProxy")
local iceWolfCastleProxy = class("iceWolfCastleProxy", baseProxy)
function iceWolfCastleProxy:onRegisterEvent()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ICE_WOLF_CASTLE_REFRESH", handler(self, self.updateRank))
end
function iceWolfCastleProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.RAMADAN_SHINING_CASTLE_4) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function iceWolfCastleProxy:updateRank(target, data)
	if data.subMsg == "refresh" then
		self.view:updateRankInfo()
	end
end
return iceWolfCastleProxy

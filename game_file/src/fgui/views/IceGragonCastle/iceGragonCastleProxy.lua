local baseProxy = require("fgui.base.baseProxy")
local iceGragonCastleProxy = class("iceGragonCastleProxy", baseProxy)
function iceGragonCastleProxy:onRegisterEvent()
	print("=======iceGragonCastleProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ICE_WOLF_CASTLE_REFRESH", handler(self, self.updateRank))
end
function iceGragonCastleProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(self.view.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function iceGragonCastleProxy:updateRank(target, data)
	if data.subMsg == "refresh" then
		self.view:updateRankInfo()
	end
end
return iceGragonCastleProxy

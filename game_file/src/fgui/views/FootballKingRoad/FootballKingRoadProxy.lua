local baseProxy = require("fgui.base.baseProxy")
local FootballKingRoadProxy = class("FootballKingRoadProxy", baseProxy)
function FootballKingRoadProxy:onRegisterEvent()
	SoraDAddMessage(self, "MESSAGE_CHISEL_STONE_REFRESH", handler(self, self.onUpdateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function FootballKingRoadProxy:onUpdateTask(target, data)
end
function FootballKingRoadProxy:onUpdateView()
	self.view:updateCurDay()
	self.view:updateRed()
	self.view:updateTaskTab()
	self.view:initProgress()
	SoraDCloseLoading()
	self.view:updatTaskScroll()
end
function FootballKingRoadProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.FOOTBALL_KING_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return FootballKingRoadProxy

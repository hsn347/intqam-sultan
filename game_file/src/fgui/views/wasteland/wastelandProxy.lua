local baseProxy = require("fgui.base.baseProxy")
local wastelandProxy = class("wastelandProxy", baseProxy)
function wastelandProxy:ctor(...)
	self.super.ctor(self, ...)
	self.activityID = gActivityTimeActivityID.WASTELAND
end
function wastelandProxy:onRegisterEvent()
	print("=======wastelandProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_WASTELAND_REFRESH_RANK", handler(self, self.refreshMyRank))
end
function wastelandProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function wastelandProxy:refreshMyRank(target, event)
	local myInfo = event.rspdata.myInfo
	if myInfo then
		self.view:refreshMyRank(myInfo.rank)
	end
end
function wastelandProxy:getShowRankRed(...)
	local dailyRemindManager = include("dailyRemindManager")
	local ctype = dailyRemindManager.REMIND_TYPE.wastelandRank
	return dailyRemindManager.checkNeedRemindOnce(ctype, self.activityID)
end
function wastelandProxy:cleanRankRed(...)
	local dailyRemindManager = include("dailyRemindManager")
	local ctype = dailyRemindManager.REMIND_TYPE.wastelandRank
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local openCount = activityShowCtrl:getOpenCount(self.activityID)
	dailyRemindManager.addRemindToManager(ctype, openCount)
end
return wastelandProxy

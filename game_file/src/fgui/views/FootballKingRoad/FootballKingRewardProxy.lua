local baseProxy = require("fgui.base.baseProxy")
local FootballKingRewardProxy = class("FootballKingRewardProxy", baseProxy)
function FootballKingRewardProxy:onRegisterEvent()
	print("=======FootballKingRewardProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function FootballKingRewardProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.FOOTBALL_KING_ACTIVITY) then
		self.view:close()
	end
end
return FootballKingRewardProxy

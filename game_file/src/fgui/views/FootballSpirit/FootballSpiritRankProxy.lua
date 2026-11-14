local baseProxy = require("fgui.base.baseProxy")
local FootballSpiritRankProxy = class("FootballSpiritRankProxy", baseProxy)
function FootballSpiritRankProxy:onRegisterEvent()
	print("=======FootballSpiritRankProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_FOOTBALL_ELF_RANK", handler(self, self.rankDataBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function FootballSpiritRankProxy:rankDataBack(target, data)
	self.view:rankDataBack(target, data)
end
function FootballSpiritRankProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.FOOTBALL_ELF_ACTIVITY) then
		self.view:close()
	end
end
return FootballSpiritRankProxy

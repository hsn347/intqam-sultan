local baseProxy = require("fgui.base.baseProxy")
local FootballToFbProxy = class("FootballToFbProxy", baseProxy)
function FootballToFbProxy:onRegisterEvent()
	print("=======FootballToFbProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_PITCHAGAINST_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function FootballToFbProxy:updateView(target, data)
	self.view:updateView(target, data)
end
function FootballToFbProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.PITCH_AGAINST_HEAD_ACTIVITY) then
		self.view:close()
	end
end
return FootballToFbProxy

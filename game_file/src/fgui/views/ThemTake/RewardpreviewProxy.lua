local baseProxy = require("fgui.base.baseProxy")
local RewardpreviewProxy = class("RewardpreviewProxy", baseProxy)
function RewardpreviewProxy:onRegisterEvent()
	print("=======RewardpreviewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function RewardpreviewProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.LOUDLY_DRESSED_ACTIVITY) then
		self.view:close()
	end
end
return RewardpreviewProxy

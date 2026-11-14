local baseProxy = require("fgui.base.baseProxy")
local SuchafeastProxy = class("SuchafeastProxy", baseProxy)
function SuchafeastProxy:onRegisterEvent()
	print("=======SuchafeastProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SIGNREWARD_2022_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function SuchafeastProxy:updateView()
	self.view:initData()
end
function SuchafeastProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.SIGN_REWARD_2022_ACTIVITY) then
		self.view:close()
	end
end
return SuchafeastProxy

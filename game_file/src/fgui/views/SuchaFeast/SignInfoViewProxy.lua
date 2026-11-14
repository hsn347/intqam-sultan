local baseProxy = require("fgui.base.baseProxy")
local SignInfoViewProxy = class("SignInfoViewProxy", baseProxy)
function SignInfoViewProxy:onRegisterEvent()
	print("=======SignInfoViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SIGNREWARD_2022_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function SignInfoViewProxy:updateView()
	self.view:initData()
end
function SignInfoViewProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.SIGN_REWARD_2022_ACTIVITY) then
		self.view:close()
	end
end
return SignInfoViewProxy

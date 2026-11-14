local baseProxy = require("fgui.base.baseProxy")
local AlmirajChangemainProxy = class("AlmirajChangemainProxy", baseProxy)
function AlmirajChangemainProxy:onRegisterEvent()
	print("=======AlmirajChangemainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MIRAJCHALLENGE_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_MIRAJCHALLENGE_BOXREWARD_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function AlmirajChangemainProxy:updateView()
	self.view:initData()
end
function AlmirajChangemainProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.MIRAJ_CHALLENGE_ACTIVITY) then
		self.view:close()
	end
end
return AlmirajChangemainProxy

local baseProxy = require("fgui.base.baseProxy")
local AlmirajTreasureProxy = class("AlmirajTreasureProxy", baseProxy)
function AlmirajTreasureProxy:onRegisterEvent()
	print("=======AlmirajTreasureProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MIRAJCHALLENGE_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_MIRAJCHALLENGE_BOXREWARD_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function AlmirajTreasureProxy:updateView()
	self.view:initData()
end
function AlmirajTreasureProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.MIRAJ_CHALLENGE_ACTIVITY) then
		self.view:close()
	end
end
return AlmirajTreasureProxy

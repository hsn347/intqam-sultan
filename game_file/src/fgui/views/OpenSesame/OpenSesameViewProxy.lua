local baseProxy = require("fgui.base.baseProxy")
local OpenSesameViewProxy = class("OpenSesameViewProxy", baseProxy)
function OpenSesameViewProxy:onRegisterEvent()
	SoraDAddMessage(self, "MESSAGE_UPDATE_LOTTERY_9001546", handler(self, self.onUpdateView))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.onUpdateView))
	SoraDAddMessage(self, "MESSAGE_UPDATE_LOTTERY_9001546_REWARD", handler(self, self.onGetReward))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function OpenSesameViewProxy:onUpdateView()
	self.view:updateView()
end
function OpenSesameViewProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.LOTTERY_ACTIVITY_9001546) then
		self.view:close()
	end
end
function OpenSesameViewProxy:onGetReward(target, data)
	self.view:onGetReward(data.rewards)
end
return OpenSesameViewProxy

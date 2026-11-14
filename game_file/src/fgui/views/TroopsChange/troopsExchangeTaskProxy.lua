local baseProxy = require("fgui.base.baseProxy")
local troopsExchangeTaskProxy = class("troopsExchangeTaskProxy", baseProxy)
function troopsExchangeTaskProxy:onRegisterEvent()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD", handler(self, self.onUpdateTask))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_UPDATE_TASK", handler(self, self.onUpdateTask))
	SoraDAddMessage(self, "MESSAGE_TROOPS_EXCHANGE_REFRESH", handler(self, self.onUpdateTask))
end
function troopsExchangeTaskProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.BATTLEFIELD_TRAINING) then
		self.view:close()
	end
end
function troopsExchangeTaskProxy:onUpdateTask(target, data)
	if data.activityID == gActivityTimeActivityID.BATTLEFIELD_TRAINING then
		SoraDCloseLoading()
		self.view:updatTaskScroll()
		self.view:updateRedPoint()
	end
end
return troopsExchangeTaskProxy

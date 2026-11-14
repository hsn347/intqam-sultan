local baseProxy = require("fgui.base.baseProxy")
local Activity_9001734_MainProxy = class("Activity_9001734_MainProxy", baseProxy)
function Activity_9001734_MainProxy:onRegisterEvent()
	print("=======Activity_9001734_MainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001734_UPDATE", handler(self, self.initView))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001734_PASS", handler(self, self.updatePass))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001734_LIST", handler(self, self.updateList))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001734_ACHI", handler(self, self.updateRedDots))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updateItemNum))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001734_TIMEOUT", handler(self, self.initByTimeOut))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001734_RECORD", handler(self, self.updateRedDots))
	self:registerActivityCloseEvent(self.view.activityID)
end
function Activity_9001734_MainProxy:initView(target, data)
	self.view:initView(target, data)
end
function Activity_9001734_MainProxy:updatePass()
	self.view:updatePass()
end
function Activity_9001734_MainProxy:updateList(target, data)
	self.view:updatePredictList(data.matchData)
end
function Activity_9001734_MainProxy:updateItemNum()
	self.view:updateItemNum()
end
function Activity_9001734_MainProxy:updateRedDots()
	self.view:refreshRedDots()
end
function Activity_9001734_MainProxy:initByTimeOut(target, data)
	SoraDShowMsgTip(i18n("football_betting_text_09"))
	self.view:initView(target, data)
end
return Activity_9001734_MainProxy

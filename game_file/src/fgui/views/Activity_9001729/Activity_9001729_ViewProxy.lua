local baseProxy = require("fgui.base.baseProxy")
local Activity_9001729_ViewProxy = class("Activity_9001729_ViewProxy", baseProxy)
function Activity_9001729_ViewProxy:onRegisterEvent()
	print("=======Activity_9001729_ViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001729_THROW_DICE", handler(self, self.onThrowDice))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001729_STAGE_REWARD", handler(self, self.onStageReward))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001729_BATTLEPASS_UPDATE", handler(self, self.onBattlePassUpdate))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH", handler(self, self.onRedDotRefresh))
	SoraDAddMessage(self, "MESSAGE_RECHARGE_EXCHANGE_REFRESH", handler(self, self.onExchangeRefresh))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_REFRESH", handler(self, self.onExchangeRefresh))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.onItemCountChange))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001729_PACKAGE_UPDATE", handler(self, self.onBattlePassUpdate))
end
function Activity_9001729_ViewProxy:onThrowDice(target, data)
	self.view:onThrowDice(data.data)
end
function Activity_9001729_ViewProxy:onStageReward(target, data)
	self.view:onStageReward(data.data)
end
function Activity_9001729_ViewProxy:onBattlePassUpdate(target, data)
	self.view.fields.battlePass:initData(self.view.activityID)
end
function Activity_9001729_ViewProxy:onRedDotRefresh(target, data)
	if data.eventID == self.view.activityID then
		self.view:updateReddot()
	end
end
function Activity_9001729_ViewProxy:onExchangeRefresh(target, data)
	self.view.fields.battlePass:initData(self.view.activityID)
end
function Activity_9001729_ViewProxy:onItemCountChange(target, data)
	self.view.fields.dice1x:initDice()
end
return Activity_9001729_ViewProxy

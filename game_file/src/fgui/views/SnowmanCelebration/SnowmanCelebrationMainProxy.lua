local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseProxy = require("fgui.base.baseProxy")
local SnowmanCelebrationMainProxy = class("SnowmanCelebrationMainProxy", baseProxy)
function SnowmanCelebrationMainProxy:onRegisterEvent()
	print("=======SnowmanCelebrationMainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_SNOWMAN_CELEBRATION_REFRESH", handler(self, self.refreshView))
	SoraDAddMessage(self, "MESSAGE_SNOWMAN_CELEBRATION_DONATE", handler(self, self.refreshView))
	SoraDAddMessage(self, "MESSAGE_SNOWMAN_CELEBRATION_BOX_REWARD", handler(self, self.refreshView))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_BE_KICKED", handler(self, self.kickOutOfAlliance))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_UPDATE_BASE", handler(self, self.updateBuyBtn))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updateDonateBtn))
	SoraDAddMessage(self, "MESSAGE_SNOWMAN_CELEBRATION_ALLIANCE_RANK", handler(self, self.setButtonRewardShow))
	SoraDAddMessage(self, "MESSAGE_SNOWMAN_CELEBRATION_WATER_DELAY", handler(self, self.waterEffectOn))
end
function SnowmanCelebrationMainProxy:waterEffectOn()
	if self.view then
		self.view:waterEffectOn()
	end
end
function SnowmanCelebrationMainProxy:setButtonRewardShow()
	if self.view then
		self.view:setButtonRewardShow()
	end
end
function SnowmanCelebrationMainProxy:refreshView(target, data)
	if self.view then
		dump(data, "SnowmanCelebrationMainProxy:refreshV")
		self.view:refreshView(data)
	end
end
function SnowmanCelebrationMainProxy:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.SNOWY_NIGHT_CARNIVAL_ACTIVITY) then
		print("Normal close fhjsdfhdjfhdjf")
		self.view:close()
	else
		self.view:initData()
		if activityShowCtrl:isActivityOpen(gActivityTimeActivityID.SURPRISED_DROP_ACTIVITY_1) then
			print("except hideItemTime")
			self.view:hideItemTime()
		else
			print("except, setGetItemTime")
			self.view:setGetItemTime()
		end
	end
end
function SnowmanCelebrationMainProxy:kickOutOfAlliance(target, data)
	if self.view then
		self.view:close()
	end
end
function SnowmanCelebrationMainProxy:updateDonateBtn()
	if self.view then
		self.view:updateDonateBtn()
	end
end
function SnowmanCelebrationMainProxy:updateBuyBtn()
	if self.view then
		self.view:updateBuyBtn()
	end
end
function SnowmanCelebrationMainProxy:updateExchangeButton()
	if self.view then
		self.view:updateExchangeButton()
	end
end
return SnowmanCelebrationMainProxy

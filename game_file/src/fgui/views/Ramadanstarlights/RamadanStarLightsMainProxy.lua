local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseProxy = require("fgui.base.baseProxy")
local RamadanStarLightsMainProxy = class("RamadanStarLightsMainProxy", baseProxy)
function RamadanStarLightsMainProxy:onRegisterEvent()
	print("=======RamadanStarLightsMainProxy:onRegisterEvent")
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
function RamadanStarLightsMainProxy:waterEffectOn()
	if self.view then
		self.view:waterEffectOn()
	end
end
function RamadanStarLightsMainProxy:setButtonRewardShow()
	if self.view then
		self.view:setButtonRewardShow()
	end
end
function RamadanStarLightsMainProxy:refreshView(target, data)
	if self.view then
		dump(data, "RamadanStarLightsMainProxy:refreshV")
		self.view:refreshView(data)
	end
end
function RamadanStarLightsMainProxy:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.RAMADAN_STARLIGHT_ACTIVITY) then
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
function RamadanStarLightsMainProxy:kickOutOfAlliance(target, data)
	if self.view then
		self.view:close()
	end
end
function RamadanStarLightsMainProxy:updateDonateBtn()
	if self.view then
		self.view:updateDonateBtn()
	end
end
function RamadanStarLightsMainProxy:updateBuyBtn()
	if self.view then
		self.view:updateBuyBtn()
	end
end
function RamadanStarLightsMainProxy:updateExchangeButton()
	if self.view then
		self.view:updateExchangeButton()
	end
end
return RamadanStarLightsMainProxy

local baseProxy = require("fgui.base.baseProxy")
local magicLampSkillLotteryCtrl = SoraDGetCtrl("magicLampSkillLotteryCtrl")
local MagicLampMaigcPowerMainProxy = class("MagicLampMaigcPowerMainProxy", baseProxy)
function MagicLampMaigcPowerMainProxy:onRegisterEvent()
	print("=======MagicLampMaigcPowerMainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ITEM_CHANGE_TYPE", handler(self, self.onRefreshItem))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_NEWDAY", handler(self, self.onNewDay))
	SoraDAddMessage(self, "MESSAGE_MAGICLAMP_SKILL_LOTTERY_UPDATE", handler(self, self.onUpdateView))
	SoraDAddMessage(self, "MESSAGE_MAGICLAMP_SKILL_LOTTERY_POOL_UPDATE", handler(self, self.onUpdatePoolList))
	SoraDAddMessage(self, "MESSAGE_MAGICLAMP_SKILL_LOTTERY_REWARD", handler(self, self.onReward))
end
function MagicLampMaigcPowerMainProxy:onNewDay()
	magicLampSkillLotteryCtrl:sendInitMsg()
end
function MagicLampMaigcPowerMainProxy:onUpdateView()
	self.view:updateView()
end
function MagicLampMaigcPowerMainProxy:onRefreshItem()
	self.view:refreshItem()
end
function MagicLampMaigcPowerMainProxy:onUpdatePoolList()
	self.view:updatePoolList()
	self.view:updateDailyReward()
end
function MagicLampMaigcPowerMainProxy:onReward(target, data)
	dump(data, "MagicLampMaigcPowerMainProxy:onReward")
	uiManager:show("MagicLampMaigcPowerGain", data.data)
end
return MagicLampMaigcPowerMainProxy

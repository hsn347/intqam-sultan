local baseProxy = require("fgui.base.baseProxy")
local NebulaEmperorDonateProxy = class("NebulaEmperorDonateProxy", baseProxy)
function NebulaEmperorDonateProxy:onRegisterEvent()
	print("=======NebulaEmperorDonateProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_EMPEROR_DONATE_GOLD", handler(self, self.onMsgDonateGoldBack))
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_DONATE_GOLD", handler(self, self.onMsgDonateGoldBack))
	SoraDAddMessage(self, "MESSAGE_NEBULA_EMPEROR_DONATE_REWARD", handler(self, self.onMsgDonateRewardBack))
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_DONATE_REWARD", handler(self, self.onMsgDonateRewardBack))
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_REGION_DONATE_GOLD", handler(self, self.onMsgUpdateRegionDonateGold))
end
function NebulaEmperorDonateProxy:onMsgDonateGoldBack(...)
	SoraDCloseLoading(self.view:displayObject())
	self.view:updateDonateGold()
end
function NebulaEmperorDonateProxy:onMsgDonateRewardBack(...)
	self.view:updateDonateReward()
end
function NebulaEmperorDonateProxy:onMsgUpdateRegionDonateGold(...)
	SoraDCloseLoading(self.view:displayObject())
	self.view:updateRegionDonateGold()
end
return NebulaEmperorDonateProxy

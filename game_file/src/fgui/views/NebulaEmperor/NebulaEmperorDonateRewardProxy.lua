local baseProxy = require("fgui.base.baseProxy")
local NebulaEmperorDonateRewardProxy = class("NebulaEmperorDonateRewardProxy", baseProxy)
function NebulaEmperorDonateRewardProxy:onRegisterEvent()
	print("=======NebulaEmperorDonateRewardProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_EMPEROR_DONATE_REWARD", handler(self, self.onMsgDonateRewardBack))
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_DONATE_REWARD", handler(self, self.onMsgDonateRewardBack))
end
function NebulaEmperorDonateRewardProxy:onMsgDonateRewardBack(...)
	self.view:closePanel()
end
return NebulaEmperorDonateRewardProxy

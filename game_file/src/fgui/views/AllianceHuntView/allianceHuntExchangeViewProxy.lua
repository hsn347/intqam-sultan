local baseProxy = require("fgui.base.baseProxy")
local allianceHuntExchangeViewProxy = class("allianceHuntExchangeViewProxy", baseProxy)
function allianceHuntExchangeViewProxy:onRegisterEvent()
	print("=======allianceHuntExchangeViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_HUNT_BUY_SUCCESS", handler(self, self.sMsgBuySuccess))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_HUNT_BUY_FAILED", handler(self, self.sMsgBuyFailed))
end
function allianceHuntExchangeViewProxy:sMsgBuySuccess(...)
	self.view:sMsgBuySuccess(...)
end
function allianceHuntExchangeViewProxy:sMsgBuyFailed(...)
	self.view:sMsgBuyFailed(...)
end
return allianceHuntExchangeViewProxy

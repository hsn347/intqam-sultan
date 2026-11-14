local baseProxy = require("fgui.base.baseProxy")
local allianceUnlockMessagesViewProxy = class("allianceUnlockMessagesViewProxy", baseProxy)
function allianceUnlockMessagesViewProxy:onRegisterEvent()
	print("=======allianceUnlockMessagesViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_GET_SHIELD_LIST_SUCCESS", handler(self, self.updateScrollWithData))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_UNLOCK_SHIELD_SUCCESS", handler(self, self.updateScrollWithData))
end
function allianceUnlockMessagesViewProxy:updateScrollWithData()
	self.view:updateScrollWithData()
end
return allianceUnlockMessagesViewProxy

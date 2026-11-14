local baseProxy = require("fgui.base.baseProxy")
local ShelterApplyProxy = class("ShelterApplyProxy", baseProxy)
function ShelterApplyProxy:onRegisterEvent()
	print("=======ShelterApplyProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_WATCHTOWER_SHELTER_INVIEMAP", handler(self, self.updateUI))
end
function ShelterApplyProxy:updateUI(target, data)
	self.view:updateUI(target, data)
end
return ShelterApplyProxy

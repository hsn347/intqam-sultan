local baseProxy = require("fgui.base.baseProxy")
local ShelterViewProxy = class("ShelterViewProxy", baseProxy)
function ShelterViewProxy:onRegisterEvent()
	print("=======ShelterViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_WATCHTOWER_SHELTER", handler(self, self.updateUI))
end
function ShelterViewProxy:updateUI(target, data)
	self.view:updateUI(target, data)
end
return ShelterViewProxy

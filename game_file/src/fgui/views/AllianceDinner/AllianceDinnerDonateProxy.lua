local baseProxy = require("fgui.base.baseProxy")
local AllianceDinnerDonateProxy = class("AllianceDinnerDonateProxy", baseProxy)
function AllianceDinnerDonateProxy:onRegisterEvent()
	print("=======AllianceDinnerDonateProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_DINNER_UPDATE", handler(self, self.updateView))
end
function AllianceDinnerDonateProxy:updateView()
	if self.view then
		self.view:updateView()
	end
end
return AllianceDinnerDonateProxy

local baseProxy = require("fgui.base.baseProxy")
local AllianceDinnerTaskProxy = class("AllianceDinnerTaskProxy", baseProxy)
function AllianceDinnerTaskProxy:onRegisterEvent()
	print("=======AllianceDinnerTaskProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_UPDATE_TASK", handler(self, self.initData))
end
function AllianceDinnerTaskProxy:initData()
	if self.view then
		self.view:initData()
	end
end
return AllianceDinnerTaskProxy

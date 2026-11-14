local baseProxy = require("fgui.base.baseProxy")
local NebulaWonderlandTaskProxy = class("NebulaWonderlandTaskProxy", baseProxy)
function NebulaWonderlandTaskProxy:onRegisterEvent()
	print("=======NebulaWonderlandTaskProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_UPDATE_TASK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_NEBULA_WONDERLAND_REFRESH", handler(self, self.initData))
end
function NebulaWonderlandTaskProxy:initData()
	if self.view then
		self.view:initData()
	end
end
return NebulaWonderlandTaskProxy

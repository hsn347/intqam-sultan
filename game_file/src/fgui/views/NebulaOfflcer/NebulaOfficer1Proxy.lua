local baseProxy = require("fgui.base.baseProxy")
local NebulaOfficer1Proxy = class("NebulaOfficer1Proxy", baseProxy)
function NebulaOfficer1Proxy:onRegisterEvent()
	print("=======NebulaOfficer1Proxy:onRegisterEvent")
	self:registerActivityCloseEvent(self.view.activityID)
	SoraDAddMessage(self, "MESSAGE_NEBULA_PRIVILEGE_REFRESH", handler(self, self.updateView))
end
function NebulaOfficer1Proxy:updateView()
	self.view:updateView()
end
return NebulaOfficer1Proxy

local baseProxy = require("fgui.base.baseProxy")
local allianceActiveViewProxy = class("allianceActiveViewProxy", baseProxy)
function allianceActiveViewProxy:onRegisterEvent()
	print("=======allianceActiveViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_ACTIVE_TASK_UPDATE", handler(self, self.updateTask))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_ACTIVE_OFFICE_UPDATE", handler(self, self.updateOffice))
end
function allianceActiveViewProxy:updateTask(target, data)
	self.view:updateTask(target, data)
end
function allianceActiveViewProxy:updateOffice(target, data)
	self.view:updateOffice(target, data)
end
return allianceActiveViewProxy

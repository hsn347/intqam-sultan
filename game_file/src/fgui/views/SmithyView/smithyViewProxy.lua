local baseProxy = require("fgui.base.baseProxy")
local smithyViewProxy = class("smithyViewProxy", baseProxy)
function smithyViewProxy:onRegisterEvent()
	print("=======smithyViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_RESOURCE_UPDATE", handler(self, self.updateSteel))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_FORGE_BACK", handler(self, self.showForge))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_FORGE_FINISH", handler(self, self.forgeFinish))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_OVERDUE_BACK", handler(self, self.checkOverdueStatus))
end
function smithyViewProxy:updateSteel(target, data)
	if data.reslist[tostring(gIDDef.STEEL)] then
		self.view:updateSteel()
	end
end
function smithyViewProxy:showForge()
	self.view:showForge()
end
function smithyViewProxy:forgeFinish()
	self.view:showForge()
end
function smithyViewProxy:checkOverdueStatus()
	self.view:checkOverdueStatus()
end
return smithyViewProxy

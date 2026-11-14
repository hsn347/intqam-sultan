local baseProxy = require("fgui.base.baseProxy")
local allianceCreateViewProxy = class("allianceCreateViewProxy", baseProxy)
function allianceCreateViewProxy:onRegisterEvent()
	print("=======allianceCreateViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_LORDINFO_UPDATE_BASE", handler(self, self.updateCreateBtn))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_CREATE_SUCCESS", handler(self, self.createSuccess))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_CREATE_ERR_BACK", handler(self, self.allianceInputErr))
end
function allianceCreateViewProxy:updateCreateBtn(target, data)
	self.view:updateCreateBtn(target, data)
end
function allianceCreateViewProxy:createSuccess(target, data)
	self.view:createSuccess(target, data)
end
function allianceCreateViewProxy:allianceInputErr(target, data)
	self.view:allianceInputErr(target, data)
end
return allianceCreateViewProxy

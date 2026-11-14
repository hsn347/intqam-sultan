local baseProxy = require("fgui.base.baseProxy")
local allianceRelationViewProxy = class("allianceRelationViewProxy", baseProxy)
function allianceRelationViewProxy:onRegisterEvent()
	print("=======allianceRelationViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_RELATION_GET_SUCCESS", handler(self, self.dataBack))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_RELATION_INVITES_GET_SUCCESS", handler(self, self.dataBack))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_RELATION_DATA_CHANGE", handler(self, self.dataBack))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_MEMBER_UPDATE", handler(self, self.dataBack))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_UI_RELATION_MENU_SELECT", handler(self, self.menuTagSelect))
end
function allianceRelationViewProxy:dataBack(target, data)
	self.view:dataBack(target, data)
end
function allianceRelationViewProxy:menuTagSelect(target, data)
	self.view:menuTagSelect(target, data)
end
return allianceRelationViewProxy

local baseProxy = require("fgui.base.baseProxy")
local allianceMemberListProxy = class("allianceMemberListProxy", baseProxy)
function allianceMemberListProxy:onRegisterEvent()
	print("=======allianceMemberListProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_GET_MEMBER_LIST_SUCCESS", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_MEMBER_UPDATE", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMUSR_CHANGED", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_OFFICIAL_APPLY_BACK", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_OFFICIAL_APPOINT_BACK", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_OFFICIAL_FIRE_BACK", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_UI_MEMBERLIST_OPEN", handler(self, self.switchMemberList))
end
function allianceMemberListProxy:updateData(target, data)
	self.view:updateData(target, data)
end
function allianceMemberListProxy:switchMemberList(target, data)
	self.view:switchMemberList(target, data)
end
return allianceMemberListProxy

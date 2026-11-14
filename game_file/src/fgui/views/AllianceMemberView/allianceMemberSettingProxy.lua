local baseProxy = require("fgui.base.baseProxy")
local allianceMemberSettingProxy = class("allianceMemberSettingProxy", baseProxy)
function allianceMemberSettingProxy:onRegisterEvent()
	print("=======allianceMemberSettingProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_MEMBER_UPDATE", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_OFFICIAL_FIRE_BACK", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_OFFICIAL_APPOINT_BACK", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_MEMBER_SETTING_CLOSE", handler(self, self.memberSettingClose))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMUSR_CHANGED", handler(self, self.kingdomusrChanged))
end
function allianceMemberSettingProxy:updateData(target, data)
	self.view:updateData(target, data)
end
function allianceMemberSettingProxy:memberSettingClose(target, data)
	self.view:memberSettingClose(target, data)
end
function allianceMemberSettingProxy:kingdomusrChanged(target, data)
	self.view:kingdomusrChanged(target, data)
end
return allianceMemberSettingProxy

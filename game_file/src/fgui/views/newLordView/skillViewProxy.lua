local baseProxy = require("fgui.base.baseProxy")
local skillViewProxy = class("skillViewProxy", baseProxy)
function skillViewProxy:onRegisterEvent()
	print("=======skillViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_LORDINFO_UPDATE_SKILL", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_UPGRADE_SKILL", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_RESET_SKILL", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_SKILL_SET_RENAME_BACK", handler(self, self.sMsgRenameSkillBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_SKILL_SET_ACTIVE_BACK", handler(self, self.sMsgSkillSetActiveBack))
end
function skillViewProxy:updateView(target, data)
	self.view:updateView(target, data)
end
function skillViewProxy:sMsgRenameSkillBack(target, data)
	self.view:sMsgRenameSkillBack(target, data)
end
function skillViewProxy:sMsgSkillSetActiveBack(target, data)
	self.view:sMsgSkillSetActiveBack(target, data)
end
return skillViewProxy

local baseProxy = require("fgui.base.baseProxy")
local militaryRankSkillViewProxy = class("militaryRankSkillViewProxy", baseProxy)
function militaryRankSkillViewProxy:onRegisterEvent()
	print("=======militaryRankSkillViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_LORDMILITARY_SKILL_STUDY", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_LORDMILITARY_TOOL_EXCHANGE", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_LORDMILITARY_UPDATE", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_ADD_SUCCESS", handler(self, self.equipBack))
end
function militaryRankSkillViewProxy:updateData(target, data)
	self.view:updateData(target, data)
end
function militaryRankSkillViewProxy:equipBack(target, data)
	self.view:equipBack(target, data)
end
return militaryRankSkillViewProxy

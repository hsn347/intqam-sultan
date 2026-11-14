local baseProxy = require("fgui.base.baseProxy")
local SoldierRushSkillChooseProxy = class("SoldierRushSkillChooseProxy", baseProxy)
function SoldierRushSkillChooseProxy:onRegisterEvent()
	print("=======SoldierRushSkillChooseProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SOLDIERRUSH_UI_SKILL_SLOT_INDEX", handler(self, self.updateSlotIndex))
	SoraDAddMessage(self, "MESSAGE_SOLDIERRUSH_UI_SKILL_CHOOSE", handler(self, self.updateSkill))
	SoraDAddMessage(self, "MESSAGE_SOLDIERRUSH_UI_SKILL_INFO", handler(self, self.showSkillInfo))
end
function SoldierRushSkillChooseProxy:updateSlotIndex(target, data)
	self.view:updateSlotIndex(target, data)
end
function SoldierRushSkillChooseProxy:updateSkill(target, data)
	self.view:updateSkill(target, data)
end
function SoldierRushSkillChooseProxy:showSkillInfo(target, data)
	self.view:showSkillInfo(target, data)
end
return SoldierRushSkillChooseProxy

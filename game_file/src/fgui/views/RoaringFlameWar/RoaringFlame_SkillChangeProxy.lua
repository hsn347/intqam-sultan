local baseProxy = require("fgui.base.baseProxy")
local RoaringFlame_SkillChangeProxy = class("RoaringFlame_SkillChangeProxy", baseProxy)
function RoaringFlame_SkillChangeProxy:onRegisterEvent()
	print("=======RoaringFlame_SkillChangeProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_SKILL_LOTTERY", handler(self, self.onMessageSkillLottery))
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_SKILL_REPLACE", handler(self, self.onMessageSkillReplace))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.onMessageBagChange))
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_SKILL_SELECT", handler(self, self.onMessageSkillSelect))
end
function RoaringFlame_SkillChangeProxy:onMessageSkillLottery(...)
	self.view:onMessageSkillLottery(...)
end
function RoaringFlame_SkillChangeProxy:onMessageSkillReplace(...)
	self.view:onMessageSkillReplace(...)
end
function RoaringFlame_SkillChangeProxy:onMessageBagChange(...)
	self.view:onMessageBagChange(...)
end
function RoaringFlame_SkillChangeProxy:onMessageSkillSelect(...)
	self.view:onMessageSkillSelect(...)
end
return RoaringFlame_SkillChangeProxy

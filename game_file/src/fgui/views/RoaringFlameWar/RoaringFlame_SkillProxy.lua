local baseProxy = require("fgui.base.baseProxy")
local RoaringFlame_SkillProxy = class("RoaringFlame_SkillProxy", baseProxy)
function RoaringFlame_SkillProxy:onRegisterEvent()
	print("=======RoaringFlame_SkillProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_SKILL_LOTTERY", handler(self, self.onMessageSkillLottery))
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_SKILL_REPLACE", handler(self, self.onMessageSkillReplace))
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_SKILL_SELECT", handler(self, self.onMessageSkillSelect))
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_BUYGIFT", handler(self, self.initData))
end
function RoaringFlame_SkillProxy:onMessageSkillLottery(...)
	self.view:onMessageSkillLottery(...)
end
function RoaringFlame_SkillProxy:onMessageSkillReplace(...)
	self.view:onMessageSkillReplace(...)
end
function RoaringFlame_SkillProxy:onMessageSkillSelect(...)
	self.view:onMessageSkillSelect(...)
end
function RoaringFlame_SkillProxy:initData(...)
	self.view:initData(...)
end
return RoaringFlame_SkillProxy

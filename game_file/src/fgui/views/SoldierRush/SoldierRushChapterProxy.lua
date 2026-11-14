local baseProxy = require("fgui.base.baseProxy")
local SoldierRushChapterProxy = class("SoldierRushChapterProxy", baseProxy)
function SoldierRushChapterProxy:onRegisterEvent()
	print("=======SoldierRushChapterProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SOLDIERRUSH_UI_CHAPTER_MODEL", handler(self, self.updateMapToGate))
	SoraDAddMessage(self, "MESSAGE_SOLDIERRUSH_UI_SKILL_SET", handler(self, self.updateSkillSlot))
	SoraDAddMessage(self, "MESSAGE_SOLDIERRUSH_CLAIMREWARD", handler(self, self.updateStarBox))
	SoraDAddMessage(self, "MESSAGE_SOLDIERRUSH_UI_GUIDE_NEXT", handler(self, self.guideNext))
	SoraDAddMessage(self, "MESSAGE_SOLDIERRUSH_AFK_UPDATE", handler(self, self.updateHook))
end
function SoldierRushChapterProxy:updateMapToGate(target, data)
	self.view:updateMapToGate(target, data)
end
function SoldierRushChapterProxy:updateSkillSlot(target, data)
	self.view:updateSkillSlot(target, data)
end
function SoldierRushChapterProxy:updateStarBox(target, data)
	self.view:updateStarBox(target, data)
end
function SoldierRushChapterProxy:guideNext(target, data)
	self.view:guideNext(target, data)
end
function SoldierRushChapterProxy:updateHook(target, data)
	self.view:updateHook(target, data)
end
return SoldierRushChapterProxy

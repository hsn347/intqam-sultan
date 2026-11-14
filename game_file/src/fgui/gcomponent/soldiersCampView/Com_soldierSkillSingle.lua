local armyDesRead = include("armyDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_soldierSkillSingle = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://soldiersCampView/Com_soldierSkillSingle", Com_soldierSkillSingle)
function Com_soldierSkillSingle:onInit()
	self:addClickListener(handler(self, self.onClick))
end
function Com_soldierSkillSingle:onShow()
end
function Com_soldierSkillSingle:initData(skillID)
	self.skillID = skillID
	self.fields.icon:setSpriteFrame(armyDesRead.getSkillIcon(self.skillID))
	armyDesRead = armyDesRead.getSkillIcon(self.skillID)
	armyDesRead.getSkillIcon(self.skillID).lv = armyDesRead.getSkillLv(self.skillID)
	self.fields.title:setString(i18n("common_text_100", armyDesRead.getSkillIcon(self.skillID)))
end
function Com_soldierSkillSingle:onClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).skillID = self.skillID
	uiManager:show("soldiersSkillInfoView", nil)
end
return Com_soldierSkillSingle

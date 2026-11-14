local armyDesRead = include("armyDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_soldierSkill = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://soldiersCampView/Com_soldierSkill", Com_soldierSkill)
function Com_soldierSkill:onInit()
	self:fixChildrenPos()
end
function Com_soldierSkill:onShow()
end
function Com_soldierSkill:initData(skillID)
	self.fields.skill:initData(skillID)
	self.fields.Text_skillName:setString(armyDesRead.getSkillName(skillID))
	self.fields.Text_skillDes:setString(armyDesRead.getSkillDes(skillID))
end
return Com_soldierSkill

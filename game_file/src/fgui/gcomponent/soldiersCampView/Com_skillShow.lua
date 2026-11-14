local armyDesRead = include("armyDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_skillShow = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://soldiersCampView/Com_skillShow", Com_skillShow)
function Com_skillShow:onInit()
end
function Com_skillShow:onShow()
end
function Com_skillShow:initData(skillID)
	self.fields.skill:initData(skillID)
	self.fields.Text_name:setString(armyDesRead.getSkillName(skillID))
end
return Com_skillShow

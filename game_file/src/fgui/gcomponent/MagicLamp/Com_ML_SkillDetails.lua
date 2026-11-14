local baseComponent = require("fgui.base.baseComponent")
local magicLampSkillRead = include("magicLampSkillRead")
local Com_ML_SkillDetails = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MagicLamp/Com_ML_SkillDetails", Com_ML_SkillDetails)
function Com_ML_SkillDetails:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(false, true)
	end
end
function Com_ML_SkillDetails:onShow()
end
function Com_ML_SkillDetails:initData(skillData)
	self.fields.Com_skillDetail:setVisible(skillData ~= nil)
	self.fields.Text_name:setColor(skillData ~= nil and cc.c3b(240, 214, 156) or cc.c3b(153, 153, 153))
	self.fields.Hole:initData(skillData)
	if not skillData then
		self.fields.Text_name:setString(i18n("magic_lamp_title_12"))
		return
	end
	self.fields.Text_name:setString(magicLampSkillRead.getSkillName(skillData.skillType))
	self.fields.Com_skillDetail:initData(skillData)
	self.fields.Hole:initData(skillData)
end
return Com_ML_SkillDetails

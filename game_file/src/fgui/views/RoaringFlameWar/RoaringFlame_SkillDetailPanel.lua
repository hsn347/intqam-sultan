local roaringFlameWarRead = include("roaringFlameWarRead")
local qualityConfig = gAtlantisQualityConfig
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlame_SkillDetailPanel = class("RoaringFlame_SkillDetailPanel", baseFguiPanel)
function RoaringFlame_SkillDetailPanel:ctor(...)
	RoaringFlame_SkillDetailPanel.super.ctor(self, ...)
	print("RoaringFlame_SkillDetailPanel:ctor", self.viewName)
end
function RoaringFlame_SkillDetailPanel:onInit()
	print("=======RoaringFlame_SkillDetailPanel:onInit")
	self.fields.Text_name1:setString(i18n("atlantiswar_skill_text_055"))
	self.fields.Text_type1:setString(i18n("atlantiswar_skill_text_027"))
	self.fields.Text_quality1:setString(i18n("atlantiswar_skill_text_054"))
	if not SoraDFIsRA() then
		self.view:fixChildrenPos()
	end
end
function RoaringFlame_SkillDetailPanel:onShow()
	print("=======RoaringFlame_SkillDetailPanel:onShow")
	local skillId = self.param and self.param.skillId
	self:initData(skillId)
end
function RoaringFlame_SkillDetailPanel:initData(skillId)
	local config = roaringFlameWarRead.getSkillDisplayConfig(skillId)
	local qConfig = qualityConfig[config.quality]
	local tConfig = qualityConfig[config.sort]
	self.fields.Image_skill:setURL(config.img)
	self.fields.Text_name2:setString(i18n(config.name))
	self.fields.Text_type2:setString(i18n(tConfig.tName))
	self.fields.Text_quality2:setColor(qConfig.color)
	self.fields.Text_quality2:setString(i18n(qConfig.qName))
	self.fields.Image_quality:setURL(qConfig.qImage)
	self.fields.Text_des:setString(i18n(config.describe))
end
return RoaringFlame_SkillDetailPanel

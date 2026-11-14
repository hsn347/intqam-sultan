local ASD = require_data("atlantiswar_skill_display").data
local qualityConfig = gAtlantisQualityConfig
local atlantisSkillDetail = class("atlantisSkillDetail", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("atlantisSkillDetail")
	end
	return target
end)
function atlantisSkillDetail:ctor()
	self:initWidget()
end
function atlantisSkillDetail:onMessageListener()
end
function atlantisSkillDetail:initWidget()
	_UPVALUE2_ = nil
	;(nil)[1] = "Center_Node"
	;(nil)[2] = "Node_info"
	self.Node_info = SoraDGetChildByFullPath(self._ccsView, nil)
	SoraDGetAllChildFromWidget(self.Node_info, self)
	self.Text_name1:setString(i18n("atlantiswar_skill_text_055"))
	self.Text_type1:setString(i18n("atlantiswar_skill_text_027"))
	self.Text_quality1:setString(i18n("atlantiswar_skill_text_054"))
end
function atlantisSkillDetail:initData(skillID)
	local config = ASD[skillID]
	local qConfig = qualityConfig[config.quality]
	local tConfig = qualityConfig[config.sort]
	SoraChangeSpriteImage(self.Image_skill, config.img)
	self.Text_name2:setString(i18n(config.name))
	self.Text_type2:setString(i18n(tConfig.tName))
	self.Text_quality2:setColor(qConfig.color)
	self.Text_quality2:setString(i18n(qConfig.qName))
	SoraChangeSpriteImage(self.Image_quality, qConfig.qImage)
	self.Text_des:setString(i18n(config.describe))
end
return atlantisSkillDetail

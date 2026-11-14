local commonUseSkill = class("commonUseSkill", function(target)
	return SoraDCreateTouchPanel("commonUseSkill")
end)
_ENV = "commonUseSkill"
_ENV = nil
;(nil).imgBg = "bg_userskill_1102801.png"
;(nil).detail = i18n("lordskill_des_11028")
;("commonUseSkill")[lordSkillIDDefine.rescue], (nil).name = nil, "lordskill_name_11028"
_ENV = nil
;(nil).imgBg = "bg_userskill_1202101.png"
;(nil).detail = i18n("lordskill_des_12023")
;("commonUseSkill")[lordSkillIDDefine.collectprotect], (nil).name = nil, "lordskill_name_12023"
_ENV = nil
;(nil).imgBg = "bg_userskill_1300801.png"
;(nil).detail = i18n("lordskill_des_13022")
;("commonUseSkill")[lordSkillIDDefine.fastmarch], (nil).name = nil, "lordskill_name_13022"
local skillConfig = "commonUseSkill"
function commonUseSkill:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.bg_skill = SoraDGetChildByName(self, "bg_userskill")
	self.text_detail = SoraDGetChildByName(self, "Text_detail")
end
function commonUseSkill:initData(skillID)
	if skillConfig[skillID] and next(skillConfig[skillID]) then
		self.ccs_bg:setTitleName(i18n(skillConfig[skillID].name))
		self.bg_skill:loadTexture(skillConfig[skillID].imgBg, ccui.TextureResType.plistType)
		self.text_detail:setString(skillConfig[skillID].detail)
	end
end
return commonUseSkill

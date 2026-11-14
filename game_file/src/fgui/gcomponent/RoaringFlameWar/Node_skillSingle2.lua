local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local roaringFlameWarRead = include("roaringFlameWarRead")
local atlantisActivityCtrl = SoraDGetCtrl("atlantisActivityCtrl")
local atlantisActivityRead = include("atlantisActivityRead")
local baseComponent = require("fgui.base.baseComponent")
local Node_skillSingle2 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RoaringFlameWar/Node_skillSingle2", Node_skillSingle2)
function Node_skillSingle2:onInit()
	self.fields.Button_select:setString(i18n("treasure_crystal_btn_02"))
	self.fields.Button_select:addClickListener(handler(self, self.onClickBtnSelect))
end
function Node_skillSingle2:onShow()
end
function Node_skillSingle2:onClickBtnSelect(context)
	SoraDPlaySound()
	if self.hasSkill then
		SoraDShowMsgTip(i18n("flames_dunes_text367"))
		return
	end
	local curSkillId = self:getSkillSlotSkillId(self.skillIdx)
	if not curSkillId then
		return
	end
	local skill1Name = self:getSkillNameWithColor(self.data.skillID)
	local skill2Name = self:getSkillNameWithColor(curSkillId)
	_ENV = i18n("flames_dunes_text367")
	i18n("flames_dunes_text367").skill1 = skill1Name
	i18n("flames_dunes_text367").skill2 = skill2Name
	local content = i18n("flames_dunes_text366", i18n("flames_dunes_text367"))
	_ENV = i18n("flames_dunes_text367")
	i18n("flames_dunes_text367").content = content
	i18n("flames_dunes_text367").cancel = true
	i18n("flames_dunes_text367").confirmFunc = function()
		SoraDShowLoading()
		self:reqSelectSkill(self.skillIdx, self.data.skillID)
		uiManager:close("RoaringFlame_SkillSelect")
	end
	uiManager:show("MessageBox", i18n("flames_dunes_text367"))
end
function Node_skillSingle2:initData(data, skillIdx, warType)
	self.data = data
	self.skillIdx = skillIdx
	self.warType = warType
	self.fields.Node_skillSingle:initData(self.data, self.warType)
	local isEnough = self:isUsedSkillTimesEnough()
	self.fields.Button_select:setEnabled(isEnough)
	if isEnough then
		local skillId = self.data.skillID
		self.hasSkill = self:checkSkillSlotAndCandidateSkill(skillId)
		self.fields.Button_select:setGrayed(self.hasSkill)
	else
		self.hasSkill = false
	end
end
function Node_skillSingle2:isUsedSkillTimesEnough(...)
	if self.warType == gKingdomClassType.atlantis then
		return atlantisActivityCtrl:isUsedSkillTimesEnough(...)
	else
		return roaringFlameWarCtrl:isUsedSkillTimesEnough(...)
	end
end
function Node_skillSingle2:checkSkillSlotAndCandidateSkill(...)
	if self.warType == gKingdomClassType.atlantis then
		return atlantisActivityCtrl:checkSkillSlotAndCandidateSkill(...)
	else
		return roaringFlameWarCtrl:checkSkillSlotAndCandidateSkill(...)
	end
end
function Node_skillSingle2:getSkillSlotSkillId(...)
	if self.warType == gKingdomClassType.atlantis then
		return atlantisActivityCtrl:getSkillSlotSkillId(...)
	else
		return roaringFlameWarCtrl:getSkillSlotSkillId(...)
	end
end
function Node_skillSingle2:getSkillNameWithColor(...)
	if self.warType == gKingdomClassType.atlantis then
		return atlantisActivityRead.getSkillNameWithColor(...)
	else
		return roaringFlameWarRead.getSkillNameWithColor(...)
	end
end
function Node_skillSingle2:reqSelectSkill(...)
	if self.warType == gKingdomClassType.atlantis then
		return atlantisActivityCtrl:reqSelectSkill(...)
	else
		return roaringFlameWarCtrl:reqSelectSkill(...)
	end
end
return Node_skillSingle2

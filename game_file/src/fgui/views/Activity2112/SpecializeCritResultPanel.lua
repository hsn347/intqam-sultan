local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SpecializeCritResultPanel = class("SpecializeCritResultPanel", baseFguiPanel)
function SpecializeCritResultPanel:ctor(...)
	self.super.ctor(self, ...)
	print("SpecializeCritResultPanel:ctor", self.viewName)
end
function SpecializeCritResultPanel:getPackageList()
	if not self._packageList then
		_UPVALUE2_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "Activity2112"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
	end
	return self._packageList
end
function SpecializeCritResultPanel:onInit()
	print("=======SpecializeCritResultPanel:onInit")
	self.fields.Text_title:setString(i18n("awakeSkillCrit_text_02"))
	local totalAddExp = self.param.critInfo.totalAddExp
	local costID = self.param.itemID
	local costCount = self.param.critInfo.realCost
	local singEXP = heroltCtrl:getAdvancedSkillFeedEXP(costID)
	local critAdd = singEXP * costCount
	_ENV = i18n("awakeSkillCrit_text_02")
	i18n("awakeSkillCrit_text_02").num = string.formatnumberthousands(totalAddExp)
	self.fields.Text_totalAdd:setString(i18n("awakeSkillCrit_text_03", i18n("awakeSkillCrit_text_02")))
	_ENV = i18n("awakeSkillCrit_text_03", i18n("awakeSkillCrit_text_02"))
	i18n("awakeSkillCrit_text_03", i18n("awakeSkillCrit_text_02")).num = string.formatnumberthousands(totalAddExp - critAdd)
	self.fields.Text_critAdd:setString(i18n("awakeSkillCrit_text_04", i18n("awakeSkillCrit_text_03", i18n("awakeSkillCrit_text_02"))))
end
function SpecializeCritResultPanel:onShow()
	print("=======SpecializeCritResultPanel:onShow")
end
function SpecializeCritResultPanel:onCritItemRenderer(index, obj)
	local key = self.critInfoKeys[index + 1]
	local value = self.critInfo[key]
	obj:getChild("Text_mul"):setString("x" .. tonumber(key))
	obj:getChild("Text_count"):setString(value)
end
return SpecializeCritResultPanel

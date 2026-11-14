local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local lordSkillModuleAPI = include("lordSkillModuleAPI")
local lordSkillDesRead = include("lordSkillDesRead")
_ENV = "lordSkillDesRead"
;("lordSkillDesRead")[12032] = "SKILL_CITY_WOOD_COLLECT_DAY_MAX"
;("lordSkillDesRead")[12034] = "SKILL_CITY_FOOD_COLLECT_DAY_MAX"
;("lordSkillDesRead")[12036] = "SKILL_CITY_IRON_COLLECT_DAY_MAX"
;("lordSkillDesRead")[12038] = "SKILL_CITY_MITHRIL_COLLECT_DAY_MAX"
;("lordSkillDesRead")[12040] = "SKILL_CITY_CRYSTAL_COLLECT_DAY_MAX"
;("lordSkillDesRead")[12033] = "SKILL_WOOD_COLLECT_DAY_MAX"
;("lordSkillDesRead")[12035] = "SKILL_FOOD_COLLECT_DAY_MAX"
;("lordSkillDesRead")[12037] = "SKILL_IRON_COLLECT_DAY_MAX"
;("lordSkillDesRead")[12039] = "SKILL_MITHRIL_COLLECT_DAY_MAX"
local ("lordSkillDesRead")[12041], everydayLimitTable = "SKILL_CRYSTAL_COLLECT_DAY_MAX", "lordSkillDesRead"
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local skillStudyViewPanel = class("skillStudyViewPanel", baseFguiPanel)
function skillStudyViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("skillStudyViewPanel:ctor", self.viewName)
end
function skillStudyViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function skillStudyViewPanel:onInit()
	print("=======skillStudyViewPanel:onInit")
	self.conditionList, _ENV, self.tableSkillData, _ENV = print, print, print, print
	self.fields.Text_max_tip:setString(i18n("lordskill_text_07"))
	self.fields.Text_condition:setString(i18n("common_text_374"))
	self.fields.Button_study:setString(i18n("common_text_375"))
	self.fields.Button_study:addClickListener(handler(self, self.onBtnStudyClick))
	self.fields.Button_studyFull:setString(i18n("common_text_1528_s"))
	self.fields.Button_studyFull:addClickListener(handler(self, self.onBtnStudyFullClick))
	self.fields.List_condition:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_curLv:fixPos()
	self.fields.Text_toLv:fixPos()
	self.fields.Button_study:fixPos()
	self.fields.Button_studyFull:fixPos()
	self.fields.n5:setRotation(SoraDFIsRA() and 90 or -90)
	self.fields.bar:setScaleX(SoraDFIsRA() and -1 or 1)
end
function skillStudyViewPanel:onShow()
	print("=======skillStudyViewPanel:onShow")
	self.skillID = self.param.skillID
	self.setID = self.param.setID
	self.iconType = self.param.iconType
	self:initData()
end
function skillStudyViewPanel:onItemRenderer(index, obj)
	local skillID = self.conditionList[index + 1]
	obj:initData(skillID, self.iconType)
	local info = lordSkillModuleAPI:getSkillDetail(self.setID, skillID)
	lordSkillModuleAPI = nil
	;(nil).lv = info.maxLevel
	obj:setLabStatus(true, i18n("common_text_277", nil))
end
function skillStudyViewPanel:initData(target, data)
	SoraDCloseLoading(self)
	self.tableSkillData = lordSkillModuleAPI:getSkillDetail(self.setID, self.skillID)
	self:updateView(data ~= nil)
end
function skillStudyViewPanel:updateView(isFromMsg)
	self.fields.Panel_bg:setString(lordSkillDesRead.getName(self.tableSkillData.skillID))
	self.fields.Com_skillIcon:initData(self.tableSkillData.skillID, self.iconType)
	self.fields.Com_skillIcon:setLabStatus(false)
	self.fields.Text_des:setString(lordSkillDesRead.getDes(self.tableSkillData.skillID))
	if tonumber(self.tableSkillData.currentLevel) >= tonumber(self.tableSkillData.maxLevel) then
		self.controllers.c1:setSelectedIndex(2)
		self.fields.Com_skillIcon:setGrayStatus(false)
		lordSkillDesRead = lordSkillDesRead.getDes(self.tableSkillData.skillID)
		lordSkillDesRead.getDes(self.tableSkillData.skillID).lv = self.tableSkillData.maxLevel
		self.fields.Text_lvmax:setString(i18n("common_text_100", lordSkillDesRead.getDes(self.tableSkillData.skillID)))
		self.fields.bar:setMax(self.tableSkillData.maxLevel)
		if isFromMsg then
			self.fields.bar:tweenValue(self.tableSkillData.maxLevel, 0.5)
		else
			self.fields.bar:setValue(self.tableSkillData.maxLevel)
		end
		local baseValue, plusValue = self:getShowValue()
		self.fields.Text_value:setString(baseValue)
	elseif self.tableSkillData.isOpened then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Com_skillIcon:setGrayStatus(false)
		self.fields.bar:setMax(self.tableSkillData.maxLevel)
		if isFromMsg then
			self.fields.bar:tweenValue(self.tableSkillData.currentLevel, 0.5)
		else
			self.fields.bar:setValue(self.tableSkillData.currentLevel)
		end
		local baseValue, plusValue = self:getShowValue()
		lordSkillDesRead = i18n("common_text_100", lordSkillDesRead.getDes(self.tableSkillData.skillID))
		i18n("common_text_100", lordSkillDesRead.getDes(self.tableSkillData.skillID)).var1 = baseValue
		i18n("common_text_100", lordSkillDesRead.getDes(self.tableSkillData.skillID)).var2 = fguiHelper.getColorString("#70C723", "+" .. plusValue)
		self.fields.Text_value:setString(i18n("%{var1} %{var2}", i18n("common_text_100", lordSkillDesRead.getDes(self.tableSkillData.skillID))))
		lordSkillDesRead = i18n("%{var1} %{var2}", i18n("common_text_100", lordSkillDesRead.getDes(self.tableSkillData.skillID)))
		i18n("%{var1} %{var2}", i18n("common_text_100", lordSkillDesRead.getDes(self.tableSkillData.skillID))).lv = self.tableSkillData.currentLevel
		self.fields.Text_curLv:setString(i18n("common_text_100", i18n("%{var1} %{var2}", i18n("common_text_100", lordSkillDesRead.getDes(self.tableSkillData.skillID)))))
		lordSkillDesRead = i18n("common_text_100", i18n("%{var1} %{var2}", i18n("common_text_100", lordSkillDesRead.getDes(self.tableSkillData.skillID))))
		i18n("common_text_100", i18n("%{var1} %{var2}", i18n("common_text_100", lordSkillDesRead.getDes(self.tableSkillData.skillID)))).lv = self.tableSkillData.currentLevel + 1
		self.fields.Text_toLv:setString(i18n("common_text_100", i18n("common_text_100", i18n("%{var1} %{var2}", i18n("common_text_100", lordSkillDesRead.getDes(self.tableSkillData.skillID))))))
		self:updateStudyButton()
	else
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Com_skillIcon:setGrayStatus(true)
		self.conditionList = lordInfoCtrl:getSkillFont(self.tableSkillData.skillID)
		self.fields.List_condition:setNumItems(#self.conditionList)
	end
end
function skillStudyViewPanel:updateStudyButton()
	local skillSetData = lordSkillModuleAPI:getSkillSetData(self.setID)
	local havePoint = skillSetData.skillPoints
	self.fields.Button_study:setEnabled(0 < havePoint)
	self.fields.Button_studyFull:setEnabled(0 < havePoint)
end
function skillStudyViewPanel:getShowValue()
	local baseValue, plusValue = 0, 0
	if self.tableSkillData.skillID == lordSkillIDDefine.siegeLore or self.tableSkillData.skillID == lordSkillIDDefine.killBarrier then
		local curSkillDetail = lordSkillModuleAPI:getSkillDetail(self.setID, self.tableSkillData.skillID)
		if curSkillDetail.currentLevel == 0 then
			curSkillDetail.currentLevel = 1
		end
		baseValue = lordSkillModuleAPI:getBuffInfoText(self.setID, self.tableSkillData.skillID, curSkillDetail.currentLevel)
		plusValue = lordSkillModuleAPI:getBuffInfoText(self.setID, self.tableSkillData.skillID, 1)
		self.tableSkillData.isAcitve = false
		if self.tableSkillData.currentLevel == 0 then
			baseValue = 0
		end
		baseValue = baseValue / 10 .. "%"
		plusValue = plusValue / 10 .. "%"
	else
		baseValue, plusValue = lordSkillModuleAPI:getBuffInfoText(self.setID, self.tableSkillData.skillID, self.tableSkillData.currentLevel)
	end
	return baseValue, plusValue
end
function skillStudyViewPanel:onBtnStudyClick()
	SoraDPlaySound()
	lordSkillModuleAPI:upgradeSkill(self.setID, self.tableSkillData.skillID, 1)
	SoraDShowLoading(self)
end
function skillStudyViewPanel:onBtnStudyFullClick()
	SoraDPlaySound("uicontrol", 54)
	lordSkillModuleAPI:upgradeSkill(self.setID, self.tableSkillData.skillID, 0)
	SoraDShowLoading(self)
end
return skillStudyViewPanel

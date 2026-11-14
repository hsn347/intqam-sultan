local technologyCtrl = SoraDGetCtrl("technologyCtrl")
local guideCtrl = SoraDGetCtrl("guideCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local warTechnologyViewPanel = class("warTechnologyViewPanel", baseFguiPanel)
function warTechnologyViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("warTechnologyViewPanel:ctor", self.viewName)
end
function warTechnologyViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function warTechnologyViewPanel:onInit()
	print("=======warTechnologyViewPanel:onInit")
	self.isHideCurrentSceneView = true
	_ENV, self.techType = TECHNOLOGY_ATTR.wartechnology, TECHNOLOGY_ATTR.wartechnology
	_ENV = nil
	;(nil).scroll = "warTechnologyScrollView"
	;(nil).title = i18n("warSkill_name_01")
	TECHNOLOGY_ATTR.wartechnology[WARTECHNOLOGY_ATTR.wartechnology], (nil).tab = nil, 0
	_ENV = nil
	;(nil).scroll = "warBattleScrollView"
	;(nil).title = i18n("warSkill_name_02")
	TECHNOLOGY_ATTR.wartechnology[WARTECHNOLOGY_ATTR.warbattle], (nil).tab = nil, 1
	_ENV = nil
	;(nil).scroll = "warMilitaryScrollView"
	;(nil).title = i18n("warSkill_name_03")
	TECHNOLOGY_ATTR.wartechnology[WARTECHNOLOGY_ATTR.warmilitary], (nil).tab = nil, 2
	_ENV = nil
	;(nil).scroll = "warCommandScrollView"
	;(nil).title = i18n("warSkill_name_04")
	TECHNOLOGY_ATTR.wartechnology[WARTECHNOLOGY_ATTR.warcommand], (nil).tab = nil, 3
	_ENV = nil
	;(nil).scroll = "warLightScrollView"
	;(nil).title = i18n("warSkill_name_05")
	self.techTreeCfg, TECHNOLOGY_ATTR.wartechnology[WARTECHNOLOGY_ATTR.warlight], (nil).tab = TECHNOLOGY_ATTR.wartechnology, nil, 4
	self.fields.Com_title:initData("", handler(self, self.onClickClose))
	self.fields.Text_tip:setString(i18n("common_text_3906"))
	self.fields.Com_studying:setVisible(false)
end
function warTechnologyViewPanel:onShow()
	print("=======warTechnologyViewPanel:onShow")
	self.techType = self.param.techType or TECHNOLOGY_ATTR.wartechnology
	self.fields.Com_title:updateTitle(self.techTreeCfg[self.techType].title)
	self.controllers.c1:setSelectedIndex(self.techTreeCfg[self.techType].tab)
	self:initData()
end
function warTechnologyViewPanel:endShow()
	if not IsArClient then
		guideCtrl:updateGuideModule(gGuideModule.WAR_TECH)
	end
end
function warTechnologyViewPanel:initData()
	self.fields[self.techTreeCfg[self.techType].scroll]:initData(self.techType, gQueueTypeDef.war_tech_research)
	self:updateStudy()
end
function warTechnologyViewPanel:updateStudy()
	self.tableStuding, self.studyingType = technologyCtrl:studyingTechnology(gQueueTypeDef.war_tech_research)
	if self.studyingType == self.techType then
		self.fields.Com_studying:setVisible(self.tableStuding ~= nil)
		if self.tableStuding then
			self.fields.Com_studying:initData(self.tableStuding, self.studyingType, i18n("common_text_059"))
		end
	else
		self.fields.Com_studying:setVisible(false)
	end
end
function warTechnologyViewPanel:gameGuide_getTarget(itemName, parameters)
	if itemName == "warSingle" then
		local target = self.fields[self.techTreeCfg[self.techType].scroll]:getCollegeSingleById(parameters.tid)
		if target then
			return target
		else
			return self.fields[itemName]
		end
	end
	return self.fields[itemName]
end
return warTechnologyViewPanel

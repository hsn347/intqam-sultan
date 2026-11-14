local armyDesRead = include("armyDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local soldiersInfoTipViewPanel = class("soldiersInfoTipViewPanel", baseFguiPanel)
function soldiersInfoTipViewPanel:ctor(...)
	soldiersInfoTipViewPanel.super.ctor(self, ...)
	print("soldiersInfoTipViewPanel:ctor", self.viewName)
end
function soldiersInfoTipViewPanel:onInit()
	print("=======soldiersInfoTipViewPanel:onInit")
	self.attrList, _ENV, self.skillList, _ENV = print, print, print, print
	self.fields.Text_attr:setString(i18n("hero_title_01"))
	self.fields.List_skill:setItemRenderer(handler(self, self.onSkillRenderer))
	self.fields.List_attr:setItemRenderer(handler(self, self.onAttrRenderer))
end
function soldiersInfoTipViewPanel:onShow()
	print("=======soldiersInfoTipViewPanel:onShow")
	self.armyID = self.param.armyID
	self:initData()
end
function soldiersInfoTipViewPanel:onSkillRenderer(index, obj)
	obj:initData(self.skillList[index + 1])
end
function soldiersInfoTipViewPanel:onAttrRenderer(index, obj)
	obj:initData(self.attrList[index + 1], self.armyID)
end
function soldiersInfoTipViewPanel:initData()
	self.fields.Panel_bg:setString(armyDesRead.getName(self.armyID))
	self.skillList = armyDesRead.getSkill(self.armyID)
	self.fields.List_skill:setNumItems(#self.skillList)
	armyDesRead, armyDesRead = self.fields.List_skill, self.fields.List_skill.setNumItems
	self.fields.List_skill.attrEnum = ARMY_ATTR.ATTACK
	self.fields.List_skill.title = "common_text_319"
	armyDesRead, self.fields.List_skill.setNumItems[1], self.fields.List_skill.bType = self.fields.List_skill, self.fields.List_skill, 1
	self.fields.List_skill.attrEnum = ARMY_ATTR.DEFENSE
	self.fields.List_skill.title = "common_text_320"
	armyDesRead, self.fields.List_skill.setNumItems[2], self.fields.List_skill.bType = self.fields.List_skill, self.fields.List_skill, 2
	self.fields.List_skill.attrEnum = ARMY_ATTR.LIFE
	self.fields.List_skill.title = "common_text_321"
	armyDesRead, self.fields.List_skill.setNumItems[3], self.fields.List_skill.bType = self.fields.List_skill, self.fields.List_skill, 3
	self.fields.List_skill.attrEnum = ARMY_ATTR.ATK_DISTANCE
	armyDesRead, self.fields.List_skill.setNumItems[4], self.fields.List_skill.title = self.fields.List_skill, self.fields.List_skill, "common_text_322"
	self.fields.List_skill.attrEnum = ARMY_ATTR.SPEED
	armyDesRead, self.fields.List_skill.setNumItems[5], self.fields.List_skill.title = self.fields.List_skill, self.fields.List_skill, "common_text_323"
	self.fields.List_skill.attrEnum = ARMY_ATTR.FREE_WEIGHT
	armyDesRead, self.fields.List_skill.setNumItems[6], self.fields.List_skill.title = self.fields.List_skill, self.fields.List_skill, "common_text_324"
	self.fields.List_skill.attrEnum = ARMY_ATTR.COSTFOOD
	armyDesRead, self.fields.List_skill.setNumItems[7], self.fields.List_skill.title = self.fields.List_skill, self.fields.List_skill, "common_text_325"
	self.fields.List_skill.attrEnum = ARMY_ATTR.POWER
	self.attrList, self.fields.List_skill.setNumItems[8], self.fields.List_skill.title = self.fields.List_skill.setNumItems, self.fields.List_skill, "common_text_097"
	self.fields.List_attr:setNumItems(#self.attrList)
end
return soldiersInfoTipViewPanel

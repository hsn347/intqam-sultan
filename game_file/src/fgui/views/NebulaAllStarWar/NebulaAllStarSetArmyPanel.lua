local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
local armyDesRead = include("armyDesRead")
local eliteSoldiersDef = include("eliteSoldiersDef")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaAllStarSetArmyPanel = class("NebulaAllStarSetArmyPanel", baseFguiPanel)
function NebulaAllStarSetArmyPanel:ctor(...)
	NebulaAllStarSetArmyPanel.super.ctor(self, ...)
	print("NebulaAllStarSetArmyPanel:ctor", self.viewName)
end
function NebulaAllStarSetArmyPanel:onInit()
	print("=======NebulaAllStarSetArmyPanel:onInit")
	self.fields.Panel_bg:setString(i18n("NebulaAllstar_381"))
	local totalArmy = nebulaAllStarCtrl:getTotalArmy()
	_ENV = i18n("NebulaAllstar_381")
	i18n("NebulaAllstar_381").num = string.formatnumberthousands(totalArmy)
	self.fields.Text_curNum:setString(i18n("NebulaAllstar_140", i18n("NebulaAllstar_381")))
	self.fields.Button_help:addClickListener(handler(self, self.onClickBtnHelp))
	self.fields.Text_select:setString(i18n("NebulaAllstar_384"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_set:setString(i18n("common_text_204"))
	self.fields.Button_set:addClickListener(handler(self, self.onClickBtnSet))
end
function NebulaAllStarSetArmyPanel:onShow()
	print("=======NebulaAllStarSetArmyPanel:onShow")
	self.armyid = nebulaAllStarCtrl:getDefendArmyid()
	self.armyidList = nebulaAllStarCtrl:getDefendArmyidList()
	local index = table.indexof(self.armyidList, self.armyid)
	if index then
		self.curSelect = index
	end
	self.fields.List:setNumItems(#self.armyidList)
	if self.curSelect then
		self.fields.List:setSelectedIndex(self.curSelect - 1)
	end
	self:updateArmySelect()
end
function NebulaAllStarSetArmyPanel:onClickBtnHelp()
	SoraDPlaySound()
	uiManager:show("NebulaAllStarHospitalHelp")
end
function NebulaAllStarSetArmyPanel:onItemRenderer(index, obj)
	index = index + 1
	local armyid = self.armyidList[index]
	if not obj._fields then
		obj._fields = fguiHelper.get_fields(obj)
		obj:addClickListener(handler(self, self.onClickArmy))
	end
	obj.index = index
	local _fields = obj._fields
	local spineCfg = armyDesRead.getSpecialArmyCfg(armyid)
	local spineInfo
	if spineCfg and spineCfg.spine then
		spineInfo = spineCfg.spine
	else
		local modelType = armyDesRead.getModelType(armyid)
		local alv = armyLogic.getArmyLV(armyid)
		local eliteCfg = eliteSoldiersDef.getSpineCfg(modelType, alv)
		if eliteCfg and eliteCfg.json then
			spineInfo = eliteCfg.json
		end
	end
	if spineInfo then
		_fields.Spine_army:setEffectPath(spineInfo)
		_fields.Spine_army:setVisible(true)
		_fields.army:setVisible(false)
	else
		_fields.army:setIcon(armyDesRead.getPortrait(armyid))
		_fields.army:setVisible(true)
		_fields.Spine_army:setVisible(false)
	end
	local armyName = armyDesRead.getName(armyid)
	_fields.title:setString(armyName)
end
function NebulaAllStarSetArmyPanel:onClickArmy(EventContext)
	local obj = EventContext:getSender()
	local selectIndex = obj.index
	if selectIndex == self.curSelect then
		self.curSelect = nil
		self.fields.List:clearSelection()
	else
		self.curSelect = selectIndex
	end
	self:updateArmySelect()
end
function NebulaAllStarSetArmyPanel:updateArmySelect(...)
	local tipStr = i18n("NebulaAllstar_383")
	if self.curSelect then
		local armyid = self.armyidList[self.curSelect]
		local armyName = armyDesRead.getName(armyid)
		_ENV = nil
		_ENV, _ENV, (nil).name = nil, nil, armyName
		;(nil).name, (nil).color = nil, "#70C723"
		tipStr = i18n_html("NebulaAllstar_382", nil, nil)
	end
	self.fields.Text_tip:setString(tipStr)
end
function NebulaAllStarSetArmyPanel:onClickBtnSet(...)
	SoraDPlaySound()
	local armyid = self.curSelect and self.armyidList[self.curSelect] or 0
	if self.armyid ~= armyid then
		nebulaAllStarCtrl:reqSetDefendArmy(armyid)
	end
	self:closePanel()
end
return NebulaAllStarSetArmyPanel

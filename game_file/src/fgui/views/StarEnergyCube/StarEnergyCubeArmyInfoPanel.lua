local starCubeCtrl = SoraDGetCtrl("starCubeCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local StarEnergyCubeArmyInfoPanel = class("StarEnergyCubeArmyInfoPanel", baseFguiPanel)
function StarEnergyCubeArmyInfoPanel:ctor(...)
	self.super.ctor(self, ...)
	print("StarEnergyCubeArmyInfoPanel:ctor", self.viewName)
end
function StarEnergyCubeArmyInfoPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function StarEnergyCubeArmyInfoPanel:onInit()
	print("=======StarEnergyCubeArmyInfoPanel:onInit")
	self.fields.List_army:setItemRenderer(handler(self, self.onItemRendererArmy))
	self.fields.List_hero:setItemRenderer(handler(self, self.onItemRendererHero))
end
function StarEnergyCubeArmyInfoPanel:initData(data)
	local index = data.index
	dump(data, "StarEnergyCubeArmyInfoPanel:initData")
	self.fields.Panel_bg:setTitle(i18n("buildDes_name_109"))
	self.fields.Text_des:setString(i18n(data.des))
	self.defend = data.defendInfo
	local color = cc.c3b(216, 161, 255)
	if index == 2 then
		color = cc.c3b(161, 225, 255)
	elseif index == 3 then
		color = cc.c3b(118, 230, 137)
	end
	self.fields.Text_des:setColor(color)
	local armyTotalNums = starCubeCtrl:getArmyTotalNums(index)
	_ENV = i18n(data.des)
	i18n(data.des).power = string.formatnumberthousands(self.defend.fightCapacity)
	self.fields.Text_defend:setString(i18n("Martial_arts_text_22", i18n(data.des)))
	_ENV = i18n("Martial_arts_text_22", i18n(data.des))
	i18n("Martial_arts_text_22", i18n(data.des)).count = string.formatnumberthousands(armyTotalNums)
	self.fields.Text_armyTotal:setString(i18n("common_text_466", i18n("Martial_arts_text_22", i18n(data.des))))
	self.info, _ENV = self.fields.Text_armyTotal.setString, self.fields.Text_armyTotal.setString
	if self.defend.armsInfo and next(self.defend.armsInfo) then
		table.insert(self.info, self.defend.armsInfo[1])
	end
	if self.defend.heroInfo and next(self.defend.heroInfo) then
		dump(self.defend.heroInfo, "fjskdfjkdjfk")
		for i, v in ipairs(self.defend.heroInfo) do
			table.insert(self.info, v)
		end
	end
	if self.info and next(self.info) then
		self.fields.List_hero:setNumItems(table.nums(self.info))
	else
		self.controllers.c1:setSelectedIndex(1)
	end
	if self.defend.armyInfo and next(self.defend.armyInfo) then
		self.fields.List_army:setNumItems(table.nums(self.defend.armyInfo))
	end
end
function StarEnergyCubeArmyInfoPanel:onItemRendererArmy(index, object)
	object:initData(index + 1, self.defend.armyInfo[index + 1])
end
function StarEnergyCubeArmyInfoPanel:onItemRendererHero(index, object)
	object:initData(index + 1, self.info[index + 1])
end
function StarEnergyCubeArmyInfoPanel:onShow()
	print("=======StarEnergyCubeArmyInfoPanel:onShow")
	self:initData(self.proxy.param)
end
return StarEnergyCubeArmyInfoPanel

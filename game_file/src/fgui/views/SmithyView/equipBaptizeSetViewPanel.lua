local equipmentCtrl = SoraDGetCtrl("equipmentCtrl")
local equipmentMgr = include("equipmentMgr")
local constantRead = include("constantRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local equipBaptizeSetViewPanel = class("equipBaptizeSetViewPanel", baseFguiPanel)
function equipBaptizeSetViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("equipBaptizeSetViewPanel:ctor", self.viewName)
end
function equipBaptizeSetViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function equipBaptizeSetViewPanel:onInit()
	print("=======equipBaptizeSetViewPanel:onInit")
	self.setArray, _ENV, self.tag = gQualityDef.GREEN, gQualityDef.GREEN, gQualityDef.GREEN
	self.fields.Panel_bg:setString(i18n("equipment_training_text_02"))
	self.fields.Text_tip:setString(i18n("equipment_training_text_08"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function equipBaptizeSetViewPanel:onShow()
	print("=======equipBaptizeSetViewPanel:onShow")
	self.equipCell = self.param.equipCell
	_ENV, _ENV, self.tag = self.equipCell, self.equipCell:getEquipmentQuality(), self.equipCell:getEquipmentQuality()
	self.equipCell.title = i18n("equipment_training_text_03")
	_ENV, self.equipCell:getEquipmentQuality()[1], self.equipCell.tag = self.equipCell, self.equipCell, gQualityDef.GREEN
	self.equipCell.title = i18n("equipment_training_text_04")
	_ENV, self.equipCell:getEquipmentQuality()[2], self.equipCell.tag = self.equipCell, self.equipCell, gQualityDef.BLUE
	self.equipCell.title = i18n("equipment_training_text_05")
	self.equipCell:getEquipmentQuality()[3], self.equipCell.tag = self.equipCell, gQualityDef.PURPLE
	local tabsetArray = self.equipCell:getEquipmentQuality()
	if SoraDGetLordLv() >= 40 then
		_ENV = gQualityDef.PURPLE
		gQualityDef.PURPLE.title = i18n("equipment_training_text_06")
		tabsetArray[#tabsetArray + 1], gQualityDef.PURPLE.tag = gQualityDef.PURPLE, gQualityDef.ORANGE
	end
	if equipmentMgr.isHaveNebulaEquipment() then
		_ENV = gQualityDef.PURPLE
		gQualityDef.PURPLE.title = i18n("common_text_4621")
		tabsetArray[#tabsetArray + 1], gQualityDef.PURPLE.tag = gQualityDef.PURPLE, gQualityDef.NEBULA
	end
	if equipmentMgr.isHaveLegendEquipment() then
		_ENV = gQualityDef.PURPLE
		gQualityDef.PURPLE.title = i18n("equipment_training_text_07")
		tabsetArray[#tabsetArray + 1], gQualityDef.PURPLE.tag = gQualityDef.PURPLE, gQualityDef.LEGEND
	end
	_ENV = gQualityDef.LEGEND
	gQualityDef.LEGEND.defaultClick = self.tag
	gQualityDef.LEGEND.tabsetArray = tabsetArray
	gQualityDef.LEGEND.callback = handler(self, self.clickTab)
	self.fields.com_TabW:initView(gQualityDef.LEGEND)
end
function equipBaptizeSetViewPanel:onItemRenderer(index, obj)
	obj:initData(self.setArray[index + 1], self.tag)
end
function equipBaptizeSetViewPanel:clickTab(tag)
	self.tag = tag
	self:updateView()
end
function equipBaptizeSetViewPanel:updateView()
	local maxGroup = constantRead.getConstValue("EQUIPMENT_ATTRIBUTE_GROUP_MAX_COUNT")
	self.setArray = equipmentCtrl:getAttributeGroupInfo(self.tag)
	local setCount = equipmentCtrl:getSettedAttributeGroupCount()
	constantRead = nil
	;(nil).var1 = setCount
	;(nil).var2 = maxGroup
	self.fields.Text_setted:setString(i18n("equipment_training_text_09", nil))
	if maxGroup > #self.setArray then
		i18n("equipment_training_text_09", nil).info, constantRead, constantRead = i18n("equipment_training_text_09", nil)
		table.insert(self.setArray, i18n("equipment_training_text_09", nil))
	end
	dump(self.setArray, "self.setArray===")
	self.fields.List:setNumItems(#self.setArray)
end
return equipBaptizeSetViewPanel

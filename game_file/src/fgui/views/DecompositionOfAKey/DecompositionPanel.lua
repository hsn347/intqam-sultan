_ENV = nil
;(nil).WHITE = 0
;(nil).GREEN = 1
;(nil).BLUE = 2
;(nil).PURPLE = 3
local _ENV, (nil).ORANGE, qualityDef = nil, 4, nil
;(nil).STRENGTH = 1
local (nil).SUIT, extraDef = 2, nil
local equipmentCtrl = SoraDGetCtrl("equipmentCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DecompositionPanel = class("DecompositionPanel", baseFguiPanel)
function DecompositionPanel:ctor(...)
	self.super.ctor(self, ...)
	print("DecompositionPanel:ctor", self.viewName)
end
function DecompositionPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function DecompositionPanel:onInit()
	print("=======DecompositionPanel:onInit")
	self.lvConfig, _ENV = print, print
	self:updateLvChoose()
	self.minLvIndex = gEquipResolveData.minLvIndex
	self.maxLvIndex = gEquipResolveData.maxLvIndex
	self.minLv = self.lvConfig[self.minLvIndex + 1]
	self.maxLv = self.lvConfig[self.maxLvIndex + 1]
	self.qualityList = gEquipResolveData.quality
	self.isStrengthen = gEquipResolveData.strength
	self.findList, _ENV, self.isSuit = gEquipResolveData.suit, gEquipResolveData.suit, gEquipResolveData.suit
	self.fields.Panel_bg:setTitle(i18n("disassemble_fast_1"))
	self.fields.Text_choose:setString(i18n("disassemble_fast_2"))
	self.fields.Text_quality:setString(i18n("disassemble_fast_3"))
	self.fields.Text_lvRange:setString(i18n("disassemble_fast_5"))
	self.fields.Text_tip:setString(i18n("disassemble_fast_11"))
	self.fields.Text_plx:setString("~")
	self.fields.Button_resolve:setString(i18n("common_text_1378"))
	self.fields.Button_resolve:addClickListener(handler(self, self.onBtnResolveClick))
	self.fields.List_quality:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_total:setItemRenderer(handler(self, self.onTotalRenderer))
	self.fields.com_strength:initData(extraDef.STRENGTH)
	self.fields.com_strength:setTitleStr(i18n("disassemble_fast_6"))
	self.fields.com_suit:initData(extraDef.SUIT)
	self.fields.com_suit:setTitleStr(i18n("disassemble_fast_7"))
	_ENV = i18n("disassemble_fast_7")
	i18n("disassemble_fast_7").items = self.lvConfig
	i18n("disassemble_fast_7").changedCallback = handler(self, self.onComboBoxMinChanged)
	i18n("disassemble_fast_7").selectedIndex = self.minLvIndex
	self:setComboBox(self.fields.ComboBox_min, i18n("disassemble_fast_7"))
	local dropdownMin = self.fields.ComboBox_min:getDropdown()
	self.comboBoxMinList = dropdownMin:getChildByName("list")
	self.fields.ComboBox_min:addClickListener(function()
		self.comboBoxMinList:setSelectedIndex(self.minLvIndex)
	end)
	_ENV = self.minLvIndex
	self.minLvIndex.items = self.lvConfig
	self.minLvIndex.changedCallback = handler(self, self.onComboBoxMaxChanged)
	self.minLvIndex.selectedIndex = self.maxLvIndex
	self:setComboBox(self.fields.ComboBox_max, self.minLvIndex)
	local dropdownMax = self.fields.ComboBox_max:getDropdown()
	self.comboBoxMaxList = dropdownMax:getChildByName("list")
	self.fields.ComboBox_max:addClickListener(function()
		self.comboBoxMaxList:setSelectedIndex(self.maxLvIndex)
	end)
	self.fields.Text_lvRange:fixPos()
	self.fields.Text_plx:fixPos()
	self.fields.ComboBox_min:fixPos()
	self.fields.ComboBox_max:fixPos()
end
function DecompositionPanel:updateLvChoose()
	self.lvConfig, _ENV = nil, nil
	for i = 1, SoraDGetLordLv() do
		if i == 1 or i % 5 == 0 then
			table.insert(self.lvConfig, i)
		end
	end
end
function DecompositionPanel:onComboBoxMinChanged()
	self.minLvIndex = self.fields.ComboBox_min:getSelectedIndex()
	self.minLv = self.lvConfig[self.minLvIndex + 1]
	if self.minLv > self.maxLv then
		self.minLvIndex = self.maxLvIndex
		self.minLv = self.lvConfig[self.minLvIndex + 1]
		self.fields.ComboBox_min:setSelectedIndex(self.minLvIndex)
	end
	print("self.minLv====", self.minLvIndex, self.minLv)
	gEquipResolveData.minLvIndex = self.minLvIndex
	self:initData()
end
function DecompositionPanel:onComboBoxMaxChanged()
	self.maxLvIndex = self.fields.ComboBox_max:getSelectedIndex()
	self.maxLv = self.lvConfig[self.maxLvIndex + 1]
	if self.maxLv < self.minLv then
		self.maxLvIndex = self.minLvIndex
		self.maxLv = self.lvConfig[self.maxLvIndex + 1]
		self.fields.ComboBox_max:setSelectedIndex(self.maxLvIndex)
	end
	print("self.maxLv====", self.maxLvIndex, self.maxLv)
	gEquipResolveData.maxLvIndex = self.maxLvIndex
	self:initData()
end
function DecompositionPanel:onItemRenderer(index, obj)
	obj:initData(index, self.qualityList)
end
function DecompositionPanel:onTotalRenderer(index, obj)
	obj:initData(index, self.findList)
end
function DecompositionPanel:onShow()
	print("=======DecompositionPanel:onShow")
	self:initDefaultSet()
	self:initData()
end
function DecompositionPanel:initDefaultSet()
	self.fields.ComboBox_min:setSelectedIndex(gEquipResolveData.minLvIndex)
	self.fields.ComboBox_max:setSelectedIndex(gEquipResolveData.maxLvIndex)
	self.fields.com_strength:setSelect(gEquipResolveData.strength)
	self.fields.com_suit:setSelect(gEquipResolveData.suit)
	self.fields.List_quality:setNumItems(table.nums(qualityDef))
end
function DecompositionPanel:initData()
	self.findList, self.equipList = equipmentCtrl:findEquipList(self.minLv, self.maxLv, self.isStrengthen, self.isSuit, self.qualityList)
	equipmentCtrl = self.isStrengthen
	self.isStrengthen.num = fguiHelper.getColorString("#FFFF00", self:getFindNum())
	self.fields.Text_full:setString(i18n("disassemble_fast_8", self.isStrengthen))
	self.fields.List_total:setNumItems(table.nums(qualityDef))
	self.fields.Button_resolve:setBright(self:getFindNum() > 0)
end
function DecompositionPanel:getFindNum()
	local num = 0
	for k, v in pairs(self.findList) do
		num = num + v
	end
	return num
end
function DecompositionPanel:updateExtraChoose(target, data)
	if data.isDel then
		if data.sType == extraDef.STRENGTH then
			self.isStrengthen = false
		end
		if data.sType == extraDef.SUIT then
			self.isSuit = false
		end
	else
		if data.sType == extraDef.STRENGTH then
			self.isStrengthen = true
		end
		if data.sType == extraDef.SUIT then
			self.isSuit = true
		end
	end
	print("self.isStrengthen,self.isSuit===", self.isStrengthen, self.isSuit)
	gEquipResolveData.strength = self.isStrengthen
	gEquipResolveData.suit = self.isSuit
	self:initData()
end
function DecompositionPanel:updateQualityChoose(target, data)
	if data.isDel then
		if self.qualityList[data.quality] then
			self.qualityList[data.quality] = nil
		end
	elseif not self.qualityList[data.quality] then
		self.qualityList[data.quality] = true
	end
	dump(self.qualityList, "self.qualityList===")
	self.fields.List_quality:setNumItems(table.nums(qualityDef))
	gEquipResolveData.quality = self.qualityList
	self:initData()
end
function DecompositionPanel:onBtnResolveClick()
	SoraDPlaySound()
	if self:getFindNum() <= 0 then
		SoraDShowMsgTip(i18n("disassemble_fast_10"))
		return
	end
	local _ENV, qualitys = SoraDShowMsgTip, SoraDShowMsgTip
	for k, v in pairs(self.qualityList) do
		table.insert(qualitys, k)
	end
	local _ENV, equipList = (for generator), pairs(self.qualityList)
	for k, v in pairs(self.findList) do
		if 0 < v then
			_ENV = i18n("disassemble_fast_10")
			i18n("disassemble_fast_10").quality = k
			i18n("disassemble_fast_10").count = v
			table.insert(equipList, i18n("disassemble_fast_10"))
		end
	end
	table.sort(equipList, function(a, b)
		return a.quality > b.quality
	end)
	_ENV = i18n("disassemble_fast_10")
	i18n("disassemble_fast_10").num = self:getFindNum()
	i18n("disassemble_fast_10").minLv = self.minLv
	i18n("disassemble_fast_10").maxLv = self.maxLv
	i18n("disassemble_fast_10").qualitys = qualitys
	i18n("disassemble_fast_10").isStrengthen = self.isStrengthen
	i18n("disassemble_fast_10").isSuit = self.isSuit
	i18n("disassemble_fast_10").equipList = equipList
	i18n("disassemble_fast_10").eList = self.equipList
	uiManager:show("EquipmentFor", i18n("disassemble_fast_10"))
end
return DecompositionPanel

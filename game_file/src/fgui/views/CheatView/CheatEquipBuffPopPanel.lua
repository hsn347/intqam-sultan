local MAX_ATTR_NUM = 5
_UPVALUE14_ = nil
;(nil)[1] = gEquipmentExtraProperty.INFANTRY_ATTACK
;(nil)[2] = gEquipmentExtraProperty.CAVALRY_ATTACK
;(nil)[3] = gEquipmentExtraProperty.ARCHER_ATTACK
;(nil)[4] = gEquipmentExtraProperty.SIEGE_VEHICLES_ATTACK
;(nil)[5] = gEquipmentExtraProperty.INFANTRY_DEFENSE
;(nil)[6] = gEquipmentExtraProperty.CAVALRY_DEFENSE
;(nil)[7] = gEquipmentExtraProperty.ARCHER_DEFENSE
;(nil)[8] = gEquipmentExtraProperty.SIEGE_VEHICLES_DEFENSE
;(nil)[9] = gEquipmentExtraProperty.INFANTRY_HP
;(nil)[10] = gEquipmentExtraProperty.CAVALRY_HP
;(nil)[11] = gEquipmentExtraProperty.ARCHER_HP
;(nil)[12] = gEquipmentExtraProperty.SIEGE_VEHICLES_HP
;(nil)[13] = gEquipmentExtraProperty.SOLDIER_LOAD
local (nil)[14], EXTRA_CFG = gEquipmentExtraProperty.RESOURCE_PROTECT, nil
local equipmentltCtrl = include("equipmentltCtrl")
local equipDesRead = include("equipDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CheatEquipBuffPopPanel = class("CheatEquipBuffPopPanel", baseFguiPanel)
function CheatEquipBuffPopPanel:ctor(...)
	self.isLRU = true
	CheatEquipBuffPopPanel.super.ctor(self, ...)
	print("CheatEquipBuffPopPanel:ctor", self.viewName)
end
function CheatEquipBuffPopPanel:onInit()
	print("=======CheatEquipBuffPopPanel:onInit")
	self.fields.Panel_bg:setString("洗炼属性设置")
	self.fields.Text_attr:setString("洗炼属性")
	self.fields.Text_range:setString("属性范围")
	self.fields.Text_input:setString("参数")
	self.fields.Button_ok:setString("确定")
	self.fields.Button_ok:addClickListener(handler(self, self.btnOkClick))
end
function CheatEquipBuffPopPanel:onComboBoxClick(index)
	SoraDPlaySound()
	self.indexArray[index] = tonumber(self.fields["ComboBox_" .. index]:getValue())
	self:setBuffRange()
end
function CheatEquipBuffPopPanel:setBuffRange()
	for i, v in ipairs(EXTRA_CFG) do
		if i <= self.extraNum then
			local propertyType = self.indexArray[i] or EXTRA_CFG[1]
			local equipType = equipmentltCtrl.getEquipmentType(self.equip.eid, self.equip.qly)
			local minValue, maxValue, dataType = equipmentltCtrl.getEquipmentExtraPropertyRange(self.equip.lv, propertyType, equipType)
			self.fields["Text_range_" .. i]:setString("[" .. minValue .. "~" .. maxValue .. "]")
			self.fields["input_" .. i]:getChild("input"):setText(self.equip.extra[i] and self.equip.extra[i][2] or maxValue)
		end
	end
end
function CheatEquipBuffPopPanel:endShow()
	print("=======CheatEquipBuffPopPanel:endShow")
	self.part = self.param.part
	self.indexArray, _ENV, self.equip = self.param.equip, self.param.equip, self.param.equip
	local _ENV, items = self.param.equip, self.param.equip
	for i, v in ipairs(EXTRA_CFG) do
		items[i] = equipDesRead.getAttrName(v)
	end
	self.extraNum = equipmentltCtrl.getExtraPropertyNum(self.equip.qly) or MAX_ATTR_NUM
	for i = 1, MAX_ATTR_NUM do
		self.fields["ComboBox_" .. i]:setVisible(i <= self.extraNum)
		self.fields["ComboBox_" .. i]:setSelectedIndex(0)
		self.fields["Text_range_" .. i]:setVisible(i <= self.extraNum)
		self.fields["input_" .. i]:setVisible(i <= self.extraNum)
		self.fields["line_" .. i]:setVisible(i <= self.extraNum)
		_ENV = "ComboBox_" .. i
		;("ComboBox_" .. i).items = items
		;("ComboBox_" .. i).values = EXTRA_CFG
		;("ComboBox_" .. i).changedCallback = handlerEx(self, self.onComboBoxClick, i)
		self:setComboBox(self.fields["ComboBox_" .. i], "ComboBox_" .. i)
		local toIndex = 0
		if self.equip.extra[i] then
			for index, buff in ipairs(EXTRA_CFG) do
				if buff == self.equip.extra[i][1] then
					toIndex = index - 1
				end
			end
			self.indexArray[i] = self.equip.extra[i][1]
		end
		self.fields["ComboBox_" .. i]:setSelectedIndex(toIndex)
	end
	self:setBuffRange()
end
function CheatEquipBuffPopPanel:btnOkClick()
	SoraDPlaySound()
	local _ENV, extra = SoraDPlaySound, SoraDPlaySound
	for i = 1, self.extraNum do
		local extraID = self.indexArray[i] or EXTRA_CFG[1]
		local extraVal = tonumber(self.fields["input_" .. i]:getChild("input"):getText())
		_UPVALUE2_ = self.fields["input_" .. i]:getChild("input"):getText()
		self.fields["input_" .. i]:getChild("input"):getText()[1] = extraID
		self.fields["input_" .. i]:getChild("input"):getText()[2] = extraVal
		table.insert(extra, self.fields["input_" .. i]:getChild("input"):getText())
	end
	self.equip.extra = extra
	_ENV = self.extraNum
	self.extraNum.msg = "MESSAGE_CHEAT_UI_FIGHTDEMO_EQUIP"
	self.extraNum.part = self.part
	self.extraNum.equip = self.equip
	SoraDSendMessage(self.extraNum)
	self:close()
end
return CheatEquipBuffPopPanel

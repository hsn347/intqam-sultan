local equipDesRead = include("equipDesRead")
local equipmentltCtrl = include("equipmentltCtrl")
local equipmentCtrl = SoraDGetCtrl("equipmentCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local equipBaptizeSetDoneViewPanel = class("equipBaptizeSetDoneViewPanel", baseFguiPanel)
function equipBaptizeSetDoneViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("equipBaptizeSetDoneViewPanel:ctor", self.viewName)
end
function equipBaptizeSetDoneViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function equipBaptizeSetDoneViewPanel:onInit()
	print("=======equipBaptizeSetDoneViewPanel:onInit")
	self.tableAttrData, _ENV = print, print
	self.fields.frame_title:setSpriteFrame(SoraDFIsRA() and "frame_title_congratulation_ar.png" or "frame_title_congratulation_en.png")
	self.fields.Text_title:setString(i18n("equipment_training_text_11"))
	self.fields.Button_replace:setString(i18n("common_text_1371"))
	self.fields.Button_replace:addClickListener(handler(self, self.onBtnReplace))
	self.fields.Button_back:setString(i18n("common_text_006"))
	self.fields.Button_back:addClickListener(handler(self, self.onBtnBack))
	self.fields.List_attr:setItemRenderer(handler(self, self.onAttrRenderer))
	self.fields.Button_replace:fixPos()
	self.fields.Button_back:fixPos()
end
function equipBaptizeSetDoneViewPanel:onAttrRenderer(index, obj)
	obj:initData(self.tableAttrData[index + 1])
end
function equipBaptizeSetDoneViewPanel:onShow()
	print("=======equipBaptizeSetDoneViewPanel:onShow")
	self.tableSingleData = self.param.singleData
	self.rExtra = self.param.rExtra
	self.idx = self.param.idx
	self.eqid = self.tableSingleData:getEPID()
	self.fields.Com_equip:initData(self.tableSingleData)
	local lvStr = ""
	if gEquipTypeDef.EQUIP_LEGEND ~= self.tableSingleData:getEquipmentType() then
		_ENV = self.tableSingleData
		self.tableSingleData.lv = self.tableSingleData:getEquipmentLV()
		lvStr = i18n("common_text_100", self.tableSingleData)
	end
	self.fields.Text_name:setString(lvStr .. " " .. equipDesRead.getName(self.tableSingleData:getEID()))
	self.fields.Text_name:setColor(equipDesRead.getAttrColor(self.tableSingleData:getEquipmentQuality()))
	self:initAttrLabel()
end
function equipBaptizeSetDoneViewPanel:initAttrLabel()
	local baseProperty = self.tableSingleData:getEquipmentBaseProperty()
	local isSuitEquip = equipmentltCtrl.judgeSuitEquipByEid(self.tableSingleData:getEID())
	local eLv = self.tableSingleData:getEquipmentLV()
	local slv = self.tableSingleData:getEquipmentSLV()
	if isSuitEquip then
		eLv = eLv % 100
		local propertyType, propertyValue, propertyType2, propertyValue2 = equipmentltCtrl.getSuitEquipBuffValueByEidAndIndex(self.tableSingleData:getEquipmentPart(), self.tableSingleData:getEID(), self.tableSingleData:getEquipmentQuality(), slv)
		baseProperty[1] = propertyType
		baseProperty[2] = propertyValue
		baseProperty[3] = propertyType2
		baseProperty[4] = propertyValue2
	end
	for i = 1, #baseProperty - 1, 2 do
		local name, value = equipDesRead.getAttrName(baseProperty[i], baseProperty[i + 1], true)
		equipmentltCtrl = self.tableSingleData:getEID()
		self.tableSingleData:getEID().name = name
		self.tableSingleData:getEID().value = value
		self.tableSingleData:getEID().color = equipDesRead:getNormalColor()
		table.insert(self.tableAttrData, self.tableSingleData:getEID())
	end
	if not self.rExtra then
		equipmentltCtrl = self.rExtra
	end
	for k, v in ipairs(self.rExtra) do
		local name, value = equipDesRead.getAttrName(v[1], v[2], true)
		local quality = equipmentltCtrl.getEquipmentExtraPropertyQuality(eLv, v[1], v[2], self.tableSingleData:getEquipmentType())
		local _, maxValue, dataType = equipmentltCtrl.getEquipmentExtraPropertyRange(eLv, v[1], self.tableSingleData:getEquipmentType())
		local maxStr = dataType == 2 and "(MAX " .. maxValue .. ")" or "(MAX " .. maxValue / 10 .. "%)"
		equipmentltCtrl = self.tableSingleData:getEquipmentType()
		self.tableSingleData:getEquipmentType().name = name
		self.tableSingleData:getEquipmentType().value = value .. maxStr
		self.tableSingleData:getEquipmentType().color = equipDesRead.getAttrColor(quality)
		table.insert(self.tableAttrData, self.tableSingleData:getEquipmentType())
	end
	self.fields.List_attr:setNumItems(#self.tableAttrData)
end
function equipBaptizeSetDoneViewPanel:onBtnReplace()
	SoraDPlaySound()
	SoraDShowMsgBox(i18n("common_text_1384"), i18n("common_text_204"), i18n("common_text_006"), function(event)
		if event == MSGBOX_CALLBACK_YES and not tolua.isnull(self) then
			if self.idx then
				equipmentCtrl:confirmRemakeTenProperty(self.eqid, self.idx)
			else
				equipmentCtrl:confirmRemakeProperty(self.eqid)
			end
			self:close()
		end
	end)
end
function equipBaptizeSetDoneViewPanel:onBtnBack()
	SoraDPlaySound()
	self:close()
end
return equipBaptizeSetDoneViewPanel

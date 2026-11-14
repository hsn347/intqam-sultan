local itemDesRead = include("itemDesRead")
local equipDesRead = include("equipDesRead")
local equipmentltCtrl = include("equipmentltCtrl")
local equipmentCtrl = SoraDGetCtrl("equipmentCtrl")
_ENV = "equipmentCtrl"
;("equipmentCtrl")[gMaterialActionType.ALL_ACTION] = "suit_btn_text_05"
;("equipmentCtrl")[gMaterialActionType.DECOMPOSITION] = "common_text_1378"
local ("equipmentCtrl")[gMaterialActionType.COMPONE], tips = "common_text_1352", "equipmentCtrl"
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local storageBoxInfoViewPanel = class("storageBoxInfoViewPanel", baseFguiPanel)
function storageBoxInfoViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("storageBoxInfoViewPanel:ctor", self.viewName)
end
function storageBoxInfoViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function storageBoxInfoViewPanel:onInit()
	print("=======storageBoxInfoViewPanel:onInit")
	self.tableSingleData, _ENV, self.needCallBack2SDK = print, print, true
	self.fields.Button_compound:setString(i18n("common_text_1352"))
	self.fields.Button_compound:addClickListener(handler(self, self.btnCompoundClick))
	self.fields.Button_compound:setVisible(false)
	self.fields.Button_getWay:setString(i18n("common_text_1356"))
	self.fields.Button_getWay:addClickListener(handler(self, self.btnClickGetWayCallBack))
	self.fields.Button_getWay:setVisible(false)
	self.fields.List_operate:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_attr:setItemRenderer(handler(self, self.onAttrRenderer))
	self.fields.Com_material:fixPos()
	self.fields.Text_name:fixPos()
	self.fields.Text_tip:fixPos()
end
function storageBoxInfoViewPanel:onShow()
	print("=======storageBoxInfoViewPanel:onShow")
	self.type = self.param and self.param.type or gEquipMaterialType.MATERIAL
	if not self.param or not self.param.singleData then
		_ENV = self.param.singleData
	end
	self.tableSingleData = self.param.singleData
	self.isForgeInto = self.param and self.param.isForgeInto or false
	self.isOnlyShow = self.param and self.param.isOnlyShow or false
	if self.isOnlyShow then
		self.type = gEquipMaterialType.EQUIP
	end
	self.controllers.c1:setSelectedIndex(self.type - 1)
	if self.type == gEquipMaterialType.MATERIAL then
		self:showMaterial()
	elseif self.type == gEquipMaterialType.EQUIP then
		self:showEquip()
	end
end
function storageBoxInfoViewPanel:showMaterial()
	self.fields.Panel_bg:setString(i18n("common_text_777"))
	self.fields.Text_name:setString(itemDesRead.getName(self.tableSingleData.id))
	_ENV = itemDesRead.getName(self.tableSingleData.id)
	itemDesRead.getName(self.tableSingleData.id).id = self.tableSingleData.id
	itemDesRead.getName(self.tableSingleData.id).count = 0
	self.fields.Com_material:initData(itemDesRead.getName(self.tableSingleData.id))
	_ENV = itemDesRead.getName(self.tableSingleData.id)
	itemDesRead.getName(self.tableSingleData.id).count = self.tableSingleData.count
	self.fields.Text_tip:setString(i18n("common_text_1377", itemDesRead.getName(self.tableSingleData.id)))
	self.fields.Text_title:setString(i18n("common_text_001"))
	self.fields.Text_des:setString(itemDesRead.getDes(self.tableSingleData.id))
	local materialActionType = equipmentltCtrl.getMaterialActoinType(self.tableSingleData.id)
	if gMaterialActionType.NONE_ACTION == materialActionType then
		self.fields.Button_compound:setVisible(false)
		self.fields.Button_getWay:setVisible(false)
	else
		self.fields.Button_compound:setVisible(true)
		if self.isForgeInto then
			self.fields.Button_compound:setString(i18n("suit_btn_text_05"))
		else
			self.fields.Button_compound:setString(i18n(tips[materialActionType]))
		end
	end
	local viewWidth = self.view:getWidth()
	if equipmentltCtrl.getOutput(self.tableSingleData.id) then
		self.fields.Button_getWay:setVisible(true)
		self.fields.Button_compound:setPositionX(SoraDFPosX(viewWidth / 2 + 120, viewWidth))
		self.fields.Button_getWay:setPositionX(SoraDFPosX(viewWidth / 2 - 120, viewWidth))
	else
		self.fields.Button_getWay:setVisible(false)
		self.fields.Button_compound:setPositionX(viewWidth / 2)
	end
end
function storageBoxInfoViewPanel:showEquip()
	self.fields.Panel_bg:setString(i18n("common_text_1348"))
	if self.isOnlyShow then
		self.fields.List_operate:setVisible(false)
		self.tableSingleData = include("equipmentCell").new(self.tableSingleData)
	else
		self.fields.List_operate:setVisible(true)
		self.btnList, _ENV = self.fields.List_operate.setVisible, self.fields.List_operate.setVisible
		_ENV = true
		;(true).name = "Button_wear"
		;(true).title = self.tableSingleData:isWearing() and i18n("common_text_1329") or i18n("common_text_1328")
		;(true).btnStatus = true
		;(true).handle = handler(self, self.btnWearClick)
		table.insert(self.btnList, true)
		_ENV = true
		;(true).name = "Button_baptize"
		;(true).title = i18n("common_text_1341")
		;(true).btnStatus = self.tableSingleData:getEquipmentQuality() > gQualityDef.WHITE
		;(true).handle = handler(self, self.btnBaptizeClick)
		table.insert(self.btnList, true)
		local equipType = self.tableSingleData:getEquipmentType()
		local equipLv = self.tableSingleData:getEquipmentLV()
		local isSuitEquip = equipmentltCtrl.judgeSuitEquipByEid(self.tableSingleData:getEID())
		if isSuitEquip then
			equipLv = equipLv % 100
		end
		local isMaxQLV = self.tableSingleData:getEquipmentSLV() >= equipmentltCtrl.getStrengthenMaxLv(equipLv, equipType)
		_ENV = equipType
		equipType.name = "Button_intensify"
		equipType.title = i18n("common_text_1340")
		equipType.btnStatus = not isMaxQLV
		equipType.handle = handler(self, self.btnIntensifyClick)
		table.insert(self.btnList, equipType)
		if (gEquipTypeDef.EQUIP_LEGEND == equipType or gEquipTypeDef.EQUIP_NEBULA == equipType) and equipDesRead.getKingEquipConfig(self.tableSingleData:getEID()) then
			_ENV = self.tableSingleData:getEID()
			self.tableSingleData:getEID().name = "Button_refine"
			self.tableSingleData:getEID().title = i18n("equip_btn_01")
			self.tableSingleData:getEID().btnStatus = true
			self.tableSingleData:getEID().handle = handler(self, self.btnRefineClick)
			table.insert(self.btnList, self.tableSingleData:getEID())
		else
			local btnStatus = not self.tableSingleData:isWearing() and gEquipTypeDef.EQUIP_LEGEND ~= equipType and gEquipTypeDef.EQUIP_NEBULA ~= equipType
			_ENV = handler(self, self.btnRefineClick)
			handler(self, self.btnRefineClick).name = "Button_resolve"
			handler(self, self.btnRefineClick).title = i18n("common_text_1378")
			handler(self, self.btnRefineClick).btnStatus = btnStatus
			handler(self, self.btnRefineClick).handle = handler(self, self.btnResolveClick)
			table.insert(self.btnList, (handler(self, self.btnRefineClick)))
		end
		_ENV = self.btnList
		self.btnList.name = "Button_recast"
		self.btnList.title = i18n("equipment_recoin_text_0001")
		self.btnList.btnStatus = self.tableSingleData:getEquipmentSLV() >= 1
		self.btnList.handle = handler(self, self.btnRecastClick)
		table.insert(self.btnList, self.btnList)
		self.fields.List_operate:setNumItems(#self.btnList)
	end
	self.fields.Text_ename:setString(equipDesRead.getName(self.tableSingleData:getEID()))
	self.fields.Com_equip:initData(self.tableSingleData, nil, true)
	self.fields.Text_title:setString(i18n("common_text_1349"))
	self:initAttrLabel()
end
function storageBoxInfoViewPanel:onItemRenderer(index, obj)
	local btnInfo = self.btnList[index + 1]
	obj:setBtnColorIndex(btnInfo.colorEnum or 2)
	obj:setString(btnInfo.title)
	obj:setEnabled(btnInfo.btnStatus)
	obj.handle = btnInfo.handle
	if not obj.isInit then
		obj:addClickListener(function()
			obj.handle()
		end)
		obj.isInit = true
	end
end
function storageBoxInfoViewPanel:onAttrRenderer(index, obj)
	obj:initData(self.attrList[index + 1])
end
function storageBoxInfoViewPanel:initAttrLabel()

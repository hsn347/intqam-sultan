local baseFguiPanel = require("fgui.base.baseFguiPanel")
local equipLockPanel = class("equipLockPanel", baseFguiPanel)
local equipmentMgr = include("equipmentMgr")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local equipmentCtrl = SoraDGetCtrl("equipmentCtrl")
function equipLockPanel:ctor(...)
	self.isLRU = true
	equipLockPanel.super.ctor(self, ...)
	print("equipLockPanel:ctor", self.viewName)
end
function equipLockPanel:onInit()
	print("=======equipLockPanel:onInit")
	self.fields.List_equip:setVirtual()
	self.fields.List_equip:setItemRenderer(handler(self, self.itemRenderer_List_equip))
	self.fields.List_material:setVirtual()
	self.fields.List_material:setItemRenderer(handler(self, self.itemRenderer_List_material))
	self.fields.Panel_bg:setString(i18n("Safety_lock_text_32"))
	self.fields.Button_unlock:setTitle(i18n("Safety_lock_text_34"))
	self.fields.Button_unlock:addClickListener(handler(self, self.onClick_Button_unlock))
	self.fields.Button_lock:setTitle(i18n("Safety_lock_text_33"))
	self.fields.Button_lock:addClickListener(handler(self, self.onClick_Button_lock))
	self.selectMaterialMap, _ENV, self.selectEquipMap, _ENV = self.fields.Button_lock.addClickListener, self.fields.Button_lock.addClickListener, self.fields.Button_lock.addClickListener, self.fields.Button_lock.addClickListener
end
function equipLockPanel:endShow()
	print("=======equipLockPanel:endShow")
	self.type = self.param and self.param.type or gEquipMaterialType.MATERIAL
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, self.type, self.type
	;(nil).title = i18n("common_text_1350")
	_ENV, self.type[1], (nil).tag = nil, nil, gEquipMaterialType.MATERIAL
	;(nil).title = i18n("common_text_2570")
	;(nil).tabsetArray, self.type[2], (nil).tag = self.type, nil, gEquipMaterialType.EQUIP
	;(nil).callback = handler(self, self.onClickTab)
	self.fields.com_TabW:initView(nil)
end
function equipLockPanel:onClickTab(tag)
	self.type = tag
	print("=======equipLockPanel:onClickTab", self.type)
	self.controllers.view:setSelectedIndex(self.type - 1)
	self:initData()
end
function equipLockPanel:initData()
	self:updateView()
end
function equipLockPanel:updateView()
	self.selectMaterialMap, _ENV, self.selectEquipMap, _ENV = nil, nil, nil, nil
	if self.type == gEquipMaterialType.MATERIAL then
		local materialBackpack = backpackCtrl:getBackpack(gBackpackDef.MATERIAL)
		local tableMaterialData = materialBackpack:getList()
		self.tableMaterialData, _ENV = materialBackpack, materialBackpack
		for _, value in ipairs(tableMaterialData) do
			if next(value) then
				table.insert(self.tableMaterialData, value)
			end
		end
		self.fields.List_material:setNumItems(#self.tableMaterialData)
	elseif self.type == gEquipMaterialType.EQUIP then
		self.tableEquipData = equipmentMgr.getEquipmentArrayWithFiler()
		self.fields.List_equip:setNumItems(#self.tableEquipData)
	end
end
function equipLockPanel:itemRenderer_List_equip(index, obj)
	obj:initData(self.tableEquipData[index + 1], self.selectMaterialMap, handler(self, self.onLockChange))
end
function equipLockPanel:itemRenderer_List_material(index, obj)
	obj:initData(self.tableMaterialData[index + 1], self.selectEquipMap, handler(self, self.onLockChange))
end
function equipLockPanel:onLockChange(id, isSelected)
	if self.type == gEquipMaterialType.MATERIAL then
		self.selectMaterialMap[id] = isSelected
		dump(self.selectMaterialMap, "self.selectMaterialMap")
	elseif self.type == gEquipMaterialType.EQUIP then
		self.selectEquipMap[id] = isSelected
		dump(self.selectEquipMap, "self.selectEquipMap")
	end
end
function equipLockPanel:onClick_Button_lock(context)
	SoraDPlaySound()
	if self.type == gEquipMaterialType.MATERIAL then
		local _ENV, selectMaterialList = self.type, self.type
		for id, isSelected in pairs(self.selectMaterialMap) do
			if isSelected then
				table.insert(selectMaterialList, id)
			end
		end
		dump(selectMaterialList, "selectMaterialList")
		if #selectMaterialList == 0 then
			return
		end
		SoraDIsNeedOpenVerifySecondaryLock(function()
			backpackCtrl:lockItem(selectMaterialList)
			self.selectMaterialMap, backpackCtrl = backpackCtrl.lockItem, backpackCtrl.lockItem
		end)
	elseif self.type == gEquipMaterialType.EQUIP then
		local _ENV, selectEquipList = self.type, self.type
		for id, isSelected in pairs(self.selectEquipMap) do
			if isSelected then
				table.insert(selectEquipList, id)
			end
		end
		dump(selectEquipList, "selectEquipList")
		if #selectEquipList == 0 then
			return
		end
		SoraDIsNeedOpenVerifySecondaryLock(function()
			equipmentCtrl:reqEquipmentLock(selectEquipList)
			self.selectEquipMap, equipmentCtrl = equipmentCtrl.reqEquipmentLock, equipmentCtrl.reqEquipmentLock
		end)
	end
end
function equipLockPanel:onClick_Button_unlock(context)
	SoraDPlaySound()
	if self.type == gEquipMaterialType.MATERIAL then
		local _ENV, selectMaterialList = self.type, self.type
		for id, isSelected in pairs(self.selectMaterialMap) do
			if isSelected then
				table.insert(selectMaterialList, id)
			end
		end
		if #selectMaterialList == 0 then
			return
		end
		_ENV = nil
		_ENV, (nil).verHolder = i18n("Safety_lock_text_35"), i18n("Safety_lock_text_35")
		;(nil).logParam, i18n("Safety_lock_text_35").items = i18n("Safety_lock_text_35"), selectMaterialList
		SoraDCheckSecondaryLock(function()
			backpackCtrl:unlockItem(selectMaterialList)
			self.selectMaterialMap, backpackCtrl = backpackCtrl.unlockItem, backpackCtrl.unlockItem
		end, gSecondaryLockType.EquipLock, "EquipLock", nil)
	elseif self.type == gEquipMaterialType.EQUIP then
		local _ENV, selectEquipList = self.type, self.type
		for id, isSelected in pairs(self.selectEquipMap) do
			if isSelected then
				table.insert(selectEquipList, id)
			end
		end
		if #selectEquipList == 0 then
			return
		end
		_ENV = nil
		_ENV, (nil).verHolder = i18n("Safety_lock_text_35"), i18n("Safety_lock_text_35")
		;(nil).logParam, i18n("Safety_lock_text_35").items = i18n("Safety_lock_text_35"), selectEquipList
		SoraDCheckSecondaryLock(function()
			equipmentCtrl:reqEquipmentUnlock(selectEquipList)
			self.selectEquipMap, equipmentCtrl = equipmentCtrl.reqEquipmentUnlock, equipmentCtrl.reqEquipmentUnlock
		end, gSecondaryLockType.EquipLock, "EquipLock", nil)
	end
end
return equipLockPanel

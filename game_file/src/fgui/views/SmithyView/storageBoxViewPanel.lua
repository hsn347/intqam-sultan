local equipmentMgr = include("equipmentMgr")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local storageBoxViewPanel = class("storageBoxViewPanel", baseFguiPanel)
function storageBoxViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("storageBoxViewPanel:ctor", self.viewName)
end
function storageBoxViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function storageBoxViewPanel:onInit()
	print("=======storageBoxViewPanel:onInit")
	self.isHideCurrentSceneView = true
	self.tableMaterialData, _ENV, self.tableEquipData, _ENV, self.type = gEquipMaterialType.MATERIAL, gEquipMaterialType.MATERIAL, gEquipMaterialType.MATERIAL, gEquipMaterialType.MATERIAL, gEquipMaterialType.MATERIAL
	self.curMaterialID = nil
	self.curEquipID = nil
	self.fields.Com_title:initData(i18n("common_text_040"), handler(self, self.onClickClose))
	self.fields.Button_smithy:addClickListener(handler(self, self.btnSmithyClickCallBack))
	self.fields.Button_help:addClickListener(handler(self, self.OnBtnFAQClick))
	self.fields.List_material:setVirtual()
	self.fields.List_material:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_equip:setVirtual()
	self.fields.List_equip:setItemRenderer(handler(self, self.onEquipRenderer))
	self.fields.Button_resolve:setString(i18n("disassemble_fast_1"))
	self.fields.Button_resolve:addClickListener(handler(self, self.OnBtnResolveClick))
	self.fields.Button_filer:setString(i18n("gem_btn_01"))
	self.fields.Button_filer:addClickListener(handler(self, self.OnBtnFilerClick))
	self.fields.btn_equipLock:setTitle(i18n("Safety_lock_text_32"))
	self.fields.btn_equipLock:addClickListener(handler(self, self.onEquipLockClick))
	self.fields.btn_equipLock:setVisible(userSDKManager.isNeedVerify())
	self.fields.Button_resolve:fixPos()
	self.fields.Button_filer:fixPos()
end
function storageBoxViewPanel:onShow()
	print("=======storageBoxViewPanel:onShow")
	self.type = self.param and self.param.type or gEquipMaterialType.MATERIAL
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, self.type, self.type
	;(nil).title = i18n("common_text_1350")
	_ENV, self.type[1], (nil).tag = nil, nil, gEquipMaterialType.MATERIAL
	;(nil).title = i18n("common_text_2570")
	;(nil).tabsetArray, self.type[2], (nil).tag = self.type, nil, gEquipMaterialType.EQUIP
	;(nil).callback = handler(self, self.onClickTab)
	self.fields.Com_tab:initView(nil)
end
function storageBoxViewPanel:endShow()
	local dailyRemindManager = include("dailyRemindManager")
	local ctype = dailyRemindManager.REMIND_TYPE.storageBoxView
	if dailyRemindManager.checkNeedRemind(ctype) then
		local tableEquipData = equipmentMgr.getEquipmentArrayWithFiler()
		if table.nums(tableEquipData) >= equipmentMgr.getLimitNum() - 10 then
			_ENV = table.nums(tableEquipData)
			table.nums(tableEquipData).tipTitle = i18n("common_text_4605")
			_ENV = nil
			;(nil).num1 = table.nums(tableEquipData)
			;(nil).num2 = equipmentMgr.getLimitNum()
			table.nums(tableEquipData).subTipTitle = i18n("common_text_4606", nil)
			table.nums(tableEquipData).reminderTitle = i18n("coffeeCraftsman_text_27")
			local table.nums(tableEquipData).btnCallBack, param = function(reminderClick)
				if reminderClick then
					dailyRemindManager.addRemindToManager(ctype)
				end
			end, table.nums(tableEquipData)
			uiManager:show("ReminderTipBox", param)
		end
	end
end
function storageBoxViewPanel:onItemRenderer(index, obj)
	obj:initData(self.tableMaterialData[index + 1], self.curMaterialID)
end
function storageBoxViewPanel:onEquipRenderer(index, obj)
	obj:initData(self.tableEquipData[index + 1], self.curEquipID)
end
function storageBoxViewPanel:onClickTab(tag)
	self.type = tag
	self.controllers.c1:setSelectedIndex(self.type - 1)
	self:initData()
	if self.type == gEquipMaterialType.MATERIAL then
		equipmentMgr.cleanNewList()
	end
end
function storageBoxViewPanel:updateSteel(target, data)
	if data == nil or data.reslist[tostring(gIDDef.STEEL)] then
		self.fields.Text_steel:setString(string.formatnumberthousands(cityCtrl:getResCount(gIDDef.STEEL)))
	end
end
function storageBoxViewPanel:materialSelect(target, data)
	self.curMaterialID = data and data.id
	self.fields.List_material:setNumItems(#self.tableMaterialData)
end
function storageBoxViewPanel:equipSelect(target, data)
	self.curEquipID = data and data.id
	self.fields.List_equip:setNumItems(#self.tableEquipData)
end
function storageBoxViewPanel:initData()
	if self.type == gEquipMaterialType.MATERIAL then
		local materialBackpack = backpackCtrl:getBackpack(gBackpackDef.MATERIAL)
		self.tableMaterialData = materialBackpack:getList()
		local bagCapacity = backpackCtrl:getBackpack(gBackpackDef.MATERIAL):getShowUnitNum()
		if bagCapacity > #self.tableMaterialData then
			for i = #self.tableMaterialData + 1, bagCapacity do
				_ENV = nil
				table.insert(self.tableMaterialData, nil)
			end
		else
			local lineNum = math.ceil(#self.tableMaterialData / 5)
			if #self.tableMaterialData < lineNum * 5 then
				for i = #self.tableMaterialData + 1, lineNum * 5 do
					_ENV = nil
					table.insert(self.tableMaterialData, nil)
				end
			end
		end
		self.fields.List_material:setNumItems(#self.tableMaterialData)
	elseif self.type == gEquipMaterialType.EQUIP then
		self.tableEquipData = equipmentMgr.getEquipmentArrayWithFiler()
		local bagCapacity = equipmentMgr.getShowUnitNum()
		if bagCapacity > #self.tableEquipData then
			for i = #self.tableEquipData + 1, bagCapacity do
				_ENV = table.insert
				table.insert(self.tableEquipData, table.insert)
			end
		else
			local lineNum = math.ceil(#self.tableEquipData / 5)
			if #self.tableEquipData < lineNum * 5 then
				for i = #self.tableEquipData + 1, lineNum * 5 do
					_ENV = self.tableMaterialData
					table.insert(self.tableEquipData, self.tableMaterialData)
				end
			end
		end
		self.fields.List_equip:setNumItems(#self.tableEquipData)
		local retFiler = equipmentMgr:isHasEquipFiler()
		self.fields.Button_filer:setString(retFiler and i18n("gem_btn_02") or i18n("gem_btn_01"))
		self.fields.Button_filer:setBtnColorIndex(retFiler and 0 or 1)
	end
	self:updateSteel()
end
function storageBoxViewPanel:updateView(target, data)
	self.curMaterialID = nil
	self.curEquipID = nil
	if self.type == gEquipMaterialType.EQUIP then
		self:initData()
	elseif self.type == gEquipMaterialType.MATERIAL then
		self:initData()
	end
	if data.msg == "MESSAGE_SERVER_EQUIP_DISASSEMBLE_BACK" and data.err == gErrDef.Err_None and not data.noPop then
		local panel = SoraDCreatePanel("storageBoxResolveView")
		panel:initData(data.materialArray)
		panel:show()
	end
end
function storageBoxViewPanel:OnBtnFAQClick()
	SoraDPlaySound()
	userSDKManager.showFAQSection(gSDKDef.FAQSectionType.EQUIP_ALL)
end
function storageBoxViewPanel:btnSmithyClickCallBack()
	SoraDPlaySound()
	uiManager:show("smithyView")
	SoraDRemoveAllPrePanelFromManager(self)
end
function storageBoxViewPanel:OnBtnResolveClick()
	SoraDPlaySound()
	uiManager:show("Decomposition")
end
function storageBoxViewPanel:OnBtnFilerClick()
	SoraDPlaySound()
	if equipmentMgr:isHasEquipFiler() then
		equipmentMgr:resetEquipFilerType()
		self:initData()
	else
		_ENV = nil
		;(nil).settingType = 2
		uiManager:show("WarGemSettingView", nil)
	end
end
function storageBoxViewPanel:onEquipLockClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).type = self.type
	uiManager:show("equipLock", nil)
end
function storageBoxViewPanel:onHide()
	if self.type == gEquipMaterialType.EQUIP then
		equipmentMgr.cleanNewList()
	end
end
return storageBoxViewPanel

local guideCtrl = SoraDGetCtrl("guideCtrl")
local equipDesRead = include("equipDesRead")
local equipmentMgr = include("equipmentMgr")
local equipmentltCtrl = include("equipmentltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local equipMenuViewPanel = class("equipMenuViewPanel", baseFguiPanel)
function equipMenuViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("equipMenuViewPanel:ctor", self.viewName)
end
function equipMenuViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function equipMenuViewPanel:onInit()
	print("=======equipMenuViewPanel:onInit")
	_UPVALUE6_ = print
	self.equipList, _ENV, self.partCfg, print[1] = print, print, print, gEquipmentPart.WEAPON
	self.equipList, _ENV, self.partCfg, print[2] = print, print, print, gEquipmentPart.BODY
	self.equipList, _ENV, self.partCfg, print[3] = print, print, print, gEquipmentPart.HEAD
	self.equipList, _ENV, self.partCfg, print[4] = print, print, print, gEquipmentPart.LEG
	self.equipList, _ENV, self.partCfg, print[5] = print, print, print, gEquipmentPart.FOOT
	self.equipList, _ENV, self.partCfg, print[6] = print, print, print, gEquipmentPart.HAND
	self.fields.Com_title:initData(i18n("common_text_1342"), handler(self, self.onClickClose))
	self.fields.List_menu:setItemRenderer(handler(self, self.onMenuRenderer))
	self.fields.List_equip:setVirtual()
	self.fields.List_equip:setItemRenderer(handler(self, self.onEquipRenderer))
	self.fields.Button_bag:addClickListener(handler(self, self.btnBagClickCallBack))
	self.fields.Button_go:setString(i18n("common_text_477"))
	self.fields.Button_go:addClickListener(handler(self, self.btnGoClickCallBack))
	self.fields.Button_go:setVisible(false)
	self.fields.Text_des:setVisible(false)
end
function equipMenuViewPanel:onShow()
	print("=======equipMenuViewPanel:onShow")
	self.operateType = self.param.operateType
	self.part = self.param.part or gEquipmentPart.WEAPON
	if self.operateType == gEquipOperateType.ORANGE then
		self.fields.Text_title:setString(i18n("equip_text_24"))
	else
		local doingName = i18n("common_text_1339")
		if self.operateType == gEquipOperateType.BAPTIZE then
			doingName = i18n("common_text_1341")
		elseif self.operateType == gEquipOperateType.INTENSIFY then
			doingName = i18n("common_text_1340")
		end
		_ENV = i18n("equip_text_24")
		i18n("equip_text_24").doing = doingName
		self.fields.Text_title:setString(i18n("common_text_1409", i18n("equip_text_24")))
	end
	self:refreshData()
end
function equipMenuViewPanel:onIntoPanel()
	if self.isCheckForge then
		self:refreshData()
	end
end
function equipMenuViewPanel:onMenuRenderer(index, obj)
	obj:initData(self.partCfg[index + 1], self.part)
end
function equipMenuViewPanel:onEquipRenderer(index, obj)
	obj:initData(self.equipList[index + 1], self.operateType)
end
function equipMenuViewPanel:refreshData(target, data)
	self.isCheckForge = false
	if data and data.msg == "MESSAGE_SERVER_EQUIP_FORGE_FINISH" then
		self.isCheckForge = true
	end
	self.fields.List_menu:setNumItems(#self.partCfg)
	self.equipList, _ENV = self.fields.List_menu.setNumItems, self.fields.List_menu.setNumItems
	local equipData = self:getEquipData()
	for i, v in ipairs(equipData) do
		local eid = v.equipmentID or v:getEID()
		local equipCfg = equipmentltCtrl.getEquipCfg(eid)
		if equipCfg.eType ~= gEquipmentPart.RING and equipCfg.eType ~= gEquipmentPart.NECKLACE then
			table.insert(self.equipList, v)
		end
	end
	_ENV = nil
	;(nil).equip = equipDesRead.getPartName(self.part)
	self.fields.Text_des:setString(i18n("common_text_1399", nil))
	self.fields.Button_go:setVisible(#self.equipList == 0)
	self.fields.Text_des:setVisible(#self.equipList == 0)
	self.fields.List_equip:setNumItems(#self.equipList)
	self.fields.List_equip:setVisible(#self.equipList > 0)
end
function equipMenuViewPanel:getEquipData()
	local _ENV, equipData
	if self.operateType == gEquipOperateType.FORGE then
		equipData = equipmentltCtrl.getEquipmentList(self.part)
		equipData = equipmentltCtrl.filterEquipData(equipData)
		local _ENV, newEquipData = equipmentltCtrl.filterEquipData(equipData), equipmentltCtrl.filterEquipData(equipData)
		for i, v in ipairs(equipData) do
			if v.level <= SoraDGetLordLv() + 10 then
				table.insert(newEquipData, v)
			end
		end
		equipData = newEquipData
	elseif self.operateType == gEquipOperateType.ORANGE then
		equipData = equipmentltCtrl.getOrangeEquipmentList(self.part)
		equipData = equipmentltCtrl.filterEquipData(equipData)
		local _ENV, newEquipData = equipmentltCtrl.filterEquipData(equipData), equipmentltCtrl.filterEquipData(equipData)
		local higher = 0
		for i, v in ipairs(equipData) do
			if v.level >= 40 then
				if higher < 1 then
					table.insert(newEquipData, v)
				end
				if v.level > SoraDGetLordLv() then
					higher = higher + 1
				end
			end
		end
		equipData = newEquipData
	elseif self.operateType == gEquipOperateType.BAPTIZE then
		equipData = equipmentMgr.getAllEquipmentByPart(self.part)
	elseif self.operateType == gEquipOperateType.INTENSIFY then
		equipData = equipmentMgr.getAllEquipmentByPart(self.part)
	end
	return equipData
end
function equipMenuViewPanel:partSelect(target, data)
	self.part = data.part
	self:refreshData()
	self.fields.List_equip:jumpToTop()
end
function equipMenuViewPanel:btnBagClickCallBack()
	SoraDPlaySound()
	SoraDRemoveAllAfterPanelFromManager(self, true)
	uiManager:show("storageBoxView")
end
function equipMenuViewPanel:btnGoClickCallBack()
	SoraDPlaySound()
	_ENV = nil
	;(nil).operateType = gEquipOperateType.FORGE
	;(nil).part = self.part
	uiManager:show("equipMenuView", nil)
end
return equipMenuViewPanel

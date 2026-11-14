local equipmentCtrl = SoraDGetCtrl("equipmentCtrl")
local equipDesRead = include("equipDesRead")
local equipmentMgr = include("equipmentMgr")
local equipmentltCtrl = include("equipmentltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local equipWearViewPanel = class("equipWearViewPanel", baseFguiPanel)
function equipWearViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("equipWearViewPanel:ctor", self.viewName)
end
function equipWearViewPanel:onInit()
	print("=======equipWearViewPanel:onInit")
	_UPVALUE6_ = print
	self.equipList, _ENV, self.partCfg, print[1] = print, print, print, gEquipmentPart.WEAPON
	self.equipList, _ENV, self.partCfg, print[2] = print, print, print, gEquipmentPart.BODY
	self.equipList, _ENV, self.partCfg, print[3] = print, print, print, gEquipmentPart.HEAD
	self.equipList, _ENV, self.partCfg, print[4] = print, print, print, gEquipmentPart.LEG
	self.equipList, _ENV, self.partCfg, print[5] = print, print, print, gEquipmentPart.FOOT
	self.equipList, _ENV, self.partCfg, print[6] = print, print, print, gEquipmentPart.HAND
	self.fields.Com_title:initData(i18n("common_text_2570"), handler(self, self.onClickClose))
	self.fields.Text_list:setString(i18n("common_text_4747"))
	self.fields.List_menu:setItemRenderer(handler(self, self.onMenuRenderer))
	self.fields.List_equip:setVirtual()
	self.fields.List_equip:setItemRenderer(handler(self, self.onEquipRenderer))
end
function equipWearViewPanel:onShow()
	print("=======equipWearViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self.part = self.param and self.param.part or gEquipmentPart.WEAPON
	self.isWearing = self.param and self.param.isWearing or false
	self.setID = self.param and self.param.setID
	self.epid = self.param and self.param.epid
	if self.epid then
		SoraDPlaySound("equipment", 4)
		equipmentCtrl:wearEquipment(self.epid, self.part, self.setID)
	end
	self:updateView()
end
function equipWearViewPanel:initData(isWearing)
	self.isWearing = isWearing or false
	self:updateView()
end
function equipWearViewPanel:limitTimeOut(target, data)
	if data.eid and equipmentltCtrl.getEquipmentPart(data.eid) == self.part then
		self:initData(data.isWearing)
	end
end
function equipWearViewPanel:onMenuRenderer(index, obj)
	obj:initData(self.partCfg[index + 1], self.part)
end
function equipWearViewPanel:onEquipRenderer(index, obj)
	obj:initData(self.equipList[index + 1], self.part, self.setID)
end
function equipWearViewPanel:updateView()
	self.fields.List_menu:setNumItems(#self.partCfg)
	self:updateEquipList()
	local curWearEquip
	if not self.setID then
		curWearEquip = equipmentMgr.getPartEquipment(self.part)
	else
		curWearEquip = equipmentCtrl:getEquipmentSetPart(self.setID, self.part)
	end
	local operateType = curWearEquip and gEquipOperateType.REMOVE or gEquipOperateType.NOEQUIP
	self.fields.Com_special:initData(curWearEquip, operateType, self.part, self.setID)
end
function equipWearViewPanel:updateEquipList()
	self.equipList, equipmentMgr = nil, nil
	if not self.setID then
		self.equipList = equipmentMgr.getAllEquipmentByPart(self.part, true)
	else
		local equipment = equipmentCtrl:getEquipmentSetPart(self.setID, self.part)
		local filterEpid = equipment and equipment:getEPID() or nil
		self.equipList = equipmentMgr.getFilterEquipmentByPart(self.part, filterEpid)
	end
	equipmentMgr = equipmentMgr.getFilterEquipmentByPart(self.part, filterEpid)
	equipmentMgr.getFilterEquipmentByPart(self.part, filterEpid).isJump = true
	table.insert(self.equipList, (equipmentMgr.getFilterEquipmentByPart(self.part, filterEpid)))
	self.fields.List_equip:setNumItems(#self.equipList)
	self.fields.List_equip:setHeight(self.view:getHeight() - self.fields.Text_list:getPositionY() - 23)
end
function equipWearViewPanel:menuSelect(target, data)
	self.part = data.part
	self:updateView()
end
return equipWearViewPanel

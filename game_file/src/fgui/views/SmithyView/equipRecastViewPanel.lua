local equipDesRead = include("equipDesRead")
local publicRead = include("publicRead")
local equipmentltCtrl = include("equipmentltCtrl")
local equipmentCtrl = SoraDGetCtrl("equipmentCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local equipRecastViewPanel = class("equipRecastViewPanel", baseFguiPanel)
function equipRecastViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("equipRecastViewPanel:ctor", self.viewName)
end
function equipRecastViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function equipRecastViewPanel:onInit()
	print("=======equipRecastViewPanel:onInit")
	self.tableAttrLabel, _ENV = print, print
	self.fields.Panel_bg:setString(i18n("equipment_recoin_text_0001"))
	self.fields.Text_title:setString(i18n("equipment_recoin_text_0003"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_senior:setString(i18n("equipment_recoin_text_0006"))
	self.fields.Button_senior:addClickListener(handler(self, self.onBtnSenior))
	self.fields.Button_help:addClickListener(handler(self, self.onBtnHelp))
	self.fields.Com_right:fixPos()
	self.fields.Com_left:fixPos()
	self.fields.arrow:fix()
end
function equipRecastViewPanel:onShow()
	print("=======equipRecastViewPanel:onShow")
	self.equipCell = self.param.data
	self:initData()
end
function equipRecastViewPanel:onItemRenderer(index, obj)
	obj:initData(self.tableAttrLabel[index + 1])
end
function equipRecastViewPanel:initData()
	self.fields.Text_name:setString(equipDesRead.getName(self.equipCell:getEID()))
	self.fields.Com_right:initData(self.equipCell)
	local recastEquipCell = clone(self.equipCell)
	recastEquipCell:recastEquipmentSLV()
	self.fields.Com_left:initData(recastEquipCell)
	self:initAttrLabel()
	self:setItemCount()
end
function equipRecastViewPanel:initAttrLabel()

local equipmentltCtrl = include("equipmentltCtrl")
local equipDesRead = include("equipDesRead")
local equipmentMgr = include("equipmentMgr")
local itemDesRead = include("itemDesRead")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local equipmentCtrl = SoraDGetCtrl("equipmentCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local equipIntensifyViewPanel = class("equipIntensifyViewPanel", baseFguiPanel)
function equipIntensifyViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("equipIntensifyViewPanel:ctor", self.viewName)
end
function equipIntensifyViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function equipIntensifyViewPanel:onInit()
	print("=======equipIntensifyViewPanel:onInit")
	self.attrList, _ENV, self.nextSLV = print, print, 0
	self.fields.Com_title:initData(i18n("common_text_1358"), handler(self, self.onClickClose))
	self.fields.Text_attr:setString(i18n("hero_title_01"))
	self.fields.Text_need:setString(i18n("Weapon_Rune_tips_053"))
	self.fields.Usm_qh:setVisible(false)
	self.fields.Button_bag:addClickListener(handler(self, self.btnBagClickCallBack))
	self.fields.Button_help:addClickListener(handler(self, self.OnBtnFAQClick))
	self.fields.Button_recast:setString(i18n("equipment_recoin_text_0001"))
	self.fields.Button_recast:addClickListener(handler(self, self.btnRecastCallBack))
	self.fields.Button_intensify:setString(i18n("common_text_1340"))
	self.fields.Button_intensify:addClickListener(handler(self, self.btnClickCallBack))
	self.fields.Button_add:addClickListener(handler(self, self.btnBuyClickCallBack))
	self.fields.List_attr:setItemRenderer(handler(self, self.onAttrRenderer))
end
function equipIntensifyViewPanel:onShow()
	print("=======equipIntensifyViewPanel:onShow")
	self.equipCell = self.param.equipData
	self:initData()
end
function equipIntensifyViewPanel:initData(equipCell)
	self.equipCell = equipCell or self.equipCell
	self.isSuitEquip = equipmentltCtrl.judgeSuitEquipByEid(self.equipCell:getEID())
	local equipLv = self.equipCell:getEquipmentLV()
	if self.isSuitEquip then
		equipLv = equipLv % 100
	end
	self.fields.Button_recast:setEnabled(self.equipCell:getEquipmentSLV() > 0)
	self.maxSlv = equipmentltCtrl.getStrengthenMaxLv(equipLv, self.equipCell:getEquipmentType())
	if self.equipCell:getEquipmentSLV() >= self.maxSlv then
		self.nextSLV = self.maxSlv
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Com_equipTo:initData(self.equipCell)
	else
		self.nextSLV = self.equipCell:getEquipmentSLV() + 1
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Com_equipFrom:initData(self.equipCell)
		local toEquipCell = clone(self.equipCell)
		toEquipCell:setEquipmentSLV(self.nextSLV)
		self.fields.Com_equipTo:initData(toEquipCell)
	end
	self:updateSteel()
	self:updateStone()
	self:initAttrLabel()
end
function equipIntensifyViewPanel:onAttrRenderer(index, obj)
	obj:initData(self.attrList[index + 1])
end
function equipIntensifyViewPanel:initAttrLabel()

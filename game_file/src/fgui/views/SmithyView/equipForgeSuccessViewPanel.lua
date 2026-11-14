local equipDesRead = include("equipDesRead")
local equipmentltCtrl = include("equipmentltCtrl")
local settingCtrl = SoraDGetCtrl("settingCtrl")
local equipmentCtrl = SoraDGetCtrl("equipmentCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local equipForgeSuccessViewPanel = class("equipForgeSuccessViewPanel", baseFguiPanel)
function equipForgeSuccessViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("equipForgeSuccessViewPanel:ctor", self.viewName)
end
function equipForgeSuccessViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function equipForgeSuccessViewPanel:onInit()
	print("=======equipForgeSuccessViewPanel:onInit")
	self.fields.mv_wc:setAllFrameName("dh_xlwc_tbbd_%.2d.png", 1)
	self.tableBtns, _ENV, self.tableAttrData, _ENV = self.fields.mv_wc.setAllFrameName, self.fields.mv_wc.setAllFrameName, self.fields.mv_wc.setAllFrameName, self.fields.mv_wc.setAllFrameName
	self.fields.Text_title:setString(i18n("common_text_316"))
	self.fields.Text_title:enableGradient(cc.c3b(255, 255, 121), cc.c3b(197, 152, 75))
	self.fields.Text_title:enableShadow(cc.c3b(15, 6, 2), cc.size(2, -2))
	self.fields.btn_check_g:addClickListener(handler(self, self.btnIconGBack))
	self.fields.Text_share:setString(i18n("common_text_1487"))
	self.fields.btn_check_g:setVisible(false)
	self.fields.Text_share:setVisible(false)
	self.fields.Usm_1:setVisible(false)
	self.fields.List_attr:setItemRenderer(handler(self, self.onAttrRenderer))
	self.fields.List_btns:setItemRenderer(handler(self, self.onBtnsRenderer))
	self.transitions.t0:setHook("effect", function()
		self.fields.mv_wc:setPlaySettings(0, -1, 1)
		self.fields.Usm_1:play()
	end)
end
function equipForgeSuccessViewPanel:onAttrRenderer(index, obj)
	obj:initData(self.tableAttrData[index + 1])
end
function equipForgeSuccessViewPanel:onBtnsRenderer(index, obj)
	local btnInfo = self.tableBtns[index + 1]
	obj:setBtnColorIndex(btnInfo.colorEnum or 0)
	obj:setString(btnInfo.title)
	obj.handle = btnInfo.handle
	if not obj.isInit then
		obj:addClickListener(function()
			obj.handle()
		end)
		obj.isInit = true
	end
end
function equipForgeSuccessViewPanel:onShow()
	print("=======equipForgeSuccessViewPanel:onShow")
	self.tableSingleData = self.param.singleData
	self.eqid = self.tableSingleData:getEPID()
	self.isNewEquip = self.param.isNewEquip or false
	self.fields.Com_equip:initData(self.tableSingleData)
	self.fields.Com_equip:hideOther()
	local eLv = self.tableSingleData:getEquipmentLV()
	local isSuitEquip = equipmentltCtrl.judgeSuitEquipByEid(self.tableSingleData:getEID())
	if isSuitEquip then
		eLv = eLv % 100
	end
	_ENV = self.tableSingleData:getEID()
	self.tableSingleData:getEID().lv = self.tableSingleData:getEquipmentLV()
	self.tableSingleData:getEID().name = equipDesRead.getName(self.tableSingleData:getEID())
	self.fields.Text_name:setString(i18n("common_text_134", self.tableSingleData:getEID()))
	self.fields.Text_name:setColor(equipDesRead.getAttrColor(self.tableSingleData:getEquipmentQuality()))
	if self.isNewEquip and self.tableSingleData:getEquipmentQuality() >= gQualityDef.BLUE and allianceMgr:hasJoinAlliance() then
		self.fields.btn_check_g:setVisible(true)
		self.fields.Text_share:setVisible(true)
		self.fields.btn_check_g:setSelected(settingCtrl:isShareEquipmentToAllianceChat())
	else
		self.fields.btn_check_g:setVisible(false)
		self.fields.Text_share:setVisible(false)
	end
	self:initAttrLabel()
	self:initBtns()
end
function equipForgeSuccessViewPanel:initAttrLabel()

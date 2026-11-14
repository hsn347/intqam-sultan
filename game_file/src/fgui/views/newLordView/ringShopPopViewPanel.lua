local equipmentCtrl = SoraDGetCtrl("equipmentCtrl")
local equipDesRead = include("equipDesRead")
local equipmentMgr = include("equipmentMgr")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ringShopPopViewPanel = class("ringShopPopViewPanel", baseFguiPanel)
function ringShopPopViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("ringShopPopViewPanel:ctor", self.viewName)
end
function ringShopPopViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function ringShopPopViewPanel:onInit()
	print("=======ringShopPopViewPanel:onInit")
	self.fields.Text_Describe:setString(i18n("equip_text_03"))
	self.fields.Text_Tips:setString(i18n("equip_text_04"))
	self.fields.Text_Tips:setVisible(false)
	self.fields.Button_yes:setString(i18n("common_text_282"))
	self.fields.Button_yes:addClickListener(handler(self, self.btnYesClick))
end
function ringShopPopViewPanel:onShow()
	print("=======ringShopPopViewPanel:onShow")
	self.data = self.param.data
	self:initData()
end
function ringShopPopViewPanel:initData()
	self.fields.com_item:initData(self.data.id, 1)
	self.fields.Text_ShopItemName:setString(equipDesRead.getName(self.data.id))
	self.fields.Text_Tips:setVisible(equipmentMgr.getRingEquipmentHaveBuy(self.data.id))
	self.fields.Button_yes:setCostNum(self.data.price)
end
function ringShopPopViewPanel:btnYesClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).shopItemId = self.data.shopItemID
	equipmentCtrl:reqShopRing(nil)
	self:close()
end
return ringShopPopViewPanel

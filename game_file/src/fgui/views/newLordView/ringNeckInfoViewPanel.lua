local equipmentltCtrl = include("equipmentltCtrl")
local equipmentCtrl = SoraDGetCtrl("equipmentCtrl")
local equipDesRead = include("equipDesRead")
local equipmentMgr = include("equipmentMgr")
local attrltCtrl = include("attrltCtrl")
local propParser = include("propParser")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ringNeckInfoViewPanel = class("ringNeckInfoViewPanel", baseFguiPanel)
function ringNeckInfoViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("ringNeckInfoViewPanel:ctor", self.viewName)
end
function ringNeckInfoViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function ringNeckInfoViewPanel:onInit()
	print("=======ringNeckInfoViewPanel:onInit")
	self.specialList, _ENV, self.baseList, _ENV = print, print, print, print
	self.fromID = 6800301
	self.toID = 6800401
	self.fields.Text_Normal_Property:setString(i18n("equip_text_06"))
	self.fields.Text_Special_Property:setString(i18n("equip_text_07"))
	self.fields.ScrollView_Normal:setItemRenderer(handler(self, self.onNormalRenderer))
	self.fields.List_sp:setItemRenderer(handler(self, self.onSpecialRenderer))
	self.fields.Btn_operate:addClickListener(handler(self, self.btnOperateClick))
	self.fields.Btn_buy:addClickListener(handler(self, self.btnBuyClick))
	self.fields.Btn_exchange:setString(i18n("Necklace_Conversion04"))
	self.fields.Btn_exchange:addClickListener(handler(self, self.btnExchangeClick))
	self.fields.Btn_exchange:setVisible(false)
	self.fields.Btn_operate:setPositionX(self.view:getWidth() / 2)
end
function ringNeckInfoViewPanel:onNormalRenderer(index, obj)
	obj:initData(self.baseList[index + 1], true)
end
function ringNeckInfoViewPanel:onSpecialRenderer(index, obj)
	obj:initData(self.specialList[index + 1])
end
function ringNeckInfoViewPanel:onShow()
	print("=======ringNeckInfoViewPanel:onShow")
	self.data = self.param.data
	self.setID = self.param.setID
	self.buyInfo = self.param.buyInfo
	self.onlyShow = self.param.onlyShow
	self:initData()
end
function ringNeckInfoViewPanel:initData()
	self.fields.Panel_bg:setString(equipDesRead.getName(self.data:getEID()))
	self.fields.com_equip:initRingNeckLace(self.data:getEquipmentPart(), self.data)
	self.baseList = equipmentltCtrl.getEquipmentAllProperty(self.data:getEID(), self.data:getEquipmentQuality(), self.data:getEquipmentSLV())
	self.fields.ScrollView_Normal:setNumItems(#self.baseList)
	self.specialList = equipmentltCtrl.getEquipmentSpecialProperty(self.data:getEID(), self.data:getEquipmentQuality())
	if self.specialList and next(self.specialList) then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.List_sp:setNumItems(#self.specialList)
	else
		self.controllers.c1:setSelectedIndex(0)
	end
	if self.onlyShow then
		self.fields.Btn_operate:setVisible(false)
		self.fields.Btn_buy:setVisible(false)
		self.fields.Btn_exchange:setVisible(false)
	elseif self.buyInfo then
		self.fields.Btn_operate:setVisible(false)
		self.fields.Btn_buy:setVisible(true)
		self.fields.Btn_buy:initData(gIDDef.GOLD, self.buyInfo.price, self.buyInfo.originalPrice)
		self.fields.Btn_buy:setTitleTextColor(cc.c3b(255, 255, 0, 1), cc.c3b(255, 200, 0, 1))
	else
		self.fields.Btn_operate:setVisible(true)
		self.fields.Btn_buy:setVisible(false)
		self.fields.Btn_operate:setString(self.data:isWearing() and i18n("common_text_1329") or i18n("common_text_1328"))
		local isOwn = equipmentMgr.isOwnHideNecklace(self.toID)
		print("isOwn=====", isOwn, self.data:getEID(), self.fromID)
		if self.data:getEID() == self.fromID and not isOwn then
			self.fields.Btn_exchange:setVisible(true)
			self.fields.Btn_operate:setPositionX(SoraDFIsRA() and self.view:getWidth() / 2 + 120 or self.view:getWidth() / 2 - 120)
			self.fields.Btn_exchange:setPositionX(SoraDFIsRA() and self.view:getWidth() / 2 - 120 or self.view:getWidth() / 2 + 120)
		else
			self.fields.Btn_exchange:setVisible(false)
			self.fields.Btn_operate:setPositionX(self.view:getWidth() / 2)
		end
	end
end
function ringNeckInfoViewPanel:btnBuyClick()
	SoraDPlaySound()
	if SoraDEnoughGold(self.buyInfo.price) then
		_ENV, _ENV = nil, nil
		;(nil).id = self.buyInfo.ringId
		;(nil).originalPrice = self.buyInfo.originalPrice
		;(nil).price = self.buyInfo.price
		;(nil).data, (nil).shopItemID = nil, self.buyInfo.shopItemID
		uiManager:show("ringShopPopView", nil)
	end
end
function ringNeckInfoViewPanel:btnOperateClick()
	if self.data:isWearing() then
		SoraDPlaySound()
		equipmentCtrl:takeOffEquipment(self.data:getEPID(), self.data:getEquipmentPart(), self.setID)
	else
		SoraDPlaySound("equipment", 4)
		equipmentCtrl:wearEquipment(self.data:getEPID(), self.data:getEquipmentPart(), self.setID)
	end
	self:close()
end
function ringNeckInfoViewPanel:btnExchangeClick()
	SoraDPlaySound()
	if self.data:isWearing() then
		SoraDShowMsgTip(i18n("Necklace_Conversion01"))
		return
	end
	if equipmentCtrl:isEquipmentLocked(self.data:getEPID()) then
		SoraDShowMsgTip(i18n("Safety_lock_text_37"))
		return
	end
	_ENV = i18n("Safety_lock_text_37")
	i18n("Safety_lock_text_37").content = i18n("Necklace_Conversion05")
	i18n("Safety_lock_text_37").confirmFunc = function()
		equipmentCtrl:equipmentExchange(self.data:getEPID())
		self:close()
	end
	uiManager:show("MessageBox", i18n("Safety_lock_text_37"))
end
return ringNeckInfoViewPanel

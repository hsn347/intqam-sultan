local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
local luckyGiftCtrl = SoraDGetCtrl("luckyGiftCtrl")
local privilegeGiftCtrl = SoraDGetCtrl("privilegeGiftCtrl")
local shoppingCartCtrl = SoraDGetCtrl("shoppingCartCtrl")
local ladderGiftCtrl = SoraDGetCtrl("ladderGiftCtrl")
local rechargeRead = include("rechargeRead")
local privilegeGiftRead = include("privilegeGiftRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local rechargeGiftShopCarViewPanel = class("rechargeGiftShopCarViewPanel", baseFguiPanel)
function rechargeGiftShopCarViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("rechargeGiftShopCarViewPanel:ctor", self.viewName)
end
function rechargeGiftShopCarViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function rechargeGiftShopCarViewPanel:onInit()
	print("=======rechargeGiftShopCarViewPanel:onInit")
	self.giftDetail, _ENV = print, print
	self.isDeleteModel = false
	self.fields.Com_title:initData(i18n("shopping_title_01"), handler(self, self.onClickClose))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_tip:setString(i18n("shopping_text_02"))
	self.fields.Text_tip:setVisible(false)
	self.fields.Button_remove:setString(i18n("common_text_3889"))
	self.fields.Button_remove:addClickListener(handler(self, self.onRemoveBack))
	self.fields.Button_cancel:setString(i18n("common_text_185"))
	self.fields.Button_cancel:addClickListener(handler(self, self.onCancelBack))
	self.fields.Button_delete:addClickListener(handler(self, self.onDeleteBack))
	self.fields.Button_remove:fixPos()
	self.fields.Button_cancel:fixPos()
end
function rechargeGiftShopCarViewPanel:onItemRenderer(index, obj)
	obj:initData(self.giftDetail[index + 1], self.isDeleteModel, self.selectIDList)
end
function rechargeGiftShopCarViewPanel:onShow()
	print("=======rechargeGiftShopCarViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self.selectIDList, _ENV = self.fields.Com_bg.setGradientColor, self.fields.Com_bg.setGradientColor
	self:initData()
end
function rechargeGiftShopCarViewPanel:suitData(target, data)
	SoraDCloseLoading(self)
	self.giftDetail = shoppingCartCtrl:getUsefulData()
	self:initView()
end
function rechargeGiftShopCarViewPanel:initData(target, data)
	if data and data.isRemove then
		self.selectIDList, shoppingCartCtrl = data.isRemove, data.isRemove
	end
	local giftList = shoppingCartCtrl:getShoppingCartInfo()
	local shoppingCartCtrl, ridList = shoppingCartCtrl, shoppingCartCtrl
	for k, v in pairs(giftList) do
		table.insert(ridList, tonumber(k))
	end
	if 0 < #ridList then
		shoppingCartCtrl:reqShoppingCartInfo(ridList)
		SoraDShowLoading(self)
	else
		self.giftDetail, shoppingCartCtrl = SoraDShowLoading, SoraDShowLoading
		self:initView()
	end
end
function rechargeGiftShopCarViewPanel:initView()
	self.controllers.c1:setSelectedIndex(self.isDeleteModel and 1 or 0)
	if #self.giftDetail == 0 then
		self.fields.Text_tip:setVisible(true)
		self.fields.List:setVisible(false)
	else
		self.fields.Text_tip:setVisible(false)
		self.fields.List:setVisible(true)
		table.sort(self.giftDetail, function(a, b)
			if a.isInvalid and b.isInvalid then
				return a.id < b.id
			elseif not a.isInvalid and b.isInvalid then
				return true
			elseif a.isInvalid and not b.isInvalid then
				return false
			else
				return a.id < b.id
			end
		end)
		self.fields.List:setNumItems(#self.giftDetail)
	end
end
function rechargeGiftShopCarViewPanel:onRemoveBack()
	SoraDPlaySound()
	self.isDeleteModel = false
	local _ENV, selectIDList = SoraDPlaySound, SoraDPlaySound
	for k, v in pairs(self.selectIDList) do
		if v then
			table.insert(selectIDList, k)
		end
	end
	shoppingCartCtrl:reqRemoveShoppingCart(selectIDList)
end
function rechargeGiftShopCarViewPanel:delSelect(target, data)
	self.selectIDList[data.rid] = data.isDel
end
function rechargeGiftShopCarViewPanel:onCancelBack()
	SoraDPlaySound()
	self.selectIDList, _ENV, self.isDeleteModel = SoraDPlaySound, SoraDPlaySound, false
	self:initView()
end
function rechargeGiftShopCarViewPanel:onDeleteBack()
	SoraDPlaySound()
	if self.isDeleteModel then
		return
	end
	self.isDeleteModel = true
	self:initView()
end
return rechargeGiftShopCarViewPanel

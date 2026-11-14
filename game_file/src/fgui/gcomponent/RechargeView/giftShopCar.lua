local shoppingCartCtrl = SoraDGetCtrl("shoppingCartCtrl")
local baseComponent = require("fgui.base.baseComponent")
local giftShopCar = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RechargeView/giftShopCar", giftShopCar)
function giftShopCar:onInit()
	self.giftID = nil
	self.from = gRechargeGiftFrom.ACTIVITY
	self.fields.Button_touch:addClickListener(handler(self, self.onTouchBack))
	self.fields.Button_oprate:addClickListener(handler(self, self.onOprateBack))
end
function giftShopCar:onShow()
	self:initData()
end
function giftShopCar:registerEvent()
	SoraDAddMessage(self, "MESSAGE_CLIENT_RECHARGECENTER_GIFTCART", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_CLIENT_RECHARGECENTER_GIFTCART_DATA", handler(self, self.suitData))
end
function giftShopCar:initData()
	local giftNum = table.nums(shoppingCartCtrl:getShoppingCartInfo())
	self.fields.Label_reddot:initData(0 < giftNum, giftNum)
end
function giftShopCar:updateData()
	self:initData()
	self:setGiftID(self.giftID, self.from)
end
function giftShopCar:suitData()
	local showData = shoppingCartCtrl:getUsefulData()
	local ret = true
	for k, v in pairs(showData) do
		if v.id == self.giftID then
			ret = false
			break
		end
	end
	self.isCanAdd = ret and not shoppingCartCtrl:isInShoppingCart(self.giftID)
	if self.isCanAdd then
		self.fields.Button_oprate:setString(i18n("shopping_text_10"))
		self.fields.Button_oprate:getController("c1"):setSelectedIndex(0)
	else
		self.fields.Button_oprate:setString(i18n("common_text_697"))
		self.fields.Button_oprate:getController("c1"):setSelectedIndex(1)
	end
end
function giftShopCar:setGiftID(giftID, from)
	self.giftID = giftID
	self.from = from or gRechargeGiftFrom.ACTIVITY
	self.giftList = shoppingCartCtrl:getShoppingCartInfo()
	local _ENV, ridList = shoppingCartCtrl:getShoppingCartInfo(), shoppingCartCtrl:getShoppingCartInfo()
	for k, v in pairs(self.giftList) do
		table.insert(ridList, tonumber(k))
	end
	if 0 < #ridList then
		shoppingCartCtrl:reqShoppingCartInfo(ridList)
	else
		self.giftDetail, _ENV = shoppingCartCtrl.reqShoppingCartInfo, shoppingCartCtrl.reqShoppingCartInfo
		self:suitData()
	end
end
function giftShopCar:onTouchBack()
	SoraDPlaySound()
	uiManager:show("rechargeGiftShopCarView")
end
function giftShopCar:onOprateBack()
	SoraDPlaySound()
	if self.isCanAdd then
		shoppingCartCtrl:reqAddShoppingCart(self.giftID)
	else
		shoppingCartCtrl = self.giftID
		self.giftID[1] = self.giftID
		shoppingCartCtrl:reqRemoveShoppingCart(self.giftID)
	end
end
return giftShopCar

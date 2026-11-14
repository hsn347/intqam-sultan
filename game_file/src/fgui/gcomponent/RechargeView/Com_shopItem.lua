local premiumStoreCtrl = SoraDGetCtrl("premiumStoreCtrl")
local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_shopItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RechargeView/Com_shopItem", Com_shopItem)
function Com_shopItem:onInit()
	self.fields.Button_buy:addClickListener(handler(self, self.btnBuyClick))
	self.fields.Button_mask:addClickListener(handler(self, self.unlockClick))
	self:fixChildrenPos()
end
function Com_shopItem:onShow()
end
function Com_shopItem:initData(data, parent)
	self.mainData = data
	self.parent = parent
	self.fields.item:initData(self.mainData.commodityID, self.mainData.num)
	self.fields.Text_name:setString(publicRead.getName(self.mainData.commodityID))
	self.fields.Button_buy:initData(self.mainData.price, self.mainData.primeprice)
	self.fields.Button_buy:checkGold(self.mainData.price)
	self.fields.Button_buy:setBright(self.mainData.limit - self.mainData.buyCount > 0)
	if self.mainData.unlock then
		publicRead = publicRead.getName(self.mainData.commodityID)
		publicRead.getName(self.mainData.commodityID).num = self.mainData.limit - self.mainData.buyCount
		self.fields.Text_limit:setString(i18n("enjoyable_store_09", publicRead.getName(self.mainData.commodityID)))
		self.fields.Text_limit:setColor(cc.c3b(180, 170, 135))
		self.fields.Button_mask:setVisible(false)
	else
		self.fields.Text_limit:setString(i18n("enjoyable_store_03"))
		self.fields.Text_limit:setColor(cc.c3b(190, 40, 40))
		self.fields.Button_mask:setVisible(true)
	end
end
function Com_shopItem:btnBuyClick()
	SoraDPlaySound()
	if self.mainData.limit == self.mainData.buyCount then
		SoraDShowMsgTip(i18n("enjoyable_store_10"), publicRead.getIcon(self.mainData.commodityID, true))
	else
		_ENV, _ENV = publicRead.getIcon(self.mainData.commodityID, true)
		publicRead.getIcon(self.mainData.commodityID, true).id = self.mainData.commodityID
		publicRead.getIcon(self.mainData.commodityID, true).originalPrice = self.mainData.primeprice
		publicRead.getIcon(self.mainData.commodityID, true).price = self.mainData.price
		publicRead.getIcon(self.mainData.commodityID, true).cur = self.mainData.limit - self.mainData.buyCount
		_ENV, publicRead.getIcon(self.mainData.commodityID, true).itemData, publicRead.getIcon(self.mainData.commodityID, true).max = publicRead.getIcon(self.mainData.commodityID, true)
		publicRead.getIcon(self.mainData.commodityID, true).otherData, publicRead.getIcon(self.mainData.commodityID, true).maxCount = publicRead.getIcon(self.mainData.commodityID, true)
		publicRead.getIcon(self.mainData.commodityID, true).buyHandle = function(count)
			if SoraDEnoughGold(count * self.mainData.price) then
				premiumStoreCtrl:sendBuy(self.mainData.shopId, count)
				SoraDShowLoading(self.parent)
			end
		end
		uiManager:show("newShopSingleBuy", publicRead.getIcon(self.mainData.commodityID, true))
	end
end
function Com_shopItem:unlockClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).itemData = self.mainData
	uiManager:show("rechargeVipLimitBox", nil)
end
return Com_shopItem

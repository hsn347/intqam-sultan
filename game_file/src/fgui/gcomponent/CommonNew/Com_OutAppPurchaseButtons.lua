local baseComponent = require("fgui.base.baseComponent")
local Com_OutAppPurchaseButtons = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonNew/Com_OutAppPurchaseButtons", Com_OutAppPurchaseButtons)
fgui.register_extension("ui://CommonNew/Com_OutAppPurchaseButtons2", Com_OutAppPurchaseButtons)
function Com_OutAppPurchaseButtons:onInit()
	self.controllers.c1:setSelectedIndex(commonCheck.OUTAPPPURCHASE and 0 or 1)
	self:fixChildrenPos()
	self.fields.Button_itemBuy:addClickListener(handler(self, self.onClickItemBuy))
	self.fields.Button_buy:addClickListener(handler(self, self.onClickBuy))
end
function Com_OutAppPurchaseButtons:onShow()
end
function Com_OutAppPurchaseButtons:registerEvent()
	SoraDAddMessage(self, "MESSAGE_RECHARGE_EXCHANGE_REFRESH", handler(self, self.purchaseBack))
end
function Com_OutAppPurchaseButtons:initData(info)
	self.handleBuyClick = info.handleBuyClick
	self.handleItemBuyClick = info.handleItemBuyClick
	self.handlePurchaseBack = info.handlePurchaseBack
	self.handleItemBuyEx = info.handleItemBuyEx
	self.logInfo = info.logInfo
	self.giftID = info.rid
	print("self.giftID", self.giftID)
	self.nowPrice = info.nowPrice
	self.oriPrice = info.oriPrice
	self.fields.Button_buy:initData(info.nowPrice, info.oriPrice)
	if info.hideDicountLine then
		self.fields.Button_buy:hideLine(false)
	end
	self.fields.Button_itemBuy:initData(nil, nil, self.giftID)
end
function Com_OutAppPurchaseButtons:setBrightBtn(ret)
	self.fields.Button_buy:setBright(ret)
	self.fields.Button_itemBuy:setBright(ret)
end
function Com_OutAppPurchaseButtons:onClickItemBuy(button, event)
	SoraDPlaySound()
	local _ENV, param = SoraDPlaySound, SoraDPlaySound
	local show = true
	if self.handleItemBuyClick then
		show, param = self.handleItemBuyClick()
	end
	if self.handleItemBuyEx then
		self.handleItemBuyEx()
	end
	if show then
		SoraDShowH5PurchaseView(self.giftID, param, self.logInfo)
	end
end
function Com_OutAppPurchaseButtons:onClickBuy(button, event)
	if self.handleBuyClick then
		self.handleBuyClick(button, event)
	end
end
function Com_OutAppPurchaseButtons:purchaseBack(target, data)
	if self.giftID ~= data.rid then
		return
	end
	if self.handlePurchaseBack then
		self.handlePurchaseBack()
	end
end
return Com_OutAppPurchaseButtons

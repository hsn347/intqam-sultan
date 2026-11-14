local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local publicRead = include("publicRead")
local outAppPurchaseButtons = class("outAppPurchaseButtons", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("outAppPurchaseButtons")
end)
function outAppPurchaseButtons:ctor()
	self.giftID = nil
	self.Button_itemBuy = SoraDGetChildByName(self, "Button_itemBuy")
	self.Button_itemBuy:addTouchEventListener(handler(self, self.onClickItemBuy))
	_UPVALUE2_ = handler(self, self.onClickItemBuy)
	handler(self, self.onClickItemBuy)[1] = "Node_recharge"
	handler(self, self.onClickItemBuy)[2] = "Text_oriPrice"
	self.Text_ItemOriPrice = SoraDGetChildByFullPath(self.Button_itemBuy, handler(self, self.onClickItemBuy))
	self.itemNode = SoraDGetChildByName(self.Button_itemBuy, "Item_Node")
	_UPVALUE3_ = "Item_Node"
	;("Item_Node")[1] = "Node_recharge"
	;("Item_Node")[2] = "Item_Node"
	;("Item_Node")[3] = "Text_nowPrice"
	self.Text_ItemNowPrice = SoraDGetChildByFullPath(self.Button_itemBuy, "Item_Node")
	self.Text_ItemNowPrice = SoraDChangeTextToHtml(self.Text_ItemNowPrice)
	self.Button_buy = SoraDGetChildByName(self, "Button_buy")
	self.Button_buy:addTouchEventListener(handler(self, self.onClickBuy))
	_UPVALUE2_ = handler(self, self.onClickBuy)
	handler(self, self.onClickBuy)[1] = "Node_recharge"
	handler(self, self.onClickBuy)[2] = "Text_oriPrice"
	self.Text_OriPrice = SoraDGetChildByFullPath(self.Button_buy, handler(self, self.onClickBuy))
	SoraDSetTextWidthHeight(self.Text_OriPrice, self.Button_buy:getContentSize())
	_UPVALUE2_ = self.Button_buy:getContentSize()
	self.Button_buy:getContentSize()[1] = "Node_recharge"
	self.Button_buy:getContentSize()[2] = "Text_nowPrice"
	self.Text_NowPrice = SoraDGetChildByFullPath(self.Button_buy, self.Button_buy:getContentSize())
	SoraDSetTextWidthHeight(self.Text_NowPrice, self.Button_buy:getContentSize())
	_UPVALUE3_ = self.Button_buy:getContentSize()
	self.Button_buy:getContentSize()[1] = "Node_recharge"
	self.Button_buy:getContentSize()[2] = "Item_Node"
	self.Button_buy:getContentSize()[3] = "Image_gold"
	self.imgGold = SoraDGetChildByFullPath(self.Button_itemBuy, self.Button_buy:getContentSize())
	self.imgGold:loadTexture(publicRead.getIcon(TOKEN_ITEM), ccui.TextureResType.plistType)
end
function outAppPurchaseButtons:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_RECHARGE_EXCHANGE_REFRESH", handler(self, self.purchaseBack))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updateItemNum))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.updateItemNum))
end
function outAppPurchaseButtons:initData(info)
	self.handleBuyClick = info.handleBuyClick
	self.handleItemBuyClick = info.handleItemBuyClick
	self.handlePurchaseBack = info.handlePurchaseBack
	self.logInfo = info.logInfo
	self.giftID = info.rid
	print("self.giftID", self.giftID)
	self.itemNeedNum = paymentManager.rid2TokenPirce(self.giftID)
	self.nowPrice = info.nowPrice
	self.oriPrice = info.oriPrice
	self.Text_NowPrice:setString(self.nowPrice)
	if self.oriPrice then
		self.Text_OriPrice:setVisible(true)
		self.Text_OriPrice:setString(self.oriPrice)
		if info.hideDicountLine then
			_UPVALUE2_ = self.oriPrice
			self.oriPrice[1] = "Node_recharge"
			self.oriPrice[2] = "Sprite_line"
			SoraDGetChildByFullPath(self.Button_buy, self.oriPrice):setVisible(false)
		else
			_UPVALUE2_ = false
			;(false)[1] = "Node_recharge"
			;(false)[2] = "Sprite_line"
			SoraDGetChildByFullPath(self.Button_buy, false):setVisible(true)
		end
		self.Text_NowPrice:setPositionY(12)
	else
		self.Text_OriPrice:setString("")
		self.Text_OriPrice:setVisible(false)
		self.Text_NowPrice:setPositionY(0)
		_UPVALUE2_ = 0
		;(0)[1] = "Node_recharge"
		;(0)[2] = "Sprite_line"
		SoraDGetChildByFullPath(self.Button_buy, 0):setVisible(false)
	end
	self:updateItemNum()
end
function outAppPurchaseButtons:updateItemNum()
	self.itemOwnNum = backpackCtrl:getItemCount(TOKEN_ITEM)
	local nowPrice = self.itemNeedNum
	self.imgGold:setVisible(true)
	local discount = SoraDGetCtrl("rechargeExchangeCtrl"):getDiscount()
	if discount < 100 then
		nowPrice = math.ceil(discount / 100 * self.itemNeedNum)
		self.Text_ItemOriPrice:setString(SoraDConvertNumberWithUnit(self.itemNeedNum))
		self.Text_ItemOriPrice:setVisible(true)
		self.itemNode:setPositionY(12)
	else
		self.Text_ItemOriPrice:setString("")
		self.Text_ItemOriPrice:setVisible(false)
		self.itemNode:setPositionY(0)
		_UPVALUE2_ = 0
		;(0)[1] = "Node_recharge"
		;(0)[2] = "Sprite_line"
		SoraDGetChildByFullPath(self.Button_itemBuy, 0):setVisible(false)
	end
	local couponID = backpackCtrl:getRechargeGiftCoupon(nowPrice)
	if couponID then
		self.Text_ItemNowPrice:setString(i18n("common_text_4849"))
		self.Text_ItemNowPrice:setPositionX(0)
		self.imgGold:setVisible(false)
	else
		backpackCtrl = i18n("common_text_4849")
		i18n("common_text_4849").member = SoraDConvertNumberWithUnit(self.itemOwnNum)
		backpackCtrl, backpackCtrl, i18n("common_text_4849").total = nowPrice, SoraDConvertNumberWithUnit(nowPrice), SoraDConvertNumberWithUnit(nowPrice)
		backpackCtrl, SoraDConvertNumberWithUnit(nowPrice).member, nowPrice.color = nowPrice, nowPrice, nowPrice > self.itemOwnNum and "#E02B2B" or "#F1C35B"
		SoraDConvertNumberWithUnit(nowPrice).__default, nowPrice.color = nowPrice, "#F1C35B"
		self.Text_ItemNowPrice:setString(i18n_html("common_text_155", i18n("common_text_4849")))
		SoraDToCenter(self.itemNode, 5, SoraDFIsRA())
	end
end
function outAppPurchaseButtons:onClickItemBuy(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local _ENV, param = SoraDPlaySound, SoraDPlaySound
		local show = true
		if self.handleItemBuyClick then
			show, param = self.handleItemBuyClick()
		end
		if show then
			SoraDShowH5PurchaseView(self.giftID, param, self.logInfo)
		end
	end
end
function outAppPurchaseButtons:onClickBuy(button, event)
	if event == ccui.TouchEventType.ended and self.handleBuyClick then
		self.handleBuyClick(button, event)
	end
end
function outAppPurchaseButtons:purchaseBack(target, data)
	if self.giftID ~= data.rid then
		return
	end
	if self.handlePurchaseBack then
		self.handlePurchaseBack()
	end
end
function outAppPurchaseButtons:setGray(isEnable)
	self.Button_buy:setTouchEnabled(isEnable)
	self.Button_buy:setBright(isEnable)
	self.Button_itemBuy:setTouchEnabled(isEnable)
	self.Button_itemBuy:setBright(isEnable)
end
return outAppPurchaseButtons

local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local publicRead = include("publicRead")
local OAPButton = class("OAPButton", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("OAPButton")
end)
function OAPButton:ctor()
	self.giftID = nil
	self.Button_buy = SoraDGetChildByName(self, "Button_Buy")
	self.itemNode = SoraDGetChildByName(self.Button_buy, "Item_Node")
	_UPVALUE2_ = "Item_Node"
	;("Item_Node")[1] = "Node_recharge"
	;("Item_Node")[2] = "Sprite_line"
	self.spLine = SoraDGetChildByFullPath(self.Button_buy, "Item_Node")
	_UPVALUE2_ = "Item_Node"
	;("Item_Node")[1] = "Node_recharge"
	;("Item_Node")[2] = "Text_oriPrice"
	self.Text_OriPrice = SoraDGetChildByFullPath(self.Button_buy, "Item_Node")
	_UPVALUE3_ = "Item_Node"
	;("Item_Node")[1] = "Node_recharge"
	;("Item_Node")[2] = "Item_Node"
	;("Item_Node")[3] = "Text_nowPrice"
	self.Text_NowPrice = SoraDGetChildByFullPath(self.Button_buy, "Item_Node")
	self.Text_NowPrice = SoraDChangeTextToHtml(self.Text_NowPrice)
	_UPVALUE3_ = "Item_Node"
	;("Item_Node")[1] = "Node_recharge"
	;("Item_Node")[2] = "Item_Node"
	;("Item_Node")[3] = "Image_gold"
	self.imgGold = SoraDGetChildByFullPath(self.Button_buy, "Item_Node")
	self.imgGold:loadTexture(publicRead.getIcon(TOKEN_ITEM), ccui.TextureResType.plistType)
end
function OAPButton:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.updateItemNum))
end
function OAPButton:initData(info)
	self.giftID = info.rid
	print("self.giftID", self.giftID)
	self.itemNeedNum = paymentManager.rid2TokenPirce(self.giftID)
	self.payType = info.payType
	if info.payType == 1 then
		self.imgGold:setVisible(false)
		self.Button_buy:loadTextureNormal("btn_yellow_small_01.png", ccui.TextureResType.plistType)
		self.Text_NowPrice:setString(info.nowPrice)
		self.Text_NowPrice:setPositionX(0)
		if info.oriPrice then
			self.Text_OriPrice:setString(info.oriPrice)
			self.Text_OriPrice:setVisible(true)
			if info.hideDicountLine then
				self.spLine:setVisible(false)
			else
				self.spLine:setVisible(true)
			end
			if tolua.type(self.spLine) == "cc.Sprite" then
				self.itemNode:setPositionY(12)
			else
				self.itemNode:setPositionY(0)
			end
		else
			self.Text_OriPrice:setString("")
			self.Text_OriPrice:setVisible(false)
			self.itemNode:setPositionY(0)
			self.Text_OriPrice:setPositionX(0)
			self.spLine:setVisible(false)
		end
	elseif info.payType == 2 then
		self.imgGold:setVisible(true)
		self.Button_buy:loadTextureNormal("btn_green_small_01.png", ccui.TextureResType.plistType)
		self:updateItemNum()
	end
end
function OAPButton:updateItemNum()
	if self.payType ~= 2 then
		return
	end
	self.itemOwnNum = backpackCtrl:getItemCount(TOKEN_ITEM)
	local nowPrice = self.itemNeedNum
	local discount = SoraDGetCtrl("rechargeExchangeCtrl"):getDiscount()
	if discount < 100 then
		nowPrice = math.ceil(discount / 100 * self.itemNeedNum)
		self.Text_OriPrice:setVisible(true)
		self.Text_OriPrice:setString(SoraDConvertNumberWithUnit(self.itemNeedNum))
		self.spLine:setVisible(true)
		if tolua.type(self.spLine) == "cc.Sprite" then
			self.itemNode:setPositionY(12)
		else
			self.itemNode:setPositionY(0)
		end
	else
		self.Text_OriPrice:setString("")
		self.Text_OriPrice:setVisible(false)
		self.itemNode:setPositionY(0)
		self.spLine:setVisible(false)
	end
	backpackCtrl = SoraDConvertNumberWithUnit(self.itemNeedNum)
	SoraDConvertNumberWithUnit(self.itemNeedNum).member = SoraDConvertNumberWithUnit(self.itemOwnNum)
	backpackCtrl, backpackCtrl, SoraDConvertNumberWithUnit(self.itemNeedNum).total = nowPrice, SoraDConvertNumberWithUnit(nowPrice), SoraDConvertNumberWithUnit(nowPrice)
	backpackCtrl, SoraDConvertNumberWithUnit(nowPrice).member, nowPrice.color = nowPrice, nowPrice, nowPrice > self.itemOwnNum and "#E02B2B" or "#F1C35B"
	SoraDConvertNumberWithUnit(nowPrice).__default, nowPrice.color = nowPrice, "#F1C35B"
	self.Text_NowPrice:setString(i18n_html("common_text_155", SoraDConvertNumberWithUnit(self.itemNeedNum)))
	SoraDToCenter(self.itemNode, 5, SoraDFIsRA())
	local couponID = backpackCtrl:getRechargeGiftCoupon(nowPrice)
	if couponID then
		self.Text_NowPrice:setString(i18n("common_text_4849"))
		self.Text_NowPrice:setPositionX(0)
		self.imgGold:setVisible(false)
	else
		backpackCtrl = i18n("common_text_4849")
		i18n("common_text_4849").member = SoraDConvertNumberWithUnit(self.itemOwnNum)
		backpackCtrl, backpackCtrl, i18n("common_text_4849").total = nowPrice, SoraDConvertNumberWithUnit(nowPrice), SoraDConvertNumberWithUnit(nowPrice)
		backpackCtrl, SoraDConvertNumberWithUnit(nowPrice).member, nowPrice.color = nowPrice, nowPrice, nowPrice > self.itemOwnNum and "#E02B2B" or "#F1C35B"
		SoraDConvertNumberWithUnit(nowPrice).__default, nowPrice.color = nowPrice, "#F1C35B"
		self.Text_NowPrice:setString(i18n_html("common_text_155", i18n("common_text_4849")))
		SoraDToCenter(self.itemNode, 5, SoraDFIsRA())
	end
end
function OAPButton:setGray(isEnable)
	self.Button_buy:setTouchEnabled(isEnable)
	self.Button_buy:setBright(isEnable)
end
function OAPButton:addTouchEventListener(handler)
	self.Button_buy:addTouchEventListener(handler)
end
function OAPButton:setHandle(handler)
	self.Button_buy = include("commonBtnInstance").new(self.Button_buy)
	self.Button_buy:setHandle(handler)
end
return OAPButton

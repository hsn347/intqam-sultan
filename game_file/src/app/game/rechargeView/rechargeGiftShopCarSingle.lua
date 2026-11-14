local shoppingCartCtrl = SoraDGetCtrl("shoppingCartCtrl")
local MAX_AWARD_NUM = 5
local rechargeGiftShopCarSingle = class("rechargeGiftShopCarSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("rechargeGiftShopCarSingle")
	end
	return target
end)
function rechargeGiftShopCarSingle:ctor()
	self.awardArray, _ENV = nil, nil
	self.Image_bg = SoraDGetChildByName(self, "Image_bg")
	self.Image_bg:setFillType(1)
	self.Text_status = SoraDGetChildByName(self, "Text_status")
	self.Text_status:setString(i18n("shopping_text_07"))
	self.Text_status:setVisible(false)
	self.Image_shader = SoraDGetChildByName(self, "Image_shader")
	self.Image_shader:setVisible(false)
	self.Text_name = SoraDGetChildByName(self, "Text_name")
	self.Text_price = SoraDGetChildByName(self, "Text_price")
	self.Node_time = SoraDGetChildByName(self, "Node_time")
	self.Node_time:setVisible(false)
	self.Text_time = SoraDGetChildByName(self.Node_time, "Text_time")
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	self.Text_left = SoraDGetChildByName(self, "Text_left")
	self.Text_more = SoraDGetChildByName(self, "Text_more")
	SoraDDrawTextUnderLine(self.Text_more, cc.c4b(0, 190, 40, 255))
	self.Text_more:setString(i18n("common_text_486"))
	self.Text_more:setTouchEnabled(true)
	self.Text_more:setSwallowTouches(false)
	self.Text_more:setTouchScaleChangeEnabled(true)
	self.Text_more:addTouchEventListener(handler(self, self.onMoreClick))
	self.Node_items = SoraDGetChildByName(self, "Node_items")
	self.Node_select = SoraDGetChildByName(self, "Node_select")
	self.icon_g = SoraDGetChildByName(self, "icon_g")
	self.icon_g:setVisible(false)
	self.Image_touch = SoraDGetChildByName(self, "Image_touch")
	self.Image_touch = include("commonBtnInstance").new(self.Image_touch)
	self.Image_touch:setSwallowTouches(false)
	self.Image_touch:setHandle(handler(self, self.onTouchBack))
	self.Button_buy = SoraDGetChildByName(self, "Button_buy")
	self.Button_buy = include("commonBtnInstance").new(self.Button_buy)
	self.Button_buy:setSwallowTouches(false)
	self.Button_buy:setHandle(handler(self, self.onBuyBack))
	self.Button_buy:setVisible(false)
end
function rechargeGiftShopCarSingle:initData(data, otherData)
	self.data = data
	self.ownScroll = otherData.scroll
	self.view = otherData.view
	self.isDelete = otherData.isDelete
	self.selectIDList = otherData.selectIDList
	self.icon_g:setVisible(false)
	self.Image_shader:setVisible(false)
	self.Text_status:setVisible(false)
	self.Image_touch:setScroll(self.ownScroll)
	self.Button_buy:setScroll(self.ownScroll)
	self.Text_name:setString(self.data.name)
	local showPrice, isGetPrice = paymentManager.judgePrice(self.data.id, self.data.price)
	self.Text_price:setString(showPrice)
	self.Button_buy:setTitleText(showPrice)
	if self.data.leftBuy and self.data.leftBuy > 0 then
		self.Text_left:setVisible(true)
		_ENV = nil
		;(nil).num = self.data.leftBuy
		;(nil).limit = self.data.maxBuy
		self.Text_left:setString(i18n("shopping_text_03", nil))
	else
		self.Text_left:setVisible(false)
	end
	self:setShowAward()
	if self.data.leftTime and 0 < self.data.leftTime and not self.data.isInvalid and self.data.hideTime and self.data.hideTime ~= 1 then
		self.Node_time:setVisible(true)
		self.Text_time:beginTime(self.data.leftTime)
		self.Text_time:setTimeEndListener(function()
			_ENV = nil
			;(nil).msg = "MESSAGE_CLIENT_RECHARGECENTER_GIFTCART"
			SoraDSendMessage(nil)
		end)
		SoraDToCenter(self.Node_time)
	else
		self.Node_time:setVisible(false)
	end
	self.Node_select:setVisible(self.isDelete or false)
	self.Text_more:setVisible(true)
	if self.data.isInvalid then
		self.Button_buy:setVisible(false)
		self.Text_price:setVisible(true)
		self.Text_status:setVisible(true)
		self.Image_shader:setVisible(true)
		self.Text_left:setVisible(false)
		local statusStr = i18n("shopping_text_07")
		if self.data.leftBuy and self.data.leftBuy == 0 or self.data.isValidNow then
			statusStr = i18n("shopping_text_08")
		end
		self.Text_more:setVisible(false)
		self.Text_name:setColor(cc.c3b(190, 174, 134))
		self.Text_status:setString(statusStr)
	else
		self.Text_name:setColor(cc.c3b(255, 255, 255))
		self.Text_price:setVisible(self.isDelete or false)
		self.Button_buy:setVisible(not self.isDelete)
		self.Text_left:setVisible(true)
	end
	self.icon_g:setVisible(self.isDelete and self.selectIDList[self.data.id])
	self.Text_name:setPositionX(SoraDFPosX(self.isDelete and 570 or 610))
	self:updateOutAppPurchase()
end
function rechargeGiftShopCarSingle:setShowAward()
	for k, v in ipairs(self.data.rewards) do
		if not self.awardArray[k] and k <= MAX_AWARD_NUM then
			self.awardArray[k] = include("commonItemAward").new()
			self.awardArray[k]:setScale(0.8)
			self.awardArray[k]:setBaseScale(1.0)
			self.awardArray[k]:setOwnView(self.view)
			self.awardArray[k]:setOwnScroll(self.ownScroll)
			self.awardArray[k]:setPosition(SoraDFPosX(-(60 + (k - 1) * 90), 0), 0)
			self.awardArray[k]:addTo(self.Node_items)
		end
		if self.awardArray[k] then
			self.awardArray[k]:initData(v.id, v.num)
			self.awardArray[k]:setVisible(k <= MAX_AWARD_NUM)
		end
	end
	if #self.awardArray > #self.data.rewards then
		for k = #self.awardArray, #self.data.rewards + 1, -1 do
			self.awardArray[k]:setVisible(false)
		end
	end
end
function rechargeGiftShopCarSingle:onTouchBack()
	self.icon_g:setVisible(not self.icon_g:isVisible())
	_ENV = self.icon_g
	self.icon_g.msg = "MESSAGE_CLIENT_RECHARGECENTER_GIFTCART_UI_SEL"
	self.icon_g.rid = self.data.id
	self.icon_g.isDel = self.isDelete and self.icon_g:isVisible()
	SoraDSendMessage(self.icon_g)
end
function rechargeGiftShopCarSingle:onMoreClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.data.privilegeType then
			if self.data.privilegeType == 1 then
				_ENV = nil
				;(nil).privilegeType = gRechargePrivilegeType.castle
				;(nil).title = i18n("common_text_4030")
				;(nil).fromCenter = gRechargeActiveFromEnum.ROAD34
				;(nil).isSinglePage = true
				uiManager:show("MagicLampPrivilegeView", nil)
			elseif self.data.privilegeType == 2 then
				uiManager:show("vipCenterView")
			end
		else
			local panel = SoraDCreatePanel("rechargePopView")
			panel:initData(self.data.id, gRechargeActiveFromEnum.ROAD34)
			panel:show()
		end
	end
end
function rechargeGiftShopCarSingle:onBuyBack()
	print("购买=====", self.data.id)
	if device.platform == "mac" then
		local cheatCtrl = SoraDGetCtrl("cheatCtrl")
		_ENV = nil
		;(nil).command = "czbd"
		;(nil).param = tostring(self.data.id)
		cheatCtrl:reqCheat(nil, nil)
	else
		paymentManager.normalGiftBuyClassify(self.data.id)
		paymentManager.OnemtReadyBuy(self.data.id, gRechargeActiveFromEnum.ROAD34, false)
	end
end
function rechargeGiftShopCarSingle:updateOutAppPurchase()
	if self.Button_buy:isVisible() and SoraDCheckOAPIsOpen(self.data.id) then
		if not self.outAppPurchaseButtons then
			self.outAppPurchaseButtons = include("outAppPurchaseButtons").new("outAppPurchaseButtonsSmall")
			self.outAppPurchaseButtons:addTo(self.Button_buy:getParent())
			self.outAppPurchaseButtons:setPosition(cc.p(SoraDFPosX(185, 640), 50))
		end
		self.outAppPurchaseButtons:setVisible(true)
		self.Button_buy:setVisible(false)
		_ENV = false
		;(false).rid = self.data.id
		;(false).nowPrice = self.Button_buy:getTitleText()
		;(false).handleBuyClick = handler(self, self.onBuyBack)
		self.outAppPurchaseButtons:initData(false)
	elseif self.outAppPurchaseButtons then
		self.outAppPurchaseButtons:setVisible(false)
	end
end
return rechargeGiftShopCarSingle

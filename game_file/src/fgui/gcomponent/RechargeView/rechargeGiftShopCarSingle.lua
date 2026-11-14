local shoppingCartCtrl = SoraDGetCtrl("shoppingCartCtrl")
local rechargeRead = include("rechargeRead")
local privilegeGiftRead = include("privilegeGiftRead")
local baseComponent = require("fgui.base.baseComponent")
local rechargeGiftShopCarSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RechargeView/rechargeGiftShopCarSingle", rechargeGiftShopCarSingle)
function rechargeGiftShopCarSingle:onInit()
	self.itemsList, _ENV = nil, nil
	self.fields.Text_status:setString(i18n("shopping_text_07"))
	self.fields.Text_status:setVisible(false)
	self.fields.Image_shader:setVisible(false)
	self.fields.Button_more:addClickListener(handler(self, self.onMoreClick))
	self.fields.Button_buy:addClickListener(handler(self, self.onBuyBack))
	self.fields.Button_buy:setVisible(false)
	self.fields.List_items:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Check_tick:addClickListener(handler(self, self.btnTickClick))
	self:fixChildrenPos()
end
function rechargeGiftShopCarSingle:onItemRenderer(index, obj)
	obj:initData(tonumber(self.itemsList[index + 1].id), tonumber(self.itemsList[index + 1].num))
end
function rechargeGiftShopCarSingle:onShow()
end
function rechargeGiftShopCarSingle:initData(data, isDelete, selectIDList)
	self.data = data
	self.isDelete = isDelete or false
	self.fields.Text_name:setString(self.data.name)
	local giftStyle = rechargeRead.getPageViewData(self.data.id)
	if giftStyle then
		self.fields.Img_banner:setSpriteFrame(giftStyle.popBanner)
	end
	if self.data.privilegeType and self.data.privilegeType == gPrivilegeType.PRIVILEGE_GIFT_MAGIC_LAMP then
		local jinnPng = privilegeGiftRead.getMagicLampJinnPng(1)
		self.fields.Img_banner:setSpriteFrame(jinnPng)
	end
	local showPrice, isGetPrice = paymentManager.judgePrice(self.data.id, self.data.price)
	self.showPrice = showPrice
	self.fields.Text_price:setString(self.showPrice)
	self.fields.Button_buy:setString(self.showPrice)
	if self.data.leftBuy and self.data.leftBuy > 0 then
		self.fields.Text_left:setVisible(true)
		rechargeRead = nil
		;(nil).num = self.data.leftBuy
		;(nil).limit = self.data.maxBuy
		self.fields.Text_left:setString(i18n("shopping_text_03", nil))
	else
		self.fields.Text_left:setVisible(false)
	end
	self:setShowAward()
	if self.data.leftTime and 0 < self.data.leftTime and not self.data.isInvalid and self.data.hideTime and self.data.hideTime ~= 1 then
		self.fields.Lab_timer:setVisible(true)
		self.fields.Lab_timer:setTimeEndListener(function()
			_ENV = nil
			;(nil).msg = "MESSAGE_CLIENT_RECHARGECENTER_GIFTCART"
			SoraDSendMessage(nil)
		end)
		self.fields.Lab_timer:beginTime(self.data.leftTime)
	else
		self.fields.Lab_timer:setVisible(false)
	end
	self.fields.Check_tick:setVisible(self.isDelete or false)
	self.fields.Check_tick:setSelected(selectIDList[self.data.id] and true or false)
	self.fields.Button_more:setVisible(true)
	if self.data.isInvalid then
		self.fields.Button_buy:setVisible(false)
		self.fields.Text_price:setVisible(true)
		self.fields.Text_status:setVisible(true)
		self.fields.Image_shader:setVisible(true)
		self.fields.Text_left:setVisible(false)
		local statusStr = i18n("shopping_text_07")
		if self.data.leftBuy and self.data.leftBuy == 0 or self.data.isValidNow then
			statusStr = i18n("shopping_text_08")
		end
		self.fields.Button_more:setVisible(false)
		self.fields.Text_status:setString(statusStr)
	else
		self.fields.Image_shader:setVisible(false)
		self.fields.Text_status:setVisible(false)
		self.fields.Text_price:setVisible(self.isDelete or false)
		self.fields.Button_buy:setVisible(not self.isDelete)
		self.fields.Text_left:setVisible(true)
	end
	self:updateOutAppPurchase()
end
function rechargeGiftShopCarSingle:updateOutAppPurchase()
	if self.fields.Button_buy:isVisible() and SoraDCheckOAPIsOpen(self.data.id) then
		self.fields.outAppPurchaseButtons:setVisible(true)
		self.fields.Button_buy:setVisible(false)
		_ENV = false
		;(false).rid = self.data.id
		;(false).nowPrice = self.showPrice
		;(false).handleBuyClick = handler(self, self.onBuyBack)
		self.fields.outAppPurchaseButtons:initData(false)
	else
		self.fields.outAppPurchaseButtons:setVisible(false)
	end
end
function rechargeGiftShopCarSingle:setShowAward()
	self.itemsList = self.data.rewards
	self.fields.List_items:setNumItems(#self.itemsList)
end
function rechargeGiftShopCarSingle:getGiftID()
	return self.data.id
end
function rechargeGiftShopCarSingle:onBuyBack()
	SoraDPlaySound()
	paymentManager.normalGiftBuyClassify(self.data.id)
	paymentManager.OnemtReadyBuy(self.data.id, gRechargeActiveFromEnum.ROAD34, false)
end
function rechargeGiftShopCarSingle:onMoreClick()
	SoraDPlaySound()
	if self.data.privilegeType then
		if self.data.privilegeType == gPrivilegeType.PRIVILEGE_GIFT_CASTLE_LV then
			_ENV = nil
			;(nil).privilegeType = gRechargePrivilegeType.castle
			;(nil).title = i18n("common_text_4030")
			;(nil).fromCenter = gRechargeActiveFromEnum.ROAD34
			;(nil).isSinglePage = true
			uiManager:show("MagicLampPrivilegeView", nil)
		elseif self.data.privilegeType == gPrivilegeType.PRIVILEGE_GIFT_MAGIC_LAMP then
			_ENV = nil
			;(nil).privilegeType = gRechargePrivilegeType.magiclamp
			;(nil).title = i18n("common_text_4786")
			;(nil).fromCenter = gRechargeActiveFromEnum.ROAD34
			;(nil).isSinglePage = true
			uiManager:show("MagicLampPrivilegeView", nil)
		elseif self.data.privilegeType == 2 then
			uiManager:show("vipCenterView")
		end
	else
		_ENV = nil
		;(nil).id = self.data.id
		;(nil).fromCenter = gRechargeActiveFromEnum.ROAD34
		uiManager:show("rechargePopView", nil)
	end
end
function rechargeGiftShopCarSingle:btnTickClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_CLIENT_RECHARGECENTER_GIFTCART_UI_SEL"
	;(nil).rid = self.data.id
	;(nil).isDel = self.fields.Check_tick:isVisible() and self.fields.Check_tick:isSelected()
	SoraDSendMessage(nil)
end
return rechargeGiftShopCarSingle

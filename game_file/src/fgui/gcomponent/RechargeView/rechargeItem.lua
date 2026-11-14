local ITEMTYPE_NORMAL = 0
local ITEMTYPE_DAYBUY = 1
local ITEMTYPE_PURCHASE = 2
local publicRead = include("publicRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseComponent = require("fgui.base.baseComponent")
local rechargeItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RechargeView/rechargeItem", rechargeItem)
function rechargeItem:onInit()
	self.goldData, _ENV = nil, nil
	self.fields.Text_goldGive:setString(i18n("common_text_4762"))
	self.fields.Button_buy:addClickListener(handler(self, self.btnItemClick))
	self.fields.OAPButton:addClickListener(handler(self, self.btnItemClick))
	self.fields.Text_goldGive:fixPos()
	self.fields.nFirst1:fixPos()
	self.fields.nFirst1:fix()
	self.fields.Lab_hot:fixPos()
	self.fields.icon_sdb:fixPos()
	self.fields.txtSdb:fixPos()
end
function rechargeItem:onShow()
end
function rechargeItem:initData(data, payType)
	self.goldData = data
	self.payType = payType
	self.controllers.c2:setSelectedIndex(self.payType - 1)
	self.fields.txtGold:setString(string.formatnumberthousands(self.goldData.gold))
	if self.goldData.goldGive > 0 then
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Text_goldGive:setString(i18n("common_text_4762") .. "+" .. string.formatnumberthousands(self.goldData.goldGive))
	else
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Text_goldGive:setString(i18n("common_text_4762"))
	end
	self.fields.Lab_hot:setVisible(self.goldData.isHot == 1)
	self.fields.Sprite_goldIcon:setSpriteFrame("icon_coin_0" .. self.goldData.index .. ".png")
	if self.goldData.isLocked then
		self.fields.OAPButton:setVisible(false)
		self.fields.Button_buy:setString(i18n("common_text_776"))
		self.fields.Button_buy:setEnabled(false)
		self.fields.Button_buy:setVisible(true)
	elseif self.payType == 1 then
		self.fields.Button_buy:setString(self.goldData.showPrice)
		self.fields.Button_buy:setEnabled(true)
		self.fields.Button_buy:setVisible(true)
	elseif SoraDCheckOAPIsOpen(self.goldData.iid) then
		local itemOwnNum = backpackCtrl:getItemCount(TOKEN_ITEM)
		local itemNeedNum = paymentManager.rid2TokenPirce(self.goldData.iid)
		local discount = SoraDGetCtrl("rechargeExchangeCtrl"):getDiscount()
		local nowPrice = math.ceil(discount / 100 * itemNeedNum)
		local couponID = backpackCtrl:getRechargeGiftCoupon(nowPrice)
		if couponID then
			self.controllers.c2:setSelectedIndex(0)
			self.fields.OAPButton:setVisible(false)
			self.fields.Button_buy:setVisible(true)
			self.fields.Button_buy:setEnabled(true)
			self.fields.Button_buy:setString(i18n("common_text_4849"))
		else
			self.controllers.c2:setSelectedIndex(self.payType - 1)
			self.fields.OAPButton:setVisible(true)
			self.fields.OAPButton:setIcon(publicRead.getIcon(TOKEN_ITEM))
			_ENV = publicRead.getIcon(TOKEN_ITEM)
			publicRead.getIcon(TOKEN_ITEM).own = fguiHelper.getColorString(itemOwnNum >= nowPrice and "#FFFBD5" or "#BE2828", itemOwnNum)
			publicRead.getIcon(TOKEN_ITEM).price = nowPrice
			self.fields.OAPButton:setString(i18n("%{own}/%{price}", publicRead.getIcon(TOKEN_ITEM)))
		end
	else
		self.fields.Button_buy:setString(self.goldData.showPrice)
		self.fields.Button_buy:setEnabled(true)
		self.fields.Button_buy:setVisible(true)
		self.fields.OAPButton:setVisible(false)
	end
	_ENV, backpackCtrl = false, self.fields.OAPButton
	;(false).rechargeID = self.goldData.iid
	self.fields.OAPButton[1] = false
	local ret, resId, num = SoraDisShowRechargePresentNode(self.fields.OAPButton)
	if ret then
		self.controllers.c3:setSelectedIndex(1)
		self.fields.icon_sdb:setSpriteFrame(publicRead.getIcon(resId))
		self.fields.txtSdb:setString("+" .. num)
	else
		self.controllers.c3:setSelectedIndex(0)
	end
end
function rechargeItem:btnItemClick()
	SoraDPlaySound()
	if SoraDCheckOAPIsOpen(self.goldData.iid) and self.payType == ITEMTYPE_PURCHASE then
		_ENV = nil
		;(nil).fromCenter = gRechargeActiveFromEnum.ROAD08
		_ENV, (nil).isPageTurn = gRechargeActiveFromEnum.ROAD08, false
		;(nil).otherList, gRechargeActiveFromEnum.ROAD08.buyGold = gRechargeActiveFromEnum.ROAD08, true
		SoraDShowH5PurchaseView(self.goldData.iid, nil, nil)
	else
		paymentManager.normalGiftBuyClassify(self.goldData.iid)
		_ENV = gRechargeActiveFromEnum.ROAD08
		gRechargeActiveFromEnum.ROAD08.buyGold = true
		paymentManager.OnemtReadyBuy(self.goldData.iid, gRechargeActiveFromEnum.ROAD08, false, gRechargeActiveFromEnum.ROAD08)
	end
end
return rechargeItem

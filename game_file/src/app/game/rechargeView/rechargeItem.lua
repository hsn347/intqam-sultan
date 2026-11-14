local ITEMTYPE_NORMAL = 0
local ITEMTYPE_DAYBUY = 1
local ITEMTYPE_PURCHASE = 2
local RechargeItem = class("rechargeItem", function(target)
	local targetType = type(target)
	if targetType == "nil" then
		return SoraDCreateBasePanel("rechargeItem")
	elseif targetType == "userdata" then
		return SoraDCreateCloneBasePanel(target, "rechargeItem")
	else
		return target
	end
end)
function RechargeItem:ctor()
	self.scroll = nil
	self.goldData, _ENV, self.singleIsMoved = nil, nil, false
	self.btnItem = SoraDGetChildByName(self, "Button_buy")
	self.spIcon = SoraDGetChildByName(self, "Sprite_goldIcon")
	self.imgHot = SoraDGetChildByName(self, "Image_leftTopBanner")
	self.Sprite_hot = SoraDGetChildByName(self, "Sprite_hot")
	self.txtGold = SoraDGetChildByName(self, "BitmapFontLabel_gold")
	self.txtGoldGive = SoraDGetChildByName(self, "Text_goldGive")
	self.nodeGold = SoraDGetChildByName(self, "Node_addGold")
	self.Node_base = SoraDGetChildByName(self, "Node_base")
	self.frame_cell_1 = SoraDGetChildByName(self, "frame_cell_1")
	self.frame_cell_2 = SoraDGetChildByName(self, "frame_cell_2")
	self.Node_first = SoraDGetChildByName(self, "Node_first")
	self.btnItem:setSwallowTouches(false)
	self.Node_first:setVisible(false)
	self.imgHot:setFlippedX(false)
	self.Sprite_hot:setFlippedX(SoraDFIsRA())
	self.imgHot:setScaleX(SoraDFIsRA() and -1 or 1)
	self.OAPButton = SoraDGetExtendChildFromCCSByName(self, "CCS_OAPButton")
	self.OAPButton:addTouchEventListener(handler(self, self.btnItemClick))
	self.btnItem:addTouchEventListener(handler(self, self.btnItemClick))
	self.txtGoldGive = SoraDChangeTextToHtml(self.txtGoldGive)
end
function RechargeItem:initData(data, otherData)
	self.goldData = data
	self.scroll = otherData.scroll
	self.payType = otherData.payType
	self.btnItem:setTitleText(self.goldData.showPrice)
	self.nodeGold:setPositionY(-36)
	self.txtGold:setString(string.formatnumberthousands(self.goldData.gold))
	if self.goldData.goldGive > 0 then
		self.Node_first:setVisible(true)
		_ENV = string.formatnumberthousands(self.goldData.gold)
		_ENV, _ENV, string.formatnumberthousands(self.goldData.gold).num = self.goldData.goldGive, string.formatnumberthousands(self.goldData.goldGive), string.formatnumberthousands(self.goldData.goldGive)
		_ENV, string.formatnumberthousands(self.goldData.goldGive).num, self.goldData.goldGive.color = self.goldData.goldGive, self.goldData.goldGive, "#EBE53B"
		string.formatnumberthousands(self.goldData.goldGive).__default, self.goldData.goldGive.color = self.goldData.goldGive, "#E0CEA3"
		self.txtGoldGive:setString(i18n_html("shop_text_18", string.formatnumberthousands(self.goldData.gold)))
	else
		self.Node_first:setVisible(false)
		self.nodeGold:setPositionY(-56)
	end
	self.imgHot:setVisible(self.goldData.isHot == 1)
	local goldSprite = "icon_coin_0" .. self.goldData.index .. ".png"
	local judgeImage = display.newSpriteFrame(goldSprite)
	if judgeImage then
		self.spIcon:setSpriteFrame(judgeImage)
	end
	self.frame_cell_1:setSpriteFrame("frame_cz_cell_02.png")
	self.frame_cell_2:setSpriteFrame("frame_cz_cell_02.png")
	if self.goldData.type == ITEMTYPE_NORMAL then
		self.frame_cell_1:setSpriteFrame("frame_cz_cell_01.png")
		self.frame_cell_2:setSpriteFrame("frame_cz_cell_01.png")
	elseif self.goldData.type == ITEMTYPE_PURCHASE then
	elseif self.goldData.type == ITEMTYPE_DAYBUY then
	end
	if self.goldData.isLocked then
		self.btnItem:setTitleText(i18n("common_text_776"))
		self.btnItem:setTouchEnabled(false)
		self.btnItem:setBright(false)
		self.OAPButton:setVisible(false)
		self.btnItem:setVisible(true)
	else
		self.btnItem:setTouchEnabled(true)
		self.btnItem:setBright(true)
	end
	if SoraDCheckOAPIsOpen(self.goldData.iid) and not self.goldData.isLocked then
		self.OAPButton:setVisible(true)
		self.btnItem:setVisible(false)
		local itemNeedNum = paymentManager.rid2TokenPirce(self.goldData.iid)
		local discount = SoraDGetCtrl("rechargeExchangeCtrl"):getDiscount()
		local nowPrice = math.ceil(discount / 100 * itemNeedNum)
		_ENV = i18n("common_text_776")
		i18n("common_text_776").payType = self.payType
		i18n("common_text_776").rid = self.goldData.iid
		i18n("common_text_776").nowPrice = self.goldData.showPrice
		self.OAPButton:initData(i18n("common_text_776"))
	else
		self.OAPButton:setVisible(false)
		self.btnItem:setVisible(true)
	end
	_ENV, ITEMTYPE_NORMAL = true, self.btnItem
	;(true).rechargeID = self.goldData.iid
	self.btnItem[1] = true
	_G.SoraDCreateRechargePresentNode(self.btnItem, self.Node_base, cc.p(SoraDFPosX(308, 0), -108), 0.8, SoraDFPosX(2, 5))
end
function RechargeItem:btnItemClick(button, event)
	if event == ccui.TouchEventType.ended then
		if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		if SoraDCheckOAPIsOpen(self.goldData.iid) and self.payType == 2 then
			_ENV = nil
			;(nil).fromCenter = gRechargeActiveFromEnum.ROAD08
			_ENV, (nil).isPageTurn = gRechargeActiveFromEnum.ROAD08, false
			;(nil).otherList, gRechargeActiveFromEnum.ROAD08.buyGold = gRechargeActiveFromEnum.ROAD08, true
			SoraDShowH5PurchaseView(self.goldData.iid, param, nil)
		else
			paymentManager.normalGiftBuyClassify(self.goldData.iid)
			_ENV = gRechargeActiveFromEnum.ROAD08
			gRechargeActiveFromEnum.ROAD08.buyGold = true
			paymentManager.OnemtReadyBuy(self.goldData.iid, gRechargeActiveFromEnum.ROAD08, false, gRechargeActiveFromEnum.ROAD08)
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
return RechargeItem

local gametop = gModuleMgr.getObject("gametop")
local ancientReelCtrl = gametop.playertop_:getModule("ancientReelCtrl")
local ancientReelUtil = include("ancientReelUtil")
local ANCIENT_REEL_AWARD_TYPE = ancientReelUtil.ANCIENT_REEL_AWARD_TYPE
local MAX_ROW_NUM = 4
local ancientReelGift = class("ancientReelGift", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("ancientReelGift")
	end
	return target
end)
function ancientReelGift:ctor()
	self.nodeReward = SoraDGetChildByName(self, "Node_reward")
	self.nodeGold = SoraDGetChildByName(self, "Node_gold")
	self.txtGold = SoraDGetChildByName(self, "Text_gold")
	self.textTitle = SoraDGetChildByName(self, "Text_Title")
	self.textTitle:setString(i18n("activity_name_9001271"))
	self.text_oriPrice = SoraDGetChildByName(self, "Text_oriPrice")
	self.text_nowPrice = SoraDGetChildByName(self, "Text_nowPrice")
	self.nodeTitleNormal = SoraDGetChildByName(self, "Node_title_normal")
	self.nodeTitleGold = SoraDGetChildByName(self, "Node_title_gold")
	self.btnBuy = SoraDGetChildByName(self, "Bottom_Button_buy")
	self.btnBuy:setPressedActionEnabled(false)
	self.btnBuy:addTouchEventListener(handler(self, self.btnBuyClick))
	self.btnBuy:setLocalZOrder(2)
	self.single = SoraDGetChildByName(self, "Node_single")
	self.single:setVisible(false)
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_award")
	self:initData()
	_G.SoraDCreatAnimationEx(self.__cname, self, true)
end
function ancientReelGift:initData()
	self.itemList, ANCIENT_REEL_AWARD_TYPE = nil, nil
	self.itemList[ANCIENT_REEL_AWARD_TYPE.ANCIENT_REEL_AWARD_TYPE_GOLD], ANCIENT_REEL_AWARD_TYPE = nil, nil
	self.itemList[ANCIENT_REEL_AWARD_TYPE.ANCIENT_REEL_AWARD_TYPE_NORMAL], ANCIENT_REEL_AWARD_TYPE = nil, nil
	local giftData = ancientReelUtil.getRechargeGift()
	local gold = 0
	self.giftData = giftData
	if giftData then
		if not giftData.gift then
			ANCIENT_REEL_AWARD_TYPE = giftData.gift
		end
		self.itemList[ANCIENT_REEL_AWARD_TYPE.ANCIENT_REEL_AWARD_TYPE_GOLD] = giftData.gift
		gold = giftData.gold or 0
		local nowPrice = paymentManager.judgePrice(giftData.ID, giftData.price)
		self.text_nowPrice:setString(tostring(nowPrice))
		local discount = giftData.originalPrice / giftData.price
		local oriPrice = paymentManager.calculateDiscount(giftData.ID, nowPrice, discount, giftData.originalPrice)
		self.text_oriPrice:setString(tostring(oriPrice))
		self.nowPrice = nowPrice
		self.oriPrice = oriPrice
		self:updateOutAppPurchase()
	end
	self.txtGold:setString(string.formatnumberthousands(gold))
	local addAward = ancientReelUtil.addAward
	local itemGoldAward = self.itemList[ANCIENT_REEL_AWARD_TYPE.ANCIENT_REEL_AWARD_TYPE_NORMAL]
	local lv = ancientReelCtrl:getCurGoldLevel()
	ANCIENT_REEL_AWARD_TYPE = string.formatnumberthousands(gold)
	string.formatnumberthousands(gold).minlv = 0
	string.formatnumberthousands(gold).maxlv = lv
	addAward(string.formatnumberthousands(gold))
	self:initScrollList()
end
function ancientReelGift:initScrollList()
	self.scrollH = 0
	self.offsetY = nil
	self:updateScrollData()
	self:updateScrollPos()
end
local TITLE_HEIGHT = 50
local SCROLL_ITEM_HEIGHT = 120
function ancientReelGift:updateScrollPos()
	local sSize = self.scroll:getContentSize()
	local listHeight = self.scrollH + 10
	local sH = math.max(sSize.height, listHeight)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	self.nodeReward:setPositionY(sH)
end
function ancientReelGift:updateScrollData()
	for k, v in ipairs(self.itemList) do
		self:updateScrollData_imp(k, v)
	end
end
function ancientReelGift:updateScrollData_imp(taskType, itemInfo)
	local numsItem = table.nums(itemInfo)
	self:getSingle_Title(taskType, numsItem)
	if taskType == ANCIENT_REEL_AWARD_TYPE.ANCIENT_REEL_AWARD_TYPE_GOLD then
		local height = 120
		self.nodeGold:setPositionY(-self.scrollH)
		self.scrollH = self.scrollH + height
	end
	self:getSingle_AwardPanel(taskType, itemInfo)
end
function ancientReelGift:getSingle_Title(taskType, numsItem)
	local single
	if taskType == ANCIENT_REEL_AWARD_TYPE.ANCIENT_REEL_AWARD_TYPE_GOLD then
		single = self.nodeTitleGold
	else
		single = self.nodeTitleNormal
	end
	local strTitle
	if taskType == ANCIENT_REEL_AWARD_TYPE.ANCIENT_REEL_AWARD_TYPE_GOLD then
		strTitle = i18n("rechare_activename_1802")
	else
		ANCIENT_REEL_AWARD_TYPE = nil
		;(nil).num = numsItem
		strTitle = i18n("Ancient_reel_text_13", nil)
	end
	local txtScoreTitle = SoraDGetChildByName(single, "Text_score_title")
	txtScoreTitle:setString(strTitle)
	single:setPositionY(-self.scrollH)
	self.scrollH = self.scrollH + TITLE_HEIGHT
	return single
end
function ancientReelGift:getSingle_AwardPanel(taskType, itemInfo)
	local single = self.single:clone()
	single:addTo(self.nodeReward)
	single:setVisible(true)
	single:setPositionY(-self.scrollH)
	for k, v in ipairs(itemInfo) do
		local award = self:getSingle_AwardItem()
		award:initData(v.id, v.count)
		local x = (k - 1) % MAX_ROW_NUM
		local y = math.floor((k - 1) / MAX_ROW_NUM)
		local posX = SoraDFPosX(185 - x * 120, 0, 600)
		local posy = y * SCROLL_ITEM_HEIGHT
		award:setPosition(cc.p(posX, -(self.scrollH + 60 + posy)))
	end
	self.scrollH = self.scrollH + math.ceil(#itemInfo / MAX_ROW_NUM) * SCROLL_ITEM_HEIGHT
end
function ancientReelGift:getSingle_AwardItem()
	local single = include("commonItemAward").new()
	single:addTo(self.nodeReward)
	single:setVisible(true)
	single:setCascadeOpacityEnabled(true)
	single:setOwnView(self)
	local size = cc.size(55, 22)
	single:setTextWidthHeight(size)
	return single
end
function ancientReelGift:btnBuyClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.giftData then
			paymentManager.normalGiftBuyClassify(self.giftData.ID)
			paymentManager.OnemtReadyBuy(self.giftData.ID, gRechargeActiveFromEnum.ROAD13, false)
		end
		self:removeFromParent()
	end
end
function ancientReelGift:updateOutAppPurchase()
	if SoraDCheckOAPIsOpen(self.giftData.ID) then
		if not self.outAppPurchaseButtons then
			self.outAppPurchaseButtons = include("outAppPurchaseButtons").new()
			self.outAppPurchaseButtons:addTo(self.btnBuy:getParent())
			self.outAppPurchaseButtons:setPosition(cc.p(320, 135))
		end
		self.outAppPurchaseButtons:setVisible(true)
		self.btnBuy:setVisible(false)
		_ENV = false
		;(false).rid = self.giftData.ID
		;(false).nowPrice = self.nowPrice
		_ENV, (false).oriPrice = self.oriPrice, self.oriPrice
		;(false).logInfo, self.oriPrice.fromCenter = self.oriPrice, gRechargeActiveFromEnum.ROAD13
		;(false).handlePurchaseBack = handler(self, self.purchaseBack)
		;(false).handleBuyClick = handler(self, self.btnBuyClick)
		self.outAppPurchaseButtons:initData(false)
		_ENV, _UPVALUE1_ = false, self.outAppPurchaseButtons
		;(false).rechargeID = self.giftData.ID
		self.outAppPurchaseButtons[1] = false
		_G.SoraDCreateRechargeGiftNode(self.outAppPurchaseButtons, self.btnBuy:getParent(), cc.p(110, 45))
	else
		_ENV, _UPVALUE1_ = self.btnBuy:getParent(), self.outAppPurchaseButtons
		self.btnBuy:getParent().rechargeID = self.giftData.ID
		self.outAppPurchaseButtons[1] = self.btnBuy:getParent()
		_G.SoraDCreateRechargeGiftNode(self.outAppPurchaseButtons, self.btnBuy:getParent(), cc.p(110, 150))
	end
end
function ancientReelGift:purchaseBack()
	self:removeFromParent()
end
return ancientReelGift

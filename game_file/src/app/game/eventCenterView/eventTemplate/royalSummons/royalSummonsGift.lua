local gametop = gModuleMgr.getObject("gametop")
local royalSummonsCtrl = gametop.playertop_:getModule("royalSummonsCtrl")
local royalSummonsUtil = include("royalSummonsUtil")
local ROYAL_SUMMONS_AWARD_TYPE = royalSummonsUtil.ROYAL_SUMMONS_AWARD_TYPE
local MAX_ROW_NUM = 4
local royalSummonsGift = class("royalSummonsGift", function(target)
	if target == nil then
		if royalSummonsCtrl:getClassType() == 1 then
			return SoraDCreateTouchPanel("royalSummonsGift")
		else
			return SoraDCreateTouchPanel("dashToSkyGift")
		end
	end
	return target
end)
function royalSummonsGift:ctor()
	self.nodeReward = SoraDGetChildByName(self, "Node_reward")
	self.nodeGold = SoraDGetChildByName(self, "Node_gold")
	self.txtGold = SoraDGetChildByName(self, "Text_gold")
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
	self.textTitle = SoraDGetChildByName(self, "Text_Title")
	if self.textTitle then
		self.textTitle:setString(i18n("summoned_text_59"))
	end
	self:initData()
end
function royalSummonsGift:updateOutAppPurchase()
	if SoraDCheckOAPIsOpen(self.giftRid) then
		if not self.outAppPurchaseButtons then
			self.outAppPurchaseButtons = include("outAppPurchaseButtons").new()
			self.outAppPurchaseButtons:addTo(self.btnBuy:getParent())
			self.outAppPurchaseButtons:setPosition(cc.p(320, 130))
		end
		self.outAppPurchaseButtons:setVisible(true)
		self.btnBuy:setVisible(false)
		_ENV = false
		;(false).rid = self.giftRid
		;(false).nowPrice = self.nowPrice
		_ENV, (false).oriPrice = self.oriPrice, self.oriPrice
		self.oriPrice.fromCenter = gRechargeActiveFromEnum.ROAD38
		;(false).logInfo, self.oriPrice.activityID = self.oriPrice, gActivityTimeActivityID.CAVALRY_RISE_ACTIVITY
		;(false).handlePurchaseBack = handler(self, self.purchaseBack)
		;(false).handleBuyClick = handler(self, self.btnBuyClick)
		self.outAppPurchaseButtons:initData(false)
		_ENV, _UPVALUE1_ = false, self.outAppPurchaseButtons
		;(false).rechargeID = self.giftData and self.giftData.ID
		self.outAppPurchaseButtons[1] = false
		SoraDCreateRechargeGiftNode(self.outAppPurchaseButtons, self.btnBuy:getParent(), cc.p(SoraDFPosX(100, 640), self.btnBuy:getPositionY() - 100), 0.8, 1)
	else
		_ENV, _UPVALUE1_ = self.btnBuy:getParent(), self.outAppPurchaseButtons
		self.btnBuy:getParent().rechargeID = self.giftData and self.giftData.ID
		self.outAppPurchaseButtons[1] = self.btnBuy:getParent()
		local bShow = SoraDCreateRechargeGiftNode(self.outAppPurchaseButtons, self.btnBuy:getParent(), cc.p(SoraDFPosX(100, 640), self.btnBuy:getPositionY()), 0.8, 1, 380)
		if bShow then
			self.btnBuy:setPositionX(self.btnBuy:getPositionX() + 2)
		end
	end
end
function royalSummonsGift:initData()
	if royalSummonsCtrl:getClassType() == 2 then
		self:setBackGround(0)
		local cssFileName = "dashToSkyGift"
		local cssFilePath = getCCSPath(cssFileName)
		local action = cc.CSLoader:createTimeline(cssFilePath)
		action:gotoFrameAndPlay(0, 37, false)
		if action and tolua.cast(action, "cc.Action") then
			action:setFrameEventCallFunc(function(frameEventName)
				local frameEvent = frameEventName:getEvent()
				if frameEvent and frameEvent == "ActionEnd" then
					action:gotoFrameAndPlay(38, 118, true)
				end
			end)
		end
		self:runAction(action)
	end
	self.itemList, royalSummonsCtrl = "dashToSkyGift", cssFileName
	self.itemList[ROYAL_SUMMONS_AWARD_TYPE.ROYAL_SUMMONS_AWARD_TYPE_GOLD], royalSummonsCtrl = cc.CSLoader:createTimeline(cssFilePath), cc.CSLoader:createTimeline(cssFilePath)
	self.itemList[ROYAL_SUMMONS_AWARD_TYPE.ROYAL_SUMMONS_AWARD_TYPE_NORMAL], royalSummonsCtrl = cc.CSLoader:createTimeline(cssFilePath), cc.CSLoader:createTimeline(cssFilePath)
	local giftData = royalSummonsUtil.getRechargeGift()
	local gold = 0
	if giftData then
		if not giftData.gift then
			royalSummonsCtrl = giftData.gift
		end
		self.itemList[ROYAL_SUMMONS_AWARD_TYPE.ROYAL_SUMMONS_AWARD_TYPE_GOLD] = giftData.gift
		gold = giftData.gold or 0
		local nowPrice = paymentManager.judgePrice(giftData.ID, giftData.price)
		self.text_nowPrice:setString(tostring(nowPrice))
		local discount = giftData.originalPrice / giftData.price
		local oriPrice = paymentManager.calculateDiscount(giftData.ID, nowPrice, discount, giftData.originalPrice)
		self.nowPrice = nowPrice
		self.oriPrice = oriPrice
		self.giftRid = giftData.ID
		self.text_oriPrice:setString(tostring(oriPrice))
	end
	self.giftData = giftData
	self.txtGold:setString(string.formatnumberthousands(gold))
	local addAward = royalSummonsUtil.addAward
	local itemGoldAward = self.itemList[ROYAL_SUMMONS_AWARD_TYPE.ROYAL_SUMMONS_AWARD_TYPE_NORMAL]
	local lv = royalSummonsCtrl:getCurGoldLevel()
	royalSummonsCtrl = string.formatnumberthousands(gold)
	string.formatnumberthousands(gold).minlv = 0
	string.formatnumberthousands(gold).maxlv = lv
	addAward(string.formatnumberthousands(gold))
	dump(self.itemList, "self.itemList", 10)
	royalSummonsCtrl, _ENV = "self.itemList", self.itemList
	;("self.itemList").rechargeID = self.giftData.ID
	self.itemList[1] = "self.itemList"
	SoraDCreateRechargeGiftNode(self.itemList, self.btnBuy, cc.p(-45, 40))
	self:initScrollList()
	self:updateOutAppPurchase()
end
function royalSummonsGift:initScrollList()
	self.scrollH = 0
	self.offsetY = nil
	self:updateScrollData()
	self:updateScrollPos()
	if royalSummonsCtrl:getClassType() == 2 then
		self.scroll:getInnerContainer():setPositionY(-self.scroll:getInnerContainerSize().height)
		_ENV = self.scroll
		self.scroll[1] = cca.delay(0.23333333333333334)
		self.scroll[2] = cca.callFunc(function(...)
			self.scroll:scrollToTop(0.45, true)
		end)
		self.scroll[3] = cca.callFunc(function(...)
			self.scroll:scrollToTop(0.45, true)
		end)
		self:runAction(cca.seq(self.scroll))
	end
end
local TITLE_HEIGHT = 50
local SCROLL_ITEM_HEIGHT = 120
function royalSummonsGift:updateScrollPos()
	local sSize = self.scroll:getContentSize()
	local listHeight = self.scrollH + 10
	local sH = math.max(sSize.height, listHeight)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	self.nodeReward:setPositionY(sH)
end
function royalSummonsGift:updateScrollData()
	for k, v in ipairs(self.itemList) do
		self:updateScrollData_imp(k, v)
	end
end
function royalSummonsGift:updateScrollData_imp(taskType, itemInfo)
	local numsItem = table.nums(itemInfo)
	self:getSingle_Title(taskType, numsItem)
	if taskType == ROYAL_SUMMONS_AWARD_TYPE.ROYAL_SUMMONS_AWARD_TYPE_GOLD then
		local height = 120
		self.nodeGold:setPositionY(-self.scrollH)
		self.scrollH = self.scrollH + height
	end
	self:getSingle_AwardPanel(taskType, itemInfo)
end
function royalSummonsGift:getSingle_Title(taskType, numsItem)
	local single
	if taskType == ROYAL_SUMMONS_AWARD_TYPE.ROYAL_SUMMONS_AWARD_TYPE_GOLD then
		single = self.nodeTitleGold
	else
		single = self.nodeTitleNormal
	end
	local strTitle
	if taskType == ROYAL_SUMMONS_AWARD_TYPE.ROYAL_SUMMONS_AWARD_TYPE_GOLD then
		strTitle = royalSummonsCtrl:getClassType() == 1 and i18n("rechare_activename_1592") or i18n("summoned_text_57")
	else
		ROYAL_SUMMONS_AWARD_TYPE = nil
		;(nil).num = numsItem
		strTitle = royalSummonsCtrl:getClassType() == 1 and i18n("summoned_text_51") or i18n("summoned_text_58", nil)
	end
	local txtScoreTitle = SoraDGetChildByName(single, "Text_score_title")
	txtScoreTitle:setString(strTitle)
	single:setPositionY(-self.scrollH)
	self.scrollH = self.scrollH + TITLE_HEIGHT
	return single
end
function royalSummonsGift:getSingle_AwardPanel(taskType, itemInfo)
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
function royalSummonsGift:getSingle_AwardItem()
	local single = include("commonItemAward").new()
	single:addTo(self.nodeReward)
	single:setVisible(true)
	single:setCascadeOpacityEnabled(true)
	single:setOwnView(self)
	local size = cc.size(55, 22)
	single:setTextWidthHeight(size)
	return single
end
function royalSummonsGift:btnBuyClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.giftData then
			paymentManager.normalGiftBuyClassify(self.giftData.ID)
			paymentManager.OnemtReadyBuy(self.giftData.ID, gRechargeActiveFromEnum.ROAD13, false)
		end
		self:removeFromParent()
	end
end
function royalSummonsGift:purchaseBack()
	self:removeFromParent()
end
return royalSummonsGift

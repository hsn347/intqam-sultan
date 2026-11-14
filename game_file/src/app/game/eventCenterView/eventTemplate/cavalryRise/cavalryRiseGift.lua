local gametop = gModuleMgr.getObject("gametop")
local cavalryRiseCtrl = SoraDGetCtrl("cavalryRiseCtrl")
local cavalryRiseUtil = include("cavalryRiseUtil")
local CAVALRY_RISE_AWARD_TYPE = cavalryRiseUtil.CAVALRY_RISE_AWARD_TYPE
local MAX_ROW_NUM = 5
local cavalryRiseGift = class("cavalryRiseGift", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("cavalryRiseGift")
	end
	return target
end)
function cavalryRiseGift:ctor()
	self.nodeReward = SoraDGetChildByName(self, "Node_reward")
	self.Sprite_gold = SoraDGetChildByName(self, "Sprite_gold")
	self.txtGold = SoraDGetChildByName(self, "Text_gold")
	self.text_oriPrice = SoraDGetChildByName(self, "Text_oriPrice")
	self.text_nowPrice = SoraDGetChildByName(self, "Text_nowPrice")
	self.nodeTitleNow = SoraDGetChildByName(self, "Node_title_now")
	self.nodeTitleFeature = SoraDGetChildByName(self, "Node_title_feature")
	self.nodeTitleFeatureY = self.nodeTitleFeature:getPositionY()
	self.panel2 = SoraDGetChildByName(self.nodeTitleFeature, "Panel_2")
	self.panel2Height = self.panel2:getContentSize().height
	local titleNow = SoraDGetChildByName(self.nodeTitleNow, "Text_score_title")
	titleNow:setString(i18n("cavalryrise_text_09"))
	local titleWidth = titleNow:getContentSize().width
	if 180 <= titleWidth then
		local frame_cw_line_3l = SoraDGetChildByName(self, "frame_cw_line_3l")
		local frame_cw_line_3r = SoraDGetChildByName(self, "frame_cw_line_3r")
		frame_cw_line_3l:setPositionX(titleNow:getPositionX() - titleWidth / 2 - 10)
		frame_cw_line_3r:setPositionX(titleNow:getPositionX() + titleWidth / 2 + 10)
	end
	local titleFeature = SoraDGetChildByName(self.nodeTitleFeature, "Text_score_title")
	titleFeature:setString(i18n("cavalryrise_text_10"))
	self.btnBuy = SoraDGetChildByName(self, "Bottom_Button_buy")
	self.btnBuy:setPressedActionEnabled(false)
	self.btnBuy:addTouchEventListener(handler(self, self.btnBuyClick))
	self.btnBuy:setLocalZOrder(2)
	self.nodeItem1 = SoraDGetChildByName(self.nodeReward, "Node_item1")
	self.nodeItem2 = SoraDGetChildByName(self.nodeTitleFeature, "Node_item2")
	self.scroll = SoraDGetChildByName(self, "ScrollView_award")
	self.textTitle = SoraDGetChildByName(self, "Text_title")
	self.textTitle:setString(i18n("cavalryrise_text_03"))
	SoraDCreatAnimation(self.__cname, self, true)
	self:initData()
end
function cavalryRiseGift:initData()
	self.itemList, cavalryRiseUtil = nil, nil
	self.itemList[1], cavalryRiseUtil = nil, nil
	self.itemList[2], cavalryRiseUtil = nil, nil
	local giftData = cavalryRiseUtil:getGoldenRechargeGift()
	local gold = 0
	if giftData then
		if not giftData.gift then
			cavalryRiseUtil = giftData.gift
		end
		self.itemList[1] = giftData.gift
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
	cavalryRiseCtrl = string.formatnumberthousands(gold)
	string.formatnumberthousands(gold)[1] = self.Sprite_gold
	string.formatnumberthousands(gold)[2] = self.txtGold
	SoraDAlignNodeArrayOnCenterX(0, string.formatnumberthousands(gold))
	local curCavalryRiseLv = cavalryRiseCtrl:getCurLevel()
	local lvGold = cavalryRiseCtrl:getCurGoldLevel()
	local toLv = cavalryRiseCtrl:getMaxLevel() + 1
	if toLv < curCavalryRiseLv + 1 then
		toLv = curCavalryRiseLv + 1
	end
	cavalryRiseUtil = self.txtGold
	self.txtGold.minlv = lvGold + 1
	self.txtGold.maxlv = curCavalryRiseLv
	cavalryRiseUtil.addAward(self.txtGold, CAVALRY_RISE_AWARD_TYPE.CAVALRY_RISE_AWARD_TYPE_GOLD, self.itemList[1])
	cavalryRiseUtil = self.txtGold
	self.txtGold.minlv = curCavalryRiseLv + 1
	self.txtGold.maxlv = toLv
	cavalryRiseUtil.addAward(self.txtGold, CAVALRY_RISE_AWARD_TYPE.CAVALRY_RISE_AWARD_TYPE_GOLD, self.itemList[2])
	print(curCavalryRiseLv + 1, toLv, #self.itemList[2])
	self:initScrollList()
	self:updateOutAppPurchase()
end
function cavalryRiseGift:initScrollList()
	self.scrollH = 0
	self.offsetY = nil
	self:updateScrollData()
	self:updateScrollPos()
	self.scroll:getInnerContainer():setPositionY(-self.scroll:getInnerContainerSize().height)
	_UPVALUE1_ = self.scroll
	self.scroll[1] = cca.delay(0)
	self.scroll[2] = cca.callFunc(function(...)
		self.scroll:scrollToTop(0.45, true)
	end)
	self.scroll[3] = cca.callFunc(function(...)
		self.scroll:scrollToTop(0.45, true)
	end)
	self:runAction(cca.seq(self.scroll))
end
local SCROLL_ITEM_INTEVAL_X = 100
local SCROLL_ITEM_INTEVAL_Y = 105
function cavalryRiseGift:updateScrollPos()
	local line1 = math.ceil(#self.itemList[1] / MAX_ROW_NUM)
	local addH1 = (line1 - 1) * SCROLL_ITEM_INTEVAL_Y
	self.nodeTitleFeature:setPositionY(self.nodeTitleFeatureY - addH1)
	local line2 = math.ceil(#self.itemList[2] / MAX_ROW_NUM)
	local addH2 = (line2 - 1) * SCROLL_ITEM_INTEVAL_Y
	local panelHeight = self.panel2Height + addH2
	self.panel2:setContentSize(cc.size(self.panel2:getContentSize().width, panelHeight))
	self.scrollH = -(self.nodeTitleFeature:getPositionY() + self.panel2:getPositionY()) + panelHeight
	local sSize = self.scroll:getContentSize()
	local listHeight = self.scrollH + 10
	local sH = math.max(sSize.height, listHeight)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	self.nodeReward:setPositionY(sH)
end
function cavalryRiseGift:updateScrollData()
	for k, v in ipairs(self.itemList) do
		self:updateScrollData_imp(k, v)
	end
end
function cavalryRiseGift:updateScrollData_imp(taskType, itemInfo)
	self:getSingle_AwardPanel(taskType, itemInfo)
end
function cavalryRiseGift:getSingle_AwardPanel(taskType, itemInfo)
	local midX, startY, parent
	if taskType == 1 then
		midX = self.nodeItem1:getPositionX()
		startY = self.nodeItem1:getPositionY()
		parent = self.nodeReward
	else
		midX = self.nodeItem2:getPositionX()
		startY = self.nodeItem2:getPositionY()
		parent = self.nodeTitleFeature
	end
	local num_per_line = math.min(#itemInfo, MAX_ROW_NUM)
	for i, v in ipairs(itemInfo) do
		local itemAward = SoraDCreatePanel("commonItemAward")
		itemAward:setScale(0.9)
		itemAward:setVisible(true)
		itemAward:addTo(parent)
		itemAward:setScroll(self.scroll)
		itemAward:setOwnView(self)
		itemAward:initData(v.id, v.count)
		local x = (i - 1) % MAX_ROW_NUM
		local y = math.floor((i - 1) / MAX_ROW_NUM)
		local posX = midX + (num_per_line - 1) / 2 * SCROLL_ITEM_INTEVAL_X - x * SCROLL_ITEM_INTEVAL_X
		if not SoraDFIsRA() then
			posX = -posX
		end
		local posy = startY - y * SCROLL_ITEM_INTEVAL_Y
		itemAward:setPosition(cc.p(posX, posy))
	end
	self.scrollH = self.scrollH + math.ceil(#itemInfo / MAX_ROW_NUM) * SCROLL_ITEM_INTEVAL_Y
end
function cavalryRiseGift:btnBuyClick(button, type)
	print("btnBuyClick")
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.giftData then
			paymentManager.normalGiftBuyClassify(self.giftData.ID)
			paymentManager.OnemtReadyBuy(self.giftData.ID, gRechargeActiveFromEnum.ROAD38, false, nil, nil, gActivityTimeActivityID.CAVALRY_RISE_ACTIVITY)
		end
		self:removeFromParent()
	end
end
function cavalryRiseGift:updateOutAppPurchase()
	if SoraDCheckOAPIsOpen(self.giftRid) then
		if not self.outAppPurchaseButtons then
			self.outAppPurchaseButtons = include("outAppPurchaseButtons").new()
			self.outAppPurchaseButtons:addTo(self.btnBuy:getParent())
			self.outAppPurchaseButtons:setPosition(cc.p(320, 190))
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
function cavalryRiseGift:purchaseBack()
	self:removeFromParent()
end
return cavalryRiseGift

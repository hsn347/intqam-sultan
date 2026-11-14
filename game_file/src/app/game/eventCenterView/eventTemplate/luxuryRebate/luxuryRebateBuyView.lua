local luxuryRebateRead = include("luxuryRebateRead")
local luxuryRebateBuyView = class("luxuryRebateBuyView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("luxuryRebateBuyView")
	end
	return target
end)
function luxuryRebateBuyView:ctor()
	self.txtTitle = SoraDGetChildByName(self, "Text_Title")
	self.txtTitleFirst = SoraDGetChildByName(self, "Text_Title_first")
	self.imgFg = SoraDGetChildByName(self, "Image_fg")
	self.txtBuyBefore = SoraDGetChildByName(self, "Text_buy_before")
	self.txtBuyAfter = SoraDGetChildByName(self, "Text_buy_after")
	self.txtBuyNormalOne = SoraDGetChildByName(self, "Text_buy_normal_one")
	self.txtBuyNormalTwo = SoraDGetChildByName(self, "Text_buy_normal_two")
	self.txtBuyGod = SoraDGetChildByName(self, "Text_buy_god")
	self.txtTitleSecend = SoraDGetChildByName(self, "Text_Title_secend")
	self.txtAwardTitle = SoraDGetChildByName(self, "Text_AwardTitle")
	self.btnClose = SoraDGetChildByName(self, "Button_close")
	self.btnSure = SoraDGetChildByName(self, "Button_Sure")
	self.btnClose:addTouchEventListener(handler(self, self.onClickClose))
	self.btnSure:addTouchEventListener(handler(self, self.onClickSure))
	self.textGold = SoraDGetChildByName(self, "Text_Gold")
	self.btnText = SoraDGetChildByName(self, "Text_Button")
	self.nodeAward = SoraDGetChildByName(self, "Node_Award")
	self.txtTitle:setString(i18n("rechare_activename_1788"))
	self.txtTitleFirst:setString(i18n("PrideRebate_text_18"))
	self.txtBuyBefore:setString(i18n("PrideRebate_text_24"))
	self.txtBuyAfter:setString(i18n("PrideRebate_text_25"))
	self.txtBuyNormalOne:setString(i18n("PrideRebate_text_10"))
	self.txtBuyNormalTwo:setString(i18n("PrideRebate_text_10"))
	self.txtBuyGod:setString(i18n("PrideRebate_text_11"))
	self.txtTitleSecend:setString(i18n("PrideRebate_text_19"))
	self.txtAwardTitle:setString(i18n("PrideRebate_text_26"))
	self.nodeItemNormal1 = SoraDGetExtendChildFromCCSByName(self, "CCS_luxuryRebateActivityItemSingle_one")
	self.nodeItemNormal2 = SoraDGetExtendChildFromCCSByName(self, "CCS_luxuryRebateActivityItemSingle_two")
	self.nodeItemGod = SoraDGetExtendChildFromCCSByName(self, "CCS_luxuryRebateActivityItemSingle_three")
	self:initView()
	SoraDCreatAnimation("luxuryRebateBuyView", self)
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self:panelScaleAct()
end
function luxuryRebateBuyView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_LUXURY_REBATE_RECHARGE_SUCCESS", handler(self, self.purchaseBack))
	SoraDAddMessage(self, "MESSAGE_RECHARGE_PRESENT_REFRESH_ACTIVE", handler(self, self.initView))
end
function luxuryRebateBuyView:initView()
	self:initBtn()
	self:initItem()
	self:setAward()
end
function luxuryRebateBuyView:initBtn()
	local giftId = luxuryRebateRead.getGiftID()
	local price = luxuryRebateRead.getGiftPrice()
	local goldStr = paymentManager.judgePrice(giftId, price)
	self.textGold:setString(goldStr)
	self.btnText:setString(i18n("common_text_282"))
	self.nowPrice = goldStr
	self.oriPrice = i18n("common_text_282")
	self:updateOutAppPurchase()
	luxuryRebateRead, _ENV = i18n("common_text_282")
	i18n("common_text_282").rechargeID = giftId
	self[1] = i18n("common_text_282")
	SoraDCreateRechargeGiftNode(self, self.btnSure:getParent(), cc.p(SoraDFPosX(-50, 0), -598), 0.8)
end
function luxuryRebateBuyView:onClickClose(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:removeFromParent()
	end
end
local doBuyGift = function()
	paymentManager.normalGiftBuyClassify(luxuryRebateRead.getGiftID())
end
local checkNotHasTime = function()
	local gametop = gModuleMgr.getObject("gametop")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local _eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.LUXURY_REBATE_ACTIVITY)
	if _eventTime then
		return _eventTime.timerNode.timer:getRemainTime() <= (luxuryRebateRead.getBoxAwardDay() - 1) * 24 * 3600
	end
	return true
end
function luxuryRebateBuyView:onClickSure(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if checkNotHasTime() then
			SoraDShowMsgBox(i18n("PrideRebate_text_22"), i18n("common_text_204"), nil, function(type)
				if type == MSGBOX_CALLBACK_YES then
					doBuyGift()
				end
			end)
		else
			doBuyGift()
		end
	end
end
function luxuryRebateBuyView:initItem_imp(item, node)
	node:setSingleCCS("commonItemAward")
	node:initPreviewItem(item, self)
end
function luxuryRebateBuyView:initItem()
	local luxuryRebateDef = include("luxuryRebateDef")
	local day = luxuryRebateDef.MAX_DAY
	if not luxuryRebateRead.getAwardListByDay(day) then
		local _ENV, dayList = luxuryRebateRead.getAwardListByDay(day), luxuryRebateRead.getAwardListByDay(day)
	end
	local cfg = dayList[#dayList]
	if cfg then
		self:initItem_imp(cfg.awardNormal, self.nodeItemNormal1)
		self:initItem_imp(cfg.awardNormal, self.nodeItemNormal2)
		self:initItem_imp(cfg.awardGod, self.nodeItemGod)
	end
end
local MAX_ROW_NUM = 5
local WIDTH = 60
function luxuryRebateBuyView:setAward()
	self.nodeAward:removeAllChildren(true)
	local rewardList = luxuryRebateRead.getBoxAwardItem()
	local rechargePresentUtil = include("rechargePresentUtil")
	local fixData = rechargePresentUtil.fixRechargePresentData(luxuryRebateRead.getGiftID(), rewardList)
	rewardList = fixData.gift
	local num = #rewardList > MAX_ROW_NUM and MAX_ROW_NUM or #rewardList
	local width = WIDTH * (num - 1) * 0.5
	for k, v in ipairs(rewardList) do
		if k > MAX_ROW_NUM then
			break
		end
		local single = include("commonItemAward").new()
		single:setScale(0.55)
		single:setBaseScale(1.0)
		single:setOwnView(self)
		local posX = SoraDFPosX(width, 0)
		width = width - WIDTH
		single:setPosition(cc.p(posX, 10))
		single:addTo(self.nodeAward)
		if rechargePresentUtil.checkShowHighLight(v.id) then
			single:setCoolSquare()
		else
			single:hideCoolSquare()
		end
		single:initData(v.id, v.count)
	end
end
function luxuryRebateBuyView:updateOutAppPurchase()
	if SoraDCheckOAPIsOpen(luxuryRebateRead.getGiftID()) then
		if not self.outAppPurchaseButtons then
			self.outAppPurchaseButtons = include("outAppPurchaseButtons").new()
			self.outAppPurchaseButtons:addTo(self.btnSure:getParent())
			self.outAppPurchaseButtons:setPosition(cc.p(0, -670))
		end
		self.outAppPurchaseButtons:setVisible(true)
		self.btnSure:setVisible(false)
		_ENV = false
		;(false).rid = luxuryRebateRead.getGiftID()
		;(false).nowPrice = self.nowPrice
		;(false).oriPrice = self.oriPrice
		;(false).hideDicountLine = true
		;(false).handlePurchaseBack = handler(self, self.purchaseBack)
		;(false).handleBuyClick = handler(self, self.onClickSure)
		self.outAppPurchaseButtons:initData(false)
	end
end
function luxuryRebateBuyView:purchaseBack()
	SoraDCloseLoading(self)
	SoraDRemoveAllAfterPanelFromManager(self)
end
return luxuryRebateBuyView

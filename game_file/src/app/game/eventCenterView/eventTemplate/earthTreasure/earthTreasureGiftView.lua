local rechargeRead = include("rechargeRead")
local earthTreasureCtrl = SoraDGetCtrl("earthTreasureCtrl")
local earthTreasureRead = include("earthTreasureRead")
local earthTreasureGiftView = class("earthTreasureGiftView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("earthTreasureGiftView")
end)
function earthTreasureGiftView:ctor(properties)
	self.textDiscount = SoraDGetChildByName(self, "Text_Discount")
	self.Panel_touch = SoraDGetChildByName(self, "Panel_touch")
	self.nodeAward = SoraDGetChildByName(self, "Node_Award")
	self.btnYes = SoraDGetChildByName(self, "Button_yes")
	self.btnYes:addTouchEventListener(handler(self, self.btnYesClick))
	self.nodeRecharge = SoraDGetChildByName(self.btnYes, "Node_recharge")
	self.textOriPrice = SoraDGetChildByName(self.nodeRecharge, "Text_oriPrice")
	self.textNowPrice = SoraDGetChildByName(self.nodeRecharge, "Text_nowPrice")
	self:initData()
end
function earthTreasureGiftView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_REFRESH_EARTH_TREASURE_CLOSEGIFT", handler(self, self.msgCallBack))
end
function earthTreasureGiftView:initData()
	local giftInfo = earthTreasureRead.getGiftInfoByIndex(earthTreasureCtrl:getCurGiftIndex())
	self.curGiftID = giftInfo.package
	local info = rechargeRead.getPageViewData(self.curGiftID)
	SoraDGetChildByName(self, "Text_Title"):setString(i18n(giftInfo.name))
	self.textDiscount:setString(giftInfo.discount[2] .. "%")
	print("self.curGiftID", self.curGiftID)
	local showPrice, isGetPrice = paymentManager.judgePrice(self.curGiftID, giftInfo.price)
	self.textNowPrice:setString(showPrice)
	local discount = tonumber(giftInfo.price) > 0 and tonumber(giftInfo.originalPrice) / tonumber(giftInfo.price)
	local oriShowPrice = paymentManager.calculateDiscount(self.curGiftID, showPrice, discount, giftInfo.originalPrice)
	self.textOriPrice:setString(oriShowPrice)
	self.nowPrice = showPrice
	self.oriPrice = oriShowPrice
	rechargeRead = oriShowPrice
	oriShowPrice[1] = "id"
	oriShowPrice[2] = "count"
	local rewards = serviceFunctions.tableFormat(giftInfo.rewards, oriShowPrice)
	for i, v in ipairs(rewards) do
		local single = include("commonItemAward").new()
		single:addTo(self.nodeAward)
		single:setBaseScale(0.8)
		single:setPosition(0, 0)
		single:setOwnView(self)
		single:initData(v.id, v.count)
		if giftInfo.highlight then
			for _, v in ipairs(giftInfo.highlight) do
				if v == i then
					single:showNewCoolSquare()
					single:setCoolSquareScale(0.79)
				end
			end
		end
	end
	SoraDToCenter(self.nodeAward, 100)
	self:updateOutAppPurchase()
end
function earthTreasureGiftView:btnYesClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		SoraDShowLoading()
		earthTreasureCtrl:reqEarthTreasureBuy()
		self:removeFromParent()
	end
end
function earthTreasureGiftView:msgCallBack(target, data)
	self:removeFromParent()
end
function earthTreasureGiftView:updateOutAppPurchase()
	if SoraDCheckOAPIsOpen(self.curGiftID) then
		if not self.outAppPurchaseButtons then
			self.outAppPurchaseButtons = include("outAppPurchaseButtons").new()
			self.outAppPurchaseButtons:addTo(self.Panel_touch)
			self.outAppPurchaseButtons:setPosition(cc.p(320, 70))
		end
		self.outAppPurchaseButtons:setVisible(true)
		self.btnYes:setVisible(false)
		_ENV = false
		;(false).rid = self.curGiftID
		;(false).nowPrice = self.nowPrice
		;(false).oriPrice = self.oriPrice
		;(false).handlePurchaseBack = handler(self, self.msgCallBack)
		;(false).handleBuyClick = handler(self, self.btnYesClick)
		self.outAppPurchaseButtons:initData(false)
	end
end
return earthTreasureGiftView

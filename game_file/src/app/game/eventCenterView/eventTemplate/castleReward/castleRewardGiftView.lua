local castleRewardCtrl = SoraDGetCtrl("castleRewardCtrl")
local castleRewardRead = include("castleRewardRead")
local castleRewardGiftView = class("castleRewardGiftView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("castleRewardGiftView")
end)
function castleRewardGiftView:ctor(properties)
	self.nodeCommonPopBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.nodeCommonPopBox:setTitleName(i18n("cityUp_title_01"))
	self.textTips = SoraDGetChildByName(self, "Text_Tips")
	self.textTips:setString(i18n("cityUp_text_04"))
	self.nodeAward = SoraDGetChildByName(self, "Node_Award")
	self.textTips1 = SoraDGetChildByName(self, "Text_Tips_1")
	self.textTips1:setString(i18n("cityUp_text_05"))
	self.textTips2 = SoraDGetChildByName(self, "Text_Tips_2")
	self.textTips2:setString(i18n("Promise_Summit_text_41"))
	self.nodeAward_2 = SoraDGetChildByName(self, "Node_Award_2")
	self.btn_buy = SoraDGetChildByName(self, "Button_receive")
	self.btn_buy:addTouchEventListener(handler(self, self.btnBuyClick))
	self.tmpItem = SoraDGetChildByName(self, "Node_Item")
	SoraDRechargeBtnEffect(self.btn_buy)
	SoraDAddMessage(self, "MESSAGE_CASTLE_REWARD_INIT", handler(self, self.reInit))
	self:initData()
end
function castleRewardGiftView:reInit(target, data)
	if castleRewardCtrl:getIsBuy() then
		self:removeFromParent()
	end
end
function castleRewardGiftView:initData()
	dump(castleRewardRead.getShowRewards(), "castleRewardRead.getShowRewards()")
	_UPVALUE3_ = "castleRewardRead.getShowRewards()"
	;("castleRewardRead.getShowRewards()")[1] = "id"
	;("castleRewardRead.getShowRewards()")[2] = "count"
	;("castleRewardRead.getShowRewards()")[3] = "lv"
	local rewards = serviceFunctions.tableFormat(castleRewardRead.getShowRewards(), "castleRewardRead.getShowRewards()")
	for i, v in ipairs(rewards) do
		local newItem = self.tmpItem:clone()
		newItem:setScale(0.8)
		local item = include("commonItemAward").new(SoraDGetChildByName(newItem, "Item"))
		item:setBaseScale(1)
		item:setOwnView(self)
		item:initData(v.id, v.count)
		local lvString = SoraDGetChildByName(newItem, "Text_lv")
		lvString:setString("Lv:" .. v.lv)
		newItem:addTo(self.nodeAward)
	end
	if SoraDFIsRA() then
		SoraDautoSortPos(self.nodeAward, 5, 2, cc.size(88, 108), SoraDFIsRA())
	else
		SoraDautoSortPos(self.nodeAward, 5, 0, cc.size(88, 108), SoraDFIsRA())
	end
	local giftData = castleRewardCtrl:getGiftData()
	if not giftData or not giftData.gift then
		return
	end
	self.giftData = giftData
	self.text_price = SoraDGetChildByName(self, "Text_price")
	local price = paymentManager.judgePrice(self.giftData.ID, self.giftData.price)
	self.text_price:setString(price)
	self.text_buy_desc = SoraDGetChildByName(self, "Text_buy_desc")
	self.text_buy_desc:setString(i18n("cityUp_title_01"))
	self.nowPrice = price
	self.oriPrice = i18n("cityUp_title_01")
	castleRewardCtrl = giftData.gift
	giftData.gift[1] = "id"
	giftData.gift[2] = "count"
	local goldRewards = serviceFunctions.tableFormat(SoraDStringsSplit(giftData.gift, ","), giftData.gift)
	for i, v in ipairs(goldRewards) do
		local item = include("commonItemAward").new()
		item:addTo(self.nodeAward_2)
		item:setBaseScale(1)
		item:setScale(0.8)
		item:setOwnView(self)
		item:initData(v.id, v.count)
	end
	SoraDautoSortPos(self.nodeAward_2, 5, 1, cc.size(88, 88), SoraDFIsRA())
	self:updateOutAppPurchase()
end
function castleRewardGiftView:btnBuyClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		paymentManager.normalGiftBuyClassify(self.giftData.ID)
	end
end
function castleRewardGiftView:updateOutAppPurchase()
	if SoraDCheckOAPIsOpen(self.giftData.ID) then
		if not self.outAppPurchaseButtons then
			self.outAppPurchaseButtons = include("outAppPurchaseButtons").new()
			self.outAppPurchaseButtons:addTo(self.btn_buy:getParent())
			self.outAppPurchaseButtons:setPosition(cc.p(0, -248))
		end
		self.outAppPurchaseButtons:setVisible(true)
		self.btn_buy:setVisible(false)
		_ENV = false
		;(false).rid = self.giftData.ID
		;(false).nowPrice = self.nowPrice
		;(false).oriPrice = self.oriPrice
		;(false).hideDicountLine = true
		;(false).handlePurchaseBack = handler(self, self.reInit)
		;(false).handleBuyClick = handler(self, self.btnBuyClick)
		self.outAppPurchaseButtons:initData(false)
	end
end
return castleRewardGiftView

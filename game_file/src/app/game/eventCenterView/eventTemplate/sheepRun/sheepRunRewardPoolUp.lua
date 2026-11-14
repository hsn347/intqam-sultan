local sheepRunCtrl = SoraDGetCtrl("sheepRunCtrl")
local sheepRunRead = include("sheepRunRead")
local sheepRunRewardPoolUp = class("sheepRunRewardPoolUp", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("sheepRunRewardPoolUp")
end)
function sheepRunRewardPoolUp:ctor(properties)
	_UPVALUE3_ = nil
	self.poolNames, (nil)[1] = nil, "runningSheep_text_04"
	self.poolNames, (nil)[2] = nil, "runningSheep_text_03"
	self.poolNames, (nil)[3] = nil, "runningSheep_text_02"
	self.nodeCommonPopBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.nodeCommonPopBox:setTitleName(i18n("runningSheep_text_05"))
	self.tmpItem = SoraDGetChildByName(self, "Node_Item")
	self.text_price = SoraDGetChildByName(self, "Text_price")
	self.text_buy_desc = SoraDGetChildByName(self, "Text_buy_desc")
	self.text_desc = SoraDGetChildByName(self, "Text_12")
	self.text_desc:setString(i18n("runningSheep_text_07"))
	self.btn_buy = SoraDGetChildByName(self, "Button_receive")
	self.btn_buy:addTouchEventListener(handler(self, self.btnBuyClick))
	self.cur_pool = sheepRunCtrl:getCurPool()
	self.text_cur = SoraDGetChildByName(self, "Text_Tips_2")
	self.text_cur:setString(i18n("remains_text_196"))
	self.node_cur_pool = SoraDGetChildByName(self, "Node_cur_pool")
	self:initData()
	local giftData = sheepRunCtrl:getGiftData()
	if not giftData or not giftData.gift then
		return
	end
	self.giftData = giftData
	local price = paymentManager.judgePrice(self.giftData.ID, self.giftData.price)
	self.text_price:setString(price)
	local items = SoraDStringSplit(self.giftData.gift, ",")
	self.Text_icon_num = SoraDGetChildByName(self, "Text_icon_num")
	self.Text_icon_num:setString("X" .. items[2])
	_ENV = i18n("remains_text_196")
	i18n("remains_text_196").name = i18n(self.poolNames[self.cur_pool + 1])
	self.text_buy_desc:setString(i18n("runningSheep_text_24", i18n("remains_text_196")))
	if self.cur_pool ~= 2 then
		SoraDGetChildByName(self, "image_left"):setVisible(false)
		SoraDGetChildByName(self, "image_right"):setVisible(false)
	end
	self.nowPrice = price
	self:updateOutAppPurchase()
	if not SoraDFIsRA() then
		local Image_35 = SoraDGetChildByName(self, "Image_35")
		if Image_35 then
			Image_35:setFlippedX(true)
		end
	end
end
function sheepRunRewardPoolUp:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SHEEP_RUN_INIT", handler(self, self.reInit))
end
function sheepRunRewardPoolUp:reInit(target, data)
	if self.cur_pool ~= sheepRunCtrl:getCurPool() then
		self:removeFromParent()
	end
end
function sheepRunRewardPoolUp:setItems(nodeAward, rewards, idx)
	for i, v in ipairs(rewards) do
		local newItem = self.tmpItem:clone()
		newItem:setScale(0.8)
		local item = include("commonItemAward").new(SoraDGetChildByName(newItem, "Item"))
		item:setBaseScale(1)
		item:setOwnView(self)
		item:initData(v.item, v.num)
		if v.highlight then
			item:showCoolSquare()
		end
		newItem:addTo(nodeAward)
	end
	nodeAward:setAnchorPoint(cc.p(0.5, 1))
	if idx == 2 and self.cur_pool == 2 then
		SoraDautoSortPos(nodeAward, 3, 1, cc.size(100, 90), not SoraDFIsRA())
	else
		SoraDautoSortPos(nodeAward, 5, 1, cc.size(100, 90), not SoraDFIsRA())
	end
end
function sheepRunRewardPoolUp:initData()
	local curPool = sheepRunCtrl:getCurPool()
	for i = 1, 2 do
		local poolNode = SoraDGetChildByName(self, "Node_pool_" .. i)
		if 3 < curPool then
			poolNode:setVisible(false)
			return
		end
		local textTips_1 = SoraDGetChildByName(poolNode, "Text_Tips_1")
		textTips_1:setString(i18n(self.poolNames[curPool + i - 1]))
		local nodeAward = SoraDGetChildByName(poolNode, "Node_Award")
		local rewards = sheepRunRead.getShowRewards()[curPool + i - 1]
		self:setItems(nodeAward, rewards, i)
	end
	SoraDToCenter(self.node_cur_pool, 0, not SoraDFIsRA())
end
function sheepRunRewardPoolUp:btnBuyClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		paymentManager.normalGiftBuyClassify(self.giftData.ID)
	end
end
function sheepRunRewardPoolUp:updateOutAppPurchase()
	if SoraDCheckOAPIsOpen(self.giftData.ID) then
		if not self.outAppPurchaseButtons then
			self.outAppPurchaseButtons = include("outAppPurchaseButtons").new()
			self.outAppPurchaseButtons:addTo(self.btn_buy:getParent())
			self.outAppPurchaseButtons:setPosition(cc.p(0, -293))
		end
		self.outAppPurchaseButtons:setVisible(true)
		self.btn_buy:setVisible(false)
		_ENV = false
		;(false).rid = self.giftData.ID
		;(false).nowPrice = self.nowPrice
		;(false).handlePurchaseBack = handler(self, self.reInit)
		;(false).handleBuyClick = handler(self, self.btnBuyClick)
		self.outAppPurchaseButtons:initData(false)
	end
end
return sheepRunRewardPoolUp

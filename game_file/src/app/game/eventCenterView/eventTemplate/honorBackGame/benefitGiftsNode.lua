local gametop = gModuleMgr.getObject("gametop")
local honorBackCtrl = gametop.playertop_:getModule("honorBackCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local publicRead = include("publicRead")
local rechargeRead = include("rechargeRead")
local benefitGiftsNode = class("benefitGiftsNode", function(target)
	if target == nil then
		return SoraDCreateBasePanel("benefitGiftsNode")
	end
	return target
end)
function benefitGiftsNode:ctor()
	self.Panel_6 = SoraDGetChildByName(self, "Panel_6")
	self.img_bg = SoraDGetChildByName(self, "Image_bg")
	self.img_bg:setAnchorPoint(cc.p(0, 1))
	self.img_bg:setPositionY(self.Panel_6:getContentSize().height)
	self.img_bg:ignoreContentAdaptWithSize(true)
	self.img_itemList = SoraDGetChildByName(self, "Image_itemList")
	self.scroll = SoraDGetChildByName(self, "ScrollView_itemList")
	self.scroll:addEventListener(handler(self, self.scrollEventCallBack))
	self.sprite_down = SoraDGetChildByName(self, "Sprite_downArrow")
	self.text_title = SoraDGetChildByName(self, "Text_title")
	self.text_once = SoraDGetChildByName(self, "Text_once")
	self.text_gold = SoraDGetChildByName(self, "Text_gold")
	self.text_discount = SoraDGetChildByName(self, "Text_discount")
	self.text_time = SoraDGetChildByName(self, "Text_time")
	self.text_time = SoraDCreateTimerLabel(self, self.text_time)
	self.node_single = SoraDGetChildByName(self, "Image_item")
	self.node_bottom = SoraDGetChildByName(self, "Node_Bottom")
	self.btn_buy = SoraDGetChildByName(self, "Button_buy")
	self.btn_right = SoraDGetChildByName(self, "Button_right")
	self.btn_left = SoraDGetChildByName(self, "Button_left")
	self.text_oriPrice = SoraDGetChildByName(self.btn_buy, "Text_oriPrice")
	self.text_nowPrice = SoraDGetChildByName(self.btn_buy, "Text_nowPrice")
	self.Top_Node_clound = SoraDGetChildByName(self, "Top_Node_clound")
	self.img_bottom = SoraDGetChildByName(self, "Image_224")
	self.pagePoint = SoraDCreatePanel("commonScrollIndicatorNumber")
	self.pagePoint:addTo(self.node_bottom)
	self.pagePoint:setPosition(0, 10)
	self.img_bottom:setAnchorPoint(cc.p(0.5, 0))
	self.img_bottom:setContentSize(640, 119)
	self.img_bottom:setPositionY(0)
	self.btn_buy:setPositionY(self.btn_buy:getPositionY() + 20)
	self.text_once:setString(i18n("common_text_4310"))
	self.tableItemsSpare, _ENV, self.tableItemsSel, _ENV, self.curPage = self.text_once.setString, self.text_once.setString, self.text_once.setString, self.text_once.setString, 0
	self.itemSize = cc.size(500.0, 80)
	self.btn_left:addTouchEventListener(handler(self, self.onClickLeft))
	self.btn_right:addTouchEventListener(handler(self, self.onClickRight))
	self.btn_buy:addTouchEventListener(handler(self, self.onClickBuy))
end
function benefitGiftsNode:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_HONOR_BACK_UPDATE_GIFTS", function(target, data)
		self:initData()
	end)
end
function benefitGiftsNode:setSize(size)
	self.img_itemList:setContentSize(cc.size(self.img_itemList:getContentSize().width, size.height - 503 - 13))
	self.scroll:setContentSize(cc.size(self.scroll:getContentSize().width, size.height - 521 - 13))
	self.scroll:setPositionY(self.img_itemList:getContentSize().height - 16)
	self.node_bottom:setPositionY(-size.height)
	self.sprite_down:setPositionY(-size.height + 110)
end
function benefitGiftsNode:initData()
	self.giftList, honorBackCtrl = nil, nil
	self.giftList = honorBackCtrl:getBenefitGiftList()
	if not next(self.giftList) then
		self:setVisible(false)
		return
	end
	local eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.FRIEND_HONORBACK)
	if eventTime then
		self.text_time:beginTime(eventTime.timerNode.timer:getRemainTime())
	end
	self:loadPage(1)
	honorBackCtrl = 1
	;(1).count = #self.giftList
	;(1).intervalWidth = 30
	;(1).intervalH = 30
	;(1).begin = self.curPage
	;(1).rowCountMax = 20
	self.pagePoint:initData(1)
end
function benefitGiftsNode:loadPage(_index)
	self.curPage = _index
	local giftData = self.giftList[_index]
	self.text_gold:setString(string.formatnumberthousands(giftData.Gold))
	local discount = giftData.originalPrice / giftData.price
	self.text_discount:setString(tostring(math.floor(discount * 100)) .. "%")
	local pageViewData = rechargeRead.getPageViewData(giftData.giftID)
	self.text_title:setString(i18n(pageViewData.activeName))
	self.img_bg:loadTexture(pageViewData.activeBg, ccui.TextureResType.plistType)
	local curPrice = paymentManager.judgePrice(giftData.giftID, giftData.price)
	self.text_nowPrice:setString(curPrice)
	local oriPrice = paymentManager.calculateDiscount(giftData.giftID, curPrice, discount, giftData.originalPrice)
	self.text_oriPrice:setString(oriPrice)
	self:clearOld()
	self:updateScrollData()
	_ENV, rechargeRead = oriPrice, self
	oriPrice.rechargeID = giftData.giftID
	self[1] = oriPrice
	SoraDCreateRechargeGiftNode(self, self.node_bottom, cc.p(SoraDFPosX(-240, 0), 45), 1, 1, 320)
end
function benefitGiftsNode:clearOld()
	for i, v in ipairs(self.tableItemsSel) do
		if v.point then
			v.point:setVisible(false)
			table.insert(self.tableItemsSpare, v.point)
			v.point = nil
		end
	end
	self.tableItemsSel, _ENV = ipairs(self.tableItemsSel)
end
function benefitGiftsNode:updateScrollData()
	for k, v in ipairs(self.giftList[self.curPage].gift) do
		_ENV = nil
		;(nil).data = v
		_ENV, (nil).point = nil, nil
		;(nil).x = 0
		;(nil).pos, (nil).y = nil, 0
		table.insert(self.tableItemsSel, nil)
	end
	self:initScroll()
	self:initShopItems()
end
function benefitGiftsNode:initScroll()
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = scrollInner:getPositionY()
	local scrollH = self.scroll:getContentSize().height
	local scrollW = self.scroll:getContentSize().width
	local accumulateHeight = #self.giftList[self.curPage].gift * self.itemSize.height
	for i, v in ipairs(self.tableItemsSel) do
		v.pos.y = accumulateHeight - (i - 1) * self.itemSize.height
		v.pos.x = 295
		if v.point then
			v.point:setPositionY(v.pos.y)
			v.point:setPositionX(v.pos.x)
		end
	end
	local totalCellHeight = accumulateHeight
	if scrollH > totalCellHeight then
		local deltaY = scrollH - totalCellHeight
		totalCellHeight = scrollH
		for i, v in ipairs(self.tableItemsSel) do
			v.pos.y = v.pos.y + deltaY
			if v.point then
				v.point:setPositionY(v.pos.y)
			end
		end
	end
	local scrollInnerNewH = totalCellHeight
	offsetY = offsetY - (scrollInnerNewH - scrollInner:getContentSize().height)
	self.scroll:setInnerContainerSize(cc.size(scrollW, scrollInnerNewH))
	scrollInner:setPositionY(offsetY)
end
function benefitGiftsNode:initShopItems()
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local scrollH = self.scroll:getContentSize().height
	_ENV = self.scroll
	self.scroll.beginY = math.max(0, offsetY - 0.5 * scrollH)
	local self.scroll.endY, tableShowH = offsetY + 1.5 * scrollH, self.scroll
	for i, v in ipairs(self.tableItemsSel) do
		if v.point then
			if v.pos.y < tableShowH.beginY or v.pos.y > tableShowH.endY then
				v.point:setVisible(false)
				table.insert(self.tableItemsSpare, v.point)
				v.point = nil
			end
		elseif tableShowH.beginY <= v.pos.y and tableShowH.endY >= v.pos.y then
			local single
			if 0 < #self.tableItemsSpare then
				single = table.remove(self.tableItemsSpare)
				single:setVisible(true)
			else
				single = self.node_single:clone()
				single:addTo(self.scroll)
			end
			self:initNewNode(single, v.data)
			single:setPosition(v.pos)
			v.point = single
		end
	end
end
function benefitGiftsNode:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved then
		self:initShopItems()
	end
end
function benefitGiftsNode:initNewNode(_node, data)
	local single = _node
	single:getChildByName("Image_itemBuff"):loadTexture(publicRead.getBg(data.id), ccui.TextureResType.plistType)
	single:getChildByName("Image_itemIcon"):loadTexture(publicRead.getIcon(data.id), ccui.TextureResType.plistType)
	single:getChildByName("Text_itemName"):setString(publicRead.getName(data.id))
	single:getChildByName("Text_itemCount"):setString(string.formatnumberthousands(data.count))
	local touchBtn = single:getChildByName("item_single_show")
	touchBtn:addTouchEventListener(function(target, event)
		if event == ccui.TouchEventType.ended or event == ccui.TouchEventType.canceled then
			SoraDCloseCommonTips()
		elseif event == ccui.TouchEventType.began then
			SoraDPlaySound()
			SoraDShowCommonTips(touchBtn, data.id)
		end
	end)
end
function benefitGiftsNode:onClickRight(sender, event)
	if event == ccui.TouchEventType.ended then
		if self.curPage == #self.giftList then
			self.curPage = 1
		else
			self.curPage = self.curPage + 1
		end
		self:loadPage(self.curPage)
		self.pagePoint:setCurLight(self.curPage)
	end
end
function benefitGiftsNode:onClickLeft(sender, event)
	if event == ccui.TouchEventType.ended then
		if self.curPage == 1 then
			self.curPage = #self.giftList
		else
			self.curPage = self.curPage - 1
		end
		self:loadPage(self.curPage)
		self.pagePoint:setCurLight(self.curPage)
	end
end
function benefitGiftsNode:onClickBuy(sender, event)
	if event == ccui.TouchEventType.ended then
		paymentManager.normalGiftBuyClassify(self.giftList[self.curPage].giftID)
	end
end
return benefitGiftsNode

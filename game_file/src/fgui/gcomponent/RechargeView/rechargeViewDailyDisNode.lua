local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local dailyDiscountGiftCtrl = SoraDGetCtrl("dailyDiscountGiftCtrl")
local rechargeRead = include("rechargeRead")
local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local rechargeViewDailyDisNode = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RechargeView/rechargeViewDailyDisNode", rechargeViewDailyDisNode)
function rechargeViewDailyDisNode:onInit()
	self.payType = 1
	self.superRID = nil
	self.superGiftData, _ENV, self.sortedGiftsData, _ENV, self.buyStatus = nil, nil, nil, nil, 0
	self.hasBuySuper = false
	self.fields.Button_freeGifts:setHandle(handler(self, self.btnClickFreeGifts))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Btn_first:fixPos()
	self.fields.Button_freeGifts:fixPos()
	self.fields.timebg:fixPos()
	self.fields.timebg:fix()
	self.fields.Lab_time:fixPos()
	self.fields.rechargeGift:fixPos()
	self.fields.rechargeGift:fixNodePos()
end
function rechargeViewDailyDisNode:onItemRenderer(index, obj)
	obj:initData(self.sortedGiftsData[index + 1], self.payType, self.hasBuySuper)
end
function rechargeViewDailyDisNode:registerEvent()
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_DAILYFREEGIFT_REFRESH", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_DAILYSPECIALGIFT_REFRESH", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_DAILYSPECIALGIFTBUY_REFRESH", handler(self, self.updateView))
end
function rechargeViewDailyDisNode:onShow()
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, self.payType, self.payType
	;(nil).title = i18n("common_text_4617")
	_ENV, self.payType[1], (nil).tag = nil, nil, 1
	_ENV = nil
	;(nil).item = publicRead.getName(TOKEN_ITEM)
	;(nil).title = i18n("common_text_4618", nil)
	;(nil).tabsetArray, self.payType[2], (nil).tag = self.payType, nil, 2
	;(nil).callback = handler(self, self.clickOAPTab)
	self.fields.com_TabW:initView(nil)
end
function rechargeViewDailyDisNode:updateOutAppPurchase()
	if SoraDCheckOAPIsOpen(self.superRID) then
		self.controllers.c1:setSelectedIndex(0)
	else
		self.controllers.c1:setSelectedIndex(1)
	end
end
function rechargeViewDailyDisNode:clickOAPTab(tag)
	self.payType = tag
	print("self.payType======", self.payType)
	self:refleshNeededData()
	self:initContent()
	self:updateOutAppPurchase()
end
function rechargeViewDailyDisNode:initContent()
	self.superGiftData, _ENV, self.sortedGiftsData, _ENV = nil, nil, nil, nil
	local endIdx, beginIdx = self:getTableLength(self.dailyDiscountGiftData.giftData), 1
	local buyGiftList = self.dailyDiscountGiftData.buyGiftList
	local _ENV, priceOrder
	local curPrice, preIndex = 0
	for k, v in pairs(self.dailyDiscountGiftData.giftData) do
		_ENV = nil
		;(nil).id = k
		;(nil).price = v.price
		table.insert(priceOrder, nil)
	end
	table.sort(priceOrder, function(a, b)
		if a and b then
			return a.price < b.price
		end
		return false
	end)
	for k, v in pairs(self.dailyDiscountGiftData.giftData) do
		local price = paymentManager.judgePrice(k, v.price)
		local discount = tonumber(v.originalPrice) / tonumber(v.price)
		local oriShowPrice = paymentManager.calculateDiscount(k, price, discount, v.originalPrice)
		local originalPrice = oriShowPrice
		v.originalPriceForDollar = originalPrice
		v.priceForDollar = price
		v.id = k
		if buyGiftList[k] and 0 < buyGiftList[k] then
			v.state = 1
		end
		local giftStyle = rechargeRead.getPageViewData(k)
		v.titleName = i18n(giftStyle.activeName)
		if v.isGreat ~= 0 then
			self.superGiftData = v
			self.superRID = v.rechargeID
		else
			for _k, _v in ipairs(priceOrder) do
				if _v.id == k then
					self.sortedGiftsData[_k] = v
				end
			end
		end
	end
	self.hasBuySuper = self.superRID and buyGiftList[tostring(self.superRID)] or false
	self.fields.List:setNumItems(#self.sortedGiftsData)
	self.fields.Com_superDis:initData(self.superGiftData, self.payType, self.superRID)
end
function rechargeViewDailyDisNode:refleshNeededData()
	self.dailyDiscountGiftData = dailyDiscountGiftCtrl.dailyDiscountGiftData
	self.isActivityOpen = activityShowCtrl:isActivityOpen(gActivityTimeActivityID.DAILY_DISCOUNT_GIFT_ACTIVITY)
end
function rechargeViewDailyDisNode:updateView()
	self:initData()
	self:initContent()
end
function rechargeViewDailyDisNode:initData()
	self:refleshNeededData()
	local isReceiveFreeGift = serviceFunctions.isSameDay(self.dailyDiscountGiftData.freeGiftTime)
	self.fields.Button_freeGifts:updateData(true, not isReceiveFreeGift)
	local leftTime = self.dailyDiscountGiftData.nextRefreshTime - serviceFunctions.systemTime()
	self.fields.Lab_time:beginTime(leftTime)
	self:checkRechargeGift()
	local buyGiftList = self.dailyDiscountGiftData.buyGiftList
	local _maxValue = self:getTableLength(self.dailyDiscountGiftData.giftData, true)
	local _curValue = self:hasBoughtGreat(buyGiftList, self.dailyDiscountGiftData.giftData) and _maxValue or self:getTableLength(buyGiftList)
	local isReceiveSpecialGift = serviceFunctions.isSameDay(self.dailyDiscountGiftData.rewardGiftTime)
	self.fields.Com_stage:initData(_curValue, _maxValue, isReceiveSpecialGift)
end
function rechargeViewDailyDisNode:hasBoughtGreat(buyGiftList, giftData)
	local ret = false
	for k, v in pairs(buyGiftList) do
		if giftData[k] and giftData[k].isGreat == 1 then
			ret = true
			break
		end
	end
	return ret
end
function rechargeViewDailyDisNode:getTableLength(_table, noGreat)
	local leng = 0
	if _table == nil then
		return leng
	end
	for k, v in pairs(_table) do
		if noGreat then
			if v.isGreat == 0 then
				leng = leng + 1
			end
		else
			leng = leng + 1
		end
	end
	return leng
end
function rechargeViewDailyDisNode:checkRechargeGift()
	local _ENV, rechargeIDList
	for k, v in pairs(self.dailyDiscountGiftData.giftData) do
		_ENV = nil
		;(nil).rechargeID = tonumber(k)
		;(nil).cost = v.price
		table.insert(rechargeIDList, nil)
	end
	table.sort(rechargeIDList, function(l, r)
		if l.cost ~= r.cost then
			return l.cost < r.cost
		else
			return l.rechargeID < r.rechargeID
		end
	end)
	self.fields.rechargeGift:initData(rechargeIDList)
end
function rechargeViewDailyDisNode:btnClickFreeGifts()
	if self.isActivityOpen then
		local receiveTime = self.dailyDiscountGiftData.freeGiftTime
		if receiveTime ~= 0 and serviceFunctions.isSameDay(receiveTime) then
			_ENV = serviceFunctions.isSameDay(receiveTime)
			serviceFunctions.isSameDay(receiveTime).content = i18n("spcial_office_text_02")
			if not dailyDiscountGiftCtrl:getFreeGiftData() then
				_ENV = dailyDiscountGiftCtrl:getFreeGiftData()
			end
			serviceFunctions.isSameDay(receiveTime).giftsData = dailyDiscountGiftCtrl:getFreeGiftData()
			serviceFunctions.isSameDay(receiveTime).receiveTime = receiveTime
			local serviceFunctions.isSameDay(receiveTime).curType, data = "free", serviceFunctions.isSameDay(receiveTime)
			_ENV = nil
			;(nil).data = data
			uiManager:show("rechargeDailyPopView", nil)
		else
			dailyDiscountGiftCtrl:receiveGift(gCmd.REQ_RECEIVE_FREE_GIFT)
		end
	else
		SoraDShowMsgTip(i18n("common_text_2486"))
	end
end
return rechargeViewDailyDisNode

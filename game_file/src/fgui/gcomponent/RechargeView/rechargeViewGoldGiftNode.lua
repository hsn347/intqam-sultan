local publicRead = include("publicRead")
local rechargeCtrl = SoraDGetCtrl("rechargeCtrl")
local baseComponent = require("fgui.base.baseComponent")
local rechargeViewGoldGiftNode = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RechargeView/rechargeViewGoldGiftNode", rechargeViewGoldGiftNode)
function rechargeViewGoldGiftNode:onInit()
	self.itemsData, _ENV, self.payType = nil, nil, 1
	self.Text_refresh = SoraDCreateTimerLabel(self, self.fields.Text_refresh)
	self.Text_refresh:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("shop_text_19", nil)
	end)
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.rechargeGift:fixPos()
	self.fields.rechargeGift:fixNodePos()
end
function rechargeViewGoldGiftNode:onItemRenderer(index, obj)
	obj:initData(self.itemsData[index + 1], self.payType)
end
function rechargeViewGoldGiftNode:onShow()
	self.Text_refresh:setTimeEndListener(function()
		local goldRefreshTime = self:getNextMonthFirstDayTime()
		if 0 < goldRefreshTime then
			self.Text_refresh:beginTime(goldRefreshTime)
		end
	end)
	local goldRefreshTime = self:getNextMonthFirstDayTime()
	if 0 < goldRefreshTime then
		self.Text_refresh:beginTime(goldRefreshTime)
	end
end
function rechargeViewGoldGiftNode:registerEvent()
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_RECHARGEVIEWGOLDREFRESH", handler(self, self.initGoldPage))
	SoraDAddMessage(self, "MESSAGE_RECHARGE_PRESENT_REFRESH_ACTIVE", handler(self, self.initGoldPage))
end
function rechargeViewGoldGiftNode:initData()
	self:updateOutAppPurchase()
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
function rechargeViewGoldGiftNode:getNextMonthFirstDayTime()
	return serviceFunctions.getNextMonthFirstDayTime()
end
function rechargeViewGoldGiftNode:updateOutAppPurchase()
	if SoraDCheckOAPIsOpen() then
		self.fields.com_TabW:setVisible(true)
	else
		self.fields.com_TabW:setVisible(false)
	end
end
function rechargeViewGoldGiftNode:initGoldPage()
	local transData = rechargeCtrl.rechargeList
	self.itemsData, rechargeCtrl = nil, nil
	local rechargeCtrl, rechargeIDList
	for k, v in pairs(transData) do
		local showPrice = paymentManager.judgePrice(v.ID, v.price)
		if paymentManager.judgeGiftExclusive(v.ID) then
			rechargeCtrl = nil
			;(nil).iid = v.ID
			;(nil).type = v.rtype
			;(nil).showPrice = showPrice
			;(nil).gold = v.gold
			;(nil).goldGive = v.gold_give
			;(nil).isHot = v.hot
			;(nil).icon = "img"
			;(nil).isLocked = v.buy
			;(nil).price = v.price
			table.insert(self.itemsData, nil)
			if v.ID ~= 302 then
				rechargeCtrl = nil
				;(nil).rechargeID = v.ID
				;(nil).price = showPrice
				;(nil).gold = v.gold
				table.insert(rechargeIDList, nil)
			end
		end
	end
	table.sort(self.itemsData, function(a, b)
		return a.gold < b.gold
	end)
	table.sort(rechargeIDList, function(a, b)
		return a.gold < b.gold
	end)
	for k, v in ipairs(self.itemsData) do
		v.index = k
	end
	dump(self.itemsData, "self.itemsData===")
	self.fields.rechargeGift:initData(rechargeIDList)
	self.fields.List:setNumItems(#self.itemsData)
end
function rechargeViewGoldGiftNode:clickOAPTab(tag)
	self.payType = tag
	self:initGoldPage()
end
return rechargeViewGoldGiftNode

local gametop = gModuleMgr.getObject("gametop")
local rechargeCtrl = gametop.playertop_:getModule("rechargeCtrl")
local RechargeViewGoldGiftNode = class("rechargeViewGoldGiftNode", function(target)
	if target == nil then
		return SoraDCreateBasePanel("rechargeViewGoldGiftNode")
	end
	return target
end)
function RechargeViewGoldGiftNode:ctor()
	self.goldItemOcxs, _ENV = nil, nil
	self.goldScroll = SoraDGetChildByName(self, "ScrollView_goldList")
	self.goldScroll = include("commonAutoScrollList").new(self.goldScroll)
	self.goldScroll:setSingleCCS("rechargeItem")
	self.nodeGoleItems = SoraDGetChildByName(self, "Top_Node_goldItems")
	self.Panel_1 = SoraDGetChildByName(self, "Panel_1")
	self.Text_1 = SoraDGetChildByName(self, "Text_1")
	self.ccs_first = SoraDGetExtendChildFromCCSByName(self, "CCS_rechargeFirstAward_node")
	self.ccs_tabOAP = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX_OAP")
	self.goldScroll:setContentSize(cc.size(self.goldScroll:getContentSize().width, display.height - 477))
	self.Panel_1:setPositionY(self.goldScroll:getPositionY() - self.goldScroll:getContentSize().height)
	self.Text_1 = SoraDCreateTimerLabel(self, self.Text_1)
	self.Text_1:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("shop_text_19", nil)
	end)
	self.Text_1:setTimeEndListener(function()
		local goldRefreshTime = self:getNextMonthFirstDayTime()
		if 0 < goldRefreshTime then
			self.Text_1:beginTime(goldRefreshTime)
		end
	end)
	local goldRefreshTime = self:getNextMonthFirstDayTime()
	if 0 < goldRefreshTime then
		self.Text_1:beginTime(goldRefreshTime)
	end
	self.ccs_tabOAP:setContentSize(cc.size(640, 56))
	self.ccs_tabOAP:setNewStyle()
	_ENV = cc.size(640, 56)
	_ENV, _ENV, cc.size(640, 56).tabNum = cc.size(640, 56)
	cc.size(640, 56).title = i18n("common_text_4617")
	cc.size(640, 56).tag = 1
	_ENV, cc.size(640, 56)[1], cc.size(640, 56).handle = cc.size(640, 56)
	_ENV = self.clickOAPTab
	self.clickOAPTab.item = include("publicRead").getName(TOKEN_ITEM)
	cc.size(640, 56).title = i18n("common_text_4618", self.clickOAPTab)
	cc.size(640, 56).tag = 2
	cc.size(640, 56).tabsetArray, cc.size(640, 56)[2], cc.size(640, 56).handle = cc.size(640, 56)
	self.ccs_tabOAP:initView(cc.size(640, 56))
	self:updateOutAppPurchase()
	self:initGoldPage()
end
function RechargeViewGoldGiftNode:getNextMonthFirstDayTime()
	return serviceFunctions.getNextMonthFirstDayTime()
end
function RechargeViewGoldGiftNode:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_RECHARGEVIEWGOLDREFRESH", handler(self, self.initGoldPage))
	SoraDAddMessage(self, "MESSAGE_RECHARGE_PRESENT_REFRESH_ACTIVE", handler(self, self.initGoldPage))
end
function RechargeViewGoldGiftNode:initGoldPage()
	local transData = rechargeCtrl.rechargeList
	local rechargeCtrl, itemsData
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
			table.insert(itemsData, nil)
			if v.ID ~= 302 then
				rechargeCtrl = nil
				;(nil).rechargeID = v.ID
				;(nil).price = showPrice
				;(nil).gold = v.gold
				table.insert(rechargeIDList, nil)
			end
		end
	end
	table.sort(itemsData, function(a, b)
		return a.gold < b.gold
	end)
	table.sort(rechargeIDList, function(a, b)
		return a.gold < b.gold
	end)
	for k, v in ipairs(itemsData) do
		v.index = k
	end
	rechargeCtrl = paymentManager.judgePrice(v.ID, v.price)
	paymentManager.judgePrice(v.ID, v.price).scroll = self.goldScroll
	paymentManager.judgePrice(v.ID, v.price).payType = self.payType
	self.goldScroll:updateScrollView(cc.size(620, 118), itemsData, 1, (paymentManager.judgePrice(v.ID, v.price)))
	SoraDCreateRechargeGiftNode(rechargeIDList, self.nodeGoleItems, cc.p(SoraDFPosX(286, 0), -229), 0.9, SoraDFPosX(2, 5))
end
function RechargeViewGoldGiftNode:updateOutAppPurchase()
	if SoraDCheckOAPIsOpen() then
		self.ccs_tabOAP:setVisible(true)
		self.goldScroll:setPositionY(self.ccs_tabOAP:getPositionY() - 24)
		self.goldScroll:setContentSize(cc.size(620, display.height - 477 - 56))
	else
		self.ccs_tabOAP:setVisible(false)
	end
end
function RechargeViewGoldGiftNode:clickOAPTab(tag)
	self.payType = tag
	self:initGoldPage()
end
return RechargeViewGoldGiftNode

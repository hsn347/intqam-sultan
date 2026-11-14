local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local MIN_BAG_CAPACITY = 40
local LINE_NUM = 5
local backpackltCtrl = include("backpackltCtrl")
local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
local publicRead = include("publicRead")
local publicUtil = include("publicUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local BagItemRecoveryPanel = class("BagItemRecoveryPanel", baseFguiPanel)
function BagItemRecoveryPanel:ctor(...)
	BagItemRecoveryPanel.super.ctor(self, ...)
	self.debug = true
	print("BagItemRecoveryPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.EXCHANGE_MALL_ACTIVITY_9010001
end
function BagItemRecoveryPanel:onInit()
	self.fields.Com_bg:setGradientColor()
	print("=======BagItemRecoveryPanel:onInit")
	self.fields.Com_title:initData(i18n("recycling_store_text2"), handler(self, self.onClickClose))
	self.fields.List_exchange:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.activity_time:setTimeLast(function(strTime)
		_ENV = nil
		;(nil).time = fguiHelper.getColorString("#F0E6D2", strTime)
		return fguiHelper.getColorString("#FFC864", (i18n("recycling_store_text10", nil)))
	end)
	self.fields.text_none:setString(i18n("recycling_store_text11"))
	self.fields.List_coin:setItemRenderer(handler(self, self.onCoinRenderer))
	self.fields.Load_bg:fix()
	self.fields.bg_bag:fix()
end
function BagItemRecoveryPanel:onCoinRenderer(index, obj)
	obj:initData(self.coinList[index + 1].exchangeitem)
end
function BagItemRecoveryPanel:endShow()
	print("=======BagItemRecoveryPanel:endShow")
	self.tag = 0
	self.shopTag = 0
	self.bagTag = 0
	self.coinList = backpackltCtrl:getRecycleShopViewList()
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, self.tag, self.tag
	;(nil).title = i18n("recycling_store_text5")
	_ENV, self.tag[1], (nil).tag = nil, nil, 0
	;(nil).title = i18n("recycling_store_text9")
	;(nil).tabsetArray, self.tag[2], (nil).tag = self.tag, nil, 1
	;(nil).callback = handler(self, self.onClickTab)
	self.fields.Com_tab:initView(nil)
	local _ENV, shopTabsetArray = self.fields.Com_tab.initView, self.fields.Com_tab.initView
	_ENV = handler(self, self.onClickTab)
	handler(self, self.onClickTab).title = i18n("common_text_635")
	handler(self, self.onClickTab).tag = 0
	table.insert(shopTabsetArray, (handler(self, self.onClickTab)))
	for i, v in ipairs(self.coinList) do
		_ENV = nil
		;(nil).title = i18n(v.shopName)
		;(nil).tag = i
		table.insert(shopTabsetArray, nil)
	end
	_ENV = ipairs(self.coinList)
	ipairs(self.coinList).defaultClick = self.shopTag
	ipairs(self.coinList).tabsetArray = shopTabsetArray
	ipairs(self.coinList).callback = handler(self, self.onClickShopTab)
	self.fields.com_TabW_shop:initView(ipairs(self.coinList))
	local _ENV, bagTabsetArray = self.fields.com_TabW_shop.initView, self.fields.com_TabW_shop.initView
	_ENV = handler(self, self.onClickShopTab)
	handler(self, self.onClickShopTab).title = i18n("common_text_635")
	handler(self, self.onClickShopTab).tag = 0
	table.insert(bagTabsetArray, (handler(self, self.onClickShopTab)))
	for i, v in ipairs(self.coinList) do
		_ENV = i18n(v.shopName)
		i18n(v.shopName).title = i18n(v.pageName)
		i18n(v.shopName).tag = i
		table.insert(bagTabsetArray, (i18n(v.shopName)))
	end
	_ENV = ipairs(self.coinList)
	ipairs(self.coinList).defaultClick = self.bagTag
	ipairs(self.coinList).tabsetArray = bagTabsetArray
	ipairs(self.coinList).callback = handler(self, self.onClickBagTab)
	self.fields.com_TabW_bag:initView(ipairs(self.coinList))
end
function BagItemRecoveryPanel:onClickTab(tag)
	self.tag = tag
	self:updateView()
end
function BagItemRecoveryPanel:onClickShopTab(tag)
	self.shopTag = tag
	self:updateView()
	self.fields.List_exchange:jumpToTop()
end
function BagItemRecoveryPanel:onClickBagTab(tag)
	self.bagTag = tag
	self:updateView()
end
function BagItemRecoveryPanel:updateView()
	self.controllers.c1:setSelectedIndex(self.tag)
	if self.tag == 0 then
		local backpacks = backpackCtrl:getAllPackItem()
		self.tableItemsData, backpackCtrl = backpackCtrl, backpackCtrl
		for k, v in pairs(backpacks) do
			for i, v in ipairs(v:getList()) do
				table.insert(self.tableItemsData, v)
			end
		end
		self.tableItemsSingle, backpackCtrl = pairs(backpacks)
		for i, v in ipairs(self.tableItemsData) do
			local recycleItemCfg = backpackltCtrl:getRecycleItemConfig(v.id)
			if recycleItemCfg ~= nil and backpackltCtrl:checkRecycleItemShow(v.id) and (self.bagTag == 0 or 0 < self.bagTag and recycleItemCfg.exchangeitem[1].id == self.coinList[self.bagTag].exchangeitem) then
				backpackCtrl = self.bagTag
				self.bagTag.point = nil
				self.bagTag.data = v
				self.bagTag.pos = nil
				table.insert(self.tableItemsSingle, self.bagTag)
			end
		end
		self.fields.Scoll_recycle:initData(self.tableItemsSingle)
		self.fields.Scoll_recycle:jumpTop()
	else
		self.tableData, backpackCtrl = backpackCtrl:getAllPackItem(), backpackCtrl:getAllPackItem()
		if not activityExchangeMallCtrl:getConfigByActivityID(self.activityID) then
			local backpackCtrl, tableData = activityExchangeMallCtrl:getConfigByActivityID(self.activityID), activityExchangeMallCtrl:getConfigByActivityID(self.activityID)
		end
		for k, v in ipairs(tableData) do
			if self.shopTag == 0 or 0 < self.shopTag and v.exchangeitem == self.coinList[self.shopTag].exchangeitem then
				table.insert(self.tableData, v)
			end
		end
		self:sortData()
		backpackCtrl = self.sortData
		self.otherData, self.sortData.activityID = self.sortData, self.activityID
		self.fields.List_exchange:setNumItems(#self.tableData)
		local remainTime = serviceFunctions.getNextMonthFirstDayTime(1)
		self.fields.activity_time:beginTime(remainTime)
	end
	self.fields.text_none:setVisible(self.tableItemsSingle and #self.tableItemsSingle == 0 and self.tag == 0)
	self.fields.List_coin:setNumItems(#self.coinList)
	self:updateRedDot()
end
function BagItemRecoveryPanel:updateRedDot()
	local ret, _ = activityExchangeMallCtrl:getReceiveStatusAndNum(self.activityID)
	self.fields.Com_tab:setBtnRedDot(2, ret)
end
function BagItemRecoveryPanel:sortData()
	for i, v in ipairs(self.tableData) do
		v.weight = 0
		v.index = i
		if 0 < v.limitnum - v.curExchangeNum then
			v.weight = 1
		end
	end
	table.sort(self.tableData, function(a, b)
		if a.weight ~= b.weight then
			return a.weight > b.weight
		else
			return a.index < b.index
		end
	end)
end
function BagItemRecoveryPanel:onItemRenderer(index, obj)
	local data = self.tableData[index + 1]
	obj:initData(data, self.otherData)
end
return BagItemRecoveryPanel

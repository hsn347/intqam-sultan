local newExchangeMallCtrl = SoraDGetCtrl("newExchangeMallCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local nebulaMarketPanel = class("nebulaMarketPanel", baseFguiPanel)
function nebulaMarketPanel:ctor(...)
	self.super.ctor(self, ...)
	print("nebulaMarketPanel:ctor", self.viewName)
end
function nebulaMarketPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "ExchangeShopNew"
	end
	return self._packageList
end
function nebulaMarketPanel:onInit()
	print("=======nebulaMarketPanel:onInit")
	self.activityID = gActivityTimeActivityID.NEBULA_MARKET_ACTIVITY
	self.fields.Com_title:initData(i18n("activity_name_9001447"), handler(self, self.onClickClose))
	self.fields.List_exchange:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.Label_time:initCommonActivityTime(self.activityID)
	self:updateData()
	_ENV = self.updateData
	_ENV, _ENV, self.updateData.defaultClick = self.activityID, self, 1
	self.activityID.title = i18n("Nebula_Bazaar_01")
	_ENV, self[1], self.activityID.tag = self.activityID, self.activityID, 1
	self.activityID.title = i18n("Nebula_Bazaar_02")
	self.updateData.tabsetArray, self[2], self.activityID.tag = self, self.activityID, 2
	local self.updateData.callback, param = handler(self, self.onClickTab), self.updateData
	self.fields.Com_Tab:initView(param)
	_UPVALUE1_ = param
	param[1] = 855101
	self.fields.Button_toShop:setIconAndNum(param)
end
function nebulaMarketPanel:onShow()
	print("=======nebulaMarketPanel:onShow")
	self:updatRed()
end
function nebulaMarketPanel:onItemRederer(index, target)
	_UPVALUE0_ = index + 1
	;(index + 1).activityID = self.activityID
	target:getChildByName("n0"):initData(self.itemList[self.tag][index + 1], index + 1)
end
function nebulaMarketPanel:onClickTab(tag)
	self.tag = tag
	self.fields.List_exchange:setNumItems(#self.itemList[tag])
end
function nebulaMarketPanel:updateView()
	self:updateData()
	_UPVALUE1_ = nil
	;(nil)[1] = 855101
	self.fields.Button_toShop:setIconAndNum(nil)
	self.fields.List_exchange:setNumItems(#self.itemList[self.tag])
	self:updatRed()
end
function nebulaMarketPanel:updatRed()
	self.fields.Com_Tab:setBtnRedDot(1, self:getRedNum(1))
	self.fields.Com_Tab:setBtnRedDot(2, self:getRedNum(2))
end
function nebulaMarketPanel:updateData()
	local tableData = newExchangeMallCtrl:getConfigByActivityID(self.activityID)
	dump(tableData, "tableData", 100)
	self.itemList, newExchangeMallCtrl = dump, dump
	for i, v in ipairs(tableData) do
		v.weight = 0
		if 0 < v.limitnum - v.curExchangeNum then
			v.weight = 1
		end
		if not self.itemList[v.tabType] then
			self.itemList[v.tabType], newExchangeMallCtrl = nil, nil
		end
		table.insert(self.itemList[v.tabType], v)
	end
	table.sort(self.itemList[1], function(a, b)
		if a.weight ~= b.weight then
			return a.weight > b.weight
		else
			return a.index < b.index
		end
	end)
	table.sort(self.itemList[2], function(a, b)
		if a.weight ~= b.weight then
			return a.weight > b.weight
		else
			return a.index < b.index
		end
	end)
end
function nebulaMarketPanel:closeLoading()
	SoraDCloseLoading(self:displayObject())
end
function nebulaMarketPanel:getRedNum(type)
	local num = 0
	local ret = false
	for _, value in ipairs(self.itemList[type]) do
		if value.remindStatus == 1 and value.exchangeitem and (value.limitType == 0 or value.curExchangeNum < value.limitnum) then
			local isNoEnough = false
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			local exchangeitem = serviceFunctions.tableFormat(value.exchangeitem, nil)
			for _, v in ipairs(exchangeitem) do
				local ownCont = SoraDGetCtrl("backpackCtrl"):getItemCount(v.id)
				if ownCont < v.count then
					isNoEnough = true
					break
				end
			end
			if not isNoEnough then
				ret = true
				num = num + 1
			end
		end
	end
	return ret, num
end
return nebulaMarketPanel

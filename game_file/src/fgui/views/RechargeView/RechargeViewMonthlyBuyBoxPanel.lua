local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RechargeViewMonthlyBuyBoxPanel = class("RechargeViewMonthlyBuyBoxPanel", baseFguiPanel)
function RechargeViewMonthlyBuyBoxPanel:ctor(...)
	self.super.ctor(self, ...)
	print("RechargeViewMonthlyBuyBoxPanel:ctor", self.viewName)
end
function RechargeViewMonthlyBuyBoxPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function RechargeViewMonthlyBuyBoxPanel:onInit()
	print("=======RechargeViewMonthlyBuyBoxPanel:onInit")
	self.canRenew = false
	self.fields.Com_title:setTitle(i18n("common_text_2460"))
	self.packageInfo = self:getPackageInfo()
	self.fields.List_item:setItemRenderer(handler(self, self.onItemRederer))
	_ENV = handler(self, self.onItemRederer)
	_ENV, _ENV, handler(self, self.onItemRederer).defaultClick = handler(self, self.onItemRederer)
	_ENV, handler(self, self.onItemRederer)[1], handler(self, self.onItemRederer).title = handler(self, self.onItemRederer)
	_ENV = handler(self, self.onItemRederer)
	handler(self, self.onItemRederer).item = include("publicRead").getName(TOKEN_ITEM)
	handler(self, self.onItemRederer).tabsetArray, handler(self, self.onItemRederer)[2], handler(self, self.onItemRederer).title = handler(self, self.onItemRederer)
	handler(self, self.onItemRederer).callback = handler(self, self.onClickTab)
	self.fields.com_TabW:initView(handler(self, self.onItemRederer))
	self.fields.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
end
function RechargeViewMonthlyBuyBoxPanel:onShow()
	print("=======RechargeViewMonthlyBuyBoxPanel:onShow")
	self.controllers.c1:setSelectedIndex(SoraDCheckOAPIsOpen() and 1 or 0)
	self:updateTime()
end
function RechargeViewMonthlyBuyBoxPanel:updateTime()
	self.fields.Text_time:setVisible(self.canRenew)
	if self.canRenew then
		local leftTime = rechargeActivityCtrl:getRechargeLeftTime(self.packageInfo[1].ID)
		self.fields.Text_time:setTimeLast(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n("common_text_4179", nil)
		end)
		self.fields.Text_time:beginTime(leftTime)
	end
end
function RechargeViewMonthlyBuyBoxPanel:onItemRederer(index, target)
	target:initData(self.packageInfo[index + 1], index + 1, self.payType, self.canRenew)
end
function RechargeViewMonthlyBuyBoxPanel:updateScroll()
	self.fields.List_item:setNumItems(#self.packageInfo)
end
function RechargeViewMonthlyBuyBoxPanel:onClickTab(tag)
	self.payType = tag
	self:updateScroll()
end
function RechargeViewMonthlyBuyBoxPanel:getPackageInfo()
	local monthData = rechargeActivityCtrl:getMonthActivityList()
	dump(monthData, "slkdjflksjdlfkjs")
	local rechargeActivityCtrl, monthList = dump, dump
	local isOpen = false
	for k, v in pairs(monthData) do
		if tonumber(k) == 14080 then
			isOpen = true
		end
	end
	for k, v in pairs(monthData) do
		if isOpen and tonumber(k) ~= 11485 then
			table.insert(monthList, v)
		elseif not isOpen then
			table.insert(monthList, v)
		end
	end
	for i, v in ipairs(monthList) do
		v.sortWeight = 0
		if v.ID == 14080 or v.ID == 11485 then
			v.sortWeight = 1
		end
	end
	table.sort(monthList, function(l, r)
		if l.sortWeight == r.sortWeight then
			return l.ID > r.ID
		else
			return l.sortWeight > r.sortWeight
		end
	end)
	dump(monthList, "iorutoiruoieru")
	self.canRenew = monthList[1].canRenew
	return monthList
end
return RechargeViewMonthlyBuyBoxPanel

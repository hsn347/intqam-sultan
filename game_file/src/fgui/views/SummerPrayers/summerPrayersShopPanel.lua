local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
local activityTimeRead = include("activityTimeRead")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local summerPrayRead = include("summerPrayRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local summerPrayersShopPanel = class("summerPrayersShopPanel", baseFguiPanel)
function summerPrayersShopPanel:ctor(...)
	self.super.ctor(self, ...)
	print("summerPrayersShopPanel:ctor", self.viewName)
end
function summerPrayersShopPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function summerPrayersShopPanel:onInit()
	print("=======summerPrayersShopPanel:onInit")
	local activityID = gActivityTimeActivityID.SUMMER_PRAY_ACTIVITY
	local classType = activityShowCtrl:getParamClassType(activityID)
	if not activityTimeRead.getRechargeId(activityID, classType) then
		_ENV = activityTimeRead.getRechargeId(activityID, classType)
	end
	self.giftIDList = activityTimeRead.getRechargeId(activityID, classType)
	if summerPrayRead.getActivityType() == 1 then
		self.fields.Text_Title:setString(i18n("pray_text_12"))
	else
		self.fields.Text_Title:setString(i18n("Icefestival2024_text13"))
	end
	self.fields.List_item:setItemRenderer(handler(self, self.onItemRederer))
	self.payType = 1
	_ENV = handler(self, self.onItemRederer)
	_ENV, _ENV, handler(self, self.onItemRederer).defaultClick = handler(self, self.onItemRederer)
	_ENV, handler(self, self.onItemRederer)[1], handler(self, self.onItemRederer).title = handler(self, self.onItemRederer)
	_ENV = handler(self, self.onItemRederer)
	handler(self, self.onItemRederer).item = include("publicRead").getName(TOKEN_ITEM)
	handler(self, self.onItemRederer).tabsetArray, handler(self, self.onItemRederer)[2], handler(self, self.onItemRederer).title = handler(self, self.onItemRederer)
	handler(self, self.onItemRederer).callback = handler(self, self.onClickTab)
	self.fields.com_TabW:initView(handler(self, self.onItemRederer))
	local _ENV, ret = self.fields.com_TabW.initView, self.fields.com_TabW.initView
	for __, giftID in ipairs(self.giftIDList) do
		_ENV = include("publicRead").getName(TOKEN_ITEM)
		include("publicRead").getName(TOKEN_ITEM).rechargeID = giftID
		table.insert(ret, (include("publicRead").getName(TOKEN_ITEM)))
	end
	SoraDCreateRechargeGiftNode(ret, self.fields.NodeGift:displayObject(), cc.p(SoraDFPosX(-180, 80), 100), 1, nil, 280)
end
function summerPrayersShopPanel:onShow()
	print("=======summerPrayersShopPanel:onShow")
	self.controllers.c1:setSelectedIndex(SoraDCheckOAPIsOpen() and 1 or 0)
end
function summerPrayersShopPanel:updateScroll()
	self.giftData = self:getGiftInfo()
	self.fields.List_item:setNumItems(#self.giftData)
end
function summerPrayersShopPanel:onItemRederer(index, target)
	target:initData(self.giftData[index + 1], index + 1, self.payType)
end
function summerPrayersShopPanel:getGiftInfo()
	local _ENV, ret
	for __, giftID in ipairs(self.giftIDList) do
		local giftInfo = rechargeActivityCtrl:getRechargeActivityData(giftID)
		if giftInfo then
			local v = clone(giftInfo)
			if not v.gift then
				_ENV = v.gift
			end
			local tmpList = SoraDStringSplit(v.gift, ",")
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.gift = serviceFunctions.tableFormat(tmpList, nil)
			table.insert(ret, v)
		end
	end
	table.sort(ret, function(l, r)
		return l.price < r.price
	end)
	SoraDPrint(ret)
	return ret
end
function summerPrayersShopPanel:onClickTab(tag)
	self.payType = tag
	self:updateScroll()
end
return summerPrayersShopPanel

local activity_9001708_Read = include("activity_9001708_Read")
local activity_9001708_Ctrl = SoraDGetCtrl("activity_9001708_Ctrl")
local newExchangeMallCtrl = SoraDGetCtrl("newExchangeMallCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001708_MainPanel = class("Activity_9001708_MainPanel", baseFguiPanel)
function Activity_9001708_MainPanel:ctor(...)
	self.isLRU = true
	Activity_9001708_MainPanel.super.ctor(self, ...)
	print("Activity_9001708_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.KOH_MIGRATE_HELP_9001708
	self.buff_rid = 19933
end
function Activity_9001708_MainPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "ExchangeShopNew"
	end
	return self._packageList
end
function Activity_9001708_MainPanel:onInit()
	print("=======Activity_9001708_MainPanel:onInit")
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Button_task:setString(i18n("migrant_move_text65"))
	self.fields.Button_task:addClickListener(handler(self, self.onClickBtnTask))
	self.fields.List1:setItemRenderer(handler(self, self.onItemRenderer1))
	self.fields.Com_have2:setAddCallBack(handler(self, self.addItemCallback))
	self.fields.List2:setItemRenderer(handler(self, self.onItemRenderer2))
end
function Activity_9001708_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("migrant_move_text75")
	uiManager:show("RuleView", nil)
end
function Activity_9001708_MainPanel:endShow()
	print("=======Activity_9001708_MainPanel:endShow")
	local giftCfg = activity_9001708_Read.getRechargeConfig(self.buff_rid)
	self.fields.Com_9001708_gift:initData(giftCfg)
	local exchangeConfig = activity_9001708_Read.getExchangeConfig(self.activityID)
	if not exchangeConfig[1] then
		_ENV = exchangeConfig[1]
	end
	self.dataList1 = exchangeConfig[1]
	self.exchangeItemID = self.dataList1[1].exchangeitem[1]
	if not exchangeConfig[2] then
		_ENV = exchangeConfig[2]
	end
	self.dataList2 = exchangeConfig[2]
	self.shopItemID = self.dataList2[1].exchangeitem[1]
	self.fields.Com_have2:initData(self.shopItemID)
	_ENV = self.fields.Com_have2.initData
	_ENV, _ENV, self.fields.Com_have2.initData.defaultClick = self.shopItemID, self.fields.Com_have2, 1
	_ENV, self.fields.Com_have2[1], self.shopItemID.title = self.shopItemID, self.shopItemID, i18n("migrant_move_text64")
	self.fields.Com_have2.initData.tabsetArray, self.fields.Com_have2[2], self.shopItemID.title = self.fields.Com_have2, self.shopItemID, i18n("migrant_move_text67")
	local self.fields.Com_have2.initData.callback, param = handler(self, self.onClickTab), self.fields.Com_have2.initData
	self.fields.Com_title:initTab(param)
	self:updateTabRedDot()
end
function Activity_9001708_MainPanel:onClickTab(tag)
	self.curTag = tag
	self.controllers.c1:setSelectedIndex(tag - 1)
	if self.curTag == 1 then
		self:updateBtnTask()
		self:updateExchangeList()
	elseif self.curTag == 2 then
		self:updateShopList()
	end
end
function Activity_9001708_MainPanel:onClickBtnTask()
	SoraDPlaySound()
	_ENV = nil
	;(nil).activityID = self.activityID
	uiManager:show("CommonTaskPop", nil)
end
function Activity_9001708_MainPanel:onItemRenderer1(index, obj)
	local data = self.dataList1[index + 1]
	_UPVALUE0_ = nil
	;(nil).activityID = self.activityID
	obj:initData(data, nil)
end
function Activity_9001708_MainPanel:onItemRenderer2(index, obj)
	local item1 = self.dataList2[index * 2 + 1]
	local item2 = self.dataList2[index * 2 + 2]
	_ENV = nil
	;(nil).item1 = item1
	_ENV, (nil).item2 = nil, item2
	;(nil).activityID = self.activityID
	;(nil).addCallback = handler(self, self.addItemCallback)
	obj:initData(nil, nil)
end
function Activity_9001708_MainPanel:onMsgUpdateData(target, event)
	local subMsg = event.subMsg
	if subMsg == "buyGift" then
		self.fields.Com_9001708_gift:updateBuyState()
	elseif subMsg == "taskReward" then
		self:updateBtnTask()
	end
end
function Activity_9001708_MainPanel:updateBtnTask()
	local ret, num = activity_9001708_Ctrl:getTaskRedNum()
	self.fields.Button_task:setReddot(ret, num)
end
function Activity_9001708_MainPanel:onMsgUpdateExchange(target, event)
	SoraDCloseLoading()
	for i, v in ipairs(self.dataList1) do
		v.curExchangeNum = newExchangeMallCtrl:getCurExchangeNum(v.storeID)
	end
	self:updateExchangeList()
	for i, v in ipairs(self.dataList2) do
		v.curExchangeNum = newExchangeMallCtrl:getCurExchangeNum(v.storeID)
	end
	self:updateShopList()
	self:updateTabRedDot()
end
function Activity_9001708_MainPanel:updateExchangeList()
	self.fields.List1:setNumItems(#self.dataList1)
end
function Activity_9001708_MainPanel:updateShopList()
	_ENV = nil
	local _ENV, ret1, ret2
	for i, v in ipairs(self.dataList2) do
		if v.limitnum - v.curExchangeNum <= 0 then
			table.insert(ret2, v)
		else
			table.insert(ret1, v)
		end
	end
	table.insertto(ret1, ret2)
	self.dataList2 = ret1
	local count = math.ceil(#self.dataList2 / 2)
	self.fields.List2:setNumItems(count)
end
function Activity_9001708_MainPanel:onMsgUpdateItemCount(target, event)
	local itemMap = event.itemMap
	if itemMap[self.exchangeItemID] then
		self:updateExchangeList()
	end
	if itemMap[self.shopItemID] then
		self.fields.Com_have2:updateNum()
		self:updateShopList()
	end
end
function Activity_9001708_MainPanel:updateTabRedDot(...)
	local ret, num = newExchangeMallCtrl:getReceiveStatusAndNumByList(self.activityID, self.dataList1)
	self.fields.Com_title:setBtnRedDot(1, ret, num)
	local ret, num = newExchangeMallCtrl:getReceiveStatusAndNumByList(self.activityID, self.dataList2)
	self.fields.Com_title:setBtnRedDot(2, ret, num)
end
function Activity_9001708_MainPanel:onMsgUpdateRemain()
	for i, v in ipairs(self.dataList1) do
		v.remindStatus = newExchangeMallCtrl:getRemindStatus(v.storeID)
	end
	self:updateExchangeList()
	local ret, num = newExchangeMallCtrl:getReceiveStatusAndNumByList(self.activityID, self.dataList1)
	self.fields.Com_title:setBtnRedDot(1, ret, num)
end
function Activity_9001708_MainPanel:addItemCallback()
	local packageList = activity_9001708_Ctrl:getPackageList()
	if 0 < #packageList then
		local targetID
		for __, v in ipairs(packageList) do
			if 0 < activity_9001708_Ctrl:getRemainBuyCount(v.id) then
				targetID = v.id
				break
			end
		end
		activity_9001708_Ctrl = nil
		;(nil).group = packageList
		;(nil).fromCenter = tostring(self.activityID)
		;(nil).isPageTurn = false
		;(nil).isHideRechargeCenter = true
		;(nil).isHideGiftCar = true
		;(nil).activityID = self.activityID
		;(nil).targetID = targetID
		uiManager:show("rechargePopView", nil)
	else
		SoraDShowMsgTip(i18n("Player_Return_test02"))
	end
end
return Activity_9001708_MainPanel

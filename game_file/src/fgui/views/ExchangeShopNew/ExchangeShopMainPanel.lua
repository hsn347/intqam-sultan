local newExchangeMallRead = include("newExchangeMallRead")
local newExchangeMallCtrl = SoraDGetCtrl("newExchangeMallCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local exchangeMallCtrl = SoraDGetCtrl("exchangeMallCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ExchangeShopMainPanel = class("ExchangeShopMainPanel", baseFguiPanel)
function ExchangeShopMainPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("ExchangeShopMainPanel:ctor", self.viewName)
end
function ExchangeShopMainPanel:getPackageList()
	if not self._packageList then
		_UPVALUE2_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "ExchangeShopNew"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
	end
	return self._packageList
end
function ExchangeShopMainPanel:onInit()
	print("=======ExchangeShopMainPanel:onInit")
	self.mallData, _ENV = print, print
	self.activityID = gActivityTimeActivityID.EXCHANGE_MALL
	self.fields.fireLeft:setAllFrameName("dh_dxtanxian_%02d.png", 1)
	self.fields.fireRight:setAllFrameName("dh_dxtanxian_%02d.png", 1)
	self.fields.Com_title:initData(i18n("common_text_1809"), handler(self, self.onClickClose))
	self.fields.List_exchangeEvent:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem))
	self:initData()
end
function ExchangeShopMainPanel:showFire()
	self.transitions.t0:play()
end
function ExchangeShopMainPanel:hideFire()
	self.transitions.t1:play()
end
function ExchangeShopMainPanel:initData()
	self.mallData = self:sortData()
	self.fields.List_exchangeEvent:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_exchangeEvent:setNumItems(table.nums(self.mallData))
end
function ExchangeShopMainPanel:sortData()
	self.mallData, _ENV = nil, nil
	for i, v in ipairs(exchangeMallActivityID) do
		local state = activityShowCtrl:getStateByID(v)
		if not newExchangeMallRead.getNewCfg(v) then
			local _ENV, newCfg = newExchangeMallRead.getNewCfg(v), newExchangeMallRead.getNewCfg(v)
		end
		local universalList = newCfg.universalList or 1
		if state == gActivityState.OPEN and (newExchangeMallRead.isReachOpenLvByID(v) or v == gActivityTimeActivityID.EXCHANGE_MALL_NEBULA_STONE) and universalList == 1 then
			if not self.mallData[v] then
				self.mallData[v], _ENV = v, v
			end
			local remainTime = 0
			if activityShowCtrl:getTimeInfoByID(v) then
				remainTime = activityShowCtrl:getTimeInfoByID(v).timerNode.timer:getRemainTime()
			end
			self.mallData[v].state = state
			self.mallData[v].remainTime = remainTime
			self.mallData[v].activityID = v
		end
	end
	self.mallData = serviceFunctions.mapConvertArrayAndSort(self.mallData, function(a, b)
		if a.state == b.state then
			if a.remainTime == b.remainTime then
				return a.activityID < b.activityID
			else
				return a.remainTime > b.remainTime
			end
		else
			return a.state > b.state
		end
	end)
	return self.mallData
end
function ExchangeShopMainPanel:onItemRenderer(index, object)
	object:initData(self.mallData[index + 1], self.fields.List_exchangeEvent)
end
function ExchangeShopMainPanel:onClickItem(context)
	local item = context:getGObjectData()
	item:onclickShow(context)
end
function ExchangeShopMainPanel:refreshRed(target, data)
	dump(data, "eventExchangeStoreView:refreshRed", 10)
	for i, v in ipairs(self.mallData) do
		if data.eventID == v.activityID then
			local single = self.fields.List_exchangeEvent:getChildAt(i - 1)
			local ret, num = newExchangeMallCtrl:getReceiveStatusAndNum(v.activityID)
			single:setRedPointVisible(ret)
			return
		end
	end
end
function ExchangeShopMainPanel:onClickHelp()
end
function ExchangeShopMainPanel:judgeClose()
	if not clientEventMgr.getEventInfoByeid(self.activityID) then
		if self then
			SoraDRemoveAllAfterPanelFromManager(self)
		end
	else
		self:initData()
	end
end
function ExchangeShopMainPanel:onShow()
	print("=======ExchangeShopMainPanel:onShow")
	self:showFire()
end
function ExchangeShopMainPanel:onHide()
	print("=======ExchangeShopMainPanel:onHide")
	self:hideFire()
	_ENV = self
	self.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	self.eventID = self.activityID
	SoraDSendMessage(self)
end
function ExchangeShopMainPanel:onDispose()
	print("=======ExchangeShopMainPanel:onDispose")
end
return ExchangeShopMainPanel

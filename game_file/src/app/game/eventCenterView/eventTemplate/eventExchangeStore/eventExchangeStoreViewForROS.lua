local gametop = gModuleMgr.getObject("gametop")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local exchangeMallCtrl = gametop.playertop_:getModule("exchangeMallCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local publicRead = include("publicRead")
local shopltCtrl = gModuleMgr.sharedMgr("shopltCtrl")
local eventExchangeStoreViewForROS = class("eventExchangeStoreViewForROS", function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventExchangeStoreViewForROS")
	end
	return target
end)
function eventExchangeStoreViewForROS:ctor()
	self.exchangeItemIDArray, _ENV, self.tableSingle, _ENV, self.tableData, _ENV = nil, nil, nil, nil, nil, nil
	self.exchangeItemID = 802401
	self.activityID = gActivityTimeActivityID.EXCHANGE_MALL
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_title")
	self.ccs_title:setTitle(i18n("common_text_1809"))
	self.node_item = SoraDGetChildByName(self, "Node_item")
	self.icon_item = SoraDGetChildByName(self.node_item, "icon_item")
	self.Text_num = SoraDGetChildByName(self.node_item, "Text_num")
	self.node_time = SoraDGetChildByName(self, "Node_time")
	self.node_time:setVisible(false)
	self.text_time = SoraDGetChildByName(self, "Text_time")
	self.text_time = SoraDCreateTimerLabel(self, self.text_time)
	self.Button_toShop = SoraDGetChildByName(self, "Button_toShop")
	self.Button_toShop:addTouchEventListener(handler(self, self.btnGoShopClick))
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_items")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("exchangeSingle")
	self.btns = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX_btns")
	self:setTime()
	self:initData()
end
function eventExchangeStoreViewForROS:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EXCHANGEMALL_SET_REFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EXCHANGEMALL_EX_REFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_CLOSELOADING", function()
		SoraDCloseLoading(self)
	end)
end
function eventExchangeStoreViewForROS:setTime()
	local activityTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	if activityTime then
		self.node_time:setVisible(true)
		self.text_time:beginTime(activityTime.timerNode.timer:getRemainTime())
		SoraDToCenter(self.node_time)
	end
end
function eventExchangeStoreViewForROS:setTabView()
	local exchangeIDArray = exchangeMallCtrl:getCostIDByActivityID(self.activityID)
	_ENV = exchangeMallCtrl
	exchangeIDArray, exchangeMallCtrl[1] = exchangeMallCtrl, exchangeIDArray
	local exchangeMallCtrl, configData = exchangeMallCtrl, exchangeMallCtrl
	configData.tabsetArray, exchangeMallCtrl, configData.tabNum = #exchangeIDArray, #exchangeIDArray, #exchangeIDArray
	for k, v in ipairs(exchangeIDArray) do
		exchangeMallCtrl = nil
		;(nil).title = publicRead.getName(v)
		;(nil).handle = handler(self, self.btnClickCallBack)
		;(nil).tag = v
		table.insert(configData.tabsetArray, nil)
	end
	self.btns:reset()
	self.btns:initView(configData)
end
function eventExchangeStoreViewForROS:setShopBtnView()
	self.icon_item:setSpriteFrame(publicRead.getIcon(self.exchangeItemID))
	local ownNum = backpackCtrl:getItemCount(self.exchangeItemID)
	self.Text_num:setString(ownNum)
	SoraDToCenter(self.node_item)
end
function eventExchangeStoreViewForROS:initData(target, data)
	if not target or data and data.notify then
		self:setTabView()
	end
	self:setShopBtnView()
	self:refreshScroll()
end
function eventExchangeStoreViewForROS:btnGoShopClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local itemInfo = shopltCtrl:getShopItemByItemID(self.exchangeItemID)
		if itemInfo then
			_ENV = nil
			;(nil).type = 1
			;(nil).mid = self.exchangeItemID
			uiManager:show("bagView", nil)
		else
			SoraDShowMsgTip(i18n("common_text_1976"))
		end
	end
end
function eventExchangeStoreViewForROS:refreshScroll()
	local mallData = exchangeMallCtrl:getConfigByActivityID(self.activityID)
	self.tableData = exchangeMallCtrl:getRealExchangeData(self.exchangeItemID, mallData)
	self:sortData()
	exchangeMallCtrl = nil
	;(nil).scroll = self.scroll
	;(nil).view = self
	;(nil).activityID = self.activityID
	;(nil).exchangeItemID = self.exchangeItemID
	self.scroll:updateScrollView(cc.size(624, 160), self.tableData, 1, nil)
end
function eventExchangeStoreViewForROS:sortData()
	table.sort(self.tableData, function(a, b)
		local isExCountA = a.curExchangeNum < a.limitnum or a.limitType == 0
		local isExCountB = b.curExchangeNum < b.limitnum or b.limitType == 0
		if isExCountA and isExCountB or not isExCountA and not isExCountB then
			return a.remindStatus > b.remindStatus
		else
			return isExCountA
		end
	end)
end
function eventExchangeStoreViewForROS:btnClickCallBack(tag, name)
	self.exchangeItemID = tag
	self:setShopBtnView()
	self:refreshScroll()
	self.scroll:jumpToTop()
end
function eventExchangeStoreViewForROS:judgeClose()
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		self:removeFromParent()
	end
end
function eventExchangeStoreViewForROS:onExitPanel()
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	;(nil).eventID = self.activityID
	SoraDSendMessage(nil)
end
return eventExchangeStoreViewForROS

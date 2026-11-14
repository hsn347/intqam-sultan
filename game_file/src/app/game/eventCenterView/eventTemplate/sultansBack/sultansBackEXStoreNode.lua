local gametop = gModuleMgr.getObject("gametop")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local activityExchangeMallCtrl = gametop.playertop_:getModule("activityExchangeMallCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local activityExchangeMallRead = include("activityExchangeMallRead")
local sultansBackEXStoreNode = class("sultansBackEXStoreNode", function(target)
	if target == nil then
		return SoraDCreateBasePanel("sultansBackEXStoreNode")
	end
	return target
end)
function sultansBackEXStoreNode:onEnterPanel()
	SoraDGetCtrl("activityCenterUICtrl"):sendClearNewMsg(self.activityID)
end
function sultansBackEXStoreNode:ctor()
	self.activityID = gActivityTimeActivityID.SULTAN_BACK_MAIN_ACTIVITY
	self.Node_head = SoraDGetChildByName(self, "Node_head")
	self.node_item = SoraDGetChildByName(self, "Node_item")
	self.Text_num = SoraDGetChildByName(self, "Text_num")
	self.scroll = SoraDGetChildByName(self, "ScrollView_item")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("exchangeSingle")
	self.Node_time = SoraDGetChildByName(self, "Node_time")
	self.Text_time = SoraDGetChildByName(self, "Text_time")
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	self.Button_toShop = SoraDGetChildByName(self, "Button_toShop")
	self.Button_toShop:addTouchEventListener(handler(self, self.btnShowClick))
	self:suitView()
	self:initTime()
end
function sultansBackEXStoreNode:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_CLOSELOADING", function(target, data)
		self:initData()
		SoraDCloseLoading(self)
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH", handler(self, self.initData))
end
function sultansBackEXStoreNode:suitView()
	self.Node_head:setPositionY(display.height - 450)
	self.scroll:setPositionY(display.height - 455)
	self.scroll:setContentSize(cc.size(624, display.height - 455))
end
function sultansBackEXStoreNode:initTime()
	local eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	if eventTime then
		self.Text_time:setTimeLast(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n("common_text_607", nil)
		end)
		self.Text_time:beginTime(eventTime.timerNode.timer:getRemainTime())
		SoraDToCenter(self.Node_time)
	end
	SoraDToCenter(self.Node_time, 10)
end
function sultansBackEXStoreNode:initData()
	self.exchangeItemID = activityExchangeMallRead:getExchangeitemByID(self.activityID)
	self.tableData = activityExchangeMallRead.getShopItemListFromOri(self.activityID)
	local ownNum = backpackCtrl:getItemCount(self.exchangeItemID)
	activityExchangeMallRead = nil
	;(nil).count = ownNum
	self.Text_num:setString(i18n("common_text_1377", nil))
	SoraDToCenter(self.node_item)
	for k, v in ipairs(self.tableData) do
		v.index = k
		v.curExchangeNum = activityExchangeMallCtrl:getExchangeNum(v.activityID, v.shopItemID)
		v.remindStatus = activityExchangeMallCtrl:getRemindStatus(v.activityID, v.shopItemID)
	end
	table.sort(self.tableData, function(a, b)
		if a.curExchangeNum >= a.limitnum and b.curExchangeNum >= b.limitnum or a.curExchangeNum < a.limitnum and b.curExchangeNum < b.limitnum then
			return a.index < b.index
		elseif a.curExchangeNum >= a.limitnum and b.curExchangeNum < b.limitnum then
			return false
		elseif a.curExchangeNum < a.limitnum and b.curExchangeNum >= b.limitnum then
			return true
		end
	end)
	activityExchangeMallRead = activityExchangeMallCtrl:getRemindStatus(v.activityID, v.shopItemID)
	activityExchangeMallCtrl:getRemindStatus(v.activityID, v.shopItemID).activityID = self.activityID
	activityExchangeMallCtrl:getRemindStatus(v.activityID, v.shopItemID).exchangeItemID = self.exchangeItemID
	activityExchangeMallCtrl:getRemindStatus(v.activityID, v.shopItemID).scroll = self.scroll
	activityExchangeMallCtrl:getRemindStatus(v.activityID, v.shopItemID).view = self
	self.scroll:updateScrollView(cc.size(640, 166), self.tableData, 1, (activityExchangeMallCtrl:getRemindStatus(v.activityID, v.shopItemID)))
end
function sultansBackEXStoreNode:setParentView(parent)
end
function sultansBackEXStoreNode:btnShowClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowMsgTip(i18n("common_text_4529"))
	end
end
return sultansBackEXStoreNode

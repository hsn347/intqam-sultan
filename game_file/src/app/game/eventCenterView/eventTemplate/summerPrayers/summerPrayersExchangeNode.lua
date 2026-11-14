local summerPrayRead = include("summerPrayRead")
local activityExchangeMallRead = include("activityExchangeMallRead")
local summerPrayersExchangeNode = class("summerPrayersExchangeNode", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	target = target or SoraDCreateBasePanel("summerPrayersExchangeNode")
	SoraDDeviceFitOffset(target)
	return target
end)
function summerPrayersExchangeNode:ctor(properties)
	self.activityID = gActivityTimeActivityID.SUMMER_PRAY_ACTIVITY
	self.exchangeItemID = 815101
	self.nodeTimer = SoraDGetChildByName(self, "Node_text")
	self.textActivityTime = SoraDGetChildByName(self, "Text_activiey_time")
	self.textActivityTime = SoraDCreateTimerLabel(self, self.textActivityTime)
	self.scroll = SoraDGetChildByName(self, "Size_ScrollView")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("summerPrayersExchangeSingle")
	self.nodeSingle = SoraDGetChildByName(self, "Node_single")
	self.nodeAward = SoraDGetChildByName(self, "Node_Award")
	self.textTips = SoraDGetChildByName(self.nodeAward, "Text_Tips")
	self.textTips:setString(i18n("pray_text_27"))
	self:initActivityTime()
	self:initData()
	for i, v in ipairs(summerPrayRead.getBannerConfig()) do
		local single = include("commonItemAward").new()
		single:setScale(0.7)
		single:setPosition(SoraDFPosX(-40 - (i - 1) * 80, 0), -45)
		single:setOwnView(self.nodeAward)
		single:addTo(self.nodeAward)
		single:initData(v.banner_show[1], v.banner_show[2])
	end
end
function summerPrayersExchangeNode:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_REFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_CLOSELOADING", handler(self, self.initData))
end
function summerPrayersExchangeNode:initActivityTime()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	self.eventTime = activityShowCtrl:getEndTimeSecond(self.activityID)
	dump(self.eventTime - serviceFunctions.systemTime(), "self.eventTime", 10)
	self.textActivityTime:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("pray_text_22", nil)
	end)
	if self.eventTime then
		self.textActivityTime:beginTime(self.eventTime - serviceFunctions.systemTime())
	end
	SoraDToCenter(self.nodeTimer, 10, not SoraDFIsRA())
end
function summerPrayersExchangeNode:initData(target, data)
	SoraDCloseLoading(self:getParent())
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local classType = activityShowCtrl:getParamClassType(self.activityID)
	if not activityExchangeMallRead:getShopItemList(self.activityID, classType) then
		local _ENV, showShopItemList = activityExchangeMallRead:getShopItemList(self.activityID, classType), activityExchangeMallRead:getShopItemList(self.activityID, classType)
	end
	_ENV = self:getParent()
	self:getParent().scroll = self.scroll
	self:getParent().view = self:getParent()
	self:getParent().activityID = self.activityID
	self:getParent().exchangeItemID = self.exchangeItemID
	self.scroll:updateScrollView(cc.size(624, 170), showShopItemList, 1, self:getParent())
end
return summerPrayersExchangeNode

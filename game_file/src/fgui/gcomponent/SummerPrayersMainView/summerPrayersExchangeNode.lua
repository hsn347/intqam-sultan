local summerPrayRead = include("summerPrayRead")
local activityExchangeMallRead = include("activityExchangeMallRead")
local baseComponent = require("fgui.base.baseComponent")
local summerPrayersExchangeNode = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SummerPrayersMainView/summerPrayersExchangeNode", summerPrayersExchangeNode)
function summerPrayersExchangeNode:onInit()
	self.activityID = gActivityTimeActivityID.SUMMER_PRAY_ACTIVITY
	self.exchangeItemID = 815101
	self.textActivityTime = SoraDGetChildByName(self, "Label_time")
	self.scroll = SoraDGetChildByName(self, "Size_ScrollView")
	self.scroll:setItemRenderer(handler(self, self.onItemRederer))
	self.scroll:setVirtual()
	self.nodeAward = SoraDGetChildByName(self, "Node_Award")
	self.textTips = SoraDGetChildByName(self.nodeAward, "Text_Tips")
	self.textTips:setString(i18n("pray_text_27"))
	self:initActivityTime()
	self:initData()
	for i, v in ipairs(summerPrayRead.getBannerConfig()) do
		local single = fgui.UIPackage:createObject("CommonNew", "Com_item70")
		single:setPivot(0.5, 0.5, true)
		single:setPosition(-40 - (i - 1) * 80, 45)
		single:addTo(self.nodeAward)
		single:initData(v.banner_show[1], v.banner_show[2])
	end
	if not SoraDFIsRA() then
		self.nodeAward:fixPos()
		self.nodeAward:fixChildren()
		self.nodeAward:fixChildrenPos()
	end
end
function summerPrayersExchangeNode:onShow()
end
function summerPrayersExchangeNode:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_REFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_CLOSELOADING", handler(self, self.initData))
end
function summerPrayersExchangeNode:initActivityTime()
	self.textActivityTime:initActivityTimeStyle(self.activityID, "pray_text_22")
end
function summerPrayersExchangeNode:initData(target, data)
	SoraDCloseLoading(self:getParent())
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local classType = activityShowCtrl:getParamClassType(self.activityID)
	if not activityExchangeMallRead:getShopItemList(self.activityID, classType) then
		local _ENV, showShopItemList = activityExchangeMallRead:getShopItemList(self.activityID, classType), activityExchangeMallRead:getShopItemList(self.activityID, classType)
	end
	self.showShopItemList = showShopItemList
	self.scroll:setNumItems(#self.showShopItemList)
end
function summerPrayersExchangeNode:onItemRederer(index, obj)
	local data = self.showShopItemList[index + 1]
	_UPVALUE0_ = nil
	;(nil).view = self:getParent()
	;(nil).activityID = self.activityID
	;(nil).exchangeItemID = self.exchangeItemID
	obj:initData(data, nil)
end
return summerPrayersExchangeNode

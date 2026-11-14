local publicRead = include("publicRead")
local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local activityExchangeMallRead = include("activityExchangeMallRead")
local basePanel = require("fgui.base.baseFguiPanel")
local troopsExchangeShopPanel = class("troopsExchangeShopPanel", basePanel)
function troopsExchangeShopPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
end
function troopsExchangeShopPanel:getPackageList()
	if not self._packageList then
		_UPVALUE4_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "TroopsChange"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI1"
	end
	return self._packageList
end
function troopsExchangeShopPanel:onInit()
	self.itemId = activityExchangeMallRead:getExchangeitemByID(gActivityTimeActivityID.PREFERENTIAL_SHOP_ACTIVITY)
	self.activityID = gActivityTimeActivityID.PREFERENTIAL_SHOP_ACTIVITY
	self.txt_time = SoraDCreateTimerLabel(self, self.fields.txt_time)
	self.fields.Com_title:initData(i18n("activity_name_9001370"), handler(self, self.onClickClose))
	self.fields.scroll:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_toShop:addClickListener(handler(self, self.btnGoShopClick))
	self.fields.Button_toShop:getChildByName("icon"):setURL(publicRead.getIcon(self.itemId))
end
function troopsExchangeShopPanel:onShow()
	self:initActivityTime()
	self:updataScroll()
	self:updateItemsNum()
end
function troopsExchangeShopPanel:updateItemsNum()
	self.fields.Button_toShop:setString(string.formatnumberthousands(activityExchangeMallCtrl:getExchangeItemNum(self.itemId)))
end
function troopsExchangeShopPanel:updataScroll()
	if not activityExchangeMallRead:getShopItemList(self.activityID) then
		activityExchangeMallRead = activityExchangeMallRead:getShopItemList(self.activityID)
	end
	self.showShopItemList = activityExchangeMallRead:getShopItemList(self.activityID)
	self.fields.scroll:setNumItems(math.ceil(table.nums(self.showShopItemList) / 3))
end
function troopsExchangeShopPanel:initActivityTime()
	self.txt_time:setTimeLast(function(strTime)
		_ENV = nil
		_ENV, _ENV, (nil).time = nil, nil, strTime
		_ENV, (nil).time, (nil).color = nil, nil, "#FFFFFF"
		;(nil).__default, (nil).color = nil, "#FFC864"
		return i18n_html("common_text_4415", nil, nil)
	end)
	local timer = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.PREFERENTIAL_SHOP_ACTIVITY)
	if timer then
		local leftTime = timer.timerNode.timer:getRemainTime()
		if 0 < leftTime then
			self.txt_time:beginTime(leftTime)
		else
			self:close()
		end
	end
end
function troopsExchangeShopPanel:btnGoShopClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).itemID = self.itemId
	uiManager:show("CommonSourceGuide", nil)
end
function troopsExchangeShopPanel:onItemRenderer(index, object)
	local beginIndex = index * 3
	object:initData(self.showShopItemList[beginIndex + 1], self.showShopItemList[beginIndex + 2], self.showShopItemList[beginIndex + 3])
end
return troopsExchangeShopPanel

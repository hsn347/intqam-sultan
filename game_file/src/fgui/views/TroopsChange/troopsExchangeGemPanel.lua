local publicUtil = include("publicUtil")
local publicRead = include("publicRead")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local gemExchangeCtrl = SoraDGetCtrl("gemExchangeCtrl")
local basePanel = require("fgui.base.baseFguiPanel")
local troopsExchangeGemPanel = class("troopsExchangeGemPanel", basePanel)
function troopsExchangeGemPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
end
function troopsExchangeGemPanel:getPackageList()
	if not self._packageList then
		_UPVALUE4_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "TroopsChange"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI1"
	end
	return self._packageList
end
function troopsExchangeGemPanel:onInit()
	self.tag1 = 1
	self.tag2 = 1
	self.itemId = 843101
	self.fields.Button_toShop:getChildByName("icon"):setURL(publicRead.getIcon(self.itemId))
	self.activityID = gActivityTimeActivityID.GEM_EXCHANGE_ACTIVITY
	self.txt_time = SoraDCreateTimerLabel(self, self.fields.txt_time)
	self.fields.Com_title:initData(i18n("activity_name_9001373"), handler(self, self.onClickClose))
	self.fields.btn_Log:addClickListener(handler(self, self.onClickLog))
	self.fields.btn_Log:setString(i18n("common_text_836"))
	self.fields.btn_Log:fixPos()
	self.fields.scroll:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_toShop:addClickListener(handler(self, self.btnGoShopClick))
	publicRead = self.fields.Button_toShop.addClickListener
	publicRead, _UPVALUE4_, self.fields.Button_toShop.addClickListener.defaultClick = handler(self, self.btnGoShopClick)
	handler(self, self.btnGoShopClick).title = i18n("armyExchange_text_013")
	publicRead, handler(self, self.btnGoShopClick).tag = i18n("armyExchange_text_013"), 1
	i18n("armyExchange_text_013").title = i18n("armyExchange_text_014")
	publicRead, i18n("armyExchange_text_013").tag = i18n("armyExchange_text_014"), 2
	i18n("armyExchange_text_014").title = i18n("armyExchange_text_015")
	publicRead, i18n("armyExchange_text_014").tag = i18n("armyExchange_text_015"), 3
	i18n("armyExchange_text_015").title = i18n("armyExchange_text_016")
	i18n("armyExchange_text_015").tag = 4
	self.fields.Button_toShop.addClickListener.tabsetArray, self.tag1[1] = self.tag1, handler(self, self.btnGoShopClick)
	self.fields.Button_toShop.addClickListener.tabsetArray, self.tag1[2] = self.tag1, i18n("armyExchange_text_013")
	self.fields.Button_toShop.addClickListener.tabsetArray, self.tag1[3] = self.tag1, i18n("armyExchange_text_014")
	self.fields.Button_toShop.addClickListener.tabsetArray, self.tag1[4] = self.tag1, i18n("armyExchange_text_015")
	local param = self.fields.Button_toShop.addClickListener
	self.fields.com_Tab:initView(param)
	self.fields.com_Tab:setBtnCallback(handler(self, self.onClickTab))
	publicRead = self.fields.com_Tab.setBtnCallback
	publicRead, _UPVALUE3_, self.fields.com_Tab.setBtnCallback.defaultClick = handler(self, self.onClickTab)
	handler(self, self.onClickTab).title = i18n("armyExchange_text_039")
	publicRead, handler(self, self.onClickTab).tag = i18n("armyExchange_text_039"), 1
	i18n("armyExchange_text_039").title = i18n("armyExchange_text_040")
	publicRead, i18n("armyExchange_text_039").tag = i18n("armyExchange_text_040"), 2
	i18n("armyExchange_text_040").title = i18n("armyExchange_text_041")
	i18n("armyExchange_text_040").tag = 3
	param, self.fields.com_Tab.setBtnCallback.tabsetArray, self.tag2[1] = self.fields.com_Tab.setBtnCallback, self.tag2, handler(self, self.onClickTab)
	param, self.fields.com_Tab.setBtnCallback.tabsetArray, self.tag2[2] = self.fields.com_Tab.setBtnCallback, self.tag2, i18n("armyExchange_text_039")
	param, self.fields.com_Tab.setBtnCallback.tabsetArray, self.tag2[3] = self.fields.com_Tab.setBtnCallback, self.tag2, i18n("armyExchange_text_040")
	self.fields.com_Tab2:setTabNum(3, nil, true)
	self.fields.com_Tab2:initView(param)
	self.fields.com_Tab2:setBtnCallback(handler(self, self.onClickTab2))
end
function troopsExchangeGemPanel:onShow()
	self:initActivityTime()
	self:updateItemsNum()
	self:updateRedPoint()
	SoraDShowLoading()
	self:updatTaskScroll()
	SoraDCloseLoading()
end
function troopsExchangeGemPanel:onClickTab(tag)
	self.tag1 = tag
	self.fields.com_Tab2:setTabIndex(1, true)
end
function troopsExchangeGemPanel:onClickTab2(tag)
	self.tag2 = tag
	self:updatTaskScroll()
	self:updateRedPoint2()
	self:updateItemsNum()
	self.fields.scroll:jumpToTop()
end
function troopsExchangeGemPanel:updateItemsNum()
	self.fields.Button_toShop:setString(string.formatnumberthousands(publicUtil.getCount(self.itemId)))
end
function troopsExchangeGemPanel:updatTaskScroll()
	self.indexList = gemExchangeCtrl:getStoneExchangeList(self.tag1, self.tag2)
	self.fields.scroll:setNumItems(#self.indexList)
end
function troopsExchangeGemPanel:updateRedPoint()
	for i = 1, 4 do
		local visible, num = gemExchangeCtrl:getReceiveStatusAndNum(i)
		print(visible, num, i, "updateRedPoint")
		self.fields.com_Tab:setBtnRedDot(i, visible, num)
	end
	self:updateRedPoint2()
end
function troopsExchangeGemPanel:updateRedPoint2()
	for i = 1, 3 do
		local num = gemExchangeCtrl:getRedNumByType(self.tag1, i)
		self.fields.com_Tab2:setBtnRedDot(i, 0 < num, num)
	end
end
function troopsExchangeGemPanel:initActivityTime()
	self.txt_time:setTimeLast(function(strTime)
		_ENV = nil
		_ENV, _ENV, (nil).time = nil, nil, strTime
		_ENV, (nil).time, (nil).color = nil, nil, "#FFFFFF"
		;(nil).__default, (nil).color = nil, "#FFC864"
		return i18n_html("common_text_4415", nil, nil)
	end)
	local timer = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.GEM_EXCHANGE_ACTIVITY)
	if timer then
		local leftTime = timer.timerNode.timer:getRemainTime()
		if 0 < leftTime then
			self.txt_time:beginTime(leftTime)
		else
			self:close()
		end
	end
end
function troopsExchangeGemPanel:onItemRenderer(index, object)
	print(self.indexList[index + 1])
	object:initData(self.indexList[index + 1])
end
function troopsExchangeGemPanel:onClickLog()
	SoraDPlaySound()
	_ENV = nil
	;(nil).type = 0
	uiManager:show("troopsExchangeLog", nil)
end
function troopsExchangeGemPanel:onHide()
	gemExchangeCtrl:reSetChooseIndex()
end
function troopsExchangeGemPanel:btnGoShopClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).itemID = self.itemId
	uiManager:show("CommonSourceGuide", nil)
end
return troopsExchangeGemPanel

local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local newExchangeMallCtrl = SoraDGetCtrl("newExchangeMallCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local publicRead = include("publicRead")
local shopltCtrl = gModuleMgr.sharedMgr("shopltCtrl")
local newExchangeMallRead = include("newExchangeMallRead")
local constantRead = include("constantRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ExchangeEventPagePanel = class("ExchangeEventPagePanel", baseFguiPanel)
function ExchangeEventPagePanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("ExchangeEventPagePanel:ctor", self.viewName)
end
function ExchangeEventPagePanel:getPackageList()
	if not self._packageList then
		_UPVALUE2_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "ExchangeShopNew"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
	end
	return self._packageList
end
local foreverTime = 315360000
_ENV = baseFguiPanel
_ENV = nil
baseFguiPanel[gActivityTimeActivityID.EXCHANGE_MALL_RED_GEM], (nil).title = nil, "shop_name_02"
_ENV = nil
baseFguiPanel[gActivityTimeActivityID.EXCHANGE_MALL_RAMADAN], (nil).title = nil, "shop_name_9001172"
_ENV = nil
baseFguiPanel[gActivityTimeActivityID.EXCHANGE_MALL_SPIRITUAL_GIFT], (nil).title = nil, "activity_name_34"
_ENV = nil
baseFguiPanel[gActivityTimeActivityID.EXCHANGE_MALL_SPIRITUAL_GIFT_NEW], (nil).title = nil, "activity_name_34"
_ENV = nil
baseFguiPanel[gActivityTimeActivityID.EXCHANGE_MALL_SALARY], (nil).title = nil, "treasuremap_text_40"
_ENV = nil
baseFguiPanel[gActivityTimeActivityID.EXCHANGE_MALL_SNATCH_TREASURE], (nil).title = nil, "activity_name_9001270"
_ENV = nil
baseFguiPanel[gActivityTimeActivityID.RIDES_EXCHANGE_MALL], (nil).title = nil, "activity_name_06"
_ENV = nil
baseFguiPanel[gActivityTimeActivityID.EXCHANGE_MALL_TROOPS_MARCHING_EFFECT], (nil).title = nil, "activity_name_9001235"
_ENV = nil
baseFguiPanel[gActivityTimeActivityID.EXCHANGE_MALL_PAY_DRESS_UP], (nil).title = nil, "activity_name_9001236"
_ENV = nil
baseFguiPanel[gActivityTimeActivityID.EXCHANGE_MALL_RED_GEM_CROSS_SERVER], (nil).title = nil, "shop_name_02"
_ENV = nil
baseFguiPanel[gActivityTimeActivityID.EXCHANGE_MALL_ACTIVITY_9001385], (nil).title = nil, "activity_name_9001385"
_ENV = nil
baseFguiPanel[gActivityTimeActivityID.EXCHANGE_MALL_ACTIVITY_9001386], (nil).title = nil, "activity_name_9001386"
_ENV = nil
baseFguiPanel[gActivityTimeActivityID.EXCHANGE_MALL_NEBULA], (nil).title = nil, "activity_name_9001388"
_ENV = nil
baseFguiPanel[gActivityTimeActivityID.NEBULA_REGION_ACTIVITY], (nil).title = nil, "activity_name_9001444"
_ENV = nil
baseFguiPanel[gActivityTimeActivityID.EXCHANGE_MALL_NEBULA_ADVANCE], (nil).title = nil, "activity_name_9001391"
_ENV = nil
baseFguiPanel[gActivityTimeActivityID.EXCHANGE_MALL_NATION_CELEBTATE], (nil).title = nil, "activity_name_9001393"
_ENV = nil
baseFguiPanel[gActivityTimeActivityID.EXCHANGE_MALL_NEBULA_STONE], (nil).title = nil, "activity_name_9001395"
_ENV = nil
baseFguiPanel[gActivityTimeActivityID.EXCHANGE_MALL_GODPOWER], (nil).title = nil, "activity_name_9001465"
_ENV = nil
baseFguiPanel[gActivityTimeActivityID.EXCHANGE_MALL_HTJC], (nil).title = nil, "activity_name_9001469"
_ENV = nil
baseFguiPanel[gActivityTimeActivityID.EXCHANGE_MALL_HYFL], (nil).title = nil, "activity_name_9001549"
_ENV = nil
baseFguiPanel[gActivityTimeActivityID.EXCHANGE_MALL_SKYROCKET], (nil).title = nil, "activity_name_9001550"
_ENV = nil
_ENV, baseFguiPanel[gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010004], (nil).title = gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010004, nil, "activity_name_9010004"
local tableOfActivitiesInfo = baseFguiPanel
gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010004[gActivityTimeActivityID.EXCHANGE_MALL_NEBULA] = true
gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010004[gActivityTimeActivityID.EXCHANGE_MALL_NEBULA_ADVANCE] = true
gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010004[gActivityTimeActivityID.EXCHANGE_MALL_NATION_CELEBTATE] = true
gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010004[gActivityTimeActivityID.EXCHANGE_MALL_NEBULA_STONE] = true
gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010004[gActivityTimeActivityID.EXCHANGE_MALL_GODPOWER] = true
gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010004[gActivityTimeActivityID.EXCHANGE_MALL_ICEDRADON_MARCH] = true
gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010004[gActivityTimeActivityID.EXCHANGE_MALL_QUENCHINGSTARS_MARCH] = true
gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010004[gActivityTimeActivityID.EXCHANGE_MALL_HTJC] = true
gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010004[gActivityTimeActivityID.EXCHANGE_MALL_HYFL] = true
gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010004[gActivityTimeActivityID.EXCHANGE_MALL_SKYROCKET] = true
gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010004[gActivityTimeActivityID.EXCHANGE_MALL_XJZBFC] = true
gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010004[gActivityTimeActivityID.EXCHANGE_ACTIVITY_9001554] = true
gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010004[gActivityTimeActivityID.EXCHANGE_ACTIVITY_9001589] = true
gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010004[gActivityTimeActivityID.EXCHANGE_ACTIVITY_9001595] = true
gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010004[gActivityTimeActivityID.EXCHANGE_ACTIVITY_9001603] = true
gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010004[gActivityTimeActivityID.EXCHANGE_ACTIVITY_9001635] = true
gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010004[gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010004] = true
gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010004[gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010007] = true
gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010004[gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010008] = true
gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010004[gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010012] = true
gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010004[gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010015] = true
local _ENV, gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010004[gActivityTimeActivityID.EXCHANGE_MALL_ACTIVITY_9010010], tableOfActOutputCommon = gActivityTimeActivityID.EXCHANGE_MALL_ACTIVITY_9010010, true, gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010004
local _ENV, gActivityTimeActivityID.EXCHANGE_MALL_ACTIVITY_9010010[gActivityTimeActivityID.NEBULA_REGION_ACTIVITY], tableOfActGiftCommon = gActivityTimeActivityID.NEBULA_REGION_ACTIVITY, true, gActivityTimeActivityID.EXCHANGE_MALL_ACTIVITY_9010010
gActivityTimeActivityID.NEBULA_REGION_ACTIVITY[gActivityTimeActivityID.EXCHANGE_MALL_DRESS_ROLL] = true
gActivityTimeActivityID.NEBULA_REGION_ACTIVITY[gActivityTimeActivityID.EXCHANGE_ACTIVITY_9001552] = not SoraDGetCtrl("badgeExchangeCtrl"):isOpenBadge()
local gActivityTimeActivityID.NEBULA_REGION_ACTIVITY[gActivityTimeActivityID.EXCHANGE_ACTIVITY_9001553], tableHideToShopButton = not SoraDGetCtrl("badgeExchangeCtrl"):isOpenBadge(), gActivityTimeActivityID.NEBULA_REGION_ACTIVITY
function ExchangeEventPagePanel:onInit()
	self.tabIndex = 1
	self.tableSingle, _ENV, self.tabArray, _ENV, self.tableData, _ENV, self.tabNum = nil, nil, nil, nil, nil, nil, 1
	self.activityID = gActivityTimeActivityID.RIDES_EXCHANGE_MALL
	self.Button_toShop = self.fields.Button_toShop
	self.Com_eventInfo = self.fields.Com_eventInfo
	self.fields.Com_title:initData(i18n("activity_name_06"), handler(self, self.onClickClose))
	self.fields.Com_title:setTitleFontSize(22)
	self.Button_toShop:addClickListener(handler(self, self.btnGoShopClick))
	self.fields.List_exchange:setVirtual()
	self.fields.List_exchange:setItemRenderer(handler(self, self.onItemRenderer))
	self:setActivityID(self.proxy.param.id)
end
function ExchangeEventPagePanel:initTabView()
	local strList = newExchangeMallRead.getTabConfig(self.activityID)
	self.tabNum = 0
	for i, v in ipairs(strList) do
		self.tabNum = self.tabNum + 1
		newExchangeMallRead = nil
		;(nil).title = i18n(v)
		;(nil).tag = i
		table.insert(self.tabArray, nil)
	end
	self.tabNum = math.max(self.tabNum, 1)
	local exTabData = tableOfActivitiesInfo[self.activityID] and tableOfActivitiesInfo[self.activityID].tabData or nil
	if self.tabNum > 1 then
		newExchangeMallRead = nil
		;(nil).defaultClick = 1
		;(nil).tabsetArray = self.tabArray
		;(nil).unDefaultClick = true
		;(nil).callback = handler(self, self.onClickTab)
		self.fields.com_TabW:initView(nil)
		self.fields.com_TabW:setTabIndex(1)
		self.controllers.c1:setSelectedIndex(1)
	elseif exTabData and next(exTabData) then
		self.controllers.c1:setSelectedIndex(2)
		self.fields.Com_tab:initView(exTabData)
	else
		self.controllers.c1:setSelectedIndex(0)
	end
end
function ExchangeEventPagePanel:initData(target, data)
	self:getExchangeDataList()
	_UPVALUE0_ = self.getExchangeDataList
	self.otherData, self.getExchangeDataList.activityID = self.getExchangeDataList, self.activityID
	self.fields.List_exchange:setNumItems(#self.tableData[self.tabIndex])
end
function ExchangeEventPagePanel:initToShop(target, data)
	self.exchangeItemIDArray = newExchangeMallCtrl:getCostIDByActivityID(self.activityID)
	if #self.exchangeItemIDArray > 2 then
		table.sort(self.exchangeItemIDArray, function(a, b)
			return b < a
		end)
	end
	if self.activityID == gActivityTimeActivityID.EXCHANGE_MALL_SNATCH_TREASURE then
		self.Button_toShop:setIconNumVisibility(false)
		self.Button_toShop:setTitle(i18n("Martial_arts_text_06"))
	elseif self.activityID ~= gActivityTimeActivityID.EXCHANGE_MALL_DRESS_ROLL then
		self.Button_toShop:setIconNumVisibility(true)
		self.Button_toShop:setIconAndNum(self.exchangeItemIDArray)
		self.Button_toShop:setTitle("")
	end
	self.fields.Button_toShop:setVisible(not tableHideToShopButton[self.activityID])
end
function ExchangeEventPagePanel:onItemRenderer(index, object)
	object:initData(self.tableData[self.tabIndex][index + 1], self.otherData)
end
function ExchangeEventPagePanel:setTime()
	if self.activityID == gActivityTimeActivityID.EXCHANGE_MALL_GODPOWER or self.activityID == gActivityTimeActivityID.EXCHANGE_MALL_XJZBFC then
		self.Com_eventInfo:setTimeVisible(false)
	else
		local activityTime = activityShowCtrl:getTimeInfoByID(self.activityID)
		if activityTime then
			self.Com_eventInfo:initData(self.activityID)
			self.Com_eventInfo:setTimeFont(20, cc.c3b(255, 255, 255))
			self.Com_eventInfo:setTimeIconScale(0.7)
			self.Com_eventInfo:setTimeVisible(true)
			self.Com_eventInfo:setTime(activityTime.timerNode.timer:getRemainTime())
			if activityTime.timerNode.timer:getRemainTime() >= foreverTime then
				self.Com_eventInfo:setTimeVisible(false)
			end
		end
	end
end
function ExchangeEventPagePanel:getExchangeDataList()
	local allData = newExchangeMallCtrl:getConfigByActivityID(self.activityID, self.classtype)
	for i = 1, self.tabNum do
		self.tableData[i], newExchangeMallCtrl = nil, nil
	end
	for i, v in ipairs(allData) do
		v.weight = 0
		if 0 < v.limitnum - v.curExchangeNum then
			v.weight = 1
		end
		local tabIndex = v.itemSheet or 0
		tabIndex = tabIndex > self.tabNum and 1 or tabIndex
		tabIndex = math.max(1, tabIndex)
		table.insert(self.tableData[tabIndex], v)
	end
	self:sortData()
end
function ExchangeEventPagePanel:sortData()
	for i, v in ipairs(self.tableData) do
		table.sort(v, function(a, b)
			if a.weight ~= b.weight then
				return a.weight > b.weight
			else
				return a.index < b.index
			end
		end)
	end
end
function ExchangeEventPagePanel:setActivityID(activityID)
	if not activityID then
		return
	end
	self.activityID = activityID
	local param = activityShowCtrl:getParamByID(self.activityID)
	self.classtype = param.classtype or 1
	print("self.activityID======", self.activityID, self.classtype)
	if self.fields.Button_toShop:isVisible() then
		local left = self.fields.Button_toShop:getPositionX() - self.fields.Button_toShop:getWidth()
		local newWidth = (left - display.width / 2 - 2) * 2
		self.fields.Com_title:setTitleWidthHeight(newWidth, 60)
	else
		self.fields.Com_title:setTitleWidthHeight(360, 40)
	end
	if not newExchangeMallRead.getNewCfg(self.activityID) then
		local activityShowCtrl, newCfg = newExchangeMallRead.getNewCfg(self.activityID), newExchangeMallRead.getNewCfg(self.activityID)
	end
	if newCfg.activityname or tableOfActivitiesInfo[self.activityID] then
		self.fields.Com_title:updateTitle(i18n(newCfg.activityname or tableOfActivitiesInfo[self.activityID].title))
	else
		self.fields.Com_title:updateTitle(i18n(string.format("activity_exchange_%s", self.activityID)))
	end
	self:initTabView()
	self:initToShop()
	self:initData()
	self:setTime()
	self:setBgAndIcon()
end
function ExchangeEventPagePanel:setBgAndIcon()
	local newActivityID = self:replaceResource(self.activityID)
	if not newExchangeMallRead.getNewCfg(newActivityID) then
		local newExchangeMallRead, newCfg = newExchangeMallRead.getNewCfg(newActivityID), newExchangeMallRead.getNewCfg(newActivityID)
	end
	local bgName = string.format("bg_exchange_%d.png", newActivityID)
	self.Com_eventInfo:setBg(newCfg.exchcange_bg or bgName)
	self.Com_eventInfo:replaceBg(newActivityID)
	_UPVALUE2_ = newActivityID
	newActivityID[1] = "ar"
	newActivityID[2] = "en"
	local iconName = SoraDGetImageNameByLang("bg_exchange_" .. newActivityID .. "_%s.png", newActivityID)
	local iconCfg = SoraDFIsRA() and newCfg.wordart_ar or newCfg.wordart_en
	self.Com_eventInfo:setIcon(iconCfg or iconName)
end
function ExchangeEventPagePanel:replaceResource(actID)
	if actID == gActivityTimeActivityID.EXCHANGE_MALL_RED_GEM_CROSS_SERVER then
		return gActivityTimeActivityID.EXCHANGE_MALL_RED_GEM
	end
	return actID
end
function ExchangeEventPagePanel:btnGoShopClick(context)
	SoraDPlaySound()
	if self.activityID == gActivityTimeActivityID.EXCHANGE_MALL_COMMON_DRESS or self.activityID == gActivityTimeActivityID.EXCHANGE_MALL_DRESS_ROLL then
		_ENV = nil
		;(nil).type = 1
		;(nil).jumpStore = "btnOther"
		uiManager:show("bagView", nil)
	elseif self.activityID == gActivityTimeActivityID.EXCHANGE_MALL_MES_CASTLE then
		_UPVALUE4_ = self.activityID
		self.activityID[1] = 13971
		self.activityID[2] = 13972
		self.activityID[3] = 13973
		local self.activityID[4], giftArray = 13974, self.activityID
		if GLOBAL_GAME_RECHARGE_MODE then
			_ENV = 13974
			;(13974).rechargeIDList = giftArray
			uiManager:show("rechargeView", 13974)
		else
			local panel = SoraDCreatePanel("rechargeView")
			panel:jumpToLimitNodeByList(12, giftArray)
			panel:show()
		end
	elseif self.activityID == gActivityTimeActivityID.EXCHANGE_MALL_GF_CASTLE then
		_UPVALUE5_ = self.activityID
		self.activityID[1] = 14083
		self.activityID[2] = 14084
		self.activityID[3] = 14085
		self.activityID[4] = 14086
		local self.activityID[5], giftArray = 14132, self.activityID
		if GLOBAL_GAME_RECHARGE_MODE then
			_ENV = 14086
			;(14086).rechargeIDList = giftArray
			uiManager:show("rechargeView", 14086)
		else
			local panel = SoraDCreatePanel("rechargeView")
			panel:jumpToLimitNodeByList(12, giftArray)
			panel:show()
		end
	elseif self.activityID == gActivityTimeActivityID.EXCHANGE_MALL_SNATCH_TREASURE then
		local eventState = activityShowCtrl:getStateByID(gActivityTimeActivityID.EXCHANGE_MALL_SNATCH_TREASURE)
		if eventState == gActivityState.OPEN then
			local panel = SoraDCreatePanel("raidersLostArkView")
			panel:show()
		else
			SoraDShowMsgTip(i18n("common_text_2486"))
		end
	elseif self.activityID == gActivityTimeActivityID.EXCHANGE_MALL_9001224 then
		_UPVALUE4_ = self.activityID
		self.activityID[1] = 14304
		self.activityID[2] = 14305
		self.activityID[3] = 14306
		local self.activityID[4], giftArray = 14307, self.activityID
		if GLOBAL_GAME_RECHARGE_MODE then
			_ENV = 14307
			;(14307).rechargeIDList = giftArray
			uiManager:show("rechargeView", 14307)
		else
			local panel = SoraDCreatePanel("rechargeView")
			panel:jumpToLimitNodeByList(12, giftArray)
			panel:show()
		end
	elseif self.activityID == gActivityTimeActivityID.EXCHANGE_MALL_NUMBER_ONE then
		_UPVALUE4_ = self.activityID
		self.activityID[1] = 14448
		self.activityID[2] = 14449
		self.activityID[3] = 14450
		local self.activityID[4], giftArray = 14451, self.activityID
		if GLOBAL_GAME_RECHARGE_MODE then
			_ENV = 14451
			;(14451).rechargeIDList = giftArray
			uiManager:show("rechargeView", 14451)
		else
			local panel = SoraDCreatePanel("rechargeView")
			panel:jumpToLimitNodeByList(12, giftArray)
			panel:show()
		end
	elseif self.activityID == gActivityTimeActivityID.EXCHANGE_MALL_STAR_MOON_TREASURE then
		_ENV = panel
		panel.itemID = 730401
		uiManager:show("CommonSourceGuide", panel)
	elseif self.activityID == gActivityTimeActivityID.EXCHANGE_MALL_RAMADAN then
		clientEventMgr.singleClickEvent(gActivityTimeActivityID.COFFEE_CRAFTSMAN_ACTIVITY)
	elseif self.activityID == gActivityTimeActivityID.EXCHANGE_MALL_DRESS_ICE_CASTLE then
		local activityTimeRead = include("activityTimeRead")
		if not activityTimeRead.getRechargeId(self.activityID) then
			local _ENV, giftArray = activityTimeRead.getRechargeId(self.activityID), activityTimeRead.getRechargeId(self.activityID)
		end
		if GLOBAL_GAME_RECHARGE_MODE then
			_ENV = giftArray
			giftArray.rechargeIDList = giftArray
			uiManager:show("rechargeView", giftArray)
		else
			local panel = SoraDCreatePanel("rechargeView")
			panel:jumpToLimitNodeByList(12, giftArray)
			panel:show()
		end
	elseif self.activityID == gActivityTimeActivityID.EXCHANGE_MALL_STAR_MOON_KEY then
		_ENV = panel.show
		panel.show.itemID = 728901
		uiManager:show("CommonSourceGuide", panel.show)
	elseif self.activityID == gActivityTimeActivityID.EXCHANGE_MALL_THUNDERCLOUD then
		local activityTimeRead = include("activityTimeRead")
		if not activityTimeRead.getRechargeId(self.activityID) then
			local _ENV, giftArray = activityTimeRead.getRechargeId(self.activityID), activityTimeRead.getRechargeId(self.activityID)
		end
		if GLOBAL_GAME_RECHARGE_MODE then
			_ENV = 12
			;(12).rechargeIDList = giftArray
			uiManager:show("rechargeView", 12)
		else
			local panel = SoraDCreatePanel("rechargeView")
			panel:jumpToLimitNodeByList(12, giftArray)
			panel:show()
		end
	elseif self.activityID == gActivityTimeActivityID.EXCHANGE_MALL_TROOPS_MARCHING_EFFECT then
		_ENV = panel.show
		panel.show.itemID = 842501
		uiManager:show("CommonSourceGuide", panel.show)
	elseif self.activityID == gActivityTimeActivityID.EXCHANGE_MALL_PAY_DRESS_UP then
		if IsArClient then
			if GLOBAL_GAME_RECHARGE_MODE then
				_ENV = panel.show
				panel.show.toCategory = gRechargeCenterCategory.DAILYADISCOUNT
				uiManager:show("rechargeView", panel.show)
			else
				local panel = SoraDCreatePanel("rechargeView")
				panel:jumpToDailyDiscountTab()
				panel:show()
			end
		else
			_UPVALUE4_ = SoraDCreatePanel("rechargeView")
			SoraDCreatePanel("rechargeView")[1] = 14623
			SoraDCreatePanel("rechargeView")[2] = 14624
			SoraDCreatePanel("rechargeView")[3] = 14625
			local SoraDCreatePanel("rechargeView")[4], giftArray = 14626, SoraDCreatePanel("rechargeView")
			if GLOBAL_GAME_RECHARGE_MODE then
				_ENV = 14626
				;(14626).rechargeIDList = giftArray
				uiManager:show("rechargeView", 14626)
			else
				local panel = SoraDCreatePanel("rechargeView")
				panel:jumpToLimitNodeByList(10, giftArray)
				panel:show()
			end
		end
	elseif self.activityID == gActivityTimeActivityID.EXCHANGE_MALL_ACTIVITY_9001385 then
		local _ENV, sourcesData = self.activityID, self.activityID
		for _, itemID in ipairs(self.exchangeItemIDArray) do
			local list = include("itemDesRead").getOutput(itemID)
			for i, v in ipairs(list) do
				if not table.keyof(sourcesData, v) then
					table.insert(sourcesData, v)
				end
			end
		end
		_ENV = 10
		;(10).sources = sourcesData
		uiManager:show("CommonSourceGuide", 10)
	elseif self.activityID == gActivityTimeActivityID.EXCHANGE_MALL_ACTIVITY_9001386 then
		_UPVALUE4_ = self.activityID
		self.activityID[1] = 19031
		self.activityID[2] = 19032
		self.activityID[3] = 19033
		local self.activityID[4], giftArray = 19034, self.activityID
		if GLOBAL_GAME_RECHARGE_MODE then
			_ENV = 19034
			;(19034).rechargeIDList = giftArray
			uiManager:show("rechargeView", 19034)
		else
			local panel = SoraDCreatePanel("rechargeView")
			panel:jumpToLimitNodeByList(12, giftArray)
			panel:show()
		end
	elseif self.activityID == gActivityTimeActivityID.EXCHANGE_ACTIVITY_9001552 then
		_ENV = panel
		panel.targetID = gBadgeItemID.COMMON_BADGE_ID
		uiManager:show("badgeBourseView", panel)
	elseif self.activityID == gActivityTimeActivityID.EXCHANGE_ACTIVITY_9001553 then
		_ENV = panel
		panel.targetID = gBadgeItemID.ADVANCED_BADGE_ID
		uiManager:show("badgeBourseView", panel)
	elseif tableOfActOutputCommon[self.activityID] then
		self:showActItemOutput()
	elseif tableOfActGiftCommon[self.activityID] then
		self:showActGiftBuyView()
	else
		local itemDesRead = include("itemDesRead")
		local sourcesData = itemDesRead.getItemListOutput(self.exchangeItemIDArray)
		if next(sourcesData) then
			_ENV = giftArray
			giftArray.sources = sourcesData
			uiManager:show("CommonSourceGuide", giftArray)
		else
			_ENV = giftArray
			giftArray.activityID = self.activityID
			uiManager:show("EventItemGuide", giftArray)
		end
	end
end
function ExchangeEventPagePanel:showActGiftBuyView()
	local activityTimeRead = include("activityTimeRead")
	if not activityTimeRead.getRechargeId(self.activityID) then
		local _ENV, giftArray = activityTimeRead.getRechargeId(self.activityID), activityTimeRead.getRechargeId(self.activityID)
	end
	if GLOBAL_GAME_RECHARGE_MODE then
		_ENV = nil
		;(nil).rechargeIDList = giftArray
		uiManager:show("rechargeView", nil)
	else
		local panel = SoraDCreatePanel("rechargeView")
		panel:jumpToLimitNodeByList(12, giftArray)
		panel:show()
	end
end
function ExchangeEventPagePanel:showActItemOutput()
	local _ENV, sourcesData
	for _, itemID in ipairs(self.exchangeItemIDArray) do
		local list = include("itemDesRead").getOutput(itemID)
		for i, v in ipairs(list) do
			if not table.keyof(sourcesData, v) then
				table.insert(sourcesData, v)
			end
		end
	end
	_ENV = nil
	;(nil).sources = sourcesData
	uiManager:show("CommonSourceGuide", nil)
end
function ExchangeEventPagePanel:closeLoading()
	SoraDCloseLoading(self:displayObject())
end
function ExchangeEventPagePanel:judgeClose()
	if not clientEventMgr.judgeIsOpen(self.activityID) and self then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
function ExchangeEventPagePanel:onClickTab(tag)
	self.tabIndex = tag
	self.fields.List_exchange:setNumItems(#self.tableData[self.tabIndex])
	self.fields.List_exchange:jumpToTop()
end
function ExchangeEventPagePanel:onShow()
	print("=======ExchangeEventPagePanel:onShow")
	self.fields.Com_bg:setGradientColor()
end
function ExchangeEventPagePanel:onHide()
	print("=======ExchangeEventPagePanel:onHide")
	_ENV = "=======ExchangeEventPagePanel:onHide"
	;("=======ExchangeEventPagePanel:onHide").msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	;("=======ExchangeEventPagePanel:onHide").eventID = self.activityID
	SoraDSendMessage("=======ExchangeEventPagePanel:onHide")
end
function ExchangeEventPagePanel:onDispose()
	print("=======ExchangeEventPagePanel:onDispose")
end
return ExchangeEventPagePanel

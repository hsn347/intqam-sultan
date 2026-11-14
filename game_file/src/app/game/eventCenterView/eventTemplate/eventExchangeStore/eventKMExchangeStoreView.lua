local gametop = gModuleMgr.getObject("gametop")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local exchangeMallCtrl = gametop.playertop_:getModule("exchangeMallCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local publicRead = include("publicRead")
local shopltCtrl = gModuleMgr.sharedMgr("shopltCtrl")
local eventKMExchangeStoreView = class("eventKMExchangeStoreView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventKMExchangeStoreView")
	end
	return target
end)
local foreverTime = 315360000
function _ENV(target)
	if target == nil then
		return SoraDCreateBasePanel("eventKMExchangeStoreView")
	end
	return target
end
_ENV = nil
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventKMExchangeStoreView")
	end
	return target
end)[gActivityTimeActivityID.EXCHANGE_MALL_RED_GEM], (nil).title = nil, "shop_name_02"
_ENV = nil
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventKMExchangeStoreView")
	end
	return target
end)[gActivityTimeActivityID.EXCHANGE_MALL_RAMADAN], (nil).title = nil, "shop_name_9001172"
_ENV = nil
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventKMExchangeStoreView")
	end
	return target
end)[gActivityTimeActivityID.EXCHANGE_MALL_SPIRITUAL_GIFT], (nil).title = nil, "activity_name_34"
_ENV = nil
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventKMExchangeStoreView")
	end
	return target
end)[gActivityTimeActivityID.EXCHANGE_MALL_SALARY], (nil).title = nil, "treasuremap_text_40"
_ENV = nil
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventKMExchangeStoreView")
	end
	return target
end)[gActivityTimeActivityID.EXCHANGE_MALL_SNATCH_TREASURE], (nil).title = nil, "activity_name_9001270"
_ENV = nil
;(nil).title = "activity_exchange_9001220"
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventKMExchangeStoreView")
	end
	return target
end)[gActivityTimeActivityID.EXCHANGE_MALL_NEW_DAY_TASK], (nil).titleSize = nil, cc.size(365, 40)
_ENV = nil
;(nil).title = "activity_exchange_9001221"
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventKMExchangeStoreView")
	end
	return target
end)[gActivityTimeActivityID.EXCHANGE_ROAD_TO_GLORY], (nil).titleSize = nil, cc.size(365, 40)
_ENV = nil
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventKMExchangeStoreView")
	end
	return target
end)[gActivityTimeActivityID.RIDES_EXCHANGE_MALL], (nil).title = nil, "activity_name_06"
_ENV = nil
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventKMExchangeStoreView")
	end
	return target
end)[gActivityTimeActivityID.EXCHANGE_MALL_COMMON_DRESS], (nil).title = nil, "activity_exchange_9001226"
_ENV = nil
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventKMExchangeStoreView")
	end
	return target
end)[gActivityTimeActivityID.EXCHANGE_MALL_DRESS_ROLL], (nil).title = nil, "activity_exchange_9001227"
_ENV = nil
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventKMExchangeStoreView")
	end
	return target
end)[gActivityTimeActivityID.EXCHANGE_MALL_STAR_MOON_KEY], (nil).title = nil, "activity_exchange_9001229"
_ENV = nil
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventKMExchangeStoreView")
	end
	return target
end)[gActivityTimeActivityID.EXCHANGE_MALL_STAR_MOON_TREASURE], (nil).title = nil, "activity_exchange_9001233"
_ENV = nil
tableOfActivitiesInfo, (function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventKMExchangeStoreView")
	end
	return target
end)[gActivityTimeActivityID.EXCHANGE_MALL_TROOPS_MARCHING_EFFECT], (nil).title = function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventKMExchangeStoreView")
	end
	return target
end, nil, "activity_name_9001235"
function eventKMExchangeStoreView:ctor()
	self.tableSingle, _ENV, self.tableData, _ENV = nil, nil, nil, nil
	self.exchangeItemID = 815101
	self.activityID = gActivityTimeActivityID.RIDES_EXCHANGE_MALL
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_title")
	self.ccs_title:setTitle(i18n("activity_name_06"))
	self.ccs_title:setFontSize(22)
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
	self.bg = SoraDGetChildByName(self, "Image_2")
	self.bg:setTouchEnabled(true)
	self.bg:setSwallowTouches(true)
	self.spIcon = SoraDGetChildByName(self, "bg_exchange_9001143_en_1")
	self:initData()
	self:setTime()
end
function eventKMExchangeStoreView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EXCHANGEMALL_SET_REFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EXCHANGEMALL_EX_REFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_CLOSELOADING", function()
		SoraDCloseLoading(self)
	end)
end
function eventKMExchangeStoreView:setActivityID(activityID)
	if not activityID then
		return
	end
	self.activityID = activityID
	if tableOfActivitiesInfo[self.activityID] then
		self.ccs_title:setTitle(i18n(tableOfActivitiesInfo[self.activityID].title))
		if IsArClient and tableOfActivitiesInfo[self.activityID].arTitle then
			self.ccs_title:setTitle(i18n(tableOfActivitiesInfo[self.activityID].arTitle))
		end
		if tableOfActivitiesInfo[self.activityID].fontSize then
			self.ccs_title:setFontSize(tableOfActivitiesInfo[self.activityID].fontSize)
		end
		if tableOfActivitiesInfo[self.activityID].titleSize then
			self.ccs_title:setTitleSize(tableOfActivitiesInfo[self.activityID].titleSize)
		end
	else
		self.ccs_title:setTitle(i18n(string.format("activity_exchange_%s", self.activityID)))
	end
	SoraDGetAutoHeightLabel(self.ccs_title:returnTitle(), 360)
	self:initData()
	self:setTime()
	self:setBgAndIcon()
end
function eventKMExchangeStoreView:initData()
	self.exchangeItemID, self.exchangeItemIDArray = exchangeMallCtrl:getCostIDByActivityID(self.activityID)
	local ridesEXdataArray = exchangeMallCtrl:getConfigByActivityID(self.activityID)
	self.icon_item:setSpriteFrame(publicRead.getIcon(self.exchangeItemID))
	local ownNum = backpackCtrl:getItemCount(self.exchangeItemID)
	self.Text_num:setString(ownNum)
	SoraDToCenter(self.node_item)
	self.node_item:setVisible(true)
	self.Button_toShop:setTitleText("")
	if self.activityID == gActivityTimeActivityID.EXCHANGE_MALL_SNATCH_TREASURE then
		self.Text_num:setString(i18n("Martial_arts_text_06"))
	end
	self.Button_toShop:setVisible(self.activityID ~= gActivityTimeActivityID.EXCHANGE_MALL_DRESS_ROLL)
	self.tableData = exchangeMallCtrl:getRealExchangeData(self.exchangeItemID, ridesEXdataArray, self.exchangeItemIDArray)
	self:sortData()
	exchangeMallCtrl = i18n("Martial_arts_text_06")
	i18n("Martial_arts_text_06").scroll = self.scroll
	i18n("Martial_arts_text_06").view = self
	i18n("Martial_arts_text_06").activityID = self.activityID
	i18n("Martial_arts_text_06").exchangeItemID = self.exchangeItemID
	self.scroll:updateScrollView(cc.size(624, 160), self.tableData, 1, i18n("Martial_arts_text_06"))
end
function eventKMExchangeStoreView:setTime()
	local activityTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	if activityTime then
		self.node_time:setVisible(true)
		self.text_time:beginTime(activityTime.timerNode.timer:getRemainTime())
		SoraDToCenter(self.node_time)
		if activityTime.timerNode.timer:getRemainTime() >= foreverTime then
			self.node_time:setVisible(false)
		end
	end
end
function eventKMExchangeStoreView:setBgAndIcon()
	local addStr = ""
	if self.activityID == 9001212 and not IsArClient then
		addStr = "_ros"
	end
	local bgName = string.format("bg_exchange_%d" .. addStr .. ".png", self.activityID)
	self.bg:loadTexture(bgName, ccui.TextureResType.plistType)
	if self.activityID == 9001213 and not IsArClient then
		addStr = "_ros"
	end
	if self.activityID == 9001215 and SoraDGetDefaultLanguage() == "en" then
		self.spIcon:setScale(0.8)
	end
	_UPVALUE2_ = self.activityID
	self.activityID[1] = "ar"
	self.activityID[2] = "en"
	local iconName = SoraDGetImageNameByLang("bg_exchange_" .. self.activityID .. "_%s" .. addStr .. ".png", self.activityID)
	self.spIcon:setSpriteFrame(iconName)
end
function eventKMExchangeStoreView:btnGoShopClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.activityID == gActivityTimeActivityID.EXCHANGE_MALL_COMMON_DRESS or self.activityID == gActivityTimeActivityID.EXCHANGE_MALL_DRESS_ROLL then
			_ENV = nil
			;(nil).type = 1
			;(nil).jumpStore = "btnOther"
			uiManager:show("bagView", nil)
		elseif self.activityID == gActivityTimeActivityID.EXCHANGE_MALL_RAMADAN then
			if GLOBAL_GAME_RECHARGE_MODE then
				_ENV = nil
				;(nil).toCategory = gRechargeCenterCategory.LIMITGIFT
				uiManager:show("rechargeView", nil)
			else
				local panel = SoraDCreatePanel("rechargeView")
				panel:expect2SelectTab(gRechargeCenterCategory.LIMITGIFT, self.activityID)
				panel:show()
			end
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
		else
			_ENV = panel.show
			panel.show.activityID = self.activityID
			uiManager:show("EventItemGuide", panel.show)
		end
	end
end
function eventKMExchangeStoreView:sortData()
	for i, v in ipairs(self.tableData) do
		v.weight = 0
		if 0 < v.limitnum - v.curExchangeNum then
			v.weight = 1
		end
	end
	table.sort(self.tableData, function(a, b)
		if a.weight ~= b.weight then
			return a.weight > b.weight
		else
			return a.index < b.index
		end
	end)
end
function eventKMExchangeStoreView:judgeClose()
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
function eventKMExchangeStoreView:onExitPanel()
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	;(nil).eventID = self.activityID
	SoraDSendMessage(nil)
end
return eventKMExchangeStoreView

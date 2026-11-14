local gametop = gModuleMgr.getObject("gametop")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local activityExchangeMallRead = include("activityExchangeMallRead")
local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local publicRead = include("publicRead")
local shopltCtrl = gModuleMgr.sharedMgr("shopltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ActExchangePagePanel = class("ActExchangePagePanel", baseFguiPanel)
function ActExchangePagePanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("ActExchangePagePanel:ctor", self.viewName)
end
function ActExchangePagePanel:getPackageList()
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
baseFguiPanel[gActivityTimeActivityID.NEBULA_REGION_ACTIVITY], (nil).title = nil, "activity_name_9001444"
_ENV = nil
_ENV, baseFguiPanel[gActivityTimeActivityID.NEBULA_SURPRISED_DROP_STORE], (nil).title = gActivityTimeActivityID.NEBULA_SURPRISED_DROP_STORE, nil, "activity_name_9001632"
local tableOfActivitiesInfo = baseFguiPanel
local gActivityTimeActivityID.NEBULA_SURPRISED_DROP_STORE[gActivityTimeActivityID.NEBULA_REGION_ACTIVITY], tableOfActOutputCommon = true, gActivityTimeActivityID.NEBULA_SURPRISED_DROP_STORE
local _ENV, tableOfActGiftCommon = gActivityTimeActivityID.NEBULA_REGION_ACTIVITY, gActivityTimeActivityID.NEBULA_REGION_ACTIVITY
function ActExchangePagePanel:onInit()
	self:setActivityID()
	self.tableSingle, _ENV, self.tableData, _ENV = self.setActivityID, self.setActivityID, self.setActivityID, self.setActivityID
	self.activityID = gActivityTimeActivityID.RIDES_EXCHANGE_MALL
	self.fields.Com_title:initData(i18n("activity_name_06"), handler(self, self.onClickClose))
	self.fields.Com_title:setTitleFontSize(22)
	self.fields.Button_toShop:addClickListener(handler(self, self.btnGoShopClick))
	self.Button_toShop = self.fields.Button_toShop
	self.Com_eventInfo = self.fields.Com_eventInfo
	self:setActivityID(self.proxy.param.id)
end
function ActExchangePagePanel:initData()
	self.exchangeItemIDArray = activityExchangeMallRead:getExchangeitemByID(self.activityID)
	activityExchangeMallRead = self.activityID
	self.activityID[1] = self.exchangeItemIDArray
	self.fields.Button_toShop:setIconAndNum(self.activityID)
	self.fields.Button_toShop:setVisible(self.activityID ~= gActivityTimeActivityID.EXCHANGE_MALL_DRESS_ROLL)
	if self.activityID == gActivityTimeActivityID.NEBULA_REGION_ACTIVITY then
		local nebulaWarUtil = include("nebulaWarUtil")
		local group = nebulaWarUtil.getRegionGroup()
		if not activityExchangeMallCtrl:getConfigByActivityID(self.activityID, group) then
			activityExchangeMallRead = activityExchangeMallCtrl:getConfigByActivityID(self.activityID, group)
		end
		self.tableData = activityExchangeMallCtrl:getConfigByActivityID(self.activityID, group)
	else
		if not activityExchangeMallCtrl:getConfigByActivityID(self.activityID) then
			activityExchangeMallRead = activityExchangeMallCtrl:getConfigByActivityID(self.activityID)
		end
		self.tableData = activityExchangeMallCtrl:getConfigByActivityID(self.activityID)
	end
	self:sortData()
	activityExchangeMallRead = self.sortData
	self.otherData, self.sortData.activityID = self.sortData, self.activityID
	self.fields.List_exchange:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_exchange:setNumItems(table.nums(self.tableData))
end
function ActExchangePagePanel:onItemRenderer(index, object)
	object:initData(self.tableData[index + 1], self.otherData)
end
function ActExchangePagePanel:setTime()
	local activityTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	if activityTime then
		self.Com_eventInfo:setTimeVisible(true)
		local remainTime = 0
		if self.activityID == gActivityTimeActivityID.NEBULA_REGION_ACTIVITY then
			local nebulaWarRead = include("nebulaWarRead")
			local _time, _num = nebulaWarRead.getExchangeShopTime()
			remainTime = _time
			if _num < 4 then
				self.Label_timer:setTimeLast(function(timeStr)
					return i18n("Endless_trial_text_07") .. timeStr
				end)
			else
				self.Label_timer:setTimeLast(nil)
			end
		else
			remainTime = activityTime.timerNode.timer:getRemainTime()
		end
		self.Com_eventInfo:setTime(remainTime)
		local title = self.Label_timer:getChild("title")
		fguiHelper.setTextWidthHeight(title, cc.size(220, 40))
		if remainTime >= foreverTime then
			self.Com_eventInfo:setTimeVisible(false)
		end
	end
end
function ActExchangePagePanel:sortData()
	for i, v in ipairs(self.tableData) do
		v.weight = 0
		v.index = i
		if 0 < v.limitnum - v.curExchangeNum then
			v.weight = 1
		end
	end
	dump(self.tableData, "fjksdjfkdjkfjkd")
	table.sort(self.tableData, function(a, b)
		if a.weight ~= b.weight then
			return a.weight > b.weight
		else
			return a.index < b.index
		end
	end)
end
function ActExchangePagePanel:setActivityID(activityID)
	if not activityID then
		return
	end
	self.activityID = activityID
	self.title = self.fields.Com_title
	self.title:setTitleWidthHeight(360, 40)
	if tableOfActivitiesInfo[self.activityID] then
		self.title:setTitle(i18n(tableOfActivitiesInfo[self.activityID].title))
	else
		self.title:setString(i18n(string.format("activity_exchange_%s", self.activityID)))
	end
	self.Com_eventInfo:initData(self.activityID)
	self.Com_eventInfo:setTimeFont(20, cc.c3b(255, 255, 255))
	self.Com_eventInfo:setTimeIconScale(0.7)
	self.Label_timer = self.fields.Com_eventInfo:getLabelTimer()
	if self.activityID == gActivityTimeActivityID.NEBULA_REGION_ACTIVITY then
		self.Label_timer:setTimeEndListener(function()
			self:setTime()
		end)
	end
	self:initData()
	self:setTime()
	self:setBgAndIcon()
end
function ActExchangePagePanel:setBgAndIcon()
	local addStr = ""
	if self.activityID == 9001212 and not IsArClient then
		addStr = "_ros"
	end
	local bgName = string.format("bg_exchange_%d" .. addStr .. ".png", self:replaceResource(self.activityID))
	self.Com_eventInfo:setBg(bgName)
	self.Com_eventInfo:replaceBg(self.activityID)
	if self.activityID == 9001213 and not IsArClient then
		addStr = "_ros"
	end
	if self.activityID == 9001215 and SoraDGetDefaultLanguage() == "en" then
		self.Com_eventInfo:setIconScale(0.8)
	end
	_UPVALUE2_ = self:replaceResource(self.activityID)
	self:replaceResource(self.activityID)[1] = "ar"
	self:replaceResource(self.activityID)[2] = "en"
	local iconName = SoraDGetImageNameByLang("bg_exchange_" .. self:replaceResource(self.activityID) .. "_%s" .. addStr .. ".png", (self:replaceResource(self.activityID)))
	self.Com_eventInfo:setIcon(iconName)
end
function ActExchangePagePanel:replaceResource(actID)
	if actID == gActivityTimeActivityID.EXCHANGE_MALL_RED_GEM_CROSS_SERVER then
		return gActivityTimeActivityID.EXCHANGE_MALL_RED_GEM
	end
	return actID
end
function ActExchangePagePanel:btnGoShopClick(context)
	SoraDPlaySound()
	if tableOfActOutputCommon[self.activityID] then
		self:showActItemOutput()
	elseif tableOfActGiftCommon[self.activityID] then
		self:showActGiftBuyView()
	else
		_ENV = nil
		;(nil).activityID = self.activityID
		uiManager:show("EventItemGuide", nil)
	end
end
function ActExchangePagePanel:showActGiftBuyView()
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
function ActExchangePagePanel:showActItemOutput()
	local _ENV, sourcesData
	local list = include("itemDesRead").getOutput(self.exchangeItemIDArray)
	for i, v in ipairs(list) do
		if not table.keyof(sourcesData, v) then
			table.insert(sourcesData, v)
		end
	end
	_ENV = nil
	;(nil).sources = sourcesData
	;(nil).desStr = i18n("common_text_4643")
	uiManager:show("CommonSourceGuide", nil)
end
function ActExchangePagePanel:judgeClose()
	if self.activityID == gActivityTimeActivityID.NEBULA_REGION_ACTIVITY then
		local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
		if not nebulaActivityCtrl:isExchangeShopOpen() then
			SoraDRemoveAllAfterPanelFromManager(self)
		end
		return
	end
	if not clientEventMgr.judgeIsOpen(self.activityID) and self then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
function ActExchangePagePanel:onShow()
	print("=======ActExchangePagePanel:onShow")
end
function ActExchangePagePanel:onHide()
	print("=======ActExchangePagePanel:onHide")
	_ENV = "=======ActExchangePagePanel:onHide"
	;("=======ActExchangePagePanel:onHide").msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	;("=======ActExchangePagePanel:onHide").eventID = self.activityID
	SoraDSendMessage("=======ActExchangePagePanel:onHide")
end
function ActExchangePagePanel:onDispose()
	print("=======ActExchangePagePanel:onDispose")
end
return ActExchangePagePanel

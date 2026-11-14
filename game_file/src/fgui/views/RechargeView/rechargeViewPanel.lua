local rechargeCtrl = SoraDGetCtrl("rechargeCtrl")
local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local luckyGiftCtrl = SoraDGetCtrl("luckyGiftCtrl")
local princeGiftNewCtrl = SoraDGetCtrl("princeGiftNewCtrl")
local dailyDiscountGiftCtrl = SoraDGetCtrl("dailyDiscountGiftCtrl")
local rechargeRead = include("rechargeRead")
local clickResumeTime = 0
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local rechargeViewPanel = class("rechargeViewPanel", baseFguiPanel)
function rechargeViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("rechargeViewPanel:ctor", self.viewName)
end
function rechargeViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function rechargeViewPanel:onInit()
	print("=======rechargeViewPanel:onInit")
	self.isHideCurrentSceneView = true
	self.curIndex = 1
	self.curTag = 1
	self.fields.Com_title:initData(i18n("common_text_780"), handler(self, self.onClickClose))
	self.fields.Btn_feedBack:setString(i18n("common_text_2102"))
	self.fields.Btn_feedBack:addClickListener(handler(self, self.btnFeedBackClick))
	self.fields.Btn_resume:setVisible(false)
	if gSvrConfig.isReview and device.platform == "ios" then
		self.fields.Btn_resume:setVisible(true)
		self.fields.Btn_resume:setString(i18n("commonTxt_text_001"))
		self.fields.Btn_resume:addClickListener(handler(self, self.btnResumeClick))
	end
end
function rechargeViewPanel:onShow()
	print("=======rechargeViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	_ENV, _ENV = self.fields.Com_bg, self.fields.Com_bg.setGradientColor
	self.fields.Com_bg.title = i18n("recharge_btn_02")
	self.fields.Com_bg.tabType = gRechargeCenterCategory.LIMITGIFT
	_ENV, self.fields.Com_bg.setGradientColor[1], self.fields.Com_bg.cTag = self.fields.Com_bg, self.fields.Com_bg, 0
	self.fields.Com_bg.title = i18n("recharge_btn_01")
	self.fields.Com_bg.tabType = gRechargeCenterCategory.GOLD
	_ENV, self.fields.Com_bg.setGradientColor[2], self.fields.Com_bg.cTag = self.fields.Com_bg, self.fields.Com_bg, 1
	self.fields.Com_bg.title = i18n("common_text_2476")
	self.fields.Com_bg.tabType = gRechargeCenterCategory.MONTH
	_ENV, self.fields.Com_bg.setGradientColor[3], self.fields.Com_bg.cTag = self.fields.Com_bg, self.fields.Com_bg, 2
	self.fields.Com_bg.title = i18n("spcial_office_name_01")
	self.fields.Com_bg.tabType = gRechargeCenterCategory.DAILYADISCOUNT
	_ENV, self.fields.Com_bg.setGradientColor[4], self.fields.Com_bg.cTag = self.fields.Com_bg, self.fields.Com_bg, 3
	self.fields.Com_bg.title = i18n("activity_name_9001316")
	self.fields.Com_bg.tabType = gRechargeCenterCategory.RECHARGE_PRESENT
	self.moduleTbl, self.fields.Com_bg.setGradientColor[5], self.fields.Com_bg.cTag = self.fields.Com_bg.setGradientColor, self.fields.Com_bg, 4
	if not self.param then
		_ENV = self.param
	end
	self.param = self.param
	self:updateHeadBtns()
end
function rechargeViewPanel:updateHeadBtns(isToFirst)
	self.tableArray, _ENV = nil, nil
	local tag = 1
	for k, v in ipairs(self.moduleTbl) do
		if self:checkTabData(v.tabType) then
			v.tag = tag
			table.insert(self.tableArray, v)
			tag = tag + 1
		end
	end
	local toCategory = self.param and self.param.toCategory
	if toCategory then
		for k, v in ipairs(self.tableArray) do
			if v.tabType == toCategory then
				self.curIndex = k
				break
			end
		end
	end
	_ENV = ipairs(self.tableArray)
	ipairs(self.tableArray).defaultClick = self.curIndex
	ipairs(self.tableArray).tabsetArray = self.tableArray
	ipairs(self.tableArray).callback = handler(self, self.onTabClick)
	self.fields.Com_tab:initView(ipairs(self.tableArray))
	self:updateRedPoint()
	if isToFirst then
		self:jumpHeadOne()
	end
end
function rechargeViewPanel:onTabClick(index)
	self.curIndex = index
	self.tabType = nil
	for k, v in ipairs(self.tableArray) do
		if k == self.curIndex then
			self.curTag = v.cTag
			self.tabType = v.tabType
			break
		end
	end
	print("self.curIndex,self.curTag======", self.curIndex, self.curTag)
	self.controllers.c1:setSelectedIndex(self.curTag)
	advertiseCollect.TriggerEvent(gSDKDef.TDonEvent.advertise_recharge_btn)
	_ENV = self.curTag
	self.curTag.tab = self.tabType
	userSDKManager.logEvent(gSDKDef.TDonEvent.click_rechargeview_switchtab, self.curTag)
	self:initView()
end
function rechargeViewPanel:initView(target, data)
	if self.curTag == 0 or self.curTag == 4 or self.curTag == 5 then
		if data then
			local rechargeID = data.data.rid
			if self.curTag == 0 then
				if SoraDcheckLimitData() then
					self.fields.Com_limitNode:initData(self.tabType, self.param.menuEnum, rechargeID, self.param.rechargeIDList, true)
				else
					self:updateHeadBtns(true)
				end
			else
				self.fields.Com_limitNode:initData(self.tabType, self.param.menuEnum, rechargeID, self.param.rechargeIDList, true)
			end
		else
			self.fields.Com_limitNode:initData(self.tabType, self.param.menuEnum, self.param.rechargeID, self.param.rechargeIDList)
		end
	elseif self.curTag == 1 then
		self.fields.Com_goldNode:initData()
	elseif self.curTag == 2 then
		self.fields.Com_node:initData(self.param and self.param.toNodeTag)
	elseif self.curTag == 3 then
		self.fields.Com_dailyNode:initData()
	end
end
function rechargeViewPanel:checkTabData(tabType)
	local ret = false
	if tabType == gRechargeCenterCategory.LIMITGIFT then
		ret = SoraDcheckLimitData()
	elseif tabType == gRechargeCenterCategory.GOLD then
		ret = true
	elseif tabType == gRechargeCenterCategory.MONTH then
		ret = true
	elseif tabType == gRechargeCenterCategory.DAILYADISCOUNT then
		ret = not gSvrConfig.isReview and activityShowCtrl:isActivityOpen(gActivityTimeActivityID.DAILY_DISCOUNT_GIFT_ACTIVITY)
	elseif tabType == gRechargeCenterCategory.RECHARGE_PRESENT then
		local rechargePresentUtil = include("rechargePresentUtil")
		local activityID = rechargePresentUtil.getActivityIDByCategory(tabType)
		if activityID then
			ret = rechargePresentUtil.checkActivityOpen(activityID)
		end
	end
	return ret
end
function rechargeViewPanel:jumpHeadOne()
	self.fields.Com_tab:setTabIndex(1, true)
end
function rechargeViewPanel:updateRedPoint()
	for k, v in ipairs(self.tableArray) do
		if v.cTag == 2 then
			local visible = false
			local weeklyData = rechargeActivityCtrl:getWeekActivityList()
			if weeklyData and next(weeklyData) then
				for k, v in pairs(weeklyData) do
					if v.isbuy and not v.isdayget then
						visible = true
						break
					end
				end
			end
			local monthData = rechargeActivityCtrl:getMonthActivityList()
			if monthData and next(monthData) then
				for k, v in pairs(monthData) do
					if v.isbuy and not v.isdayget then
						visible = true
						break
					end
				end
			end
			local takeData = rechargeActivityCtrl:getTakeActivityList()
			if takeData and next(takeData) and takeData.isbuy and not takeData.isdayget then
				visible = true
			end
			self.fields.Com_tab:setBtnRedDot(k, visible)
		end
		if v.cTag == 3 then
			local visible = false
			local getTabLength = function(_table)
				local leng = 0
				if _table == nil then
					return leng
				end
				for k, v in pairs(_table) do
					leng = leng + 1
				end
				return leng
			end
			local actOpen = activityShowCtrl:isActivityOpen(gActivityTimeActivityID.DAILY_DISCOUNT_GIFT_ACTIVITY)
			local isReceiveFreeGift = serviceFunctions.isSameDay(dailyDiscountGiftCtrl.dailyDiscountGiftData.freeGiftTime)
			local isReceiveSpecialGift = serviceFunctions.isSameDay(dailyDiscountGiftCtrl.dailyDiscountGiftData.rewardGiftTime)
			local _maxValue = getTabLength(dailyDiscountGiftCtrl.dailyDiscountGiftData.giftData)
			local _curValue = getTabLength(dailyDiscountGiftCtrl.dailyDiscountGiftData.buyGiftList)
			local isNeedReceiveSpeGift = not isReceiveSpecialGift and _maxValue == _curValue
			if actOpen and (not isReceiveFreeGift or isNeedReceiveSpeGift) then
				visible = true
			end
			self.fields.Com_tab:setBtnRedDot(k, visible)
		end
	end
end
function rechargeViewPanel:btnFeedBackClick()
	SoraDPlaySound()
	userSDKManager.openFeedback("Purchase", true)
end
function rechargeViewPanel:btnResumeClick()
	SoraDPlaySound()
	if clickResumeTime == 0 then
		local msg = i18n("Restore_Purchases_02")
		local msg = string.format([[
%s:
1.%s
2.%s
3.%s]], i18n("common_text_001"), i18n("commonTxt_text_002"), i18n("commonTxt_text_003"), i18n("commonTxt_text_004"))
		SoraDShowMsgBox(msg, i18n("commonTxt_text_001"), nil, function(eventType)
			if MSGBOX_CALLBACK_YES == eventType then
				SoraDShowLoading(self, nil, nil, nil, 2)
			end
		end)
	elseif serviceFunctions.systemTime() - clickResumeTime < 15 then
		SoraDShowMsgTip(i18n("commonTxt_text_005"))
	else
		SoraDShowMsgTip(i18n("commonTxt_text_006"))
	end
end
function rechargeViewPanel:expect2SelectTab(tabType, activityID, targetID, giftID)
	local cTag = 0
	for k, v in ipairs(self.moduleTbl) do
		if v.tabType == tabType then
			cTag = v.cTag
			break
		end
	end
	self.fields.Com_tab:setTabIndex(cTag + 1, true)
	if activityID then
		if activityID == gActivityTimeActivityID.EXCHANGE_MALL_RAMADAN then
			self.fields.Com_limitNode:initData(self.tabType, 12)
		elseif activityID == gActivityTimeActivityID.SULTAN_EX_RECAHRGE_PRESENT then
			self.fields.Com_limitNode:initData(self.tabType, 12)
		elseif activityID == gActivityTimeActivityID.NEW_PRINCE_GIFT_ACTIVITY then
			self.fields.Com_limitNode:initData(self.tabType, 24)
		end
	end
end
function rechargeViewPanel:getTabIndexByCategory(category)
	local index = 1
	for k, v in ipairs(self.tableArray) do
		if v.tabType == category then
			index = v.tag
			break
		end
	end
	return index
end
function rechargeViewPanel:gameGuide_getTarget(itemName, parameters)
	if itemName == "rechargePresent" then
		return self.fields.Com_tab:getBtn(1)
	elseif itemName == "rechargeMonth" then
		local index = self:getTabIndexByCategory(gRechargeCenterCategory.MONTH)
		return self.fields.Com_tab:getBtn(index)
	elseif itemName == "Panel_guide" then
		local index = self:getTabIndexByCategory(gRechargeCenterCategory.RECHARGE_PRESENT)
		self.fields.Com_tab:setTabIndex(index, true)
		return self.fields.Com_limitNode:getPanelGuide()
	end
	return self.fields[itemName]
end
function rechargeViewPanel:endShow()
	if not include("pyramidWarltCtrl").checkPwXianXiaSai() then
		self:close()
	end
end
return rechargeViewPanel

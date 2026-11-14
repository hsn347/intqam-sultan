local gametop = gModuleMgr.getObject("gametop")
local rechargeCtrl = gametop.playertop_:getModule("rechargeCtrl")
local rechargeActivityCtrl = gametop.playertop_:getModule("rechargeActivityCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local rechargeRead = include("rechargeRead")
local RechargeView = class("rechargeView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("rechargeView")
	end
	return target
end)
local gRechargeCenterCategory = _G.gRechargeCenterCategory
function RechargeView:ctor()
	self.isHideCurrentSceneView = true
	self.childrenNode = SoraDGetChildByName(self, "Top_Node_children")
	self.txtTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_recharge")
	self.txtTitle:setTitle(i18n("common_text_780"))
	self.txtTitle:setLocalZOrder(99)
	self.goldTop = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonGoldTop_recharge")
	self.goldTop:closeTouch()
	self.goldTop:setLocalZOrder(100)
	self.btnFeedBack = SoraDGetChildByName(self, "Top_Button_feedBack")
	self.btnFeedBack:addTouchEventListener(function(button, eventType)
		if eventType == ccui.TouchEventType.ended then
			SoraDPlaySound()
			userSDKManager.openFeedback("Purchase", true)
		end
	end)
	local textFeedBack = SoraDGetChildByName(self, "Text_feedBack")
	textFeedBack:ignoreContentAdaptWithSize(false)
	textFeedBack:setContentSize(cc.size(83, 62))
	SoraDGetChildByName(self, "Text_feedBack"):setString(i18n("common_text_2102"))
	SoraDGetChildByName(self, "Image_bg"):setFillType(1)
	if gSvrConfig.isReview and device.platform == "ios" then
		self:addBtnResumeBuy()
	end
	self:updateHeadBtns()
end
local clickResumeTime = 0
function RechargeView:addBtnResumeBuy(...)
	local btnResume = self.btnFeedBack:clone()
	btnResume:addTo(self.btnFeedBack:getParent())
	btnResume:setPosition(-self.btnFeedBack:getPositionX() + SoraDFSign(640), self.btnFeedBack:getPositionY())
	btnResume:addTouchEventListener(function(button, eventType)
		if eventType == ccui.TouchEventType.ended then
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
	end)
	local textResume = SoraDGetChildByName(btnResume, "Text_feedBack")
	textResume:setString(i18n("commonTxt_text_001"))
end
function RechargeView:setRechargeOCXOffset(offset)
end
function RechargeView:onEnterPanel()
	if self.curTab == nil and self.ccs_tab then
		self.ccs_tab:clickByIndex(1)
	end
end
function RechargeView:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", function(target, data)
		if type(data.activityID) == "table" then
			for _, v in pairs(data.activityID) do
				if v == gActivityTimeActivityID.DAILY_DISCOUNT_GIFT_ACTIVITY or v == gActivityTimeActivityID.SULTAN_EX_RECAHRGE_PRESENT then
					self:updateHeadBtns()
					self.ccs_tab:clickByIndex(1)
				end
			end
		elseif type(data.activityID) == "number" and (data.activityID == gActivityTimeActivityID.DAILY_DISCOUNT_GIFT_ACTIVITY or data.activityID == gActivityTimeActivityID.SULTAN_EX_RECAHRGE_PRESENT or data.activityID == gActivityTimeActivityID.NEW_PRINCE_GIFT_ACTIVITY) then
			self:updateHeadBtns()
			self.ccs_tab:clickByIndex(1)
		end
		self:updateRedPoint()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_DAILYFREEGIFT_REFRESH", handler(self, self.updateRedPoint))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_DAILYSPECIALGIFTBUY_REFRESH", handler(self, self.updateRedPoint))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_DAILYSPECIALGIFT_REFRESH", handler(self, self.updateRedPoint))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_ACTIVETIMEOUT", function(target, redata)
		if redata and redata.redata and redata.redata.rid then
			local info = rechargeRead.getPageViewData(redata.redata.rid)
			if info then
				if gRechargeActiveModelType.MONTHLYGIFT == info.activeModelType then
					self:updateRedPoint()
				elseif gRechargeActiveModelType.WEEKLY_GIFT == info.activeModelType then
					self:updateRedPoint()
				elseif gRechargeActiveModelType.SUBSCRIPTION == info.activeModelType then
					self:updateRedPoint()
				end
			end
			self:updateHeadBtns()
			self.ccs_tab:clickByIndex(1)
		end
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_WEEKLY_REFRESH", handler(self, self.updateRedPoint))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_MONTHLY_REFRESH", handler(self, self.updateRedPoint))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_TAKE_REFRESH", handler(self, self.updateRedPoint))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_RECHARGEVIEWREFRESH", function(target, redata)
		self:updateHeadBtns()
		self.ccs_tab:clickByIndex(1)
	end)
end
function RechargeView:monthRed()
	local weeklyData = rechargeActivityCtrl:getWeekActivityList()
	if weeklyData and next(weeklyData) then
		for k, v in pairs(weeklyData) do
			if v.isbuy and not v.isdayget then
				self.ccs_tab:setRedPointState(gRechargeCenterCategory.MONTH, true)
				return
			end
		end
	end
	local monthData = rechargeActivityCtrl:getMonthActivityList()
	if monthData and next(monthData) then
		for k, v in pairs(monthData) do
			if v.isbuy and not v.isdayget then
				self.ccs_tab:setRedPointState(gRechargeCenterCategory.MONTH, true)
				return
			end
		end
	end
	local takeData = rechargeActivityCtrl:getTakeActivityList()
	if takeData and next(takeData) and takeData.isbuy and not takeData.isdayget then
		self.ccs_tab:setRedPointState(gRechargeCenterCategory.MONTH, true)
		return
	end
	self.ccs_tab:setRedPointState(gRechargeCenterCategory.MONTH, false)
end
function RechargeView:discountRed()
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
	local dailyDiscountGiftCtrl = gametop.playertop_:getModule("dailyDiscountGiftCtrl")
	local isReceiveFreeGift = serviceFunctions.isSameDay(dailyDiscountGiftCtrl.dailyDiscountGiftData.freeGiftTime)
	local isReceiveSpecialGift = serviceFunctions.isSameDay(dailyDiscountGiftCtrl.dailyDiscountGiftData.rewardGiftTime)
	local _maxValue = getTabLength(dailyDiscountGiftCtrl.dailyDiscountGiftData.giftData)
	local _curValue = getTabLength(dailyDiscountGiftCtrl.dailyDiscountGiftData.buyGiftList)
	local isNeedReceiveSpeGift = not isReceiveSpecialGift and _maxValue == _curValue
	if actOpen and (not isReceiveFreeGift or isNeedReceiveSpeGift) then
		self.ccs_tab:setRedPointState(gRechargeCenterCategory.DAILYADISCOUNT, true)
	else
		self.ccs_tab:setRedPointState(gRechargeCenterCategory.DAILYADISCOUNT, false)
	end
end
function RechargeView:updateRedPoint()
	for _, v in pairs(self.moduleTbl) do
		if v.isOpen and v.checkRed then
			v.checkRed()
		end
	end
end
function RechargeView:updateHeadBtns()
	if self.ccs_tab == nil then
		_ENV, self.ccs_tab = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn_tab"), SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn_tab")
		_ENV = "Top_CCS_commonTabBtn_tab"
		;("Top_CCS_commonTabBtn_tab").ocx = nil
		;("Top_CCS_commonTabBtn_tab").isOpen = false
		;("Top_CCS_commonTabBtn_tab").panelName = "rechargeViewLimitGiftNode"
		;("Top_CCS_commonTabBtn_tab").title = i18n("recharge_btn_02")
		SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn_tab")[gRechargeCenterCategory.LIMITGIFT], ("Top_CCS_commonTabBtn_tab").offsetY = "Top_CCS_commonTabBtn_tab", -140
		_ENV = "Top_CCS_commonTabBtn_tab"
		;("Top_CCS_commonTabBtn_tab").ocx = nil
		;("Top_CCS_commonTabBtn_tab").isOpen = false
		;("Top_CCS_commonTabBtn_tab").panelName = "rechargeViewGoldGiftNode"
		;("Top_CCS_commonTabBtn_tab").title = i18n("recharge_btn_01")
		SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn_tab")[gRechargeCenterCategory.GOLD], ("Top_CCS_commonTabBtn_tab").offsetY = "Top_CCS_commonTabBtn_tab", 30
		_ENV = "Top_CCS_commonTabBtn_tab"
		;("Top_CCS_commonTabBtn_tab").ocx = nil
		;("Top_CCS_commonTabBtn_tab").isOpen = false
		;("Top_CCS_commonTabBtn_tab").checkRed = handler(self, self.monthRed)
		;("Top_CCS_commonTabBtn_tab").panelName = "rechargeViewMonthlyNode"
		;("Top_CCS_commonTabBtn_tab").title = i18n("common_text_2476")
		SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn_tab")[gRechargeCenterCategory.MONTH], ("Top_CCS_commonTabBtn_tab").offsetY = "Top_CCS_commonTabBtn_tab", -5
		_ENV = "Top_CCS_commonTabBtn_tab"
		;("Top_CCS_commonTabBtn_tab").ocx = nil
		;("Top_CCS_commonTabBtn_tab").isOpen = false
		;("Top_CCS_commonTabBtn_tab").checkRed = handler(self, self.discountRed)
		;("Top_CCS_commonTabBtn_tab").panelName = "rechargeViewDailyDisNode"
		;("Top_CCS_commonTabBtn_tab").title = i18n("spcial_office_name_01")
		SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn_tab")[gRechargeCenterCategory.DAILYADISCOUNT], ("Top_CCS_commonTabBtn_tab").offsetY = "Top_CCS_commonTabBtn_tab", 40
		_ENV = "Top_CCS_commonTabBtn_tab"
		;("Top_CCS_commonTabBtn_tab").ocx = nil
		;("Top_CCS_commonTabBtn_tab").isOpen = false
		;("Top_CCS_commonTabBtn_tab").panelName = "rechargeViewPresentNode"
		;("Top_CCS_commonTabBtn_tab").title = i18n("activity_name_9001316")
		;("Top_CCS_commonTabBtn_tab").offsetY = -140
		;("Top_CCS_commonTabBtn_tab").choosePng = "bg_sdkz_fyan_ts01.png"
		self.moduleTbl, SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn_tab")[gRechargeCenterCategory.RECHARGE_PRESENT], ("Top_CCS_commonTabBtn_tab").unChoosePng = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn_tab"), "Top_CCS_commonTabBtn_tab", "bg_sdkz_fyan_ts02.png"
	end
	_UPVALUE5_ = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn_tab")
	SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn_tab")[1] = gRechargeCenterCategory.LIMITGIFT
	SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn_tab")[2] = gRechargeCenterCategory.GOLD
	SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn_tab")[3] = gRechargeCenterCategory.MONTH
	SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn_tab")[4] = gRechargeCenterCategory.DAILYADISCOUNT
	local SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn_tab")[5], tableOrder = gRechargeCenterCategory.RECHARGE_PRESENT, SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn_tab")
	if not commonCheck.DAILY_DISCOUNT_GIFT then
		self.moduleTbl[gRechargeCenterCategory.DAILYADISCOUNT] = nil
	end
	local _ENV, tableArray = self.moduleTbl, self.moduleTbl
	for i, v in ipairs(tableOrder) do
		if self.moduleTbl[v] then
			self.moduleTbl[v].isOpen = self:checkTabData(v)
			if self.moduleTbl[v].isOpen then
				local data = self.moduleTbl[v]
				_ENV = v
				v.title = data.title
				v.tag = v
				v.handle = handler(self, self.btnTabClick)
				v.choosePng = data.choosePng
				v.unChoosePng = data.unChoosePng
				table.insert(tableArray, v)
			end
		end
	end
	if self.ccs_tab then
		_ENV = ipairs(tableOrder)
		ipairs(tableOrder).tabNum = #tableArray
		ipairs(tableOrder).defaultClick = 1
		ipairs(tableOrder).tabsetArray = tableArray
		ipairs(tableOrder).unDefaultClick = true
		self.ccs_tab:initView(ipairs(tableOrder))
	end
	self:updateRedPoint()
	local btn, index = self.ccs_tab:getTabByTag(gRechargeCenterCategory.RECHARGE_PRESENT)
	if btn and self:isOpen(gRechargeCenterCategory.RECHARGE_PRESENT) and not btn.addEffect then
		local sp = self.ccs_tab:setOtherSprite(index, "dh_anniu2_01.png")
		if sp then
			_UPVALUE3_ = index
			index[1] = cca.fadeTo(0.5, 0.24)
			index[2] = cca.fadeTo(0.5833333333333334, 0.62)
			index[3] = cca.fadeTo(0.3333333333333333, 0.4)
			index[4] = cca.fadeTo(0.9166666666666666, 0.58)
			index[5] = cca.fadeTo(0.9166666666666666, 0.58)
			index[6] = cca.fadeTo(0.9166666666666666, 0.58)
			index[7] = cca.fadeTo(0.9166666666666666, 0.58)
			index[8] = cca.fadeTo(0.9166666666666666, 0.58)
			local seq = cca.seq(index)
			_G.SoraDMixtureGLONE(sp)
			local size = btn:getContentSize()
			sp:setScaleX(size.width / sp:getContentSize().width)
			sp:setScaleY(size.height / sp:getContentSize().height * 1.4)
			sp:runAction(cc.RepeatForever:create(seq))
			sp:setOpacity(148.48)
			_ENV, _ENV = sp, sp.setOpacity
			sp.setOpacity[1], sp.plist = sp, "et_qizhi004_02.plist"
			local param = sp.setOpacity
			local et_node1 = SoraDCreateEffectNode(param)
			et_node1:setPosition(cc.p(btn:getContentSize().width / 2, btn:getContentSize().height / 2))
			et_node1:setScale(0.8)
			et_node1:setRotation(-90)
			et_node1:addTo(btn)
			btn.addEffect = true
		end
	end
end
function RechargeView:isOpen(tabType)
	local data = self.moduleTbl[tabType]
	return data and data.isOpen
end
function RechargeView:checkTabData(tabType)
	local ret = false
	if tabType == gRechargeCenterCategory.LIMITGIFT then
		ret = self:checkLimitData()
	elseif tabType == gRechargeCenterCategory.GOLD then
		ret = true
	elseif tabType == gRechargeCenterCategory.MONTH then
		ret = true
	elseif tabType == gRechargeCenterCategory.DAILYADISCOUNT then
		ret = activityShowCtrl:isActivityOpen(gActivityTimeActivityID.DAILY_DISCOUNT_GIFT_ACTIVITY)
	elseif tabType == gRechargeCenterCategory.RECHARGE_PRESENT then
		local rechargePresentUtil = include("rechargePresentUtil")
		local activityID = rechargePresentUtil.getActivityIDByCategory(tabType)
		if activityID then
			ret = rechargePresentUtil.checkActivityOpen(activityID)
		end
	end
	return ret
end
function RechargeView:checkLimitData()
	local luckyGiftCtrl = gametop.playertop_:getModule("luckyGiftCtrl")
	local luckyGiftList = luckyGiftCtrl:getLuckyGiftData(true)
	for i, v in ipairs(luckyGiftList) do
		local judgeData = rechargeRead.hasRechargeItem(v.luckyGiftID)
		if judgeData then
			return true
		end
	end
	local activeDataList = rechargeActivityCtrl:getHotActivityList()
	for k, v in pairs(activeDataList) do
		if paymentManager.judgeGiftExclusive(k) and rechargeRead.hasRechargeItem(k) and rechargeRead.getRankHideListByID(v.label) then
			return true
		end
	end
	local ladderData = rechargeActivityCtrl:getLadderActivityList()
	if ladderData and next(ladderData) then
		return true
	end
	local princeGiftNewCtrl = gametop.playertop_:getModule("princeGiftNewCtrl")
	local newPrinceGiftData = princeGiftNewCtrl:getNewPrinceData()
	if newPrinceGiftData then
		return true
	end
	return false
end
function RechargeView:isNewPriceGfitOpen()
	local princeGiftNewCtrl = gametop.playertop_:getModule("princeGiftNewCtrl")
	local newPrinceGiftData = princeGiftNewCtrl:getNewPrinceData()
	if newPrinceGiftData then
		return true
	end
	return false
end
function RechargeView:btnTabClick(tabType)
	local data = self.moduleTbl[tabType]
	_ENV = nil
	;(nil).msg = "MESSAGE_CLOSE_GIFT_MENU"
	SoraDSendMessage(nil)
	if data.isOpen then
		advertiseCollect.TriggerEvent(gSDKDef.TDonEvent.advertise_recharge_btn)
		if data.ocx == nil then
			data.ocx = SoraDCreatePanel(data.panelName)
			data.ocx:setPosition(0, 0)
			data.ocx:addTo(self.childrenNode)
			if tabType == gRechargeCenterCategory.RECHARGE_PRESENT then
				data.ocx:setTabType(tabType)
				data.ocx:initData()
			end
		end
		if self.curTab then
			self.curTab:setVisible(false)
		end
		self.curTab = data.ocx
		self.curTab:setVisible(true)
		if self.curTab.updateRechargeOCXOffset then
			self.curTab:updateRechargeOCXOffset()
		else
			self:setRechargeOCXOffset(data.offsetY)
		end
		_ENV = data.offsetY
		data.offsetY.tab = tabType
		userSDKManager.logEvent(gSDKDef.TDonEvent.click_rechargeview_switchtab, data.offsetY)
		if self.isGuideJump and self.curTab and self.curTab.jump2Weekly then
			self.curTab:jump2Weekly()
			self.isGuideJump = false
		end
		return self.curTab
	else
		return nil
	end
end
function RechargeView:expect2SelectTab(tabType, activityID, targetID, giftID)
	self.ccs_tab:clickByTag(tabType)
	if activityID then
		if activityID == gActivityTimeActivityID.EXCHANGE_MALL_RAMADAN then
			local oxt = self:btnTabClick(gRechargeCenterCategory.LIMITGIFT)
			if oxt then
				oxt:jump2Holiday(12)
			end
		elseif activityID == gActivityTimeActivityID.SULTAN_EX_RECAHRGE_PRESENT then
			local oxt = self:btnTabClick(gRechargeCenterCategory.RECHARGE_PRESENT)
			if oxt then
				oxt:jump2Holiday(targetID, giftID)
			end
		elseif activityID == gActivityTimeActivityID.NEW_PRINCE_GIFT_ACTIVITY then
			local oxt = self:btnTabClick(gRechargeCenterCategory.LIMITGIFT)
			if oxt then
				oxt:jump2Holiday(24)
			end
		end
	end
end
function RechargeView:expect2SelectTabEx(tabType, rechargeID)
	self.ccs_tab:clickByTag(tabType)
	if tabType == gRechargeCenterCategory.HOTGIFT or tabType == gRechargeCenterCategory.LIMITGIFT then
		local oxt = self:btnTabClick(gRechargeCenterCategory.LIMITGIFT)
		if oxt then
			self.ccs_tab:switchTab(gRechargeCenterCategory.LIMITGIFT)
			oxt:jump2rechargeID(rechargeID)
		end
	end
end
function RechargeView:jumpToLimitNode(class, giftID)
	local oxt = self:btnTabClick(gRechargeCenterCategory.LIMITGIFT)
	if oxt then
		self.ccs_tab:switchTab(gRechargeCenterCategory.LIMITGIFT)
		oxt:jump2gift(class, giftID)
	end
end
function RechargeView:jumpToLimitNodeByType(class, activeModelType)
	local oxt = self:btnTabClick(gRechargeCenterCategory.LIMITGIFT)
	if oxt then
		self.ccs_tab:switchTab(gRechargeCenterCategory.LIMITGIFT)
		oxt:jump2giftByType(class, activeModelType)
	end
end
function RechargeView:jumpToLimitNodeByList(class, giftList)
	dump(giftList, "RechargeView:jumpToLimitNodeByList")
	local oxt = self:btnTabClick(gRechargeCenterCategory.LIMITGIFT)
	if oxt then
		self.ccs_tab:switchTab(gRechargeCenterCategory.LIMITGIFT)
		oxt:jump2giftByList(class, giftList)
	end
end
function RechargeView:jumpToWeeklyTab()
	local oxt = self:btnTabClick(gRechargeCenterCategory.MONTH)
	if oxt then
		self.ccs_tab:switchTab(gRechargeCenterCategory.MONTH)
		oxt:jump2Weekly()
	end
end
function RechargeView:jumpToWeeklyTakeTab()
	local oxt = self:btnTabClick(gRechargeCenterCategory.MONTH)
	if oxt then
		self.ccs_tab:switchTab(gRechargeCenterCategory.MONTH)
		oxt:jump2Take()
	end
end
function RechargeView:jumpToSubscriptionTab(giftID)
	local oxt = self:btnTabClick(gRechargeCenterCategory.MONTH)
	if oxt then
		self.ccs_tab:switchTab(gRechargeCenterCategory.MONTH)
		oxt:jump2Subscription(giftID)
	end
end
function RechargeView:jumpToDailyDiscountTab(giftID)
	local oxt = self:btnTabClick(gRechargeCenterCategory.DAILYADISCOUNT)
	if oxt then
		self.ccs_tab:switchTab(gRechargeCenterCategory.DAILYADISCOUNT)
	end
end
function RechargeView:changeRedPointState(state, _specialState)
	self.btnDailyDiscountPage:getChildByName("redPoint"):setVisible(state or _specialState)
end
function RechargeView:gameGuide_getTarget(itemName, parameters)
	if itemName == "rechargePresent" then
		local tag
		if self:checkLimitData() then
			tag = _G.gRechargeCenterCategory.LIMITGIFT
		else
			tag = _G.gRechargeCenterCategory.GOLD
		end
		return self.ccs_tab:getTabByTag(tag)
	elseif itemName == "rechargeMonth" then
		self.isGuideJump = true
		return self.ccs_tab:getTabByTag(_G.gRechargeCenterCategory.MONTH)
	end
	return SoraDGetChildByName(self, itemName)
end
function RechargeView:endShow()
	if not include("pyramidWarltCtrl").checkPwXianXiaSai() then
		self:removeFromParent()
	end
end
return RechargeView

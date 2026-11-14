local gametop = gModuleMgr.getObject("gametop")
local rechargeActivityCtrl = gametop.playertop_:getModule("rechargeActivityCtrl")
local rechargeRead = include("rechargeRead")
local publicRead = include("publicRead")
local hideData = gSvrConfig.isReview and device.platform == "android"
local RechargeViewMonthlyNode = class("rechargeViewMonthlyNode", function(target)
	if target == nil then
		return SoraDCreateBasePanel("rechargeViewMonthlyNode")
	end
	return target
end)
function RechargeViewMonthlyNode:ctor()
	self.isHideCurrentSceneView = true
	self.curTab = nil
	self.haveRed = false
	self.monthOffsetY = 0
	self.curTabIndex = 1
	self.nodeNone = SoraDGetChildByName(self, "Top_Node_none")
	self.nodeNone:setVisible(false)
	self.nodeNone:getChildByName("Text_noTitle"):setString(i18n("common_unlock_text_01"))
	self.Top_Node_none_huawei = SoraDGetChildByName(self, "Top_Node_none_huawei")
	self.Top_Node_none_huawei:setVisible(false)
	self.Top_Node_none_huawei:getChildByName("Text_noTitle_huawei"):setString(i18n("common_unlock_text_01"))
	self.Node_month = SoraDGetChildByName(self, "Node_month")
	self.Node_week = SoraDGetChildByName(self, "Node_week")
	self.Node_take = SoraDGetChildByName(self, "Node_take")
	self.ccs_tab = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX_tab")
	self.ccs_tab:setContentSize(cc.size(640, 56))
	self.ccs_tab:setNewStyle()
	self:initSetNode()
	self:showRule()
end
function RechargeViewMonthlyNode:onEnterPanel()
	_ENV = nil
	;(nil).byUID = true
	local clickTime = SoraDConfigGet("Game:MainCityView:monthlyCardTipTime~integer", nil) or 0
	if clickTime == 0 or not serviceFunctions.isSameDay(clickTime) then
		_ENV = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:MainCityView:monthlyCardTipTime~integer", os.time(), nil)
		_ENV = "Game:MainCityView:monthlyCardTipTime~integer"
		;("Game:MainCityView:monthlyCardTipTime~integer").msg = "MESSAGE_MAINCITYVIEW_UPDATE_BOAT_TIP"
		SoraDSendMessage("Game:MainCityView:monthlyCardTipTime~integer")
	end
end
function RechargeViewMonthlyNode:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_ACTIVETIMEOUT", function(target, redata)
		if redata and redata.redata and redata.redata.rid then
			local rechargeRead = include("rechargeRead")
			local info = rechargeRead.getPageViewData(redata.redata.rid)
			if info then
				if gRechargeActiveModelType.MONTHLYGIFT == info.activeModelType then
					self:refreshMonthNode()
				elseif gRechargeActiveModelType.WEEKLY_GIFT == info.activeModelType then
					self:refreshWeeklyNode()
				elseif gRechargeActiveModelType.SUBSCRIPTION == info.activeModelType then
					self:refreshTakeNode()
				end
			end
		end
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_WEEKLY_REFRESH", handler(self, self.refreshWeeklyNode))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_MONTHLY_REFRESH", handler(self, self.refreshMonthNode))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_TAKE_REFRESH", handler(self, self.refreshTakeNode))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_REFRESH", handler(self, self.refreshAll))
end
function RechargeViewMonthlyNode:initSetNode()
	if not rechargeActivityCtrl:getWeekActivityList() then
		local rechargeActivityCtrl, monthData = rechargeActivityCtrl:getWeekActivityList(), rechargeActivityCtrl:getWeekActivityList()
	end
	if not self.nodeMonthView and next(monthData) then
		self.nodeMonthView = SoraDCreatePanel("monthSeasonNode")
		self.nodeMonthView:addTo(self.Node_month)
		self.nodeMonthView:setPosition(0, 0)
	end
	if not rechargeActivityCtrl:getMonthActivityList() then
		local rechargeActivityCtrl, weekData = rechargeActivityCtrl:getMonthActivityList(), rechargeActivityCtrl:getMonthActivityList()
	end
	if not self.nodeWeekView and next(weekData) then
		self.nodeWeekView = SoraDCreatePanel("monthCardNode")
		self.nodeWeekView:addTo(self.Node_week)
		self.nodeWeekView:setPosition(0, 0)
	end
	if not rechargeActivityCtrl:getTakeActivityList() then
		local rechargeActivityCtrl, takeData = rechargeActivityCtrl:getTakeActivityList(), rechargeActivityCtrl:getTakeActivityList()
	end
	if not self.nodeTakeView and next(takeData) and not hideData then
		self.nodeTakeView = SoraDCreatePanel("takeNode")
		self.nodeTakeView:addTo(self.Node_take)
		self.nodeTakeView:setPosition(0, 0)
	end
end
function RechargeViewMonthlyNode:showRule()
	if not rechargeActivityCtrl:getWeekActivityList() then
		local rechargeActivityCtrl, monthData = rechargeActivityCtrl:getWeekActivityList(), rechargeActivityCtrl:getWeekActivityList()
	end
	if not rechargeActivityCtrl:getMonthActivityList() then
		local rechargeActivityCtrl, weekData = rechargeActivityCtrl:getMonthActivityList(), rechargeActivityCtrl:getMonthActivityList()
	end
	if not rechargeActivityCtrl:getTakeActivityList() then
		local rechargeActivityCtrl, takeData = rechargeActivityCtrl:getTakeActivityList(), rechargeActivityCtrl:getTakeActivityList()
	end
	if hideData then
		takeData, rechargeActivityCtrl = hideData, hideData
	end
	if next(monthData) or next(takeData) or next(weekData) then
		self.ccs_tab:setVisible(true)
		self.nodeNone:setVisible(false)
		if userSDKManager.isHuawei() then
			if next(monthData) or next(weekData) then
				print("style===================8")
				if next(monthData) and not next(weekData) then
					self.ccs_tab:reset()
					rechargeActivityCtrl = false
					;(false).tabNum = 1
					rechargeActivityCtrl, rechargeActivityCtrl, (false).defaultClick = nil, self.curTabIndex, self.curTabIndex
					;(nil).title = i18n("common_text_4125")
					;(nil).tag = 1
					;(false).tabsetArray, self.curTabIndex[1], (nil).handle = self.curTabIndex, nil, handler(self, self.btnMonthClick)
					self.ccs_tab:initView(false)
				elseif not next(monthData) and next(weekData) then
					self.ccs_tab:reset()
					rechargeActivityCtrl = false
					;(false).tabNum = 1
					rechargeActivityCtrl, rechargeActivityCtrl, (false).defaultClick = nil, self.curTabIndex, self.curTabIndex
					;(nil).title = i18n("common_text_2460")
					;(nil).tag = 1
					;(false).tabsetArray, self.curTabIndex[1], (nil).handle = self.curTabIndex, nil, handler(self, self.btnWeeklyClick)
					self.ccs_tab:initView(false)
				else
					self.ccs_tab:reset()
					rechargeActivityCtrl = false
					;(false).tabNum = 2
					rechargeActivityCtrl, rechargeActivityCtrl, (false).defaultClick = nil, self.curTabIndex, self.curTabIndex
					;(nil).title = i18n("common_text_4125")
					;(nil).tag = 1
					rechargeActivityCtrl, self.curTabIndex[1], (nil).handle = nil, nil, handler(self, self.btnMonthClick)
					;(nil).title = i18n("common_text_2460")
					;(nil).tag = 2
					;(false).tabsetArray, self.curTabIndex[2], (nil).handle = self.curTabIndex, nil, handler(self, self.btnWeeklyClick)
					self.ccs_tab:initView(false)
				end
			else
				print("style===================9")
				self.ccs_tab:reset()
				rechargeActivityCtrl = false
				;(false).tabNum = 1
				rechargeActivityCtrl, rechargeActivityCtrl, (false).defaultClick = nil, self.curTabIndex, 3
				;(nil).title = i18n("common_text_2461")
				;(nil).tag = 3
				;(false).tabsetArray, self.curTabIndex[1], (nil).handle = self.curTabIndex, nil, handler(self, self.btnTakeClick)
				self.ccs_tab:initView(false)
				self.Node_month:setVisible(false)
				self.Node_week:setVisible(false)
				self.Node_take:setVisible(false)
				self.Top_Node_none_huawei:setVisible(true)
			end
			return
		end
		if not commonCheck.DAILY_DISCOUNT_GIFT then
			if not hideData then
				self.ccs_tab:reset()
				rechargeActivityCtrl = true
				;(true).tabNum = 1
				rechargeActivityCtrl, rechargeActivityCtrl, (true).defaultClick = nil, self.curTabIndex, 3
				;(nil).title = i18n("common_text_2461")
				;(nil).tag = 3
				;(true).tabsetArray, self.curTabIndex[1], (nil).handle = self.curTabIndex, nil, handler(self, self.btnTakeClick)
				self.ccs_tab:initView(true)
				self.Node_month:setVisible(false)
				self.Node_week:setVisible(false)
				self.Node_take:setVisible(true)
			else
				self.ccs_tab:setVisible(false)
				self.nodeNone:setVisible(true)
			end
			return
		end
		if next(monthData) and next(takeData) and next(weekData) then
			print("style===================1")
			self.ccs_tab:reset()
			rechargeActivityCtrl = true
			;(true).tabNum = 3
			rechargeActivityCtrl, rechargeActivityCtrl, (true).defaultClick = nil, self.curTabIndex, self.curTabIndex
			;(nil).title = i18n("common_text_4125")
			;(nil).tag = 1
			rechargeActivityCtrl, self.curTabIndex[1], (nil).handle = nil, nil, handler(self, self.btnMonthClick)
			;(nil).title = i18n("common_text_2460")
			;(nil).tag = 2
			rechargeActivityCtrl, self.curTabIndex[2], (nil).handle = nil, nil, handler(self, self.btnWeeklyClick)
			;(nil).title = i18n("common_text_2461")
			;(nil).tag = 3
			;(true).tabsetArray, self.curTabIndex[3], (nil).handle = self.curTabIndex, nil, handler(self, self.btnTakeClick)
			self.ccs_tab:initView(true)
		end
		if not next(monthData) and next(takeData) and next(weekData) then
			self.curTabIndex = 2
			print("style===================2", self.curTabIndex)
			self.ccs_tab:reset()
			rechargeActivityCtrl = self.curTabIndex
			self.curTabIndex.tabNum = 2
			rechargeActivityCtrl, rechargeActivityCtrl, self.curTabIndex.defaultClick = nil, self.curTabIndex, self.curTabIndex
			;(nil).title = i18n("common_text_2460")
			;(nil).tag = 2
			rechargeActivityCtrl, self.curTabIndex[1], (nil).handle = nil, nil, handler(self, self.btnWeeklyClick)
			;(nil).title = i18n("common_text_2461")
			;(nil).tag = 3
			self.curTabIndex.tabsetArray, self.curTabIndex[2], (nil).handle = self.curTabIndex, nil, handler(self, self.btnTakeClick)
			self.ccs_tab:initView(self.curTabIndex)
		end
		if next(monthData) and not next(takeData) and next(weekData) then
			print("style===================3")
			self.ccs_tab:reset()
			rechargeActivityCtrl = self.curTabIndex
			self.curTabIndex.tabNum = 2
			rechargeActivityCtrl, rechargeActivityCtrl, self.curTabIndex.defaultClick = nil, self.curTabIndex, self.curTabIndex
			;(nil).title = i18n("common_text_4125")
			;(nil).tag = 1
			rechargeActivityCtrl, self.curTabIndex[1], (nil).handle = nil, nil, handler(self, self.btnMonthClick)
			;(nil).title = i18n("common_text_2460")
			;(nil).tag = 2
			self.curTabIndex.tabsetArray, self.curTabIndex[2], (nil).handle = self.curTabIndex, nil, handler(self, self.btnWeeklyClick)
			self.ccs_tab:initView(self.curTabIndex)
		end
		if next(monthData) and next(takeData) and not next(weekData) then
			print("style===================4")
			self.ccs_tab:reset()
			rechargeActivityCtrl = self.curTabIndex
			self.curTabIndex.tabNum = 2
			rechargeActivityCtrl, rechargeActivityCtrl, self.curTabIndex.defaultClick = nil, self.curTabIndex, self.curTabIndex
			;(nil).title = i18n("common_text_4125")
			;(nil).tag = 1
			rechargeActivityCtrl, self.curTabIndex[1], (nil).handle = nil, nil, handler(self, self.btnMonthClick)
			;(nil).title = i18n("common_text_2461")
			;(nil).tag = 3
			self.curTabIndex.tabsetArray, self.curTabIndex[2], (nil).handle = self.curTabIndex, nil, handler(self, self.btnTakeClick)
			self.ccs_tab:initView(self.curTabIndex)
		end
		if not next(monthData) and not next(takeData) and next(weekData) then
			self.curTabIndex = 2
			print("style===================5")
			self.ccs_tab:reset()
			rechargeActivityCtrl = self.curTabIndex
			self.curTabIndex.tabNum = 1
			rechargeActivityCtrl, rechargeActivityCtrl, self.curTabIndex.defaultClick = nil, self.curTabIndex, self.curTabIndex
			;(nil).title = i18n("common_text_2460")
			;(nil).tag = 2
			self.curTabIndex.tabsetArray, self.curTabIndex[1], (nil).handle = self.curTabIndex, nil, handler(self, self.btnWeeklyClick)
			self.ccs_tab:initView(self.curTabIndex)
		end
		if not next(monthData) and next(takeData) and not next(weekData) then
			self.curTabIndex = 3
			print("style===================6")
			self.ccs_tab:reset()
			rechargeActivityCtrl = self.curTabIndex
			self.curTabIndex.tabNum = 1
			rechargeActivityCtrl, rechargeActivityCtrl, self.curTabIndex.defaultClick = nil, self.curTabIndex, self.curTabIndex
			;(nil).title = i18n("common_text_2461")
			;(nil).tag = 3
			self.curTabIndex.tabsetArray, self.curTabIndex[1], (nil).handle = self.curTabIndex, nil, handler(self, self.btnTakeClick)
			self.ccs_tab:initView(self.curTabIndex)
		end
		if next(monthData) and not next(takeData) and not next(weekData) then
			print("style===================7")
			self.ccs_tab:reset()
			rechargeActivityCtrl = self.curTabIndex
			self.curTabIndex.tabNum = 1
			rechargeActivityCtrl, rechargeActivityCtrl, self.curTabIndex.defaultClick = nil, self.curTabIndex, self.curTabIndex
			;(nil).title = i18n("common_text_4125")
			;(nil).tag = 1
			self.curTabIndex.tabsetArray, self.curTabIndex[1], (nil).handle = self.curTabIndex, nil, handler(self, self.btnMonthClick)
			self.ccs_tab:initView(self.curTabIndex)
		end
	else
		self.ccs_tab:setVisible(false)
		self.nodeNone:setVisible(true)
	end
end
function RechargeViewMonthlyNode:refreshAll()
	SoraDCloseLoading()
	self:refreshWeeklyNode()
	self:refreshMonthNode()
	self:refreshTakeNode()
end
function RechargeViewMonthlyNode:checkRedPoint()
	local addRet
	local buyMonth = false
	local buyWeekly = true
	local buyTake = true
	local monthCanRenew = false
	local weeklyCanRenew = false
	local monthData = rechargeActivityCtrl:getWeekActivityList()
	local takeData = rechargeActivityCtrl:getTakeActivityList()
	if monthData and next(monthData) then
		self.ccs_tab:setRedPointState(1, false)
		for k, v in pairs(monthData) do
			if v.isbuy and not v.isdayget then
				self.ccs_tab:setRedPointState(1, true)
				addRet = 1
				break
			elseif not v.isbuy then
				buyWeekly = false
			elseif v.isdayget and v.canRenew then
				weeklyCanRenew = true
			end
		end
	else
		self.ccs_tab:setRedPointState(1, false)
	end
	if takeData and next(takeData) then
		self.ccs_tab:setRedPointState(3, false)
		if takeData.isbuy and not takeData.isdayget then
			self.ccs_tab:setRedPointState(3, true)
			addRet = 3
		elseif not takeData.isbuy then
			buyTake = false
		end
	else
		self.ccs_tab:setRedPointState(3, false)
	end
	local weeklyData = rechargeActivityCtrl:getMonthActivityList()
	if weeklyData and next(weeklyData) then
		self.ccs_tab:setRedPointState(2, false)
		for k, v in pairs(weeklyData) do
			if v.isbuy and not v.isdayget then
				self.ccs_tab:setRedPointState(2, true)
				addRet = 2
				break
			elseif v.isbuy then
				buyMonth = true
			elseif v.isdayget and v.canRenew then
				monthCanRenew = true
			end
		end
	else
		self.ccs_tab:setRedPointState(2, false)
	end
	self.haveRed = addRet ~= nil
	if self.handleRefreshHead then
		self.handleRefreshHead()
	end
	if addRet == nil then
		if not buyMonth then
			addRet = 1
		elseif not buyWeekly then
			addRet = 2
		elseif not buyTake then
			addRet = 3
		elseif monthCanRenew then
			addRet = 1
		elseif weeklyCanRenew then
			addRet = 2
		else
			addRet = 1
		end
	end
	return addRet
end
function RechargeViewMonthlyNode:refreshTakeNode(target, data)
	SoraDCloseLoading()
	if self.nodeTakeView then
		self.nodeTakeView:initData()
	end
	if data then
		self:showRule()
	end
	self:checkRedPoint()
	_ENV = self
	self.msg = "MESSAGE_MAINCITYVIEW_UPDATE_BOAT_TIP"
	SoraDSendMessage(self)
end
function RechargeViewMonthlyNode:refreshWeeklyNode(target, data)
	SoraDCloseLoading()
	if self.nodeWeekView then
		self.nodeWeekView:initData()
	end
	if data then
		self:showRule()
	end
	self:checkRedPoint()
	_ENV = self
	self.msg = "MESSAGE_MAINCITYVIEW_UPDATE_BOAT_TIP"
	SoraDSendMessage(self)
end
function RechargeViewMonthlyNode:refreshMonthNode(target, data)
	SoraDCloseLoading()
	if self.nodeMonthView then
		self.nodeMonthView:initData()
	end
	if data then
		self:showRule()
	end
	self:checkRedPoint()
end
function RechargeViewMonthlyNode:btnMonthClick()
	print("点击月卡=========")
	self.curTabIndex = 1
	self.Node_month:setVisible(true)
	self.Node_week:setVisible(false)
	self.Node_take:setVisible(false)
	self:refreshMonthNode()
	paymentManager.openRechargeView(gRechargeActiveFromEnum.ROAD24)
	_ENV = false
	;(false).tab = "month"
	;(false).class = 1
	userSDKManager.logEvent(gSDKDef.TDonEvent.click_rechargeview_switchtab, false)
	advertiseCollect.TriggerEvent(gSDKDef.TDonEvent.advertise_recharge_btn)
end
function RechargeViewMonthlyNode:btnTakeClick(button, eventType, notSound)
	print("点击订阅=========")
	self.curTabIndex = 3
	if userSDKManager.isHuawei() then
		SoraDShowHelpMsgTip(i18n("allitreas_text_03"))
		return
	end
	self.Node_month:setVisible(false)
	self.Node_week:setVisible(false)
	self.Node_take:setVisible(true)
	paymentManager.openRechargeView(gRechargeActiveFromEnum.ROAD31)
	_ENV = true
	;(true).tab = "take"
	;(true).class = 3
	userSDKManager.logEvent(gSDKDef.TDonEvent.click_rechargeview_switchtab, true)
	advertiseCollect.TriggerEvent(gSDKDef.TDonEvent.advertise_recharge_btn)
end
function RechargeViewMonthlyNode:btnWeeklyClick(button, eventType, notSound)
	print("点击周卡=========")
	self.curTabIndex = 2
	self.Node_month:setVisible(false)
	self.Node_week:setVisible(true)
	self.Node_take:setVisible(false)
	self:refreshWeeklyNode()
	paymentManager.openRechargeView(gRechargeActiveFromEnum.ROAD23)
	_ENV = false
	;(false).tab = "month"
	;(false).class = 2
	userSDKManager.logEvent(gSDKDef.TDonEvent.click_rechargeview_switchtab, false)
	advertiseCollect.TriggerEvent(gSDKDef.TDonEvent.advertise_recharge_btn)
end
function RechargeViewMonthlyNode:btnWeekHelpClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "common_text_4177"
		;("common_text_4177").align = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("common_text_4177"), "common_text_4177")
	end
end
function RechargeViewMonthlyNode:jump2Take()
	self.ccs_tab:clickByTag(1)
end
function RechargeViewMonthlyNode:jump2Weekly()
	self.ccs_tab:clickByTag(2)
end
function RechargeViewMonthlyNode:jump2Subscription(giftID)
	self.ccs_tab:clickByTag(3)
	if giftID then
		self.nodeTakeView:openBuyBox(giftID)
	end
end
function RechargeViewMonthlyNode:checkIsNeedRedPoint()
	return self.haveRed
end
function RechargeViewMonthlyNode:setFatherHeadRefresh(handl)
	self.handleRefreshHead = handl
end
return RechargeViewMonthlyNode

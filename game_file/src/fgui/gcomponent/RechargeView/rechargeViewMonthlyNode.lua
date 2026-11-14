local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
local rechargeRead = include("rechargeRead")
local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local rechargeViewMonthlyNode = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RechargeView/rechargeViewMonthlyNode", rechargeViewMonthlyNode)
local hideData = gSvrConfig.isReview and device.platform == "android"
function rechargeViewMonthlyNode:onInit()
	self.curTabIndex = 1
	self.tabsetArray, _ENV, self.showIndex = nil, nil, 0
	self.isJumpInit = true
	self.fields.Text_noTitle:setString(i18n("common_unlock_text_01"))
end
function rechargeViewMonthlyNode:onShow()
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
function rechargeViewMonthlyNode:registerEvent()
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_ACTIVETIMEOUT", function(target, redata)
		if redata and redata.redata and redata.redata.rid then
			local info = rechargeRead.getPageViewData(redata.redata.rid)
			if info then
				self:refreshNode()
			end
		end
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_WEEKLY_REFRESH", handler(self, self.refreshNode))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_MONTHLY_REFRESH", handler(self, self.refreshNode))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_TAKE_REFRESH", handler(self, self.refreshNode))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_REFRESH", handler(self, self.initData))
end
function rechargeViewMonthlyNode:refreshNode()
	if self.showIndex == 0 then
		self.fields.weekCardNode:initData()
	elseif self.showIndex == 1 then
		self.fields.monthCardNode:initData()
	elseif self.showIndex == 2 then
		self.fields.takeNode:initData()
	end
end
function rechargeViewMonthlyNode:initData(toNodeTag)
	self.toNodeTag = toNodeTag
	self:showRule()
end
function rechargeViewMonthlyNode:showRule()
	if not rechargeActivityCtrl:getWeekActivityList() then
		local rechargeActivityCtrl, monthData = rechargeActivityCtrl:getWeekActivityList(), rechargeActivityCtrl:getWeekActivityList()
	end
	if not rechargeActivityCtrl:getMonthActivityList() then
		local rechargeActivityCtrl, weekData = rechargeActivityCtrl:getMonthActivityList(), rechargeActivityCtrl:getMonthActivityList()
	end
	if not rechargeActivityCtrl:getTakeActivityList() then
		local rechargeActivityCtrl, takeData = rechargeActivityCtrl:getTakeActivityList(), rechargeActivityCtrl:getTakeActivityList()
	end
	self.tabsetArray, rechargeActivityCtrl = rechargeActivityCtrl, rechargeActivityCtrl
	self.curTabIndex = 1
	if not commonCheck.DAILY_DISCOUNT_GIFT then
		if not hideData and next(takeData) then
			self.controllers.c1:setSelectedIndex(1)
			rechargeActivityCtrl, rechargeActivityCtrl = self.controllers.c1, self.controllers.c1.setSelectedIndex
			self.controllers.c1.title = i18n("common_text_2461")
			self.controllers.c1.tag = 1
			self.tabsetArray, self.controllers.c1.setSelectedIndex[1], self.controllers.c1.index = self.controllers.c1.setSelectedIndex, self.controllers.c1, 2
			rechargeActivityCtrl = i18n("common_text_2461")
			i18n("common_text_2461").defaultClick = self.curTabIndex
			i18n("common_text_2461").tabsetArray = self.tabsetArray
			i18n("common_text_2461").callback = handler(self, self.onTabClick)
			self.fields.com_TabW:initView((i18n("common_text_2461")))
		else
			self.controllers.c1:setSelectedIndex(0)
		end
	elseif not next(monthData) and not next(weekData) and not next(takeData) then
		self.controllers.c1:setSelectedIndex(0)
	else
		self.controllers.c1:setSelectedIndex(1)
		if userSDKManager.isHuawei() then
			if next(monthData) or next(weekData) then
				rechargeActivityCtrl, rechargeActivityCtrl = weekData, next(weekData)
				weekData.title = i18n("common_text_4125")
				weekData.tag = 1
				rechargeActivityCtrl, next(weekData)[1], weekData.index = weekData, weekData, 0
				weekData.title = i18n("common_text_2460")
				weekData.tag = 2
				next(weekData)[2], weekData.index = weekData, 1
				local cfg = next(weekData)
				local index = 1
				for k, v in ipairs(cfg) do
					if k == 1 and next(monthData) then
						rechargeActivityCtrl = monthData
						monthData.title = v.title
						monthData.tag = index
						self.tabsetArray[index], monthData.index = monthData, v.index
						index = index + 1
					end
					if k == 2 and next(weekData) then
						rechargeActivityCtrl = weekData
						weekData.title = v.title
						weekData.tag = index
						self.tabsetArray[index], weekData.index = weekData, v.index
						index = index + 1
					end
				end
			else
				self.controllers.c1:setSelectedIndex(0)
			end
		else
			rechargeActivityCtrl, rechargeActivityCtrl = self.controllers.c1, self.controllers.c1.setSelectedIndex
			self.controllers.c1.title = i18n("common_text_4125")
			self.controllers.c1.tag = 1
			rechargeActivityCtrl, self.controllers.c1.setSelectedIndex[1], self.controllers.c1.index = self.controllers.c1, self.controllers.c1, 0
			self.controllers.c1.title = i18n("common_text_2460")
			self.controllers.c1.tag = 2
			rechargeActivityCtrl, self.controllers.c1.setSelectedIndex[2], self.controllers.c1.index = self.controllers.c1, self.controllers.c1, 1
			self.controllers.c1.title = i18n("common_text_2461")
			self.controllers.c1.tag = 3
			self.controllers.c1.setSelectedIndex[3], self.controllers.c1.index = self.controllers.c1, 2
			local cfg = self.controllers.c1.setSelectedIndex
			local index = 1
			for k, v in ipairs(cfg) do
				if k == 1 and next(monthData) then
					rechargeActivityCtrl = monthData
					monthData.title = v.title
					monthData.tag = index
					self.tabsetArray[index], monthData.index = monthData, v.index
					index = index + 1
				end
				if k == 2 and next(weekData) then
					rechargeActivityCtrl = weekData
					weekData.title = v.title
					weekData.tag = index
					self.tabsetArray[index], weekData.index = weekData, v.index
					index = index + 1
				end
				if k == 3 and next(takeData) and not hideData then
					rechargeActivityCtrl = takeData
					takeData.title = v.title
					takeData.tag = index
					self.tabsetArray[index], takeData.index = takeData, v.index
					index = index + 1
				end
			end
		end
		if #self.tabsetArray > 0 then
			if self.toNodeTag and self.isJumpInit then
				for k, v in ipairs(self.tabsetArray) do
					if self.toNodeTag == v.index then
						self.curTabIndex = v.tag
						break
					end
				end
				self.isJumpInit = false
			end
			rechargeActivityCtrl = ipairs(self.tabsetArray)
			ipairs(self.tabsetArray).defaultClick = self.curTabIndex
			ipairs(self.tabsetArray).tabsetArray = self.tabsetArray
			ipairs(self.tabsetArray).callback = handler(self, self.onTabClick)
			self.fields.com_TabW:initView(ipairs(self.tabsetArray))
		end
	end
end
function rechargeViewMonthlyNode:onTabClick(tag)
	self.curTabIndex = tag
	self.showIndex = self.tabsetArray[self.curTabIndex].index
	self.controllers.c2:setSelectedIndex(self.showIndex)
	self:refreshNode()
end
return rechargeViewMonthlyNode

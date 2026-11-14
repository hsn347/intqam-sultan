local activityExchangeMallRead = include("activityExchangeMallRead")
local publicRead = include("publicRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local divineBeastMarkRead = include("divineBeastMarkRead")
local divineBeastCtrl = SoraDGetCtrl("divineBeastCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local BeastCanyonExchangePanel = class("BeastCanyonExchangePanel", baseFguiPanel)
_ENV = "BeastCanyonExchangePanel"
;("BeastCanyonExchangePanel").NO_LIMIT = 0
;("BeastCanyonExchangePanel").EVERY_DAY_RESET = 1
;("BeastCanyonExchangePanel").EVERY_ACTIVITY_RESET = 2
;("BeastCanyonExchangePanel").EVERY_WEEK_RESET = 3
;("BeastCanyonExchangePanel").ALWAYS_LIMIT = 4
;("BeastCanyonExchangePanel").EVERY_ROUND_RESET = 5
;("BeastCanyonExchangePanel").SEASON_RESET = 6
local ("BeastCanyonExchangePanel").MONTH_RESET, gActExLimitType = 7, "BeastCanyonExchangePanel"
function BeastCanyonExchangePanel:ctor(...)
	self.super.ctor(self, ...)
	print("BeastCanyonExchangePanel:ctor", self.viewName)
end
function BeastCanyonExchangePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function BeastCanyonExchangePanel:onInit()
	print("=======BeastCanyonExchangePanel:onInit")
	self.activityID = self.param and self.param.activityID or gActivityTimeActivityID.DIVINE_BEAST_CANYON_ACTIVITY
	if self.activityID == gActivityTimeActivityID.CELEBRATE_CORBAN then
		self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
		self.fields.Label_time:setTimeLast(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n("common_text_607", nil)
		end)
	else
		self.fields.Com_title:initData(i18n("common_text_1889"), handler(self, self.onClickClose))
		self.fields.Label_time:setTimeLast(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n("commandhall_text_78", nil)
		end)
		self.fields.Label_time:setTimeEndListener(function()
			self:updatScroll()
		end)
	end
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.Label_Num:getChild("icon"):fixPos()
	self.fields.Button_add = self.fields.Label_Num:getChild("Button_add")
	self.fields.Button_add:fixPos()
	if self.activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001650 then
		self.fields.Button_add:addClickListener(handler(self, self.onClickBtnAdd))
		self.fields.Button_add:setVisible(true)
	else
		self.fields.Button_add:setVisible(false)
	end
	self.filterArmy, _ENV = self.fields.Button_add.setVisible, self.fields.Button_add.setVisible
	self.fields.Btn_army:setTitle(i18n("mail_2_text_35"))
	self.fields.Btn_army:addClickListener(handler(self, self.onArmyClick))
	self.exchangeItemList = activityExchangeMallRead:getExchangeItemList(self.activityID)
	if self.activityID == gActivityTimeActivityID.CELEBRATE_CORBAN then
		_ENV = self.activityID
		_ENV, _ENV, self.activityID.defaultClick = self.activityID, gActivityTimeActivityID.CELEBRATE_CORBAN, 2
		self.activityID.title = i18n("anniversary_cross_text_03")
		_ENV, gActivityTimeActivityID.CELEBRATE_CORBAN[1], self.activityID.tag = self.activityID, self.activityID, 0
		self.activityID.title = i18n("common_text_4498")
		_ENV, gActivityTimeActivityID.CELEBRATE_CORBAN[2], self.activityID.tag = self.activityID, self.activityID, 1
		_ENV = handler(self, self.onArmyClick)
		handler(self, self.onArmyClick).item = ""
		self.activityID.title = i18n("Elitebeastcanyon_text_4", handler(self, self.onArmyClick))
		self.activityID.tabsetArray, gActivityTimeActivityID.CELEBRATE_CORBAN[3], self.activityID.tag = gActivityTimeActivityID.CELEBRATE_CORBAN, self.activityID, 2
		local self.activityID.callback, param = handler(self, self.onClickTab2), self.activityID
		self.fields.com_Tab2:initView(param)
		local activity_9001637_Ctrl = SoraDGetCtrl("activity_9001637_Ctrl")
		local rewardRedNum = activity_9001637_Ctrl:getUnGetRewardNum()
		self.fields.com_Tab2:setBtnRedDot(1, 0 < rewardRedNum, rewardRedNum)
		local taskRedPoint = activity_9001637_Ctrl:getTaskRedNum()
		self.fields.com_Tab2:setBtnRedDot(2, 0 < taskRedPoint, taskRedPoint)
		self.controllers.c_viewType:setSelectedIndex(2)
		self.exchangeItemID = self.exchangeItemList[1]
		self:initExchangeItemID()
	elseif #self.exchangeItemList > 1 then
		self.controllers.c_viewType:setSelectedIndex(1)
		table.sort(self.exchangeItemList)
		local _ENV, tabsetArray = table.sort, table.sort
		for __, itemID in ipairs(self.exchangeItemList) do
			local itemName = publicRead.getName(itemID)
			_ENV = handler(self, self.onArmyClick)
			_ENV = handler(self, self.onArmyClick)
			handler(self, self.onArmyClick).item = itemName
			handler(self, self.onArmyClick).title = i18n("Elitebeastcanyon_text_4", handler(self, self.onArmyClick))
			table.insert(tabsetArray, handler(self, self.onArmyClick))
		end
		local _ENV, defaultClick = ipairs(self.exchangeItemList)
		ipairs(self.exchangeItemList).defaultClick = defaultClick
		ipairs(self.exchangeItemList).tabsetArray = tabsetArray
		local ipairs(self.exchangeItemList).callback, param = handler(self, self.onClickTab), ipairs(self.exchangeItemList)
		self.fields.com_Tab:initView(param)
	else
		self.controllers.c_viewType:setSelectedIndex(0)
		self.exchangeItemID = self.exchangeItemList[1]
		self:initExchangeItemID()
	end
end
function BeastCanyonExchangePanel:onShow()
	print("=======BeastCanyonExchangePanel:onShow")
end
function BeastCanyonExchangePanel:onClickHelp()
	SoraDPlaySound()
	if self.activityID == gActivityTimeActivityID.CELEBRATE_CORBAN then
		_ENV = nil
		;(nil).content = i18n("eidTycoon2024_text_01")
		uiManager:show("RuleView", nil)
	end
end
function BeastCanyonExchangePanel:onClickTab2(tag)
	if tag == 2 then
		return
	end
	self:closePanel()
	_ENV = nil
	;(nil).activityID = gActivityTimeActivityID.CELEBRATE_CORBAN
	;(nil).tabIndex = tag
	uiManager:show("Activity_9001624_Main", nil)
end
function BeastCanyonExchangePanel:onClickTab(tag)
	self.exchangeItemID = self.exchangeItemList[tag]
	self.showAdd = self.exchangeItemID == 227501
	self:initExchangeItemID()
	self.controllers.c_viewType:setSelectedIndex(self.showAdd and 1 or 3)
	table.sort(self.exchangeItemList)
	self.fields.Button_add:setVisible(self.showAdd)
end
function BeastCanyonExchangePanel:initExchangeItemID(...)
	self.fields.Label_Num:setIcon(publicRead.getIcon(self.exchangeItemID))
	self:updatScroll()
	self:updateItemNum()
end
function BeastCanyonExchangePanel:updateItemNum()
	_ENV = nil
	;(nil).name = publicRead.getName(self.exchangeItemID)
	;(nil).msg = string.formatnumberthousands(backpackCtrl:getItemCount(self.exchangeItemID))
	self.fields.Label_Num:setString(i18n("common_text_1000", nil))
	if self.activityID == gActivityTimeActivityID.CELEBRATE_CORBAN then
		local activity_9001637_Ctrl = SoraDGetCtrl("activity_9001637_Ctrl")
		local exchangeRedNum = activity_9001637_Ctrl:getExchangeRedNum()
		self.fields.com_Tab2:setBtnRedDot(3, 0 < exchangeRedNum, exchangeRedNum)
	end
end
function BeastCanyonExchangePanel:updatScroll()
	local classType
	if self.activityID == gActivityTimeActivityID.CELEBRATE_CORBAN then
		classType = activityShowCtrl:getParamClassType(self.activityID)
	end
	if not activityExchangeMallRead:getShopItemList(self.activityID, classType) then
		local _ENV, showShopItemList = activityExchangeMallRead:getShopItemList(self.activityID, classType), activityExchangeMallRead:getShopItemList(self.activityID, classType)
	end
	local _ENV, ret1 = activityExchangeMallRead, activityExchangeMallRead
	for __, cfg in ipairs(showShopItemList) do
		if self.exchangeItemID == cfg.exchangeitem then
			table.insert(ret1, cfg)
		end
	end
	local _ENV, ret2 = (for generator), ipairs(showShopItemList)
	for __, cfg in ipairs(ret1) do
		if self.showAdd then
			local markCfg = divineBeastMarkRead.getDbMarkCfg(cfg.shopitem)
			if markCfg == nil or not self.filterArmy[markCfg.army_id] then
				table.insert(ret2, cfg)
			end
		else
			table.insert(ret2, cfg)
		end
	end
	local _ENV, ret3 = (for generator), ipairs(ret1)
	for _, cfg in ipairs(ret2) do
		if #cfg.exLimit > 0 and cfg.exLimit[1] == 3 or cfg.exLimit[1] == 4 then
			_ENV = cfg.exLimit[1]
			cfg.exLimit[1][3] = gBestID.ONE
			local cfg.exLimit[1][4], limitMap = gBestID.TWO, cfg.exLimit[1]
			local divineID = limitMap[cfg.exLimit[1]]
			local stepLv = cfg.exLimit[2] or 0
			if divineBeastCtrl:getIsUnlock(divineID) then
				table.insert(ret3, cfg)
			end
		else
			table.insert(ret3, cfg)
		end
	end
	self.showShopItemList = ret3
	self.fields.List:setNumItems(#self.showShopItemList)
	local leftTime = self:getLeftTime()
	if leftTime then
		self.fields.Label_time:beginTime(leftTime)
	end
end
function BeastCanyonExchangePanel:onItemRederer(index, target)
	local taskInfo = self.showShopItemList[index + 1]
	target:initData(taskInfo)
end
function BeastCanyonExchangePanel:getLeftTime()
	if self.activityID == gActivityTimeActivityID.CELEBRATE_CORBAN then
		return activityShowCtrl:getRemainTime(self.activityID)
	elseif self.activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001650 then
		local cfg = self.showShopItemList[1]
		if cfg and cfg.limitType == gActExLimitType.MONTH_RESET then
			return serviceFunctions.getNextMonthFirstDayTime()
		end
	end
	local weekDay = os.date("!%w", serviceFunctions.systemTime())
	local day = 7 - (tonumber(weekDay) == 0 and 7 or weekDay)
	local leftTime = serviceFunctions.getTodayRemainTime() + day * 3600 * 24
	if 0 < leftTime then
		return leftTime
	end
	return 0
end
function BeastCanyonExchangePanel:onClickBtnAdd(...)
	SoraDPlaySound()
	_ENV = nil
	;(nil).itemID = self.exchangeItemID
	uiManager:show("CommonSourceGuide", nil)
end
function BeastCanyonExchangePanel:onArmyClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).filterData = self.filterArmy
	;(nil).filterType = 1
	;(nil).sureCallback = function(filterData)
		self.filterArmy = filterData
		self:updatScroll()
	end
	uiManager:show("DivineBeastMarkFilter", nil)
end
return BeastCanyonExchangePanel

local activityExchangeMallRead = include("activityExchangeMallRead")
local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ActExchangePageNewPanel = class("ActExchangePageNewPanel", baseFguiPanel)
function ActExchangePageNewPanel:ctor(...)
	ActExchangePageNewPanel.super.ctor(self, ...)
	print("ActExchangePageNewPanel:ctor", self.viewName)
	ActExchangePageNewPanel = print
	ActExchangePageNewPanel = self.viewName
	self.viewName.title = i18n("activity_name_9001632")
	self.viewName.showItem = true
	self.viewName.clickItem = false
	print[gActivityTimeActivityID.NEBULA_SURPRISED_DROP_STORE], self.viewName.bg = self.viewName, "bg_9001627_guanggaotu.png"
	ActExchangePageNewPanel = self.viewName
	self.viewName.title = i18n("allianceWar_shop_title")
	self.viewName.hideTip = true
	self.viewName.showTime = true
	print[gActivityTimeActivityID.EXCHANGE_ACTIVITY_9001653], self.viewName.showTimeStr = self.viewName, "shop_reset_countdown"
	ActExchangePageNewPanel = self.viewName
	self.viewName.title = i18n("weapon_creating_01")
	self.viewName.showItem = true
	self.viewName.clickItem = true
	ActExchangePageNewPanel, ActExchangePageNewPanel, self.viewName.bg = "weapon_creating_01", i18n("weapon_creating_01"), "bg_9001651_guanggaotu.png"
	;("weapon_creating_01").title = i18n("weapon_creating_02")
	ActExchangePageNewPanel, i18n("weapon_creating_01")[1], ("weapon_creating_01").tag = "weapon_creating_01", "weapon_creating_01", 1
	;("weapon_creating_01").title = i18n("weapon_creating_03")
	self.viewName.tabsetArray, i18n("weapon_creating_01")[2], ("weapon_creating_01").tag = i18n("weapon_creating_01"), "weapon_creating_01", 2
	self.viewName.defaultClick = 2
	function self.viewName.callback(tag)
		if tag == 1 then
			uiManager:show("Activity_9001651_Main")
			self:close()
		end
	end
	self.viewName.showTabTime = true
	print[gActivityTimeActivityID.NEBULA_FURNACE_ACTIVITY], self.viewName.redNumFunc = self.viewName, function()
		return SoraDGetCtrl("activity_9001651_Ctrl"):getExchangeNum()
	end
	ActExchangePageNewPanel = self.viewName
	self.viewName.title = i18n("activity_name_9010003")
	self.viewName.showItem = true
	print[gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010003], self.viewName.bg = self.viewName, "bg_9001658_shangdian.png"
	ActExchangePageNewPanel = self.viewName
	self.viewName.title = i18n("conquestwar_text_89")
	self.viewName.bg = "bg_activity_9010009.png"
	self.viewName.showTime = true
	self.viewName.showClientTime = "conquestwar_text_91"
	function self.viewName.clientTimeFunc()
		local conquestWarCtrl = SoraDGetCtrl("conquestWarCtrl")
		local state = conquestWarCtrl:getConquestWarState()
		if state == gConquestWarState.WAITING then
			return conquestWarCtrl:getLeftTime()
		else
			local secOfOneDay = 86400
			return serviceFunctions.getNextWeekDayUTC(gWeekDay.WEDNESDAY) + secOfOneDay * 7 - serviceFunctions.systemTime()
		end
	end
	print[gActivityTimeActivityID.EXCHANGE_MALL_ACTIVITY_9010009], self.viewName.helpClick = self.viewName, function()
		SoraDPlaySound()
		_ENV = nil
		;(nil).content = i18n("conquestwar_text_90")
		uiManager:show("RuleView", nil)
	end
	ActExchangePageNewPanel = self.viewName
	self.viewName.title = i18n("eidTycoon2024_text_04")
	self.viewName.showItem = true
	self.viewName.clickItem = true
	self.activityConfig, print[gActivityTimeActivityID.NORMAL_ACTIVITY_9001736], self.viewName.noBanner = print, self.viewName, true
end
function ActExchangePageNewPanel:onInit()
	print("=======ActExchangePageNewPanel:onInit")
	self.tableData, _ENV = print, print
	self.activityID = gActivityTimeActivityID.RIDES_EXCHANGE_MALL
	self.fields.Com_title:initData(i18n("activity_name_06"), handler(self, self.onClickClose))
	self.fields.Button_toShop:addClickListener(handler(self, self.btnGoShopClick))
	self.fields.Com_tab:setVisible(false)
	self.fields.Label_time:setVisible(false)
	self.fields.Btn_weaponDes:setString(i18n("HeroWeapon_9"))
	self.fields.Btn_weaponDes:addClickListener(handler(self, self.btnWeaponDesClick))
	self.fields.Btn_weaponDes:setVisible(false)
	if not self.proxy.param then
		local _ENV, param = self.proxy.param, self.proxy.param
	end
	self.param = param
	self:setActivityID(param.activityID or param.id)
end
function ActExchangePageNewPanel:onShow()
	print("=======ActExchangePageNewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
end
function ActExchangePageNewPanel:setActivityID(activityID)
	if not activityID then
		return
	end
	self.activityID = activityID
	if not self.activityConfig[self.activityID] then
		_ENV = self.activityConfig[self.activityID]
	end
	self.cfg = self.activityConfig[self.activityID]
	self.fields.Com_title:setTitleWidthHeight(360, 40)
	local titleStr = self.cfg.title or i18n(string.format("activity_exchange_%s", self.activityID))
	self.fields.Com_title:setString(titleStr)
	if self.cfg.helpClick then
		self.fields.Com_title:setHelpCallBack(self.cfg.helpClick)
	end
	self.fields.Btn_weaponDes:setVisible(self.activityID == gActivityTimeActivityID.NEBULA_FURNACE_ACTIVITY)
	self:initData()
	self:setTime()
	self:setBgAndIcon()
end
function ActExchangePageNewPanel:initData()
	if self.cfg.showItem or self.param.items then
		self.exchangeItemIDArray = self.param.items or activityExchangeMallRead:getExchangeItemList(self.activityID)
		self.fields.Button_toShop:setIconAndNum(self.exchangeItemIDArray)
	else
		self.fields.Button_toShop:setVisible(false)
	end
	if self.cfg.tabsetArray then
		self.fields.Com_title:getController("c1"):setSelectedIndex(0)
		self.fields.Com_tab:setVisible(true)
		activityExchangeMallRead = true
		;(true).defaultClick = self.cfg.defaultClick
		;(true).tabsetArray = self.cfg.tabsetArray
		;(true).callback = self.cfg.callback
		self.fields.Com_tab:initView(true)
		if self.cfg.redNumFunc then
			local exchangeNum = self.cfg.redNumFunc()
			self.fields.Com_tab:setBtnRedDot(self.cfg.defaultClick, 0 < exchangeNum, exchangeNum)
		end
	else
		self.fields.Com_tab:setVisible(false)
	end
	if self.cfg.showTabTime then
		self.fields.Label_time:setVisible(true)
		self.fields.Label_time:initCommonActivityTime(self.activityID)
	else
		self.fields.Label_time:setVisible(false)
	end
	if not activityExchangeMallCtrl:getConfigByActivityID(self.activityID) then
		activityExchangeMallRead = activityExchangeMallCtrl:getConfigByActivityID(self.activityID)
	end
	self.tableData = activityExchangeMallCtrl:getConfigByActivityID(self.activityID)
	self:sortData()
	activityExchangeMallRead = self.sortData
	self.sortData.activityID = self.activityID
	self.otherData, self.sortData.hideTip = self.sortData, self.cfg.hideTip
	self.fields.List_exchange:setVirtual()
	self.fields.List_exchange:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_exchange:setNumItems(table.nums(self.tableData))
end
function ActExchangePageNewPanel:onItemRenderer(index, obj)
	local data = self.tableData[index + 1]
	obj:initData(data, self.otherData)
end
function ActExchangePageNewPanel:setTime()
	if self.cfg.showTime then
		if self.cfg.showTimeStr then
			local eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
			if eventTime then
				local leftTime = eventTime.timerNode.timer:getRemainTime()
				self.fields.Com_title:initSpecialTime(leftTime, self.cfg.showTimeStr)
			else
				self.fields.Com_title:setTimeShow(false)
			end
		elseif self.cfg.showNextMonthTime then
			self.fields.Com_title:initSpecialTime(serviceFunctions.getNextMonthFirstDayTime(), self.cfg.showNextMonthTime)
		elseif self.cfg.clientTimeFunc then
			self.fields.Com_title:initSpecialTime(self.cfg.clientTimeFunc(), self.cfg.showClientTime)
		else
			self.fields.Com_title:initCommonActivityTime(self.activityID)
		end
	else
		self.fields.Com_title:setTimeShow(false)
	end
end
function ActExchangePageNewPanel:sortData()
	for i, v in ipairs(self.tableData) do
		v.weight = 0
		v.index = i
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
function ActExchangePageNewPanel:setBgAndIcon()
	if self.cfg.noBanner then
		self.controllers.c_banner:setSelectedIndex(1)
		self.fields.Com_title:setTabShow(false)
		return
	else
		self.controllers.c_banner:setSelectedIndex(0)
	end
	local bgName = self.cfg.bg or "bg_exchange_" .. self.activityID .. ".png"
	self.fields.Load_bg:setURL(bgName)
end
function ActExchangePageNewPanel:btnGoShopClick(context)
	if self.param.clickTips then
		SoraDShowMsgTip(self.param.clickTips)
		return
	end
	if self.cfg.clickItem == false then
		return
	end
	SoraDPlaySound()
	_ENV = nil
	;(nil).itemList = self.exchangeItemIDArray
	uiManager:show("CommonSourceGuide", nil)
end
function ActExchangePageNewPanel:judgeClose()
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
function ActExchangePageNewPanel:btnWeaponDesClick()
	SoraDPlaySound()
	uiManager:show("HeroWeaponMap")
end
return ActExchangePageNewPanel

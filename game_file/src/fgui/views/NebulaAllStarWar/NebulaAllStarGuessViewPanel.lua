local publicRead = include("publicRead")
local nebulaAllStarRead = include("nebulaAllStarRead")
local nebulaAllStarUtil = include("nebulaAllStarUtil")
local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaAllStarGuessViewPanel = class("NebulaAllStarGuessViewPanel", baseFguiPanel)
function NebulaAllStarGuessViewPanel:ctor(...)
	NebulaAllStarGuessViewPanel.super.ctor(self, ...)
	print("NebulaAllStarGuessViewPanel:ctor", self.viewName)
end
function NebulaAllStarGuessViewPanel:onInit()
	print("=======NebulaAllStarGuessViewPanel:onInit")
	self.tag = 1
	self.coinID = gIDDef.NEBULA_ALLSTAR_QUIZ_COIN
	self.turn = 1
	self.turnPass = false
	self.shopList, _ENV, self.themeList, _ENV, self.isInSettle = gIDDef.NEBULA_ALLSTAR_QUIZ_COIN, gIDDef.NEBULA_ALLSTAR_QUIZ_COIN, gIDDef.NEBULA_ALLSTAR_QUIZ_COIN, gIDDef.NEBULA_ALLSTAR_QUIZ_COIN, false
	self.fields.Com_title:initData(i18n("NebulaAllstar_213"), handler(self, self.onClickClose))
	self.fields.Com_coin:setIcon(publicRead.getIcon(self.coinID))
	self.fields.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
	self.fields.Text_time:setTimeEndListener(function()
		self:setRefreshTime()
		self:updateView()
	end)
	self.fields.Text_leftTime = SoraDCreateTimerLabel(self, self.fields.Text_leftTime)
	self.fields.List_guess:setItemRenderer(handler(self, self.onThemeRenderer))
	self.fields.List_shop:setVirtual()
	self.fields.List_shop:setItemRenderer(handler(self, self.onShopRenderer))
	self.fields.Text_none:setString(i18n("NebulaAllstar_342"))
	self.fields.Text_none:setVisible(false)
end
function NebulaAllStarGuessViewPanel:onThemeRenderer(index, obj)
	obj:initData(self.themeList[index + 1], index + 1, self.tag, self.turnPass, self.turn)
end
function NebulaAllStarGuessViewPanel:onShopRenderer(index, obj)
	obj:initData(self.shopList[index + 1])
end
function NebulaAllStarGuessViewPanel:onShow()
	print("=======NebulaAllStarGuessViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self.tag = self.param and self.param.tag or 1
	self.isFirst = true
	self.passTime = nebulaAllStarCtrl:getWarStarPassTime()
	self:setStatus()
	self:setActivityTime()
	self:setRefreshTime()
end
function NebulaAllStarGuessViewPanel:initData(target, data)
	SoraDCloseLoading(self)
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, self.tag, self.tag
	;(nil).title = i18n("NebulaAllstar_214")
	_ENV, self.tag[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("NebulaAllstar_215")
	_ENV, self.tag[2], (nil).tag = nil, nil, 2
	;(nil).title = i18n("NebulaAllstar_33")
	;(nil).tabsetArray, self.tag[3], (nil).tag = self.tag, nil, 3
	;(nil).callback = handler(self, self.onClickTab)
	self.fields.Com_tab:initView(nil)
	self:setShopRed()
end
function NebulaAllStarGuessViewPanel:onClickTab(tag)
	if self.isInSettle and tag ~= 3 then
		SoraDShowMsgTip(i18n("NebulaAllstar_297"))
		self.fields.Com_tab:setToTab(3)
		return
	end
	self.tag = tag
	self.controllers.c1:setSelectedIndex(self.tag - 1)
	if self.isFirst and self.tag == 3 then
		SoraDShowLoading(self)
		nebulaAllStarCtrl:reqViewerExchangeRecord()
		self.isFirst = false
	else
		self:updateView()
	end
end
function NebulaAllStarGuessViewPanel:setShopRed()
	local ret, retNum = nebulaAllStarCtrl:getQuizShopStatusAndNum(true)
	self.fields.Com_tab:setBtnRedDot(3, ret, retNum)
end
function NebulaAllStarGuessViewPanel:setStatus()
	if nebulaAllStarUtil.checkActivityState(nebulaAllStarRead.NEBULA_ALL_STAR_STATE.BATTLE) then
		SoraDShowLoading(self)
		nebulaAllStarCtrl:reqViewerQuizRecord()
	elseif nebulaAllStarUtil.checkActivityState(nebulaAllStarRead.NEBULA_ALL_STAR_STATE.SETTLE) then
		self.tag = 3
		self.isInSettle = true
		self:initData()
	end
end
function NebulaAllStarGuessViewPanel:setRefreshTime()
	self.turn = nebulaAllStarRead.getTurnByTime(self.passTime)
	self.turnPass = false
	if nebulaAllStarRead.isLastTurn(self.turn) then
		local leftTime = nebulaAllStarRead.getGuessTime(self.turn, self.passTime)
		if 0 < leftTime then
			self.fields.Text_time:setTimeLast(function(timeStr)
				self.passTime = self.passTime + 1
				self = nil
				;(nil).time = fguiHelper.getColorString("#70C723", timeStr)
				return i18n("NebulaAllstar_292", nil)
			end)
			self.fields.Text_time:beginTime(leftTime)
		else
			self.fields.Text_time:setString(i18n("NebulaAllstar_294"))
		end
		self.turnPass = leftTime <= 0
	else
		local leftTime = nebulaAllStarRead.getGuessTime(self.turn, self.passTime)
		if 0 < leftTime then
			self.fields.Text_time:setTimeLast(function(timeStr)
				self.passTime = self.passTime + 1
				self = nil
				;(nil).time = fguiHelper.getColorString("#70C723", timeStr)
				return i18n("NebulaAllstar_292", nil)
			end)
			self.fields.Text_time:beginTime(leftTime)
		else
			self.turnPass = true
			self.fields.Text_time:setTimeLast(function(timeStr)
				self.passTime = self.passTime + 1
				self = nil
				;(nil).time = fguiHelper.getColorString("#70C723", timeStr)
				return i18n("NebulaAllstar_222", nil)
			end)
			local nextTurn = nebulaAllStarRead.getNextTurnByTime(self.passTime)
			local nextTurnCfg = nebulaAllStarRead.getTurnCfg(nextTurn)
			local tempTime = nextTurnCfg.RefreshTime - self.passTime
			if 0 < tempTime then
				self.fields.Text_time:beginTime(tempTime)
			end
		end
	end
end
function NebulaAllStarGuessViewPanel:setActivityTime()
	self.fields.Text_leftTime:setTimeLast(function(timeStr)
		return i18n("common_text_2669") .. fguiHelper.getColorString("#70C723", timeStr)
	end)
	local timer = SoraDGetCtrl("activityShowCtrl"):getTimeInfoByID(gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY)
	local leftTime = timer.timerNode.timer:getRemainTime()
	if 0 < leftTime then
		self.fields.Text_leftTime:beginTime(leftTime)
	end
end
function NebulaAllStarGuessViewPanel:updateCoin()
	self.fields.Com_coin:setString(nebulaAllStarCtrl:getViewerQuizCoin())
end
function NebulaAllStarGuessViewPanel:exchangeBack()
	self:updateCoin()
	self:setShopRed()
	self.shopList = self:getShopList()
	self.fields.List_shop:setNumItems(#self.shopList)
end
function NebulaAllStarGuessViewPanel:getShopList()
	local nebulaAllStarRead, list
	local shopList = nebulaAllStarRead.getStoreCfg()
	local quizCoin = nebulaAllStarCtrl:getViewerQuizCoin()
	for k, v in ipairs(shopList) do
		if SoraDGetBuildStarLv() >= v.gloriousLv then
			local record = nebulaAllStarCtrl:getViewerExchangeRecord(v.shopItemID)
			local exchangedCount = record and record.count or 0
			local leftCount = math.max(0, v.limitnum - exchangedCount)
			local isCanExchange = quizCoin >= v.exchangeitem and 0 < leftCount
			if v.itemtype == 2 then
				local isInBattle = nebulaAllStarUtil.checkActivityState(nebulaAllStarRead.NEBULA_ALL_STAR_STATE.BATTLE)
				if isInBattle then
					v.leftCount = leftCount
					v.isCanExchange = isCanExchange
					table.insert(list, v)
				end
			else
				v.leftCount = leftCount
				v.isCanExchange = isCanExchange
				table.insert(list, v)
			end
		end
	end
	table.sort(list, function(a, b)
		if a.isCanExchange and b.isCanExchange then
			return a.shopItemID < b.shopItemID
		end
		if a.isCanExchange and not b.isCanExchange then
			return true
		end
		if not a.isCanExchange and b.isCanExchange then
			return false
		end
		if not a.isCanExchange and not b.isCanExchange then
			if a.leftCount == 0 and b.leftCount == 0 then
				return a.shopItemID < b.shopItemID
			end
			if a.leftCount > 0 and b.leftCount == 0 then
				return true
			end
			if a.leftCount == 0 and b.leftCount > 0 then
				return false
			end
			if a.leftCount > 0 and b.leftCount > 0 then
				return a.shopItemID < b.shopItemID
			end
		end
	end)
	return list
end
function NebulaAllStarGuessViewPanel:updateView()
	SoraDCloseLoading(self)
	self:updateCoin()
	if self.tag == 3 then
		self.fields.Text_none:setVisible(false)
		self.fields.Text_time:setVisible(false)
		self.fields.Text_leftTime:setVisible(true)
		self.shopList = self:getShopList()
		self.fields.List_shop:setNumItems(#self.shopList)
	elseif self.tag == 1 then
		self.fields.Text_none:setVisible(false)
		self.fields.Text_time:setVisible(true)
		self.fields.Text_leftTime:setVisible(false)
		local turnCfg = nebulaAllStarRead.getTurnCfg(self.turn)
		self.themeList = turnCfg.theme
		self.fields.List_guess:setNumItems(#self.themeList)
		self.fields.List_guess:jumpToTop()
	elseif self.tag == 2 then
		self.fields.Text_time:setVisible(false)
		self.fields.Text_leftTime:setVisible(false)
		local quizBetList = nebulaAllStarCtrl:getViewerQuizBet()
		local _ENV, quizBetArray = nebulaAllStarCtrl, nebulaAllStarCtrl
		for k, v in pairs(quizBetList) do
			_ENV = nil
			;(nil).theme = tonumber(k)
			;(nil).t = v.t
			;(nil).r = v.result ~= nil
			table.insert(quizBetArray, nil)
		end
		table.sort(quizBetArray, function(a, b)
			if a.r == b.r then
				return a.t < b.t
			end
			if a.r ~= b.r then
				return not a.r
			end
		end)
		self.themeList, _ENV = table.sort, table.sort
		for _, data in pairs(quizBetArray) do
			table.insert(self.themeList, data.theme)
		end
		self.fields.Text_none:setVisible(#self.themeList == 0)
		self.fields.List_guess:setNumItems(#self.themeList)
		self.fields.List_guess:jumpToTop()
	end
end
function NebulaAllStarGuessViewPanel:onMsgQuizBetBack(...)
	self:updateCoin()
	if self.tag ~= 1 then
		return
	end
	self.fields.List_guess:setNumItems(#self.themeList)
end
function NebulaAllStarGuessViewPanel:onMsgUpdateQuizCoin(...)
	self:updateCoin()
	if self.tag ~= 3 then
		return
	end
	self.shopList = self:getShopList()
	self.fields.List_shop:setNumItems(#self.shopList)
end
return NebulaAllStarGuessViewPanel

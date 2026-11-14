local activityTimeRead = include("activityTimeRead")
local activity_9001706_Read = include("activity_9001706_Read")
local activity_9001706_Ctrl = SoraDGetCtrl("activity_9001706_Ctrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local publicRead = include("publicRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001706_MainPanel = class("Activity_9001706_MainPanel", baseFguiPanel)
function Activity_9001706_MainPanel:ctor(...)
	self.isLRU = true
	Activity_9001706_MainPanel.super.ctor(self, ...)
	print("Activity_9001706_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.SULTAN_COIN_PRESENT_ACTIVITY
end
function Activity_9001706_MainPanel:onInit()
	print("=======Activity_9001706_MainPanel:onInit")
	self.fields.Com_bg:setGradientColor()
	local activityName = i18n(activityTimeRead.getActivityNameByID(self.activityID, SoraDGetActivityClassType(self.activityID)))
	self.fields.Com_title:initData(activityName, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Text_done:setString(i18n("Sultan_present_text_05"))
	self.fields.Text_done:setVisible(false)
	self.fields.bg_done:setVisible(false)
	self.fields.Button_go:setString(i18n("common_text_477"))
	self.fields.Button_go:addClickListener(handler(self, self.btnGoClick))
	self.fields.Button_receive:setString(i18n("common_text_1146"))
	self.fields.Button_receive:addClickListener(handler(self, self.btnReceiveClick))
	self.fields.Button_coin:getChild("Text_name"):setString(publicRead.getName(TOKEN_ITEM))
	self.fields.Text_tips:setString(i18n("Sultan_present_text_17"))
	self.fields.Text_tips:setVisible(false)
	self.fields.Label_cTime:setTimeLast(function(time)
		_ENV = nil
		;(nil).time = time
		return i18n("Sultan_present_text_20", nil)
	end)
	self.fields.Label_time:setTimeLast(function(time)
		_ENV = nil
		;(nil).time = time
		return i18n("Sultan_present_text_21", nil)
	end)
	self.fields.Label_time:setTimeEndListener(function()
		self:initView()
	end)
	self.fields.BoxList_person:setBarColor(3)
end
function Activity_9001706_MainPanel:endShow()
	print("=======Activity_9001706_MainPanel:endShow")
	local _ENV, stageData = print, print
	local stageCfg = activity_9001706_Read.getStageCfg()
	for __, cfg in ipairs(stageCfg) do
		_ENV = nil
		;(nil).stage = cfg.index
		;(nil).point = cfg.point
		activity_9001706_Ctrl = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		;(nil).rewards = serviceFunctions.tableFormat(cfg.reward, nil)
		table.insert(stageData, nil)
	end
	self.stageData = stageData
	_ENV = ipairs(stageCfg)
	ipairs(stageCfg).activityID = self.activityID
	ipairs(stageCfg).stageMax = #self.stageData
	ipairs(stageCfg).gap = 30
	self.fields.BoxList_person:initData(ipairs(stageCfg))
	self.curIndex = activity_9001706_Read.getServerIndex(activity_9001706_Ctrl:getPeopleNumber())
	local _ENV, stageDataSer = activity_9001706_Read.getServerIndex(activity_9001706_Ctrl:getPeopleNumber()), activity_9001706_Read.getServerIndex(activity_9001706_Ctrl:getPeopleNumber())
	local stageCfgSer = activity_9001706_Read.getServerCfg()
	for __, cfg in ipairs(stageCfgSer) do
		_ENV = activity_9001706_Ctrl:getPeopleNumber()
		activity_9001706_Ctrl:getPeopleNumber().stage = cfg.index
		activity_9001706_Ctrl:getPeopleNumber().point = cfg.num
		table.insert(stageDataSer, activity_9001706_Ctrl:getPeopleNumber())
	end
	_ENV = ipairs(stageCfgSer)
	ipairs(stageCfgSer).stageMax = #stageDataSer
	ipairs(stageCfgSer).stageData = stageDataSer
	ipairs(stageCfgSer).curIndex = self.curIndex
	ipairs(stageCfgSer).handler = handler(self, self.onClickSerIndex)
	self.fields.BoxList_server:initData(ipairs(stageCfgSer))
	self.tag = 1
	_ENV = ipairs(stageCfgSer)
	_ENV, _ENV, ipairs(stageCfgSer).defaultClick = self, self.tag, self.tag
	self.title = i18n("Sultan_present_text_02")
	_ENV, self.tag[1], self.tag = self, self, 1
	self.title = i18n("Sultan_present_text_03")
	ipairs(stageCfgSer).tabsetArray, self.tag[2], self.tag = self.tag, self, 2
	ipairs(stageCfgSer).callback = handler(self, self.onClickTab)
	self.fields.Com_title:initTab(ipairs(stageCfgSer))
end
function Activity_9001706_MainPanel:onClickTab(tag)
	self.tag = tag
	local index = self.tag - 1
	self.controllers.c1:setSelectedIndex(index)
	self.transitions["t" .. index]:play()
	self:initView()
end
function Activity_9001706_MainPanel:initView(target, data)
	SoraDCloseLoading(self)
	self.doStage = activityShowCtrl:getDoStageByID(self.activityID)
	self:setStageTime()
	for i = 1, 2 do
		local num = i == 1 and activity_9001706_Ctrl:getPersonRewardNum() or activity_9001706_Ctrl:getServerRewardNum()
		self.fields.Com_title:setBtnRedDot(i, 0 < num, num)
	end
	local costSultanCoin = activity_9001706_Ctrl:getCostSultanCoin()
	if self.tag == 1 then
		local coinCount = backpackCtrl:getItemCount(TOKEN_ITEM)
		self.fields.Button_coin:setTitle(string.formatnumberthousands(coinCount))
		_ENV = costSultanCoin
		costSultanCoin.color = "#FFDF2D"
		costSultanCoin.size = 28
		local cumuCoin = SoraDWrapHtmlTagByStyle(string.formatnumberthousands(costSultanCoin), costSultanCoin)
		_ENV = string.formatnumberthousands(coinCount)
		string.formatnumberthousands(coinCount).num = cumuCoin
		self.fields.Com_cumu:setTitle(i18n("Sultan_present_text_04", string.formatnumberthousands(coinCount)))
		self.fields.Text_done:setVisible(self.doStage == 1)
		self.fields.bg_done:setVisible(self.doStage == 1)
		self.fields.Button_go:setVisible(self.doStage == 0)
		for __, data in ipairs(self.stageData) do
			data.state = activity_9001706_Ctrl:getStageBoxStatues(data.stage, data.point)
		end
		_ENV = ipairs(self.stageData)
		ipairs(self.stageData).score = costSultanCoin
		ipairs(self.stageData).stageData = self.stageData
		ipairs(self.stageData).noAni = target and true or false
		self.fields.BoxList_person:updateData(ipairs(self.stageData))
		self.bonusList = activity_9001706_Read.getPersonalCfg()
		for i = 1, 6 do
			self.fields["bonus_" .. i]:initData(self.bonusList[i])
		end
	else
		self.fields.BoxList_server:setTouchEnabled(self.doStage == 0)
		local peopleNum = activity_9001706_Ctrl:getPeopleNumber()
		_ENV = target and true or false
		;(target and true or false).num = fguiHelper.getColorString("#FFDF2D", string.formatnumberthousands(peopleNum))
		self.fields.Text_joinNum:setString(i18n("Sultan_present_text_10", target and true or false))
		local showIndexCfg = activity_9001706_Read.getServerCfgByIndex(self.curIndex)
		self.fields.Com_free:initData(showIndexCfg)
		local month = activity_9001706_Ctrl:getCurMonth()
		if self.doStage == 0 then
			self.fields.Label_time:setVisible(false)
			self.fields.Label_cTime:setVisible(false)
			self.fields.Button_receive:setVisible(false)
			self.fields.Text_tips:setString(i18n("Sultan_present_text_17"))
			self.fields.Text_tips:setColor(cc.c3b(215, 195, 155))
			self.fields.Text_tips:setVisible(true)
			self.fields.Com_pay:setVisible(true)
			self.fields.Com_pay:initData(showIndexCfg)
		else
			local realIndex = activity_9001706_Read.getServerIndex(peopleNum, true)
			local day, isInPay = activity_9001706_Ctrl:getCurDay()
			if 0 < realIndex then
				local beginTime = activity_9001706_Ctrl:getActivityStageTime()
				local isClaimedFree = activity_9001706_Ctrl:isClaimedSerFreeReward(month)
				local isClaimedPay = activity_9001706_Ctrl:isClaimedSerPayReward(month)
				local isUnlock = activity_9001706_Ctrl:isPaySerUnlock(month)
				local isAllClaimed = isUnlock and isClaimedFree and isClaimedPay or not isInPay and isClaimedFree and not isUnlock
				local leftTime = serviceFunctions.getNextMonthDayTime(beginTime, month)
				local btnStr = i18n("common_text_1146")
				local colorIndex = gBtnColorDef.GREEN
				self.isContinue = false
				if isInPay and not isUnlock and isClaimedFree and not isClaimedPay then
					btnStr = i18n("cityUp_btn_01")
					colorIndex = gBtnColorDef.YELLOW
					self.isContinue = true
				end
				self.fields.Button_receive:setVisible(true)
				local isBeginMonth = activity_9001706_Ctrl:isBeginMonth()
				local isCanClaim = not isBeginMonth and (not isClaimedFree or isUnlock and not isClaimedPay)
				local isEnable = isCanClaim or isInPay and not isUnlock
				self.fields.Button_receive:setEnabled(isEnable)
				self.fields.Button_receive:setString(isAllClaimed and i18n("common_text_1892") or btnStr)
				self.fields.Button_receive:setBtnColorIndex(colorIndex)
				self.fields.Com_pay:initData(showIndexCfg)
				self.fields.Com_pay:setVisible(isBeginMonth or isUnlock or isInPay)
				if 0 < leftTime and not isCanClaim then
					if isBeginMonth then
						self.fields.Label_cTime:setVisible(true)
						self.fields.Label_cTime:beginTime(leftTime)
						self.fields.Label_time:setVisible(false)
						self.fields.Button_receive:setVisible(false)
					else
						self.fields.Label_cTime:setVisible(false)
						if month <= 5 and not isEnable then
							self.fields.Label_time:setVisible(true)
							self.fields.Label_time:beginTime(leftTime)
						else
							self.fields.Label_time:setVisible(false)
						end
					end
				else
					self.fields.Label_time:setVisible(false)
					self.fields.Label_cTime:setVisible(false)
				end
				self.fields.Text_tips:setVisible(false)
			else
				self.fields.Text_tips:setString(i18n("Sultan_present_text_19"))
				self.fields.Text_tips:setColor(cc.c3b(190, 40, 40))
				self.fields.Text_tips:setVisible(true)
				self.fields.Label_time:setVisible(false)
				self.fields.Label_cTime:setVisible(false)
				self.fields.Button_receive:setVisible(false)
				self.fields.Com_pay:setVisible(true)
				self.fields.Com_pay:initData(showIndexCfg)
			end
		end
	end
end
function Activity_9001706_MainPanel:setStageTime()
	if self.doStage == 0 then
		_ENV = nil
		;(nil).time = ""
		self.fields.Com_title:initSpecialActivityTimeNew(self.activityID, i18n("Sultan_present_text_13", nil))
	else
		_ENV = i18n("Sultan_present_text_13", nil)
		i18n("Sultan_present_text_13", nil).time = ""
		self.fields.Com_title:initSpecialActivityTimeNew(self.activityID, i18n("Sultan_present_text_14", i18n("Sultan_present_text_13", nil)))
	end
end
function Activity_9001706_MainPanel:onClickSerIndex(data)
	if self.doStage == 0 then
		SoraDPlaySound()
		self.curIndex = data.stage
		self:initView()
	end
end
function Activity_9001706_MainPanel:btnGoClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).itemID = TOKEN_ITEM
	uiManager:show("CommonSourceGuide", nil)
end
function Activity_9001706_MainPanel:btnReceiveClick()
	SoraDPlaySound()
	if self.isContinue then
		SoraDShowMsgTip(i18n("Sultan_present_text_12"))
	else
		SoraDShowLoading(self)
		activity_9001706_Ctrl:sendServerReward()
	end
end
function Activity_9001706_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("Sultan_present_text_01")
	uiManager:show("RuleView", nil)
end
return Activity_9001706_MainPanel

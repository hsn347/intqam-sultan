local allianceScience = SoraDGetCtrl("allianceScience")
local memberMgr = SoraDGetCtrl("memberMgr")
local constantRead = include("constantRead")
local allianceProsperityDonateView = class("allianceProsperityDonateView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("allianceProsperityDonateView")
	end
	return target
end)
function allianceProsperityDonateView:ctor()
	self.tableBtn, _UPVALUE0_ = nil, nil
	self.prePercent = 0
	self.needExitEffect = false
	self:initWidget()
	self:initData()
end
function allianceProsperityDonateView:initWidget()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("common_text_284"))
	self.Text_des = SoraDGetChildByName(self, "Text_des")
	local addValue = constantRead.getConstValue("ADD_PROSPERITY_EVERY_TIME", 10)
	_ENV = i18n("common_text_284")
	i18n("common_text_284").num = addValue
	SoraDGetChildByName(self, "Text_tips"):setString(i18n("alliance_prosperity_text_18", i18n("common_text_284")))
	self.Text_count = SoraDGetChildByName(self, "Text_count")
	self.Text_curPoint = SoraDGetChildByName(self, "Text_curPoint")
	self.LoadingBar_progress = SoraDGetChildByName(self, "LoadingBar_progress")
	self.Node_time = SoraDGetChildByName(self, "Node_time")
	self.Text_time = SoraDGetChildByName(self, "Text_time")
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	self.Text_time:setTimeEndListener(function()
		self:refreshTime()
	end)
	self.tableBtn = SoraDGetChildsArrayByName(self, "CCS_allianceProsperityDonateBtn_", 3, 1, true, false)
	for i, v in ipairs(self.tableBtn) do
		self.tableBtn[i] = SoraDCreatePanelByCloneNode(v, "allianceProsperityDonateBtn")
	end
	for i, v in ipairs(self.tableBtn) do
		v:setDonateType(i)
		v:setHandle(handler(self, self.donateBtnCallBack))
	end
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_PROSPERITY_REFRESH", handler(self, self.refreshView))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_PROSPERITY_CLEAN_CD", handler(self, self.cleanCDCallback))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_CONTRIBUTE_DOUBLE", handler(self, self.contributeEffect))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_PROSPERITY_CHANGE", handler(self, self.refreshProsperity))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_POPULARITY_CHANGE", handler(self, self.refreshPopularity))
end
function allianceProsperityDonateView:refreshView(target, data)
	SoraDCloseLoading(self)
	self:initData()
end
function allianceProsperityDonateView:cleanCDCallback(target, data)
	SoraDCloseLoading(self)
	self:refreshTime()
end
function allianceProsperityDonateView:initData()
	self:refreshProsperity()
	self:refreshPopularity()
	local remainCount = allianceScience:getProsperityRemainCount()
	local maxNum = constantRead.getConstValue("PROSPERITY_DONATE_MAX_NUM", 10)
	allianceScience = nil
	;(nil).num = remainCount
	;(nil).maxnum = maxNum
	self.Text_count:setString(i18n("alliance_prosperity_text_16", nil))
	for i, v in ipairs(self.tableBtn) do
		v:initData()
	end
	if remainCount <= 0 then
		for i, v in ipairs(self.tableBtn) do
			v:btnStateChange(false, true)
		end
	end
	self:refreshTime()
end
function allianceProsperityDonateView:refreshTime()
	self.isLock = allianceScience:isDonatePopularityLock()
	if self.isLock then
		self.Text_time:setColor(display.COLOR_RED)
	else
		self.Text_time:setColor(cc.c3b(105, 179, 229))
	end
	self.Node_time:setVisible(false)
	local remianTime = allianceScience:getDonatePopularityRemainTime()
	if 0 < remianTime then
		self.Text_time:beginTime(remianTime)
		self.Node_time:setVisible(true)
	end
end
function allianceProsperityDonateView:donateBtnCallBack(id, donateType)
	local jointime = memberMgr:getOwnMember():getProperty("joinTime")
	local curtime = serviceFunctions.systemTime()
	local needtime = constantRead.getConstValue("ALLIANCE_PROSPERITY_DONATE_TIME", 14400)
	if needtime >= curtime - jointime then
		SoraDShowMsgTip(i18n("alliance_prosperity_text_17"))
		return
	end
	if self.isLock then
		memberMgr = "common_text_656"
		;("common_text_656").speedUpName = i18n("common_text_655")
		;("common_text_656").isBySelf = false
		;("common_text_656").isAllianceTech = true
		;("common_text_656").timeHandler = function()
			return self.Text_time.timeNumber
		end
		local speedUpBox = SoraDShowSpeedUpBox(nil, handler(self, self.speedUpCallBack), i18n("common_text_656"), "common_text_656")
	elseif self.isLock == false then
		SoraDShowLoading(self)
		for i, v in ipairs(self.tableBtn) do
			v:btnStateChange(false, true)
		end
		allianceScience:reqDonatePopularity(donateType)
	end
end
function allianceProsperityDonateView:speedUpCallBack(type)
	if type == MSGBOX_CALLBACK_SPEEDUP then
		allianceScience:reqCleanDonatePopularityCD()
		SoraDShowLoading(self)
	end
end
function allianceProsperityDonateView:contributeEffect(target, data)
	local effectUI = include("effectUI")
	local bType = data.bType
	effectUI.addAllianceScienceContributeEffect(self)
	effectUI.addAllianceScienceRunDoubleAnimation(self, bType)
end
function allianceProsperityDonateView:refreshProsperity(target, data)
	local prosperity = allianceScience:getProsperity()
	allianceScience = nil
	;(nil).num = string.formatnumberthousands(prosperity)
	self.Text_des:setString(i18n("alliance_prosperity_text_14", nil))
end
function allianceProsperityDonateView:refreshPopularity(target, data)
	local percent = allianceScience:getPopularity() / 100
	self.LoadingBar_progress:setPercent(percent)
	allianceScience = nil
	;(nil).value = percent
	self.Text_curPoint:setString(i18n("alliance_prosperity_text_15", nil))
	if percent >= self.prePercent then
		self.prePercent = percent
	else
		self.needExitEffect = true
	end
end
function allianceProsperityDonateView:onExitPanel()
	if self.needExitEffect then
		_ENV = nil
		;(nil).msg = "MESSAGE_ALLIANCE_POPULARITY_FULL"
		SoraDSendMessage(nil)
	end
end
return allianceProsperityDonateView

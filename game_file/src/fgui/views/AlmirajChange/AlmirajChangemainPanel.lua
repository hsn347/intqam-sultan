local mirajChallengeCtrl = SoraDGetCtrl("mirajChallengeCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local almirjchangeRead = include("almirjchangeRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local AlmirajChangemainPanel = class("AlmirajChangemainPanel", baseFguiPanel)
function AlmirajChangemainPanel:ctor(...)
	self.super.ctor(self, ...)
	print("AlmirajChangemainPanel:ctor", self.viewName)
end
function AlmirajChangemainPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function AlmirajChangemainPanel:onInit()
	self.activityID = gActivityTimeActivityID.MIRAJ_CHALLENGE_ACTIVITY
	print("=======AlmirajChangemainPanel:onInit")
	self.fields.Com_title:initData(i18n("activity_name_9001412"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Btn_reward:setString(i18n("anniversary_fire_text_16"))
	self.fields.Btn_reward:addClickListener(handler(self, self.onRewardClick))
	self.fields.Btn_call:addClickListener(handler(self, self.onCallClick))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Btn_reward:fixPos()
	self.fields.Bar:setScaleX(SoraDFIsRA() and -1 or 1)
	self.fields.n20:fixPos()
	self.fields.n21:fixPos()
	self.fields.Text_times:fixPos()
	self.fields.Text_percent:fixPos()
	self.fields.n29:fixPos()
	self.fields.n23:fixPos()
end
function AlmirajChangemainPanel:onShow()
	print("=======AlmirajChangemainPanel:onShow")
	self.fields.timer:setTimeLast(function(timeStr)
		_ENV = nil
		;(nil).time = fguiHelper.getColorString("#FFFFFF", timeStr)
		return i18n("common_text_4481", nil)
	end)
	local timeInfo = activityShowCtrl:getTimeInfoByID(self.activityID)
	if timeInfo then
		local leftTime = timeInfo.timerNode.timer:getRemainTime()
		self.fields.timer:beginTime(leftTime)
	end
	local param = activityShowCtrl:getParamByID(self.activityID)
	self.classtype = param.classtype or 1
	self.changeCfg = almirjchangeRead.getChangeCfg(self.classtype)
	almirjchangeRead = leftTime
	leftTime[1] = "point"
	leftTime[2] = "times"
	self.listData, _ENV, self.pointCfg = serviceFunctions.tableFormat(self.changeCfg.summonIntegral, leftTime), serviceFunctions.tableFormat(self.changeCfg.summonIntegral, leftTime), serviceFunctions.tableFormat(self.changeCfg.summonIntegral, leftTime)
	_ENV = leftTime
	leftTime.cfg = self.changeCfg.soldier
	leftTime.cType = 1
	table.insert(self.listData, leftTime)
	_ENV = leftTime
	leftTime.cfg = self.changeCfg.upBuild
	leftTime.cType = 2
	table.insert(self.listData, leftTime)
	_ENV = leftTime
	leftTime.cfg = self.changeCfg.killMonster
	leftTime.cType = 3
	table.insert(self.listData, leftTime)
	self:initData()
end
function AlmirajChangemainPanel:onHide()
	print("=======AlmirajChangemainPanel:onHide")
end
function AlmirajChangemainPanel:onDispose()
	print("=======AlmirajChangemainPanel:onDispose")
end
function AlmirajChangemainPanel:onItemRenderer(index, obj)
	obj:initData(self.listData[index + 1])
end
function AlmirajChangemainPanel:getMaxPoint()
	return self.pointCfg[#self.pointCfg].point
end
function AlmirajChangemainPanel:getNextPoint(point)
	for k, v in ipairs(self.pointCfg) do
		if point < v.point then
			return v.point
		end
	end
	return self.pointCfg[1].point
end
function AlmirajChangemainPanel:getPointTimes(point)
	local times = 0
	for k, v in ipairs(self.pointCfg) do
		if point >= v.point then
			times = times + v.times
		end
	end
	return times
end
function AlmirajChangemainPanel:getAllCallTimes()
	local times = 0
	for k, v in ipairs(self.pointCfg) do
		times = times + v.times
	end
	return times
end
function AlmirajChangemainPanel:getCurPointTimes(point)
	for k, v in ipairs(self.pointCfg) do
		if point < v.point then
			return v.times
		end
	end
	return 0
end
function AlmirajChangemainPanel:initData()
	local isHaveReward = mirajChallengeCtrl:getUnClaimRewardNum() > 0
	self.fields.Btn_reward:setRedVisible(isHaveReward)
	self.fields.List:setNumItems(#self.listData)
	local myPoint = mirajChallengeCtrl:getPoint()
	local nextPoint = self:getNextPoint(myPoint)
	self.isHaveBoss = mirajChallengeCtrl:isHaveBoss()
	local summonGetCount = mirajChallengeCtrl:getSummonGetCount()
	local summonCostCount = mirajChallengeCtrl:getSummonCostCount()
	local maxKillCount = self:getPointTimes(myPoint)
	local curTimes = self:getCurPointTimes(myPoint)
	if myPoint >= self:getMaxPoint() then
		self.fields.n29:setVisible(false)
		self.fields.Text_percent:setString(i18n("hero_text_41"))
		self.fields.Bar:setPercent(100)
	else
		self.fields.n29:setVisible(true)
		mirajChallengeCtrl = i18n("hero_text_41")
		i18n("hero_text_41").member = fguiHelper.getColorString("#FFDF2D", string.formatnumberthousands(myPoint))
		i18n("hero_text_41").total = string.formatnumberthousands(nextPoint)
		self.fields.Text_percent:setString(i18n("common_text_155", i18n("hero_text_41")))
		self.fields.Bar:setMax(nextPoint)
		self.fields.Bar:setValue(myPoint)
	end
	if 0 < summonGetCount and summonGetCount > summonCostCount then
		self.fields.Text_times:setString(math.min(summonGetCount - summonCostCount, maxKillCount))
	else
		self.fields.Text_times:setString(0)
	end
	if self.isHaveBoss then
		self.fields.Btn_call:setEnabled(true)
		self.fields.Btn_call:setString(i18n("common_text_477"))
	else
		self.fields.Btn_call:setString(i18n("almirajChange_text15"))
		if mirajChallengeCtrl:getSummonCostCount() >= self:getAllCallTimes() then
			self.fields.Btn_call:setEnabled(false)
			mirajChallengeCtrl = false
			;(false).visible = false
			;(false).num = 0
			self.fields.Btn_call:setRedDot(false)
		else
			self.fields.Btn_call:setEnabled(true)
			if 0 < summonGetCount and summonGetCount > summonCostCount and not self.isHaveBoss then
				mirajChallengeCtrl = true
				;(true).visible = true
				;(true).num = 0
				self.fields.Btn_call:setRedDot(true)
			else
				mirajChallengeCtrl = true
				;(true).visible = false
				;(true).num = 0
				self.fields.Btn_call:setRedDot(true)
			end
		end
	end
end
function AlmirajChangemainPanel:onCallClick()
	SoraDPlaySound()
	if allianceMgr:hasJoinAlliance() then
		if self.isHaveBoss then
			mirajChallengeCtrl:jumpToBoss()
		else
			local summonGetCount = mirajChallengeCtrl:getSummonGetCount()
			local summonCostCount = mirajChallengeCtrl:getSummonCostCount()
			if summonCostCount < self:getAllCallTimes() then
				if 0 < summonGetCount and summonGetCount > summonCostCount then
					mirajChallengeCtrl:sendPutBoss()
				else
					SoraDShowMsgTip(i18n("almirajChange_text13"))
				end
			else
				SoraDShowMsgTip(i18n("notice_0026"))
			end
		end
	else
		SoraDShowMsgTip(i18n("tips_place_noUnion"))
	end
end
function AlmirajChangemainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("almirajChange_text14")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function AlmirajChangemainPanel:onRewardClick()
	SoraDPlaySound()
	uiManager:show("AlmirajTreasure")
end
return AlmirajChangemainPanel

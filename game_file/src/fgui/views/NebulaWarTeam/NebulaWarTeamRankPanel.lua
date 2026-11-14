local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local nebulaWarUtil = include("nebulaWarUtil")
local teamDef = include("teamDef")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaWarTeamRankPanel = class("NebulaWarTeamRankPanel", baseFguiPanel)
_ENV = "NebulaWarTeamRankPanel"
;("NebulaWarTeamRankPanel").TYPE_JOIN = 1
;("NebulaWarTeamRankPanel").TYPE_SEARCH = 2
local ("NebulaWarTeamRankPanel").TYPE_RANK, VIEW_TYPE = 3, "NebulaWarTeamRankPanel"
function NebulaWarTeamRankPanel:ctor(...)
	NebulaWarTeamRankPanel.super.ctor(self, ...)
	print("NebulaWarTeamRankPanel:ctor", self.viewName)
	self.myTeamInfo = nebulaActivityCtrl:getMyTeamInfo()
	self.nCount = 10
	self:retsetRankData()
end
function NebulaWarTeamRankPanel:onInit()
	print("=======NebulaWarTeamRankPanel:onInit")
	self.fields.Com_title:initData(i18n("remains_btn_01"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.justLook = self.param and self.param.justLook
	if self.justLook then
		self.fields.Com_title:setTitle(i18n("nebula_war_text_0307"))
	end
	self.fields.Text_notice:setString(i18n("common_text_927"))
	self.fields.List_team:setItemRenderer(handler(self, self.onTeamItemRederer))
	self.fields.List_team:setVirtual()
	self.fields.List_team:addEventListener(fgui.UIEventType.PullUpRelease, handler(self, self.onPullUpRelease))
	self.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
	self.Text_time:setTimeLast(function(timeStr)
		_ENV = nil
		_ENV, _ENV, (nil).time = nil, nil, timeStr
		;(nil).time, (nil).color = nil, "#F0E6D2"
		return i18n_html("nebula_war_text_0602", nil, nil)
	end)
	self.Text_time:setTimeEndListener(function()
		self.Text_time:setString(i18n("nebula_war_text_0603"))
	end)
	_ENV = self.Text_time.setTimeEndListener
	_ENV, _ENV, self.Text_time.setTimeEndListener.defaultClick = function()
		self.Text_time:setString(i18n("nebula_war_text_0603"))
	end, VIEW_TYPE.TYPE_RANK, VIEW_TYPE.TYPE_RANK
	_ENV, VIEW_TYPE.TYPE_RANK[1], (function()
		self.Text_time:setString(i18n("nebula_war_text_0603"))
	end).title = function()
		self.Text_time:setString(i18n("nebula_war_text_0603"))
	end, function()
		self.Text_time:setString(i18n("nebula_war_text_0603"))
	end, i18n("common_text_829")
	_ENV, VIEW_TYPE.TYPE_RANK[2], (function()
		self.Text_time:setString(i18n("nebula_war_text_0603"))
	end).title = function()
		self.Text_time:setString(i18n("nebula_war_text_0603"))
	end, function()
		self.Text_time:setString(i18n("nebula_war_text_0603"))
	end, i18n("common_text_166")
	self.Text_time.setTimeEndListener.tabsetArray, VIEW_TYPE.TYPE_RANK[3], (function()
		self.Text_time:setString(i18n("nebula_war_text_0603"))
	end).title = VIEW_TYPE.TYPE_RANK, function()
		self.Text_time:setString(i18n("nebula_war_text_0603"))
	end, i18n("nebula_war_text_0605")
	local self.Text_time.setTimeEndListener.callback, param = handler(self, self.onClickTab), self.Text_time.setTimeEndListener
	self.fields.com_Tab:initView(param)
end
function NebulaWarTeamRankPanel:onShow()
	print("=======NebulaWarTeamRankPanel:onShow")
	self.isSignUpState = nebulaWarUtil.checkSuperTeamSignUpState()
	self:updateTextTime()
	self:req4Data()
end
function NebulaWarTeamRankPanel:retsetRankData(...)
	self.iBegin = 1
	self.teamList, _UPVALUE0_, self.hasMore = nil, nil, true
end
function NebulaWarTeamRankPanel:onClickHelp(...)
	SoraDPlaySound()
	_ENV = nil
	;(nil).title = i18n("Payment_activity_optimization_text_09")
	;(nil).content = i18n("nebula_war_text_0604")
	uiManager:show("RuleView", nil)
end
function NebulaWarTeamRankPanel:onTeamItemRederer(index, obj)
	local teamData = self.teamList[index + 1]
	_UPVALUE0_ = nil
	;(nil).justLook = self.justLook
	;(nil).isLockFc = not self.isSignUpState
	obj:initData(teamData, nil)
end
function NebulaWarTeamRankPanel:onPullUpRelease(...)
	if self.hasMore then
		self:req4Data()
	end
end
function NebulaWarTeamRankPanel:req4Data(...)
	self.myTeamInfo:reqSignSuperTeamRank(self.iBegin, self.nCount)
	SoraDShowLoading(self:displayObject())
end
function NebulaWarTeamRankPanel:onMsgSuperTeamFcRankBack(target, event)
	SoraDCloseLoading(self:displayObject())
	if not event.rspdata then
		local _ENV, rspdata = event.rspdata, event.rspdata
	end
	if not rspdata.rankData then
		local _ENV, teamList = rspdata.rankData, rspdata.rankData
	end
	local total = rspdata.total or 0
	local addCount = #teamList
	self.iBegin = self.iBegin + addCount
	if total < self.iBegin then
		self.hasMore = false
	end
	for i, team in ipairs(teamList) do
		if next(team) then
			local memberCount = table.nums(team.memberList)
			team.memberCount = memberCount
			team.totalFc = teamDef.getTeamTotalFcLock(team)
			team.isSuperTeam = teamDef.getIsSuperTeam(team)
			table.insert(self.teamList, team)
		end
	end
	self.fields.List_team:setNumItems(#self.teamList)
	self.fields.Text_notice:setVisible(0 >= #self.teamList)
end
function NebulaWarTeamRankPanel:updateState(...)
	local isSignUpState = nebulaWarUtil.checkSuperTeamSignUpState()
	if self.isSignUpState == isSignUpState then
		return
	end
	self.isSignUpState = isSignUpState
	self:updateTextTime()
	self:resetRankAndReqData()
end
function NebulaWarTeamRankPanel:resetRankAndReqData(...)
	self.fields.List_team:setNumItems(0)
	self:retsetRankData()
	self:req4Data()
end
function NebulaWarTeamRankPanel:updateTextTime(...)
	if self.isSignUpState then
		local remainTime = nebulaWarUtil.getSuperTeamSignUpRemainTime()
		self.Text_time:beginTime(remainTime)
	else
		self.Text_time:endTime()
	end
end
function NebulaWarTeamRankPanel:onClickTab(tag)
	if tag ~= VIEW_TYPE.TYPE_RANK then
		local justLook = self.justLook
		self:closePanel()
		VIEW_TYPE = nil
		;(nil).defaultClick = tag
		;(nil).justLook = justLook
		uiManager:show("NebulaWarTeamJoin", nil)
		return
	end
end
return NebulaWarTeamRankPanel

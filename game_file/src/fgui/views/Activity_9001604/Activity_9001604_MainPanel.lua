local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001604_MainPanel = class("Activity_9001604_MainPanel", baseFguiPanel)
local activity_9001604_Ctrl = SoraDGetCtrl("activity_9001604_Ctrl")
local activity_9001604_Read = include("activity_9001604_Read")
local eventQuestRead = include("eventQuestRead")
local constantRead = include("constantRead")
local STATUS = activity_9001604_Ctrl.STATUS
_ENV = nil
;(nil).ALLIANCE_RANK = 0
;(nil).MEMBER_RANK = 1
local (nil).TASK, TAB_INDEX = 2, nil
local TASK_STATE = activity_9001604_Ctrl.RAMADAN_MOBILIZE_TASK_STATE
function Activity_9001604_MainPanel:ctor(...)
	Activity_9001604_MainPanel.super.ctor(self, ...)
	self.debug = true
	self.activityID = gActivityTimeActivityID.FESTIVAL_ACTIVITY_9001604
	print("Activity_9001604_MainPanel:ctor", self.viewName)
end
function Activity_9001604_MainPanel:onInit()
	self.view:fixChildrenPos()
	print("=======Activity_9001604_MainPanel:onInit")
	self.fields.Com_title:initData(i18n("activity_name_9001604"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Com_title:initCommonActivityTime(self.activityID)
	self.tabIndex = 2
	_ENV = self.activityID
	_ENV, _ENV, self.activityID.defaultClick = handler(self, self.onClickHelp)
	handler(self, self.onClickHelp).title = i18n("common_text_1153")
	_ENV, self.tabIndex[3], handler(self, self.onClickHelp).tag = handler(self, self.onClickHelp)
	handler(self, self.onClickHelp).title = i18n("alliance_mobilize_text_05")
	_ENV, self.tabIndex[2], handler(self, self.onClickHelp).tag = handler(self, self.onClickHelp)
	handler(self, self.onClickHelp).title = i18n("alliance_mobilize_text_04")
	self.activityID.tabsetArray, self.tabIndex[1], handler(self, self.onClickHelp).tag = self.tabIndex, handler(self, self.onClickHelp)
	self.activityID.callback = handler(self, self.onClickTab)
	self.fields.Com_tab:initView(self.activityID)
	self.fields.Label_time:initActivityTime(self.activityID)
	self.fields.txt_score:setString(i18n("common_text_1764"))
	self.fields.txt_score2:setString(i18n("common_text_1764"))
	self.fields.txt_name:setString(i18n("common_text_264"))
	self.fields.txt_rank:setString(i18n("common_text_3154"))
	self.fields.txt_quest:setString(i18n("Ramadan_League_text_17"))
	self.refreshTime = constantRead.getConstValue("RAMADAN_MOBILIZE_TASK_REFRESH", 1800)
	self.questLimit = constantRead.getConstValue("RAMADAN_MOBILIZE_TASK_LIMIT", 8)
	self.text_showTip = SoraDCreateTimerLabel(self, self.fields.text_showTip)
	self.text_showTip:setTimeLast(function(time)
		_ENV = nil
		;(nil).time = time
		return i18n("Ramadan_League_text_24", nil)
	end)
	self.fields.List_alliance_rank:setVirtual()
	self.fields.List_alliance_rank:setItemRenderer(handler(self, self.onAllianceRankRenderer))
	self.fields.List_member_rank:setVirtual()
	self.fields.List_member_rank:setItemRenderer(handler(self, self.onMemberRankRenderer))
	self.fields.List_task:setVirtual()
	self.fields.List_task:setItemRenderer(handler(self, self.onTaskRenderer))
	self.fields.btn_reward:setTitle(i18n("soldier_rush_text_11"))
	self.fields.btn_reward:addClickEventListener(handler(self, self.onRewardClick))
	self.fields.btn_reward1:addClickEventListener(handler(self, self.onRewardClick))
	self.fields.Text_noData:setString(i18n("herobattle_text_05"))
	self.status = activity_9001604_Ctrl:getActivityStage()
	activity_9001604_Ctrl = activity_9001604_Ctrl
	activity_9001604_Ctrl[1] = self.status
	activity_9001604_Ctrl[2] = STATUS.OPEN
	activity_9001604_Ctrl[3] = STATUS.SHOW
	dump(activity_9001604_Ctrl, "activity_9001604_Ctrl:getActivityStage")
	if self.status == STATUS.OPEN or self.status == STATUS.SHOW then
		activity_9001604_Ctrl:sendReqInitDataMsg()
	end
end
function Activity_9001604_MainPanel:onShow()
	print("=======Activity_9001604_MainPanel:onShow")
	self:updateView()
end
function Activity_9001604_MainPanel:onClickTab(index)
	print("index====", index)
	if self.status == STATUS.PREPARE or self.status == STATUS.DATA_PREPARE then
		self.fields.Com_tab.curTab = 2
		self.fields.Com_tab:setToTag(1)
		return true
	end
	if self.tabIndex == index then
		return
	end
	self.tabIndex = index
	if self.tabIndex == TAB_INDEX.ALLIANCE_RANK then
		self.allianceRankList = nil
		SoraDShowLoading(self:displayObject())
		activity_9001604_Ctrl:reqAllianceRank()
	elseif self.tabIndex == TAB_INDEX.MEMBER_RANK then
		self.memberRankList = nil
		SoraDShowLoading(self:displayObject())
		activity_9001604_Ctrl:reqMemberRank()
	end
	self:updateView()
end
function Activity_9001604_MainPanel:updateView()
	local red, redNum = activity_9001604_Ctrl:getReceiveStatusAndNum()
	self.fields.Com_tab:setBtnRedDot(1, red, redNum)
	self.status = activity_9001604_Ctrl:getActivityStage()
	if self.status == STATUS.PREPARE or self.status == STATUS.DATA_PREPARE then
		self:updatePrepareView()
		return
	end
	self.initAid = activity_9001604_Ctrl:getInitAid()
	if self.initAid == 0 or self.initAid == -1 or self.initAid == nil then
		self:close()
		return
	end
	self.controllers.c1:setSelectedIndex(self.tabIndex)
	if self.tabIndex == TAB_INDEX.TASK then
		self:updateTaskView()
	end
	if self.tabIndex == TAB_INDEX.ALLIANCE_RANK then
		self:updateAllianceRank()
	end
	if self.tabIndex == TAB_INDEX.MEMBER_RANK then
		self:updateMemberRank()
	end
end
function Activity_9001604_MainPanel:updatePrepareView()
	self.fields.Com_title:setTimeShow(false)
	self.controllers.c1:setSelectedIndex(3)
	self.fields.txt_timeDes:setString(i18n("Ramadan_League_text_15"))
	if self.status == STATUS.PREPARE then
		self.fields.Text_desc:setString(i18n("Ramadan_League_text_05"))
		self.timeLabel = SoraDCreateTimerLabel(self, self.fields.Text_time)
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		local activityData = activityShowCtrl:getActivityData(self.activityID)
		local endtime = activityData.begintime - serviceFunctions.systemTime()
		if endtime then
			self.timeLabel:beginTime(endtime)
		end
	else
		self.fields.Text_desc:setString(i18n("Ramadan_League_text_23"))
		self.timeLabel = SoraDCreateTimerLabel(self, self.fields.Text_time)
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		local activityData = activityShowCtrl:getActivityData(self.activityID)
		local endtime = activityData.stagetimes[1] and activityData.stagetimes[1] - serviceFunctions.systemTime() or 0
		if endtime then
			self.timeLabel:beginTime(endtime)
		end
	end
end
function Activity_9001604_MainPanel:updateTaskView()
	local gametop = gModuleMgr.getObject("gametop")
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	local ownmember = memberMgr:getOwnMember()
	local ownRank = ownmember:getProperty("rank")
	local isRankR4 = ownRank >= gAllianceRank.R4
	self.ownRank = ownRank
	local lastQuestCount = self.questLimit - activity_9001604_Ctrl:getQuestCount()
	_ENV = nil
	_ENV, _ENV, (nil).num = nil, nil, lastQuestCount
	;(nil).num, (nil).color = nil, "#ffd43e"
	self.fields.Com_taskTitle:setTitle(i18n_html("Ramadan_League_text_06", nil, nil))
	local curScore = activity_9001604_Ctrl:getAllianceScore()
	local lvCfg, isMax, lastScore = activity_9001604_Read.getLvCfgByScore(curScore)
	self.fields.Progress_score:setMax(lvCfg.score)
	self.fields.Progress_score:setValue(lastScore)
	self.fields.Text_curLevel:setString(isMax and lvCfg.stage or lvCfg.stage - 1)
	if self.status == STATUS.SHOW then
		self.fields.Com_title:setTimeShow(false)
		self.fields.List_task:setVisible(false)
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		local eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
		if eventTime then
			self.fields.text_showTip:setVisible(true)
			self.fields.text_showTip:beginTime(eventTime.timerNode.timer:getRemainTime())
		end
		return
	end
	self.fields.text_showTip:setVisible(true)
	local tmpTaskList = activity_9001604_Ctrl:getTaskList()
	self.taskList, _ENV = activity_9001604_Ctrl, activity_9001604_Ctrl
	local myTaskID = activity_9001604_Ctrl:getMyTaskID()
	local createTaskData = function(taskID, state, t, taskIdx)
		local questInfo = eventQuestRead.getTaskConfig(taskID)
		local task = clone(questInfo)
		task.taskID = taskID
		task.taskIdx = taskIdx
		task.state = state
		task.time = t
		task.award = task.reward
		task.taskName = activity_9001604_Read.getTaskName(taskID)
		task.taskIcon = activity_9001604_Read.getTaskIcon(taskID)
		task.taskScore = activity_9001604_Read.getTaskScore(taskID)
		task.activityID = self.activityID
		task.progress = activity_9001604_Ctrl:getTaskProgress(taskID)
		task.isRankR4 = isRankR4
		return task
	end
	dump(activity_9001604_Read.getTaskLimitTime(myTaskID), "activity_9001604_Read.getTaskLimitTime(myTaskID)")
	if myTaskID ~= nil and myTaskID ~= 0 then
		self.taskList[1] = createTaskData(myTaskID, TASK_STATE.ACCEPT, activity_9001604_Ctrl:getMyTaskTime() + activity_9001604_Read.getTaskLimitTime(myTaskID))
		self.taskList[1].isMy = true
	else
		_ENV = createTaskData(myTaskID, TASK_STATE.ACCEPT, activity_9001604_Ctrl:getMyTaskTime() + activity_9001604_Read.getTaskLimitTime(myTaskID))
		createTaskData(myTaskID, TASK_STATE.ACCEPT, activity_9001604_Ctrl:getMyTaskTime() + activity_9001604_Read.getTaskLimitTime(myTaskID)).isEmpty = true
		self.taskList[1], createTaskData(myTaskID, TASK_STATE.ACCEPT, activity_9001604_Ctrl:getMyTaskTime() + activity_9001604_Read.getTaskLimitTime(myTaskID)).isMy = createTaskData(myTaskID, TASK_STATE.ACCEPT, activity_9001604_Ctrl:getMyTaskTime() + activity_9001604_Read.getTaskLimitTime(myTaskID)), true
	end
	for i, v in ipairs(tmpTaskList) do
		local task = createTaskData(v.taskId, v.state, v.t + self.refreshTime, i)
		table.insert(self.taskList, task)
	end
	self.fields.List_task:setNumItems(#self.taskList)
end
function Activity_9001604_MainPanel:updateAllianceRank()
	self.fields.Com_title:setTimeShow(false)
	if not self.allianceRankList then
		local _ENV, rankList = self.allianceRankList, self.allianceRankList
	end
	self.fields.List_alliance_rank:setNumItems(#rankList)
	self.fields.Text_noData:setVisible(#rankList == 0)
	local data = self.myAllianceData
	self.fields.Com_alliance_myRank:setVisible(data ~= nil and next(data) ~= nil)
	if data ~= nil and next(data) ~= nil then
		_ENV = data
		data.index = data.rank or 0
		data.bootom = 1
		data.kid = data.kid
		self.fields.Com_alliance_myRank:initData(data, data)
	end
end
function Activity_9001604_MainPanel:updateMemberRank()
	self.fields.Com_title:setTimeShow(false)
	if not self.memberRankList then
		local _ENV, rankList = self.memberRankList, self.memberRankList
	end
	self.fields.List_member_rank:setNumItems(#rankList)
	self.fields.Text_noData:setVisible(#rankList == 0)
	local data = self.myMemberData
	self.fields.Com_member_myRank:setVisible(data ~= nil and next(data) ~= nil)
	if data ~= nil and next(data) ~= nil then
		_ENV = data
		data.index = data.rank or 0
		data.questLimit = self.questLimit
		data.bootom = 1
		data.kid = data.kid
		self.fields.Com_member_myRank:initData(data, data)
	end
end
function Activity_9001604_MainPanel:onAllianceRankRenderer(index, obj)
	local rank = index + 1
	local data = self.allianceRankList[rank]
	_UPVALUE0_ = nil
	;(nil).index = rank
	;(nil).kid = data.kid
	obj:initData(data, nil)
end
function Activity_9001604_MainPanel:onMemberRankRenderer(index, obj)
	local rank = index + 1
	local data = self.memberRankList[rank]
	dump(self.questLimit, "self.questLimit")
	_ENV = nil
	;(nil).index = rank
	;(nil).kid = data.kid
	;(nil).questLimit = self.questLimit
	obj:initData(data, nil)
end
function Activity_9001604_MainPanel:onTaskRenderer(index, obj)
	local data = self.taskList[index + 1]
	obj:initData(data)
end
function Activity_9001604_MainPanel:onClickHelp(...)
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("Ramadan_League_text_05")
	uiManager:show("RuleView", nil)
end
function Activity_9001604_MainPanel:onMsgUpdateRank(target, event)
	SoraDCloseLoading(self:displayObject())
	if not event.rspdata then
		local _ENV, rspdata = event.rspdata, event.rspdata
	end
	local myInfo = rspdata.myInfo
	if not rspdata.rankList then
		local _ENV, rankList = rspdata.rankList, rspdata.rankList
	end
	if event.Type == "Alliance" then
		self.allianceRankList = rankList
		self.myAllianceData = myInfo
	else
		if myInfo == nil then
			local gametop = gModuleMgr.getObject("gametop")
			local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
			local lordInfo = lordInfoCtrl:getLordInfo()
			_ENV = lordInfoCtrl
			lordInfoCtrl.allianceRank = self.ownRank
			lordInfoCtrl.avatar = lordInfo.base.avatar
			lordInfoCtrl.commitCount = activity_9001604_Ctrl:getQuestCount()
			lordInfoCtrl.headid = lordInfo.base.imageId
			lordInfoCtrl.nickName = lordInfo.base.nickName
			lordInfoCtrl.rank = 0
			lordInfoCtrl.score = 0
			myInfo, lordInfoCtrl.uid = lordInfoCtrl, lordInfo.base.uid
		end
		self.memberRankList = rankList
		self.myMemberData = myInfo
	end
	_UPVALUE2_ = gametop.playertop_:getModule("lordInfoCtrl")
	gametop.playertop_:getModule("lordInfoCtrl")[1] = myInfo
	gametop.playertop_:getModule("lordInfoCtrl")[2] = self.myMemberData
	dump(gametop.playertop_:getModule("lordInfoCtrl"), "Activity_9001604_MainPanel:onMsgUpdateRank")
	self:updateView()
end
function Activity_9001604_MainPanel:onRewardClick()
	SoraDPlaySound()
	uiManager:show("Activity_9001604_Reward")
end
return Activity_9001604_MainPanel

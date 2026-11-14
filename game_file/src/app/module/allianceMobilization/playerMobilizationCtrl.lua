local gamemodulec = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local playerMobilizationCtrl = class("playerMobilizationCtrl", gamemodulec)
local mobilizationltCtrl = gModuleMgr.sharedMgr("mobilizationltCtrl")
local timerList = gModuleMgr.getObject("timerList")
function playerMobilizationCtrl:ctor(properties)
	playerMobilizationCtrl.super.ctor(self, properties)
	self:resetData()
end
function playerMobilizationCtrl:Logout()
	playerMobilizationCtrl.super.Logout(self)
	self:resetData()
end
function playerMobilizationCtrl:resetData()
	self.groupRankInfo, _UPVALUE0_, self.allianceRankInfo, _UPVALUE0_, self.alliancemissionInfo, _UPVALUE0_, self.activityStatus, _UPVALUE0_, self.mobiAliStatus, _UPVALUE0_, self.personalMissionData, _UPVALUE0_ = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
end
function playerMobilizationCtrl:getReceiveStatusAndNum()
	local num, showNum = self:isHaveActived()
	return 0 < num, showNum
end
function playerMobilizationCtrl:isHaveActived()
	local num = 0
	if self.activityStatus then
		local status = self.activityStatus.status or gMobilizationActivityStatus.ACTIVITY_CLOSE
		if gMobilizationActivityStatus.ACTIVITY_OPEN == status and gMobilizationAliStatus.STATUS_NORMAL == self:getUserMobiAliStatus() then
			if not self.personalMissionData or not self.personalMissionData.missionset then
				local _ENV, missionset = self.personalMissionData.missionset, self.personalMissionData.missionset
			end
			for k, v in pairs(missionset) do
				if v.taskstatus == gMobilizationTaskStatus.TASK_STATUS_COMPLETE then
					num = num + 1
				end
			end
			if num == 0 then
				_ENV = pairs(missionset)
				pairs(missionset).byUID = true
				local ret = SoraDConfigGet("Game:alliance:mobilization~bool", pairs(missionset))
				return ret and 0 or 1, -1
			end
		end
	end
	return num, num
end
function playerMobilizationCtrl:getPersonalMissionData()
	return self.personalMissionData
end
function playerMobilizationCtrl:getAllianceMobiInfo()
	return self.alliancemissionInfo
end
function playerMobilizationCtrl:getUserMobiAliStatus()
	return self.mobiAliStatus
end
function playerMobilizationCtrl:getActivityStatus()
	return self.activityStatus
end
function playerMobilizationCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_MOBILIZATION_MODULE, gCmd.REQ_MOBI_INIT, handler(self, self.initRsp))
	msgCtrl.register(gCmd.CMD_MOBILIZATION_MODULE, gCmd.REQ_MOBI_MISSION_COMPLETE, handler(self, self.missionCompleteRsp))
	msgCtrl.register(gCmd.CMD_MOBILIZATION_MODULE, gCmd.REQ_MOBI_MISSION_RANKINFO, handler(self, self.allianceRankInfoRsp))
	msgCtrl.register(gCmd.CMD_MOBILIZATION_MODULE, gCmd.REQ_MOBI_MISSION_GROUP_RANK, handler(self, self.groupRankInfoRsp))
	msgCtrl.register(gCmd.CMD_MOBILIZATION_MODULE, gCmd.REQ_MOBI_MISSION_RESET, handler(self, self.resetRsp))
end
function playerMobilizationCtrl:initRsp(content)
end
function playerMobilizationCtrl:reqEnterData()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_MOBILIZATION_MODULE, gCmd.REQ_MOBI_INIT, data)
end
function playerMobilizationCtrl:reqMissionComplete(tasktypeid)
	local serverproxy, data
	data.tasktypeid = tasktypeid
	serverproxy:Request(gCmd.CMD_MOBILIZATION_MODULE, gCmd.REQ_MOBI_MISSION_COMPLETE, data)
end
function playerMobilizationCtrl:reqRankInfo()
	print("playerMobilizationCtrl:reqRankInfo()")
	local _ENV, data = print, print
	serverproxy:Request(gCmd.CMD_MOBILIZATION_MODULE, gCmd.REQ_MOBI_MISSION_RANKINFO, data)
end
function playerMobilizationCtrl:reqGroupRankInfo(beginIndex)
	local serverproxy, data
	beginIndex = beginIndex or 1
	data.beginIndex = beginIndex
	serverproxy:Request(gCmd.CMD_MOBILIZATION_MODULE, gCmd.REQ_MOBI_MISSION_GROUP_RANK, data)
end
function playerMobilizationCtrl:resetRsp(content)
	dump(content, "playerMobilizationCtrl:resetRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.personalMissionData.missionset = content.rspdata.missionset
		self.personalMissionData.resetTimes = content.rspdata.resetTimes
	end
	_ENV = content.rspdata.resetTimes
	content.rspdata.resetTimes.msg = "MESSAGE_ALLIANCE_TASK_REFRESH"
	content.rspdata.resetTimes.isReset = true
	SoraDSendMessage(content.rspdata.resetTimes)
end
function playerMobilizationCtrl:reqRefresh()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_MOBILIZATION_MODULE, gCmd.REQ_MOBI_MISSION_RESET, data)
end
function playerMobilizationCtrl:getSelectInfo()
	if not self.personalMissionData.awardSelect then
		_UPVALUE0_ = self.personalMissionData.awardSelect
	end
	return self.personalMissionData.awardSelect
end
function playerMobilizationCtrl:missionCompleteRsp(content)
	dump(content, "playerMobilizationCtrl:missionCompleteRsp(content)", 10)
	local data = content.data
	local err = content.err
	if err == gErrDef.Err_None then
		if content.missionset then
			self.personalMissionData.missionset = content.missionset
			_ENV = content.missionset
			content.missionset.msg = "MESSAGE_GREEN_POINT_UPDATE"
			content.missionset.type = GREEN_POINT_NOTICE_TYPE.ALLIANCE
			SoraDSendMessage(content.missionset)
			_ENV = content.missionset
			content.missionset.msg = "MESSAGE_GREEN_POINT_UPDATE"
			content.missionset.type = GREEN_POINT_NOTICE_TYPE.ALLIANCE_TASK
			SoraDSendMessage(content.missionset)
			_ENV = content.missionset
			content.missionset.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
			content.missionset.eventID = gActivityTimeActivityID.ALLIANCE_MOBILIZATION_ACTIVITY
			SoraDSendMessage(content.missionset)
			local taskdata = mobilizationltCtrl:getTaskInfo(data.tasktypeid)
			if taskdata then
				local score = taskdata.point
				_ENV = nil
				;(nil).score = score
				SoraDShowMsgTip(i18n("common_text_3592", nil))
				_ENV = i18n("common_text_3592", nil)
				i18n("common_text_3592", nil).msg = "MESSAGE_ALLIANCE_TASK_ADD_SCORE_ANIM"
				i18n("common_text_3592", nil).score = score
				SoraDSendMessage(i18n("common_text_3592", nil))
			end
		end
		if content.score then
			self.personalMissionData.score = content.score
			updateScore = true
		end
		if content.rspdata and content.rspdata.reward then
			SoraDMailGainItems(content.rspdata.reward, true)
		end
	end
	_ENV = content.rspdata.reward
	content.rspdata.reward.msg = "MESSAGE_ALLIANCE_TASK_COMMIT_BACK"
	SoraDSendMessage(content.rspdata.reward)
end
function playerMobilizationCtrl:allianceRankInfoRsp(content)
	local data = content.data
	local err = content.err
	if err == gErrDef.Err_None then
		if not self.allianceRankInfo then
			_ENV = self.allianceRankInfo
		end
		self.allianceRankInfo = self.allianceRankInfo
		self.allianceRankInfo.rankdata = content.rankdata
		self.allianceRankInfo.currank = content.currank
	end
	_ENV = content.currank
	content.currank.msg = "MESSAGE_ALLIANCE_TASK_USER_INFO_BACK"
	SoraDSendMessage(content.currank)
end
function playerMobilizationCtrl:getAllianceRankInfo()
	if not self.allianceRankInfo then
		_UPVALUE0_ = self.allianceRankInfo
	end
	return self.allianceRankInfo
end
function playerMobilizationCtrl:getGroupRankInfo()
	if not self.groupRankInfo then
		_UPVALUE0_ = self.groupRankInfo
	end
	return self.groupRankInfo
end
function playerMobilizationCtrl:getBuyCost()
	return MOBILIZATION_BUY_COST
end
function playerMobilizationCtrl:groupRankInfoRsp(content)
	local data = content.data
	local err = content.err
	if err == gErrDef.Err_None then
		local bHaveData = true
		if data.beginIndex == 1 then
			if not self.groupRankInfo then
				_ENV = self.groupRankInfo
			end
			self.groupRankInfo = self.groupRankInfo
			self.groupRankInfo.rankdata = content.rankdata
			if not next(content.rankdata) then
				bHaveData = false
			end
			self.groupRankInfo.currank = content.currank
		else
			if not self.groupRankInfo then
				_ENV = self.groupRankInfo
			end
			self.groupRankInfo = self.groupRankInfo
			if not self.groupRankInfo.rankdata then
				_ENV = self.groupRankInfo.rankdata
			end
			self.groupRankInfo.rankdata = self.groupRankInfo.rankdata
			if not next(content.rankdata) then
				bHaveData = false
			end
			for k, v in pairs(content.rankdata) do
				table.insert(self.groupRankInfo.rankdata, v)
			end
			self.groupRankInfo.currank = content.currank
		end
	end
	local bHaveData
	_ENV = content.currank
	content.currank.msg = "MESSAGE_ALLIANCE_TASK_RANK_INFO_BACK"
	content.currank.hasMore = bHaveData
	SoraDSendMessage(content.currank)
end
function playerMobilizationCtrl:getCurAliStatus()
	return self.curAliStatus
end
function playerMobilizationCtrl:initClientData(retdata)
	dump(retdata, "playerMobilizationCtrl:initClientData()", 10)
	if not retdata then
		retdata, _ENV = dump, dump
	end
	self.activityStatus = retdata.activityStatus
	if not self.alliancemissionInfo then
		_ENV = self.alliancemissionInfo
	end
	self.alliancemissionInfo = self.alliancemissionInfo
	self.alliancemissionInfo.curAliStatus = retdata.curAliStatus
	self.alliancemissionInfo.grouprank = retdata.grouprank
	self.alliancemissionInfo.matchlev = retdata.matchlev
	self.alliancemissionInfo.matchscore = retdata.matchscore
	self.alliancemissionInfo.mobiAliStatus = retdata.mobiAliStatus
	self.mobiAliStatus = retdata.mobiAliStatus
	self.alliancemissionInfo.newmatchlev = retdata.newmatchlev
	if not retdata.personalMissionData then
		_ENV = retdata.personalMissionData
	end
	self.personalMissionData = retdata.personalMissionData
	self:registerNotify()
end
function playerMobilizationCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.ALLIANCE_MOBILIZATION, handler(self, self.notifyUpdate))
end
function playerMobilizationCtrl:notifyUpdate(event)
	local notifydata = event.data
	local updateTaskEvent = false
	local taskUpdateState = false
	local updateScore = false
	dump(notifydata, "notifyUpdate(event)@@@", 10)
	for k, data in pairs(notifydata) do
		if data.missionset then
			for k2, v2 in pairs(data.missionset) do
				if v2.taskstatus == gMobilizationTaskStatus.TASK_STATUS_COMPLETE then
					SoraDShowMsgTip(i18n("common_text_3606"))
				end
				if self.personalMissionData.missionset[tostring(v2.tasktypeid)] then
					self.personalMissionData.missionset[tostring(v2.tasktypeid)] = v2
				end
			end
			updateTaskEvent = true
		end
		if data.alliancemission then
			local alliancemission = data.alliancemission
			if alliancemission then
				local taskindex = alliancemission.index
				if not self.alliancemissionInfo then
					_ENV = self.alliancemissionInfo
				end
				self.alliancemissionInfo = self.alliancemissionInfo
				local missionData = self.alliancemissionInfo.MissionData
				if missionData then
					self:cancelAllianceMissionTimer(taskindex)
					missionData[taskindex] = alliancemission
					print("notifyupdate4447777")
					updateTaskEvent = true
				end
			end
		end
		if data.alliancescore then
			local newscore = data.alliancescore.score
			if not self.alliancemissionInfo then
				_ENV = self.alliancemissionInfo
			end
			self.alliancemissionInfo = self.alliancemissionInfo
			self.alliancemissionInfo.matchscore = newscore
			updateScore = true
		end
		if data.matchinfo then
			local newmatchlev = data.matchinfo.matchlev
			local newscore = data.matchinfo.matchscore
			if not self.alliancemissionInfo then
				_ENV = self.alliancemissionInfo
			end
			self.alliancemissionInfo = self.alliancemissionInfo
			self.alliancemissionInfo.matchlev = newmatchlev
			self.alliancemissionInfo.matchscore = newscore
			self.alliancemissionInfo.newmatchlev = data.matchinfo.newmatchlev
			self.alliancemissionInfo.grouprank = data.matchinfo.grouprank
		end
		if data.activityStatus then
			taskUpdateState = true
			self.activityStatus = data.activityStatus
		end
		if data.mobiAliStatus then
			self.mobiAliStatus = data.mobiAliStatus
			updateScore = true
		end
		if data.allianceMissionData then
			if not self.alliancemissionInfo then
				_ENV = self.alliancemissionInfo
			end
			self.alliancemissionInfo = self.alliancemissionInfo
			self.alliancemissionInfo.MissionData = data.allianceMissionData
		end
		if data.personalMissionData then
			self.personalMissionData = data.personalMissionData
			updateTaskEvent = true
		end
		if data.curAliStatus then
			self.curAliStatus = data.curAliStatus
			updateScore = true
		end
		if data.score then
			self.personalMissionData.score = data.score
			updateScore = true
		end
		if data.alliancescore then
			self.alliancemissionInfo.matchscore = data.alliancescore.score
			updateScore = true
		end
	end
	if taskUpdateState then
		_ENV = 10
		;(10).byUID = true
		SoraDConfigSet("Game:alliance:mobilization~bool", false, 10)
		_ENV = "Game:alliance:mobilization~bool"
		;("Game:alliance:mobilization~bool").msg = "MESSAGE_ALLIANCE_TASK_REFRESH"
		SoraDSendMessage("Game:alliance:mobilization~bool")
		_ENV = "Game:alliance:mobilization~bool"
		;("Game:alliance:mobilization~bool").msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		_ENV, ("Game:alliance:mobilization~bool").eventID = gActivityTimeActivityID.ALLIANCE_MOBILIZATION_ACTIVITY, gActivityTimeActivityID.ALLIANCE_MOBILIZATION_ACTIVITY
		;("Game:alliance:mobilization~bool").activityId, gActivityTimeActivityID.ALLIANCE_MOBILIZATION_ACTIVITY[1] = gActivityTimeActivityID.ALLIANCE_MOBILIZATION_ACTIVITY, gActivityTimeActivityID.ALLIANCE_MOBILIZATION_ACTIVITY
		SoraDSendMessage("Game:alliance:mobilization~bool")
		_ENV = "Game:alliance:mobilization~bool"
		;("Game:alliance:mobilization~bool").msg = "MESSAGE_GREEN_POINT_UPDATE"
		;("Game:alliance:mobilization~bool").type = GREEN_POINT_NOTICE_TYPE.ALLIANCE
		SoraDSendMessage("Game:alliance:mobilization~bool")
		_ENV = "Game:alliance:mobilization~bool"
		;("Game:alliance:mobilization~bool").msg = "MESSAGE_GREEN_POINT_UPDATE"
		;("Game:alliance:mobilization~bool").type = GREEN_POINT_NOTICE_TYPE.ALLIANCE_TASK
		SoraDSendMessage("Game:alliance:mobilization~bool")
		_ENV = "Game:alliance:mobilization~bool"
		;("Game:alliance:mobilization~bool").msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		;("Game:alliance:mobilization~bool").eventID = gActivityTimeActivityID.ALLIANCE_MOBILIZATION_ACTIVITY
		SoraDSendMessage("Game:alliance:mobilization~bool")
	end
	if updateTaskEvent then
		_ENV = "Game:alliance:mobilization~bool"
		;("Game:alliance:mobilization~bool").msg = "MESSAGE_ALLIANCE_TASK_REFRESH"
		SoraDSendMessage("Game:alliance:mobilization~bool")
		_ENV = "Game:alliance:mobilization~bool"
		;("Game:alliance:mobilization~bool").msg = "MESSAGE_GREEN_POINT_UPDATE"
		;("Game:alliance:mobilization~bool").type = GREEN_POINT_NOTICE_TYPE.ALLIANCE
		SoraDSendMessage("Game:alliance:mobilization~bool")
		_ENV = "Game:alliance:mobilization~bool"
		;("Game:alliance:mobilization~bool").msg = "MESSAGE_GREEN_POINT_UPDATE"
		;("Game:alliance:mobilization~bool").type = GREEN_POINT_NOTICE_TYPE.ALLIANCE_TASK
		SoraDSendMessage("Game:alliance:mobilization~bool")
		_ENV = "Game:alliance:mobilization~bool"
		;("Game:alliance:mobilization~bool").msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		;("Game:alliance:mobilization~bool").eventID = gActivityTimeActivityID.ALLIANCE_MOBILIZATION_ACTIVITY
		SoraDSendMessage("Game:alliance:mobilization~bool")
	end
	if updateScore then
		_ENV = "Game:alliance:mobilization~bool"
		;("Game:alliance:mobilization~bool").msg = "MESSAGE_ALLIANCE_TASK_REFRESH"
		SoraDSendMessage("Game:alliance:mobilization~bool")
		_ENV = "Game:alliance:mobilization~bool"
		;("Game:alliance:mobilization~bool").msg = "MESSAGE_GREEN_POINT_UPDATE"
		;("Game:alliance:mobilization~bool").type = GREEN_POINT_NOTICE_TYPE.ALLIANCE
		SoraDSendMessage("Game:alliance:mobilization~bool")
		_ENV = "Game:alliance:mobilization~bool"
		;("Game:alliance:mobilization~bool").msg = "MESSAGE_GREEN_POINT_UPDATE"
		;("Game:alliance:mobilization~bool").type = GREEN_POINT_NOTICE_TYPE.ALLIANCE_TASK
		SoraDSendMessage("Game:alliance:mobilization~bool")
		_ENV = "Game:alliance:mobilization~bool"
		;("Game:alliance:mobilization~bool").msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		;("Game:alliance:mobilization~bool").eventID = gActivityTimeActivityID.ALLIANCE_MOBILIZATION_ACTIVITY
		SoraDSendMessage("Game:alliance:mobilization~bool")
	end
end
function playerMobilizationCtrl:getShowTime()
	local isShow = true
	local remainTime = 0
	if self.activityStatus.status == gMobilizationActivityStatus.ACTIVITY_PREPAREING then
		remainTime = self.activityStatus.preparetime - serviceFunctions.systemTime()
	elseif self.activityStatus.status == gMobilizationActivityStatus.ACTIVITY_OPEN then
		remainTime = self.activityStatus.calculatetime - serviceFunctions.systemTime()
	else
		isShow = false
	end
	return isShow, self.activityStatus.status, math.max(0, remainTime)
end
function playerMobilizationCtrl:getPersonScore()
	return self.personalMissionData.score
end
function playerMobilizationCtrl:getPersonResetTimes()
	return self.personalMissionData.resetTimes
end
function playerMobilizationCtrl:getAllianceInfo()
	return self.personalMissionData.allianceinfo
end
function playerMobilizationCtrl:getAllianceScore()
	return self.alliancemissionInfo.matchscore
end
function playerMobilizationCtrl:getAllianceMatchlev()
	return self.alliancemissionInfo.matchlev
end
function playerMobilizationCtrl:getMissionset()
	return self.personalMissionData.missionset
end
return playerMobilizationCtrl

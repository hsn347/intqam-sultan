local activity_9001571_Read = include("activity_9001571_Read")
local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001573_Ctrl = class("activity_9001573_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local activity_9001573_Read = include("activity_9001573_Read")
_ENV = "activity_9001573_Read"
;("activity_9001573_Read").MAP = "mapData"
;("activity_9001573_Read").COMMANDER = "commanderData"
;("activity_9001573_Read").MARK = "mapMarkData"
;("activity_9001573_Read").RUIN_BUILD = "ruinBuildData"
;("activity_9001573_Read").SCORE = "score"
;("activity_9001573_Read").GATEWAY = "gatewayData"
local _ENV, ("activity_9001573_Read").SERVER_TOWER_STATUS, nebulaDefenceWarNotifyType = nil, "serverTowerStatus", "activity_9001573_Read"
;(nil).NORMAL = 1
;(nil).MONSTER_OCCUPY = 2
local (nil).USER_OCCUPY, nebulaDefenceWarServerTowerStatus = 3, nil
function activity_9001573_Ctrl:ctor(properties)
	activity_9001573_Ctrl.super.ctor(self, properties)
	activity_9001573_Ctrl, self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001573, gActivityTimeActivityID.NORMAL_ACTIVITY_9001573
	gActivityTimeActivityID.NORMAL_ACTIVITY_9001573[gNebulaDefenceWarStage.BATTLE1] = 1
	gActivityTimeActivityID.NORMAL_ACTIVITY_9001573[gNebulaDefenceWarStage.BATTLE2] = 1
	gActivityTimeActivityID.NORMAL_ACTIVITY_9001573[gNebulaDefenceWarStage.BATTLE3] = 1
	activity_9001573_Ctrl, self.battleStatus, gActivityTimeActivityID.NORMAL_ACTIVITY_9001573[gNebulaDefenceWarStage.BATTLE4] = gActivityTimeActivityID.NORMAL_ACTIVITY_9001573, gActivityTimeActivityID.NORMAL_ACTIVITY_9001573, 1
	gActivityTimeActivityID.NORMAL_ACTIVITY_9001573[gNebulaDefenceWarStage.READY1] = 1
	gActivityTimeActivityID.NORMAL_ACTIVITY_9001573[gNebulaDefenceWarStage.READY2] = 1
	gActivityTimeActivityID.NORMAL_ACTIVITY_9001573[gNebulaDefenceWarStage.READY3] = 1
	self.prepareStatus, gActivityTimeActivityID.NORMAL_ACTIVITY_9001573[gNebulaDefenceWarStage.READY4] = gActivityTimeActivityID.NORMAL_ACTIVITY_9001573, 1
	self:resetData()
end
function activity_9001573_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_NEBULA_DEFENCE_WAR_MODULE, gCmd.CMD_NEBULA_DEFENCE_WAR_DATA, handler(self, self.reqDataRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_DEFENCE_WAR_MODULE, gCmd.CMD_NEBULA_DEFENCE_WAR_RECEIVE_SCORE_REWARD, handler(self, self.reqReceiveScoreRewardRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_DEFENCE_WAR_MODULE, gCmd.CMD_NEBULA_DEFENCE_WAR_APPOINT, handler(self, self.reqAppointRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_DEFENCE_WAR_MODULE, gCmd.CMD_NEBULA_DEFENCE_WAR_DISMISS, handler(self, self.reqDismissRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_DEFENCE_WAR_MODULE, gCmd.CMD_NEBULA_DEFENCE_WAR_SETMARK, handler(self, self.reqSetMarkRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_DEFENCE_WAR_MODULE, gCmd.CMD_NEBULA_DEFENCE_WAR_DELMARK, handler(self, self.reqDelMarkRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_DEFENCE_WAR_MODULE, gCmd.CMD_NEBULA_DEFENCE_WAR_RANK, handler(self, self.reqRankRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_DEFENCE_WAR_MODULE, gCmd.CMD_NEBULA_DEFENCE_WAR_SHARE, handler(self, self.reqShareRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_DEFENCE_WAR_MODULE, gCmd.CMD_NEBULA_DEFENCE_WAR_COMMANDLIST, handler(self, self.reqCommandListRsp))
	self:registerNotify()
end
function activity_9001573_Ctrl:initClientData(data)
	dump(data, "==activity_9001573_Ctrl:initClientData==", 10)
	if not data then
		if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NORMAL_ACTIVITY_9001573, false) and SoraDGetCastleLv() >= CASTLE_LV6_LIMITED then
			self:sendReqInitDataMsg()
		end
		return
	end
	self.data = data
	_ENV = self
	self.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	self.eventID = self.activityID
	SoraDSendMessage(self)
end
function activity_9001573_Ctrl:Logout()
	activity_9001573_Ctrl.super.Logout(self)
	self:resetData(true)
end
function activity_9001573_Ctrl:resetData(isLogout)
	self.data, _ENV = nil, nil
	if not isLogout then
		_ENV = nil
		;(nil).msg = "MESSAGE_ACTIVITY_9001573_MARK"
		SoraDSendMessage(nil)
	end
end
function activity_9001573_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.NEBULA_DEFENCE, handler(self, self.notifyHandler))
end
function activity_9001573_Ctrl:notifyHandler(event)
	dump(event.data, "activity_9001573_Ctrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		if v.notifyType == nil then
			self.data = v.data
		else
			self.data[v.notifyType] = v.data
		end
		if v.notifyType == nebulaDefenceWarNotifyType.SCORE or v.notifyType == nil then
			_ENV = nebulaDefenceWarNotifyType.SCORE
			nebulaDefenceWarNotifyType.SCORE.msg = "MESSAGE_ACTIVITY_9001573_POINT_REWARD"
			SoraDSendMessage(nebulaDefenceWarNotifyType.SCORE)
			_ENV = nebulaDefenceWarNotifyType.SCORE
			nebulaDefenceWarNotifyType.SCORE.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
			nebulaDefenceWarNotifyType.SCORE.eventID = self.activityID
			SoraDSendMessage(nebulaDefenceWarNotifyType.SCORE)
		elseif v.notifyType == nebulaDefenceWarNotifyType.COMMANDER then
			_ENV = nebulaDefenceWarNotifyType.COMMANDER
			nebulaDefenceWarNotifyType.COMMANDER.msg = "MESSAGE_ACTIVITY_9001573_APPOINT_DISMISS"
			SoraDSendMessage(nebulaDefenceWarNotifyType.COMMANDER)
		elseif v.notifyType == nebulaDefenceWarNotifyType.MARK then
			_ENV = nebulaDefenceWarNotifyType.MARK
			nebulaDefenceWarNotifyType.MARK.msg = "MESSAGE_ACTIVITY_9001573_MARK"
			SoraDSendMessage(nebulaDefenceWarNotifyType.MARK)
		elseif v.notifyType == nebulaDefenceWarNotifyType.SERVER_TOWER_STATUS then
			_ENV = nebulaDefenceWarNotifyType.SERVER_TOWER_STATUS
			nebulaDefenceWarNotifyType.SERVER_TOWER_STATUS.msg = "MESSAGE_ACTIVITY_9001573_UPDATE"
			SoraDSendMessage(nebulaDefenceWarNotifyType.SERVER_TOWER_STATUS)
		end
	end
end
function activity_9001573_Ctrl:sendReqInitDataMsg()
	serverproxy:Request(gCmd.CMD_NEBULA_DEFENCE_WAR_MODULE, gCmd.CMD_NEBULA_DEFENCE_WAR_DATA)
end
function activity_9001573_Ctrl:reqReceiveScoreReward(index)
	serverproxy = nil
	;(nil).index = index
	serverproxy:Request(gCmd.CMD_NEBULA_DEFENCE_WAR_MODULE, gCmd.CMD_NEBULA_DEFENCE_WAR_RECEIVE_SCORE_REWARD, nil)
end
function activity_9001573_Ctrl:reqAppoint(targetUid)
	serverproxy = nil
	;(nil).targetUid = targetUid
	serverproxy:Request(gCmd.CMD_NEBULA_DEFENCE_WAR_MODULE, gCmd.CMD_NEBULA_DEFENCE_WAR_APPOINT, nil)
end
function activity_9001573_Ctrl:reqDismiss(targetUid)
	serverproxy = nil
	;(nil).targetUid = targetUid
	serverproxy:Request(gCmd.CMD_NEBULA_DEFENCE_WAR_MODULE, gCmd.CMD_NEBULA_DEFENCE_WAR_DISMISS, nil)
end
function activity_9001573_Ctrl:reqSetMark(data)
	serverproxy = nil
	;(nil).markInfo = data
	serverproxy:Request(gCmd.CMD_NEBULA_DEFENCE_WAR_MODULE, gCmd.CMD_NEBULA_DEFENCE_WAR_SETMARK, nil)
end
function activity_9001573_Ctrl:reqDelMark(data)
	serverproxy:Request(gCmd.CMD_NEBULA_DEFENCE_WAR_MODULE, gCmd.CMD_NEBULA_DEFENCE_WAR_DELMARK, data)
end
function activity_9001573_Ctrl:reqRank()
	print("activity_9001573_Ctrl:reqRank")
	serverproxy:Request(gCmd.CMD_NEBULA_DEFENCE_WAR_MODULE, gCmd.CMD_NEBULA_DEFENCE_WAR_RANK)
end
function activity_9001573_Ctrl:reqShareMark(markData)
	serverproxy:Request(gCmd.CMD_NEBULA_DEFENCE_WAR_MODULE, gCmd.CMD_NEBULA_DEFENCE_WAR_SHARE, markData)
end
function activity_9001573_Ctrl:reqCommandList()
	serverproxy:Request(gCmd.CMD_NEBULA_DEFENCE_WAR_MODULE, gCmd.CMD_NEBULA_DEFENCE_WAR_COMMANDLIST)
end
function activity_9001573_Ctrl:reqDataRsp(content)
	dump(content, "activity_9001573_Ctrl:reqDataRsp(content)", 10)
	if content.err == gErrDef.Err_None or content.err == nil then
		self:initClientData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_ACTIVITY_9001573_UPDATE"
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_ACTIVITY_9001573_POINT_REWARD"
		SoraDSendMessage(self)
	end
end
function activity_9001573_Ctrl:reqReceiveScoreRewardRsp(content)
	dump(content, "activity_9001573_Ctrl:reqReceiveScoreRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.data.receiveData = content.rspdata.receiveData
		SoraDMailGainItems(content.rspdata.rewards, true)
		_ENV = content.rspdata.rewards
		content.rspdata.rewards.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		content.rspdata.rewards.eventID = self.activityID
		SoraDSendMessage(content.rspdata.rewards)
		_ENV = content.rspdata.rewards
		content.rspdata.rewards.msg = "MESSAGE_ACTIVITY_9001573_POINT_REWARD"
		SoraDSendMessage(content.rspdata.rewards)
	end
end
function activity_9001573_Ctrl:reqAppointRsp(content)
	dump(content, "activity_9001573_Ctrl:reqAppointRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.data.commanderData = content.rspdata.commanderData
		_ENV = content.rspdata.commanderData
		content.rspdata.commanderData.msg = "MESSAGE_ACTIVITY_9001573_APPOINT_DISMISS"
		SoraDSendMessage(content.rspdata.commanderData)
		_ENV = content.rspdata.commanderData
		content.rspdata.commanderData.msg = "MESSAGE_ACTIVITY_9001573_COMMANDLIST"
		content.rspdata.commanderData.commandList = content.rspdata.commanderDetail
		SoraDSendMessage(content.rspdata.commanderData)
		SoraDShowMsgTip(i18n("nebula_war_text_0321"))
	end
end
function activity_9001573_Ctrl:reqDismissRsp(content)
	dump(content, "activity_9001573_Ctrl:reqDismissRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.data.commanderData = content.rspdata.commanderData
		_ENV = content.rspdata.commanderData
		content.rspdata.commanderData.msg = "MESSAGE_ACTIVITY_9001573_APPOINT_DISMISS"
		SoraDSendMessage(content.rspdata.commanderData)
		_ENV = content.rspdata.commanderData
		content.rspdata.commanderData.msg = "MESSAGE_ACTIVITY_9001573_COMMANDLIST"
		content.rspdata.commanderData.commandList = content.rspdata.commanderDetail
		SoraDSendMessage(content.rspdata.commanderData)
		SoraDShowMsgTip(i18n("nebula_war_text_0313"))
	end
end
function activity_9001573_Ctrl:reqSetMarkRsp(content)
	dump(content, "activity_9001573_Ctrl:reqSetMarkRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.data.mapMarkData = content.rspdata.mapMarkData
		SoraDShowMsgTip(i18n("Celestial_defense_text_079"))
		_ENV = i18n("Celestial_defense_text_079")
		i18n("Celestial_defense_text_079").msg = "MESSAGE_ACTIVITY_9001573_MARK"
		SoraDSendMessage(i18n("Celestial_defense_text_079"))
	end
end
function activity_9001573_Ctrl:reqDelMarkRsp(content)
	dump(content, "activity_9001573_Ctrl:reqDelMarkRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.data.mapMarkData = content.rspdata.mapMarkData
		_ENV = content.rspdata.mapMarkData
		content.rspdata.mapMarkData.msg = "MESSAGE_ACTIVITY_9001573_MARK"
		SoraDSendMessage(content.rspdata.mapMarkData)
		SoraDShowMsgTip(i18n("common_text_633"))
	end
end
function activity_9001573_Ctrl:reqRankRsp(content)
	dump(content, "activity_9001573_Ctrl:reqRankRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001573_RANK"
		gErrDef.Err_None.rspdata = content.rspdata
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001573_Ctrl:reqShareRsp(content)
	dump(content, "activity_9001573_Ctrl:reqShareRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("Celestial_defense_text_078"))
	end
end
function activity_9001573_Ctrl:reqCommandListRsp(content)
	dump(content, "activity_9001573_Ctrl:reqCommandListRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001573_COMMANDLIST"
		gErrDef.Err_None.commandList = content.rspdata.commanderList
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001573_Ctrl:getReceiveStatusAndNum(activityID)
	local myPoint = self:getMyPoint()
	if myPoint <= 0 then
		return false, 0
	end
	local redNum = 0
	local rewardCfgs = activity_9001573_Read.getRewardsByType(1)
	for i, v in ipairs(rewardCfgs) do
		if self:getPointRewardState(v.point, i) == 1 then
			redNum = redNum + 1
		end
	end
	return 0 < redNum, redNum
end
function activity_9001573_Ctrl:getIsCommander(uid)
	local commanderData = self.data.commanderData
	if not self.data.commanderData then
		return false
	end
	local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
	local ownUid = uid or lordInfoCtrl:getLordInfo().base.uid
	if not commanderData.list then
		_ENV = commanderData.list
	end
	for i, v in ipairs(commanderData.list) do
		if v == ownUid then
			return true
		end
	end
	return false
end
function activity_9001573_Ctrl:getIsManager()
	local commanderData = self.data.commanderData
	if not self.data.commanderData then
		return false
	end
	local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
	local ownUid = lordInfoCtrl:getLordInfo().base.uid
	if ownUid == commanderData.managerUid then
		return true
	end
	return false
end
function activity_9001573_Ctrl:getMyPoint()
	return self.data.score or 0
end
function activity_9001573_Ctrl:getPointRewardState(point, index)
	if not self.data.receiveData then
		local _ENV, gotReward = self.data.receiveData, self.data.receiveData
	end
	if gotReward[tostring(index)] then
		return 2
	end
	local myPoint = self:getMyPoint()
	if point <= myPoint then
		return 1
	end
	return 0
end
function activity_9001573_Ctrl:getStatus()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local activityData = activityShowCtrl:getActivityData(self.activityID)
	return activityData.doStage
end
function activity_9001573_Ctrl:getStatusLastTime()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local _eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	return _eventTime and _eventTime.timerNode.timer:getRemainTime() or 0
end
function activity_9001573_Ctrl:getCommanderNum()
	if not self.data.commanderData or not self.data.commanderData.list then
		local _UPVALUE0_, commanderList = self.data.commanderData.list, self.data.commanderData.list
	end
	return #commanderList
end
function activity_9001573_Ctrl:getPowerRatio()
	return self.data.lv or 0
end
function activity_9001573_Ctrl:getIsInBattle(status)
	if not self:getIsActivityOpen() then
		return false
	end
	status = status or self:getStatus()
	return self.battleStatus[status]
end
function activity_9001573_Ctrl:getIsInPrepare(status)
	if not self:getIsActivityOpen() then
		return false
	end
	status = status or self:getStatus()
	return self.prepareStatus[status]
end
function activity_9001573_Ctrl:getMapBuildsData()
	if not self.data.gatewayData then
		_UPVALUE0_ = self.data.gatewayData
	end
	return self.data.gatewayData
end
function activity_9001573_Ctrl:getCampMarkList()
	if not self.data.mapMarkData or not self.data.mapMarkData.mark then
		_UPVALUE0_ = self.data.mapMarkData.mark
	end
	return self.data.mapMarkData.mark
end
function activity_9001573_Ctrl:getRuinBuildData(buildType)
	if not self.data.ruinBuildData then
		return 0
	end
	return self.data.ruinBuildData[tostring(buildType)] or 0
end
function activity_9001573_Ctrl:getIsTowerBeOccupied()
	return worldMapDefine.checkCurrentKingdomIsMyKingdom() and self:getIsInBattle() and self.data.serverTowerStatus == nebulaDefenceWarServerTowerStatus.MONSTER_OCCUPY
end
function activity_9001573_Ctrl:getIsActivityOpen()
	return clientEventMgr.judgeIsOpen(self.activityID)
end
return activity_9001573_Ctrl

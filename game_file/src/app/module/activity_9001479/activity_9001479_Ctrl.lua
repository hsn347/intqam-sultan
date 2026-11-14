local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001479_Ctrl = class("activity_9001479_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001479_Ctrl:ctor(properties)
	activity_9001479_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.NEBULA_CAMP_INTEGRAL_ACTIVITY
	self:resetData()
end
function activity_9001479_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_NEBULA_CAMP_INTEGRAL_MODULE, gCmd.REQ_NEBULA_CAMP_INTEGRAL_DATA, handler(self, self.reqInitDataRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_CAMP_INTEGRAL_MODULE, gCmd.REQ_NEBULA_CAMP_INTEGRAL_ROUND_CAMP_SCORE, handler(self, self.reqRoundCampScoreRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_CAMP_INTEGRAL_MODULE, gCmd.REQ_NEBULA_CAMP_INTEGRAL_ROUND_RANK, handler(self, self.reqRoundRankRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_CAMP_INTEGRAL_MODULE, gCmd.REQ_NEBULA_CAMP_INTEGRAL_ROUND_RESULT, handler(self, self.reqRoundResultRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_CAMP_INTEGRAL_MODULE, gCmd.REQ_NEBULA_CAMP_INTEGRAL_REWARD, handler(self, self.reqRewardRsp))
	self:registerNotify()
end
function activity_9001479_Ctrl:Logout()
	activity_9001479_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001479_Ctrl:resetData()
	self.data, _UPVALUE0_ = nil, nil
end
function activity_9001479_Ctrl:initClientData(data)
	if data then
		self.data = data
	end
end
function activity_9001479_Ctrl:registerNotify()
	local notifyCtrl = SoraDGetCtrl("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.NOTIFY_NEBULA_CAMP_INTEGRAL, handler(self, self.notifyHandler))
end
function activity_9001479_Ctrl:notifyHandler(event)
	dump(event.data, "activity_9001479_Ctrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		local notifyType = v.notifyType
		if not v.notifyData then
			local _ENV, notifyData = v.notifyData, v.notifyData
		end
		if notifyType == "newStage" then
			self.data = notifyData
			_ENV = nil
			;(nil).msg = "MESSAGE_ACTIVITY_9001479_UPDATE_STAGE"
			SoraDSendMessage(nil)
			_ENV = nil
			;(nil).msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
			;(nil).eventID = self.activityID
			SoraDSendMessage(nil)
		elseif notifyType == "addProgress" then
			self.data = notifyData
			_ENV = nil
			;(nil).msg = "MESSAGE_ACTIVITY_9001479_UPDATE_PROGRESS"
			SoraDSendMessage(nil)
		elseif notifyType == "settle" then
			_ENV = nil
			;(nil).msg = "MESSAGE_ACTIVITY_9001479_UPDATE_SETTLE"
			;(nil).round = notifyData
			SoraDSendMessage(nil)
		end
	end
end
function activity_9001479_Ctrl:reqInitData()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_NEBULA_CAMP_INTEGRAL_MODULE, gCmd.REQ_NEBULA_CAMP_INTEGRAL_DATA, nil)
end
function activity_9001479_Ctrl:reqInitDataRsp(content)
	dump(content, "activity_9001479_Ctrl:reqInitDataRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		if not content.rspdata then
			_ENV = content.rspdata
		end
		self.data = content.rspdata
	end
end
function activity_9001479_Ctrl:reqRoundCampScore(round)
	serverproxy = nil
	;(nil).round = round
	serverproxy:Request(gCmd.CMD_NEBULA_CAMP_INTEGRAL_MODULE, gCmd.REQ_NEBULA_CAMP_INTEGRAL_ROUND_CAMP_SCORE, nil)
end
function activity_9001479_Ctrl:reqRoundCampScoreRsp(content)
	dump(content, "activity_9001479_Ctrl:reqRoundCampScoreRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001479_UPDATE_CAMP_SCORE"
		gErrDef.Err_None.rspdata = content.rspdata
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001479_Ctrl:reqRoundRank(round, iBegin, nCount)
	serverproxy = nil
	;(nil).round = round
	;(nil).iBegin = iBegin
	local (nil).nCount, data = nCount, nil
	serverproxy:Request(gCmd.CMD_NEBULA_CAMP_INTEGRAL_MODULE, gCmd.REQ_NEBULA_CAMP_INTEGRAL_ROUND_RANK, data)
end
function activity_9001479_Ctrl:reqRoundRankRsp(content)
	dump(content, "activity_9001479_Ctrl:reqRoundRankRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001479_UPDATE_RANK"
		gErrDef.Err_None.rspdata = content.rspdata
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001479_Ctrl:reqRoundResult(round)
	serverproxy = nil
	;(nil).round = round
	serverproxy:Request(gCmd.CMD_NEBULA_CAMP_INTEGRAL_MODULE, gCmd.REQ_NEBULA_CAMP_INTEGRAL_ROUND_RESULT, nil)
end
function activity_9001479_Ctrl:reqRoundResultRsp(content)
	dump(content, "activity_9001479_Ctrl:reqRoundResultRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001479_UPDATE_RESULT"
		gErrDef.Err_None.rspdata = content.rspdata
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001479_Ctrl:reqReward(taskType, reward)
	serverproxy = nil
	local (nil).reward, clientData = reward, nil
	serverproxy = nil
	;(nil).taskType = taskType
	serverproxy:Request(gCmd.CMD_NEBULA_CAMP_INTEGRAL_MODULE, gCmd.REQ_NEBULA_CAMP_INTEGRAL_REWARD, nil, clientData)
end
function activity_9001479_Ctrl:reqRewardRsp(content)
	dump(content, "activity_9001479_Ctrl:reqRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local taskType = content.data.taskType
		local gotRewardLv1 = self:getTaskGotRewardLv(taskType)
		self.data = content.rspdata
		local gotRewardLv2 = self:getTaskGotRewardLv(taskType)
		local scale = gotRewardLv2 - gotRewardLv1
		scale = math.max(1, scale)
		local reward = clone(content.clientData.reward)
		for __, v in ipairs(reward) do
			v.count = v.count * scale
		end
		SoraDMailGainItems(reward, true)
		_ENV = reward
		reward.msg = "MESSAGE_ACTIVITY_9001479_UPDATE_PROGRESS"
		SoraDSendMessage(reward)
	end
end
function activity_9001479_Ctrl:getTaskMap(...)
	if not self.data.taskMap then
		_UPVALUE0_ = self.data.taskMap
	end
	return self.data.taskMap
end
function activity_9001479_Ctrl:getTaskGotRewardLv(taskType)
	local taskMap = self:getTaskMap()
	if not taskMap[tostring(taskType)] then
		local _ENV, task = taskMap[tostring(taskType)], taskMap[tostring(taskType)]
	end
	local gotRewardLv = task.gotRewardLv or 0
	return gotRewardLv
end
function activity_9001479_Ctrl:getActivityData()
	return self.data
end
function activity_9001479_Ctrl:getCurStage(...)
	return self.data.stage
end
function activity_9001479_Ctrl:getRoundScore(...)
	return self.data.roundScore or 0
end
function activity_9001479_Ctrl:getCurRound(...)
	local curStage = self.data.stage
	local activity_9001479_Read = include("activity_9001479_Read")
	local curRound, curBatch = activity_9001479_Read.getRoundAndBatch(curStage)
	return curRound
end
function activity_9001479_Ctrl:getSelfCampByRound(round)
	local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
	local nebulaWarUtil = include("nebulaWarUtil")
	local curRound = round or self:getCurRound()
	local groupId = nebulaActivityCtrl:getSelfGroupId()
	return nebulaWarUtil.getCampByGroupId(groupId, curRound)
end
function activity_9001479_Ctrl:getStageRemainTime(stage)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local activity_9001479_Read = include("activity_9001479_Read")
	local beginTime = activityShowCtrl:getBeginTimeSecond(self.activityID)
	local stage2Time = activity_9001479_Read.getStageTime(2)
	local curStage = stage or self:getCurStage()
	local stageTime = activity_9001479_Read.getStageTime(curStage + 1)
	local remainTime = beginTime - stage2Time + stageTime - serviceFunctions.systemTime()
	return remainTime
end
function activity_9001479_Ctrl:getReceiveStatusAndNum(...)
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		return false, -1
	end
	local activity_9001479_Read = include("activity_9001479_Read")
	local curStage = self.data.stage
	local curRound, curBatch = activity_9001479_Read.getRoundAndBatch(curStage)
	if curRound < 1 or 4 < curRound or curBatch == 0 then
		return false, -1
	end
	local config = activity_9001479_Read.getTaskConfigByRound(curRound, curBatch)
	for __, group in pairs(config) do
		local groupNum = #group
		for i, cfg in ipairs(group) do
			local taskType = cfg.type
			local need = cfg.need
			local method = cfg.method
			if not self.data.taskMap[tostring(taskType)] then
				local _ENV, task = self.data.taskMap[tostring(taskType)], self.data.taskMap[tostring(taskType)]
			end
			local progress = task.progress or 0
			local gotRewardLv = task.gotRewardLv or 0
			local state
			if method == 1 and progress >= (gotRewardLv + 1) * need then
				return true, -1
			end
			if i > gotRewardLv and need <= progress then
				return true, -1
			end
		end
	end
	return false, -1
end
function activity_9001479_Ctrl:checkShowCampNotice(...)
	local activity_9001479_Read = include("activity_9001479_Read")
	local curOpencount = self.data.opencount
	local curStage = self.data.stage
	local curRound, curBatch = activity_9001479_Read.getRoundAndBatch(curStage)
	if curRound < 1 or 4 < curRound or curBatch == 0 then
		return false
	end
	_ENV = nil
	;(nil).byUID = true
	local _key = SoraDConfigGet("Game:activity_9001479:campNotice~integer", nil) or 0
	local _opencount = math.floor(_key / 100)
	local _round = _key % 100
	if _opencount ~= curOpencount or _round ~= curRound then
		local key = curOpencount * 100 + curRound
		_ENV = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:activity_9001479:campNotice~integer", key, nil)
		return true
	end
end
function activity_9001479_Ctrl:checkIsSpecial(...)
	local constantRead = include("constantRead")
	local value = constantRead.getConstValue("CAMP_INTEGRA_NUM1_SPECIAL", 0.0)
	return value == 1
end
return activity_9001479_Ctrl

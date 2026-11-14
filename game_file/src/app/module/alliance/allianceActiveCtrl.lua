local gameModule = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local allianceActiveCtrl = class("allianceActiveCtrl", gameModule)
function allianceActiveCtrl:ctor(properties)
	allianceActiveCtrl.super.ctor(self, properties)
	self:resetData()
end
function allianceActiveCtrl:resetData()
	self.alliance, _UPVALUE0_ = nil, nil
	self.alliance.allianceActiveLv = 1
	self.alliance.allianceActivePoint = 0
	self.alliance.curPublishList, _UPVALUE0_ = nil, nil
	self.alliance.curShowList, _UPVALUE0_ = nil, nil
	self.person, _UPVALUE0_, self.alliance.refreshCount = self.alliance, self.alliance, 0
	self.person.joinALlianceTime = nil
	self.person.curTask, _UPVALUE0_ = nil, nil
	self.person.todayTask, _UPVALUE0_ = nil, nil
	self.person.todayAcceptCount = 0
end
function allianceActiveCtrl:Logout()
	allianceActiveCtrl.super.Logout(self)
	self.handle_notify = nil
	self:resetData()
end
function allianceActiveCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_ALLIANCE_ACTIVE_MODULE, gCmd.REQ_ALLIANCE_ACTIVE_INIT, handler(self, self.initDataRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_ACTIVE_MODULE, gCmd.REQ_ALLIANCE_ACTIVE_PUBLISH_TASK, handler(self, self.publishTaskRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_ACTIVE_MODULE, gCmd.REQ_ALLIANCE_ACTIVE_REFRESH_TASK, handler(self, self.refreshTaskRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_ACTIVE_MODULE, gCmd.REQ_ALLIANCE_ACTIVE_ACCEPT_TASK, handler(self, self.acceptTaskRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_ACTIVE_MODULE, gCmd.REQ_ALLIANCE_ACTIVE_RECEIVE_TASK_REWARD, handler(self, self.receiveTaskRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_ACTIVE_MODULE, gCmd.REQ_ALLIANCE_ACTIVE_RANK, handler(self, self.getRankRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_ACTIVE_MODULE, gCmd.REQ_ALLIANCE_ACTIVE_INSIDE_RANK, handler(self, self.getMemberRankRsp))
	self:registerNotify()
	self:initData()
end
function allianceActiveCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.ALLIANCE_ACTIVE, handler(self, self.notifyHandler))
end
function allianceActiveCtrl:notifyHandler(event)
	dump(event, "allianceActiveCtrl:notifyHandler event========", 10)
	for _, content in ipairs(event.data) do
		local alliance = content.alliance
		if alliance then
			self.alliance = alliance
		end
		local person = content.person
		if person then
			self.person = person
		end
	end
	_ENV = ipairs(event.data)
	ipairs(event.data).msg = "MESSAGE_ALLIANCE_ACTIVE_TASK_UPDATE"
	SoraDSendMessage(ipairs(event.data))
	_ENV = ipairs(event.data)
	ipairs(event.data).msg = "MESSAGE_GREEN_POINT_UPDATE"
	ipairs(event.data).type = GREEN_POINT_NOTICE_TYPE.ALLIANCE
	SoraDSendMessage(ipairs(event.data))
end
function allianceActiveCtrl:initData()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ALLIANCE_ACTIVE_MODULE, gCmd.REQ_ALLIANCE_ACTIVE_INIT, nil)
end
function allianceActiveCtrl:publishTask(index)
	serverproxy = nil
	;(nil).index = index
	serverproxy:Request(gCmd.CMD_ALLIANCE_ACTIVE_MODULE, gCmd.REQ_ALLIANCE_ACTIVE_PUBLISH_TASK, nil)
end
function allianceActiveCtrl:refreshTask(index)
	serverproxy = nil
	;(nil).index = index
	serverproxy:Request(gCmd.CMD_ALLIANCE_ACTIVE_MODULE, gCmd.REQ_ALLIANCE_ACTIVE_REFRESH_TASK, nil)
end
function allianceActiveCtrl:acceptTask(index)
	serverproxy = nil
	;(nil).index = index
	serverproxy:Request(gCmd.CMD_ALLIANCE_ACTIVE_MODULE, gCmd.REQ_ALLIANCE_ACTIVE_ACCEPT_TASK, nil)
end
function allianceActiveCtrl:receiveReward(index)
	serverproxy = nil
	;(nil).index = index
	serverproxy:Request(gCmd.CMD_ALLIANCE_ACTIVE_MODULE, gCmd.REQ_ALLIANCE_ACTIVE_RECEIVE_TASK_REWARD, nil)
end
function allianceActiveCtrl:getRank(nType)
	serverproxy = nil
	;(nil).nType = nType
	serverproxy:Request(gCmd.CMD_ALLIANCE_ACTIVE_MODULE, gCmd.REQ_ALLIANCE_ACTIVE_RANK, nil)
end
function allianceActiveCtrl:getMemberRank(nType)
	serverproxy = nil
	;(nil).nType = nType
	serverproxy:Request(gCmd.CMD_ALLIANCE_ACTIVE_MODULE, gCmd.REQ_ALLIANCE_ACTIVE_INSIDE_RANK, nil)
end
function allianceActiveCtrl:initDataRsp(data)
	if data.err == gErrDef.Err_None then
		local activeData = data.rspdata.allianceActiveData
		if activeData then
			self.alliance = activeData.alliance
			self.person = activeData.person
		end
	end
end
function allianceActiveCtrl:publishTaskRsp(data)
	if data.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("alliance_text_47"))
	elseif data.err == gErrDef.Err_ALLIANCE_ACTIVE_DATA_ILLEGAL then
		SoraDShowMsgTip(i18n("alliance_text_29"))
	end
end
function allianceActiveCtrl:refreshTaskRsp(data)
	if data.err == gErrDef.Err_None then
		local index = data.data.index
		SoraDShowMsgTip(i18n("alliance_text_48"))
	end
end
function allianceActiveCtrl:acceptTaskRsp(data)
	if data.err == gErrDef.Err_None then
		self.person = data.rspdata.person
		SoraDShowMsgTip(i18n("alliance_text_52"))
	elseif data.err == gErrDef.Err_ALLIANCE_ACTIVE_LIMIT_ACCEPT_TASK_COUNT then
		SoraDShowMsgTip(i18n("alliance_text_34"))
	elseif data.err == gErrDef.Err_ALLIANCE_ACTIVE_CAN_NOT_ACCEPT then
		SoraDShowMsgTip(i18n("alliance_text_35"))
	elseif data.err == gErrDef.Err_ALLIANCE_ACTIVE_ALREADY_ACCEPT then
		SoraDShowMsgTip(i18n("alliance_text_51"))
	end
	_ENV = i18n("alliance_text_51")
	i18n("alliance_text_51").msg = "MESSAGE_ALLIANCE_ACTIVE_TASK_UPDATE"
	SoraDSendMessage(i18n("alliance_text_51"))
end
function allianceActiveCtrl:receiveTaskRsp(data)
	dump(data, "allianceActiveCtrl:receiveTaskRsp", 10)
	if data.err == gErrDef.Err_None then
		self.person = data.rspdata.person
		SoraDMailGainItems(data.rspdata.reward, true)
	end
	_ENV = data.rspdata.reward
	data.rspdata.reward.msg = "MESSAGE_ALLIANCE_ACTIVE_TASK_UPDATE"
	SoraDSendMessage(data.rspdata.reward)
end
function allianceActiveCtrl:getRankRsp(data)
	dump(data, "allianceActiveCtrl:getRankRsp", 10)
	local _ENV, ret = dump, dump
	ret.rankInfo = data.rspdata and data.rspdata.rankInfo
	ret.selfInfo = data.rspdata and data.rspdata.selfInfo
	_ENV = "allianceActiveCtrl:getRankRsp"
	;("allianceActiveCtrl:getRankRsp").msg = "MESSAGE_ALLIANCE_ACTIVE_RANK_UPDATE"
	;("allianceActiveCtrl:getRankRsp").rankData = ret
	;("allianceActiveCtrl:getRankRsp").isAllianceRank = true
	SoraDSendMessage("allianceActiveCtrl:getRankRsp")
end
function allianceActiveCtrl:getMemberRankRsp(data)
	dump(data, "allianceActiveCtrl:getMemberRankRsp", 10)
	local _ENV, ret = dump, dump
	ret.rankInfo = data.rspdata and data.rspdata.rankInfo
	ret.selfInfo = data.rspdata and data.rspdata.selfInfo
	_ENV = "allianceActiveCtrl:getMemberRankRsp"
	;("allianceActiveCtrl:getMemberRankRsp").msg = "MESSAGE_ALLIANCE_ACTIVE_RANK_UPDATE"
	;("allianceActiveCtrl:getMemberRankRsp").rankData = ret
	;("allianceActiveCtrl:getMemberRankRsp").isAllianceRank = false
	SoraDSendMessage("allianceActiveCtrl:getMemberRankRsp")
end
function allianceActiveCtrl:getJoinAllianceTime()
	if self.person.joinALlianceTime and self.person.joinALlianceTime > 0 then
		return self.person.joinALlianceTime + ALLIANCE_ACTIVE_JOINALLIANCE_TIME * 3600 - serviceFunctions.systemTime()
	end
end
function allianceActiveCtrl:getCurPublishNum()
	return table.nums(self.alliance.curPublishList)
end
function allianceActiveCtrl:getCurPublishList()
	local allianceActiveltCtrl = include("allianceActiveltCtrl")
	local _ENV, publishList = "allianceActiveltCtrl", "allianceActiveltCtrl"
	for k, v in pairs(self.alliance.curPublishList) do
		local taskInfo = allianceActiveltCtrl.getActiveTaskInfo(v.index)
		taskInfo.status = self:getTaskStatus(v.index)
		taskInfo.publishTime = v.publishTime
		taskInfo.name = v.name
		table.insert(publishList, taskInfo)
	end
	table.sort(publishList, function(a, b)
		if a.status == b.status then
			return a.index < b.index
		else
			return a.status > b.status
		end
	end)
	return publishList
end
function allianceActiveCtrl:getCurShowList()
	local allianceActiveltCtrl = include("allianceActiveltCtrl")
	local _ENV, publishList = "allianceActiveltCtrl", "allianceActiveltCtrl"
	if not self.alliance.curShowList then
		_ENV = self.alliance.curShowList
	end
	for k, v in pairs(self.alliance.curShowList) do
		local taskInfo = allianceActiveltCtrl.getActiveTaskInfo(v.index)
		taskInfo.position = v.position
		table.insert(publishList, taskInfo)
	end
	table.sort(publishList, function(a, b)
		return a.position < b.position
	end)
	return publishList
end
function allianceActiveCtrl:getRefreshCount()
	return self.alliance.refreshCount
end
function allianceActiveCtrl:getActiveLevel()
	return self.alliance.allianceActiveLv
end
function allianceActiveCtrl:getActivePoint()
	return self.alliance.allianceActivePoint
end
function allianceActiveCtrl:getActiveTodayPoint()
	return self.alliance.allianceActiveTodayPoint
end
function allianceActiveCtrl:getCanReceiveTaskNum()
	local num = 0
	if not self.person.todayTask then
		_ENV = self.person.todayTask
	end
	for k, v in pairs(self.person.todayTask) do
		if v.isCanReceive then
			num = num + 1
		end
	end
	return num
end
function allianceActiveCtrl:getPersonTodayAcceptNum()
	local curNum = 0
	if not self.person.curTask then
		_ENV = self.person.curTask
	end
	if next(self.person.curTask) then
		curNum = 1
	end
	if not self.person.todayTask then
		_ENV = self.person.todayTask
	end
	return table.nums(self.person.todayTask) + curNum
end
function allianceActiveCtrl:getMyTodayAcceptNum()
	return self.person.todayAcceptCount or 0
end
function allianceActiveCtrl:isHaveDoingTask()
	local ret = false
	local index
	if not self.person.curTask then
		_ENV = self.person.curTask
	end
	if next(self.person.curTask) then
		ret = true
		index = self.person.curTask.index
	end
	return ret, index
end
function allianceActiveCtrl:getCurTaskProgress(index)
	local progress = 0
	if not self.person.curTask then
		_ENV = self.person.curTask
	end
	if next(self.person.curTask) then
		progress = self.person.curTask.progress
	end
	return progress
end
function allianceActiveCtrl:getTaskAcceptCount(index)
	local acceptCount = 0
	if self.alliance.curPublishList and self.alliance.curPublishList[tostring(index)] then
		acceptCount = self.alliance.curPublishList[tostring(index)].acceptCount
	end
	return acceptCount
end
function allianceActiveCtrl:getTaskStatus(index)
	local status = 1
	local isFinished = false
	if not self.person.todayTask then
		_ENV = self.person.todayTask
	end
	for k, v in pairs(self.person.todayTask) do
		if v.index == index then
			isFinished = true
			status = v.isCanReceive and 3 or 0
			break
		end
	end
	if not isFinished and self.person.curTask and self.person.curTask.index == index then
		status = 2
	end
	return status
end
function allianceActiveCtrl:isAcceptedTask(index, uid)
	local ret = false
	if self.alliance.curPublishList and self.alliance.curPublishList[tostring(index)] then
		if not self.alliance.curPublishList[tostring(index)].acceptUids then
			local _ENV, acceptUids = self.alliance.curPublishList[tostring(index)].acceptUids, self.alliance.curPublishList[tostring(index)].acceptUids
		end
		if acceptUids[tostring(uid)] then
			ret = true
		end
	end
	return ret
end
return allianceActiveCtrl

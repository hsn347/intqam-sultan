local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001643_Ctrl = class("activity_9001643_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local activity_9001643_Read = include("activity_9001643_Read")
function activity_9001643_Ctrl:ctor(properties)
	activity_9001643_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.EID_CELEBRATION_ACTIVITY
	self:resetData()
end
function activity_9001643_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_EID_CELEBRATION_INIT_TASK, handler(self, self.reqInitTaskRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_EID_CELEBRATION_RECEIVE_TASK, handler(self, self.reqReceiveTaskRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_EID_CELEBRATION_CLAIM_REWARD, handler(self, self.reqClaimRewardRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_EID_CELEBRATION_HELP_LIST, handler(self, self.reqHelpListRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_EID_CELEBRATION_HELP, handler(self, self.reqHelpRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_EID_CELEBRATION_CLAIM_CHAPTER_REWARD, handler(self, self.reqClaimChapterRewardRsp))
	self:registerNotify()
end
function activity_9001643_Ctrl:initClientData(data)
	if data and data[tostring(self.activityID)] then
		self.initData = data[tostring(self.activityID)]
		dump(self.initData, "activity_9001643_Ctrl:initClientData=====", 10)
	end
end
function activity_9001643_Ctrl:Logout()
	activity_9001643_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001643_Ctrl:resetData()
	;(nil).chapterStatus, _UPVALUE0_, _UPVALUE0_ = nil, nil, nil
	self.initData, (nil).taskStatus, _UPVALUE0_, (nil).helpCount = nil, nil, nil, 0
end
function activity_9001643_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.USER_ACTIVITY, handler(self, self.notifyHandler))
end
function activity_9001643_Ctrl:notifyHandler(event)
	dump(event.data, "activity_9001642_Ctrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		if v.activityID == self.activityID and v.notifyType == "updateData" then
			self.initData.chapterStatus = v.notifyData.chapterStatus
			self.initData.helpCount = v.notifyData.helpCount
			self.initData.shareTime = v.notifyData.shareTime
			self.initData.mapObjData = v.notifyData.mapObjData
			self.initData.taskStatus = v.notifyData.taskStatus
			_ENV = v.notifyData.taskStatus
			v.notifyData.taskStatus.msg = "MESSAGE_ACTIVITY_9001643_UPDATE"
			SoraDSendMessage(v.notifyData.taskStatus)
		end
	end
end
function activity_9001643_Ctrl:getReceiveStatusAndNum()
	local num = 0
	local chapterCfg = activity_9001643_Read.getChapterCfg()
	for k, v in ipairs(chapterCfg) do
		local rewardNum, isAllComplete = self:getChapterRewardTask(v.chapter)
		num = num + rewardNum
		if isAllComplete and v.chapter <= self:openDay() and not self:isChapterRewardClaimed(v.chapter) then
			num = num + 1
		end
	end
	local goNum = self:getGoNum()
	num = num + goNum
	return 0 < num, num
end
function activity_9001643_Ctrl:getGoNum()
	local num = 0
	local chapterCfg = activity_9001643_Read.getChapterCfg()
	for _, v in ipairs(chapterCfg) do
		for _, taskID in ipairs(v.task_id) do
			local status = self:getTaskStatus(taskID)
			if self:isTaskUnlock(v.chapter, taskID) and status == activity_9001643_Read.TASK_STATUS_ENUM.NONE then
				num = num + 1
			end
		end
	end
	return num
end
function activity_9001643_Ctrl:updateData(rspdata)
	if rspdata.chapterStatus then
		self.initData.chapterStatus = rspdata.chapterStatus
	end
	if rspdata.helpCount then
		self.initData.helpCount = rspdata.helpCount
	end
	if rspdata.mapObjData then
		self.initData.mapObjData = rspdata.mapObjData
	end
	if rspdata.taskStatus then
		self.initData.taskStatus = rspdata.taskStatus
	end
end
function activity_9001643_Ctrl:reqInitTask(taskID)
	serverproxy = nil
	;(nil).taskID = taskID
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_EID_CELEBRATION_INIT_TASK, nil)
end
function activity_9001643_Ctrl:reqReceiveTask(taskID, heroID)
	serverproxy = nil
	;(nil).taskID = taskID
	;(nil).heroID = heroID
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_EID_CELEBRATION_RECEIVE_TASK, nil)
end
function activity_9001643_Ctrl:reqClaimReward(taskID)
	serverproxy = nil
	;(nil).taskID = taskID
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_EID_CELEBRATION_CLAIM_REWARD, nil)
end
function activity_9001643_Ctrl:reqHelpList()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_EID_CELEBRATION_HELP_LIST, nil)
end
function activity_9001643_Ctrl:reqHelp(targetUid, taskID)
	serverproxy = nil
	;(nil).targetUid = targetUid
	;(nil).taskID = taskID
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_EID_CELEBRATION_HELP, nil)
end
function activity_9001643_Ctrl:reqClaimChapterReward(chapterID)
	serverproxy = nil
	;(nil).chapterID = chapterID
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_EID_CELEBRATION_CLAIM_CHAPTER_REWARD, nil)
end
function activity_9001643_Ctrl:reqInitTaskRsp(content)
	dump(content, "activity_9001643_Ctrl:reqInitTaskRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:updateData(content.rspdata)
		if self.initData.mapObjData then
			local pos = self:getMapObjPos()
			SoraDGotoWorldMapPoint(pos, true)
			SoraDRemoveAllPanelFromManager()
		end
	end
	_ENV = SoraDRemoveAllPanelFromManager
	SoraDRemoveAllPanelFromManager.msg = "MESSAGE_ACTIVITY_9001643_UPDATE"
	SoraDSendMessage(SoraDRemoveAllPanelFromManager)
end
function activity_9001643_Ctrl:reqReceiveTaskRsp(content)
	dump(content, "activity_9001643_Ctrl:reqReceiveTaskRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:updateData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_ACTIVITY_9001643_UPDATE"
		SoraDSendMessage(self)
	end
end
function activity_9001643_Ctrl:reqClaimRewardRsp(content)
	dump(content, "activity_9001643_Ctrl:reqClaimRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:updateData(content.rspdata)
		local rewards = content.rspdata.rewards
		if rewards and next(rewards) then
			SoraDMailGainItems(rewards, true)
		end
		_ENV = rewards
		rewards.msg = "MESSAGE_ACTIVITY_9001643_UPDATE"
		SoraDSendMessage(rewards)
	end
end
function activity_9001643_Ctrl:reqHelpListRsp(content)
	dump(content, "activity_9001643_Ctrl:reqHelpListRsp(content)", 10)
	local _ENV, helpList = dump, dump
	if content.err == gErrDef.Err_None then
		local list = content.rspdata
		helpList, _ENV = gErrDef.Err_None, gErrDef.Err_None
		for k, v in ipairs(list) do
			if v.uid ~= SoraDGetPlayerID() then
				v.isHelped = SoraDisInList(SoraDGetPlayerID(), v.helper)
				v.leftTime = v.data.endTime - v.curHp * v.reduceTime - serviceFunctions.systemTime()
				table.insert(helpList, v)
			else
			end
		end
		table.sort(helpList, function(a, b)
			if not (a.isHelped or b.isHelped) or a.isHelped and b.isHelped then
				return a.leftTime > b.leftTime
			else
				return not a.isHelped
			end
		end)
	end
	_ENV = table.sort
	table.sort.msg = "MESSAGE_ACTIVITY_9001643_HELPLIST"
	table.sort.helpList = helpList
	SoraDSendMessage(table.sort)
end
function activity_9001643_Ctrl:reqHelpRsp(content)
	dump(content, "activity_9001643_Ctrl:reqHelpRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:updateData(content.rspdata)
		local rewards = content.rspdata.rewards
		if rewards and next(rewards) then
			SoraDMailGainItems(rewards, true)
		end
		local taskID = content.data.taskID
		local cfg = activity_9001643_Read.getTaskCfg(taskID)
		_ENV = nil
		;(nil).taskname = i18n(cfg.task_name)
		local strContent = i18n("eidal_celebration_text29", nil)
		_ENV = "eidal_celebration_text29"
		;("eidal_celebration_text29").contentType = gChatMailContentType.content_text
		local ("eidal_celebration_text29").content, mailContent = strContent, "eidal_celebration_text29"
		activity_9001643_Read = cfg.task_name
		cfg.task_name[1] = content.data.targetUid
		SoraDGetCtrl("mailCtrl"):sendMultipleChatMail(cfg.task_name, mailContent)
		_ENV = SoraDGetCtrl("mailCtrl")
		SoraDGetCtrl("mailCtrl").msg = "MESSAGE_ACTIVITY_9001643_UPDATE"
		SoraDSendMessage((SoraDGetCtrl("mailCtrl")))
	elseif content.err == gErrDef.Err_EID_CELEBRATION_HELP then
		SoraDShowMsgTip(i18n("common_text_2870"))
	end
end
function activity_9001643_Ctrl:reqClaimChapterRewardRsp(content)
	dump(content, "activity_9001643_Ctrl:reqClaimChapterRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:updateData(content.rspdata)
		local rewards = content.rspdata.rewards
		if rewards and next(rewards) then
			SoraDMailGainItems(rewards, true)
		end
		_ENV = rewards
		rewards.msg = "MESSAGE_ACTIVITY_9001643_UPDATE"
		SoraDSendMessage(rewards)
	end
end
function activity_9001643_Ctrl:isChapterRewardClaimed(chapter)
	return self.initData.chapterStatus[tostring(chapter)] and true or false
end
function activity_9001643_Ctrl:openDay()
	local param = SoraDGetCtrl("activityShowCtrl"):getActivityData(self.activityID)
	return math.ceil((serviceFunctions.systemTime() - param.begintime) / 86400)
end
function activity_9001643_Ctrl:isChapterUnlock(chapter)
	if chapter == 1 then
		return true
	else
		local doneNum, isAllComplete = self:getChapterDoneTask(chapter - 1)
		return isAllComplete and chapter <= self:openDay()
	end
end
function activity_9001643_Ctrl:getChapterUnlockTime(chapter)
	local param = SoraDGetCtrl("activityShowCtrl"):getActivityData(self.activityID)
	return param.begintime + (chapter - 1) * 86400 - serviceFunctions.systemTime()
end
function activity_9001643_Ctrl:isTaskUnlock(chapter, taskID)
	local cfg = activity_9001643_Read.getChapterCfgById(chapter)
	if chapter == 1 then
		if cfg.task_id[1] == taskID then
			return true
		else
			local taskIndex = table.indexof(cfg.task_id, taskID)
			local preTaskID = cfg.task_id[taskIndex - 1]
			return self:isTaskDone(preTaskID)
		end
	else
		local doneNum, isAllComplete = self:getChapterDoneTask(chapter - 1)
		if isAllComplete and chapter <= self:openDay() then
			if cfg.task_id[1] == taskID then
				return true
			else
				local taskIndex = table.indexof(cfg.task_id, taskID)
				local preTaskID = cfg.task_id[taskIndex - 1]
				return self:isTaskDone(preTaskID)
			end
		else
			return false
		end
	end
end
function activity_9001643_Ctrl:getTaskStatus(taskID)
	return self.initData.taskStatus[tostring(taskID)] or activity_9001643_Read.TASK_STATUS_ENUM.NONE
end
function activity_9001643_Ctrl:isTaskDoIng()
	if self.initData.mapObjData and self.initData.mapObjData.endTime and self.initData.mapObjData.endTime - serviceFunctions.systemTime() > 0 then
		return self.initData.mapObjData.taskID
	end
end
function activity_9001643_Ctrl:getTaskLeftTime(taskID)
	if self.initData.mapObjData and self.initData.mapObjData.taskID == taskID and self.initData.mapObjData.endTime then
		return self.initData.mapObjData.endTime - serviceFunctions.systemTime()
	end
	return 0
end
function activity_9001643_Ctrl:getTaskByHelpCount(taskID)
	if self.initData.mapObjData and self.initData.mapObjData.taskID == taskID then
		return self.initData.mapObjData.byHelpCount
	end
	return 0
end
function activity_9001643_Ctrl:isTaskInited(taskID)
	if self.initData.mapObjData and self.initData.mapObjData.taskID == taskID then
		return true
	end
	return false
end
function activity_9001643_Ctrl:isTaskDone(taskID)
	local status = self.initData.taskStatus and self.initData.taskStatus[tostring(taskID)]
	if status then
		return status == activity_9001643_Read.TASK_STATUS_ENUM.COMPLETE or status == activity_9001643_Read.TASK_STATUS_ENUM.FINISH
	end
	return false
end
function activity_9001643_Ctrl:getChapterDoneTask(chapter)
	local num = 0
	if not self.initData.taskStatus then
		local activity_9001643_Read, taskStatus = self.initData.taskStatus, self.initData.taskStatus
	end
	local cfg = activity_9001643_Read.getChapterCfgById(chapter)
	for k, v in ipairs(cfg.task_id) do
		if taskStatus[tostring(v)] and (taskStatus[tostring(v)] == activity_9001643_Read.TASK_STATUS_ENUM.COMPLETE or taskStatus[tostring(v)] == activity_9001643_Read.TASK_STATUS_ENUM.FINISH) then
			num = num + 1
		end
	end
	return num, num >= #cfg.task_id
end
function activity_9001643_Ctrl:getChapterRewardTask(chapter)
	local num = 0
	local isAllDone = true
	if not self.initData.taskStatus then
		local activity_9001643_Read, taskStatus = self.initData.taskStatus, self.initData.taskStatus
	end
	local cfg = activity_9001643_Read.getChapterCfgById(chapter)
	for k, v in ipairs(cfg.task_id) do
		if taskStatus[tostring(v)] and taskStatus[tostring(v)] == activity_9001643_Read.TASK_STATUS_ENUM.COMPLETE then
			num = num + 1
		end
		if not self:isTaskDone(v) then
			isAllDone = false
		end
	end
	return num, isAllDone
end
function activity_9001643_Ctrl:getChapterReward(chapter)
	local num = 0
	local isAllDone = true
	if not self.initData.taskStatus then
		local activity_9001643_Read, taskStatus = self.initData.taskStatus, self.initData.taskStatus
	end
	local cfg = activity_9001643_Read.getChapterCfgById(chapter)
	for k, v in ipairs(cfg.task_id) do
		if taskStatus[tostring(v)] and taskStatus[tostring(v)] == activity_9001643_Read.TASK_STATUS_ENUM.COMPLETE then
			num = num + 1
		end
		if not self:isTaskDone(v) then
			isAllDone = false
		end
	end
	if isAllDone and not self.initData.chapterStatus[tostring(chapter)] then
		num = num + 1
	end
	return num, isAllDone
end
function activity_9001643_Ctrl:getMapObjPos()
	if self.initData.mapObjData then
		return cc.p(self.initData.mapObjData.x - 1, self.initData.mapObjData.y - 1)
	end
end
function activity_9001643_Ctrl:setShareTime(time)
	self.initData.shareTime = time or serviceFunctions.systemTime()
end
function activity_9001643_Ctrl:getShareCDTime()
	if self.initData.shareTime then
		local cdTime = include("constantRead").getConstValue("EMAIL_SHARING_CD_01")
		return self.initData.shareTime + cdTime - serviceFunctions.systemTime()
	end
	return 0
end
function activity_9001643_Ctrl:getHelpCount()
	return include("constantRead").getConstValue("EIDAL_CELEBRATION_HELP_DAILY_NUM") - (self.initData.helpCount or 0)
end
return activity_9001643_Ctrl

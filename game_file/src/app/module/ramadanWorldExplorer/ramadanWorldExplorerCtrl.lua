local kingdomMapUtil = include("kingdomMapUtil")
local ramadanWorldExplorerRead = include("ramadanWorldExplorerRead")
local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local ramadanWorldExplorerCtrl = class("ramadanWorldExplorerCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function ramadanWorldExplorerCtrl:ctor(properties)
	ramadanWorldExplorerCtrl.super.ctor(self, properties)
	self:resetData()
	self.activityID = gActivityTimeActivityID.RAMADAN_WORLD_EXPLORER
end
function ramadanWorldExplorerCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_RAMADAN_WORLD_EXPLORER_MODULE, gCmd.REQ_RAMADAN_WORLD_EXPLORER_DATA, handler(self, self.reqRamadanWorldExplorerDataRsp))
	msgCtrl.register(gCmd.CMD_RAMADAN_WORLD_EXPLORER_MODULE, gCmd.REQ_RAMADAN_WORLD_EXPLORER_COMPLETE_TASK, handler(self, self.reqRamadanWorldExplorerCompleteTaskRsp))
	msgCtrl.register(gCmd.CMD_RAMADAN_WORLD_EXPLORER_MODULE, gCmd.REQ_RAMADAN_WORLD_EXPLORER_TASK_REWARD, handler(self, self.reqRamadanWorldExplorerTaskRewardRsp))
	msgCtrl.register(gCmd.CMD_RAMADAN_WORLD_EXPLORER_MODULE, gCmd.REQ_RAMADAN_WORLD_EXPLORER_PLAN_REWARD, handler(self, self.reqRamadanWorldExplorerPlanRewardRsp))
	msgCtrl.register(gCmd.CMD_RAMADAN_WORLD_EXPLORER_MODULE, gCmd.REQ_RAMADAN_WORLD_EXPLORER_TASK_TRADE_VISIT, handler(self, self.reqRamadanWorldExplorerTaskTradeVisitRsp))
	self:registerNotify()
end
function ramadanWorldExplorerCtrl:Logout()
	ramadanWorldExplorerCtrl.super.Logout(self)
	self:resetData()
end
function ramadanWorldExplorerCtrl:resetData()
	self.mapObjects, _UPVALUE0_, self.activityData, _UPVALUE0_ = nil, nil, nil, nil
end
function ramadanWorldExplorerCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.RAMADAN_WORLD_EXPLORER, handler(self, self.notifyHandler))
end
function ramadanWorldExplorerCtrl:notifyHandler(event)
	dump(event.data, "ramadanWorldExplorerCtrl:notifyHandler", 10)
	for _, v in ipairs(event.data) do
		if v.taskCompletedCount > (self.activityData.taskCompletedCount or 0) then
			local parentView = SoraDSearchPanelFromManagerByName("RamadanWorldExplorerTask")
			if parentView then
				_ENV = nil
				;(nil).taskIdx = 0
				parentView:updateView(nil)
			else
				_ENV = nil
				;(nil).taskIdx = 0
				uiManager:show("RamadanWorldExplorerTask", nil)
			end
		end
		self.activityData = v
		_ENV = uiManager.show
		uiManager.show.msg = "MESSAGE_RAMADAN_WORLD_EXPLORER_TASK_UPDATE"
		SoraDSendMessage(uiManager.show)
	end
end
function ramadanWorldExplorerCtrl:sendReqInitDataMsg()
	if clientEventMgr.judgeIsOpen(self.activityID) then
		_ENV = nil
		serverproxy:Request(gCmd.CMD_RAMADAN_WORLD_EXPLORER_MODULE, gCmd.REQ_RAMADAN_WORLD_EXPLORER_DATA, nil)
	end
end
function ramadanWorldExplorerCtrl:reqRamadanWorldExplorerCompleteTask(taskIdx)
	serverproxy = nil
	;(nil).taskIdx = taskIdx
	serverproxy:Request(gCmd.CMD_RAMADAN_WORLD_EXPLORER_MODULE, gCmd.REQ_RAMADAN_WORLD_EXPLORER_COMPLETE_TASK, nil)
end
function ramadanWorldExplorerCtrl:reqRamadanWorldExplorerTaskReward(taskIdx)
	serverproxy = nil
	;(nil).taskIdx = taskIdx
	serverproxy:Request(gCmd.CMD_RAMADAN_WORLD_EXPLORER_MODULE, gCmd.REQ_RAMADAN_WORLD_EXPLORER_TASK_REWARD, nil)
end
function ramadanWorldExplorerCtrl:reqRamadanWorldExplorerPlanReward(idx)
	serverproxy = nil
	;(nil).idx = idx
	serverproxy:Request(gCmd.CMD_RAMADAN_WORLD_EXPLORER_MODULE, gCmd.REQ_RAMADAN_WORLD_EXPLORER_PLAN_REWARD, nil)
end
function ramadanWorldExplorerCtrl:reqRamadanWorldExplorerTaskTradeVisit(taskIdx)
	serverproxy = nil
	;(nil).taskIdx = taskIdx
	serverproxy:Request(gCmd.CMD_RAMADAN_WORLD_EXPLORER_MODULE, gCmd.REQ_RAMADAN_WORLD_EXPLORER_TASK_TRADE_VISIT, nil)
end
function ramadanWorldExplorerCtrl:reqRamadanWorldExplorerDataRsp(content)
	dump(content, "ramadanWorldExplorerCtrl:reqRamadanWorldExplorerDataRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.activityData = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_RAMADAN_WORLD_EXPLORER_TASK_UPDATE"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function ramadanWorldExplorerCtrl:reqRamadanWorldExplorerCompleteTaskRsp(content)
	dump(content, "ramadanWorldExplorerCtrl:reqRamadanWorldExplorerCompleteTaskRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.activityData = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_RAMADAN_WORLD_EXPLORER_TASK_UPDATE"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function ramadanWorldExplorerCtrl:reqRamadanWorldExplorerTaskRewardRsp(content)
	dump(content, "ramadanWorldExplorerCtrl:reqRamadanWorldExplorerTaskRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.activityData = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_RAMADAN_WORLD_EXPLORER_TASK_UPDATE"
		SoraDSendMessage(gErrDef.Err_None)
		local taskIdx = content.data.taskIdx or 0
		if not ramadanWorldExplorerRead.getTaskRewardByTaskID(self.activityData.tasks[taskIdx] and self.activityData.tasks[taskIdx].taskId) then
			local _ENV, rewards = ramadanWorldExplorerRead.getTaskRewardByTaskID(self.activityData.tasks[taskIdx] and self.activityData.tasks[taskIdx].taskId), ramadanWorldExplorerRead.getTaskRewardByTaskID(self.activityData.tasks[taskIdx] and self.activityData.tasks[taskIdx].taskId)
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		SoraDMailGainItems(serviceFunctions.tableFormat(rewards, nil), true)
	end
end
function ramadanWorldExplorerCtrl:reqRamadanWorldExplorerPlanRewardRsp(content)
	dump(content, "ramadanWorldExplorerCtrl:reqRamadanWorldExplorerPlanRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.activityData = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_RAMADAN_WORLD_EXPLORER_TASK_UPDATE"
		SoraDSendMessage(gErrDef.Err_None)
		local idx = content.data.idx or 0
		local info = ramadanWorldExplorerRead.getProgressInfoByIndex(idx)
		if not info.reward then
			_ENV = info.reward
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		local rewards = serviceFunctions.tableFormat(info.reward, nil)
		SoraDMailGainItems(rewards, true)
	end
end
function ramadanWorldExplorerCtrl:reqRamadanWorldExplorerTaskTradeVisitRsp(content)
	dump(content, "ramadanWorldExplorerCtrl:reqRamadanWorldExplorerTaskTradeVisitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
	end
end
function ramadanWorldExplorerCtrl:getTaskIdxByMapInstanceID(instanceID)
	if not self.activityData.tasks then
		_ENV = self.activityData.tasks
	end
	for i, v in ipairs(self.activityData.tasks) do
		if v.mapObjId == instanceID then
			return i
		end
	end
	return 0
end
function ramadanWorldExplorerCtrl:getTaskList()
	local _ENV, ret
	if not self.activityData.tasks then
		_ENV = self.activityData.tasks
	end
	for i, v in ipairs(self.activityData.tasks) do
		if not v.hasGotReward then
			local _ENV, object = v.hasGotReward, v.hasGotReward
			object.isCompleted = v.isCompleted
			object.taskIdx = i
			_ENV, object.taskId = v.taskId, v.taskId
			object.mapObj, v.taskId.id = v.taskId, v.mapObjId
			kingdomMapUtil.splitMapObjId(object.mapObj)
			table.insert(ret, object)
		end
	end
	table.sort(ret, function(l, r)
		if l.isCompleted == r.isCompleted then
			return l.taskIdx < r.taskIdx
		else
			return l.isCompleted
		end
	end)
	return ret
end
function ramadanWorldExplorerCtrl:isBoxRewardGot(index)
	if self.activityData.planRewardRecord and self.activityData.planRewardRecord[index] then
		return true
	end
	return false
end
function ramadanWorldExplorerCtrl:getFinishTaskNum()
	return self.activityData.taskCompletedCount or 0
end
function ramadanWorldExplorerCtrl:getTaskResetTime()
	local nowTime = serviceFunctions.systemTime()
	local beginTime = serviceFunctions.getTodayZeroHourUTC(nowTime)
	if nowTime < beginTime + 43200 then
		return beginTime + 43200
	else
		return beginTime + 86400
	end
end
function ramadanWorldExplorerCtrl:isTaskFinished(taskIdx)
	if self.activityData.tasks and self.activityData.tasks[taskIdx] then
		return self.activityData.tasks[taskIdx].isCompleted
	end
	return nil
end
function ramadanWorldExplorerCtrl:getTaskIDByIndex(index)
	if self.activityData.tasks and self.activityData.tasks[index] then
		return self.activityData.tasks[index].taskId
	end
	return 0
end
function ramadanWorldExplorerCtrl:getReceiveStatusAndNum()
	local num = self:getTaskRewardNum()
	local nowFinishNum = self:getFinishTaskNum()
	for i, v in ipairs(ramadanWorldExplorerRead.getProcessReward()) do
		if nowFinishNum >= v.plan and (not self.activityData.planRewardRecord or not self.activityData.planRewardRecord[i]) then
			num = num + 1
		end
	end
	return 0 < num, num
end
function ramadanWorldExplorerCtrl:getTaskRewardNum()
	local num = 0
	if not self.activityData.tasks then
		_ENV = self.activityData.tasks
	end
	for _, v in ipairs(self.activityData.tasks) do
		if v.isCompleted and not v.hasGotReward then
			num = num + 1
		end
	end
	return num
end
return ramadanWorldExplorerCtrl

local gamemodulec = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local ltBase = include("ltBase")
local secretBagCtrl = class("secretBagCtrl", gamemodulec)
secretBagCtrl.localClass, _ENV = "secretBagCtrl", "secretBagCtrl"
secretBagCtrl.localClass.kits_task_reward = require_data("kits_task_reward", true)
secretBagCtrl.localClass.kits_box_config = require_data("kits_box_config", true)
secretBagCtrl.localClass.kits_item_reward = require_data("kits_item_reward", true)
secretBagCtrl.localClass.bagItemID = secretBagCtrl.localClass.kits_item_reward.data[1].item
_ENV = secretBagCtrl.localClass.kits_item_reward.data[1].item
secretBagCtrl.localClass.kits_item_reward.data[1].item[1] = nil
secretBagCtrl.localClass.kits_item_reward.data[1].item[2] = function(...)
	mildGuideManager = nil
	mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.RECHARGE_GOLD, nil)
	SoraDRemoveAllPanelFromManager()
end
secretBagCtrl.localClass.kits_item_reward.data[1].item[3] = function(...)
	local expostulationLogic = include("expostulationLogic")
	if expostulationLogic.checkTrainQueue() then
		SoraDRemoveAllPanelFromManager()
		expostulationLogic.jumpToCamp()
	else
		print("队列已满")
	end
end
secretBagCtrl.localClass.kits_item_reward.data[1].item[4] = function(...)
	mildGuideManager = nil
	mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.KILL_MONSTER, nil)
	SoraDRemoveAllPanelFromManager()
end
secretBagCtrl.localClass.kits_item_reward.data[1].item[5] = function(...)
	SoraDRemoveAllPanelFromManager()
	_ENV = nil
	mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.EVIL_PALACE, nil)
end
secretBagCtrl.localClass.kits_item_reward.data[1].item[6] = function(...)
	mildGuideManager = nil
	mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.MYSTICAL_STORE, nil)
	SoraDRemoveAllPanelFromManager()
end
secretBagCtrl.localClass.kits_item_reward.data[1].item[7] = function(...)
	mildGuideManager = nil
	mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.ALLIANCE_HUNT, nil)
	SoraDRemoveAllPanelFromManager()
end
secretBagCtrl.localClass.kits_item_reward.data[1].item[8] = function(...)
	mildGuideManager = nil
	mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.MAKE_A_WISH, nil)
	SoraDRemoveAllPanelFromManager()
end
secretBagCtrl.localClass.taskJumpFun, secretBagCtrl.localClass.kits_item_reward.data[1].item[9] = secretBagCtrl.localClass.kits_item_reward.data[1].item, function(...)
	mildGuideManager = nil
	mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.COLLECT_RESOURCE, nil)
	SoraDRemoveAllPanelFromManager()
end
secretBagCtrl.localClass.taskid_index_kits_task_reward = (function(...)
	local _ENV, ret
	for i, v in ipairs(secretBagCtrl.localClass.kits_task_reward.data) do
		ret[tostring(v.taskId)] = v
	end
	return ret
end)()
function secretBagCtrl.localClass.getTaskData(taskId, group)
	for k, v in pairs(secretBagCtrl.localClass.taskid_index_kits_task_reward) do
		if secretBagCtrl.localClass.taskid_index_kits_task_reward[tostring(taskId)] and group == v.group then
			return secretBagCtrl.localClass.taskid_index_kits_task_reward[tostring(taskId)]
		end
	end
end
function secretBagCtrl.localClass.getBoxInfo(taskNum, curLv, group)
	local _ENV, info
	for i, v in ipairs(secretBagCtrl.localClass.kits_box_config.data) do
		if taskNum == v.taskNum and curLv >= v.LV[1] and curLv <= v.LV[2] and group == v.group then
			info = v
		end
	end
	return info
end
function secretBagCtrl.localClass.getBagInfo(curLv, group)
	local _ENV, info
	for i, v in ipairs(secretBagCtrl.localClass.kits_item_reward.data) do
		if curLv >= v.LV[1] and curLv <= v.LV[2] and group == v.group then
			info = v
		end
	end
	return info
end
function secretBagCtrl.localClass.jumpToDo(taskId)
	local info = secretBagCtrl.localClass.taskid_index_kits_task_reward[tostring(taskId)]
	if secretBagCtrl.localClass.taskJumpFun[info.type] then
		secretBagCtrl.localClass.taskJumpFun[info.type]()
	end
end
function secretBagCtrl.localClass.checkToDo(taskId)
	local info = secretBagCtrl.localClass.taskid_index_kits_task_reward[tostring(taskId)]
	return secretBagCtrl.localClass.taskJumpFun[info.type]
end
function secretBagCtrl:initialize()
	_ENV = nil
	;(nil).cmd = gCmd.CMD_KITS_ACTIVITY_MODULE
	;(nil).data, _ENV, (nil).subcmd = gCmd.REQ_KITS_INIT, gCmd.REQ_KITS_INIT, gCmd.REQ_KITS_INIT
	local msg
	serverproxy:SendMsg(msg)
end
function secretBagCtrl:gainReward(taskId)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_KITS_ACTIVITY_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_KITS_RECEIVE_TASK_REWARD, gCmd.REQ_KITS_RECEIVE_TASK_REWARD
	;(nil).data, gCmd.REQ_KITS_RECEIVE_TASK_REWARD.taskId = gCmd.REQ_KITS_RECEIVE_TASK_REWARD, taskId
	local msg
	serverproxy:SendMsg(msg)
end
function secretBagCtrl:gainBoxReward(taskNum)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_KITS_ACTIVITY_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_KITS_RECEIVE_BOX_REWARD, gCmd.REQ_KITS_RECEIVE_BOX_REWARD
	;(nil).data, gCmd.REQ_KITS_RECEIVE_BOX_REWARD.taskNum = gCmd.REQ_KITS_RECEIVE_BOX_REWARD, taskNum
	local msg
	serverproxy:SendMsg(msg)
end
function secretBagCtrl:openBag(count)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_KITS_ACTIVITY_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_KITS_OPEN_KITS_REWARD, gCmd.REQ_KITS_OPEN_KITS_REWARD
	;(nil).data, gCmd.REQ_KITS_OPEN_KITS_REWARD.count = gCmd.REQ_KITS_OPEN_KITS_REWARD, count or 1
	local msg
	serverproxy:SendMsg(msg)
end
function secretBagCtrl:initializeRsp(content)
	dump(content, "secretBagCtrl:initializeRsp", 10)
	if content.err == gErrDef.Err_None then
	else
	end
end
function secretBagCtrl:gainRewardRsp(content)
	dump(content, "secretBagCtrl:gainRewardRsp", 10)
	if content.err == gErrDef.Err_None then
		self.secretBagData = content.rspdata
		SoraDMailGainItems(content.rspdata.reward, true)
		self.secretBagData.reward = nil
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_SERVER_SECRETBAG_GAINTASK"
		SoraDSendMessage(content.rspdata.reward)
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		content.rspdata.reward.eventID = gActivityTimeActivityID.KITS_ACTIVITY
		SoraDSendMessage(content.rspdata.reward)
	else
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_SERVER_SECRETBAG_ERRBACK"
		SoraDSendMessage(content.rspdata.reward)
	end
end
function secretBagCtrl:gainBoxRewardRsp(content)
	dump(content, "secretBagCtrl:gainBoxRewardRsp", 10)
	if content.err == gErrDef.Err_None then
		self.secretBagData = content.rspdata
		local itemList = content.rspdata.reward
		local _ENV, transList = gErrDef.Err_None, gErrDef.Err_None
		for i, v in ipairs(itemList) do
			if transList[tostring(v.id)] then
				transList[tostring(v.id)] = transList[tostring(v.id)] + v.count
			else
				transList[tostring(v.id)] = v.count
			end
		end
		SoraDOpenGiftView(transList)
		self.secretBagData.reward = nil
		_ENV = transList
		transList.msg = "MESSAGE_SERVER_SECRETBAG_OPENBOX"
		SoraDSendMessage(transList)
		_ENV = transList
		transList.msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		transList.eventID = gActivityTimeActivityID.KITS_ACTIVITY
		SoraDSendMessage(transList)
	else
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_SECRETBAG_ERRBACK"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function secretBagCtrl:openBagRsp(content)
	dump(content, "secretBagCtrl:openBagRsp", 10)
	if content.err == gErrDef.Err_None then
		local itemList = content.rspdata.reward
		local _ENV, transList = gErrDef.Err_None, gErrDef.Err_None
		for i, v in ipairs(itemList) do
			if transList[tostring(v.id)] then
				transList[tostring(v.id)] = transList[tostring(v.id)] + v.count
			else
				transList[tostring(v.id)] = v.count
			end
		end
		_ENV = ipairs(itemList)
		ipairs(itemList).msg = "MESSAGE_SERVER_SECRETBAG_OPENBAG"
		ipairs(itemList).itemList = transList
		SoraDSendMessage(ipairs(itemList))
		_ENV = ipairs(itemList)
		ipairs(itemList).msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		ipairs(itemList).eventID = gActivityTimeActivityID.KITS_ACTIVITY
		SoraDSendMessage(ipairs(itemList))
	else
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_SECRETBAG_ERRBACK"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function secretBagCtrl:notifyDataRsp(event)
	if event.data then
		for _, content in pairs(event.data) do
			self.secretBagData = content
		end
		_ENV = pairs(event.data)
		pairs(event.data).msg = "MESSAGE_SERVER_SECRETBAG_REFRESH"
		SoraDSendMessage(pairs(event.data))
	end
end
function secretBagCtrl:getsecretBagData(...)
	return self.secretBagData
end
function secretBagCtrl:getsecretBagTaskCount(...)
	local ret = 0
	local gametop = gModuleMgr.getObject("gametop")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local group = activityShowCtrl:getParamByID(gActivityTimeActivityID.KITS_ACTIVITY).classtype or 1
	for i, v in ipairs(self.secretBagData.taskData) do
		local amount = secretBagCtrl.localClass.getTaskData(v.taskId, group).amount
		if amount <= v.finishCount then
			ret = ret + 1
		end
	end
	return ret
end
function secretBagCtrl:getsecretBagBoxCount(...)
	local cur = self:getsecretBagTaskCount()
	local ret = 0
	for k, v in pairs(self.secretBagData.boxData) do
		if not v.receive and cur >= v.taskNum then
			ret = ret + 1
		end
	end
	return ret
end
function secretBagCtrl:getIsAnyTaskCanReceive(...)
	local gametop = gModuleMgr.getObject("gametop")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local group = activityShowCtrl:getParamByID(gActivityTimeActivityID.KITS_ACTIVITY).classtype or 1
	for k, v in pairs(self.secretBagData.taskData) do
		if not v.receive then
			local tblData = secretBagCtrl.localClass.getTaskData(v.taskId, group)
			if v.finishCount >= tblData.amount then
				return true
			end
		end
	end
	return false
end
function secretBagCtrl:ctor(properties)
	secretBagCtrl.super.ctor(self, properties)
	self:resetData()
end
function secretBagCtrl:resetData()
	self.secretBagData, _UPVALUE0_ = nil, nil
end
function secretBagCtrl:initClientData(data)
	if nil == data then
		return
	end
	dump(data, "secretBagCtrl:initClientData", 10)
	self.secretBagData = data
	self:registerNotify()
end
function secretBagCtrl:EnterGame()
	secretBagCtrl.super.EnterGame(self)
	msgCtrl.register(gCmd.CMD_KITS_ACTIVITY_MODULE, gCmd.REQ_KITS_INIT, handler(self, self.initializeRsp))
	msgCtrl.register(gCmd.CMD_KITS_ACTIVITY_MODULE, gCmd.REQ_KITS_RECEIVE_TASK_REWARD, handler(self, self.gainRewardRsp))
	msgCtrl.register(gCmd.CMD_KITS_ACTIVITY_MODULE, gCmd.REQ_KITS_RECEIVE_BOX_REWARD, handler(self, self.gainBoxRewardRsp))
	msgCtrl.register(gCmd.CMD_KITS_ACTIVITY_MODULE, gCmd.REQ_KITS_OPEN_KITS_REWARD, handler(self, self.openBagRsp))
end
function secretBagCtrl:getReceiveStatusAndNum(...)
	local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
	local bagCount = backpackCtrl:getItemCount(secretBagCtrl.localClass.bagItemID)
	if 0 < bagCount or self:getIsAnyTaskCanReceive() or 0 < self:getsecretBagBoxCount() then
		return true, -1
	else
		return false, 0
	end
end
function secretBagCtrl:registerNotify(...)
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.KITS_ACTIVITY, handler(self, self.notifyDataRsp))
end
function secretBagCtrl:Logout()
	secretBagCtrl.super.Logout(self)
	self:resetData()
end
return secretBagCtrl

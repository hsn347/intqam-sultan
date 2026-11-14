local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activityCommonKitchenCtrl = class("activityCommonKitchenCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activityCommonKitchenCtrl:ctor(properties)
	activityCommonKitchenCtrl.super.ctor(self, properties)
	self:resetData()
end
function activityCommonKitchenCtrl:EnterGame()
	local constantRead = include("constantRead")
	_ENV = "constantRead"
	_ENV = nil
	;(nil).module = gCmd.CMD_END_OF_RAMADAN_KITCHEN_MODULE
	;(nil).init = gCmd.REQ_END_OF_RAMADAN_KITCHEN_INIT
	;(nil).cook = gCmd.REQ_END_OF_RAMADAN_KITCHEN_COOKING
	;(nil).completeTask = gCmd.REQ_END_OF_RAMADAN_KITCHEN_COMPLETE_TASK
	;(nil).stageReward = gCmd.REQ_END_OF_RAMADAN_KITCHEN_STAGE_REWARD
	;(nil).achievementReward = gCmd.REQ_END_OF_RAMADAN_KITCHEN_ACHEVEMENT_REWARD
	;(nil).autoComplete = gCmd.REQ_END_OF_RAMADAN_KITCHEN_AUTO_COMPLETE
	;(nil).decreeReward = gCmd.REQ_END_OF_RAMADAN_KITCHEN_DECREE_REWARD
	;(nil).cookItemID = constantRead.getConstValue("EIDAL_KITCHEN_MATERIAL", 870402)
	;(nil).autoNeedCount = constantRead.getConstValue("EIDAL_KITCHEN_AUTO_SERVING", 80)
	;("constantRead")[gActivityTimeActivityID.NORMAL_ACTIVITY_9001699], (nil).notifyID = nil, gNotifyID.END_OF_RAMADAN_KITCHEN
	_ENV = nil
	;(nil).module = gCmd.CMD_OCTOPUS_KITCHEN_MODULE
	;(nil).init = gCmd.REQ_OCTOPUS_KITCHEN_DATA
	;(nil).cook = gCmd.REQ_OCTOPUS_KITCHEN_COOKING
	;(nil).completeTask = gCmd.REQ_OCTOPUS_KITCHEN_COMPLETE_TASK
	;(nil).refreshTask = gCmd.REQ_OCTOPUS_KITCHEN_REFRESH_TASK
	;(nil).stageReward = gCmd.REQ_OCTOPUS_KITCHEN_STAGE_REWARD
	;(nil).achievementReward = gCmd.REQ_OCTOPUS_KITCHEN_ACHEVEMENT_REWARD
	;(nil).autoComplete = gCmd.REQ_OCTOPUS_KITCHEN_AUTO_COMPLETE
	;(nil).cookItemID = constantRead.getConstValue("OCTOPUS_KITCHEN_MATERIAL", 870401)
	;(nil).autoNeedCount = constantRead.getConstValue("OCTOPUS_KITCHEN_AUTO_SERVING", 80)
	;(nil).refreshItemID = constantRead.getConstValue("OCTOPUS_KITCHEN_REFRESH_ITEM", 872801)
	self.cmdConfig, ("constantRead")[gActivityTimeActivityID.NORMAL_ACTIVITY_9001669], (nil).notifyID = "constantRead", nil, gNotifyID.OCTOPUS_KITCHEN
	for activityID, cmdCfg in pairs(self.cmdConfig) do
		msgCtrl.register(cmdCfg.module, cmdCfg.init, handler(self, self.reqInitDataRsp))
		msgCtrl.register(cmdCfg.module, cmdCfg.cook, handler(self, self.reqCookingRsp))
		msgCtrl.register(cmdCfg.module, cmdCfg.completeTask, handler(self, self.reqCompleteTaskRsp))
		if cmdCfg.refreshTask then
			msgCtrl.register(cmdCfg.module, cmdCfg.refreshTask, handler(self, self.reqRefreshTaskRsp))
		end
		msgCtrl.register(cmdCfg.module, cmdCfg.stageReward, handler(self, self.reqStageRewardRsp))
		msgCtrl.register(cmdCfg.module, cmdCfg.achievementReward, handler(self, self.reqAchievementRewardRsp))
		msgCtrl.register(cmdCfg.module, cmdCfg.autoComplete, handler(self, self.reqAutoCompleteRsp))
		if cmdCfg.decreeReward then
			msgCtrl.register(cmdCfg.module, cmdCfg.decreeReward, handler(self, self.reqDecreeRewardRsp))
		end
	end
	self:registerNotify()
end
function activityCommonKitchenCtrl:Logout()
	activityCommonKitchenCtrl.super.Logout(self)
	self:resetData()
end
function activityCommonKitchenCtrl:resetData(activityID)
	if activityID then
		self.activityData[activityID], _UPVALUE0_ = nil, nil
	else
		self.activityData, _UPVALUE0_ = self.activityData, self.activityData
	end
end
function activityCommonKitchenCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	for activityID, cmdCfg in pairs(self.cmdConfig) do
		if cmdCfg.notifyID then
			notifyCtrl:register(cmdCfg.notifyID, handlerEx(self, self.notifyHandler, activityID))
		end
	end
end
function activityCommonKitchenCtrl:notifyHandler(activityID, event)
	dump(event.data, "==activityCommonKitchenCtrl:notifyHandler==", 10)
	for k, v in ipairs(event.data) do
		local notifyType = v.notifyType
		local notifydata = v.notifyData
		if notifyType == "refresh" then
			self.activityData[activityID] = notifydata
		elseif notifyType == "buyGift" and notifydata.success then
			SoraDMailGainItems(notifydata.reward, true)
			self.activityData[activityID] = notifydata.initData
			_ENV = true
			;(true).activityID = activityID
			;(true).subMsg = "buyGift"
			self:sendMessage(true)
		end
	end
end
function activityCommonKitchenCtrl:updateInitData(activityID, rspdata)
	if activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001699 then
		if rspdata.rewards then
			SoraDMailGainItems(rspdata.rewards, true)
		end
		self.activityData[activityID] = rspdata.initData
	else
		if rspdata.rewards then
			SoraDMailGainItems(rspdata.rewards, true)
			rspdata.rewards = nil
		end
		self.activityData[activityID] = rspdata
	end
end
function activityCommonKitchenCtrl:sendReqInitDataMsg(activityID)
	self:reqInitData(activityID)
end
function activityCommonKitchenCtrl:reqInitData(activityID)
	local cmdCfg = self.cmdConfig[activityID]
	serverproxy, serverproxy = nil, nil
	;(nil).activityID = activityID
	serverproxy:Request(cmdCfg.module, cmdCfg.init, nil, nil)
end
function activityCommonKitchenCtrl:reqInitDataRsp(content)
	dump(content, "activityCommonKitchenCtrl:reqInitDataRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local activityID = content.clientData.activityID
		if activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001699 then
			self.activityData[activityID] = content.rspdata
		else
			self:updateInitData(activityID, content.rspdata)
		end
		_ENV = activityID
		activityID.activityID = activityID
		activityID.subMsg = "init"
		self:sendMessage(activityID)
	end
end
function activityCommonKitchenCtrl:reqCooking(activityID, count)
	local cmdCfg = self.cmdConfig[activityID]
	serverproxy = nil
	serverproxy, (nil).count = nil, count
	;(nil).activityID = activityID
	serverproxy:Request(cmdCfg.module, cmdCfg.cook, nil, nil)
end
function activityCommonKitchenCtrl:reqCookingRsp(content)
	dump(content, "activityCommonKitchenCtrl:reqCookingRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local activityID = content.clientData.activityID
		local rspdata = content.rspdata
		if activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001699 then
			self.activityData[activityID] = rspdata.initData
		else
			self.activityData[activityID] = rspdata
		end
		_ENV = nil
		;(nil).activityID = activityID
		;(nil).subMsg = "cook"
		;(nil).rewards = rspdata.rewards
		self:sendMessage(nil)
		rspdata.rewards = nil
	end
end
function activityCommonKitchenCtrl:reqCompleteTask(activityID, taskID, itemID)
	local cmdCfg = self.cmdConfig[activityID]
	serverproxy = nil
	;(nil).taskID = taskID
	serverproxy, (nil).itemID = nil, itemID
	;(nil).activityID = activityID
	serverproxy:Request(cmdCfg.module, cmdCfg.completeTask, nil, nil)
end
function activityCommonKitchenCtrl:reqCompleteTaskRsp(content)
	dump(content, "activityCommonKitchenCtrl:reqCompleteTaskRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local activityID = content.clientData.activityID
		self:updateInitData(activityID, content.rspdata)
		local taskID = content.data.taskID
		_ENV = content.rspdata
		content.rspdata.activityID = activityID
		content.rspdata.subMsg = "completeTask"
		content.rspdata.taskID = taskID
		self:sendMessage(content.rspdata)
	end
end
function activityCommonKitchenCtrl:reqRefreshTask(activityID, taskID)
	local cmdCfg = self.cmdConfig[activityID]
	serverproxy = nil
	serverproxy, (nil).taskID = nil, taskID
	;(nil).activityID = activityID
	serverproxy:Request(cmdCfg.module, cmdCfg.refreshTask, nil, nil)
end
function activityCommonKitchenCtrl:reqRefreshTaskRsp(content)
	dump(content, "activityCommonKitchenCtrl:reqRefreshTaskRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local activityID = content.clientData.activityID
		self:updateInitData(activityID, content.rspdata)
		local taskID = content.data.taskID
		_ENV = content.rspdata
		content.rspdata.activityID = activityID
		content.rspdata.subMsg = "refreshTask"
		content.rspdata.taskID = taskID
		self:sendMessage(content.rspdata)
	end
end
function activityCommonKitchenCtrl:reqStageReward(activityID, stageID)
	local cmdCfg = self.cmdConfig[activityID]
	serverproxy = nil
	serverproxy, (nil).stageID = nil, stageID
	;(nil).activityID = activityID
	serverproxy:Request(cmdCfg.module, cmdCfg.stageReward, nil, nil)
end
function activityCommonKitchenCtrl:reqStageRewardRsp(content)
	dump(content, "activityCommonKitchenCtrl:reqStageRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local activityID = content.clientData.activityID
		self:updateInitData(activityID, content.rspdata)
		_ENV = activityID
		activityID.activityID = activityID
		activityID.subMsg = "stage"
		self:sendMessage(activityID)
	end
end
function activityCommonKitchenCtrl:reqAchievementReward(activityID, achievementID)
	local cmdCfg = self.cmdConfig[activityID]
	serverproxy = nil
	serverproxy, (nil).achievementID = nil, achievementID
	;(nil).activityID = activityID
	serverproxy:Request(cmdCfg.module, cmdCfg.achievementReward, nil, nil)
end
function activityCommonKitchenCtrl:reqAchievementRewardRsp(content)
	dump(content, "activityCommonKitchenCtrl:reqAchievementRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local activityID = content.clientData.activityID
		self:updateInitData(activityID, content.rspdata)
		_ENV = activityID
		activityID.activityID = activityID
		activityID.subMsg = "achievementReward"
		self:sendMessage(activityID)
	end
end
function activityCommonKitchenCtrl:reqAutoComplete(activityID)
	local cmdCfg = self.cmdConfig[activityID]
	serverproxy, serverproxy = nil, nil
	;(nil).activityID = activityID
	serverproxy:Request(cmdCfg.module, cmdCfg.autoComplete, nil, nil)
end
function activityCommonKitchenCtrl:reqAutoCompleteRsp(content)
	dump(content, "activityCommonKitchenCtrl:reqAutoCompleteRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local _ENV, autoData = content.err, content.err
		local activityID = content.clientData.activityID
		if activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001699 then
			_ENV, self.activityData[activityID] = self.activityData, content.rspdata.initData
			self.activityData.completeNum = content.rspdata.completeNum
			self.activityData.costItem = content.rspdata.costItem
			autoData, self.activityData.rewards = self.activityData, content.rspdata.rewards
		else
			self.activityData[activityID] = content.rspdata.data
			autoData = content.rspdata.ret
		end
		_ENV = nil
		;(nil).activityID = activityID
		;(nil).subMsg = "auto"
		self:sendMessage(nil)
		_ENV = nil
		;(nil).activityID = activityID
		;(nil).data = autoData
		uiManager:show("Activity_9001669_Auto", nil)
	end
end
function activityCommonKitchenCtrl:reqDecreeReward(activityID)
	local cmdCfg = self.cmdConfig[activityID]
	serverproxy, serverproxy = nil, nil
	;(nil).activityID = activityID
	serverproxy:Request(cmdCfg.module, cmdCfg.decreeReward, nil, nil)
end
function activityCommonKitchenCtrl:reqDecreeRewardRsp(content)
	dump(content, "activityCommonKitchenCtrl:reqDecreeRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local activityID = content.clientData.activityID
		self:updateInitData(activityID, content.rspdata)
		_ENV = activityID
		activityID.activityID = activityID
		activityID.subMsg = "decreeReward"
		self:sendMessage(activityID)
	end
end
function activityCommonKitchenCtrl:sendMessage(data)
	data.msg = "MESSAGE_ACTIVITY_COMMON_KITCHEN_UPDATE"
	SoraDSendMessage(data)
end
function activityCommonKitchenCtrl:getActivityData(activityID)
	if not self.activityData[activityID] then
		_UPVALUE0_ = self.activityData[activityID]
	end
	return self.activityData[activityID]
end
function activityCommonKitchenCtrl:getCompleteCount(activityID)
	local initData = self:getActivityData(activityID)
	return initData.completeCount or 0
end
function activityCommonKitchenCtrl:getPoint(activityID)
	local initData = self:getActivityData(activityID)
	return initData.point or 0
end
function activityCommonKitchenCtrl:getStageScore(activityID)
	if activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001699 then
		return self:getPoint(activityID)
	else
		return self:getCompleteCount(activityID)
	end
end
function activityCommonKitchenCtrl:getTaskList(activityID)
	local initData = self:getActivityData(activityID)
	if not initData.taskList then
		_UPVALUE0_ = initData.taskList
	end
	return initData.taskList
end
function activityCommonKitchenCtrl:getTaskData(activityID, taskID)
	local taskList = self:getTaskList(activityID)
	return taskList[taskID]
end
function activityCommonKitchenCtrl:getStageMark(activityID)
	local initData = self:getActivityData(activityID)
	if not initData.stageMark then
		_UPVALUE0_ = initData.stageMark
	end
	return initData.stageMark
end
function activityCommonKitchenCtrl:getBoxRewardDataStatus(activityID, index, num)
	local stageMark = self:getStageMark(activityID)
	if stageMark[tostring(index)] then
		return gBtnTargetStatusDef.GOT
	end
	if num <= self:getStageScore(activityID) then
		return gBtnTargetStatusDef.GET
	else
		return gBtnTargetStatusDef.GO
	end
end
function activityCommonKitchenCtrl:getCookingStatistics(activityID)
	local initData = self:getActivityData(activityID)
	if not initData.cookingStatistics then
		_UPVALUE0_ = initData.cookingStatistics
	end
	return initData.cookingStatistics
end
function activityCommonKitchenCtrl:getCookCount(activityID, itemID)
	local cookingStatistics = self:getCookingStatistics(activityID)
	return cookingStatistics[tostring(itemID)] or 0
end
function activityCommonKitchenCtrl:getAchievement(activityID)
	local initData = self:getActivityData(activityID)
	if not initData.achievement then
		_UPVALUE0_ = initData.achievement
	end
	return initData.achievement
end
function activityCommonKitchenCtrl:getAchivevementState(activityID, achievementID)
	local achievement = self:getAchievement(activityID)
	if achievement[tostring(achievementID)] then
		return gBtnTargetStatusDef.GOT
	end
	local info = self:getAchivevementInfo(activityID, achievementID)
	local isReach = info.barValue >= info.barMax
	if isReach then
		return gBtnTargetStatusDef.GET
	else
		return gBtnTargetStatusDef.GO
	end
end
function activityCommonKitchenCtrl:getAchivevementInfo(activityID, achievementID, needDes)
	local activityCommonKitchenRead = include("activityCommonKitchenRead")
	local cfg = activityCommonKitchenRead.getAchivementConfig(activityID, achievementID)
	local taskDes = ""
	local barMax, barValue = 0, 0
	local achivementType = cfg.achivementType
	if achivementType == 1 then
		local foodIDList = activityCommonKitchenRead.getNormalFoodIDList(activityID)
		barMax = #foodIDList
		for __, itemID in ipairs(foodIDList) do
			if 0 < self:getCookCount(activityID, itemID) then
				barValue = barValue + 1
			end
		end
		if needDes then
			_ENV = ipairs(foodIDList)
			ipairs(foodIDList).val = barMax
			taskDes = i18n(cfg.taskDes, ipairs(foodIDList))
		end
	elseif achivementType == 2 then
		local foodIDList = activityCommonKitchenRead.getSpecFoodIDList(activityID)
		barMax = #foodIDList
		for __, itemID in ipairs(foodIDList) do
			if 0 < self:getCookCount(activityID, itemID) then
				barValue = barValue + 1
			end
		end
		if needDes then
			taskDes = i18n(cfg.taskDes)
		end
	elseif achivementType == 3 then
		barMax = cfg.require[1]
		_ENV = cfg.taskDes
		cfg.taskDes.val = barMax
		taskDes = i18n(cfg.taskDes, cfg.taskDes)
		barValue = self:getCompleteCount(activityID)
	elseif achivementType == 4 then
		local itemID = cfg.require[1]
		barMax = cfg.require[2]
		if needDes then
			local itemDesRead = include("itemDesRead")
			local itemName = itemDesRead.getName(itemID)
			_ENV = nil
			;(nil).val1 = itemName
			;(nil).val2 = barMax
			taskDes = i18n(cfg.taskDes, nil)
		end
		barValue = self:getCookCount(activityID, itemID)
	elseif needDes then
		taskDes = i18n(cfg.taskDes)
	end
	_ENV = i18n(cfg.taskDes)
	i18n(cfg.taskDes).taskDes = taskDes
	i18n(cfg.taskDes).barValue = barValue
	local i18n(cfg.taskDes).barMax, ret = barMax, i18n(cfg.taskDes)
	return ret
end
function activityCommonKitchenCtrl:getReceiveStatusAndNum(activityID)
	if not clientEventMgr.judgeIsOpen(activityID) then
		return false
	end
	local num = 0
	local _ret, _num = self:getReceiveStatusAndNum1(activityID)
	if _ret then
		num = num + _num
	end
	local _ret, _num = self:getReceiveStatusAndNum2(activityID)
	if _ret then
		num = num + _num
	end
	return 0 < num, num
end
function activityCommonKitchenCtrl:getReceiveStatusAndNum1(activityID, noNum)
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local activityCommonKitchenRead = include("activityCommonKitchenRead")
	local num = 0
	local cookItemID = self:getCookItemID(activityID)
	local itemCount = backpackCtrl:getItemCount(cookItemID)
	num = num + itemCount
	if 0 < num and noNum then
		return true
	end
	local stageData = activityCommonKitchenRead.getStageData(activityID)
	for __, data in ipairs(stageData) do
		local state = self:getBoxRewardDataStatus(activityID, data.stage, data.point)
		if state == gBtnTargetStatusDef.GET then
			num = num + 1
			if noNum then
				return true
			end
		end
	end
	local _ret, _num = self:getAchivevementRedNum(activityID, noNum)
	if _ret then
		if noNum then
			return true
		end
		num = num + _num
	end
	local taskList = self:getTaskList(activityID)
	for __, data in ipairs(taskList) do
		local nextTime = data.nextTime
		if not nextTime or not (nextTime > serviceFunctions.systemTime()) then
			local itemCount = backpackCtrl:getItemCount(data.likeItemID)
			if 0 < itemCount then
				num = num + 1
				break
			end
		end
	end
	return 0 < num, num
end
function activityCommonKitchenCtrl:getReceiveStatusAndNum2(activityID, noNum)
	local num = 0
	local _ret = self:getBattlePassRedNum(activityID)
	if _ret then
		num = num + 1
	end
	return 0 < num, num
end
function activityCommonKitchenCtrl:getAchivevementRedNum(activityID, noNum)
	local num = 0
	local activityCommonKitchenRead = include("activityCommonKitchenRead")
	local uniqueIDList = activityCommonKitchenRead.getUniqueIDList(activityID)
	for __, uniqueID in ipairs(uniqueIDList) do
		local state = self:getAchivevementState(activityID, uniqueID)
		if state == gBtnTargetStatusDef.GET then
			num = num + 1
			if noNum then
				return true
			end
		end
	end
	return 0 < num, num
end
function activityCommonKitchenCtrl:getCookItemID(activityID)
	local cmdCfg = self.cmdConfig[activityID]
	return cmdCfg.cookItemID
end
function activityCommonKitchenCtrl:getAutoNeedCount(activityID)
	local cmdCfg = self.cmdConfig[activityID]
	return cmdCfg.autoNeedCount
end
function activityCommonKitchenCtrl:getRefreshItemID(activityID)
	local cmdCfg = self.cmdConfig[activityID]
	return cmdCfg.refreshItemID
end
function activityCommonKitchenCtrl:getRewardLv(activityID, rtype)
	local initData = self:getActivityData(activityID)
	if rtype == 1 then
		return initData.normalRewardLv or 0
	else
		return initData.advanceRewardLv or 0
	end
end
function activityCommonKitchenCtrl:getIsAdvanceRewardUnlock(activityID)
	local initData = self:getActivityData(activityID)
	return initData.isAdvanceRewardUnlock or false
end
function activityCommonKitchenCtrl:getBattlePassRewardState(activityID, rtype, lv)
	local rewardLv = self:getRewardLv(activityID, rtype)
	if lv <= rewardLv then
		return gBtnTargetStatusDef.GOT
	end
	if rtype == 2 and not self:getIsAdvanceRewardUnlock(activityID) then
		return gBtnTargetStatusDef.NONE
	end
	local curLv = self:getCurLv(activityID)
	if lv <= curLv then
		return gBtnTargetStatusDef.GET
	else
		return gBtnTargetStatusDef.GO
	end
end
function activityCommonKitchenCtrl:getCurLv(activityID)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local activityCommonKitchenRead = include("activityCommonKitchenRead")
	local curLv = activityShowCtrl:getCurOpenDay(activityID)
	local maxDay = activityCommonKitchenRead.getBattlePassMaxDay(activityID)
	return math.min(curLv, maxDay)
end
function activityCommonKitchenCtrl:getBattlePassRedNum(activityID)
	local curLv = self:getCurLv(activityID)
	local rewardLv1 = self:getRewardLv(activityID, 1)
	if curLv > rewardLv1 then
		return true
	end
	if self:getIsAdvanceRewardUnlock(activityID) then
		local rewardLv2 = self:getRewardLv(activityID, 2)
		if curLv > rewardLv2 then
			return true
		end
	end
	return false
end
return activityCommonKitchenCtrl

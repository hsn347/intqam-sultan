local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local smeltCtrl = class("smeltCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local smeltRead = include("smeltRead")
local publicRead = include("publicRead")
_ENV = "publicRead"
;("publicRead").FINISH = 1
;("publicRead").UNCOMPLETE = 2
local ("publicRead").RECEIVE, TaskStatus = 3, "publicRead"
function smeltCtrl:ctor(properties)
	smeltCtrl.super.ctor(self, properties)
	self.giftID = IsArClient and 14434 or 17001
	self:resetData()
end
function smeltCtrl:EnterGame()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_INIT", handler(self, self.activityInitRsp))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_UPDATE_QUEST_DATA", handler(self, self.activityTaskUpdate))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_SMELT_ACTIVITY_CHOOSE_EQUIP, handler(self, self.reqChooseEquipRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_SMELT_ACTIVITY_SMELT, handler(self, self.reqSmeltRsp))
	self:registerNotify()
end
function smeltCtrl:Logout()
	SoraDRemoveMessageByTarget(self)
	smeltCtrl.super.Logout(self)
	self:resetData()
end
function smeltCtrl:resetData()
	self.msgData = nil
	self.task = nil
	self.chooseID = nil
end
function smeltCtrl:activityInitRsp(target, data)
	if data.activityID == gActivityTimeActivityID.SMELT_ACTIVITY then
		self:initClientData(data.initData)
	end
end
function smeltCtrl:activityTaskUpdate(target, data)
	if data.activityID == gActivityTimeActivityID.SMELT_ACTIVITY and self.msgData then
		local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
		self.msgData.questData = activityTaskComponentCtrl:getQuestData(gActivityTimeActivityID.SMELT_ACTIVITY)
		self:updateTaskData()
		_ENV = self
		self.msg = "MESSAGE_UPDATE_SMELT_DATA"
		SoraDSendMessage(self)
	end
end
function smeltCtrl:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.SMELT_ACTIVITY) then
		self:resetData()
		_ENV = self
		self.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		self.eventID = gActivityTimeActivityID.SMELT_ACTIVITY
		SoraDSendMessage(self)
	end
end
function smeltCtrl:initClientData(data)
	dump(data, "smeltCtrl:initClientData", 20)
	if not data then
		return
	end
	self.msgData = data
	self.curRound = data.stage
	self.chooseID = data.equipID
	self:updateTaskData()
end
function smeltCtrl:updateTaskData()
	local group = self:getGroupID()
	local taskIDs = smeltRead.getTasks(group)
	self.tasks, smeltRead = group, group
	for k, v in pairs(taskIDs) do
		local status = self:getTaskStatus(v)
		local progress = self:getTaskProgress(v)
		smeltRead = nil
		;(nil).taskID = v
		;(nil).status = status
		;(nil).progress = progress
		table.insert(self.tasks, nil)
	end
	table.sort(self.tasks, function(l, r)
		if l.status == r.status then
			return l.taskID < r.taskID
		else
			return l.status < r.status
		end
	end)
	smeltRead = self.tasks
	self.tasks.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	self.tasks.eventID = gActivityTimeActivityID.SMELT_ACTIVITY
	SoraDSendMessage(self.tasks)
end
function smeltCtrl:reqInit(...)
	local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
	activityTaskComponentCtrl:sendReqInit()
end
function smeltCtrl:reqSmelt(itemID, itemCount, ...)
	serverproxy = nil
	;(nil).itemID = itemID
	;(nil).itemCount = itemCount
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_SMELT_ACTIVITY_SMELT, nil, ...)
end
function smeltCtrl:reqChooseEquip(equipID, ...)
	serverproxy = nil
	;(nil).equipID = equipID
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_SMELT_ACTIVITY_CHOOSE_EQUIP, nil, ...)
end
function smeltCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.SMELT_ACTIVITY, handler(self, self.notifyHandler))
end
function smeltCtrl:notifyHandler(event)
	dump(event.data, "smeltCtrl:notifyHandler", 10)
	for _, content in pairs(event.data) do
		if content then
			self:initClientData(content)
			_ENV = self
			self.msg = "MESSAGE_UPDATE_SMELT_DATA"
			SoraDSendMessage(self)
		end
	end
end
function smeltCtrl:reqSmeltRsp(content)
	dump(content, "smeltCtrl:reqSmeltRsp", 10)
	if content.err == gErrDef.Err_None then
		self.msgData.value = content.rspdata.value
		self.msgData.stage = content.rspdata.stage
		self:initClientData(self.msgData)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_SMELT_SMELT"
		self.data = content.rspdata
		SoraDSendMessage(self)
	end
end
function smeltCtrl:reqChooseEquipRsp(content)
	dump(content, "smeltCtrl:reqChooseEquipRsp", 10)
	if content.err == gErrDef.Err_None then
		self.msgData.equipID = content.rspdata.equipID
		self.msgData.changeCount = content.rspdata.changeCount
		self:initClientData(self.msgData)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_SMELT_CHOOSE_EQUIP"
		self.data = content.rspdata
		SoraDSendMessage(self)
	end
end
function smeltCtrl:getReceiveStatusAndNum()
	if not self.tasks or self:getChooseID() == nil or self:getChooseID() == 0 then
		return false, -1, 0
	else
		local num = 0
		for k, v in pairs(self.tasks) do
			if v.status == TaskStatus.FINISH then
				num = num + 1
			end
		end
		return 0 < num, -1, num
	end
end
function smeltCtrl:getIsBuy()
	return self.msgData and self.msgData.upgrade == 1 or false
end
function smeltCtrl:getCurRewards(round)
	round = round == nil and self.curRound or round
	if round == nil then
		round = 1
	end
	local showRewards = self:getShowRewards()
	local curReward
	for k, v in pairs(showRewards) do
		if k <= round then
			curReward = v
		end
	end
	return curReward
end
function smeltCtrl:getNextStageCost(curRound)
	local curRewards = self:getCurRewards()
	local costSum = 0
	for i, v in ipairs(curRewards) do
		if costSum < v.cost then
			costSum = v.cost
		end
	end
	return costSum
end
function smeltCtrl:getAllGotRewards(curRound, value, isBuy)
	local _ENV, gotRewards
	local _ENV, roundRewards
	local showRewards = self:getShowRewards()
	for i = 1, curRound - 1 do
		local realRound = i
		for k, v in pairs(showRewards) do
			if k >= realRound then
				realRound = k
				break
			end
		end
		if not roundRewards[realRound] and showRewards[realRound] then
			local rewards = showRewards[realRound]
			local _ENV, tmpRewards = pairs(showRewards)
			for j, v in ipairs(rewards) do
				local rewards = self:getRewardTableFromCfg(v, isBuy)
				for l, v2 in ipairs(rewards) do
					if not tmpRewards[v2.id] then
						tmpRewards[v2.id] = v2.count
					else
						tmpRewards[v2.id] = tmpRewards[v2.id] + v2.count
					end
				end
			end
			roundRewards[realRound] = tmpRewards
		end
		for j, v in pairs(roundRewards[realRound]) do
			if not gotRewards[j] then
				gotRewards[j] = v
			else
				gotRewards[j] = gotRewards[j] + v
			end
		end
	end
	local curRewards = self:getCurRewards()
	local maxCost = 0
	for k, v2 in ipairs(curRewards) do
		local rewards = self:getRewardTableFromCfg(v2, isBuy)
		if value >= v2.cost then
			for i, v in ipairs(rewards) do
				if not gotRewards[v.id] then
					gotRewards[v.id] = v.count
				else
					gotRewards[v.id] = gotRewards[v.id] + v.count
				end
			end
		end
		if maxCost < v2.cost then
			maxCost = v2.cost
		end
	end
	newGotRewards, _ENV = ipairs(curRewards)
	for k, v in pairs(gotRewards) do
		_ENV = ipairs(rewards)
		ipairs(rewards).id = k
		ipairs(rewards).count = v
		table.insert(newGotRewards, ipairs(rewards))
	end
	if 1 < curRound then
		_ENV = pairs(roundRewards[realRound])
		pairs(roundRewards[realRound]).id = self:getChooseID()
		pairs(roundRewards[realRound]).count = self:getChooseNum()
		table.insert(newGotRewards, 1, pairs(roundRewards[realRound]))
	end
	return newGotRewards
end
function smeltCtrl:getNewGetRewards(oldRound, oldValue, curRound, value, isBuy)
	local _ENV, gotRewards
	local _ENV, roundRewards
	local showRewards = self:getShowRewards()
	for i = oldRound + 1, curRound - 1 do
		local realRound = i
		for k, v in pairs(showRewards) do
			if k >= realRound then
				realRound = k
				break
			end
		end
		if not roundRewards[realRound] then
			local rewards = showRewards[realRound]
			local _ENV, tmpRewards = pairs(showRewards)
			for j, v in ipairs(rewards) do
				local rewards = self:getRewardTableFromCfg(v, isBuy)
				for l, v2 in ipairs(rewards) do
					if not tmpRewards[v2.id] then
						tmpRewards[v2.id] = v2.count
					else
						tmpRewards[v2.id] = tmpRewards[v2.id] + v2.count
					end
				end
			end
			roundRewards[realRound] = tmpRewards
		end
		for j, v in pairs(roundRewards[realRound]) do
			if not gotRewards[j] then
				gotRewards[j] = v
			else
				gotRewards[j] = gotRewards[j] + v
			end
		end
	end
	if oldRound ~= curRound then
		local oldRewards = self:getCurRewards(oldRound)
		for k, v2 in ipairs(oldRewards) do
			local rewards = self:getRewardTableFromCfg(v2, isBuy)
			if oldValue < v2.cost then
				for i, v in ipairs(rewards) do
					if not gotRewards[v.id] then
						gotRewards[v.id] = v.count
					else
						gotRewards[v.id] = gotRewards[v.id] + v.count
					end
				end
			end
		end
	end
	curRewards = self:getCurRewards(curRound)
	for k, v2 in ipairs(curRewards) do
		local rewards = self:getRewardTableFromCfg(v2, isBuy)
		if oldRound ~= curRound and value >= v2.cost or oldRound == curRound and value >= v2.cost and oldValue < v2.cost then
			for i, v in ipairs(rewards) do
				if not gotRewards[v.id] then
					gotRewards[v.id] = v.count
				else
					gotRewards[v.id] = gotRewards[v.id] + v.count
				end
			end
		end
	end
	newGotRewards, _ENV = ipairs(curRewards)
	for k, v in pairs(gotRewards) do
		_ENV = ipairs(rewards)
		ipairs(rewards).id = k
		ipairs(rewards).count = v
		table.insert(newGotRewards, ipairs(rewards))
	end
	if oldRound ~= curRound or curRound == self:getMaxRound() and value >= self:getNextStageCost(curRound) then
		for i = oldRound, curRound do
			local otherReward = self:getOtherReward(i, isBuy)
			if otherReward then
				table.insert(newGotRewards, 1, otherReward)
			end
		end
	end
	return newGotRewards
end
function smeltCtrl:getRewardTableFromCfg(smeltStargeCfg, isBuy)
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	return serviceFunctions.tableFormat(isBuy and smeltStargeCfg.reward2 or smeltStargeCfg.reward1, nil)
end
function smeltCtrl:getMaxRoundCost(curRound)
	local costSum = self:getNextStageCost(curRound)
	local _ENV, roundCosts = self, self
	local showRewards = self:getShowRewards()
	for i = curRound + 1, self:getMaxRound() do
		local realRound = i
		for k, v in pairs(showRewards) do
			if k >= realRound then
				realRound = k
				break
			end
		end
		if not roundCosts[realRound] then
			local rewards = showRewards[realRound]
			local tmpCostSum = 0
			for j, v in ipairs(rewards) do
				if tmpCostSum < v.cost then
					tmpCostSum = v.cost
				end
			end
			roundCosts[realRound] = tmpCostSum
		end
		costSum = costSum + roundCosts[realRound]
	end
	return costSum
end
function smeltCtrl:getWillGetRound(curRound, nowValue, addValue)
	local nextCost = self:getNextStageCost(curRound)
	local lastValue = addValue - (nextCost - nowValue)
	if lastValue <= 0 then
		return curRound
	end
	local _ENV, roundCosts = curRound, curRound
	local showRewards = self:getShowRewards()
	for i = curRound + 1, self:getMaxRound() do
		local realRound = i
		for k, v in pairs(showRewards) do
			if k >= realRound then
				realRound = k
				break
			end
		end
		if not roundCosts[realRound] then
			local rewards = showRewards[realRound]
			local tmpCostSum = 0
			for j, v in ipairs(rewards) do
				if tmpCostSum < v.cost then
					tmpCostSum = v.cost
				end
			end
			roundCosts[realRound] = tmpCostSum
		end
		lastValue = lastValue - roundCosts[realRound]
		if lastValue <= 0 then
			return i
		end
	end
end
function smeltCtrl:getGroupID()
	return self.msgData and self.msgData.groupID or 1
end
function smeltCtrl:getCurEquips()
	local group = self:getGroupID()
	return smeltRead.getEquips(group)
end
function smeltCtrl:getShowRewards()
	local group = self:getGroupID()
	return smeltRead.getShowRewards(group)
end
function smeltCtrl:getCurRound()
	if self.curRound and self.curRound > self:getMaxRound() then
		return self:getMaxRound()
	end
	return self.curRound or 0
end
function smeltCtrl:getMaxRound()
	local group = self:getGroupID()
	return smeltRead.getMaxRound(group)
end
function smeltCtrl:getChooseID()
	return self.chooseID
end
function smeltCtrl:getUpChooseID()
	for i, v in ipairs(self:getCurEquips()) do
		if v.equip == self.chooseID then
			return v.upEquip
		end
	end
end
function smeltCtrl:getChooseEquipCfg()
	for i, v in ipairs(self:getCurEquips()) do
		if v.equip == self.chooseID or v.upEquip == self.chooseID then
			return v
		end
	end
end
function smeltCtrl:getChooseNum()
	for i, v in ipairs(self:getCurEquips()) do
		if v.equip == self.chooseID or v.upEquip == self.chooseID then
			return self:getIsBuy() and v.num[2] or v.num[1]
		end
	end
end
function smeltCtrl:getValue()
	return self.msgData and self.msgData.value or 0
end
function smeltCtrl:getNowPrice()
	local count = self.msgData and self.msgData.changeCount or 0
	count = count + 1
	return smeltRead.getCurPrice(count)
end
function smeltCtrl:getGiftData()
	local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
	local giftID = self.giftID
	local giftData = rechargeActivityCtrl:getRechargeActivityData(giftID)
	return giftData
end
function smeltCtrl:getItemCount(itemID)
	local backpackCtrl = SoraDGetCtrl("backpackCtrl", gametop)
	if itemID == 1631 then
		if self.msgData then
			return self.msgData.smeltStone or 0
		end
		return 0
	else
		return backpackCtrl:getItemCount(itemID)
	end
end
function smeltCtrl:getOtherReward(round, isBuy)
	local group = self:getGroupID()
	local otherReward = smeltRead.getOtherRewards(group)[round]
	if otherReward then
		local reward = isBuy and otherReward.reward2 or otherReward.reward1
		if next(reward) then
			smeltRead = next(reward)
			next(reward).id = reward[1]
			next(reward).count = reward[2]
			return (next(reward))
		else
			return nil
		end
	end
	return nil
end
function smeltCtrl:getIsFinish()
	if not self.msgData then
		return false
	end
	return self:getCurRound() >= self:getMaxRound() and self:getValue() >= self:getNextStageCost(self:getCurRound())
end
function smeltCtrl:getTasks()
	return self.tasks
end
function smeltCtrl:getTaskStatus(taskID)
	local status = TaskStatus.UNCOMPLETE
	if self:getIsTaskClaimed(taskID) ~= 0 then
		status = TaskStatus.RECEIVE
	elseif self:getIsTaskFinished(taskID) ~= 0 then
		status = TaskStatus.FINISH
	end
	return status
end
function smeltCtrl:getTaskProgress(taskID)
	if not (self.msgData and self.msgData.questData) or not self.msgData.questData.questProgress then
		return 0
	end
	local ret = self.msgData.questData.questProgress[tostring(taskID)]
	return ret ~= nil and ret or 0
end
function smeltCtrl:getIsTaskClaimed(taskID)
	if not (self.msgData and self.msgData.questData) or not self.msgData.questData.claimedQuest then
		return 0
	end
	local ret = self.msgData.questData.claimedQuest[tostring(taskID)]
	return ret ~= nil and ret or 0
end
function smeltCtrl:getIsTaskFinished(taskID)
	if not (self.msgData and self.msgData.questData) or not self.msgData.questData.finishedQuest then
		return 0
	end
	local ret = self.msgData.questData.finishedQuest[tostring(taskID)]
	return ret ~= nil and ret or 0
end
function smeltCtrl:getEquipName(equipID)
	if equipID == nil then
		return ""
	end
	local group = self:getGroupID()
	local level = 1
	if group == 1 then
		local qid = include("equipDesRead").getRealEquipIDAndQuality(equipID)
		local equipmentltCtrl = include("equipmentltCtrl")
		local equipCfg = equipmentltCtrl.getEquipCfg(qid)
		level = equipCfg and equipCfg.level or 0
	else
		level = include("wargemResRead").getLevel(equipID)
	end
	local name = "LV." .. level .. " " .. publicRead.getName(equipID)
	return name
end
return smeltCtrl

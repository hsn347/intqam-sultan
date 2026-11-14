local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001615_Ctrl = class("activity_9001615_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local activity_9001615_Read = include("activity_9001615_Read")
local publicRead = include("publicRead")
_ENV = "publicRead"
;("publicRead").FINISH = 1
;("publicRead").UNCOMPLETE = 2
local ("publicRead").RECEIVE, TaskStatus = 3, "publicRead"
function activity_9001615_Ctrl:ctor(properties)
	activity_9001615_Ctrl.super.ctor(self, properties)
	_UPVALUE3_, self.activityID = gActivityTimeActivityID.HONOR_BACK_SMELT, gActivityTimeActivityID.HONOR_BACK_SMELT
	self.rechargeIDList, gActivityTimeActivityID.HONOR_BACK_SMELT[1] = gActivityTimeActivityID.HONOR_BACK_SMELT, 19490
	self.rechargeIDList, gActivityTimeActivityID.HONOR_BACK_SMELT[2] = gActivityTimeActivityID.HONOR_BACK_SMELT, 19491
	self.rechargeIDList, gActivityTimeActivityID.HONOR_BACK_SMELT[3] = gActivityTimeActivityID.HONOR_BACK_SMELT, 19492
	self:resetData()
end
function activity_9001615_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_HONOR_BACK_SMELT_MODULE, gCmd.REQ_HONOR_BACK_SMELT_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_HONOR_BACK_SMELT_MODULE, gCmd.REQ_HONOR_BACK_SMELT_SMELT, handler(self, self.reqSmeltRsp))
	msgCtrl.register(gCmd.CMD_HONOR_BACK_SMELT_MODULE, gCmd.REQ_HONOR_BACK_SMELT_CHOOSE, handler(self, self.reqChooseEquipRsp))
	msgCtrl.register(gCmd.CMD_HONOR_BACK_SMELT_MODULE, gCmd.REQ_HONOR_BACK_SMELT_BUY, handler(self, self.reqBuyRsp))
	msgCtrl.register(gCmd.CMD_HONOR_BACK_SMELT_MODULE, gCmd.REQ_HONOR_BACK_SMELT_CLAIM_REWARD, handler(self, self.reqClaimRsp))
	self:registerNotify()
end
function activity_9001615_Ctrl:Logout()
	SoraDRemoveMessageByTarget(self)
	activity_9001615_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001615_Ctrl:resetData()
	self.msgData = nil
	self.task = nil
	self.chooseID = nil
end
function activity_9001615_Ctrl:initClientData(data)
	dump(data, "activity_9001615_Ctrl:initClientData", 20)
	if not data then
		return
	end
	self.msgData = data
	self:createQuestComponent(data.questData)
	self.curRound = data.stage
	self.chooseID = data.equipID
	self:updateTaskData()
end
function activity_9001615_Ctrl:updateTaskData()
	local group = self:getGroupID()
	local eventQuestRead = include("eventQuestRead")
	local taskIDs = eventQuestRead.getQuestList(self.activityID)
	self.tasks, _ENV = self.activityID, self.activityID
	for k, v in pairs(taskIDs) do
		local status = self:getTaskStatus(v)
		local progress = self:getTaskProgress(v)
		_ENV = nil
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
	_ENV = self.tasks
	self.tasks.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	self.tasks.eventID = gActivityTimeActivityID.HONOR_BACK_SMELT
	SoraDSendMessage(self.tasks)
end
function activity_9001615_Ctrl:sendReqInitDataMsg(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_HONOR_BACK_SMELT_MODULE, gCmd.REQ_HONOR_BACK_SMELT_INIT, nil, ...)
end
function activity_9001615_Ctrl:reqSmelt(itemID, itemCount, ...)
	serverproxy = nil
	;(nil).itemID = itemID
	;(nil).itemCount = itemCount
	serverproxy:Request(gCmd.CMD_HONOR_BACK_SMELT_MODULE, gCmd.REQ_HONOR_BACK_SMELT_SMELT, nil, ...)
end
function activity_9001615_Ctrl:reqChooseEquip(equipID, ...)
	serverproxy = nil
	;(nil).equipID = equipID
	serverproxy:Request(gCmd.CMD_HONOR_BACK_SMELT_MODULE, gCmd.REQ_HONOR_BACK_SMELT_CHOOSE, nil, ...)
end
function activity_9001615_Ctrl:reqBuy(rid, ...)
	serverproxy = nil
	;(nil).rid = rid
	serverproxy:Request(gCmd.CMD_HONOR_BACK_SMELT_MODULE, gCmd.REQ_HONOR_BACK_SMELT_BUY, nil, ...)
end
function activity_9001615_Ctrl:reqClaim(questId, ...)
	serverproxy = nil
	;(nil).questId = questId
	serverproxy:Request(gCmd.CMD_HONOR_BACK_SMELT_MODULE, gCmd.REQ_HONOR_BACK_SMELT_CLAIM_REWARD, nil, ...)
end
function activity_9001615_Ctrl:createQuestComponent(questData)
	if self.questComponent then
		self.questComponent:setQuestData(questData)
	else
		local activityTaskComponent = include("activityTaskComponent")
		self.questComponent = activityTaskComponent.new()
		self.questComponent:setActivityID(self.activityID)
		self.questComponent:setQuestData(questData)
	end
end
function activity_9001615_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.USER_ACTIVITY, handler(self, self.notifyHandler))
end
function activity_9001615_Ctrl:notifyHandler(event)
	dump(event.data, "activity_9001615_Ctrl:notifyHandler", 10)
	for _, v in pairs(event.data) do
		if v.activityID == self.activityID then
			if v.notifyType == "updateData" then
				self:initClientData(v.notifyData)
				_ENV = self
				self.msg = "MESSAGE_UPDATE_SMELT_DATA"
				SoraDSendMessage(self)
				_ENV = self
				self.msg = "MESSAGE_ACTIVITY_9001608_UPDATE_RED"
				self.activityID = self.activityID
				SoraDSendMessage(self)
			elseif v.notifyType == "buyGift" then
				if v.notifyData.rechargeInfo.success then
					paymentManager.loopForFinishTransaction()
					local reward = v.notifyData.rechargeInfo.reward
					local rid = v.notifyData.rechargeInfo.rid
					local mailid = v.notifyData.rechargeInfo.mailid
					_ENV = nil
					;(nil).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
					;(nil).eventID = self.activityID
					SoraDSendMessage(nil)
					_ENV = nil
					_ENV, (nil).msg = self.activityID, "MESSAGE_SERVER_RECHARGECENTER_REFRESH"
					self.activityID.result = true
					self.activityID.rid = rid
					self.activityID.itemList = reward
					;(nil).data, self.activityID.mailID = self.activityID, mailid
					SoraDSendMessage(nil)
				end
				self:initClientData(v.notifyData)
				_ENV = self
				self.msg = "MESSAGE_UPDATE_SMELT_DATA"
				SoraDSendMessage(self)
				_ENV = self
				self.msg = "MESSAGE_ACTIVITY_9001608_UPDATE_RED"
				self.activityID = self.activityID
				SoraDSendMessage(self)
			elseif v.notifyType == "progressUpdate" then
				if self.questComponent then
					self.questComponent:onNotify_progressUpdate(v.notifyData)
				end
				_ENV = self.questComponent
				self.questComponent.msg = "MESSAGE_UPDATE_SMELT_DATA"
				SoraDSendMessage(self.questComponent)
			end
		end
	end
end
function activity_9001615_Ctrl:reqInitRsp(content)
	dump(content, "activity_9001615_Ctrl:reqInitRsp", 10)
	if content.err == gErrDef.Err_None then
		self.msgData = content.rspdata
		self:initClientData(self.msgData)
		_ENV = self
		self.msg = "MESSAGE_ACTIVITY_9001615_UPDATE"
		self.data = content.rspdata
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_ACTIVITY_9001608_UPDATE_RED"
		self.activityID = self.activityID
		SoraDSendMessage(self)
	end
end
function activity_9001615_Ctrl:reqSmeltRsp(content)
	dump(content, "activity_9001615_Ctrl:reqSmeltRsp", 10)
	if content.err == gErrDef.Err_None then
		self.msgData.value = content.rspdata.value
		self.msgData.stage = content.rspdata.stage
		self:initClientData(self.msgData)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_SMELT_SMELT"
		self.data = content.rspdata
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_ACTIVITY_9001608_UPDATE_RED"
		self.activityID = self.activityID
		SoraDSendMessage(self)
	end
end
function activity_9001615_Ctrl:reqChooseEquipRsp(content)
	dump(content, "activity_9001615_Ctrl:reqChooseEquipRsp", 10)
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
function activity_9001615_Ctrl:reqBuyRsp(content)
	dump(content, "activity_9001615_Ctrl:reqBuyRsp", 10)
	if content.err == gErrDef.Err_None then
		local rspdata = content.rspdata
		paymentManager.purchase(content.data.rid, rspdata.orderID)
	end
end
function activity_9001615_Ctrl:reqClaimRsp(content)
	dump(content, "activity_9001615_Ctrl:reqClaimRsp", 10)
	if content.err == gErrDef.Err_None then
		self.msgData = content.rspdata.data
		self:initClientData(self.msgData)
		SoraDMailGainItems(content.rspdata.reward, true)
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_UPDATE_SMELT_DATA"
		SoraDSendMessage(content.rspdata.reward)
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_ACTIVITY_9001608_UPDATE_RED"
		content.rspdata.reward.activityID = self.activityID
		SoraDSendMessage(content.rspdata.reward)
	end
end
function activity_9001615_Ctrl:getReceiveStatusAndNum()
	if self:getIsFinish() then
		return false, 0
	end
	local items = activity_9001615_Read:getItems()
	_UPVALUE2_ = activity_9001615_Read
	self.itemIDs, activity_9001615_Read[1] = activity_9001615_Read, items[1].itemID
	self.itemIDs, activity_9001615_Read[2] = activity_9001615_Read, items[2].itemID
	local itemCount = 0
	for i, v in ipairs(items) do
		itemCount = itemCount + self:getItemCount(v.itemID)
	end
	return 0 < itemCount, itemCount
end
function activity_9001615_Ctrl:getTaskRed()
	if not self.tasks or self:getChooseID() == nil or self:getChooseID() == 0 then
		return false, 0
	else
		local num = 0
		for k, v in pairs(self.tasks) do
			if v.status == TaskStatus.FINISH then
				num = num + 1
			end
		end
		return 0 < num, num
	end
end
function activity_9001615_Ctrl:getIsBuy()
	return self.msgData and self.msgData.upgrade == 1 or false
end
function activity_9001615_Ctrl:getCurRewards(round)
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
function activity_9001615_Ctrl:getNextStageCost(curRound)
	local curRewards = self:getCurRewards()
	local costSum = 0
	for i, v in ipairs(curRewards) do
		if costSum < v.cost then
			costSum = v.cost
		end
	end
	return costSum
end
function activity_9001615_Ctrl:getAllGotRewards(curRound, value, isBuy)
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
function activity_9001615_Ctrl:getNewGetRewards(oldRound, oldValue, curRound, value, isBuy)
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
function activity_9001615_Ctrl:getRewardTableFromCfg(smeltStargeCfg, isBuy)
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	return serviceFunctions.tableFormat(isBuy and smeltStargeCfg.reward2 or smeltStargeCfg.reward1, nil)
end
function activity_9001615_Ctrl:getMaxRoundCost(curRound)
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
function activity_9001615_Ctrl:getWillGetRound(curRound, nowValue, addValue)
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
function activity_9001615_Ctrl:getGroupID()
	return self.msgData and self.msgData.groupID or 2
end
function activity_9001615_Ctrl:getCurEquips()
	local group = self:getGroupID()
	return activity_9001615_Read.getEquips(group)
end
function activity_9001615_Ctrl:getShowRewards()
	local group = self:getGroupID()
	return activity_9001615_Read.getShowRewards(group)
end
function activity_9001615_Ctrl:getCurRound()
	if self.curRound and self.curRound > self:getMaxRound() then
		return self:getMaxRound()
	end
	return self.curRound or 0
end
function activity_9001615_Ctrl:getMaxRound()
	local group = self:getGroupID()
	return activity_9001615_Read.getMaxRound(group)
end
function activity_9001615_Ctrl:getChooseID()
	return self.chooseID
end
function activity_9001615_Ctrl:getUpChooseID()
	for i, v in ipairs(self:getCurEquips()) do
		if v.equip == self.chooseID then
			return v.upEquip
		end
	end
end
function activity_9001615_Ctrl:getChooseEquipCfg()
	for i, v in ipairs(self:getCurEquips()) do
		if v.equip == self.chooseID or v.upEquip == self.chooseID then
			return v
		end
	end
end
function activity_9001615_Ctrl:getChooseNum()
	for i, v in ipairs(self:getCurEquips()) do
		if v.equip == self.chooseID or v.upEquip == self.chooseID then
			return self:getIsBuy() and v.num[2] or v.num[1]
		end
	end
end
function activity_9001615_Ctrl:getValue()
	return self.msgData and self.msgData.value or 0
end
function activity_9001615_Ctrl:getNowPrice()
	local count = self.msgData and self.msgData.changeCount or 0
	count = count + 1
	return activity_9001615_Read.getCurPrice(count)
end
function activity_9001615_Ctrl:getGiftData()
	local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
	local giftData = activity_9001615_Read.getGift(self.activityID)
	return giftData
end
function activity_9001615_Ctrl:getItemCount(itemID)
	local backpackCtrl = SoraDGetCtrl("backpackCtrl", gametop)
	if itemID == 1682 then
		if self.msgData then
			return self.msgData.smeltStone or 0
		end
		return 0
	else
		return backpackCtrl:getItemCount(itemID)
	end
end
function activity_9001615_Ctrl:getOtherReward(round, isBuy)
	local group = self:getGroupID()
	local otherReward = activity_9001615_Read.getOtherRewards(group)[round]
	if otherReward then
		local reward = isBuy and otherReward.reward2 or otherReward.reward1
		if next(reward) then
			activity_9001615_Read = next(reward)
			next(reward).id = reward[1]
			next(reward).count = reward[2]
			return (next(reward))
		else
			return nil
		end
	end
	return nil
end
function activity_9001615_Ctrl:getIsFinish()
	if not self.msgData then
		return false
	end
	return self:getCurRound() >= self:getMaxRound() and self:getValue() >= self:getNextStageCost(self:getCurRound())
end
function activity_9001615_Ctrl:getTasks()
	return self.tasks
end
function activity_9001615_Ctrl:getTaskStatus(taskID)
	local status = TaskStatus.UNCOMPLETE
	if self:getIsTaskClaimed(taskID) then
		status = TaskStatus.RECEIVE
	elseif self:getIsTaskFinished(taskID) then
		status = TaskStatus.FINISH
	end
	return status
end
function activity_9001615_Ctrl:getTaskProgress(taskID)
	if self.questComponent then
		return self.questComponent:getTaskProgress(taskID)
	end
	return 0
end
function activity_9001615_Ctrl:getIsTaskClaimed(taskID)
	if self.questComponent then
		return self.questComponent:isTaskClaimed(taskID)
	end
	return false
end
function activity_9001615_Ctrl:getIsTaskFinished(taskID)
	if self.questComponent then
		return self.questComponent:isTaskFinished(taskID)
	end
	return false
end
function activity_9001615_Ctrl:getEquipName(equipID)
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
function activity_9001615_Ctrl:getPackageList()
	local _ENV, packageList
	local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
	for i, v in ipairs(self.rechargeIDList) do
		local giftData = rechargeActivityCtrl:getRechargeActivityData(v)
		dump(giftData, "giftData")
		if giftData and tonumber(giftData.extraData) > 0 and paymentManager.judgeGiftExclusive(tonumber(v)) then
			_ENV = tonumber(v)
			tonumber(v).id = tonumber(v)
			tonumber(v).giftType = "normalGift"
			tonumber(v).weight = giftData.weight
			tonumber(v).price = giftData.price
			table.insert(packageList, tonumber(v))
		end
	end
	return packageList
end
return activity_9001615_Ctrl

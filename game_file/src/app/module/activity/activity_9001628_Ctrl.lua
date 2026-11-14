local gametop = gModuleMgr.getObject("gametop")
local GameModule = include("GameModule")
local activity_9001628_Ctrl = class("activity_9001628_Ctrl", GameModule)
local msgCtrl = include("msgCtrl")
local serverproxy = gModuleMgr.getObject("serverproxy")
function activity_9001628_Ctrl:ctor(properties)
	activity_9001628_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001628
end
function activity_9001628_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_NEBULA_TREASURE_HUNT_MODULE, gCmd.REQ_NEBULA_TREASURE_HUNT_INIT, handler(self, self.reqInitInfoRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_TREASURE_HUNT_MODULE, gCmd.REQ_NEBULA_TREASURE_HUNT_CAST_DICE, handler(self, self.reqThrowDiceRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_TREASURE_HUNT_MODULE, gCmd.REQ_NEBULA_TREASURE_HUNT_BUY_GIFT, handler(self, self.reqBuyPackageRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_TREASURE_HUNT_MODULE, gCmd.REQ_NEBULA_TREASURE_HUNT_GET_REWARD, handler(self, self.reqGetRewardRsp))
	self:resetData()
	self:registerNotify()
end
function activity_9001628_Ctrl:initClientData(content)
	dump(content, "==activity_9001628_Ctrl:initClientData==", 20)
	if not content then
		return
	end
end
function activity_9001628_Ctrl:resetData()
	self.activityData, _UPVALUE0_ = nil, nil
	self.castData = nil
	self.isRemindMerchant = true
end
function activity_9001628_Ctrl:Logout()
	self:resetData()
	activity_9001628_Ctrl.super.Logout(self)
end
function activity_9001628_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.NEBULA_TREASURE_HUNT, handler(self, self.notifyHandler))
end
function activity_9001628_Ctrl:notifyHandler(event)
	dump(event.data, "activity_9001628_Ctrl:notifyHandler event.data", 10)
	for _, content in pairs(event.data) do
		if content then
			if content.type == "buyGift" then
				if content.data.success then
					if content.data.reward and next(content.data.reward) ~= nil then
						_ENV = nil
						;(nil).itemList = content.data.reward
						;(nil).mailID = content.data.mailID
						;(nil).rid = content.data.rid
						uiManager:show("gemGoodsBuyGiftSuccess", nil)
					end
					self.activityData.giftMerchant = content.data.giftMerchant
					self.activityData.buyTimes = content.data.buyTimes
					self.activityData.roundGift = content.data.roundGift
					_ENV = content.data.roundGift
					content.data.roundGift.msg = "MESSAGE_ANNIVERSARY_TREASURE_HUNT_BUY_PACKAGE"
					SoraDSendMessage(content.data.roundGift)
				else
					_ENV = content.data.roundGift
					content.data.roundGift.msg = "MESSAGE_ANNIVERSARY_TREASURE_HUNT_REFRESH_PACKAGE_STATE"
					SoraDSendMessage(content.data.roundGift)
				end
				SoraDCloseLoading()
				paymentManager.isInRecharging = false
			elseif content.type == "refreshData" then
				self.activityData = content.data
				_ENV = content.data.roundGift
				content.data.roundGift.msg = "MESSAGE_ANNIVERSARY_TREASURE_HUNT_INIT_BACK"
				SoraDSendMessage(content.data.roundGift)
			elseif content.type == "chgDice" then
				self.activityData.diceNum = content.data.diceNum
				_ENV = content.data.diceNum
				content.data.diceNum.msg = "MESSAGE_ANNIVERSARY_TREASURE_HUNT_BUY_DICE_COUNT"
				SoraDSendMessage(content.data.diceNum)
			elseif content.type == "chgFreeDice" then
				self.activityData.freeDiceNum = content.data.freeDiceNum
				_ENV = content.data.freeDiceNum
				content.data.freeDiceNum.msg = "MESSAGE_ANNIVERSARY_TREASURE_HUNT_BUY_DICE_COUNT"
				SoraDSendMessage(content.data.freeDiceNum)
			end
		end
	end
end
function activity_9001628_Ctrl:sendReqInitDataMsg()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_NEBULA_TREASURE_HUNT_MODULE, gCmd.REQ_NEBULA_TREASURE_HUNT_INIT, data)
end
function activity_9001628_Ctrl:reqThrowDiceMsg()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_NEBULA_TREASURE_HUNT_MODULE, gCmd.REQ_NEBULA_TREASURE_HUNT_CAST_DICE, data)
end
function activity_9001628_Ctrl:reqBuyPackageMsg(rechargeID)
	serverproxy = nil
	local (nil).rechargeID, data = rechargeID, nil
	serverproxy:Request(gCmd.CMD_NEBULA_TREASURE_HUNT_MODULE, gCmd.REQ_NEBULA_TREASURE_HUNT_BUY_GIFT, data)
end
function activity_9001628_Ctrl:reqGetRewardMsg(taskType, uniqueID)
	serverproxy = nil
	;(nil).taskType = taskType
	local (nil).index, data = uniqueID, nil
	serverproxy:Request(gCmd.CMD_NEBULA_TREASURE_HUNT_MODULE, gCmd.REQ_NEBULA_TREASURE_HUNT_GET_REWARD, data)
end
function activity_9001628_Ctrl:reqInitInfoRsp(content)
	dump(content, "activity_9001628_Ctrl:reqInitInfoRsp===", 10)
	if content.err == gErrDef.Err_None then
		self.activityData = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ANNIVERSARY_TREASURE_HUNT_INIT_BACK"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001628_Ctrl:reqThrowDiceRsp(content)
	dump(content, "activity_9001628_Ctrl:reqThrowDiceRsp===", 10)
	if content.err == gErrDef.Err_None then
		self.activityData = content.rspdata.initData
		self.castData = content.rspdata.castdata
		local activity_9001628_Read = include("activity_9001628_Read")
		local rounds = self:getRoundCount()
		local times = activity_9001628_Read:getHuntSecretTimes(rounds)
		_ENV = nil
		;(nil).byUID = true
		if not SoraDConfigGet("Game:Activity_9001628:reddot~table", nil) then
			local _ENV, reddotTb = SoraDConfigGet("Game:Activity_9001628:reddot~table", nil), SoraDConfigGet("Game:Activity_9001628:reddot~table", nil)
		end
		if 0 < times and not reddotTb[tostring(times)] then
			reddotTb[tostring(times)] = 1
			_ENV = nil
			;(nil).byUID = true
			SoraDConfigSet("Game:Activity_9001628:reddot~table", reddotTb, nil)
		end
		_ENV = "Game:Activity_9001628:reddot~table"
		;("Game:Activity_9001628:reddot~table").msg = "MESSAGE_ANNIVERSARY_TREASURE_GET_REWARD_BACK"
		SoraDSendMessage("Game:Activity_9001628:reddot~table")
		_ENV = "Game:Activity_9001628:reddot~table"
		;("Game:Activity_9001628:reddot~table").msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		;("Game:Activity_9001628:reddot~table").eventID = self.activityID
		SoraDSendMessage("Game:Activity_9001628:reddot~table")
	end
	_ENV = self:getRoundCount()
	self:getRoundCount().msg = "MESSAGE_ANNIVERSARY_TREASURE_HUNT_THROW_DICE"
	self:getRoundCount().err = content.err
	SoraDSendMessage((self:getRoundCount()))
end
function activity_9001628_Ctrl:reqBuyPackageRsp(content)
	dump(content, "activity_9001628_Ctrl:reqBuyPackageRsp===", 10)
	if content.err == gErrDef.Err_None then
		self.activityData.giftMerchant = content.rspdata.giftMerchant
		self.activityData.buyTimes = content.rspdata.buyTimes
		paymentManager.purchase(content.data.rechargeID, content.rspdata.orderID)
	else
		_ENV = content.data.rechargeID
		content.data.rechargeID.msg = "MESSAGE_ANNIVERSARY_TREASURE_HUNT_REFRESH_PACKAGE_STATE"
		SoraDSendMessage(content.data.rechargeID)
		SoraDCloseLoading()
		paymentManager.isInRecharging = false
	end
end
function activity_9001628_Ctrl:reqGetRewardRsp(content)
	dump(content, "activity_9001628_Ctrl:reqGetRewardRsp===", 10)
	if content.err == gErrDef.Err_None then
		self.activityData = content.rspdata.initData
		if content.rspdata.rewards then
			SoraDMailGainItems(content.rspdata.rewards, true)
		end
		_ENV = content.rspdata.rewards
		content.rspdata.rewards.msg = "MESSAGE_ANNIVERSARY_TREASURE_GET_REWARD_BACK"
		SoraDSendMessage(content.rspdata.rewards)
		_ENV = content.rspdata.rewards
		content.rspdata.rewards.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		content.rspdata.rewards.eventID = self.activityID
		SoraDSendMessage(content.rspdata.rewards)
	end
end
function activity_9001628_Ctrl:getOwnDiceCount()
	local freeDiceCount = self.activityData.freeDiceNum and tonumber(self.activityData.freeDiceNum) or 0
	return freeDiceCount + (tonumber(self.activityData.diceNum) or 0)
end
function activity_9001628_Ctrl:getFreeDiceCount()
	return tonumber(self.activityData.freeDiceNum) or 0
end
function activity_9001628_Ctrl:getDiceCount()
	return tonumber(self.activityData.diceNum) or 0
end
function activity_9001628_Ctrl:getAlreadyBuyDiceCount()
	return tonumber(self.activityData.buyDiceNum) or 0
end
function activity_9001628_Ctrl:getCurGrid()
	local curStepCount = 0
	if self.activityData.curStepCount == 0 then
		curStepCount = 1
	elseif 0 < self:getMapSize() then
		curStepCount = (self.activityData.curStepCount - 1) % self:getMapSize() + 1
	end
	return curStepCount
end
function activity_9001628_Ctrl:getMerchantGridInfo()
	return self.activityData.giftMerchant
end
function activity_9001628_Ctrl:isMerchantGrid()
	local isMerchantGrid = false
	if next(self.activityData.giftMerchant) then
		isMerchantGrid = true
	end
	return isMerchantGrid
end
function activity_9001628_Ctrl:getTotalThrowTimes()
	return self.activityData.castDiceCount or 0
end
function activity_9001628_Ctrl:getTotalStepCount()
	local totalStepCount = self.activityData.stepBeforeCount or 0
	if 0 > totalStepCount - 1 then
		totalStepCount = 0
	end
	return totalStepCount
end
function activity_9001628_Ctrl:getTotalRoundCount()
	local totalRoundCount = self.activityData.roundCount or 0
	local curCount = self.activityData.curStepCount or 0
	if totalRoundCount <= 1 and curCount <= self:getMapSize() then
		totalRoundCount = 0
	else
		totalRoundCount = totalRoundCount - 1
	end
	return totalRoundCount
end
function activity_9001628_Ctrl:getRoundCount()
	return math.floor(self.activityData.stepBeforeCount / self:getMapSize())
end
function activity_9001628_Ctrl:getBuyTimes()
	local times = 0
	for k, v in pairs(self:getRoundGift()) do
		times = times + v
	end
	return times
end
function activity_9001628_Ctrl:getMaxRoundGiftTimes()
	local activity_9001628_Read = include("activity_9001628_Read")
	return activity_9001628_Read:getHuntSecretTimes(self:getRoundCount())
end
function activity_9001628_Ctrl:getRoundGift()
	if not self.activityData.roundGift then
		_UPVALUE0_ = self.activityData.roundGift
	end
	return self.activityData.roundGift
end
function activity_9001628_Ctrl:isRoundGiftRed()
	_ENV = nil
	;(nil).byUID = true
	if not SoraDConfigGet("Game:Activity_9001628:reddot~table", nil) then
		local _ENV, reddotTb = SoraDConfigGet("Game:Activity_9001628:reddot~table", nil), SoraDConfigGet("Game:Activity_9001628:reddot~table", nil)
	end
	local num = 0
	for _, v in pairs(reddotTb) do
		num = num + v
	end
	return 0 < num
end
function activity_9001628_Ctrl:isRewardClaimed(type, uniqueID)
	local isClaimed = false
	if self.activityData.receivedReward[tostring(type)] and self.activityData.receivedReward[tostring(type)][tostring(uniqueID)] then
		isClaimed = true
	end
	return isClaimed
end
function activity_9001628_Ctrl:getMapSize()
	local activity_9001628_Read = include("activity_9001628_Read")
	return #activity_9001628_Read:getTreasureHuntMapInfo()
end
function activity_9001628_Ctrl:getCastDataStepSet()
	if self.castData then
		return self.castData.stepSet
	end
end
function activity_9001628_Ctrl:getAmazingGridEventTypeAndNum(index)
	local aType = gNTHAdveType.NONE
	local num = 0
	if self.castData and self.activityData and self.castData.stepSet then
		for i, v in ipairs(self.castData.stepSet) do
			if index == v.curMapIndex then
				if 0 < v.adjustStepCount then
					do
						local activity_9001628_Read = include("activity_9001628_Read")
						local realType = activity_9001628_Read:getMapRealType((index + v.adjustStepCount) % 36)
						if realType and realType == gNTHAdveType.MERCHANT then
							aType = gNTHAdveType.MERCHANT
						else
							aType = gNTHAdveType.MOVE_FORWARD_NOW
						end
						num = v.adjustStepCount
					end
					break
				end
				if 0 > v.adjustStepCount then
					aType = gNTHAdveType.BACK_OFF_NOW
					num = -v.adjustStepCount
				end
				break
			end
		end
		if aType ~= gNTHAdveType.BACK_OFF_NOW then
			if self.activityData.advMultiple > 1 then
				aType = gNTHAdveType.DICE_MULTI_POINT
				num = self.activityData.advMultiple
			elseif self.activityData.advRewardMulti and 1 < self.activityData.advRewardMulti then
				aType = gNTHAdveType.REWARD_MULTI
			end
		end
		if aType ~= gNTHAdveType.MOVE_FORWARD_NOW and aType ~= gNTHAdveType.BACK_OFF_NOW and self.castData.rewards ~= nil and 0 < #self.castData.rewards then
			aType = gNTHAdveType.RANDOM_REWARD
		end
	end
	return aType, num
end
function activity_9001628_Ctrl:getAdvRewwards()
	return self.castData.rewards
end
function activity_9001628_Ctrl:getMultipleForAmazing()
	local advMultiple = 1
	if self.castData then
		advMultiple = self.castData.advMultiple
	end
	return advMultiple
end
function activity_9001628_Ctrl:getCastDataRewards()
	local _UPVALUE0_, rewards
	if self.castData and self.castData.rewards then
		rewards = self.castData.rewards
	end
	return rewards
end
function activity_9001628_Ctrl:isAllPackageBought()
	local isAllBought = true
	for k, v in pairs(self.activityData.giftMerchant) do
		if not v.purchased then
			isAllBought = false
			break
		end
	end
	return isAllBought
end
function activity_9001628_Ctrl:getReceiveStatusAndNum()
	local totalNum = self:getTaskRedNum() + self:getGiftRedNum()
	return 0 < totalNum, totalNum
end
function activity_9001628_Ctrl:getTaskRedNum()
	local totalNum = 0
	local activity_9001628_Read = include("activity_9001628_Read")
	local taskList = activity_9001628_Read:getTreasureHuntAchievementInfo()
	for i, v in ipairs(taskList) do
		local curCount = 0
		if v.type == gNTHAchiTaskType.castDiceTotalCount then
			curCount = self:getTotalThrowTimes()
		elseif v.type == gNTHAchiTaskType.stepBeforeTotalCount then
			curCount = self:getTotalStepCount()
		elseif v.type == gNTHAchiTaskType.roundTotalCount then
			curCount = self:getTotalRoundCount()
		end
		if curCount >= v.require and not self:isRewardClaimed(v.type, v.uniqueID) then
			totalNum = totalNum + 1
		end
	end
	return totalNum
end
function activity_9001628_Ctrl:getGiftRedNum()
	return IsArClient and self:isRoundGiftRed() and 1 or 0
end
function activity_9001628_Ctrl:getSortedTaskList()
	local activity_9001628_Read = include("activity_9001628_Read")
	local taskList = activity_9001628_Read:getTreasureHuntAchievementInfo()
	for i, v in ipairs(taskList) do
		local curCount = 0
		v.weight = 1
		if v.type == gNTHAchiTaskType.castDiceTotalCount then
			curCount = self:getTotalThrowTimes()
		elseif v.type == gNTHAchiTaskType.stepBeforeTotalCount then
			curCount = self:getTotalStepCount()
		elseif v.type == gNTHAchiTaskType.roundTotalCount then
			curCount = self:getTotalRoundCount()
		end
		if curCount >= v.require then
			if self:isRewardClaimed(v.type, v.uniqueID) then
				v.weight = 0
			else
				v.weight = 3
			end
		else
			v.weight = 2
		end
	end
	table.sort(taskList, function(a, b)
		if a.weight == b.weight then
			return a.uniqueID < b.uniqueID
		else
			return a.weight > b.weight
		end
	end)
	return taskList
end
function activity_9001628_Ctrl:isCurGearAllbought(packageID)
	local isAllBought = false
	local curBuyTimes = 0
	if self.activityData and next(self.activityData.buyTimes) then
		local activity_9001628_Read = include("activity_9001628_Read")
		local packageInfo = activity_9001628_Read:getTreasureHuntPackageInfo(packageID)
		local packageList = activity_9001628_Read:getTreasureHuntPackageInfoByPrice(packageInfo.price)
		for i, v in ipairs(packageList) do
			if self.activityData.buyTimes[tostring(v.index)] then
				curBuyTimes = curBuyTimes + 1
			end
		end
		isAllBought = curBuyTimes == #packageList
	end
end
function activity_9001628_Ctrl:getStarLv()
	return self.activityData.starLv or 0
end
function activity_9001628_Ctrl:getGroupID()
	return SoraDGetCtrl("activityShowCtrl"):getParamClassType(self.activityID) or 1
end
function activity_9001628_Ctrl:setIsRemindMerchant(isRemind)
	self.isRemindMerchant = isRemind
end
function activity_9001628_Ctrl:getIsRemindMerchant()
	return self.isRemindMerchant
end
return activity_9001628_Ctrl

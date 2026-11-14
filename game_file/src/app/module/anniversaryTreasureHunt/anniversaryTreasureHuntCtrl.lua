local gametop = gModuleMgr.getObject("gametop")
local GameModule = include("GameModule")
local anniversaryTreasureHuntCtrl = class("anniversaryTreasureHuntCtrl", GameModule)
local msgCtrl = include("msgCtrl")
local serverproxy = gModuleMgr.getObject("serverproxy")
function anniversaryTreasureHuntCtrl:ctor(properties)
	anniversaryTreasureHuntCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.ANNIVERSARY_TREASURE_HUNT
end
function anniversaryTreasureHuntCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_TREASURE_HUNT_MODULE, gCmd.REQ_TREASURE_HUNT_INIT, handler(self, self.reqInitInfoRsp))
	msgCtrl.register(gCmd.CMD_TREASURE_HUNT_MODULE, gCmd.REQ_TREASURE_HUNT_CAST_DICE, handler(self, self.reqThrowDiceRsp))
	msgCtrl.register(gCmd.CMD_TREASURE_HUNT_MODULE, gCmd.REQ_TREASURE_HUNT_BUY_DICE, handler(self, self.reqBuyDiceCountRsp))
	msgCtrl.register(gCmd.CMD_TREASURE_HUNT_MODULE, gCmd.REQ_TREASURE_HUNT_IGNORE_MERCHANT, handler(self, self.reqCancelBuyPackageRsp))
	msgCtrl.register(gCmd.CMD_TREASURE_HUNT_MODULE, gCmd.REQ_TREASURE_HUNT_BUY_GIFT, handler(self, self.reqBuyPackageRsp))
	msgCtrl.register(gCmd.CMD_TREASURE_HUNT_MODULE, gCmd.REQ_TREASURE_HUNT_GET_REWARD, handler(self, self.reqGetRewardRsp))
	self:resetData()
	self:registerNotify()
end
function anniversaryTreasureHuntCtrl:initClientData(content)
	dump(content, "==anniversaryTreasureHuntCtrl:initClientData==", 20)
	if not content then
		return
	end
	self.completeData = content.complete
	self.initReward = content.receivedReward
end
function anniversaryTreasureHuntCtrl:resetData()
	self.activityData, _UPVALUE0_ = nil, nil
	self.castData = nil
	self.completeData = nil
	self.initReward = nil
end
function anniversaryTreasureHuntCtrl:Logout()
	self:resetData()
	anniversaryTreasureHuntCtrl.super.Logout(self)
end
function anniversaryTreasureHuntCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.TREASURE_HUNT, handler(self, self.notifyHandler))
end
function anniversaryTreasureHuntCtrl:notifyHandler(event)
	dump(event.data, "anniversaryTreasureHuntCtrl:notifyHandler event.data", 10)
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
					_ENV = content.data.buyTimes
					content.data.buyTimes.msg = "MESSAGE_ANNIVERSARY_TREASURE_HUNT_BUY_PACKAGE"
					SoraDSendMessage(content.data.buyTimes)
				else
					_ENV = content.data.buyTimes
					content.data.buyTimes.msg = "MESSAGE_ANNIVERSARY_TREASURE_HUNT_REFRESH_PACKAGE_STATE"
					SoraDSendMessage(content.data.buyTimes)
				end
			elseif content.type == "taskCompete" then
			end
		end
	end
end
function anniversaryTreasureHuntCtrl:sendReqInitDataMsg(...)
	self:sendReqInitInfoMsg(...)
end
function anniversaryTreasureHuntCtrl:sendReqInitInfoMsg()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_TREASURE_HUNT_MODULE, gCmd.REQ_TREASURE_HUNT_INIT, data)
end
function anniversaryTreasureHuntCtrl:reqThrowDiceMsg()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_TREASURE_HUNT_MODULE, gCmd.REQ_TREASURE_HUNT_CAST_DICE, data)
end
function anniversaryTreasureHuntCtrl:reqBuyDiceCountMsg(buyCount)
	serverproxy = nil
	local (nil).buyCount, data = buyCount, nil
	serverproxy:Request(gCmd.CMD_TREASURE_HUNT_MODULE, gCmd.REQ_TREASURE_HUNT_BUY_DICE, data)
end
function anniversaryTreasureHuntCtrl:reqCancelBuyPackageMsg()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_TREASURE_HUNT_MODULE, gCmd.REQ_TREASURE_HUNT_IGNORE_MERCHANT, data)
end
function anniversaryTreasureHuntCtrl:reqBuyPackageMsg(rechargeID)
	serverproxy = nil
	local (nil).rechargeID, data = rechargeID, nil
	serverproxy:Request(gCmd.CMD_TREASURE_HUNT_MODULE, gCmd.REQ_TREASURE_HUNT_BUY_GIFT, data)
end
function anniversaryTreasureHuntCtrl:reqGetRewardMsg(taskType, index)
	serverproxy = nil
	;(nil).taskType = taskType
	local (nil).index, data = index, nil
	serverproxy:Request(gCmd.CMD_TREASURE_HUNT_MODULE, gCmd.REQ_TREASURE_HUNT_GET_REWARD, data)
end
function anniversaryTreasureHuntCtrl:reqInitInfoRsp(content)
	dump(content, "anniversaryTreasureHuntCtrl:reqInitInfoRsp===", 10)
	if content.err == gErrDef.Err_None then
		self.activityData = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ANNIVERSARY_TREASURE_HUNT_INIT_BACK"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function anniversaryTreasureHuntCtrl:reqThrowDiceRsp(content)
	dump(content, "anniversaryTreasureHuntCtrl:reqThrowDiceRsp===", 10)
	if content.err == gErrDef.Err_None then
		self.activityData = content.rspdata
		self.castData = content.castdata
		self.completeData = self.activityData.complete
		self.initReward = self.activityData.receivedReward
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ANNIVERSARY_TREASURE_GET_REWARD_BACK"
		SoraDSendMessage(gErrDef.Err_None)
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		gErrDef.Err_None.eventID = self.activityID
		SoraDSendMessage(gErrDef.Err_None)
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_ANNIVERSARY_TREASURE_HUNT_THROW_DICE"
	gErrDef.Err_None.err = content.err
	SoraDSendMessage(gErrDef.Err_None)
end
function anniversaryTreasureHuntCtrl:reqBuyDiceCountRsp(content)
	dump(content, "anniversaryTreasureHuntCtrl:reqBuyDiceCountRsp===", 10)
	if content.err == gErrDef.Err_None then
		self.activityData = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ANNIVERSARY_TREASURE_HUNT_BUY_DICE_COUNT"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function anniversaryTreasureHuntCtrl:reqCancelBuyPackageRsp(content)
	dump(content, "anniversaryTreasureHuntCtrl:reqCancelBuyPackageRsp===", 10)
	if content.err == gErrDef.Err_None then
		self.activityData.giftMerchant, _ENV = gErrDef.Err_None, gErrDef.Err_None
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ANNIVERSARY_TREASURE_HUNT_CANCEL_BUY_PACKAGE"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function anniversaryTreasureHuntCtrl:reqBuyPackageRsp(content)
	dump(content, "anniversaryTreasureHuntCtrl:reqBuyPackageRsp===", 10)
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
function anniversaryTreasureHuntCtrl:reqGetRewardRsp(content)
	dump(content, "anniversaryTreasureHuntCtrl:reqGetRewardRsp===", 10)
	if content.err == gErrDef.Err_None then
		self.activityData = content.rspdata
		self.initReward = self.activityData.receivedReward
		if content.rspreward then
			SoraDMailGainItems(content.rspreward, true)
		end
		_ENV = content.rspreward
		content.rspreward.msg = "MESSAGE_ANNIVERSARY_TREASURE_GET_REWARD_BACK"
		SoraDSendMessage(content.rspreward)
		_ENV = content.rspreward
		content.rspreward.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		content.rspreward.eventID = self.activityID
		SoraDSendMessage(content.rspreward)
	end
end
function anniversaryTreasureHuntCtrl:getOwnDiceCount()
	return tonumber(self.activityData.diceNum) or 0
end
function anniversaryTreasureHuntCtrl:getAlreadyBuyDiceCount()
	return tonumber(self.activityData.buyDiceNum) or 0
end
function anniversaryTreasureHuntCtrl:getCurGrid()
	local curStepCount = 0
	if self.activityData.curStepCount == 0 then
		curStepCount = 1
	elseif 0 < self:getMapSize() then
		curStepCount = (self.activityData.curStepCount - 1) % self:getMapSize() + 1
	end
	return curStepCount
end
function anniversaryTreasureHuntCtrl:getMerchantGridInfo()
	dump(self.activityData, "sdkfjlsdjfklsd")
	return self.activityData.giftMerchant
end
function anniversaryTreasureHuntCtrl:isMerchantGrid()
	local isMerchantGrid = false
	if next(self.activityData.giftMerchant) then
		isMerchantGrid = true
	end
	return isMerchantGrid
end
function anniversaryTreasureHuntCtrl:getTotalThrowTimes()
	return self.activityData.castDiceCount or 0
end
function anniversaryTreasureHuntCtrl:getTotalStepCount()
	local totalStepCount = self.activityData.stepBeforeCount
	if totalStepCount - 1 < 0 then
		totalStepCount = 0
	end
	return totalStepCount
end
function anniversaryTreasureHuntCtrl:getTotalRoundCount()
	local totalRoundCount = self.activityData.roundCount
	if totalRoundCount <= 1 and self.activityData.curStepCount <= 35 then
		totalRoundCount = 0
	else
		totalRoundCount = totalRoundCount - 1
	end
	return totalRoundCount
end
function anniversaryTreasureHuntCtrl:isRewardClaimed(index)
	local isClaimed = false
	if self.activityData.receivedReward[tostring(index)] then
		isClaimed = true
	end
	return isClaimed
end
function anniversaryTreasureHuntCtrl:getMapSize()
	return self.activityData.mapSize or 1
end
function anniversaryTreasureHuntCtrl:getCastDataStepSet()
	if self.castData then
		return self.castData.stepSet
	end
end
function anniversaryTreasureHuntCtrl:getAmazingGridEventTypeAndNum(index)
	local aType = gTHAmazingEvent.NONE
	local num = 0
	if self.castData and self.activityData then
		if self.activityData.advMultiple > 1 then
			aType = gTHAmazingEvent.MUTIPLE_DICE
			num = self.activityData.advMultiple
		elseif self.castData.stepSet then
			for i, v in ipairs(self.castData.stepSet) do
				if index == v.curMapIndex then
					if 0 <= v.adjustStepCount then
						do
							local anniversaryTreasureHuntRead = include("anniversaryTreasureHuntRead")
							local realType = anniversaryTreasureHuntRead:getMapRealType((index + v.adjustStepCount) % 35)
							if realType and realType == gTHAmazingEvent.MERCHANT then
								aType = gTHAmazingEvent.MERCHANT
							else
								aType = gTHAmazingEvent.FORWARD
							end
							num = v.adjustStepCount
						end
						break
					end
					aType = gTHAmazingEvent.BACK
					num = -v.adjustStepCount
					break
				end
			end
		end
	end
	return aType, num
end
function anniversaryTreasureHuntCtrl:getMultipleForAmazing()
	local advMultiple = 1
	if self.castData then
		advMultiple = self.castData.advMultiple
	end
	return advMultiple
end
function anniversaryTreasureHuntCtrl:getCastDataRewards()
	local _UPVALUE0_, rewards
	if self.castData and self.castData.rewards then
		rewards = self.castData.rewards
	end
	return rewards
end
function anniversaryTreasureHuntCtrl:isAllPackageBought()
	local isAllBought = true
	for k, v in pairs(self.activityData.giftMerchant) do
		if not v.purchased then
			isAllBought = false
			break
		end
	end
	return isAllBought
end
function anniversaryTreasureHuntCtrl:getReceiveStatusAndNum()
	local totalNum = 0
	if self.completeData then
		for k, v in pairs(self.completeData) do
			for j, m in pairs(v) do
				if not self.initReward[j] then
					totalNum = totalNum + 1
				end
			end
		end
	end
	if 0 < totalNum then
		return 0 < totalNum, totalNum
	end
	if 0 < self:getOwnDiceCount() then
		return true, -1
	end
	return false, 0
end
function anniversaryTreasureHuntCtrl:getSortedTaskList()
	local anniversaryTreasureHuntRead = include("anniversaryTreasureHuntRead")
	local taskList = anniversaryTreasureHuntRead:getTreasureHuntAchievementInfo()
	for i, v in ipairs(taskList) do
		local curCount = 0
		v.weight = 1
		if v.type == gAchievementTaskType.TOTAL_THROW_DICE_TIME then
			curCount = self:getTotalThrowTimes()
		elseif v.type == gAchievementTaskType.TOTAL_STEP_COUNT then
			curCount = self:getTotalStepCount()
		elseif v.type == gAchievementTaskType.TOTAL_ROUND_COUNT then
			curCount = self:getTotalRoundCount()
		end
		if curCount >= v.require then
			if self:isRewardClaimed(v.index) then
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
			return a.index < b.index
		else
			return a.weight > b.weight
		end
	end)
	return taskList
end
function anniversaryTreasureHuntCtrl:isCurGearAllbought(packageID)
	local isAllBought = false
	local curBuyTimes = 0
	if self.activityData and next(self.activityData.buyTimes) then
		local anniversaryTreasureHuntRead = include("anniversaryTreasureHuntRead")
		local packageInfo = anniversaryTreasureHuntRead:getTreasureHuntPackageInfo(packageID)
		local packageList = anniversaryTreasureHuntRead:getTreasureHuntPackageInfoByPrice(packageInfo.price)
		for i, v in ipairs(packageList) do
			if self.activityData.buyTimes[tostring(v.index)] then
				curBuyTimes = curBuyTimes + 1
			end
		end
		isAllBought = curBuyTimes == #packageList
	end
end
function anniversaryTreasureHuntCtrl:getStarLv()
	return self.activityData.starLv or 0
end
return anniversaryTreasureHuntCtrl

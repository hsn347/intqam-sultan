local gametop = gModuleMgr.getObject("gametop")
local GameModule = include("GameModule")
local raidersLostArkCtrl = class("raidersLostArkCtrl", GameModule)
local msgCtrl = include("msgCtrl")
local serverproxy = gModuleMgr.getObject("serverproxy")
function raidersLostArkCtrl:ctor(properties)
	raidersLostArkCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.RAIDERS_LOST_ARK
end
function raidersLostArkCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_RAIDERS_LOST_ARK_MODULE, gCmd.REQ_RAIDERS_LOST_ARK_ENTER_ROBBERY, handler(self, self.reqRobberyEnterRsp))
	msgCtrl.register(gCmd.CMD_RAIDERS_LOST_ARK_MODULE, gCmd.REQ_RAIDERS_LOST_ARK_REFRESH, handler(self, self.reqRobberyRefreshRsp))
	msgCtrl.register(gCmd.CMD_RAIDERS_LOST_ARK_MODULE, gCmd.REQ_RAIDERS_LOST_ARK_BUY_ROBBERY_TIMES, handler(self, self.reqRobberyTimesRsp))
	msgCtrl.register(gCmd.CMD_RAIDERS_LOST_ARK_MODULE, gCmd.REQ_RAIDERS_LOST_ARK_ROBBERY, handler(self, self.reqRobberyRsp))
	msgCtrl.register(gCmd.CMD_RAIDERS_LOST_ARK_MODULE, gCmd.REQ_RAIDERS_LOST_ARK_OPEN_BOX, handler(self, self.reqOpenBoxRsp))
	self:resetData()
	self:initKeyNums()
end
function raidersLostArkCtrl:resetData()
	self.clientData = nil
	self.rewardData = nil
	self.keyNumData, _UPVALUE0_, self.snatchedData = nil, nil, nil
end
function raidersLostArkCtrl:initKeyNums()
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	_UPVALUE15_ = "backpackCtrl"
	;("backpackCtrl")[1] = 830701
	;("backpackCtrl")[2] = 830801
	;("backpackCtrl")[3] = 830901
	;("backpackCtrl")[4] = 831001
	;("backpackCtrl")[5] = 831101
	;("backpackCtrl")[6] = 831201
	;("backpackCtrl")[7] = 831301
	;("backpackCtrl")[8] = 831401
	;("backpackCtrl")[9] = 831501
	;("backpackCtrl")[10] = 831601
	;("backpackCtrl")[11] = 831701
	;("backpackCtrl")[12] = 831801
	;("backpackCtrl")[13] = 831901
	;("backpackCtrl")[14] = 832001
	local ("backpackCtrl")[15], keyList = 832201, "backpackCtrl"
	for i, v in ipairs(keyList) do
		local keyCount = backpackCtrl:getItemCount(v)
		if not self.keyNumData[v] then
			self.keyNumData[v], _ENV = v, v
		end
		self.keyNumData[v] = keyCount
	end
end
function raidersLostArkCtrl:initClientData(data)
	dump(data, "raidersLostArkCtrl:initClientData=====")
	if data and next(data) then
		self.clientData = data
	end
end
function raidersLostArkCtrl:Logout()
	self:resetData()
	raidersLostArkCtrl.super.Logout(self)
end
function raidersLostArkCtrl:reqRobberyEnter(itemID)
	serverproxy = nil
	local (nil).itemID, data = itemID, nil
	serverproxy:Request(gCmd.CMD_RAIDERS_LOST_ARK_MODULE, gCmd.REQ_RAIDERS_LOST_ARK_ENTER_ROBBERY, data)
end
function raidersLostArkCtrl:reqRobberyRefresh()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_RAIDERS_LOST_ARK_MODULE, gCmd.REQ_RAIDERS_LOST_ARK_REFRESH, data)
end
function raidersLostArkCtrl:reqRobberyTimes()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_RAIDERS_LOST_ARK_MODULE, gCmd.REQ_RAIDERS_LOST_ARK_BUY_ROBBERY_TIMES, data)
end
function raidersLostArkCtrl:reqRobbery(targetID, itemID, armsInfo, armyInfo, heroInfo, divineBeastInfo)
	serverproxy = nil
	;(nil).targetID = targetID
	;(nil).itemID = itemID
	;(nil).armsInfo = armsInfo
	;(nil).armyInfo = armyInfo
	;(nil).heroInfo = heroInfo
	local (nil).divineBeastInfo, data = divineBeastInfo, nil
	serverproxy:Request(gCmd.CMD_RAIDERS_LOST_ARK_MODULE, gCmd.REQ_RAIDERS_LOST_ARK_ROBBERY, data)
end
function raidersLostArkCtrl:reqOpenBox(boxType, times)
	serverproxy = nil
	;(nil).boxType = boxType
	local (nil).times, data = times or 1, nil
	serverproxy:Request(gCmd.CMD_RAIDERS_LOST_ARK_MODULE, gCmd.REQ_RAIDERS_LOST_ARK_OPEN_BOX, data)
end
function raidersLostArkCtrl:reqRobberyEnterRsp(content)
	dump(content, "raidersLostArkCtrl:reqRobberyEnterRsp===", 10)
	if content.err == gErrDef.Err_None then
		self.clientData = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_RAIDER_LOST_ARK_ENTER_SNATCH"
		SoraDSendMessage(gErrDef.Err_None)
	elseif content.err == gErrDef.Err_RAIDERS_LOST_ARK_TARGET_ERROR then
		_ENV = gErrDef.Err_RAIDERS_LOST_ARK_TARGET_ERROR
		gErrDef.Err_RAIDERS_LOST_ARK_TARGET_ERROR.msg = "MESSAGE_SERVER_RAIDER_LOST_ARK_ENTER_FAILED"
		SoraDSendMessage(gErrDef.Err_RAIDERS_LOST_ARK_TARGET_ERROR)
	end
end
function raidersLostArkCtrl:reqRobberyRefreshRsp(content)
	dump(content, "raidersLostArkCtrl:reqRobberyRefreshRsp===", 10)
	if content.err == gErrDef.Err_None then
		if self.clientData.targetList then
			self.clientData.targetList = content.rspdata.targetList
		end
		_ENV = content.rspdata.targetList
		content.rspdata.targetList.msg = "MESSAGE_SERVER_RAIDER_LOST_ARK_REFRESH_ROBBERY_TARGET"
		SoraDSendMessage(content.rspdata.targetList)
	end
end
function raidersLostArkCtrl:reqRobberyTimesRsp(content)
	dump(content, "raidersLostArkCtrl:reqRobberyTimesRsp===", 10)
	if content.err == gErrDef.Err_None then
		if self.clientData.buyRobberyTimes then
			self.clientData.buyRobberyTimes = content.rspdata.buyRobberyTimes
		end
		if self.clientData.robberyTimes then
			self.clientData.robberyTimes = content.rspdata.robberyTimes
		end
		_ENV = content.rspdata.robberyTimes
		content.rspdata.robberyTimes.msg = "MESSAGE_SERVER_RAIDER_LOST_ARK_BUY_ROBBERY_TIMES"
		SoraDSendMessage(content.rspdata.robberyTimes)
	end
end
function raidersLostArkCtrl:reqRobberyRsp(content)
	dump(content, "raidersLostArkCtrl:reqRobberyRsp===", 10)
	if content.err == gErrDef.Err_None then
		self.snatchedData = content.rspdata
		if self.clientData.robberyTimes then
			self.clientData.robberyTimes = content.rspdata.robberyTimes
		end
		if self.clientData.targetList and content.rspdata.targetList then
			self.clientData.targetList = content.rspdata.targetList
		end
		_ENV = content.rspdata.targetList
		content.rspdata.targetList.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		content.rspdata.targetList.eventID = self.activityID
		SoraDSendMessage(content.rspdata.targetList)
		_ENV = content.rspdata.targetList
		content.rspdata.targetList.msg = "MESSAGE_SERVER_RAIDER_LOST_ARK_BEGIN_ROBBERY"
		SoraDSendMessage(content.rspdata.targetList)
	elseif content.err == gErrDef.Err_RAIDERS_LOST_ARK_ROBBERY_TIMES_NOT_ENOUGH then
		_ENV = gErrDef.Err_RAIDERS_LOST_ARK_ROBBERY_TIMES_NOT_ENOUGH
		gErrDef.Err_RAIDERS_LOST_ARK_ROBBERY_TIMES_NOT_ENOUGH.msg = "MESSAGE_SERVER_RAIDER_LOST_ARK_ROBBERY_TIMES_NOT_ENOUGH"
		SoraDSendMessage(gErrDef.Err_RAIDERS_LOST_ARK_ROBBERY_TIMES_NOT_ENOUGH)
	elseif content.err == gErrDef.Err_RAIDERS_LOST_ARK_BATTLE_INFO_ILLEGAL then
		_ENV = gErrDef.Err_RAIDERS_LOST_ARK_BATTLE_INFO_ILLEGAL
		gErrDef.Err_RAIDERS_LOST_ARK_BATTLE_INFO_ILLEGAL.msg = "MESSAGE_SERVER_RAIDER_LOST_ARK_ROBBERY_TROOPS_ERROR"
		SoraDSendMessage(gErrDef.Err_RAIDERS_LOST_ARK_BATTLE_INFO_ILLEGAL)
	end
end
function raidersLostArkCtrl:reqOpenBoxRsp(content)
	dump(content, "raidersLostArkCtrl:reqOpenBoxRsp===", 10)
	if content.err == gErrDef.Err_None then
		self.rewardData = content.rspdata.reward
		if not self.clientData then
			self.clientData, _ENV = self.clientData, self.clientData
		end
		self.clientData.openBoxTimes = content.rspdata.openBoxTimes
		_ENV = content.rspdata.openBoxTimes
		content.rspdata.openBoxTimes.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		content.rspdata.openBoxTimes.eventID = self.activityID
		SoraDSendMessage(content.rspdata.openBoxTimes)
		_ENV = content.rspdata.openBoxTimes
		content.rspdata.openBoxTimes.msg = "MESSAGE_SERVER_RAIDER_LOST_ARK_OPEN_CHEST"
		SoraDSendMessage(content.rspdata.openBoxTimes)
	elseif content.err == gErrDef.Err_RAIDERS_LOST_ARK_OPEN_BOX_LIMIT then
		_ENV = gErrDef.Err_RAIDERS_LOST_ARK_OPEN_BOX_LIMIT
		gErrDef.Err_RAIDERS_LOST_ARK_OPEN_BOX_LIMIT.msg = "MESSAGE_SERVER_RAIDER_LOST_ARK_OPEN_CHEST_NUM_LIMIT"
		SoraDSendMessage(gErrDef.Err_RAIDERS_LOST_ARK_OPEN_BOX_LIMIT)
	end
end
function raidersLostArkCtrl:getRewardList()
	local rewardList
	if self.rewardData then
		rewardList = self.rewardData
	end
	return rewardList
end
function raidersLostArkCtrl:getTodayRemainRobberyTimes()
	local remainTimes = 0
	if self.clientData.robberyTimes then
		remainTimes = self.clientData.robberyTimes
	end
	return remainTimes
end
function raidersLostArkCtrl:getTodayBuyRobberyTimes()
	local buyTimes = 0
	if self.clientData.buyRobberyTimes then
		buyTimes = self.clientData.buyRobberyTimes
		dump(buyTimes, "Fskdfjkdsjfkdjfkdjfkdjfk")
	end
	return buyTimes
end
function raidersLostArkCtrl:getTargetListInfo(probability)
	local _UPVALUE0_, targetList
	if self.clientData.targetList and self.clientData.targetList[probability] then
		targetList = self.clientData.targetList[probability]
	end
	return targetList
end
function raidersLostArkCtrl:getArmyTotalNums(probability)
	local armyTotalNums = 0
	if self.clientData.targetList and self.clientData.targetList[probability] and self.clientData.targetList[probability].armyInfo then
		for i, v in ipairs(self.clientData.targetList[probability].armyInfo) do
			armyTotalNums = armyTotalNums + v.num
		end
	end
	return armyTotalNums
end
function raidersLostArkCtrl:getBattleReportData()
	local _UPVALUE0_, battleReportData
	if self.snatchedData and self.snatchedData.battleReport then
		battleReportData = self.snatchedData.battleReport
	end
	return battleReportData
end
function raidersLostArkCtrl:getWinOrLostRelation()
	local isWin = false
	local keyID
	if self.snatchedData and self.snatchedData.isWin then
		isWin = self.snatchedData.isWin
	end
	if self.snatchedData and self.snatchedData.keyID then
		keyID = self.snatchedData.keyID
	end
	return isWin, keyID
end
function raidersLostArkCtrl:getSnatchedRewardList()
	local _UPVALUE0_, snatchRewarDList
	if self.snatchedData and self.snatchedData.reward then
		snatchRewarDList = self.snatchedData.reward
	end
	return snatchRewarDList
end
function raidersLostArkCtrl:isSatisfyZeroToOne(itemID)
	local isSatisfy = false
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	if next(self.keyNumData) and self.keyNumData[itemID] and self.keyNumData[itemID] == 0 then
		local curCount = backpackCtrl:getItemCount(itemID)
		if 0 < curCount then
			isSatisfy = true
		end
		self.keyNumData[itemID] = curCount
	end
	return isSatisfy
end
function raidersLostArkCtrl:getReceiveStatusAndNum(activityID)
	local ret, redNum = false, 0
	local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local raidersLostArkRead = include("raidersLostArkRead")
	local secondRet, secondNum = activityExchangeMallCtrl:getReceiveStatusAndNum(activityID)
	local firstNum = raidersLostArkRead:getTotalTreasureOpenCount()
	local dailyBoxNum = include("constantRead").getConstValue("SNATCH_TREASURE_BOX_NUM", 630)
	firstNum = math.min(firstNum, math.max(0, dailyBoxNum - self:getOpenBoxTimes()))
	redNum = firstNum + secondNum
	if 0 < redNum then
		ret = true
	end
	local eventState = activityShowCtrl:getStateByID(activityID)
	if eventState == gActivityState.PREPARE then
		redNum = -1
		ret = false
	end
	return ret, redNum
end
function raidersLostArkCtrl:getOpenBoxTimes()
	return self.clientData and self.clientData.openBoxTimes or 0
end
return raidersLostArkCtrl

local gametop = gModuleMgr.getObject("gametop")
local GameModule = include("GameModule")
local starCubeCtrl = class("starCubeCtrl", GameModule)
local msgCtrl = include("msgCtrl")
local serverproxy = gModuleMgr.getObject("serverproxy")
function starCubeCtrl:ctor(properties)
	starCubeCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.STAR_CUBE_ACTIVITY
end
function starCubeCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_RAIDERS_LOST_ARK_MODULE, gCmd.REQ_STAR_CUBE_ENTER_ROBBERY, handler(self, self.reqStarCubeEnterRsp))
	msgCtrl.register(gCmd.CMD_RAIDERS_LOST_ARK_MODULE, gCmd.REQ_STAR_CUBE_REFRESH, handler(self, self.reqStarCubeRefreshRsp))
	msgCtrl.register(gCmd.CMD_RAIDERS_LOST_ARK_MODULE, gCmd.REQ_STAR_CUBE_BUY_ROBBERY_TIMES, handler(self, self.reqStarCubeTimesRsp))
	msgCtrl.register(gCmd.CMD_RAIDERS_LOST_ARK_MODULE, gCmd.REQ_STAR_CUBE_ROBBERY, handler(self, self.reqStarCubeRsp))
	msgCtrl.register(gCmd.CMD_RAIDERS_LOST_ARK_MODULE, gCmd.REQ_STAR_CUBE_OPEN_BOX, handler(self, self.reqOpenBoxRsp))
	msgCtrl.register(gCmd.CMD_RAIDERS_LOST_ARK_MODULE, gCmd.REQ_STAR_CUBE_REWARD, handler(self, self.reqStageRewardRsp))
	msgCtrl.register(gCmd.CMD_RAIDERS_LOST_ARK_MODULE, gCmd.REQ_STAR_CUBE_BUY_KEY, handler(self, self.reqBuyBoxKeyRsp))
	self:resetData()
end
function starCubeCtrl:initClientData(data)
	if not data then
		return
	end
	dump(data, "starCubeCtrl:initClientData")
	self.buyRobberyTimes = data.buyRobberyTimes
	self.dailyTime = data.dailyTime
	self.openBoxTimesTable = data.openBoxTimesTable
	self.openCount = data.openCount
	self.robberyTimes = data.robberyTimes
	self.countRewardList = data.countRewardList
	self.monsterDropTimes = data.monsterDropTimes
end
function starCubeCtrl:resetData()
	_UPVALUE0_, self.buyRobberyTimes = nil, 0
	;(nil)["1"] = 0
	;(nil)["2"] = 0
	;(nil)["3"] = 0
	;(nil)["4"] = 0
	self.openBoxTimesTable, (nil)["5"] = nil, 0
	self.monsterDropTimes, _UPVALUE0_, self.countRewardList, _UPVALUE0_, self.targetList, _UPVALUE0_, self.robberyTimes = nil, nil, nil, nil, nil, nil, 0
end
function starCubeCtrl:initKeyNums()
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
function starCubeCtrl:Logout()
	self:resetData()
	starCubeCtrl.super.Logout(self)
end
function starCubeCtrl:reqStarCubeEnter(itemID)
	serverproxy = nil
	;(nil).itemID = itemID
	serverproxy:Request(gCmd.CMD_RAIDERS_LOST_ARK_MODULE, gCmd.REQ_STAR_CUBE_ENTER_ROBBERY, nil)
end
function starCubeCtrl:reqStarCubeRefresh()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_RAIDERS_LOST_ARK_MODULE, gCmd.REQ_STAR_CUBE_REFRESH, nil)
end
function starCubeCtrl:reqStarCubeTimes(times)
	serverproxy = nil
	;(nil).times = times
	serverproxy:Request(gCmd.CMD_RAIDERS_LOST_ARK_MODULE, gCmd.REQ_STAR_CUBE_BUY_ROBBERY_TIMES, nil)
end
function starCubeCtrl:reqStarCubeRobbery(targetID, itemID, armsInfo, armyInfo, heroInfo, divineBeastInfo)
	serverproxy = nil
	;(nil).targetID = targetID
	;(nil).itemID = itemID
	;(nil).armsInfo = armsInfo
	;(nil).armyInfo = armyInfo
	;(nil).heroInfo = heroInfo
	local (nil).divineBeastInfo, data = divineBeastInfo, nil
	serverproxy:Request(gCmd.CMD_RAIDERS_LOST_ARK_MODULE, gCmd.REQ_STAR_CUBE_ROBBERY, data)
end
function starCubeCtrl:reqStarCubeOpenBox(boxType, times)
	serverproxy = nil
	;(nil).boxType = boxType
	;(nil).times = times
	serverproxy:Request(gCmd.CMD_RAIDERS_LOST_ARK_MODULE, gCmd.REQ_STAR_CUBE_OPEN_BOX, nil)
end
function starCubeCtrl:reqStarCubeStageReward(index)
	serverproxy = nil
	;(nil).index = index
	serverproxy:Request(gCmd.CMD_RAIDERS_LOST_ARK_MODULE, gCmd.REQ_STAR_CUBE_REWARD, nil)
end
function starCubeCtrl:reqStarCubeBuyOpenKey(boxType)
	serverproxy = nil
	;(nil).boxType = boxType
	serverproxy:Request(gCmd.CMD_RAIDERS_LOST_ARK_MODULE, gCmd.REQ_STAR_CUBE_BUY_KEY, nil)
end
function starCubeCtrl:reqStarCubeEnterRsp(content)
	dump(content, "starCubeCtrl:reqStarCubeEnterRsp===", 10)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self.buyRobberyTimes = data.buyRobberyTimes
		self.robberyTimes = data.robberyTimes
		self.targetList = data.targetList
		_ENV = "starCubeCtrl:reqStarCubeEnterRsp==="
		;("starCubeCtrl:reqStarCubeEnterRsp===").msg = "MESSAGE_STAR_ENERGY_CUBE"
		;("starCubeCtrl:reqStarCubeEnterRsp===").subMsg = "enterSuccess"
		;("starCubeCtrl:reqStarCubeEnterRsp===").itemID = content.data.itemID
		SoraDSendMessage("starCubeCtrl:reqStarCubeEnterRsp===")
	elseif content.err == gErrDef.Err_RAIDERS_LOST_ARK_TARGET_ERROR then
		SoraDShowMsgTip(i18n("Martial_arts_text_10"))
	end
end
function starCubeCtrl:reqStarCubeRefreshRsp(content)
	dump(content, "starCubeCtrl:reqStarCubeRefreshRsp===", 10)
	if content.err == gErrDef.Err_None then
		self.targetList = content.rspdata.targetList
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_STAR_ENERGY_CUBE"
		gErrDef.Err_None.subMsg = "refreshTarget"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function starCubeCtrl:reqStarCubeTimesRsp(content)
	dump(content, "starCubeCtrl:reqStarCubeTimesRsp===", 10)
	if content.err == gErrDef.Err_None then
		self.buyRobberyTimes = content.rspdata.buyRobberyTimes
		SoraDMailGainItems(content.rspdata.buyItem, true)
		_ENV = content.rspdata.buyItem
		content.rspdata.buyItem.msg = "MESSAGE_STAR_ENERGY_CUBE"
		content.rspdata.buyItem.subMsg = "times"
		SoraDSendMessage(content.rspdata.buyItem)
	end
end
function starCubeCtrl:reqStarCubeRsp(content)
	dump(content, "starCubeCtrl:reqStarCubeRsp===", 10)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self.robberyTimes = data.robberyTimes
		self.targetList = data.targetList
		self.battleReport = data.battleReport
		if data.isWin then
			_ENV = "starCubeCtrl:reqStarCubeRsp==="
			;("starCubeCtrl:reqStarCubeRsp===").msg = "MESSAGE_STAR_ENERGY_CUBE"
			;("starCubeCtrl:reqStarCubeRsp===").subMsg = "snatchSuccess"
			;("starCubeCtrl:reqStarCubeRsp===").reward = data.reward
			;("starCubeCtrl:reqStarCubeRsp===").keyID = data.keyID
			SoraDSendMessage("starCubeCtrl:reqStarCubeRsp===")
		else
			_ENV = "starCubeCtrl:reqStarCubeRsp==="
			;("starCubeCtrl:reqStarCubeRsp===").msg = "MESSAGE_STAR_ENERGY_CUBE"
			;("starCubeCtrl:reqStarCubeRsp===").subMsg = "snatchFail"
			;("starCubeCtrl:reqStarCubeRsp===").itemID = data.itemID
			;("starCubeCtrl:reqStarCubeRsp===").reward = data.reward
			SoraDSendMessage("starCubeCtrl:reqStarCubeRsp===")
		end
		return
	elseif content.err == gErrDef.Err_RAIDERS_LOST_ARK_ROBBERY_TIMES_NOT_ENOUGH then
		SoraDShowMsgTip(i18n("remains_text_79"))
	elseif content.err == gErrDef.Err_RAIDERS_LOST_ARK_BATTLE_INFO_ILLEGAL then
		SoraDShowMsgTip(i18n("Martial_arts_text_26"))
	end
	_ENV = i18n("Martial_arts_text_26")
	i18n("Martial_arts_text_26").msg = "MESSAGE_STAR_ENERGY_CUBE"
	i18n("Martial_arts_text_26").subMsg = "openFail"
	SoraDSendMessage(i18n("Martial_arts_text_26"))
end
function starCubeCtrl:reqOpenBoxRsp(content)
	dump(content, "starCubeCtrl:reqOpenBoxRsp===", 10)
	if content.err == gErrDef.Err_None then
		self.openBoxTimesTable[tostring(content.data.boxType)] = content.rspdata.openBoxTimes
		_ENV = tostring(content.data.boxType)
		tostring(content.data.boxType).msg = "MESSAGE_STAR_ENERGY_CUBE"
		tostring(content.data.boxType).subMsg = "openSuccess"
		tostring(content.data.boxType).reward = content.rspdata.reward
		SoraDSendMessage((tostring(content.data.boxType)))
	elseif content.err == gErrDef.Err_RAIDERS_LOST_ARK_OPEN_BOX_LIMIT then
		SoraDShowMsgTip(i18n("remains_text_79"))
	end
end
function starCubeCtrl:reqStageRewardRsp(content)
	dump(content, "starCubeCtrl:reqStageRewardRsp===", 10)
	if content.err == gErrDef.Err_None then
		self.countRewardList = content.rspdata.countRewardList
		SoraDMailGainItems(content.rspdata.reward, true)
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_STAR_ENERGY_CUBE"
		content.rspdata.reward.subMsg = "stageReward"
		content.rspdata.reward.reward = content.rspdata.reward
		SoraDSendMessage(content.rspdata.reward)
	end
end
function starCubeCtrl:reqBuyBoxKeyRsp(content)
	dump(content, "starCubeCtrl:reqBuyBoxKeyRsp", 10)
	if content.err == gErrDef.Err_None then
		SoraDMailGainItems(content.rspdata.keysTable, true)
		_ENV = content.rspdata.keysTable
		content.rspdata.keysTable.msg = "MESSAGE_STAR_ENERGY_CUBE"
		content.rspdata.keysTable.subMsg = "buyKey"
		SoraDSendMessage(content.rspdata.keysTable)
	end
end
function starCubeCtrl:getOpenBoxTimes(boxType)
	return self.openBoxTimesTable[tostring(boxType)] or 0
end
function starCubeCtrl:getTodayRemainTimes()
	dump(self.robberyTimes, "Fskldfldkfldkfld")
	return self.robberyTimes
end
function starCubeCtrl:getHadBuyTicketTimes()
	return self.buyRobberyTimes
end
function starCubeCtrl:getTargetListInfo()
	return self.targetList
end
function starCubeCtrl:getBattleReportData()
	return self.battleReport
end
function starCubeCtrl:getReceiveStatusAndNum(activityID)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.STAR_CUBE_ACTIVITY) then
		return false, -1
	end
	local constantRead = include("constantRead")
	local limitLv = constantRead.getConstValue("STAR_CUBE_UNLOCK_LEVEL", CASTLE_LV110_LIMITED)
	if limitLv > SoraDGetCastleLv() then
		return false, -1
	end
	local num = 0
	local starEnergyCubeRead = include("starEnergyCubeRead")
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local count = starEnergyCubeRead:getBoxCount()
	for boxIndex = 1, 3 do
		local config = starEnergyCubeRead:getTreasureChestInfo(boxIndex)
		local one = backpackCtrl:getItemCount(config.core1)
		if 0 < one then
			num = num + one
		end
	end
	local starEnergyCubeRead = include("starEnergyCubeRead")
	num = num + (starEnergyCubeRead:getCurScoreLevel(self:getTotalOpenTimes()) - table.nums(self.countRewardList))
	return 0 < num, num
end
function starCubeCtrl:getArmyTotalNums(probability)
	local armyTotalNums = 0
	if self.targetList and self.targetList[probability] and self.targetList[probability].armyInfo then
		for i, v in ipairs(self.targetList[probability].armyInfo) do
			armyTotalNums = armyTotalNums + v.num
		end
	end
	return armyTotalNums
end
function starCubeCtrl:getTotalOpenTimes()
	local totalOpenTimes = 0
	for i, v in pairs(self.openBoxTimesTable) do
		totalOpenTimes = totalOpenTimes + v
	end
	return totalOpenTimes
end
function starCubeCtrl:isInStageReward(boxIndex)
	if self.countRewardList and self.countRewardList[tostring(boxIndex)] then
		return true
	end
	return false
end
return starCubeCtrl

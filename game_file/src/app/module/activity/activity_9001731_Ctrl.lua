local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001731_Ctrl = class("activity_9001731_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001731_Ctrl:ctor(properties)
	activity_9001731_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.FLYING_CHESS_ACTIVITY
	self:resetData()
end
function activity_9001731_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_FLYINGCHESS_MODULE, gCmd.REQ_FLYINGCHESS_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_FLYINGCHESS_MODULE, gCmd.REQ_FLYINGCHESS_START, handler(self, self.reqStartRsp))
	msgCtrl.register(gCmd.CMD_FLYINGCHESS_MODULE, gCmd.REQ_FLYINGCHESS_QUIT, handler(self, self.reqQuitRsp))
	msgCtrl.register(gCmd.CMD_FLYINGCHESS_MODULE, gCmd.REQ_FLYINGCHESS_ROLL, handler(self, self.reqRollRsp))
	msgCtrl.register(gCmd.CMD_FLYINGCHESS_MODULE, gCmd.REQ_FLYINGCHESS_CHOOSE, handler(self, self.reqChooseRsp))
	msgCtrl.register(gCmd.CMD_FLYINGCHESS_MODULE, gCmd.REQ_FLYINGCHESS_USE, handler(self, self.reqUseRsp))
	msgCtrl.register(gCmd.CMD_FLYINGCHESS_MODULE, gCmd.REQ_FLYINGCHESS_SIGN, handler(self, self.reqSignRsp))
	msgCtrl.register(gCmd.CMD_FLYINGCHESS_MODULE, gCmd.REQ_FLYINGCHESS_QUEST, handler(self, self.reqQuestRsp))
	msgCtrl.register(gCmd.CMD_FLYINGCHESS_MODULE, gCmd.REQ_FLYINGCHESS_ROOM_CREATE, handler(self, self.reqRoomCreateRsp))
	msgCtrl.register(gCmd.CMD_FLYINGCHESS_MODULE, gCmd.REQ_FLYINGCHESS_ROOM_SHARE, handler(self, self.reqRoomShareRsp))
	msgCtrl.register(gCmd.CMD_FLYINGCHESS_MODULE, gCmd.REQ_FLYINGCHESS_ROOM_ENTER, handler(self, self.reqRoomEnterRsp))
	msgCtrl.register(gCmd.CMD_FLYINGCHESS_MODULE, gCmd.REQ_FLYINGCHESS_ROOM_QUIT, handler(self, self.reqRoomQuitRsp))
	msgCtrl.register(gCmd.CMD_FLYINGCHESS_MODULE, gCmd.REQ_FLYINGCHESS_ROOM_START, handler(self, self.reqRoomStartRsp))
	msgCtrl.register(gCmd.CMD_FLYINGCHESS_MODULE, gCmd.REQ_FLYINGCHESS_ROOM_READY, handler(self, self.reqRoomReadyRsp))
	msgCtrl.register(gCmd.CMD_FLYINGCHESS_MODULE, gCmd.REQ_FLYINGCHESS_ROOM_KICK, handler(self, self.reqRoomKickRsp))
	msgCtrl.register(gCmd.CMD_FLYINGCHESS_MODULE, gCmd.REQ_FLYINGCHESS_ROOM_GUIDE, handler(self, self.reqRoomGuideRsp))
	self:registerNotify()
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_NEWDAY", handler(self, self.newDay))
end
function activity_9001731_Ctrl:Logout()
	activity_9001731_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001731_Ctrl:resetData()
	_UPVALUE0_ = nil
	;(nil).isUnlockAdvancedSign = false
	;(nil).signIn, _UPVALUE0_, (nil).questData, (nil).questProgress, _UPVALUE0_, (nil).finishedQuest, _UPVALUE0_, (nil).claimedQuest, _UPVALUE0_, _UPVALUE0_, (nil).loginDay = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1
	self.initData, (nil).guide = nil, false
	self.aiCfg, _UPVALUE0_, self.gameData, _UPVALUE0_, self.roomDataBack, _UPVALUE0_, self.roomData = nil, nil, nil, nil, nil, nil, nil
	self.isInGame = false
	self.isCanTurn = false
end
function activity_9001731_Ctrl:initClientData(data)
	dump(data, "activity_9001731_Ctrl:initClientData===")
end
function activity_9001731_Ctrl:newDay()
	local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
	rechargeActivityCtrl:getRechargeActivityInfoReq()
	self:sendReqInitDataMsg()
end
function activity_9001731_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.FLYING_CHESS, handler(self, self.notifyHandler))
end
function activity_9001731_Ctrl:notifyHandler(event)
	dump(event, "activity_9001731_Ctrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		local notifyData = v.notifyData
		local notifyType = v.notifyType
		if notifyType == gFlyingChessEventType.GAMESTART then
			self.isInGame = true
			self.gameData = notifyData.initData
			local firstPlayer = notifyData.playerID
			local _ENV, player
			if self.roomData and next(self.roomData) then
				player = self:getPlayerInfo(firstPlayer)
				self.roomDataBack = clone(self.roomData)
			else
				local activity_9001676_Read = include("activity_9001676_Read")
				local cfg = activity_9001676_Read.getAIPlayers()
				local randomIndex = math.random(1, #cfg)
				self.aiCfg = cfg[randomIndex]
				local isAI = firstPlayer == gFlyingChessPlayer.GREEN
				local nickName = SoraDGetCtrl("lordInfoCtrl"):getNickName()
				local iconID, avatar
				if isAI then
					nickName = i18n(self.aiCfg.name)
					iconID = self.aiCfg.head
					avatar = ""
				end
				_ENV = self.aiCfg
				self.aiCfg.nickName = nickName
				self.aiCfg.iconID = iconID
				player, self.aiCfg.avatar = self.aiCfg, avatar
			end
			_ENV = activity_9001676_Read.getAIPlayers()
			activity_9001676_Read.getAIPlayers().msg = "MESSAGE_ACTIVITY_9001731_START"
			activity_9001676_Read.getAIPlayers().player = player
			activity_9001676_Read.getAIPlayers().rollNum = notifyData.rollNum
			SoraDSendMessage((activity_9001676_Read.getAIPlayers()))
		elseif notifyType == gFlyingChessEventType.CHANGEPLAYER then
			self.isCanTurn = notifyData.playerID == self:getSelfChessPlayer()
			_ENV = self:getSelfChessPlayer()
			self:getSelfChessPlayer().msg = "MESSAGE_ACTIVITY_9001731_PLAYER"
			self:getSelfChessPlayer().playerID = notifyData.playerID
			SoraDSendMessage((self:getSelfChessPlayer()))
		elseif notifyType == gFlyingChessEventType.ROLL then
			_ENV = self:getSelfChessPlayer()
			self:getSelfChessPlayer().msg = "MESSAGE_ACTIVITY_9001731_ROLL"
			self:getSelfChessPlayer().playerID = notifyData.playerID
			self:getSelfChessPlayer().rollNums = notifyData.rollNums
			SoraDSendMessage((self:getSelfChessPlayer()))
		elseif notifyType == gFlyingChessEventType.MOVE then
			self.isCanTurn = true
			_ENV = self:getSelfChessPlayer()
			self:getSelfChessPlayer().msg = "MESSAGE_ACTIVITY_9001731_MOVE"
			self:getSelfChessPlayer().notifyData = notifyData
			SoraDSendMessage((self:getSelfChessPlayer()))
		elseif notifyType == gFlyingChessEventType.USE then
			_ENV = self:getSelfChessPlayer()
			self:getSelfChessPlayer().msg = "MESSAGE_ACTIVITY_9001731_USEITEM"
			self:getSelfChessPlayer().notifyData = notifyData
			SoraDSendMessage((self:getSelfChessPlayer()))
		elseif notifyType == gFlyingChessEventType.GAMEOVER then
			self.isInGame = false
			if notifyData.isQuitGame then
				_ENV = activity_9001676_Read.getAIPlayers()
				activity_9001676_Read.getAIPlayers().rewards = notifyData.rewards
				activity_9001676_Read.getAIPlayers().isWin = notifyData.isWin
				uiManager:show("Activity_9001731_Finish", (activity_9001676_Read.getAIPlayers()))
			else
				_ENV = uiManager
				uiManager.msg = "MESSAGE_ACTIVITY_9001731_GAMEOVER"
				uiManager.notifyData = notifyData
				SoraDSendMessage(uiManager)
			end
		elseif notifyType == gFlyingChessEventType.ITEMCREATE then
			_ENV = uiManager
			uiManager.msg = "MESSAGE_ACTIVITY_9001731_ITEMCREATE"
			uiManager.notifyData = notifyData
			SoraDSendMessage(uiManager)
		elseif notifyType == "refreshData" then
			for k, v in pairs(notifyData) do
				self.initData[k] = v
			end
			_ENV = pairs(notifyData)
			pairs(notifyData).msg = "MESSAGE_ACTIVITY_9001731_UPDATE"
			SoraDSendMessage(pairs(notifyData))
		elseif notifyType == "beKicked" then
			self.roomDataBack, _ENV, self.roomData = SoraDSendMessage, SoraDSendMessage, nil
			self.isInGame = false
			self.isCanTurn = false
			_ENV = pairs(notifyData)
			pairs(notifyData).msg = "MESSAGE_ACTIVITY_9001731_ROOM"
			pairs(notifyData).subMsg = "beKicked"
			SoraDSendMessage(pairs(notifyData))
			SoraDShowMsgTip(i18n("Ludo_test_030"))
			SoraDRemoveAllPanelFromManager()
		elseif notifyType == "setRoom" then
			self.roomData = notifyData
			_ENV = i18n("Ludo_test_030")
			i18n("Ludo_test_030").msg = "MESSAGE_ACTIVITY_9001731_ROOM"
			i18n("Ludo_test_030").subMsg = "setRoom"
			SoraDSendMessage(i18n("Ludo_test_030"))
		elseif notifyType == "quitRoom" then
			self.roomDataBack, _ENV, self.roomData = SoraDSendMessage, SoraDSendMessage, nil
			self.isInGame = false
			self.isCanTurn = false
			_ENV = i18n("Ludo_test_030")
			i18n("Ludo_test_030").msg = "MESSAGE_ACTIVITY_9001731_ROOM"
			i18n("Ludo_test_030").subMsg = "quitRoom"
			SoraDSendMessage(i18n("Ludo_test_030"))
		end
	end
end
function activity_9001731_Ctrl:sendReqInitDataMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_FLYINGCHESS_MODULE, gCmd.REQ_FLYINGCHESS_INIT, nil)
end
function activity_9001731_Ctrl:reqInitRsp(content)
	dump(content, "activity_9001731_Ctrl:reqInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001731_UPDATE"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001731_Ctrl:reqStart(count)
	serverproxy = nil
	;(nil).count = count or 1
	serverproxy:Request(gCmd.CMD_FLYINGCHESS_MODULE, gCmd.REQ_FLYINGCHESS_START, nil)
end
function activity_9001731_Ctrl:reqStartRsp(content)
	dump(content, "activity_9001731_Ctrl:reqStartRsp(content)", 10)
	if content.err == gErrDef.Err_None then
	end
end
function activity_9001731_Ctrl:reqQuit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_FLYINGCHESS_MODULE, gCmd.REQ_FLYINGCHESS_QUIT, nil)
end
function activity_9001731_Ctrl:reqQuitRsp(content)
	dump(content, "activity_9001731_Ctrl:reqQuitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
	else
	end
end
function activity_9001731_Ctrl:reqRoll(rollNum)
	serverproxy = nil
	;(nil).rollNum = rollNum
	serverproxy:Request(gCmd.CMD_FLYINGCHESS_MODULE, gCmd.REQ_FLYINGCHESS_ROLL, nil)
end
function activity_9001731_Ctrl:reqRollRsp(content)
	dump(content, "activity_9001731_Ctrl:reqRollRsp(content)", 10)
	if content.err == gErrDef.Err_None then
	end
end
function activity_9001731_Ctrl:reqChoose(chessID)
	serverproxy = nil
	;(nil).chessID = chessID
	serverproxy:Request(gCmd.CMD_FLYINGCHESS_MODULE, gCmd.REQ_FLYINGCHESS_CHOOSE, nil)
end
function activity_9001731_Ctrl:reqChooseRsp(content)
	dump(content, "activity_9001731_Ctrl:reqChooseRsp(content)", 10)
	if content.err == gErrDef.Err_None then
	end
end
function activity_9001731_Ctrl:reqUse(itemID)
	serverproxy = nil
	;(nil).itemID = itemID
	serverproxy:Request(gCmd.CMD_FLYINGCHESS_MODULE, gCmd.REQ_FLYINGCHESS_USE, nil)
end
function activity_9001731_Ctrl:reqUseRsp(content)
	dump(content, "activity_9001731_Ctrl:reqUseRsp(content)", 10)
	if content.err == gErrDef.Err_None then
	else
		if content.err == gErrDef.Err_FLYING_CHESS_USE_ITEM_REPEAT then
			SoraDShowMsgTip(i18n("Ludo_test_017"))
		else
		end
	end
end
function activity_9001731_Ctrl:reqSign()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_FLYINGCHESS_MODULE, gCmd.REQ_FLYINGCHESS_SIGN, nil)
end
function activity_9001731_Ctrl:reqSignRsp(content)
	dump(content, "activity_9001731_Ctrl:reqSignRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData.signIn = content.rspdata.signIn
		local rewards = content.rspdata.rewards
		if rewards and next(rewards) then
			SoraDMailGainItems(rewards, true)
		end
		_ENV = rewards
		rewards.msg = "MESSAGE_ACTIVITY_9001731_UPDATE"
		SoraDSendMessage(rewards)
	end
end
function activity_9001731_Ctrl:reqQuest(taskID)
	serverproxy = nil
	;(nil).taskID = taskID
	serverproxy:Request(gCmd.CMD_FLYINGCHESS_MODULE, gCmd.REQ_FLYINGCHESS_QUEST, nil)
end
function activity_9001731_Ctrl:reqQuestRsp(content)
	dump(content, "activity_9001731_Ctrl:reqQuestRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData.questData = content.rspdata.questData
		local rewards = content.rspdata.rewards
		if rewards and next(rewards) then
			SoraDMailGainItems(rewards, true)
		end
		_ENV = rewards
		rewards.msg = "MESSAGE_ACTIVITY_9001731_UPDATE"
		SoraDSendMessage(rewards)
	end
end
function activity_9001731_Ctrl:reqRoomCreate()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_FLYINGCHESS_MODULE, gCmd.REQ_FLYINGCHESS_ROOM_CREATE, nil)
end
function activity_9001731_Ctrl:reqRoomCreateRsp(content)
	dump(content, "activity_9001731_Ctrl:reqRoomCreateRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.roomDataBack, _ENV, self.roomData = content.rspdata, content.rspdata, content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001731_ROOM"
		gErrDef.Err_None.subMsg = "create"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001731_Ctrl:reqRoomShare(toUids, toAlliance, toKingdom)
	serverproxy = nil
	;(nil).toUids = toUids
	;(nil).toAlliance = toAlliance
	;(nil).toKingdom = toKingdom
	serverproxy:Request(gCmd.CMD_FLYINGCHESS_MODULE, gCmd.REQ_FLYINGCHESS_ROOM_SHARE, nil)
end
function activity_9001731_Ctrl:reqRoomShareRsp(content)
	dump(content, "activity_9001731_Ctrl:reqRoomShareRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("notice_0103"))
	end
end
function activity_9001731_Ctrl:reqRoomEnter(roomId, createTime)
	serverproxy = nil
	;(nil).roomId = roomId
	;(nil).createTime = createTime
	serverproxy:Request(gCmd.CMD_FLYINGCHESS_MODULE, gCmd.REQ_FLYINGCHESS_ROOM_ENTER, nil)
end
function activity_9001731_Ctrl:reqRoomEnterRsp(content)
	dump(content, "activity_9001731_Ctrl:reqRoomEnterRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.roomData = content.rspdata
		_ENV = 10
		;(10).isJoin = true
		;(10).roomId = content.data.roomId
		uiManager:show("Activity_9001731_Game", 10)
	elseif content.err == gErrDef.Err_MATCH_ROOM_PLAYER_FULL then
		SoraDShowMsgTip(i18n("Ludo_test_016"))
	elseif content.err == gErrDef.Err_MATCH_ROOM_NOT_EXIST then
		SoraDShowMsgTip(i18n("simulated_drill_text_03"))
	elseif content.err == gErrDef.Err_MATCH_ROOM_NOT_READY then
		SoraDShowMsgTip(i18n("simulated_drill_text_03"))
	end
end
function activity_9001731_Ctrl:reqRoomQuit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_FLYINGCHESS_MODULE, gCmd.REQ_FLYINGCHESS_ROOM_QUIT, nil)
end
function activity_9001731_Ctrl:reqRoomQuitRsp(content)
	dump(content, "activity_9001731_Ctrl:reqRoomQuitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
	else
	end
end
function activity_9001731_Ctrl:reqRoomStart()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_FLYINGCHESS_MODULE, gCmd.REQ_FLYINGCHESS_ROOM_START, nil)
end
function activity_9001731_Ctrl:reqRoomStartRsp(content)
	dump(content, "activity_9001731_Ctrl:reqRoomStartRsp(content)", 10)
	if content.err == gErrDef.Err_None then
	end
end
function activity_9001731_Ctrl:reqRoomReady(ready)
	serverproxy = nil
	;(nil).ready = ready
	serverproxy:Request(gCmd.CMD_FLYINGCHESS_MODULE, gCmd.REQ_FLYINGCHESS_ROOM_READY, nil)
end
function activity_9001731_Ctrl:reqRoomReadyRsp(content)
	dump(content, "activity_9001731_Ctrl:reqRoomReadyRsp(content)", 10)
	if content.err == gErrDef.Err_None then
	end
end
function activity_9001731_Ctrl:reqRoomKick(kickUid)
	serverproxy = nil
	;(nil).kickUid = kickUid
	serverproxy:Request(gCmd.CMD_FLYINGCHESS_MODULE, gCmd.REQ_FLYINGCHESS_ROOM_KICK, nil)
end
function activity_9001731_Ctrl:reqRoomKickRsp(content)
	dump(content, "activity_9001731_Ctrl:reqRoomKickRsp(content)", 10)
	if content.err == gErrDef.Err_None then
	end
end
function activity_9001731_Ctrl:reqRoomGuide()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_FLYINGCHESS_MODULE, gCmd.REQ_FLYINGCHESS_ROOM_GUIDE, nil)
end
function activity_9001731_Ctrl:reqRoomGuideRsp(content)
	dump(content, "activity_9001731_Ctrl:reqRoomGuideRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData.guide = content.rspdata.guide
	end
end
function activity_9001731_Ctrl:getReceiveStatusAndNum()
	local num = self:getTaskRewardNum() + self:getStageRewardNum() + self:getPassRedNum() + self:getItemRedNum()
	return 0 < num, num
end
function activity_9001731_Ctrl:getStageRewardNum()
	local activity_9001731_Read = include("activity_9001731_Read")
	local stageCfg = activity_9001731_Read.getStageCfg()
	local num = 0
	for k, v in ipairs(stageCfg) do
		if self:getStageBoxStatues(v.taskId, v.parameter) == gBtnTargetStatusDef.GET then
			num = num + 1
		end
	end
	return num
end
function activity_9001731_Ctrl:getTaskRewardNum()
	local activity_9001731_Read = include("activity_9001731_Read")
	local taskCfg = activity_9001731_Read.getTaskCfg()
	local num = 0
	for k, v in ipairs(taskCfg) do
		if self:getTaskStatus(v.taskId, v.parameter) == gBtnTargetStatusDef.GET then
			num = num + 1
		end
	end
	return num
end
function activity_9001731_Ctrl:getPassRedNum()
	return self:isHaveSignReward() and 1 or 0
end
function activity_9001731_Ctrl:getItemRedNum()
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local constantRead = include("constantRead")
	local itemID = constantRead.getConstValue("LUDO_STAR_COST", 880601)
	return backpackCtrl:getItemCount(itemID) > 0 and 1 or 0
end
function activity_9001731_Ctrl:isNeedGuide()
	return not self.initData.guide
end
function activity_9001731_Ctrl:getSignLvStatus(lv, isAdv)
	local status = 0
	local loginDay = self:getLoginDay()
	if not self.initData.signIn[lv] then
		local _UPVALUE0_, signInLvInfo = self.initData.signIn[lv], self.initData.signIn[lv]
	end
	if isAdv then
		if self:isUnlockAdvSign() then
			status = 2
			if signInLvInfo[2] == 1 then
				status = 3
			elseif lv <= loginDay then
				status = 1
			end
		end
	else
		status = 2
		if signInLvInfo[1] == 1 then
			status = 3
		elseif lv <= loginDay then
			status = 1
		end
	end
	return status
end
function activity_9001731_Ctrl:getTaskClaimed(taskId)
	return self.initData.questData.claimedQuest[tostring(taskId)]
end
function activity_9001731_Ctrl:getTaskFinished(taskId)
	return self.initData.questData.finishedQuest[tostring(taskId)]
end
function activity_9001731_Ctrl:getTaskProgress(taskId)
	return self.initData.questData.questProgress[tostring(taskId)]
end
function activity_9001731_Ctrl:getTaskStatus(taskId, parameter)
	local status = gBtnTargetStatusDef.GO
	if self:getTaskClaimed(taskId) then
		status = gBtnTargetStatusDef.GOT
	elseif self:getTaskFinished(taskId) then
		status = gBtnTargetStatusDef.GET
	end
	return status
end
function activity_9001731_Ctrl:getGameTimes()
	local times = 0
	local activity_9001731_Read = include("activity_9001731_Read")
	for taskId, v in pairs(self.initData.questData.questProgress) do
		if activity_9001731_Read.isStageTaskId(tonumber(taskId)) then
			times = math.max(times, v)
		end
	end
	return times
end
function activity_9001731_Ctrl:getStageBoxStatues(stage, point)
	local stageData = self:getTaskClaimed(stage)
	local state = stageData and gBtnTargetStatusDef.GOT or gBtnTargetStatusDef.GO
	if state ~= gBtnTargetStatusDef.GOT and point <= self:getGameTimes() then
		state = gBtnTargetStatusDef.GET
	end
	return state
end
function activity_9001731_Ctrl:isUnlockAdvSign()
	return self.initData.isUnlockAdvancedSign
end
function activity_9001731_Ctrl:getLoginDay()
	return self.initData.loginDay
end
function activity_9001731_Ctrl:isHaveSignReward()
	local loginDay = self:getLoginDay()
	local activity_9001731_Read = include("activity_9001731_Read")
	local lvList = activity_9001731_Read.getBattlePassCfg()
	local ret = false
	for k, v in ipairs(lvList) do
		if not self.initData.signIn[v.lv] then
			local _ENV, signInLvInfo = self.initData.signIn[v.lv], self.initData.signIn[v.lv]
		end
		if loginDay >= v.lv and signInLvInfo[1] ~= 1 then
			ret = true
		end
		if self:isUnlockAdvSign() and loginDay >= v.lv and signInLvInfo[2] ~= 1 then
			ret = true
		end
	end
	return ret
end
function activity_9001731_Ctrl:isGaming()
	return self.isInGame
end
function activity_9001731_Ctrl:isTurn()
	return self.isCanTurn
end
function activity_9001731_Ctrl:resetTurn()
	self.isCanTurn = false
end
function activity_9001731_Ctrl:getAICfg()
	return self.aiCfg
end
function activity_9001731_Ctrl:getGameData()
	return self.gameData
end
function activity_9001731_Ctrl:getRoomData()
	return self.roomData
end
function activity_9001731_Ctrl:getRoomState()
	local room = self:getRoomData()
	return room and room.state or gFlyingRoomState.READY
end
function activity_9001731_Ctrl:getPlayerInfo(playerID)
	local room = self:getRoomData()
	if room then
		for _, v in ipairs(room.campMap) do
			if v.players["1"] and v.players["1"].camp == playerID then
				return v.players["1"]
			end
		end
	end
end
function activity_9001731_Ctrl:getPlayerInfoEX(index)
	local room = self:getRoomData()
	local info
	if room then
		info = room.campMap[index].players["1"]
	end
	if not info and self.roomDataBack and self.roomDataBack.campMap then
		info = self.roomDataBack.campMap[index].players["1"]
	end
	return info
end
function activity_9001731_Ctrl:getPlayerRoomInfo()
	local room = self:getRoomData()
	if room then
		for _, v in ipairs(room.campMap) do
			if v.players["1"] and v.players["1"].uid == SoraDGetPlayerID() then
				return v.players["1"]
			end
		end
	end
end
function activity_9001731_Ctrl:isAllReady()
	local room = self:getRoomData()
	local isAllReady = true
	local members = 0
	if room then
		for _, v in ipairs(room.campMap) do
			if v.players and v.players["1"] then
				if v.players["1"].ready then
					members = members + 1
				else
					isAllReady = false
				end
			end
		end
	end
	return isAllReady and 1 < members
end
function activity_9001731_Ctrl:getCampInfoByUid(uid)
	local uid = uid or SoraDGetPlayerID()
	local room = self:getRoomData()
	local info
	if room then
		for _, v in ipairs(room.campMap) do
			if v.players and v.players["1"] and v.players["1"].uid == uid then
				info = v.players["1"]
				break
			end
		end
	end
	if not info and self.roomDataBack and self.roomDataBack.campMap then
		for _, v in ipairs(self.roomDataBack.campMap) do
			if v.players["1"] and v.players["1"].uid == uid then
				info = v.players["1"]
				break
			end
		end
	end
	return info
end
function activity_9001731_Ctrl:getCampInfoByCamp(camp)
	local room = self:getRoomData()
	local info
	if room then
		for _, v in ipairs(room.campMap) do
			if v.players and v.players["1"] and v.players["1"].camp == camp then
				info = v.players["1"]
				break
			end
		end
	end
	if not info and self.roomDataBack and self.roomDataBack.campMap then
		for _, v in ipairs(self.roomDataBack.campMap) do
			if v.players["1"] and v.players["1"].camp == camp then
				info = v.players["1"]
				break
			end
		end
	end
	return info
end
function activity_9001731_Ctrl:getCampByUid(uid)
	local uid = uid or SoraDGetPlayerID()
	local info = self:getCampInfoByUid(uid)
	return info and info.camp or gFlyingChessPlayer.BLUE
end
function activity_9001731_Ctrl:getSelfChessPlayer()
	local roomInfo = self:getPlayerRoomInfo()
	return roomInfo and roomInfo.camp or gFlyingChessPlayer.BLUE
end
function activity_9001731_Ctrl:isReady()
	local roomInfo = self:getPlayerRoomInfo()
	return roomInfo and roomInfo.ready or false
end
function activity_9001731_Ctrl:isSelfHost()
	local room = self:getRoomData()
	local isHost = false
	isHost = room and room.host.uid == SoraDGetPlayerID() or false
	return isHost
end
function activity_9001731_Ctrl:getChannelID()
	local room = self:getRoomData()
	return room.channelId or 0
end
return activity_9001731_Ctrl

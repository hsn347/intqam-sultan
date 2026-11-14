local GameModule = include("GameModule")
local epicWarCtrl = class("epicWarCtrl", GameModule)
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local serverproxy = gModuleMgr.getObject("serverproxy")
local epicWarltCtrl = include("epicWarltCtrl")
local epicBattleDef = include("epicBattleDef")
function epicWarCtrl:ctor(properties)
	epicWarCtrl.super.ctor(self, properties)
end
function epicWarCtrl:EnterGame()
	epicWarCtrl.super.EnterGame(self)
	epicWarCtrl = nil
	;(nil).name = gEventName.event_req_player_data
	gametop.playertop_:dispatchEvent(nil)
	msgCtrl.register(gCmd.CMD_EPIC_WAR_MODULE, gCmd.REQ_EPIC_WAR_INIT_DATA, handler(self, self.reqStageDataRsp))
	msgCtrl.register(gCmd.CMD_EPIC_WAR_MODULE, gCmd.REQ_EPIC_WAR_ENTER_STAGE, handler(self, self.reqEnterStageRsp))
	msgCtrl.register(gCmd.CMD_EPIC_WAR_MODULE, gCmd.REQ_EPIC_WAR_QUIT_STAGE, handler(self, self.reqQuitStageRsp))
	msgCtrl.register(gCmd.CMD_EPIC_WAR_MODULE, gCmd.REQ_EPIC_WAR_EXPLORE_POS, handler(self, self.reqExploreRsp))
	msgCtrl.register(gCmd.CMD_EPIC_WAR_MODULE, gCmd.REQ_EPIC_WAR_MOVE, handler(self, self.reqMoveRsp))
	msgCtrl.register(gCmd.CMD_EPIC_WAR_MODULE, gCmd.REQ_EPIC_WAR_TRIGGER_EVENT, handler(self, self.reqTriggerEventRsp))
	msgCtrl.register(gCmd.CMD_EPIC_WAR_MODULE, gCmd.REQ_EPIC_WAR_SWEEP_STAGE, handler(self, self.reqSweepStageRsp))
	msgCtrl.register(gCmd.CMD_EPIC_WAR_MODULE, gCmd.REQ_EPIC_WAR_BUY_EXPLORE_POINT, handler(self, self.reqBuyExplorePointRsp))
	msgCtrl.register(gCmd.CMD_EPIC_WAR_MODULE, gCmd.REQ_EPIC_WAR_BUY_CHALLENGE_COUNT, handler(self, self.reqBuyChallengeCountRsp))
	msgCtrl.register(gCmd.CMD_EPIC_WAR_MODULE, gCmd.REQ_EPIC_WAR_CLAIM_CHAPTER_REWARD, handler(self, self.reqClaimChapterRewardRsp))
	msgCtrl.register(gCmd.CMD_EPIC_WAR_MODULE, gCmd.REQ_EPIC_WAR_LOG_LIST, handler(self, self.reqLogListRsp))
	msgCtrl.register(gCmd.CMD_EPIC_WAR_MODULE, gCmd.REQ_EPIC_WAR_ENTER_CHAPTER, handler(self, self.reqEnterChapterRsp))
	msgCtrl.register(gCmd.CMD_EPIC_WAR_MODULE, gCmd.REQ_EPIC_WAR_QUIT_CHAPTER, handler(self, self.reqQuitChapterRsp))
	msgCtrl.register(gCmd.CMD_EPIC_WAR_MODULE, gCmd.REQ_EPIC_WAR_USE_STRATEGY, handler(self, self.reqUseStrategyRsp))
	msgCtrl.register(gCmd.CMD_EPIC_WAR_MODULE, gCmd.REQ_EPIC_WAR_SELECT_BOSS_DROP_BLESS, handler(self, self.reqSelectDropBlessRsp))
	msgCtrl.register(gCmd.CMD_EPIC_WAR_MODULE, gCmd.REQ_EPIC_WAR_ENTER_NEXT_STAGE, handler(self, self.reqEnterNextGateRsp))
	msgCtrl.register(gCmd.CMD_EPIC_WAR_MODULE, gCmd.REQ_EPIC_RECIEVE_STAGE_REWARD, handler(self, self.reqRecieveStageRewardRsp))
	msgCtrl.register(gCmd.CMD_EPIC_WAR_MODULE, gCmd.REQ_EPIC_RECIEVE_DAILY_REWARD, handler(self, self.reqRecieveDailyRewardRsp))
	self:resetData()
	self:registerNotify()
	self:sendReqInitData()
end
function epicWarCtrl:resetData()
	self.handle_notify = nil
	self.chapterInstance, _UPVALUE0_, self.resetChallengeCountTime = nil, nil, 0
	self.instance, _UPVALUE0_, self.chapterInstance.role, _UPVALUE0_ = self.chapterInstance, self.chapterInstance
	self.stageData, _UPVALUE0_, self.explorePoint, _UPVALUE0_, self.instance.board, _UPVALUE0_ = self.instance, self.instance, self.instance, self.instance
	self.stagesInfo, _UPVALUE0_, self.chaptersInfo, _UPVALUE0_, self.lastDayRewardTime = self.instance, self.instance, self.instance, self.instance, nil
end
function epicWarCtrl:Logout()
	self:resetData()
	epicWarCtrl.super.Logout(self)
end
function epicWarCtrl:getBossDropBless()
	if not self.chapterInstance.role or not self.chapterInstance.role.bossDropBless then
		_UPVALUE0_ = self.chapterInstance.role.bossDropBless
	end
	return self.chapterInstance.role.bossDropBless
end
function epicWarCtrl:setBossDropBless(bless)
	self.chapterInstance.role.bossDropBless = bless
end
function epicWarCtrl:isDailyRewardReceived()
	local ret = false
	local leftTime = 0
	if self.lastDayRewardTime and serviceFunctions.isSameDay(self.lastDayRewardTime) then
		ret = true
		leftTime = 86400 + serviceFunctions.getTodayZeroHourUTC() - serviceFunctions.systemTime()
	end
	return ret, leftTime
end
function epicWarCtrl:getCurChapter()
	return self.chapterInstance and self.chapterInstance.chapterId or 1
end
function epicWarCtrl:getCurGateIndex()
	return self.chapterInstance and self.chapterInstance.stageIdx or 1
end
function epicWarCtrl:getCurGateID()
	return self.instance and self.instance.stageID or nil
end
function epicWarCtrl:updateBuffList(buff)
	self.chapterInstance.role.buff = buff
end
function epicWarCtrl:getBuffList()
	if not self.chapterInstance.role or not self.chapterInstance.role.buff then
		_UPVALUE0_ = self.chapterInstance.role.buff
	end
	return self.chapterInstance.role.buff
end
function epicWarCtrl:getBuffNum()
	if not self.chapterInstance.role or not self.chapterInstance.role.buff then
		_ENV = self.chapterInstance.role.buff
	end
	return table.nums(self.chapterInstance.role.buff)
end
function epicWarCtrl:getBlessList()
	if not self.chapterInstance.role or not self.chapterInstance.role.blessList then
		_UPVALUE0_ = self.chapterInstance.role.blessList
	end
	return self.chapterInstance.role.blessList
end
function epicWarCtrl:updateBlessList(blessList)
	self.chapterInstance.role.blessList = blessList
end
function epicWarCtrl:getBlessNum()
	if not self.chapterInstance.role or not self.chapterInstance.role.blessList then
		_UPVALUE0_ = self.chapterInstance.role.blessList
	end
	return #self.chapterInstance.role.blessList
end
function epicWarCtrl:getCurArmyList()
	if not self.chapterInstance.role or not self.chapterInstance.role.curArmyList then
		_UPVALUE0_ = self.chapterInstance.role.curArmyList
	end
	return self.chapterInstance.role.curArmyList
end
function epicWarCtrl:getOriArmyList()
	if not self.chapterInstance.role or not self.chapterInstance.role.originalArmyList then
		_UPVALUE0_ = self.chapterInstance.role.originalArmyList
	end
	return self.chapterInstance.role.originalArmyList
end
function epicWarCtrl:getCurHeroList()
	if not self.chapterInstance.role or not self.chapterInstance.role.heroList then
		_UPVALUE0_ = self.chapterInstance.role.heroList
	end
	return self.chapterInstance.role.heroList
end
function epicWarCtrl:getCurStrategyList()
	if not self.chapterInstance.role or not self.chapterInstance.role.strategys then
		_UPVALUE0_ = self.chapterInstance.role.strategys
	end
	return self.chapterInstance.role.strategys
end
function epicWarCtrl:updateCurStrategyList(strategys)
	self.chapterInstance.role.strategys = strategys
end
function epicWarCtrl:addCurStrategyList(idx, strategyId)
	if not self.chapterInstance.role.strategys then
		self.chapterInstance.role.strategys, _ENV = nil, nil
	end
	self.chapterInstance.role.strategys[tostring(idx)] = strategyId
end
function epicWarCtrl:getMutBuffInfo(effectType)
	local ret = 0
	local buffArray = epicWarltCtrl.getMutBuffArray(effectType)
	if not self.chapterInstance.role.layersBless then
		local epicWarltCtrl, layerBless = self.chapterInstance.role.layersBless, self.chapterInstance.role.layersBless
	end
	for k, v in pairs(buffArray) do
		if layerBless[tostring(v.tacticsId)] then
			for _, mut in ipairs(layerBless[tostring(v.tacticsId)]) do
				ret = ret + mut * v.value / 10
			end
		end
	end
	return ret
end
function epicWarCtrl:getBlessBuffMut(id, index)
	if not self.chapterInstance.role.layersBless then
		local _ENV, layerBless = self.chapterInstance.role.layersBless, self.chapterInstance.role.layersBless
	end
	local mut = 0
	if layerBless[tostring(id)] then
		mut = layerBless[tostring(id)][index] or 0
	end
	return mut
end
function epicWarCtrl:isShowBossPre()
	return self.instance.board.showBoss
end
function epicWarCtrl:isShowBMonsterPre()
	return self.instance.board.showMonster
end
function epicWarCtrl:getCurBoardInfo()
	return self.instance.board and self.instance.board.pointArray
end
function epicWarCtrl:getCurBoardInfoByPos(pos)
	for x, v in ipairs(self.instance.board.pointArray) do
		for y, vi in ipairs(v) do
			if x == pos.x and y == pos.y then
				return vi
			end
		end
	end
end
function epicWarCtrl:getAliveTower()
	local _ENV, posArray
	for x, v in ipairs(self.instance.board.pointArray) do
		for y, vi in ipairs(v) do
			if vi.pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.BARTIZAN and vi.eventData.status == epicBattleDef.gBoardEventStatusEnum.ACTIVE then
				_ENV = nil
				;(nil).x = x
				;(nil).y = y
				table.insert(posArray, nil)
			end
		end
	end
	return posArray
end
function epicWarCtrl:isBossKilled()
	local isKilled = false
	for x, v in ipairs(self.instance.board.pointArray) do
		for y, vi in ipairs(v) do
			if vi.pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.BOSS and vi.isReal and vi.eventData.status == epicBattleDef.gBoardEventStatusEnum.COMPLETE and not next(vi.eventData.eventParam.curArmyList) then
				isKilled = true
			end
		end
	end
	return isKilled
end
function epicWarCtrl:isAllMonsterFounded()
	local isFind = true
	for x, v in ipairs(self.instance.board.pointArray) do
		for y, vi in ipairs(v) do
			if vi.pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.MONSTER and not vi.isReal then
				isFind = false
				break
			end
		end
	end
	return isFind
end
function epicWarCtrl:isBossFounded()
	local isFind = true
	for x, v in ipairs(self.instance.board.pointArray) do
		for y, vi in ipairs(v) do
			if vi.pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.BOSS and not vi.isReal then
				isFind = false
				break
			end
		end
	end
	return isFind
end
function epicWarCtrl:isHaveAliveBossNow()
	local ret = false
	local _ENV, posArray
	for x, v in ipairs(self.instance.board.pointArray) do
		for y, data in ipairs(v) do
			local pointType = data.pointType
			local status = data.eventData.status
			if data.isReal and (pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.BOSS or pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.MONSTER) and status == epicBattleDef.gBoardEventStatusEnum.ACTIVE then
				ret = true
				_ENV = nil
				;(nil).x = x
				;(nil).y = y
				table.insert(posArray, nil)
			end
		end
	end
	return ret, posArray
end
function epicWarCtrl:isHaveTower()
	local ret = false
	local _ENV, posArray
	for x, v in ipairs(self.instance.board.pointArray) do
		for y, vi in ipairs(v) do
			local status = vi.eventData and vi.eventData.status
			if vi.pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.BARTIZAN and status and status == epicBattleDef.gBoardEventStatusEnum.ACTIVE then
				ret = true
				_ENV = nil
				;(nil).x = x
				;(nil).y = y
				table.insert(posArray, nil)
			end
		end
	end
	return ret, posArray
end
function epicWarCtrl:isHaveSpace()
	local ret = false
	for x, v in ipairs(self.instance.board.pointArray) do
		for y, vi in ipairs(v) do
			local status = vi.eventData and vi.eventData.status
			if status and status == epicBattleDef.gBoardEventStatusEnum.COMPLETE and vi.pointType ~= epicBattleDef.gEpicWarBoardPointTypeEnum.BARTIZAN then
				ret = true
				break
			end
		end
	end
	return ret
end
function epicWarCtrl:isSecondMonster(pos)
	local info = self:getCurBoardInfoByPos(pos)
	local ret = false
	if (pos.x ~= 1 or pos.y ~= 3) and info.pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.MONSTER and info.eventData.status == epicBattleDef.gBoardEventStatusEnum.ACTIVE then
		ret = true
	end
	return ret
end
function epicWarCtrl:isFinalBoss(pos)
	local info = self:getCurBoardInfoByPos(pos)
	local ret = false
	if info.pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.BOSS and info.eventData.status == epicBattleDef.gBoardEventStatusEnum.ACTIVE then
		ret = true
	end
	return ret
end
function epicWarCtrl:getMithrilCount()
	return self.chapterInstance.role.mithrilCount or 0
end
function epicWarCtrl:getStrategys()
	if not self.chapterInstance.role.strategys then
		_UPVALUE0_ = self.chapterInstance.role.strategys
	end
	return self.chapterInstance.role.strategys
end
function epicWarCtrl:updateStrategys(list)
	self.chapterInstance.role.strategys = list
end
function epicWarCtrl:isHaveAliveBoss(x, y)
	_UPVALUE2_, _UPVALUE8_ = nil, nil
	_UPVALUE2_, (nil)[1] = x, x
	_UPVALUE2_, (nil)[2] = x, y - 1
	_UPVALUE2_, x[1] = x, x
	_UPVALUE2_, x[2] = x, y + 1
	_UPVALUE2_, x[1] = x - 1, x - 1
	_UPVALUE2_, x[2] = x - 1, y
	_UPVALUE2_, (x - 1)[1] = x + 1, x + 1
	_UPVALUE2_, (x - 1)[2] = x + 1, y
	_UPVALUE2_, (x + 1)[1] = x - 1, x - 1
	_UPVALUE2_, (x + 1)[2] = x - 1, y - 1
	_UPVALUE2_, (x - 1)[1] = x - 1, x - 1
	_UPVALUE2_, (x - 1)[2] = x - 1, y + 1
	_UPVALUE2_, (x - 1)[1] = x + 1, x + 1
	_UPVALUE2_, (x - 1)[2] = x + 1, y - 1
	;(x + 1)[1] = x + 1
	;(x + 1)[2] = y + 1
	;(nil)[1] = nil
	;(nil)[2] = x
	;(nil)[3] = x
	;(nil)[4] = x - 1
	;(nil)[5] = x + 1
	;(nil)[6] = x - 1
	;(nil)[7] = x - 1
	local (nil)[8], dirArray = x + 1, nil
	local ret = false
	for k, v in ipairs(dirArray) do
		if self.instance.board.pointArray[v[1]] then
			local data = self.instance.board.pointArray[v[1]][v[2]]
			if data then
				local pointType = data.pointType
				local status = data.eventData.status
				if not data.eventData.eventParam or not data.eventData.eventParam.curArmyList then
					local _ENV, curArmyList = data.eventData.eventParam.curArmyList, data.eventData.eventParam.curArmyList
				end
				local relexTimes = data.eventData.eventParam and data.eventData.eventParam.relexTimes or 0
				if (pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.BOSS or pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.MONSTER) and (status == epicBattleDef.gBoardEventStatusEnum.COMPLETE and next(curArmyList) or status == epicBattleDef.gBoardEventStatusEnum.ACTIVE) then
					ret = relexTimes == 0
					break
				end
			end
		end
	end
	return ret
end
function epicWarCtrl:isHaveExploredSpace(x, y)
	_UPVALUE2_, _UPVALUE4_ = nil, nil
	_UPVALUE2_, (nil)[1] = x, x
	_UPVALUE2_, (nil)[2] = x, y - 1
	_UPVALUE2_, x[1] = x, x
	_UPVALUE2_, x[2] = x, y + 1
	_UPVALUE2_, x[1] = x - 1, x - 1
	_UPVALUE2_, x[2] = x - 1, y
	;(x - 1)[1] = x + 1
	;(x - 1)[2] = y
	;(nil)[1] = nil
	;(nil)[2] = x
	;(nil)[3] = x
	local (nil)[4], dirArray = x - 1, nil
	local ret = false
	for k, v in ipairs(dirArray) do
		if self.instance.board.pointArray[v[1]] then
			local boardInfo = self.instance.board.pointArray[v[1]][v[2]]
			if boardInfo then
				local isReal = boardInfo.isReal
				local status = boardInfo.eventData.status
				local pointType = boardInfo.pointType
				local relexTimes = boardInfo.eventData.eventParam and boardInfo.eventData.eventParam.relexTimes or 0
				if pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.BARTIZAN then
					isReal = isReal and status == epicBattleDef.gBoardEventStatusEnum.COMPLETE
				end
				if isReal or status == epicBattleDef.gBoardEventStatusEnum.COMPLETE then
					ret = true
					break
				end
			end
		end
	end
	return ret
end
function epicWarCtrl:isTowerCanDestory(x, y)
	_UPVALUE2_, _UPVALUE4_ = nil, nil
	_UPVALUE2_, (nil)[1] = x, x
	_UPVALUE2_, (nil)[2] = x, y - 1
	_UPVALUE2_, x[1] = x, x
	_UPVALUE2_, x[2] = x, y + 1
	_UPVALUE2_, x[1] = x - 1, x - 1
	_UPVALUE2_, x[2] = x - 1, y
	;(x - 1)[1] = x + 1
	;(x - 1)[2] = y
	;(nil)[1] = nil
	;(nil)[2] = x
	;(nil)[3] = x
	local (nil)[4], dirArray = x - 1, nil
	local ret = false
	local _ENV, retList = x, x
	for k, v in ipairs(dirArray) do
		retList[k] = false
		if self.instance.board.pointArray[v[1]] then
			local boardInfo = self.instance.board.pointArray[v[1]][v[2]]
			if boardInfo then
				local isReal = boardInfo.isReal
				local status = boardInfo.eventData.status
				local pointType = boardInfo.pointType
				if not boardInfo.eventData.eventParam or not boardInfo.eventData.eventParam.curArmyList then
					local _ENV, curArmyList = boardInfo.eventData.eventParam.curArmyList, boardInfo.eventData.eventParam.curArmyList
				end
				if isReal then
					if pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.BARTIZAN and status == epicBattleDef.gBoardEventStatusEnum.ACTIVE then
						retList[k] = false
					elseif (pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.BOSS or pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.MONSTER) and next(curArmyList) then
						retList[k] = false
					else
						retList[k] = true
					end
				else
					retList[k] = false
				end
			end
		end
	end
	for k, v in pairs(retList) do
		if v then
			ret = true
			break
		end
	end
	return ret
end
function epicWarCtrl:sendReqInitData()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_EPIC_WAR_MODULE, gCmd.REQ_EPIC_WAR_INIT_DATA, nil)
end
function epicWarCtrl:sendReqEnterStage(stageID, selectArmy)
	local stageID = stageID or self:getCurGateID()
	serverproxy = nil
	;(nil).stageID = stageID
	;(nil).selectArmy = selectArmy
	serverproxy:Request(gCmd.CMD_EPIC_WAR_MODULE, gCmd.REQ_EPIC_WAR_ENTER_STAGE, nil)
end
function epicWarCtrl:sendReqQuitStage(stageID)
	local stageID = stageID or self:getCurGateID()
	serverproxy = nil
	;(nil).stageID = stageID
	serverproxy:Request(gCmd.CMD_EPIC_WAR_MODULE, gCmd.REQ_EPIC_WAR_QUIT_STAGE, nil)
end
function epicWarCtrl:sendReqExplore(pos)
	serverproxy = nil
	;(nil).pos = pos
	serverproxy:Request(gCmd.CMD_EPIC_WAR_MODULE, gCmd.REQ_EPIC_WAR_EXPLORE_POS, nil)
end
function epicWarCtrl:sendReqMove(stageID, pos)
	local stageID = stageID or self:getCurGateID()
	serverproxy = nil
	;(nil).stageID = stageID
	;(nil).pos = pos
	serverproxy:Request(gCmd.CMD_EPIC_WAR_MODULE, gCmd.REQ_EPIC_WAR_MOVE, nil)
	serverproxy = serverproxy
	serverproxy.msg = "MESSAGE_UI_EPICBATTLE_TOUCH_UPDATE"
	SoraDSendMessage(serverproxy)
end
function epicWarCtrl:sendReqTriggerEvent(pos, selectIndex)
	serverproxy = nil
	;(nil).pos = pos
	;(nil).selectIndex = selectIndex
	serverproxy:Request(gCmd.CMD_EPIC_WAR_MODULE, gCmd.REQ_EPIC_WAR_TRIGGER_EVENT, nil)
	serverproxy = serverproxy
	serverproxy.msg = "MESSAGE_UI_EPICBATTLE_TOUCH_UPDATE"
	SoraDSendMessage(serverproxy)
end
function epicWarCtrl:sendReqSweepStage(stageID, times)
	serverproxy = nil
	;(nil).stageID = stageID
	;(nil).times = times or 1
	serverproxy:Request(gCmd.CMD_EPIC_WAR_MODULE, gCmd.REQ_EPIC_WAR_SWEEP_STAGE, nil)
end
function epicWarCtrl:sendReqBuyExplorePoint()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_EPIC_WAR_MODULE, gCmd.REQ_EPIC_WAR_BUY_EXPLORE_POINT, nil)
end
function epicWarCtrl:sendReqBuyChallengeCount(stageID, count)
	local stageID = stageID or self:getCurGateID()
	serverproxy = nil
	;(nil).stageID = stageID
	;(nil).count = count
	serverproxy:Request(gCmd.CMD_EPIC_WAR_MODULE, gCmd.REQ_EPIC_WAR_BUY_CHALLENGE_COUNT, nil)
end
function epicWarCtrl:sendReqClaimChapterReward(chapterID)
	serverproxy = nil
	;(nil).chapterID = chapterID
	serverproxy:Request(gCmd.CMD_EPIC_WAR_MODULE, gCmd.REQ_EPIC_WAR_CLAIM_CHAPTER_REWARD, nil)
end
function epicWarCtrl:sendReqLogList(stageID)
	local stageID = stageID or self:getCurGateID()
	serverproxy = nil
	;(nil).stageID = stageID
	serverproxy:Request(gCmd.CMD_EPIC_WAR_MODULE, gCmd.REQ_EPIC_WAR_LOG_LIST, nil)
end
function epicWarCtrl:sendReqEnterChapter(chapterID, selectArmy, heroList)

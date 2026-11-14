local GameModule = include("GameModule")
local soldierRushCtrl = class("soldierRushCtrl", GameModule)
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local serverproxy = gModuleMgr.getObject("serverproxy")
function soldierRushCtrl:ctor(properties)
	soldierRushCtrl.super.ctor(self, properties)
end
function soldierRushCtrl:EnterGame()
	soldierRushCtrl.super.EnterGame(self)
	msgCtrl.register(gCmd.CMD_SOLDIER_RUSH_MODULE, gCmd.REQ_SOLDIER_RUSH_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_SOLDIER_RUSH_MODULE, gCmd.REQ_SOLDIER_WIN, handler(self, self.reqWinRsp))
	msgCtrl.register(gCmd.CMD_SOLDIER_RUSH_MODULE, gCmd.REQ_SOLDIER_REWARD, handler(self, self.reqRewardRsp))
	msgCtrl.register(gCmd.CMD_SOLDIER_RUSH_MODULE, gCmd.REQ_SOLDIER_REWARD_ALL, handler(self, self.reqRewardAllRsp))
	msgCtrl.register(gCmd.CMD_SOLDIER_RUSH_MODULE, gCmd.REQ_SOLDIER_RUSH_AFK_INIT, handler(self, self.reqAFKinitRsp))
	msgCtrl.register(gCmd.CMD_SOLDIER_RUSH_MODULE, gCmd.REQ_SOLDIER_RUSH_AFK_REWARD, handler(self, self.reqAFKRewardRsp))
	self:resetData()
	self:sendInit()
end
function soldierRushCtrl:resetData()
	self.rewardMap, _UPVALUE0_, self.starReward, _UPVALUE0_, self.record, _UPVALUE0_ = nil, nil, nil, nil, nil, nil
	self.receiveTime = nil
	self:resetClientData()
end
function soldierRushCtrl:resetClientData()
	self.skillSlot, _UPVALUE0_ = nil, nil
	self.buildList, _UPVALUE0_, self.curBattleId = nil, nil, 0
	self.buildPosMap, _UPVALUE0_, self.dispatchStatus, _UPVALUE0_, self.enemyQueue, _UPVALUE0_, self.armyQueue, _UPVALUE0_, self.dispatchPro = nil, nil, nil, nil, nil, nil, nil, nil, 1
	self.curStarInfo = nil
end
function soldierRushCtrl:reStart()
	self.buildList, _UPVALUE0_, self.skillSlot, _UPVALUE0_ = nil, nil, nil, nil
	self.buildPosMap, _UPVALUE0_, self.dispatchStatus, _UPVALUE0_, self.enemyQueue, _UPVALUE0_, self.armyQueue, _UPVALUE0_, self.dispatchPro = nil, nil, nil, nil, nil, nil, nil, nil, 1
	self.curStarInfo = nil
end
function soldierRushCtrl:Logout()
	self:resetData()
	soldierRushCtrl.super.Logout(self)
end
function soldierRushCtrl:sendInit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_SOLDIER_RUSH_MODULE, gCmd.REQ_SOLDIER_RUSH_INIT, nil)
end
function soldierRushCtrl:sendWin(levelID, starInfo, isLost)
	serverproxy = nil
	;(nil).levelID = levelID
	;(nil).starInfo = starInfo
	;(nil).isLost = isLost or 1
	serverproxy:Request(gCmd.CMD_SOLDIER_RUSH_MODULE, gCmd.REQ_SOLDIER_WIN, nil)
end
function soldierRushCtrl:sendReward(chapterID, index)
	serverproxy = nil
	;(nil).chapterID = chapterID
	;(nil).index = index
	serverproxy:Request(gCmd.CMD_SOLDIER_RUSH_MODULE, gCmd.REQ_SOLDIER_REWARD, nil)
end
function soldierRushCtrl:sendRewardAll(chapterID)
	serverproxy = nil
	;(nil).chapterID = chapterID
	serverproxy:Request(gCmd.CMD_SOLDIER_RUSH_MODULE, gCmd.REQ_SOLDIER_REWARD_ALL, nil)
end
function soldierRushCtrl:sendAFKInit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_SOLDIER_RUSH_MODULE, gCmd.REQ_SOLDIER_RUSH_AFK_INIT, nil)
end
function soldierRushCtrl:sendAFKReward()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_SOLDIER_RUSH_MODULE, gCmd.REQ_SOLDIER_RUSH_AFK_REWARD, nil)
end
function soldierRushCtrl:reqInitRsp(content)
	dump(content, "soldierRushCtrl:reqInitRsp", 10)
	if content.err == gErrDef.Err_None then
		self.record = content.rspdata.record
		self.starReward = content.rspdata.starReward
	end
end
function soldierRushCtrl:reqWinRsp(content)
	dump(content, "soldierRushCtrl:reqWinRsp", 10)
	if content.err == gErrDef.Err_None and content.data.isLost == 1 then
		local gateID = content.data.levelID
		local starInfo = content.data.starInfo
		if not self.record[tostring(gateID)] then
			self.record[tostring(gateID)] = starInfo
		elseif self:getGateStars(gateID) < self:getGateStars(gateID, starInfo) then
			self.record[tostring(gateID)] = starInfo
		end
		self:setCurStarInfo(starInfo)
		_ENV = gateID
		gateID.id = gateID
		gateID.reward = content.rspdata.rewards
		uiManager:show("SoldierRushWin", gateID)
		if content.rspdata.rewards then
			SoraDMailGainItems(content.rspdata.rewards, true)
		end
	end
	if content.data.isLost == 1 then
		self:resetClientData()
	end
	_ENV = self
	self.msg = "MESSAGE_SOLDIERRUSH_UI_CHAPTER_MODEL"
	SoraDSendMessage(self)
end
function soldierRushCtrl:reqRewardRsp(content)
	dump(content, "soldierRushCtrl:reqRewardRsp", 10)
	if content.err == gErrDef.Err_None then
		self.starReward = content.rspdata.starReward
		SoraDMailGainItems(content.rspdata.rewards, true)
	end
	_ENV = content.rspdata.rewards
	content.rspdata.rewards.msg = "MESSAGE_SOLDIERRUSH_CLAIMREWARD"
	SoraDSendMessage(content.rspdata.rewards)
end
function soldierRushCtrl:reqRewardAllRsp(content)
	dump(content, "soldierRushCtrl:reqRewardAllRsp", 10)
	if content.err == gErrDef.Err_None then
		self.starReward = content.rspdata.starReward
		SoraDMailGainItems(content.rspdata.rewards, true)
	end
	_ENV = content.rspdata.rewards
	content.rspdata.rewards.msg = "MESSAGE_SOLDIERRUSH_CLAIMREWARD"
	SoraDSendMessage(content.rspdata.rewards)
end
function soldierRushCtrl:reqAFKinitRsp(content)
	dump(content, "soldierRushCtrl:reqAFKinitRsp", 10)
	if content.err == gErrDef.Err_None then
		self.rewardMap = content.rspdata.rewardMap
		self.receiveTime = content.rspdata.receiveTime
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_SOLDIERRUSH_AFK_UPDATE"
	SoraDSendMessage(gErrDef.Err_None)
end
function soldierRushCtrl:reqAFKRewardRsp(content)
	dump(content, "soldierRushCtrl:reqAFKRewardRsp", 10)
	if content.err == gErrDef.Err_None then
		self.rewardMap, _ENV = content.err, content.err
		self.receiveTime = content.rspdata.receiveTime
		SoraDMailGainItems(content.rspdata.rewards, true)
	end
	_ENV = content.rspdata.rewards
	content.rspdata.rewards.msg = "MESSAGE_SOLDIERRUSH_AFK_UPDATE"
	SoraDSendMessage(content.rspdata.rewards)
end
function soldierRushCtrl:setSkillSlot(data)
	self.skillSlot = data
	_ENV = nil
	;(nil).msg = "MESSAGE_SOLDIERRUSH_UI_SKILL_SET"
	SoraDSendMessage(nil)
end
function soldierRushCtrl:setDispatchPro(pro)
	self.dispatchPro = pro
end
function soldierRushCtrl:setCurStarInfo(starInfo)
	self.curStarInfo = starInfo
end
function soldierRushCtrl:getCurStarInfo()
	return self.curStarInfo
end
function soldierRushCtrl:setBuildInfo(bid, info)
	self.buildList[bid] = info
end
function soldierRushCtrl:setBuildPosMap(bid, info)
	self.buildPosMap[bid] = info
end
function soldierRushCtrl:setCurBattleID(gateID)
	self.curBattleId = gateID
end
function soldierRushCtrl:addArmyQueue(queue)
	table.insert(self.armyQueue, queue)
end
function soldierRushCtrl:removeArmyQueue(queue)
	for k, v in ipairs(self.armyQueue) do
		if v.index == queue.index then
			table.remove(self.armyQueue, k)
			break
		end
	end
end
function soldierRushCtrl:addEnemyQueue(queue)
	table.insert(self.enemyQueue, queue)
end
function soldierRushCtrl:removeEnemyQueue(queue)
	for k, v in ipairs(self.enemyQueue) do
		if v.index == queue.index then
			table.remove(self.enemyQueue, k)
			break
		end
	end
end
function soldierRushCtrl:pauseQueue()
	for k, v in ipairs(self.armyQueue) do
		if not tolua.isnull(v) and v.pause then
			v:pause()
			v:getActionManager():pauseTarget(v)
		end
	end
	for k, v in ipairs(self.enemyQueue) do
		if not tolua.isnull(v) and v.pause then
			v:pause()
			v:getActionManager():pauseTarget(v)
		end
	end
end
function soldierRushCtrl:resumeQueue()
	for k, v in ipairs(self.armyQueue) do
		v:resume()
		v:getActionManager():resumeTarget(v)
	end
	for k, v in ipairs(self.enemyQueue) do
		v:resume()
		v:getActionManager():resumeTarget(v)
	end
end
function soldierRushCtrl:setDispatchStatus(force)
	if self.dispatchStatus[force] then
		self.dispatchStatus[force] = self.dispatchStatus[force] + 1
	else
		self.dispatchStatus[force] = 1
	end
end
function soldierRushCtrl:delDispatchStatus(force)
	if self.dispatchStatus[force] then
		self.dispatchStatus[force] = math.max(0, self.dispatchStatus[force] - 1)
	end
end
function soldierRushCtrl:retsetDispatchStatus(force)
	self.dispatchStatus[force] = 0
end
function soldierRushCtrl:getDispatchStatus(force)
	return self.dispatchStatus[force] or 0
end
function soldierRushCtrl:getArmyQueue()
	return self.armyQueue
end
function soldierRushCtrl:getEnemyQueue()
	return self.enemyQueue
end
function soldierRushCtrl:getEnemyQueueNumToBid(force, toBid)
	local _ENV, array
	for k, v in ipairs(self.enemyQueue) do
		if v.force == force and v.toBid == bid and not array[v.index] then
			array[v.index] = 1
		end
	end
	return table.nums(array)
end
function soldierRushCtrl:getEnemyQueueNum(force)
	local _ENV, array
	for k, v in ipairs(self.enemyQueue) do
		if v.force == force and not array[v.index] then
			array[v.index] = 1
		end
	end
	return table.nums(array)
end
function soldierRushCtrl:getAttackQueue(force)
	local _ENV, armyQueue
	if force == 1 then
		armyQueue = self.enemyQueue
	elseif force == 2 then
		for _, q1 in ipairs(self.enemyQueue) do
			table.insert(armyQueue, q1)
		end
		for _, q2 in ipairs(self.armyQueue) do
			table.insert(armyQueue, q2)
		end
	else
		armyQueue = self.armyQueue
	end
	return armyQueue
end
function soldierRushCtrl:isWin()
	local ret = true
	for k, v in ipairs(self.buildList) do
		if v.force == 3 or v.force == 4 then
			ret = false
			break
		end
	end
	if self:getArmyNumByForce(3) > 0 or self:getArmyNumByForce(4) > 0 then
		ret = false
	end
	return ret
end
function soldierRushCtrl:isLost()
	local ret = true
	for k, v in ipairs(self.buildList) do
		if v.force == 1 then
			ret = false
			break
		end
	end
	if self:getArmyNumByForce(1) > 0 then
		ret = false
	end
	return ret
end
function soldierRushCtrl:getBuildInfo(bid)
	return self.buildList[bid]
end
function soldierRushCtrl:getBuildList()
	return self.buildList
end
function soldierRushCtrl:getArmyBuffByForce(force)
	local atk = 0
	local hp = 0
	local soldierRushRead = include("soldierRushRead")
	for k, v in ipairs(self.buildList) do
		if v.force == force and v.bType == 3 then
			local buildCfg = soldierRushRead.getBuildCfgByTypeAndLv(v.bType, v.lv)
			_UPVALUE2_ = nil
			;(nil)[1] = "buffType"
			;(nil)[2] = "buffVal"
			local buff = serviceFunctions.tableFormat(buildCfg.BuildBuff, nil)
			for i, data in ipairs(buff) do
				if data.buffType == 4 then
					atk = atk + data.buffVal
				end
				if data.buffType == 5 then
					hp = hp + data.buffVal
				end
			end
		end
	end
	return atk, hp
end
function soldierRushCtrl:getArmyNumByForce(force)
	local num = 0
	for k, v in ipairs(self.buildList) do
		if v.force == force then
			num = num + v.armyNum
		end
	end
	if force == 1 then
		for k, v in ipairs(self.armyQueue) do
			num = num + (v.num or 0)
		end
	else
		for k, v in ipairs(self.enemyQueue) do
			if v.force == force then
				num = num + (v.num or 0)
			end
		end
	end
	return num
end
function soldierRushCtrl:getBuildByPos(pos)
	for k, v in ipairs(self.buildPosMap) do
		if pos.x >= v.x - 60 and pos.x <= v.x + 60 and pos.y >= v.y - 60 and pos.y <= v.y + 60 then
			return k
		end
	end
end
function soldierRushCtrl:getBuildMap(bid)
	return self.buildPosMap[bid]
end
function soldierRushCtrl:getDispatchPro()
	return self.dispatchPro
end
function soldierRushCtrl:getSkillSlot()
	return self.skillSlot
end
function soldierRushCtrl:getSkillSlotRecord(slot)
	return self.skillSlot[tostring(slot)]
end
function soldierRushCtrl:isSkillInSlot(skillID)
	local ret = false
	for k, v in pairs(self.skillSlot) do
		if v == skillID then
			ret = true
		end
	end
	return ret
end
function soldierRushCtrl:getChpaterInfo(chapter)
	local status = 0
	local stars = 0
	local soldierRushRead = include("soldierRushRead")
	local cfgList = soldierRushRead.getLevelCfgByChapter(chapter)
	local cfg = soldierRushRead.getChapterCfg(chapter)
	for k, v in pairs(cfgList) do
		if self.record[tostring(v.ID)] then
			status = 1
			stars = stars + self:getGateStars(v.ID)
		end
	end
	if status == 0 then
		local frontCfg = soldierRushRead.getLevelFrontCfg(chapter, 1)
		if not frontCfg or frontCfg and frontCfg.ID == 0 or self.record[tostring(frontCfg.ID)] then
			status = 1
		end
	end
	if cfg.FrontChapter == 0 then
		status = 1
	end
	if stars >= soldierRushRead.getChapterAllStars(chapter) then
		status = 2
	end
	return status, stars
end
function soldierRushCtrl:getCurBattleID()
	return self.curBattleId
end
function soldierRushCtrl:getGateRecord(id)
	return self.record[tostring(id)]
end
function soldierRushCtrl:isHaveRecord()
	return next(self.record) and true or false
end
function soldierRushCtrl:getGateStars(id, record)
	local stars = 0
	local record = record or self.record[tostring(id)]
	for k, v in pairs(record) do
		if 0 < v then
			stars = stars + 1
		end
	end
	return stars
end
function soldierRushCtrl:isGateUnlock(id)
	local soldierRushRead = include("soldierRushRead")
	local cfg = soldierRushRead.getLevelCfg(id)
	if cfg.FrontLevel == 0 or self.record[tostring(cfg.FrontLevel)] then
		return true
	end
	return false
end
function soldierRushCtrl:getToGateIndex()
	local soldierRushRead = include("soldierRushRead")
	local lvList = soldierRushRead.getLevelMapCfg()
	local index = 1
	local totalGate = 0
	for k, v in ipairs(lvList) do
		for ki, vi in ipairs(v) do
			totalGate = totalGate + 1
			if self.record[tostring(vi.ID)] then
				index = index + 1
			end
		end
	end
	return math.min(index, totalGate)
end
function soldierRushCtrl:isReward(chapter, index)
	if self.starReward[tostring(chapter)] and self.starReward[tostring(chapter)][tostring(index)] then
		return true
	end
	return false
end
function soldierRushCtrl:isHaveChapterBox(chapter, stars)
	local ret = false
	local soldierRushRead = include("soldierRushRead")
	for index = 1, 3 do
		local needStars = soldierRushRead.getChapterStarCfg(chapter, index)
		if stars >= needStars and (not self.starReward[tostring(chapter)] or self.starReward[tostring(chapter)] and not self.starReward[tostring(chapter)][tostring(index)]) then
			ret = true
			break
		end
	end
	return ret
end
function soldierRushCtrl:getAFKReward()
	return self.rewardMap
end
function soldierRushCtrl:getAFKLastReceiveTime()
	return self.receiveTime
end
return soldierRushCtrl

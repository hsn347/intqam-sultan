local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local magicLampSkillLotteryCtrl = class("magicLampSkillLotteryCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local magicLampSkillLotteryRead = include("magicLampSkillLotteryRead")
function magicLampSkillLotteryCtrl:ctor(properties)
	magicLampSkillLotteryCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.MAGIC_DRAW_ACTIVITY
	self.normalItemID = 207801
	self.highItemID = 207901
	local constantRead = include("constantRead")
	self.unlockStarLv = constantRead.getConstValue("MAGIC_DRAW_LV_LIMIT", 60)
	self.unlockJinnLv = constantRead.getConstValue("MAGIC_LAMP_UNLOCK_LEVEL", 0)
	self:resetData()
end
function magicLampSkillLotteryCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_MAGIC_LAMP_SKILL_LOTTERY_MODULE, gCmd.REQ_MAGIC_LAMP_SKILL_LOTTERY_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_MAGIC_LAMP_SKILL_LOTTERY_MODULE, gCmd.REQ_MAGIC_LAMP_SKILL_LOTTERY_DRAW, handler(self, self.reqSkillLetteoryDrawRsp))
	msgCtrl.register(gCmd.CMD_MAGIC_LAMP_SKILL_LOTTERY_MODULE, gCmd.REQ_MAGIC_LAMP_SKILL_FREE_REWARD, handler(self, self.reqDailyRewardRsp))
	msgCtrl.register(gCmd.CMD_MAGIC_LAMP_SKILL_LOTTERY_MODULE, gCmd.REQ_MAGIC_LAMP_SKILL_STAGE_REWARD, handler(self, self.reqStageRewardRsp))
	self:registerNotify()
	self:sendInitMsg()
end
function magicLampSkillLotteryCtrl:initClientData(data)
	self.msgData = data
end
function magicLampSkillLotteryCtrl:Logout()
	magicLampSkillLotteryCtrl.super.Logout(self)
	self:resetData()
end
function magicLampSkillLotteryCtrl:resetData()
	self.msgData = nil
	self.clickedMagicPool, _UPVALUE0_, self.isCanFreeClick = nil, nil, false
end
function magicLampSkillLotteryCtrl:registerNotify()
end
function magicLampSkillLotteryCtrl:notifyHandler(event)
end
function magicLampSkillLotteryCtrl:checkNewPoolOpen()
	_ENV = nil
	;(nil).msg = "MESSAGE_MAGICLAMP_SKILL_LOTTERY_POOL_UPDATE"
	SoraDSendMessage(nil)
	local cityBuildFunction = include("cityBuildFunction")
	cityBuildFunction:checkMagicLampSkillDraw()
end
function magicLampSkillLotteryCtrl:sendInitMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_MAGIC_LAMP_SKILL_LOTTERY_MODULE, gCmd.REQ_MAGIC_LAMP_SKILL_LOTTERY_INIT, nil)
end
function magicLampSkillLotteryCtrl:reqSkillLetteoryDraw(magicPoolId, times, isFree)
	serverproxy = nil
	;(nil).magicPoolId = magicPoolId
	;(nil).times = times
	;(nil).isFree = isFree
	serverproxy:Request(gCmd.CMD_MAGIC_LAMP_SKILL_LOTTERY_MODULE, gCmd.REQ_MAGIC_LAMP_SKILL_LOTTERY_DRAW, nil)
end
function magicLampSkillLotteryCtrl:reqDailyReward()
	print("magicLampSkillLotteryCtrl:reqDailyReward")
	_ENV = nil
	serverproxy:Request(gCmd.CMD_MAGIC_LAMP_SKILL_LOTTERY_MODULE, gCmd.REQ_MAGIC_LAMP_SKILL_FREE_REWARD, nil)
end
function magicLampSkillLotteryCtrl:reqStageReward(magicPoolId, stageID)
	print("magicLampSkillLotteryCtrl:reqDailyReward")
	_ENV = nil
	;(nil).magicPoolId = magicPoolId
	;(nil).stageID = stageID
	serverproxy:Request(gCmd.CMD_MAGIC_LAMP_SKILL_LOTTERY_MODULE, gCmd.REQ_MAGIC_LAMP_SKILL_STAGE_REWARD, nil)
end
function magicLampSkillLotteryCtrl:reqInitRsp(content)
	dump(content, "magicLampSkillLotteryCtrl:reqInit(content)", 10)
	if content.err == gErrDef.Err_None then
		self:initClientData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_MAGICLAMP_SKILL_LOTTERY_POOL_UPDATE"
		SoraDSendMessage(self)
	end
end
function magicLampSkillLotteryCtrl:reqSkillLetteoryDrawRsp(content)
	dump(content, "magicLampSkillLotteryCtrl:reqSkillLetteoryDrawRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.msgData[tostring(content.rspdata.magicPoolId)] = content.rspdata.poolLottryInfo
		_ENV = tostring(content.rspdata.magicPoolId)
		tostring(content.rspdata.magicPoolId).msg = "MESSAGE_MAGICLAMP_SKILL_LOTTERY_UPDATE"
		SoraDSendMessage((tostring(content.rspdata.magicPoolId)))
		_ENV = tostring(content.rspdata.magicPoolId)
		tostring(content.rspdata.magicPoolId).msg = "MESSAGE_MAGICLAMP_SKILL_LOTTERY_REWARD"
		tostring(content.rspdata.magicPoolId).data = content.rspdata
		SoraDSendMessage((tostring(content.rspdata.magicPoolId)))
	end
end
function magicLampSkillLotteryCtrl:reqDailyRewardRsp(content)
	dump(content, "magicLampSkillLotteryCtrl:reqDailyRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:initClientData(content.rspdata)
		SoraDMailGainItems(content.rspdata.rewards, true)
		_ENV = content.rspdata.rewards
		content.rspdata.rewards.msg = "MESSAGE_MAGICLAMP_SKILL_LOTTERY_UPDATE"
		SoraDSendMessage(content.rspdata.rewards)
	end
end
function magicLampSkillLotteryCtrl:reqStageRewardRsp(content)
	dump(content, "magicLampSkillLotteryCtrl:reqStageRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:initClientData(content.rspdata)
		if #content.rspdata.rewards == 1 then
			_ENV = 10
			;(10).rewardsList = content.rspdata.rewards
			uiManager:show("MagicLampMaigcPowerGain", 10)
		else
			SoraDMailGainItems(content.rspdata.rewards, true)
		end
		_ENV = content.rspdata.rewards
		content.rspdata.rewards.msg = "MESSAGE_MAGICLAMP_SKILL_LOTTERY_UPDATE"
		SoraDSendMessage(content.rspdata.rewards)
	end
end
function magicLampSkillLotteryCtrl:getReceiveStatusAndNum()
	if self.msgData then
		local retNum = 0
		local backpackCtrl = SoraDGetCtrl("backpackCtrl")
		local itemNum = backpackCtrl:getItemCount(self.itemID)
		if 0 < itemNum then
			return true, -1
		end
		local drawCount = self:getDrawCount()
		local rewardCfgList = magicLampSkillLotteryRead.getRewardCfgList()
		for i, v in ipairs(rewardCfgList) do
			if drawCount >= v.draw and not self:getIsReceived(v.draw) then
				return true, -1
			end
		end
	else
		return false, 0
	end
end
function magicLampSkillLotteryCtrl:getPoolData(magicPoolID)
	return self.msgData and self.msgData[tostring(magicPoolID)] or nil
end
function magicLampSkillLotteryCtrl:getIsShowFreeBubble()
	if not self:getIsUnlock() then
		return nil
	end
	local showCfgs = magicLampSkillLotteryRead.getShowCfgList()
	local nebulaMileStoneCtrl = SoraDGetCtrl("nebulaMileStoneCtrl")
	for i, v in ipairs(showCfgs) do
		local isCurPoolUnlock = true
		local poolLastTime
		if v.milestoneID ~= 0 then
			local taskBeginTime = nebulaMileStoneCtrl:getIsTaskBeginTime(v.milestoneID)
			if taskBeginTime == 0 or serviceFunctions.systemTime() - taskBeginTime > v.duration then
				isCurPoolUnlock = false
			elseif not self.clickedMagicPool[v.magicPoolID] then
				return v.magicPoolID
			end
		end
		if isCurPoolUnlock and v.freeTime ~= 0 then
			local poolData = self:getPoolData(v.magicPoolID)
			local lastFreeTime = poolData and poolData.lastFreeTime and poolData.lastFreeTime + v.freeTime - serviceFunctions.systemTime() or 0
			if lastFreeTime <= 0 then
				return v.magicPoolID
			end
		end
	end
	return nil
end
function magicLampSkillLotteryCtrl:getIsDailyFree()
	return self.msgData and self.msgData.freeMark == 0
end
function magicLampSkillLotteryCtrl:setMagicPoolClick(magicPoolID)
	self.clickedMagicPool[magicPoolID] = true
end
function magicLampSkillLotteryCtrl:getIsUnlock()
	local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
	return self.unlockStarLv <= SoraDGetBuildStarLv() and self.unlockJinnLv <= magicLampCtrl:getSumJinnLevel()
end
function magicLampSkillLotteryCtrl:getIsPoolOpen(pool)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local param = activityShowCtrl:getParamByID(self.activityID)
	if not param.classtypes then
		local _ENV, classtypes = param.classtypes, param.classtypes
	end
	local starTime = activityShowCtrl:getBeginTimeSecond(self.activityID)
	local endTime = activityShowCtrl:getEndTimeSecond(self.activityID)
	if starTime ~= 0 and starTime <= serviceFunctions.systemTime() and endTime > serviceFunctions.systemTime() then
		for i, v in ipairs(classtypes) do
			if v == pool then
				return self:getIsPoolOpenInRightArea(pool)
			end
		end
	end
	return false
end
function magicLampSkillLotteryCtrl:getIsPoolOpenInRightArea(pool)
	local poolCfg = magicLampSkillLotteryRead.getShowCfgByID(pool)
	if poolCfg.isPreparing == 0 then
		return true
	end
	local activity_9001656_Ctrl = SoraDGetCtrl("activity_9001656_Ctrl")
	local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
	local regionType = nebulaActivityCtrl:getKingdomRegionType()
	local doStage = activity_9001656_Ctrl:getDoStage()
	print(doStage, poolCfg.isPreparing, regionType, "magicLampSkillLotteryCtrl:getIsPoolOpenInRightArea", pool)
	if doStage == 1 and poolCfg.isPreparing == 2 and regionType ~= NEBULA_REGION_TYPE.HEGEMONY_REGION then
		return true
	elseif poolCfg.isPreparing == 1 and regionType == NEBULA_REGION_TYPE.HEGEMONY_REGION then
		return true
	end
	return false
end
function magicLampSkillLotteryCtrl:getBoxRewardDataStatus(magicPoolID, index, num)
	local poolData = self:getPoolData(magicPoolID)
	if poolData and poolData.stageMark and poolData.stageMark[tostring(index)] then
		return gBtnTargetStatusDef.GOT
	end
	local nowNum = poolData and poolData.lottryTimes or 0
	if num <= nowNum then
		return gBtnTargetStatusDef.GET
	end
	return gBtnTargetStatusDef.GO
end
return magicLampSkillLotteryCtrl

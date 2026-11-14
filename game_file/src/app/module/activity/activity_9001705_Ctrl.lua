local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001705_Ctrl = class("activity_9001705_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local activity_9001705_Read = include("activity_9001705_Read")
function activity_9001705_Ctrl:ctor(properties)
	activity_9001705_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001705
	local constantRead = include("constantRead")
	_UPVALUE2_ = nil
	;(nil)[1] = 859601
	;(nil)[2] = 1
	self.itemID = constantRead.getConstValueArray("SKY_COMPETITION_DAILY_ITEM", nil)[1]
	self:resetData()
end
function activity_9001705_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_SKY_COMPETITION_MODULE, gCmd.REQ_SKY_COMPETITION_DATA, handler(self, self.reqSnowCompetitionDataRsp))
	msgCtrl.register(gCmd.CMD_SKY_COMPETITION_MODULE, gCmd.REQ_SKY_COMPETITION_FREE_TICKET, handler(self, self.reqSnowCompetitionFreeTicketRsp))
	msgCtrl.register(gCmd.CMD_SKY_COMPETITION_MODULE, gCmd.REQ_SKY_COMPETITION_BEGIN, handler(self, self.reqSnowCompetitionBeginRsp))
	msgCtrl.register(gCmd.CMD_SKY_COMPETITION_MODULE, gCmd.REQ_SKY_COMPETITION_END, handler(self, self.reqSnowCompetitionEndRsp))
	msgCtrl.register(gCmd.CMD_SKY_COMPETITION_MODULE, gCmd.REQ_SKY_COMPETITION_UPGRADE_ATTR, handler(self, self.reqSnowCompetitionUpgradeAttrRsp))
	msgCtrl.register(gCmd.CMD_SKY_COMPETITION_MODULE, gCmd.REQ_SKY_COMPETITION_BUY_GIFT, handler(self, self.reqSnowCompetitionBuyGiftRsp))
	msgCtrl.register(gCmd.CMD_SKY_COMPETITION_MODULE, gCmd.REQ_SKY_COMPETITION_BATTLE_PASS_ALL_REWARD, handler(self, self.reqSnowCompetitionBattlePassAllRewardRsp))
	msgCtrl.register(gCmd.CMD_SKY_COMPETITION_MODULE, gCmd.REQ_SKY_COMPETITION_ACHIEVEMENT_REWARD, handler(self, self.reqSnowCompetitionAchievementRewardRsp))
	msgCtrl.register(gCmd.CMD_SKY_COMPETITION_MODULE, gCmd.REQ_SKY_COMPETITION_ACHIEVEMENT_STAGE_REWARD, handler(self, self.reqSnowCompetitionAchievementStageRewardRsp))
	msgCtrl.register(gCmd.CMD_SKY_COMPETITION_MODULE, gCmd.REQ_SKY_COMPETITION_PLAYER_RANK, handler(self, self.reqSnowCompetitionPlayerRankRsp))
	msgCtrl.register(gCmd.CMD_SKY_COMPETITION_MODULE, gCmd.REQ_SKY_COMPETITION_ALLIANCE_RANK, handler(self, self.reqSnowCompetitionAllianceRankRsp))
	self:registerNotify()
end
function activity_9001705_Ctrl:Logout()
	activity_9001705_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001705_Ctrl:resetData()
	self.msgData, _UPVALUE0_ = nil, nil
end
function activity_9001705_Ctrl:setData(data, ignoreMsg)
	self.msgData = data
	if not ignoreMsg then
		_ENV = nil
		;(nil).msg = "MESSAGE_ACTIVITY_9001705_UPDATE"
		SoraDSendMessage(nil)
	end
end
function activity_9001705_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.SKY_COMPETITION, handler(self, self.notifyHandler))
end
function activity_9001705_Ctrl:notifyHandler(event)
	dump(event.data, "activity_9001705_Ctrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		local notifyType = v.notifyType
		local notifyData = v.notifyData
		if notifyType == "data" then
			serviceFunctions.deepMerge(self.msgData, notifyData)
			self:setData(self.msgData)
		end
	end
end
function activity_9001705_Ctrl:sendReqInitDataMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_SKY_COMPETITION_MODULE, gCmd.REQ_SKY_COMPETITION_DATA, nil)
end
function activity_9001705_Ctrl:reqSnowCompetitionDataRsp(content)
	dump(content, "activity_9001705_Ctrl:reqSnowCompetitionDataRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata)
		_ENV = content.rspdata
		content.rspdata.byUID = true
		local recordTable = SoraDConfigGet("Game:Com_9001705_game:recordTable~table", content.rspdata)
		if recordTable ~= nil then
			self:reqSnowCompetitionEnd(recordTable[1], recordTable[2], recordTable[3], recordTable[4], true)
			_ENV = recordTable[2]
			recordTable[2].byUID = true
			SoraDConfigSet("Game:Com_9001705_game:recordTable~table", nil, recordTable[2])
		end
	end
end
function activity_9001705_Ctrl:reqSnowCompetitionFreeTicket()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_SKY_COMPETITION_MODULE, gCmd.REQ_SKY_COMPETITION_FREE_TICKET, nil)
end
function activity_9001705_Ctrl:reqSnowCompetitionFreeTicketRsp(content)
	dump(content, "activity_9001705_Ctrl:reqSnowCompetitionFreeTicketRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata.data)
		SoraDMailGainItems(content.rspdata.reward, true)
	end
end
function activity_9001705_Ctrl:reqSnowCompetitionBegin()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_SKY_COMPETITION_MODULE, gCmd.REQ_SKY_COMPETITION_BEGIN, nil)
end
function activity_9001705_Ctrl:reqSnowCompetitionBeginRsp(content)
	dump(content, "activity_9001705_Ctrl:reqSnowCompetitionBeginRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001705_UPDATE"
		gErrDef.Err_None.msgType = "begin"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001705_Ctrl:reqSnowCompetitionEnd(distance, speedUpCount, powerUpCount, powerDownCount, isBreak)
	serverproxy = nil
	;(nil).distance = distance
	;(nil).speedUpCount = speedUpCount
	;(nil).powerUpCount = powerUpCount
	;(nil).powerDownCount = powerDownCount
	;(nil).isBreak = isBreak
	serverproxy:Request(gCmd.CMD_SKY_COMPETITION_MODULE, gCmd.REQ_SKY_COMPETITION_END, nil)
end
function activity_9001705_Ctrl:reqSnowCompetitionEndRsp(content)
	dump(content, "activity_9001705_Ctrl:reqSnowCompetitionEndRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata.data, true)
		_ENV = self
		self.msg = "MESSAGE_ACTIVITY_9001705_UPDATE"
		_ENV, self.msgType = content.rspdata.data, "end"
		content.rspdata.data.data = content.data
		self.data, content.rspdata.data.reward = content.rspdata.data, content.rspdata.reward
		SoraDSendMessage(self)
	end
end
function activity_9001705_Ctrl:reqSnowCompetitionUpgradeAttr(attrType)
	serverproxy = nil
	;(nil).attrType = attrType
	serverproxy:Request(gCmd.CMD_SKY_COMPETITION_MODULE, gCmd.REQ_SKY_COMPETITION_UPGRADE_ATTR, nil)
end
function activity_9001705_Ctrl:reqSnowCompetitionUpgradeAttrRsp(content)
	dump(content, "activity_9001705_Ctrl:reqSnowCompetitionUpgradeAttrRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata)
	end
end
function activity_9001705_Ctrl:reqSnowCompetitionBuyGift(rid)
	serverproxy = nil
	;(nil).rid = rid
	serverproxy:Request(gCmd.CMD_SKY_COMPETITION_MODULE, gCmd.REQ_SKY_COMPETITION_BUY_GIFT, nil)
end
function activity_9001705_Ctrl:reqSnowCompetitionBuyGiftRsp(content)
	dump(content, "activity_9001705_Ctrl:reqSnowCompetitionBuyGiftRsp(content)", 10)
	if content.err == gErrDef.Err_None then
	end
end
function activity_9001705_Ctrl:reqSnowCompetitionBattlePassAllReward()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_SKY_COMPETITION_MODULE, gCmd.REQ_SKY_COMPETITION_BATTLE_PASS_ALL_REWARD, nil)
end
function activity_9001705_Ctrl:reqSnowCompetitionBattlePassAllRewardRsp(content)
	dump(content, "activity_9001705_Ctrl:reqSnowCompetitionBattlePassAllRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata.data)
		SoraDMailGainItems(content.rspdata.reward, true)
	end
end
function activity_9001705_Ctrl:reqSnowCompetitionAchievementReward(idx)
	serverproxy = nil
	;(nil).idx = idx
	serverproxy:Request(gCmd.CMD_SKY_COMPETITION_MODULE, gCmd.REQ_SKY_COMPETITION_ACHIEVEMENT_REWARD, nil)
end
function activity_9001705_Ctrl:reqSnowCompetitionAchievementRewardRsp(content)
	dump(content, "activity_9001705_Ctrl:reqSnowCompetitionAchievementRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata.data)
		SoraDMailGainItems(content.rspdata.reward, true)
	end
end
function activity_9001705_Ctrl:reqSnowCompetitionAchievementStageReward(idx)
	serverproxy = nil
	;(nil).idx = idx
	serverproxy:Request(gCmd.CMD_SKY_COMPETITION_MODULE, gCmd.REQ_SKY_COMPETITION_ACHIEVEMENT_STAGE_REWARD, nil)
end
function activity_9001705_Ctrl:reqSnowCompetitionAchievementStageRewardRsp(content)
	dump(content, "activity_9001705_Ctrl:reqSnowCompetitionAchievementStageRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata.data)
		SoraDMailGainItems(content.rspdata.reward, true)
	end
end
function activity_9001705_Ctrl:reqSnowCompetitionPlayerRank(iBegin, nCount)
	serverproxy = nil
	;(nil).iBegin = iBegin
	;(nil).nCount = nCount
	serverproxy:Request(gCmd.CMD_SKY_COMPETITION_MODULE, gCmd.REQ_SKY_COMPETITION_PLAYER_RANK, nil)
end
function activity_9001705_Ctrl:reqSnowCompetitionPlayerRankRsp(content)
	dump(content, "activity_9001705_Ctrl:reqSnowCompetitionPlayerRankRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001705_RANK"
		gErrDef.Err_None.rspdata = content.rspdata
		gErrDef.Err_None.isPlayerRank = true
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001705_Ctrl:reqSnowCompetitionAllianceRank(iBegin, nCount)
	serverproxy = nil
	;(nil).iBegin = iBegin
	;(nil).nCount = nCount
	serverproxy:Request(gCmd.CMD_SKY_COMPETITION_MODULE, gCmd.REQ_SKY_COMPETITION_ALLIANCE_RANK, nil)
end
function activity_9001705_Ctrl:reqSnowCompetitionAllianceRankRsp(content)
	dump(content, "activity_9001705_Ctrl:reqSnowCompetitionAllianceRankRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001705_RANK"
		gErrDef.Err_None.rspdata = content.rspdata
		gErrDef.Err_None.isPlayerRank = false
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001705_Ctrl:getReceiveStatusAndNum()
	if next(self.msgData) == nil then
		return false
	end
	local num = 0
	if self:getIsCanGetDailyFreeReward() then
		num = num + 1
	end
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local itemNum = backpackCtrl:getItemCount(self.itemID)
	if 1 <= itemNum then
		num = num + 1
	end
	num = num + self:getAttrUpReddot()
	num = num + self:getAchieveRedDot()
	if self:hasAward() then
		num = num + 1
	end
	return 0 < num, -1
end
function activity_9001705_Ctrl:getAttrUpReddot()
	local num = 0
	local attrScore = self.msgData.attrScore or 0
	if 0 < attrScore then
		_UPVALUE3_ = nil
		;(nil)[1] = "power"
		;(nil)[2] = "speed"
		;(nil)[3] = "lucky"
		for k, v in pairs(nil) do
			local levelCfg = activity_9001705_Read.getLevelCfg((self.msgData.attr[v] or 1) + 1)
			if levelCfg and attrScore >= levelCfg.exp then
				num = num + 1
				break
			end
		end
	end
	return num
end
function activity_9001705_Ctrl:getAchieveRedDot()
	local num = 0
	local boxInfo = activity_9001705_Read.getBoxCfgs()
	local isHaveBoxReward = false
	for i, v in ipairs(boxInfo) do
		if self:getBoxRewardDataStatus(i, v.point) == gBtnTargetStatusDef.GET then
			num = num + 1
			isHaveBoxReward = true
			break
		end
	end
	if not isHaveBoxReward then
		local achiveCfgs = activity_9001705_Read.getAchievementCfgs()
		for i, v in ipairs(achiveCfgs) do
			if self:getAchieveStatus(i, v.point) == gBtnTargetStatusDef.GET then
				num = num + 1
				break
			end
		end
	end
	return num
end
function activity_9001705_Ctrl:getBoxRewardDataStatus(index, num)
	if self.msgData.gotAchievementStageReward and self.msgData.gotAchievementStageReward[index] then
		return gBtnTargetStatusDef.GOT
	end
	local nowNum = self:getMaxScore()
	if num <= nowNum then
		return gBtnTargetStatusDef.GET
	end
	return gBtnTargetStatusDef.GO
end
function activity_9001705_Ctrl:getAchieveStatus(index)
	if self.msgData.gotAchievementReward and self.msgData.gotAchievementReward[index] then
		return gBtnTargetStatusDef.GOT
	end
	local achiveCfg = activity_9001705_Read.getAchievementCfgs()[index]
	dump(achiveCfg, "achiveCfg")
	if achiveCfg == nil then
		return gBtnTargetStatusDef.GO
	end
	local nowNum = self:getAchieveNum(achiveCfg.achivementType)
	_UPVALUE2_ = achiveCfg.achivementType
	achiveCfg.achivementType[1] = achiveCfg.require
	achiveCfg.achivementType[2] = nowNum
	dump(achiveCfg.achivementType, " achiveCfg.require <= nowNum")
	if nowNum >= achiveCfg.require then
		return gBtnTargetStatusDef.GET
	end
	return gBtnTargetStatusDef.GO
end
function activity_9001705_Ctrl:getAchieveNum(achivementType)
	if not self.msgData.achievement then
		return 0
	end
	if achivementType == 1 then
		return self.msgData.achievement.playTimes or 0
	elseif achivementType == 2 then
		return self.msgData.achievement.gameMaxDistance or 0
	elseif achivementType == 3 then
		return self.msgData.achievement.totalDistance or 0
	end
end
function activity_9001705_Ctrl:getMaxScore()
	return self.msgData.achievementScore or 0
end
function activity_9001705_Ctrl:getClassType()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	return activityShowCtrl:getParamClassType(self.activityID)
end
function activity_9001705_Ctrl:getAttScore()
	return self.msgData.attrScore or 0
end
function activity_9001705_Ctrl:getAttValue(name)
	if not self.msgData.attr then
		return 0, 1
	end
	local level = self.msgData.attr[name] or 1
	local levelCfg = activity_9001705_Read.getLevelCfg(level)
	if name == "power" then
		return levelCfg.power, level
	elseif name == "speed" then
		return levelCfg.speed, level
	elseif name == "lucky" then
		return levelCfg.luckyValue, level
	end
	return 0, level
end
function activity_9001705_Ctrl:getIsCanBuyDailyGift()
	return not serviceFunctions.isSameDay(self.msgData.lastBuyDailyGiftTime or 0)
end
function activity_9001705_Ctrl:getIsCanGetDailyFreeReward()
	return not serviceFunctions.isSameDay(self.msgData.lastFreeTicketTime or 0)
end
function activity_9001705_Ctrl:getCurDay()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local beginTime = activityShowCtrl:getBeginTimeSecond(self.activityID)
	local zeroTime1 = serviceFunctions.getTomorrowZeroHourUTC(beginTime)
	local zeroTime2 = serviceFunctions.getTomorrowZeroHourUTC()
	local passTime = zeroTime2 - zeroTime1
	return math.floor(passTime / 86400) + 1
end
function activity_9001705_Ctrl:isActiveGold()
	return self.msgData.isAdvanceBattlePass or false
end
function activity_9001705_Ctrl:getRewardDay()
	return self.msgData.gotNormalBattlePassLv or 0
end
function activity_9001705_Ctrl:getRewardDayGold()
	return self.msgData.gotAdvanceBattlePassLv or 0
end
function activity_9001705_Ctrl:hasAward()
	local curDay = self:getCurDay()
	local rewardDay = self:getRewardDay()
	local cfg
	if curDay > rewardDay then
		for i = rewardDay + 1, curDay do
			cfg = activity_9001705_Read.getLevelReward(i)
			if cfg and #cfg.normalReward > 0 then
				return true
			end
		end
	end
	if self:isActiveGold() then
		local rewardDayGold = self:getRewardDayGold()
		for i = rewardDayGold + 1, curDay do
			cfg = activity_9001705_Read.getLevelReward(i)
			if cfg and 0 < #cfg.advanceReward then
				return true
			end
		end
	end
end
function activity_9001705_Ctrl:getIsNeedGuide()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local beginTime = activityShowCtrl:getBeginTimeSecond(self.activityID)
	local recordTime = SoraDConfigGet("Game:activity_9001705_Ctrl:getIsNeedGuide~integer")
	if recordTime ~= beginTime then
		SoraDConfigSet("Game:activity_9001705_Ctrl:getIsNeedGuide~integer", beginTime)
		return true
	end
end
return activity_9001705_Ctrl

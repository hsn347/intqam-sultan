local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local endlessTrialsCtrl = class("endlessTrialsCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function endlessTrialsCtrl:ctor(properties)
	endlessTrialsCtrl.super.ctor(self, properties)
	self:resetData()
end
function endlessTrialsCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_ENDLESS_TRIALS_MODULE, gCmd.REQ_GET_RANK_DATA, handler(self, self.reqRankDataRsp))
	msgCtrl.register(gCmd.CMD_ENDLESS_TRIALS_MODULE, gCmd.REQ_BOSS_INFO_LIST, handler(self, self.reqBossInfoRsp))
	msgCtrl.register(gCmd.CMD_ENDLESS_TRIALS_MODULE, gCmd.REQ_PERSONAL_RANK, handler(self, self.reqPersonalRankRsp))
	msgCtrl.register(gCmd.CMD_ENDLESS_TRIALS_MODULE, gCmd.REQ_ALLIANCE_RANK, handler(self, self.reqAllianceRankRsp))
	msgCtrl.register(gCmd.CMD_ENDLESS_TRIALS_MODULE, gCmd.REQ_SEARCH_ENDLESS_BOSS, handler(self, self.reqSearchBossRsp))
	msgCtrl.register(gCmd.CMD_ENDLESS_TRIALS_MODULE, gCmd.REQ_ENDLESS_TRIALS_GET_GIFT_INFO, handler(self, self.reqGiftInfoRsp))
	msgCtrl.register(gCmd.CMD_ENDLESS_TRIALS_MODULE, gCmd.REQ_ENDLESS_TRIALS_GET_GIFT_REWARD, handler(self, self.reqGiftRewardRsp))
	self:initConfig()
	self:reqBossInfo()
	self:reqGiftInfo()
	self:registerNotify()
end
function endlessTrialsCtrl:Logout()
	endlessTrialsCtrl.super.Logout(self)
	self:resetData()
end
function endlessTrialsCtrl:resetData()
	self.persionalScore = 0
	self.personalRank = 0
	self.allianceScore = 0
	self.reward, _UPVALUE0_, self.allianceRankInfo, _UPVALUE0_, self.personalRankInfo, _UPVALUE0_, self.bossInfoList, _UPVALUE0_, self.protalInfo, _UPVALUE0_, self.allianceRank = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 0
	self.leftAttackTime = nil
end
function endlessTrialsCtrl:setData(data)
	for k, v in pairs(data) do
		self[k] = v
	end
end
function endlessTrialsCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.ALLIANCE_MEMBERS_GIFTS, handler(self, self.notifyGifts))
	notifyCtrl:register(gNotifyID.WORLD, handler(self, self.notifyTimes))
end
function endlessTrialsCtrl:notifyTimes(event)
	local data = event.data
	dump(data, "endlessTrialsCtrl:setAttackAndKillTimes", 10)
	if data then
		for _, msg in pairs(data) do
			if msg.wordMsgType == gWorldMsgType.bossRewardsStatus and msg.data.bossTypeRewardLimit == gBossType.endlessTrialBoss1 and msg.data.maxAttackNum and msg.data.attackNum then
				_ENV = gBossType.endlessTrialBoss1
				gBossType.endlessTrialBoss1.msg = "MESSAGE_ENDLESSTRIALS_LEFT_TIME_REFRESH"
				gBossType.endlessTrialBoss1.num = msg.data.maxAttackNum - msg.data.attackNum
				SoraDSendMessage(gBossType.endlessTrialBoss1)
				self.leftAttackTime = msg.data.maxAttackNum - msg.data.attackNum
			end
		end
	end
end
function endlessTrialsCtrl:notifyGifts(event)
	dump(event, "notifyGifts", 5)
	for _, data in ipairs(event.data) do
		if data.activityID == gActivityTimeActivityID.ENDLESS_TRIALS_ACTIVITY then
			self.reward = data.rewards
			_ENV = gActivityTimeActivityID.ENDLESS_TRIALS_ACTIVITY
			gActivityTimeActivityID.ENDLESS_TRIALS_ACTIVITY.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
			gActivityTimeActivityID.ENDLESS_TRIALS_ACTIVITY.eventID = gActivityTimeActivityID.ENDLESS_TRIALS_ACTIVITY
			SoraDSendMessage(gActivityTimeActivityID.ENDLESS_TRIALS_ACTIVITY)
		end
	end
end
function endlessTrialsCtrl:initConfig(...)
	self.bossTypeConfig, _ENV, self.monsterConfig, _ENV = nil, nil, nil, nil
	local config = require_data("endlesstrials_snowmonster_type").data
	for k, v in pairs(config) do
		if not self.monsterConfig[v.type] then
			_ENV = self.monsterConfig[v.type]
		end
		self.monsterConfig[v.type] = self.monsterConfig[v.type]
		table.insert(self.monsterConfig[v.type], v.bossType)
		self.bossTypeConfig[v.bossType] = v
	end
	self.scoreConfig, _ENV, self.mountainConfig = require_data("endlesstrials_snowmountain", true).data, require_data("endlesstrials_snowmountain", true).data, require_data("endlesstrials_snowmountain", true).data
	local config = require_data("endlesstrials_snowmonster_score", true).data
	for k, v in pairs(config) do
		if not self.scoreConfig[v.type] then
			_ENV = self.scoreConfig[v.type]
		end
		self.scoreConfig[v.type] = self.scoreConfig[v.type]
		self.scoreConfig[v.type][v.lv] = v
	end
	local config = require_data("endlesstrials_time", true).data
	self.rewardsConfig, _ENV, self.timeConfig = config[1].time, config[1].time, config[1].time
	local config = require_data("endlesstrials_rewards", true).data
	for i, v in ipairs(config) do
		if not self.rewardsConfig[v.type] then
			_ENV = self.rewardsConfig[v.type]
		end
		self.rewardsConfig[v.type] = self.rewardsConfig[v.type]
		table.insert(self.rewardsConfig[v.type], v)
	end
end
function endlessTrialsCtrl:reqRankData()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ENDLESS_TRIALS_MODULE, gCmd.REQ_GET_RANK_DATA, nil)
end
function endlessTrialsCtrl:reqBossInfo()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ENDLESS_TRIALS_MODULE, gCmd.REQ_BOSS_INFO_LIST, nil)
end
function endlessTrialsCtrl:reqPersonalRank(idx, count)
	serverproxy = nil
	;(nil).idx = idx
	;(nil).count = count
	serverproxy:Request(gCmd.CMD_ENDLESS_TRIALS_MODULE, gCmd.REQ_PERSONAL_RANK, nil)
end
function endlessTrialsCtrl:reqAllianceRank(idx, count)
	serverproxy = nil
	;(nil).idx = idx
	;(nil).count = count
	serverproxy:Request(gCmd.CMD_ENDLESS_TRIALS_MODULE, gCmd.REQ_ALLIANCE_RANK, nil)
end
function endlessTrialsCtrl:reqSearchBoss(pos, level, bossTypeList)
	serverproxy = nil
	;(nil).posx = pos and pos.x
	;(nil).posy = pos and pos.y
	;(nil).level = level
	local (nil).bossTypeList, data = bossTypeList, nil
	serverproxy:Request(gCmd.CMD_ENDLESS_TRIALS_MODULE, gCmd.REQ_SEARCH_ENDLESS_BOSS, data)
end
function endlessTrialsCtrl:reqGiftInfo()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ENDLESS_TRIALS_MODULE, gCmd.REQ_ENDLESS_TRIALS_GET_GIFT_INFO, nil)
end
function endlessTrialsCtrl:reqGiftReward()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ENDLESS_TRIALS_MODULE, gCmd.REQ_ENDLESS_TRIALS_GET_GIFT_REWARD, nil)
end
function endlessTrialsCtrl:reqRankDataRsp(content)
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_ENDLESSTRIALSVIEW_REFRESH"
		SoraDSendMessage(self)
	end
end
function endlessTrialsCtrl:reqBossInfoRsp(content)
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_ENDLESSTRIALSVIEW_REFRESH"
		SoraDSendMessage(self)
	end
end
function endlessTrialsCtrl:reqPersonalRankRsp(content)
	if content.err == gErrDef.Err_None then
		local rspdata = content.rspdata
		_ENV = nil
		;(nil).msg = "MESSAGE_ENDLESSTRIALSRANK_REFRESH"
		;(nil).personalRankInfo = content.rspdata
		SoraDSendMessage(nil)
	end
end
function endlessTrialsCtrl:reqAllianceRankRsp(content)
	if content.err == gErrDef.Err_None then
		self.allianceRankInfo = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ENDLESSTRIALSRANK_REFRESH"
		gErrDef.Err_None.allianceRankInfo = content.rspdata
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function endlessTrialsCtrl:reqSearchBossRsp(content)
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_CLOSELOADING"
	SoraDSendMessage(nil)
	if content.err == gErrDef.Err_None then
		local pos = cc.p(content.rspdata.x, content.rspdata.y)
		SoraDGotoWorldMapPoint(pos, true)
		SoraDRemoveAllPanelFromManager()
	end
end
function endlessTrialsCtrl:reqGiftInfoRsp(content)
	dump(content, "endlessTrialsCtrl:reqGiftInfoRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.reward = content.rspdata.reward
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_ENDLESSTRIALSVIEW_REFRESH"
	SoraDSendMessage(gErrDef.Err_None)
end
function endlessTrialsCtrl:reqGiftRewardRsp(content)
	dump(content, "endlessTrialsCtrl:reqGiftRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.reward, _ENV = content.err, content.err
		SoraDMailGainItems(content.rspdata.reward, true)
	end
	_ENV = content.rspdata.reward
	content.rspdata.reward.msg = "MESSAGE_ENDLESSTRIALSVIEW_REFRESH"
	SoraDSendMessage(content.rspdata.reward)
end
function endlessTrialsCtrl:setLeftTimes(data)
	self.leftAttackTime = data.maxAttackNum
	_ENV = nil
	;(nil).msg = "MESSAGE_ENDLESSTRIALS_LEFT_TIME_REFRESH"
	;(nil).num = self.leftAttackTime
	SoraDSendMessage(nil)
end
function endlessTrialsCtrl:getPersonalRank(...)
	return self.personalRank
end
function endlessTrialsCtrl:getAllianceRank(...)
	return self.allianceRank
end
function endlessTrialsCtrl:getBossInfoList(...)
	return self.bossInfoList
end
function endlessTrialsCtrl:getProtalInfo(id)
	if id then
		local info = self.protalInfo[tostring(id)]
		return info and cc.p(info[1], info[2])
	else
		return self.protalInfo
	end
end
function endlessTrialsCtrl:getMonsterConfig(...)
	return self.monsterConfig
end
function endlessTrialsCtrl:getMountainConfig(id)
	if id then
		return self.mountainConfig[id]
	else
		return self.mountainConfig
	end
end
function endlessTrialsCtrl:getScoreConfig(mType, lv)
	if mType and lv then
		return self.scoreConfig[mType][lv]
	elseif mType then
		return self.scoreConfig[mType]
	else
		return self.scoreConfig
	end
end
function endlessTrialsCtrl:getBossTypeList(mType)
	return self.monsterConfig[mType]
end
function endlessTrialsCtrl:getTimeConfig(...)
	return self.timeConfig
end
function endlessTrialsCtrl:getActivityRemainTime(...)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.ENDLESS_TRIALS_ACTIVITY)
	if eventTime then
		return eventTime.timerNode.timer:getRemainTime()
	end
	return 0
end
function endlessTrialsCtrl:getNextRefreshTime(...)
	local config = self:getTimeConfig()
	local time = serviceFunctions.systemTime() - serviceFunctions.getTodayZeroHourUTC()
	local nextTime
	for i, v in ipairs(config) do
		if v > time then
			nextTime = v
			break
		end
	end
	nextTime = nextTime or config[1] + 86400
	local leftTime = nextTime - time
	local remainTime = self:getActivityRemainTime()
	if leftTime < remainTime then
		return leftTime
	end
end
function endlessTrialsCtrl:getBossTypeInfo(bossType)
	return self.bossTypeConfig[bossType]
end
function endlessTrialsCtrl:getRewardsConfig(rType)
	if rType then
		return self.rewardsConfig[rType]
	else
		return self.rewardsConfig
	end
end
function endlessTrialsCtrl:getPersonalRankInfo(...)
	return self.personalRankInfo
end
function endlessTrialsCtrl:getAllianceRankInfo(...)
	return self.allianceRankInfo
end
function endlessTrialsCtrl:getRewardCount(...)
	local count = 0
	for k, v in ipairs(self.reward) do
		count = count + v.count
	end
	return count
end
function endlessTrialsCtrl:getReceiveStatusAndNum()
	local num = self:getRewardCount()
	return 0 < num, num
end
function endlessTrialsCtrl:getLeftAttackTimes()
	return self.leftAttackTime
end
return endlessTrialsCtrl

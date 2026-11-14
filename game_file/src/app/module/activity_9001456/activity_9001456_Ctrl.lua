local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001456_Ctrl = class("activity_9001456_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001456_Ctrl:ctor(properties)
	activity_9001456_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.FIRE_DRAGON_APPEAR_ACTIVITY
	self:resetData()
end
function activity_9001456_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_FIRE_DRAGON_APPEAR_MODULE, gCmd.REQ_FIRE_DRAGON_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_FIRE_DRAGON_APPEAR_MODULE, gCmd.REQ_FIRE_DRAGON_REWARD, handler(self, self.reqRewardRsp))
	msgCtrl.register(gCmd.CMD_FIRE_DRAGON_APPEAR_MODULE, gCmd.REQ_FIRE_DRAGON_RANKLIST, handler(self, self.reqRankListRsp))
	self:registerNotify()
end
function activity_9001456_Ctrl:Logout()
	activity_9001456_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001456_Ctrl:resetData()
	self.initData, _UPVALUE0_ = nil, nil
end
function activity_9001456_Ctrl:initClientData(data)
	if not data then
		return
	end
	self.initData = data
end
function activity_9001456_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.FIRE_DRAGON_APPEAR, handler(self, self.notifyHandler))
end
function activity_9001456_Ctrl:notifyHandler(event)
	dump(event.data, "activity_9001456_Ctrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		self.initData.score = v.score
		_ENV = v.score
		v.score.msg = "MESSAGE_ACTIVITY_9001456_SCORE_UPDATE"
		SoraDSendMessage(v.score)
		_ENV = v.score
		v.score.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		v.score.eventID = self.activityID
		SoraDSendMessage(v.score)
	end
end
function activity_9001456_Ctrl:getReceiveStatusAndNum(...)
	if self:checkBtnRewardShowRed() then
		return true, -1
	else
		return false, -1
	end
end
function activity_9001456_Ctrl:reqInit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_FIRE_DRAGON_APPEAR_MODULE, gCmd.REQ_FIRE_DRAGON_INIT, nil)
end
function activity_9001456_Ctrl:reqInitRsp(content)
	dump(content, "activity_9001456_Ctrl:reqInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001456_INIT_UPDATE"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001456_Ctrl:reqReward(index)
	serverproxy = nil
	;(nil).index = index
	serverproxy:Request(gCmd.CMD_FIRE_DRAGON_APPEAR_MODULE, gCmd.REQ_FIRE_DRAGON_REWARD, nil)
end
function activity_9001456_Ctrl:reqRewardRsp(content)
	dump(content, "activity_9001456_Ctrl:reqRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local rspdata = content.rspdata
		self.initData = rspdata.initData
		SoraDMailGainItems(rspdata.rewards, true)
		_ENV = rspdata.rewards
		rspdata.rewards.msg = "MESSAGE_ACTIVITY_9001456_REWARD_UPDATE"
		SoraDSendMessage(rspdata.rewards)
		_ENV = rspdata.rewards
		rspdata.rewards.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		rspdata.rewards.eventID = self.activityID
		SoraDSendMessage(rspdata.rewards)
	end
end
function activity_9001456_Ctrl:reqRankList()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_FIRE_DRAGON_APPEAR_MODULE, gCmd.REQ_FIRE_DRAGON_RANKLIST, nil)
end
function activity_9001456_Ctrl:reqRankListRsp(content)
	dump(content, "activity_9001456_Ctrl:reqRankListRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001456_RANK_UPDATE"
		gErrDef.Err_None.rspdata = content.rspdata
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001456_Ctrl:getRewardConfig(...)
	if not self.rewardConfig then
		local fierydragonreward = require_data("fierydragonreward", true).data
		local _ENV, ret = "fierydragonreward", "fierydragonreward"
		for i, v in ipairs(fierydragonreward) do
			if not ret[v.type] then
				_ENV = ret[v.type]
			end
			ret[v.type] = ret[v.type]
			_ENV = nil
			;(nil).id = v.id
			;(nil).needIntegral = v.needIntegral
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			;(nil).reward = serviceFunctions.tableFormat(v.reward, nil)
			table.insert(ret[v.type], nil)
		end
		self.rewardConfig = ret
	end
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local ctype = activityShowCtrl:getParamClassType(self.activityID)
	return self.rewardConfig[ctype]
end
function activity_9001456_Ctrl:getRankConfig(...)
	if not self.rankConfig then
		local fierydragonrank = require_data("fierydragonrank", true).data
		local _ENV, ret = "fierydragonrank", "fierydragonrank"
		for i, v in ipairs(fierydragonrank) do
			if not ret[v.type] then
				_ENV = ret[v.type]
			end
			ret[v.type] = ret[v.type]
			_ENV = nil
			;(nil).rankNum = v.rankNum
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			;(nil).reward = serviceFunctions.tableFormat(v.reward, nil)
			table.insert(ret[v.type], nil)
		end
		self.rankConfig = ret
	end
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local ctype = activityShowCtrl:getParamClassType(self.activityID)
	return self.rankConfig[ctype]
end
function activity_9001456_Ctrl:getRankReward(rank)
	local rankConfig = self:getRankConfig()
	for i, cfg in ipairs(rankConfig) do
		if rank >= cfg.rankNum[1] and rank <= cfg.rankNum[2] then
			return cfg.reward
		end
	end
end
function activity_9001456_Ctrl:getBossConfig(...)
	if not self.bossConfig then
		local fierydragonboss = require_data("fierydragonboss", true).data
		local _ENV, ret = "fierydragonboss", "fierydragonboss"
		for i, v in ipairs(fierydragonboss) do
			if not ret[v.type] then
				_ENV = ret[v.type]
			end
			ret[v.type] = ret[v.type]
			ret[v.type][v.bossType] = v
		end
		self.bossConfig = ret
	end
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local ctype = activityShowCtrl:getParamClassType(self.activityID)
	return self.bossConfig[ctype]
end
function activity_9001456_Ctrl:getBossScore(bossType)
	local bossConfig = self:getBossConfig()
	return bossConfig[bossType].integral
end
function activity_9001456_Ctrl:getAllianceScore(...)
	return self.initData.allianceScore and math.floor(self.initData.allianceScore) or 0
end
function activity_9001456_Ctrl:getAllianceRank(...)
	return self.initData.rank or 0
end
function activity_9001456_Ctrl:getPersonScore(...)
	return self.initData.score or 0
end
function activity_9001456_Ctrl:checkIsReceived(index)
	if not self.initData.stageReward then
		local _ENV, stageReward = self.initData.stageReward, self.initData.stageReward
	end
	if stageReward[tostring(index)] then
		return true
	else
		return false
	end
end
function activity_9001456_Ctrl:checkBtnRewardShowRed(...)
	local rewardConfig = self:getRewardConfig()
	local curScore = self:getPersonScore()
	for i, cfg in ipairs(rewardConfig) do
		if not self:checkIsReceived(cfg.id) and curScore >= cfg.needIntegral then
			return true
		end
	end
	return false
end
return activity_9001456_Ctrl

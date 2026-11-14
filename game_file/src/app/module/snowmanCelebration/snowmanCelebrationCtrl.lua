local snowmanCelebrationltCtrl = include("snowmanCelebrationltCtrl")
local GameModule = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local snowmanCelebrationCtrl = class("snowmanCelebrationCtrl", GameModule)
function snowmanCelebrationCtrl:ctor(properties)
	snowmanCelebrationCtrl.super.ctor(self, properties)
end
function snowmanCelebrationCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_SNOWMAN_ACTIVITY_MODULE, gCmd.REQ_SNOWMAN_ACTIVITY_INIT, handler(self, self.sendReqInfoRsp))
	msgCtrl.register(gCmd.CMD_SNOWMAN_ACTIVITY_MODULE, gCmd.REQ_SNOWMAN_ACTIVITY_DONATE, handler(self, self.sendReqDonateRsp))
	msgCtrl.register(gCmd.CMD_SNOWMAN_ACTIVITY_MODULE, gCmd.REQ_SNOWMAN_ACTIVITY_REWARD, handler(self, self.sendReqBoxRewardRsp))
	msgCtrl.register(gCmd.CMD_SNOWMAN_ACTIVITY_MODULE, gCmd.REQ_SNOWMAN_ACTIVITY_RANKLIST, handler(self, self.sendReqAllianceRankRsp))
	self:resetData()
end
function snowmanCelebrationCtrl:initClientData(data)
	dump(data, "snowmanCelebrationCtrl:initClientData", 10)
	if data then
		self:setData(data)
	end
end
function snowmanCelebrationCtrl:Logout()
	self:resetData()
	snowmanCelebrationCtrl.super.Logout(self)
end
function snowmanCelebrationCtrl:resetData()
	self.canReceiveNum = 0
	self.receiveNum = 0
	self.rewards, _UPVALUE0_, self.score = nil, nil, 0
	self.crits, _UPVALUE0_, self.rankData, _UPVALUE0_, self.addScore = nil, nil, nil, nil, 0
	self.critNum = 0
	self.allianceRank = -1
end
function snowmanCelebrationCtrl:setData(data)
	self.canReceiveNum = data.canReceiveNum
	self.receiveNum = data.receiveNum
	self.score = data.score % snowmanCelebrationltCtrl.getNeedIntegral()
end
function snowmanCelebrationCtrl:sendInitMsg()
	serverproxy:Request(gCmd.CMD_SNOWMAN_ACTIVITY_MODULE, gCmd.REQ_SNOWMAN_ACTIVITY_INIT)
end
function snowmanCelebrationCtrl:sendDonateMsg(id, count)
	serverproxy = nil
	;(nil).itemID = id
	;(nil).itemCount = count
	serverproxy:Request(gCmd.CMD_SNOWMAN_ACTIVITY_MODULE, gCmd.REQ_SNOWMAN_ACTIVITY_DONATE, nil)
end
function snowmanCelebrationCtrl:sendBoxRewardMsg()
	serverproxy:Request(gCmd.CMD_SNOWMAN_ACTIVITY_MODULE, gCmd.REQ_SNOWMAN_ACTIVITY_REWARD)
end
function snowmanCelebrationCtrl:sendAllianceRankMsg()
	serverproxy:Request(gCmd.CMD_SNOWMAN_ACTIVITY_MODULE, gCmd.REQ_SNOWMAN_ACTIVITY_RANKLIST)
end
function snowmanCelebrationCtrl:sendReqInfoRsp(content)
	dump(content, "snowmanCelebrationCtrl:sendReqInfoRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self:setData(data)
		_ENV = self
		self.msg = "MESSAGE_SNOWMAN_CELEBRATION_REFRESH"
		self.subMsg = "init"
		SoraDSendMessage(self)
	end
end
function snowmanCelebrationCtrl:sendReqDonateRsp(content)
	dump(content, "==snowmanCelebrationCtrl：sendReqDonateRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self:setData(data)
		self.rewards = data.rewards
		self.addScore = data.addScore
		for i, v in pairs(self.crits) do
			self.crits[i] = 0
		end
		for i, v in pairs(data.crits) do
			self.crits[i] = v
		end
		_ENV = pairs(data.crits)
		pairs(data.crits).msg = "MESSAGE_SNOWMAN_CELEBRATION_DONATE"
		pairs(data.crits).subMsg = "donate"
		pairs(data.crits).rewards = data.rewards
		SoraDSendMessage(pairs(data.crits))
	end
	if content.err == gErrDef.Err_ACTIVITY_NOT_START then
		_ENV = gErrDef.Err_ACTIVITY_NOT_START
		gErrDef.Err_ACTIVITY_NOT_START.msg = "MESSAGE_SNOWMAN_CELEBRATION_DONATE"
		gErrDef.Err_ACTIVITY_NOT_START.subMsg = "notOpen"
		SoraDSendMessage(gErrDef.Err_ACTIVITY_NOT_START)
	end
	if content.err == gErrDef.Err_ALLIANCE_PLAYER_NOT_IN_ALLIANCE then
		_ENV = gErrDef.Err_ALLIANCE_PLAYER_NOT_IN_ALLIANCE
		gErrDef.Err_ALLIANCE_PLAYER_NOT_IN_ALLIANCE.msg = "MESSAGE_SNOWMAN_CELEBRATION_DONATE"
		gErrDef.Err_ALLIANCE_PLAYER_NOT_IN_ALLIANCE.subMsg = "notInAlliance"
		SoraDSendMessage(gErrDef.Err_ALLIANCE_PLAYER_NOT_IN_ALLIANCE)
	end
	if content.err == gErrDef.Err_GOLD_NOT_REACH then
		_ENV = gErrDef.Err_GOLD_NOT_REACH
		gErrDef.Err_GOLD_NOT_REACH.msg = "MESSAGE_SNOWMAN_CELEBRATION_DONATE"
		gErrDef.Err_GOLD_NOT_REACH.subMsg = "notEnoughMoney"
		SoraDSendMessage(gErrDef.Err_GOLD_NOT_REACH)
	end
end
function snowmanCelebrationCtrl:sendReqBoxRewardRsp(content)
	dump(content, "==snowmanCelebrationCtrl:sendReqExtraRewardRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self:setData(data)
		self.rewards = data.rewards
		_ENV = self
		self.msg = "MESSAGE_SNOWMAN_CELEBRATION_BOX_REWARD"
		self.subMsg = "reward"
		self.rewards = data.rewards
		self.enable = self:isHaveBoxReward()
		self.timesStr = self:getReceiveNum() .. "/" .. snowmanCelebrationltCtrl.getBoxRewardMaxTimes()
		SoraDSendMessage(self)
	end
	if content.err == gErrDef.Err_ACTIVITY_NOT_START then
		_ENV = gErrDef.Err_ACTIVITY_NOT_START
		gErrDef.Err_ACTIVITY_NOT_START.msg = "MESSAGE_SNOWMAN_CELEBRATION_BOX_REWARD"
		gErrDef.Err_ACTIVITY_NOT_START.subMsg = "notOpen"
		SoraDSendMessage(gErrDef.Err_ACTIVITY_NOT_START)
	end
	if content.err == gErrDef.Err_ILLEGAL_PARAMS then
		_ENV = gErrDef.Err_ILLEGAL_PARAMS
		gErrDef.Err_ILLEGAL_PARAMS.msg = "MESSAGE_SNOWMAN_CELEBRATION_BOX_REWARD"
		gErrDef.Err_ILLEGAL_PARAMS.subMsg = "noReward"
		SoraDSendMessage(gErrDef.Err_ILLEGAL_PARAMS)
	end
end
function snowmanCelebrationCtrl:sendReqAllianceRankRsp(content)
	dump(content, "==snowmanCelebrationCtrl:sendReqAllianceRankRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self.rankData = data.list
		self:setPlayerRank()
		_ENV = self
		self.msg = "MESSAGE_SNOWMAN_CELEBRATION_ALLIANCE_RANK"
		self.subMsg = "rank"
		self.rankData = data.list
		self.selfScore = data.selfScore
		SoraDSendMessage(self)
	end
	if content.err == gErrDef.Err_ACTIVITY_NOT_START then
		_ENV = gErrDef.Err_ACTIVITY_NOT_START
		gErrDef.Err_ACTIVITY_NOT_START.msg = "MESSAGE_SNOWMAN_CELEBRATION_ALLIANCE_RANK"
		gErrDef.Err_ACTIVITY_NOT_START.subMsg = "notOpen"
		SoraDSendMessage(gErrDef.Err_ACTIVITY_NOT_START)
	end
end
function snowmanCelebrationCtrl:getReceiveStatusAndNum()
	if self.canReceiveNum > 0 then
		return true, self.canReceiveNum
	end
	local gametop = gModuleMgr.getObject("gametop")
	local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
	local count = backpackCtrl:getItemCount(snowmanCelebrationltCtrl.getNeedIDByIndex(1))
	if self.receiveNum < snowmanCelebrationltCtrl.getBoxRewardMaxTimes() and 0 < count then
		return true, -1
	end
end
function snowmanCelebrationCtrl:getCurScore()
	return self.score
end
function snowmanCelebrationCtrl:getIncScore()
	return self.addScore
end
function snowmanCelebrationCtrl:getcanReceiveNum()
	return self.canReceiveNum
end
function snowmanCelebrationCtrl:getHadReceivedNum()
	return self.receiveNum
end
function snowmanCelebrationCtrl:getReceiveNum()
	return self.receiveNum + self.canReceiveNum
end
function snowmanCelebrationCtrl:haveGetBoxRewardChance()
	return self.receiveNum + self.canReceiveNum < snowmanCelebrationltCtrl.getBoxRewardMaxTimes()
end
function snowmanCelebrationCtrl:isHaveBoxReward()
	return self.canReceiveNum > 0
end
function snowmanCelebrationCtrl:getRankData()
	return self.rankData
end
function snowmanCelebrationCtrl:setPlayerRank()
	local allianceMgr = SoraDGetCtrl("allianceMgr")
	if not allianceMgr:hasJoinAlliance() then
		self.allianceRank = -1
		return
	end
	local allianceID = allianceMgr:getAllianceInfo().property.aid
	local rankData = self:getRankData()
	for i, v in pairs(rankData) do
		if v.aid == allianceID then
			self.allianceRank = i
			return
		end
	end
	self.allianceRank = -1
end
function snowmanCelebrationCtrl:getPlayerRank()
	return self.allianceRank
end
function snowmanCelebrationCtrl:getCritsData()
	return self.crits
end
function snowmanCelebrationCtrl:getSkin()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local param = activityShowCtrl:getParamByID(gActivityTimeActivityID.SNOWMAN_CELEBRATION_ACTIVITY)
	local _classtype = param.classtype and param.classtype or 1
	return _classtype
end
return snowmanCelebrationCtrl

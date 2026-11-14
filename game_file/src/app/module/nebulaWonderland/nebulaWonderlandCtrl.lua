local nebulaWonderlandRead = include("nebulaWonderlandRead")
local eventQuestRead = include("eventQuestRead")
local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local nebulaWonderlandCtrl = class("nebulaWonderlandCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function nebulaWonderlandCtrl:ctor(properties)
	self.activityID = gActivityTimeActivityID.NEBULA_WONDERLAND_ACTIVITY
	nebulaWonderlandCtrl.super.ctor(self, properties)
	self:resetData()
end
function nebulaWonderlandCtrl:EnterGame()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_INIT", handler(self, self.setInitData))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_NEBULA_WONDERLAND_COMMIT, handler(self, self.donateStarMapRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_NEBULA_WONDERLAND_SCORE_REWARD, handler(self, self.scoreRewardRsp))
end
function nebulaWonderlandCtrl:Logout()
	nebulaWonderlandCtrl.super.Logout(self)
	self:resetData()
end
function nebulaWonderlandCtrl:setData(data)
	if data and data.progress then
		self.progress = data.progress
	end
	if data and data.stageReward then
		for i, v in pairs(data.stageReward) do
			self.stageReward[i] = v
		end
	end
end
function nebulaWonderlandCtrl:resetData()
	self.stageReward, _UPVALUE0_, self.progress = nil, nil, 0
end
function nebulaWonderlandCtrl:sendDonateStarMap(count)
	serverproxy = nil
	;(nil).count = count
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_NEBULA_WONDERLAND_COMMIT, nil)
end
function nebulaWonderlandCtrl:sendScoreReward(index)
	serverproxy = nil
	;(nil).index = index
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_NEBULA_WONDERLAND_SCORE_REWARD, nil)
end
function nebulaWonderlandCtrl:setInitData(target, data)
	if data.activityID == self.activityID then
		dump(data, "nebulaWonderlandCtrl:setInitData")
		self:setData(data.initData)
		_ENV = self
		self.msg = "MESSAGE_NEBULA_WONDERLAND_REFRESH"
		SoraDSendMessage(self)
	end
end
function nebulaWonderlandCtrl:donateStarMapRsp(content)
	dump(content, "nebulaWonderlandCtrl:scoreRewardRsp")
	if content.err == gErrDef.Err_None then
		local data = content.clientData
		self.progress = data.progress
		if data.rewards then
			dump(data.rewards, "fsdfdkfjdkfjdkf")
			SoraDMailGainItems(data.rewards, true)
		end
		_ENV = data.rewards
		data.rewards.msg = "MESSAGE_NEBULA_WONDERLAND_INCSCORE"
		data.rewards.subMsg = "incScore"
		data.rewards.count = content.data.count
		SoraDSendMessage(data.rewards)
	end
end
function nebulaWonderlandCtrl:scoreRewardRsp(content)
	dump(content, "nebulaWonderlandCtrl:donateStarMapRsp")
	if content.err == gErrDef.Err_None then
		local data = content.clientData
		self.progress = data.progress
		for i, v in pairs(data.stageReward) do
			self.stageReward[i] = v
		end
		if content.rewards then
			dump(content.rewards, "fsdfdkfjdkfjdkf")
			SoraDMailGainItems(content.rewards, true)
		end
		_ENV = content.rewards
		content.rewards.msg = "MESSAGE_NEBULA_WONDERLAND_REFRESH"
		SoraDSendMessage(content.rewards)
		_ENV = content.rewards
		content.rewards.msg = "MESSAGE_NEBULA_WONDERLAND_REWARD"
		content.rewards.subMsg = "reward"
		content.rewards.index = content.data.index
		SoraDSendMessage(content.rewards)
	end
end
function nebulaWonderlandCtrl:getReceiveStatusAndNum()
	local show, num = false, 0
	local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
	show, num = activityTaskComponentCtrl:getReceiveStatusAndNum(self.activityID)
	num = num + self:canGetRewardNum()
	dump(num, "fsjkdfjkdjfkdjfk")
	if 0 < num then
		show = true
	end
	return show, -1
end
function nebulaWonderlandCtrl:canGetRewardNum()
	local num = 0
	self.rewardCfg = nebulaWonderlandRead.getRewardConfig()
	for i, v in ipairs(self.rewardCfg) do
		if self.progress >= v.integral and not self.stageReward[tostring(i)] then
			num = num + 1
		end
	end
	return num
end
function nebulaWonderlandCtrl:canCurPhaseIndex()
	local index = 0
	self.rewardCfg = nebulaWonderlandRead.getRewardConfig()
	for i, v in ipairs(self.rewardCfg) do
		if self.progress >= v.integral and not self.stageReward[tostring(index)] then
			index = index + 1
		end
	end
	return index
end
function nebulaWonderlandCtrl:getNextTaskResetTime()
	return self.nextRefreshTime
end
function nebulaWonderlandCtrl:getProgress()
	return self.progress
end
function nebulaWonderlandCtrl:isInStageReward(index)
	if self.stageReward and self.stageReward[tostring(index)] then
		return true
	end
	return false
end
return nebulaWonderlandCtrl

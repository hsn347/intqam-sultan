local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001613_Ctrl = class("activity_9001613_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001613_Ctrl:ctor(properties)
	activity_9001613_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.HONOR_BACK_PRIVILEGES
	self:resetData()
end
function activity_9001613_Ctrl:EnterGame()
	print("==activity_9001613_Ctrl:EnterGame==")
	msgCtrl.register(gCmd.CMD_HONOR_BACK_PRIVILEGES_MODULE, gCmd.REQ_HONOR_BACK_PRIVILEGES_DATA, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_HONOR_BACK_PRIVILEGES_MODULE, gCmd.REQ_HONOR_BACK_PRIVILEGES_REWARD, handler(self, self.reqGetRewardRsp))
end
function activity_9001613_Ctrl:Logout()
	activity_9001613_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001613_Ctrl:resetData()
	self.beginTime = nil
	self.rewardTime = nil
	self.buffList, _UPVALUE0_, self.lastLogoutTime = nil, nil, nil
end
function activity_9001613_Ctrl:sendReqInitDataMsg()
	print("activity_9001613_Ctrl:sendReqInitDataMsg")
	_ENV = nil
	serverproxy:Request(gCmd.CMD_HONOR_BACK_PRIVILEGES_MODULE, gCmd.REQ_HONOR_BACK_PRIVILEGES_DATA, nil)
end
function activity_9001613_Ctrl:reqInitRsp(content)
	dump(content, "activity_9001613_Ctrl:reqInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.beginTime = content.rspdata.beginTime
		self.rewardTime = content.rspdata.rewardTime
		self.lastLogoutTime = content.rspdata.lastLogoutTime
		local backDay = self:getBackDay()
		local activity_9001613_Read = include("activity_9001613_Read")
		if not activity_9001613_Read.getBuffCfg(backDay) then
			local _ENV, buffCfg = activity_9001613_Read.getBuffCfg(backDay), activity_9001613_Read.getBuffCfg(backDay)
		end
		local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
		self.buffList, _ENV = "buffltCtrl", "buffltCtrl"
		if not buffCfg.buffType then
			_ENV = buffCfg.buffType
		end
		for i, v in ipairs(buffCfg.buffType) do
			local effectType = buffltCtrl:getEffectType(v)
			local effect, _ = buffltCtrl:getEffect(v)
			if effectType then
				self.buffList[effectType] = self.buffList[effectType] or 0
				self.buffList[effectType] = self.buffList[effectType] + effect
			end
		end
		dump(self.buffList, "self.buffList")
		_ENV = self.buffList
		self.buffList.msg = "MESSAGE_ACTIVITY_9001613_UPDATE"
		SoraDSendMessage(self.buffList)
		_ENV = self.buffList
		self.buffList.msg = "MESSAGE_ACTIVITY_9001608_UPDATE_RED"
		self.buffList.activityID = self.activityID
		SoraDSendMessage(self.buffList)
	end
end
function activity_9001613_Ctrl:reqGetReward()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_HONOR_BACK_PRIVILEGES_MODULE, gCmd.REQ_HONOR_BACK_PRIVILEGES_REWARD, nil)
end
function activity_9001613_Ctrl:reqGetRewardRsp(content)
	dump(content, "activity_9001613_Ctrl:reqGetRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.beginTime = content.rspdata.data.beginTime
		self.rewardTime = content.rspdata.data.rewardTime
		local rewards = content.rspdata.reward
		SoraDMailGainItems(rewards, true)
		_ENV = rewards
		rewards.msg = "MESSAGE_ACTIVITY_9001613_UPDATE"
		SoraDSendMessage(rewards)
		_ENV = rewards
		rewards.msg = "MESSAGE_ACTIVITY_9001608_UPDATE_RED"
		rewards.activityID = self.activityID
		SoraDSendMessage(rewards)
	end
end
function activity_9001613_Ctrl:getReceiveStatusAndNum(activityID)
	local isRewardCanGet = self.beginTime ~= nil and self.rewardTime == nil
	return isRewardCanGet
end
function activity_9001613_Ctrl:getRewardTime()
	return self.rewardTime
end
function activity_9001613_Ctrl:getBackDay()
	if self.beginTime == nil then
		return 0
	end
	local pastDaySecs = serviceFunctions.getTodayZeroHourUTC() - serviceFunctions.getTodayZeroHourUTC(self.beginTime)
	local pastDay = math.ceil(pastDaySecs / 86400)
	return pastDay + 1
end
function activity_9001613_Ctrl:getLossDay()
	if self.lastLogoutTime == nil then
		return 0
	end
	local lossDaySecs = serviceFunctions.getTodayZeroHourUTC() - serviceFunctions.getTodayZeroHourUTC(self.lastLogoutTime)
	local lossDay = math.ceil(lossDaySecs / 86400)
	return lossDay
end
function activity_9001613_Ctrl:getBuffPlus(effectType)
	return self.buffList[effectType] or 0
end
return activity_9001613_Ctrl

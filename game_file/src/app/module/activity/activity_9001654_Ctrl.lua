local activity_9001654_Read = include("activity_9001654_Read")
local GameModule = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local activity_9001654_Ctrl = class("activity_9001654_Ctrl", GameModule)
function activity_9001654_Ctrl:ctor(properties)
	activity_9001654_Ctrl.super.ctor(self, properties)
end
function activity_9001654_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_NEW_DESERT_TREASURE_MODULE, gCmd.REQ_NEW_DESERT_TREASURE_INIT, handler(self, self.sendReqInfoRsp))
	msgCtrl.register(gCmd.CMD_NEW_DESERT_TREASURE_MODULE, gCmd.REQ_NEW_DESERT_TREASURE_DRAW, handler(self, self.sendReqExtractRsp))
	msgCtrl.register(gCmd.CMD_NEW_DESERT_TREASURE_MODULE, gCmd.REQ_NEW_DESERT_TREASURE_STAGE_REWARD, handler(self, self.sendReqStageRewardRsp))
	self:resetData()
end
function activity_9001654_Ctrl:initClientData(data)
	dump(data, "activity_9001654_Ctrl:initClientData", 10)
	if data then
		self:setData(data)
	end
end
function activity_9001654_Ctrl:Logout()
	self:resetData()
	activity_9001654_Ctrl.super.Logout(self)
end
function activity_9001654_Ctrl:resetData()
	print("activity_9001654_Ctrl:resetData()")
	self.gotTreasure, _ENV = print, print
	self.openCount = 0
	self.gotExtra, _ENV, self.classType = print, print, 1
	self.lucky = 0
	self.pointTo = 1
end
function activity_9001654_Ctrl:setData(data)
	if not data.gotTreasure then
		_UPVALUE0_ = data.gotTreasure
	end
	self.gotTreasure = data.gotTreasure
	self.openCount = data.openCount or 0
	self.classType = data.classType or 1
	if not data.gotExtra then
		_UPVALUE0_ = data.gotExtra
	end
	self.gotExtra = data.gotExtra
	self.lucky = data.lucky or 0
end
function activity_9001654_Ctrl:sendInitMsg()
	serverproxy:Request(gCmd.CMD_NEW_DESERT_TREASURE_MODULE, gCmd.REQ_NEW_DESERT_TREASURE_INIT)
end
function activity_9001654_Ctrl:sendExtractMsg()
	serverproxy:Request(gCmd.CMD_NEW_DESERT_TREASURE_MODULE, gCmd.REQ_NEW_DESERT_TREASURE_DRAW)
end
function activity_9001654_Ctrl:sendGetStageMsg(giftId)
	serverproxy = nil
	;(nil).giftId = giftId
	serverproxy:Request(gCmd.CMD_NEW_DESERT_TREASURE_MODULE, gCmd.REQ_NEW_DESERT_TREASURE_STAGE_REWARD, nil)
end
function activity_9001654_Ctrl:sendReqInfoRsp(content)
	dump(content, "activity_9001654_Ctrl:sendReqInfoRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self:setData(data)
		_ENV = self
		self.msg = "MESSAGE_DESERT_TREASURE_REFRESH"
		self.subMsg = "init"
		SoraDSendMessage(self)
	end
end
function activity_9001654_Ctrl:sendReqExtractRsp(content)
	dump(content, "==activity_9001654_Ctrl:sendReqExtractRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		for i, v in pairs(data.gotTreasure) do
			self.gotTreasure[i] = v
			self.pointTo = tonumber(i)
		end
		self.lucky = data.lucky
		_ENV = pairs(data.gotTreasure)
		pairs(data.gotTreasure).msg = "MESSAGE_DESERT_TREASURE_REFRESH"
		pairs(data.gotTreasure).subMsg = "extract"
		pairs(data.gotTreasure).reward = data.reward
		SoraDSendMessage(pairs(data.gotTreasure))
	end
end
function activity_9001654_Ctrl:sendReqStageRewardRsp(content)
	dump(content, "==activity_9001654_Ctrl:sendReqStageRewardRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		for i, v in pairs(data.gotExtra) do
			self.gotExtra[i] = v
		end
		_ENV = pairs(data.gotExtra)
		pairs(data.gotExtra).msg = "MESSAGE_DESERT_TREASURE_REFRESH"
		pairs(data.gotExtra).subMsg = "stageReward"
		pairs(data.gotExtra).reward = data.reward
		SoraDSendMessage(pairs(data.gotExtra))
	end
end
function activity_9001654_Ctrl:getReceiveStatusAndNum()
	if not activity_9001654_Read.hadStageReward() then
		return false, 0
	end
	local hadGetTimes = table.nums(self.gotTreasure)
	local num = 0
	for i, v in pairs(activity_9001654_Read.getExtraConfig()) do
		if hadGetTimes >= v.lotteryTime then
			num = num + 1
		end
	end
	num = num - table.nums(self.gotExtra)
	if num == 0 then
		return false, -1
	end
	return true, num
end
function activity_9001654_Ctrl:getLuckyPoint()
	return self.lucky
end
function activity_9001654_Ctrl:getPointTo()
	return self.pointTo
end
function activity_9001654_Ctrl:getGroup()
	return self.classType or 1
end
function activity_9001654_Ctrl:getExtraReward()
	if not self.gotExtra then
		_UPVALUE0_ = self.gotExtra
	end
	return self.gotExtra
end
function activity_9001654_Ctrl:getExtraRewardNum()
	return table.nums(self.gotExtra)
end
function activity_9001654_Ctrl:getTreasure()
	if not self.gotTreasure then
		_UPVALUE0_ = self.gotTreasure
	end
	return self.gotTreasure
end
function activity_9001654_Ctrl:getTreasureNum()
	return table.nums(self.gotTreasure)
end
function activity_9001654_Ctrl:curTimesTries()
	return table.nums(self.gotTreasure)
end
function activity_9001654_Ctrl:setRewardGetFlag(rewards)
	for i, v in pairs(rewards) do
		if self.gotTreasure[tostring(v.index)] then
			v.getFlag = true
		else
			v.getFlag = false
		end
	end
	return rewards
end
return activity_9001654_Ctrl

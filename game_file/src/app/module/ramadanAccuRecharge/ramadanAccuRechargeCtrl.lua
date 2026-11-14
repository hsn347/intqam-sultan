local ramadanAccuRechargeltCtrl = include("ramadanAccuRechargeltCtrl")
local GameModule = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local ramadanAccuRechargeCtrl = class("ramadanAccuRechargeCtrl", GameModule)
function ramadanAccuRechargeCtrl:ctor(properties)
	ramadanAccuRechargeCtrl.super.ctor(self, properties)
end
function ramadanAccuRechargeCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_RAMADAN_CUMU_RECHARGE_MODULE, gCmd.REQ_RAMADAN_CUMU_RECHARGE_DATA, handler(self, self.sendReqDataRsp))
	msgCtrl.register(gCmd.CMD_RAMADAN_CUMU_RECHARGE_MODULE, gCmd.REQ_RAMADAN_CUMU_RECHARGE_REWARD, handler(self, self.sendReqRewardRsp))
	self:resetData()
	self:registerNotify()
end
function ramadanAccuRechargeCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.RAMADAN_CUMU_RECHARGE, handler(self, self.notifyHandler))
end
function ramadanAccuRechargeCtrl:notifyHandler(event)
	dump(event.data, "ramadanAccuRechargeCtrl:notifyHandler", 10)
	for _, content in ipairs(event.data) do
		self.curScore = content.data.curScore
		_ENV = nil
		;(nil).msg = "MESSAGE_RAMADAN_ACCU_RECHARGE"
		;(nil).subMsg = "init"
		SoraDSendMessage(nil)
	end
end
function ramadanAccuRechargeCtrl:initClientData(data)
	dump(data, "ramadanAccuRechargeCtrl:initClientData", 10)
	if data then
		self:setData(data)
	end
end
function ramadanAccuRechargeCtrl:Logout()
	self:resetData()
	ramadanAccuRechargeCtrl.super.Logout(self)
end
function ramadanAccuRechargeCtrl:resetData()
	self.classType = 1
	self.curScore = 0
	self.gotReward, _UPVALUE0_, self.firstRechargeTime = nil, nil, 0
end
function ramadanAccuRechargeCtrl:setData(data)
	self.classType = data.classType
	self.curScore = data.curScore
	self.firstRechargeTime = data.firstRechargeTime
	if data.gotReward then
		for i, v in pairs(data.gotReward) do
			self.gotReward[tonumber(i)] = v
		end
	end
end
function ramadanAccuRechargeCtrl:sendDataMsg()
	serverproxy:Request(gCmd.CMD_RAMADAN_CUMU_RECHARGE_MODULE, gCmd.REQ_RAMADAN_CUMU_RECHARGE_DATA)
end
function ramadanAccuRechargeCtrl:sendRewardMsg(index)
	serverproxy = nil
	;(nil).index = index
	serverproxy:Request(gCmd.CMD_RAMADAN_CUMU_RECHARGE_MODULE, gCmd.REQ_RAMADAN_CUMU_RECHARGE_REWARD, nil)
end
function ramadanAccuRechargeCtrl:sendReqDataRsp(content)
	dump(content, "ramadanAccuRechargeCtrl:sendReqInfoRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self:setData(data)
		_ENV = self
		self.msg = "MESSAGE_RAMADAN_ACCU_RECHARGE"
		self.subMsg = "init"
		SoraDSendMessage(self)
	end
end
function ramadanAccuRechargeCtrl:sendReqRewardRsp(content)
	dump(content, "==ramadanAccuRechargeCtrl：sendReqDonateRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		for i, v in pairs(data.gotReward) do
			self.gotReward[tonumber(i)] = v
		end
		_ENV = pairs(data.gotReward)
		pairs(data.gotReward).msg = "MESSAGE_RAMADAN_ACCU_RECHARGE"
		pairs(data.gotReward).subMsg = "reward"
		pairs(data.gotReward).reward = content.rspdata.reward
		SoraDSendMessage(pairs(data.gotReward))
	end
	if content.err == gErrDef.Err_STAR_TREASURE_EXPLORE_NOT_OPEN then
		_ENV = gErrDef.Err_STAR_TREASURE_EXPLORE_NOT_OPEN
		gErrDef.Err_STAR_TREASURE_EXPLORE_NOT_OPEN.msg = "MESSAGE_RAMADAN_ACCU_RECHARGE"
		gErrDef.Err_STAR_TREASURE_EXPLORE_NOT_OPEN.subMsg = "notOpen"
		SoraDSendMessage(gErrDef.Err_STAR_TREASURE_EXPLORE_NOT_OPEN)
	end
end
function ramadanAccuRechargeCtrl:getReceiveStatusAndNum()
	if not self.curScore then
		print("ramadanAccuRechargeCtrl:getReceiveStatusAndNum curScore为Nil")
		return false
	end
	if self.curScore == 0 then
		return false
	end
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local classtype = activityShowCtrl:getParamByID(gActivityTimeActivityID.RAMADAN_ACCUMULATE_RECHARGE).classtype
	if not self.reachPointList then
		self.reachPointList = ramadanAccuRechargeltCtrl.getPointRewardDataByClassType(classtype)
	end
	local num = 0
	for i, v in ipairs(self.reachPointList) do
		if self.curScore >= v.point and not self.gotReward[i] then
			num = num + 1
		end
	end
	if num and 0 < num then
		return true, -1
	end
	return false
end
function ramadanAccuRechargeCtrl:getClassType()
	return self.classType
end
function ramadanAccuRechargeCtrl:getCurScore()
	return self.curScore
end
function ramadanAccuRechargeCtrl:getGotReward()
	return self.gotReward
end
function ramadanAccuRechargeCtrl:hadGotReward(index)
	if self.gotReward[index] and self.gotReward[index] > 0 then
		return true
	end
	return false
end
return ramadanAccuRechargeCtrl

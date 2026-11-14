local GameModule = include("GameModule")
local eventLuckyRechargeCtrl = class("eventLuckyRechargeCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function eventLuckyRechargeCtrl:ctor(properties)
	eventLuckyRechargeCtrl.super.ctor(self, properties)
end
function eventLuckyRechargeCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_LUCKY_RECHARGE_TASK_MODULE, gCmd.REQ_LUCKY_RECHARGE_TASK_RECEIVE, handler(self, self.getReceiveReward))
	self:resetData()
end
function eventLuckyRechargeCtrl:resetData()
	self.luckyRechargeData, _UPVALUE0_ = nil, nil
end
function eventLuckyRechargeCtrl:Logout()
	self:resetData()
	eventLuckyRechargeCtrl.super.Logout(self)
end
function eventLuckyRechargeCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.LUCKY_RECHARGE_TASK, handler(self, self.notifyRechargeData))
end
function eventLuckyRechargeCtrl:notifyRechargeData(event)
	for i, content in ipairs(event.data) do
		self:setLuckyRechargeData(content)
	end
	_ENV = ipairs(event.data)
	ipairs(event.data).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	ipairs(event.data).eventID = gActivityTimeActivityID.LUCKY_RECHARGE_TASK_ACTIVIYT
	SoraDSendMessage(ipairs(event.data))
end
function eventLuckyRechargeCtrl:setLuckyRechargeData(data)
	self.luckyRechargeData = data
	_ENV = nil
	;(nil).msg = "MESSAGE_LUCKY_RECHARGE_REFRESH"
	SoraDSendMessage(nil)
end
function eventLuckyRechargeCtrl:initClientData(data)
	self:setLuckyRechargeData(data)
	self:registerNotify()
end
function eventLuckyRechargeCtrl:getReceiveReward(content)
	if gErrDef.Err_None == content.err then
		self.luckyRechargeData.rechargeStatus = content.rspdata.rechargeStatus
		self:setLuckyRechargeData(self.luckyRechargeData)
		_ENV = self
		self.msg = "MESSAGE_LUCKY_RECHARGE_REWARDBACK"
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		self.eventID = gActivityTimeActivityID.LUCKY_RECHARGE_TASK_ACTIVIYT
		SoraDSendMessage(self)
	elseif gErrDef.Err_LUCKY_RECHARGE_TASK_NOT_IN_SELF_KID == content.err then
	else
		if gErrDef.Err_LUCKY_RECHARGE_TASK_NO_REWARD_RECEIVE == content.err then
		else
		end
	end
end
function eventLuckyRechargeCtrl:getLuckyRechargeData()
	local _ENV, data
	if not self.luckyRechargeData then
		_ENV = self.luckyRechargeData
	end
	data = clone(self.luckyRechargeData)
	if data.reward then
		local ok, reward = SoraDchangeToMap(data.reward)
		if ok then
			data.reward = reward
		end
	end
	return data
end
function eventLuckyRechargeCtrl:sendReceiveReward()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_LUCKY_RECHARGE_TASK_MODULE, gCmd.REQ_LUCKY_RECHARGE_TASK_RECEIVE, data)
end
function eventLuckyRechargeCtrl:getReceiveStatusAndNum(...)
	if self.luckyRechargeData and self.luckyRechargeData.rechargeStatus and self.luckyRechargeData.rechargeStatus == gLuckyRechargeStatus.CAN_RECEIVE then
		return true, 1
	end
	return false, 0
end
return eventLuckyRechargeCtrl

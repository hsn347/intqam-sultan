local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local cumulativeRecharge2021Ctrl = class("cumulativeRecharge2021Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function cumulativeRecharge2021Ctrl:ctor(properties)
	cumulativeRecharge2021Ctrl.super.ctor(self, properties)
	self:resetData()
end
function cumulativeRecharge2021Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_CUMULATIVE_RECHARGE_DATA, handler(self, self.reqActivityInitRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_CUMULATIVE_RECHARGE_REWARD, handler(self, self.reqGetRewardRsp))
	self:registerNotify()
end
function cumulativeRecharge2021Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.CUMULATIVE_RECHARGE_2021, handler(self, self.notifyHandler))
end
function cumulativeRecharge2021Ctrl:notifyHandler(event)
	dump(event.data, "cumulativeRecharge2021Ctrl:notifyHandler", 10)
	for _, content in pairs(event.data) do
		if content then
			self:initClientData(content)
			_ENV = self
			self.msg = "MESSAGE_CUMULATIVE_RECHARGE_2021_INIT"
			SoraDSendMessage(self)
		end
	end
	_ENV = pairs(event.data)
	pairs(event.data).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	pairs(event.data).eventID = gActivityTimeActivityID.CUMULATIVE_RECHARGE_2021
	SoraDSendMessage(pairs(event.data))
end
function cumulativeRecharge2021Ctrl:initClientData(data)
	if not data then
		return
	end
	self.data = data
end
function cumulativeRecharge2021Ctrl:Logout()
	cumulativeRecharge2021Ctrl.super.Logout(self)
	self:resetData()
end
function cumulativeRecharge2021Ctrl:resetData()
	self.data = nil
end
function cumulativeRecharge2021Ctrl:reqActivityInit()
	print("cumulativeRecharge2021Ctrl:reqActivityInit")
	_ENV = nil
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_CUMULATIVE_RECHARGE_DATA, nil)
end
function cumulativeRecharge2021Ctrl:reqGetReward()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_CUMULATIVE_RECHARGE_REWARD, nil)
end
function cumulativeRecharge2021Ctrl:reqActivityInitRsp(content)
	dump(content, "cumulativeRecharge2021Ctrl:reqActivityInit(content)", 10)
	if content.err == gErrDef.Err_None then
		self:initClientData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_CUMULATIVE_RECHARGE_2021_INIT"
		SoraDSendMessage(self)
	end
end
function cumulativeRecharge2021Ctrl:reqGetRewardRsp(content)
	dump(content, "cumulativeRecharge2021Ctrl:reqGetRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:initClientData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_CUMULATIVE_RECHARGE_2021_INIT"
		SoraDSendMessage(self)
		SoraDMailGainItems(content.rspdata.rewards, true)
		_ENV = content.rspdata.rewards
		content.rspdata.rewards.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		content.rspdata.rewards.eventID = gActivityTimeActivityID.CUMULATIVE_RECHARGE_2021
		SoraDSendMessage(content.rspdata.rewards)
	end
end
function cumulativeRecharge2021Ctrl:getReceiveStatusAndNum()
	return self:getIsCanGetReward(), -1, 0
end
function cumulativeRecharge2021Ctrl:getIsComplete(index)
	return self.data and self.data.complete[index] ~= nil or false
end
function cumulativeRecharge2021Ctrl:getPrice()
	return self.data and self.data.price or 0
end
function cumulativeRecharge2021Ctrl:getIsCanGetReward()
	return self.data and self.data.freeReward == 0 or false
end
function cumulativeRecharge2021Ctrl:getIsTodayComplete(idx)
	if not self.data or #self.data.complete == 0 then
		return false
	end
	idx = idx and idx or #self.data.complete
	local comleteTime = self.data.complete[idx]
	if not comleteTime then
		return false
	end
	if serviceFunctions.isSameDay(comleteTime) then
		return true
	end
	return false
end
function cumulativeRecharge2021Ctrl:getCompleteCount()
	return self.data and #self.data.complete or 0
end
return cumulativeRecharge2021Ctrl

local sultanCoinRebateRead = include("sultanCoinRebateRead")
local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local sultanCoinRebateCtrl = class("sultanCoinRebateCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function sultanCoinRebateCtrl:ctor(properties)
	sultanCoinRebateCtrl.super.ctor(self, properties)
	self:resetData()
	self.activityID = gActivityTimeActivityID.SULTAN_COIN_REBATE_ACTIVITY
end
function sultanCoinRebateCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_SULTAN_COIN_REBATE_MODULE, gCmd.REQ_SULTAN_COIN_REBATE_INIT, handler(self, self.reqSultanCoinRebateInitRsp))
	msgCtrl.register(gCmd.CMD_SULTAN_COIN_REBATE_MODULE, gCmd.REQ_SULTAN_COIN_REBATE_RECEIVE, handler(self, self.reqSultanCoinRebateReceiveRsp))
	self:registerNotify()
end
function sultanCoinRebateCtrl:Logout()
	sultanCoinRebateCtrl.super.Logout(self)
	self:resetData()
end
function sultanCoinRebateCtrl:resetData()
	self.initData, _UPVALUE0_ = nil, nil
end
function sultanCoinRebateCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.SULTAN_COIN_REBATE, handler(self, self.notifyHandler))
end
function sultanCoinRebateCtrl:notifyHandler(event)
	dump(event.data, "sultanCoinRebateCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		self.initData = v.initData
		_ENV = nil
		;(nil).msg = "MESSAGE_ACTIVITY_9001533_UPDATE"
		SoraDSendMessage(nil)
	end
end
function sultanCoinRebateCtrl:sendReqInitDataMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_SULTAN_COIN_REBATE_MODULE, gCmd.REQ_SULTAN_COIN_REBATE_INIT, nil)
end
function sultanCoinRebateCtrl:reqSultanCoinRebateInitRsp(content)
	dump(content, "sultanCoinRebateCtrl:reqSultanCoinRebateInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData = content.rspdata.initData
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001533_UPDATE"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function sultanCoinRebateCtrl:reqSultanCoinRebateReceive(stage)
	serverproxy = nil
	;(nil).stage = stage
	serverproxy:Request(gCmd.CMD_SULTAN_COIN_REBATE_MODULE, gCmd.REQ_SULTAN_COIN_REBATE_RECEIVE, nil)
end
function sultanCoinRebateCtrl:reqSultanCoinRebateReceiveRsp(content)
	dump(content, "sultanCoinRebateCtrl:reqSultanCoinRebateReceiveRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData = content.rspdata.initData
		local reward = content.rspdata.reward
		SoraDMailGainItems(reward, true)
		_ENV = reward
		reward.msg = "MESSAGE_ACTIVITY_9001533_UPDATE"
		SoraDSendMessage(reward)
	end
end
function sultanCoinRebateCtrl:getReceiveStatusAndNum()
	local num = 0
	local taskList = sultanCoinRebateRead.getOthenrebate(self:getGroupIndex())
	for i, v in ipairs(taskList) do
		if self:getTaskStatus(v.consume, v.index) == gBtnTargetStatusDef.GET then
			num = num + 1
		end
	end
	return 0 < num, -1
end
function sultanCoinRebateCtrl:getTaskStatus(count, id)
	if count > self:getCostCount() then
		return gBtnTargetStatusDef.GO
	elseif self.initData.receiveRecord and self.initData.receiveRecord[tostring(id)] then
		return gBtnTargetStatusDef.GOT
	else
		return gBtnTargetStatusDef.GET
	end
end
function sultanCoinRebateCtrl:getCostCount()
	return self.initData.costCount or 0
end
function sultanCoinRebateCtrl:getTaskList()
	local sultanCoinRebateRead, ret
	local taskList = sultanCoinRebateRead.getOthenrebate(self:getGroupIndex())
	for i, v in ipairs(taskList) do
		print("index", v.index, v.consume, self:getTaskStatus(v.consume, v.index))
		sultanCoinRebateRead = v.index
		v.index.index = v.index
		v.index.dataIndex = i
		v.index.status = self:getTaskStatus(v.consume, v.index)
		table.insert(ret, v.index)
	end
	table.sort(ret, function(l, r)
		if l.status ~= r.status then
			return l.status < r.status
		else
			return l.index < r.index
		end
	end)
	return ret
end
function sultanCoinRebateCtrl:getGroupIndex()
	return SoraDGetCtrl("activityShowCtrl"):getParamClassType(self.activityID)
end
return sultanCoinRebateCtrl

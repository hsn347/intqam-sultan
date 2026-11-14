local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001487_Ctrl = class("activity_9001487_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001487_Ctrl:ctor(properties)
	activity_9001487_Ctrl.super.ctor(self, properties)
	self:resetData()
end
function activity_9001487_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_GREAT_ARMOR_MODULE, gCmd.REQ_GREAT_ARMOR_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_GREAT_ARMOR_MODULE, gCmd.REQ_GREAT_ARMOR_RECEIVE_1, handler(self, self.reqReceiveRsp))
	msgCtrl.register(gCmd.CMD_GREAT_ARMOR_MODULE, gCmd.REQ_GREAT_ARMOR_RECEIVE_2, handler(self, self.reqReceiveRsp))
	msgCtrl.register(gCmd.CMD_GREAT_ARMOR_MODULE, gCmd.REQ_GREAT_ARMOR_RECEIVE_3, handler(self, self.reqReceiveRsp))
end
function activity_9001487_Ctrl:Logout()
	activity_9001487_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001487_Ctrl:resetData()
	self.data, _UPVALUE0_ = nil, nil
end
function activity_9001487_Ctrl:initClientData(data)
	dump(data, "activity_9001487_Ctrl:initClientData", 10)
	if data then
		self.initData = data
	end
	self:registerNotify()
end
function activity_9001487_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.GREAT_ARMOR, handler(self, self.notifyHandler))
end
function activity_9001487_Ctrl:notifyHandler(event)
	dump(event.data, "activity_9001487_Ctrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		self.initData = v.initData
		_ENV = nil
		;(nil).msg = "MESSAGE_ACTIVITY_9001487_CUMUDAYDATA"
		SoraDSendMessage(nil)
	end
end
function activity_9001487_Ctrl:reqInit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_GREAT_ARMOR_MODULE, gCmd.REQ_DICTATORSHIPS_DATA, nil)
end
function activity_9001487_Ctrl:reqInitRsp(content)
	dump(content, "activity_9001487_Ctrl:reqInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		if not content.rspdata.initData then
			_ENV = content.rspdata.initData
		end
		self.initData = content.rspdata.initData
	end
end
function activity_9001487_Ctrl:reqReceive(activityID, index, clientData)
	local subcmd = gCmd.REQ_GREAT_ARMOR_RECEIVE_1
	if activityID == gActivityTimeActivityID.GREAT_ARMOR_ACTIVITY_2 then
		subcmd = gCmd.REQ_GREAT_ARMOR_RECEIVE_2
	elseif activityID == gActivityTimeActivityID.GREAT_ARMOR_ACTIVITY_3 then
		subcmd = gCmd.REQ_GREAT_ARMOR_RECEIVE_3
	end
	_ENV = nil
	;(nil).index = index
	serverproxy:Request(gCmd.CMD_GREAT_ARMOR_MODULE, subcmd, nil, clientData)
end
function activity_9001487_Ctrl:reqReceiveRsp(content)
	dump(content, "activity_9001487_Ctrl:reqReceiveRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local reward = content.rspdata.reward
		SoraDMailGainItems(reward, true)
		self.initData = content.rspdata.initData
		_ENV = reward
		reward.msg = "MESSAGE_ACTIVITY_9001487_CLAIM"
		reward.clientData = content.clientData
		SoraDSendMessage(reward)
	end
end
function activity_9001487_Ctrl:getActivityData(activityID)
	if not self.initData[tostring(activityID)] then
		_ENV = self.initData[tostring(activityID)]
	end
	return self.initData[tostring(activityID)]
end
function activity_9001487_Ctrl:getRechargeRecord(activityID)
	local data = self:getActivityData(activityID)
	if not data.rechargeRecord then
		_UPVALUE0_ = data.rechargeRecord
	end
	return data.rechargeRecord
end
function activity_9001487_Ctrl:getDayRechargeRecord(activityID, days)
	local rechargeRecord = self:getRechargeRecord(activityID)
	return rechargeRecord[tostring(days)] or 0
end
function activity_9001487_Ctrl:getReceiveRecord(activityID)
	local data = self:getActivityData(activityID)
	if not data.receiveRecord then
		_UPVALUE0_ = data.receiveRecord
	end
	return data.receiveRecord
end
function activity_9001487_Ctrl:getCurDay(activityID)
	local data = self:getActivityData(activityID)
	return data.curDay or 1
end
function activity_9001487_Ctrl:getReceiveState(activityID, index)
	local receiveRecord = self:getReceiveRecord(activityID)
	return receiveRecord[tostring(index)]
end
function activity_9001487_Ctrl:initRechargeConfig(key, activityID)
	local great_armor = require_data(key, true).data
	local _ENV, ret = key, key
	for i, v in ipairs(great_armor) do
		if not activityID or v.activtyID == activityID then
			if not ret[v.classtype] then
				_ENV = ret[v.classtype]
			end
			ret[v.classtype] = ret[v.classtype]
			if not ret[v.classtype][v.days] then
				_ENV = ret[v.classtype][v.days]
			end
			ret[v.classtype][v.days] = ret[v.classtype][v.days]
			table.insert(ret[v.classtype][v.days], v)
		end
	end
	return ret
end
function activity_9001487_Ctrl:getRechargeConfig(activityID)
	if not self.rechargeConfig then
		_ENV = self.rechargeConfig
		self.rechargeConfig[gActivityTimeActivityID.GREAT_ARMOR_ACTIVITY_1] = self:initRechargeConfig("great_armor", gActivityTimeActivityID.GREAT_ARMOR_ACTIVITY_1)
		self.rechargeConfig[gActivityTimeActivityID.GREAT_ARMOR_ACTIVITY_2] = self:initRechargeConfig("great_armor_2")
		self.rechargeConfig, self.rechargeConfig[gActivityTimeActivityID.GREAT_ARMOR_ACTIVITY_3] = self.rechargeConfig, self:initRechargeConfig("great_armor", gActivityTimeActivityID.GREAT_ARMOR_ACTIVITY_3)
	end
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local classtype = activityShowCtrl:getParamClassType(activityID) or 1
	local rechargeConfig = self.rechargeConfig[activityID]
	return rechargeConfig[classtype] or rechargeConfig[1]
end
function activity_9001487_Ctrl:getCurDayRechargeList(activityID)
	local temp = self:getRechargeConfig(activityID)
	local curDay = self:getCurDay(activityID)
	local rechargeConfig = temp[curDay] or temp[1]
	local _ENV, ret = activityID, activityID
	for i, v in ipairs(rechargeConfig) do
		_ENV = nil
		;(nil).amount = v.amount
		;(nil).cfg = v
		table.insert(ret, nil)
	end
	table.sort(ret, function(a, b)
		if a.amount ~= b.amount then
			return a.amount < b.amount
		end
	end)
	return ret
end
function activity_9001487_Ctrl:initRewardConfig(key, activityID)
	local great_armor = require_data(key, true).data
	local _ENV, ret = key, key
	for i, v in ipairs(great_armor) do
		if not activityID or v.activtyID == activityID then
			if not ret[v.classtype] then
				_ENV = ret[v.classtype]
			end
			ret[v.classtype] = ret[v.classtype]
			table.insert(ret[v.classtype], v)
		end
	end
	return ret
end
function activity_9001487_Ctrl:getRewardConfig(activityID)
	if not self.rewardConfig then
		_ENV = self.rewardConfig
		self.rewardConfig[gActivityTimeActivityID.GREAT_ARMOR_ACTIVITY_1] = self:initRewardConfig("great_armor", gActivityTimeActivityID.GREAT_ARMOR_ACTIVITY_1)
		self.rewardConfig[gActivityTimeActivityID.GREAT_ARMOR_ACTIVITY_2] = self:initRewardConfig("great_armor_2")
		self.rewardConfig, self.rewardConfig[gActivityTimeActivityID.GREAT_ARMOR_ACTIVITY_3] = self.rewardConfig, self:initRewardConfig("great_armor", gActivityTimeActivityID.GREAT_ARMOR_ACTIVITY_3)
	end
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local classtype = activityShowCtrl:getParamClassType(activityID) or 1
	local rewardConfig = self.rewardConfig[activityID]
	return rewardConfig[classtype] or rewardConfig[1]
end
function activity_9001487_Ctrl:getRewardList(activityID)
	local rewardConfig = self:getRewardConfig(activityID)
	return rewardConfig
end
function activity_9001487_Ctrl:getReceiveStatusAndNum(activityID)
	if not clientEventMgr.judgeIsOpen(activityID) then
		return false
	end
	local receiveRecord = self:getReceiveRecord(activityID)
	for k, state in pairs(receiveRecord) do
		if state == gGreatArmorStatue.CAN_RECEIVE then
			return true, -1
		end
	end
	return false
end
return activity_9001487_Ctrl

local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activityCommonSignCtrl = class("activityCommonSignCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activityCommonSignCtrl:ctor(properties)
	activityCommonSignCtrl.super.ctor(self, properties)
	self:resetData()
end
local _ENV, _ENV, needRedNumConfig = nil, function(self, properties)
	activityCommonSignCtrl.super.ctor(self, properties)
	self:resetData()
end, function(self, properties)
	activityCommonSignCtrl.super.ctor(self, properties)
	self:resetData()
end
;(nil)[gActivityTimeActivityID.SIGN_REWARD_9001687_ACTIVITY] = true
local (nil)[gActivityTimeActivityID.DAILY_SALUTE], defaultCmdActivity = true, nil
function activityCommonSignCtrl:EnterGame()
	_UPVALUE5_ = nil
	_ENV, self.defaultCmd, (nil)[1] = nil, nil, gCmd.CMD_COMMON_SIGN_ACTIVIT_MODULE
	_ENV, self.defaultCmd, (nil)[2] = nil, nil, gCmd.REQ_COMMON_SIGN_ACTIVITY_INIT
	_ENV, self.defaultCmd, (nil)[3] = nil, nil, gCmd.REQ_COMMON_SIGN_ACTIVITY_SIGN
	_ENV, self.defaultCmd, (nil)[4] = nil, nil, gCmd.REQ_COMMON_SIGN_ACTIVITY_USE_GOLD_SIGN
	_ENV, self.defaultCmd, (nil)[5] = nil, nil, gCmd.REQ_COMMON_SIGN_ACTIVITY_GET_EXTRA_REWARD
	_UPVALUE5_ = gCmd.REQ_COMMON_SIGN_ACTIVITY_INIT
	;(nil)[gActivityTimeActivityID.SIGN_REWARD_9001659_ACTIVITY], gCmd.REQ_COMMON_SIGN_ACTIVITY_INIT[1] = gCmd.REQ_COMMON_SIGN_ACTIVITY_INIT, gCmd.CMD_SIGN_REWARD_ACTIVITY_MODULE
	;(nil)[gActivityTimeActivityID.SIGN_REWARD_9001659_ACTIVITY], gCmd.REQ_COMMON_SIGN_ACTIVITY_INIT[2] = gCmd.REQ_COMMON_SIGN_ACTIVITY_INIT, gCmd.REQ_SIGN_REWARD_9001659_ACTIVITY_INIT
	;(nil)[gActivityTimeActivityID.SIGN_REWARD_9001659_ACTIVITY], gCmd.REQ_COMMON_SIGN_ACTIVITY_INIT[3] = gCmd.REQ_COMMON_SIGN_ACTIVITY_INIT, gCmd.REQ_SIGN_REWARD_9001659_ACTIVITY_SIGN
	;(nil)[gActivityTimeActivityID.SIGN_REWARD_9001659_ACTIVITY], gCmd.REQ_COMMON_SIGN_ACTIVITY_INIT[4] = gCmd.REQ_COMMON_SIGN_ACTIVITY_INIT, gCmd.REQ_SIGN_REWARD_9001659_ACTIVITY_USE_GOLD_SIGN
	;(nil)[gActivityTimeActivityID.SIGN_REWARD_9001659_ACTIVITY], gCmd.REQ_COMMON_SIGN_ACTIVITY_INIT[5] = gCmd.REQ_COMMON_SIGN_ACTIVITY_INIT, gCmd.REQ_SIGN_REWARD_9001659_ACTIVITY_GET_EXTRA_REWARD
	_UPVALUE5_ = gCmd.REQ_COMMON_SIGN_ACTIVITY_INIT
	;(nil)[gActivityTimeActivityID.SIGN_REWARD_9001636_ACTIVITY], gCmd.REQ_COMMON_SIGN_ACTIVITY_INIT[1] = gCmd.REQ_COMMON_SIGN_ACTIVITY_INIT, gCmd.CMD_SIGN_REWARD_ACTIVITY_MODULE
	;(nil)[gActivityTimeActivityID.SIGN_REWARD_9001636_ACTIVITY], gCmd.REQ_COMMON_SIGN_ACTIVITY_INIT[2] = gCmd.REQ_COMMON_SIGN_ACTIVITY_INIT, gCmd.REQ_SIGN_REWARD_9001636_ACTIVITY_INIT
	;(nil)[gActivityTimeActivityID.SIGN_REWARD_9001636_ACTIVITY], gCmd.REQ_COMMON_SIGN_ACTIVITY_INIT[3] = gCmd.REQ_COMMON_SIGN_ACTIVITY_INIT, gCmd.REQ_SIGN_REWARD_9001636_ACTIVITY_SIGN
	;(nil)[gActivityTimeActivityID.SIGN_REWARD_9001636_ACTIVITY], gCmd.REQ_COMMON_SIGN_ACTIVITY_INIT[4] = gCmd.REQ_COMMON_SIGN_ACTIVITY_INIT, gCmd.REQ_SIGN_REWARD_9001636_ACTIVITY_USE_GOLD_SIGN
	;(nil)[gActivityTimeActivityID.SIGN_REWARD_9001636_ACTIVITY], gCmd.REQ_COMMON_SIGN_ACTIVITY_INIT[5] = gCmd.REQ_COMMON_SIGN_ACTIVITY_INIT, gCmd.REQ_SIGN_REWARD_9001636_ACTIVITY_GET_EXTRA_REWARD
	_UPVALUE5_ = gCmd.REQ_COMMON_SIGN_ACTIVITY_INIT
	self.cmdConfig, (nil)[gActivityTimeActivityID.SIGN_REWARD_9001623_ACTIVITY], gCmd.REQ_COMMON_SIGN_ACTIVITY_INIT[1] = nil, gCmd.REQ_COMMON_SIGN_ACTIVITY_INIT, gCmd.CMD_SIGN_REWARD_ACTIVITY_MODULE
	self.cmdConfig, (nil)[gActivityTimeActivityID.SIGN_REWARD_9001623_ACTIVITY], gCmd.REQ_COMMON_SIGN_ACTIVITY_INIT[2] = nil, gCmd.REQ_COMMON_SIGN_ACTIVITY_INIT, gCmd.REQ_SIGN_REWARD_9001623_ACTIVITY_INIT
	self.cmdConfig, (nil)[gActivityTimeActivityID.SIGN_REWARD_9001623_ACTIVITY], gCmd.REQ_COMMON_SIGN_ACTIVITY_INIT[3] = nil, gCmd.REQ_COMMON_SIGN_ACTIVITY_INIT, gCmd.REQ_SIGN_REWARD_9001623_ACTIVITY_SIGN
	self.cmdConfig, (nil)[gActivityTimeActivityID.SIGN_REWARD_9001623_ACTIVITY], gCmd.REQ_COMMON_SIGN_ACTIVITY_INIT[4] = nil, gCmd.REQ_COMMON_SIGN_ACTIVITY_INIT, gCmd.REQ_SIGN_REWARD_9001623_ACTIVITY_USE_GOLD_SIGN
	self.cmdConfig, (nil)[gActivityTimeActivityID.SIGN_REWARD_9001623_ACTIVITY], gCmd.REQ_COMMON_SIGN_ACTIVITY_INIT[5] = nil, gCmd.REQ_COMMON_SIGN_ACTIVITY_INIT, gCmd.REQ_SIGN_REWARD_9001623_ACTIVITY_GET_EXTRA_REWARD
	msgCtrl.register(self.defaultCmd[1], self.defaultCmd[2], handler(self, self.reqInitRsp))
	msgCtrl.register(self.defaultCmd[1], self.defaultCmd[3], handler(self, self.reqSignRsp))
	msgCtrl.register(self.defaultCmd[1], self.defaultCmd[4], handler(self, self.reqUseGoldSignRsp))
	msgCtrl.register(self.defaultCmd[1], self.defaultCmd[5], handler(self, self.reqExtraRewardRsp))
	for __, cmdCfg in pairs(self.cmdConfig) do
		msgCtrl.register(cmdCfg[1], cmdCfg[2], handler(self, self.reqInitRsp))
		msgCtrl.register(cmdCfg[1], cmdCfg[3], handler(self, self.reqSignRsp))
		msgCtrl.register(cmdCfg[1], cmdCfg[4], handler(self, self.reqUseGoldSignRsp))
		msgCtrl.register(cmdCfg[1], cmdCfg[5], handler(self, self.reqExtraRewardRsp))
	end
	self:registerNotify()
end
function activityCommonSignCtrl:Logout()
	activityCommonSignCtrl.super.Logout(self)
	self:resetData()
end
function activityCommonSignCtrl:resetData()
	_UPVALUE0_ = nil
	;(nil).totalDay = 1
	;(nil).curDay = 1
	;(nil).totalSignDay = 0
	self.activityData, _UPVALUE0_, self.defaultData, (nil).extraRewardInfo, _UPVALUE0_, (nil).signInfo, _UPVALUE0_, (nil).useGoldDay = nil, nil, nil, nil, nil, nil, nil, 0
end
function activityCommonSignCtrl:initClientData(activityID, data)
	if not data then
		return
	end
	_ENV = nil
	;(nil).activityID = activityID
	;(nil).data = data
	dump(nil, "activityCommonSignCtrl:initClientData", 10)
	self:updateActivityData(activityID, data)
end
function activityCommonSignCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.SIGN_REWARD_ACTIVITY, handler(self, self.notifyHandler))
end
function activityCommonSignCtrl:notifyHandler(event)
	dump(event.data, "activityCommonSignCtrl:notifyHandler", 10)
	for __, content in ipairs(event.data) do
		local activityID = content.activityID
		self:updateActivityData(activityID, content)
		if activityID == gActivityTimeActivityID.DAILY_SALUTE then
			_ENV = self
			self.msg = "MESSAGE_ACTIVITY_9001688_UPDATE"
			SoraDSendMessage(self)
		end
	end
end
function activityCommonSignCtrl:sendReqInitDataMsg(activityID)
	self:reqInit(activityID)
end
function activityCommonSignCtrl:reqInit(activityID)
	local cmdCfg = self.cmdConfig[activityID] or self.defaultCmd
	serverproxy = nil
	serverproxy, (nil).activityID = nil, activityID
	;(nil).activityID = activityID
	serverproxy:Request(cmdCfg[1], cmdCfg[2], nil, nil)
end
function activityCommonSignCtrl:reqInitRsp(content)
	dump(content, "activityCommonSignCtrl:reqInitRsp(content)", 10)
	local activityID = content.clientData.activityID
	if content.err == gErrDef.Err_None then
		if defaultCmdActivity[activityID] then
			self:updateActivityData(activityID, content.rspdata)
		else
			self:updateActivityData(activityID, content.data)
		end
	end
	_ENV = self
	self.msg = "MESSAGE_ACTIVITY_COMMON_SIGN_UPDATE"
	self.activityID = activityID
	self.subMsg = "init"
	SoraDSendMessage(self)
end
function activityCommonSignCtrl:reqSign(activityID)
	local cmdCfg = self.cmdConfig[activityID] or self.defaultCmd
	serverproxy = nil
	serverproxy, (nil).activityID = nil, activityID
	;(nil).activityID = activityID
	serverproxy:Request(cmdCfg[1], cmdCfg[3], nil, nil)
end
function activityCommonSignCtrl:reqSignRsp(content)
	dump(content, "activityCommonSignCtrl:reqSignRsp(content)", 10)
	local activityID = content.clientData.activityID
	if content.err == gErrDef.Err_None then
		if defaultCmdActivity[activityID] then
			self:updateActivityData(activityID, content.rspdata)
			if content.rspdata.rewards then
				SoraDMailGainItems(content.rspdata.rewards, true)
			end
		else
			self:updateActivityData(activityID, content.data)
			if content.data.items then
				SoraDMailGainItems(content.data.items, true)
			end
		end
	end
	_ENV = content.data.items
	content.data.items.msg = "MESSAGE_ACTIVITY_COMMON_SIGN_UPDATE"
	content.data.items.activityID = activityID
	content.data.items.subMsg = "sign"
	SoraDSendMessage(content.data.items)
end
function activityCommonSignCtrl:reqUseGoldSign(activityID, signDay)
	local cmdCfg = self.cmdConfig[activityID] or self.defaultCmd
	serverproxy = nil
	;(nil).signDay = signDay
	serverproxy, (nil).activityID = nil, activityID
	;(nil).activityID = activityID
	serverproxy:Request(cmdCfg[1], cmdCfg[4], nil, nil)
end
function activityCommonSignCtrl:reqUseGoldSignRsp(content)
	dump(content, "activityCommonSignCtrl:reqUseGoldSignRsp(content)", 10)
	local activityID = content.clientData.activityID
	if content.err == gErrDef.Err_None then
		if defaultCmdActivity[activityID] then
			self:updateActivityData(activityID, content.rspdata)
			if content.rspdata.rewards then
				SoraDMailGainItems(content.rspdata.rewards, true)
			end
		else
			self:updateActivityData(activityID, content.data)
			if content.data.items then
				SoraDMailGainItems(content.data.items, true)
			end
		end
	end
	_ENV = content.data.items
	content.data.items.msg = "MESSAGE_ACTIVITY_COMMON_SIGN_UPDATE"
	content.data.items.activityID = activityID
	content.data.items.subMsg = "useGoldSign"
	SoraDSendMessage(content.data.items)
end
function activityCommonSignCtrl:reqExtraReward(activityID, extraDay)
	local cmdCfg = self.cmdConfig[activityID] or self.defaultCmd
	serverproxy = nil
	;(nil).extraDay = extraDay
	serverproxy, (nil).activityID = nil, activityID
	;(nil).activityID = activityID
	serverproxy:Request(cmdCfg[1], cmdCfg[5], nil, nil)
end
function activityCommonSignCtrl:reqExtraRewardRsp(content)
	dump(content, "activityCommonSignCtrl:reqExtraRewardRsp(content)", 10)
	local activityID = content.clientData.activityID
	if content.err == gErrDef.Err_None then
		local activityData = self:getActivityData(activityID)
		if not activityData.extraRewardInfo then
			local _ENV, extraRewardInfo = activityData.extraRewardInfo, activityData.extraRewardInfo
		end
		local day
		if defaultCmdActivity[activityID] then
			day = content.data.extraDay
		else
			day = content.data.day
		end
		if day then
			extraRewardInfo[tostring(day)] = gSignRewardStatus.ALREADY_RECEIVE
		end
		_ENV = nil
		;(nil).extraRewardInfo = extraRewardInfo
		self:updateActivityData(activityID, nil)
		if defaultCmdActivity[activityID] then
			if content.rspdata.rewards then
				SoraDMailGainItems(content.rspdata.rewards, true)
			end
		elseif content.data.items then
			SoraDMailGainItems(content.data.items, true)
		end
	end
	_ENV = activityData.extraRewardInfo
	activityData.extraRewardInfo.msg = "MESSAGE_ACTIVITY_COMMON_SIGN_UPDATE"
	activityData.extraRewardInfo.activityID = activityID
	activityData.extraRewardInfo.subMsg = "extraReward"
	SoraDSendMessage(activityData.extraRewardInfo)
end
function activityCommonSignCtrl:updateActivityData(activityID, rspdata)
	if not self.activityData[activityID] then
		local _ENV, activityData = self.activityData[activityID], self.activityData[activityID]
	end
	if not rspdata then
		rspdata, _ENV = nil, nil
	end
	for key, __ in pairs(self.defaultData) do
		if rspdata[key] then
			activityData[key] = rspdata[key]
		end
	end
	self.activityData[activityID] = activityData
end
function activityCommonSignCtrl:getActivityData(activityID)
	if not self.activityData[activityID] then
		_UPVALUE0_ = self.activityData[activityID]
	end
	return self.activityData[activityID]
end
function activityCommonSignCtrl:getTotalDay(activityID)
	local activityData = self:getActivityData(activityID)
	return activityData.totalDay or 0
end
function activityCommonSignCtrl:getCurDay(activityID)
	local activityData = self:getActivityData(activityID)
	return activityData.curDay or 0
end
function activityCommonSignCtrl:getTotalSignDay(activityID)
	local activityData = self:getActivityData(activityID)
	return activityData.totalSignDay or 0
end
function activityCommonSignCtrl:getUseGoldDay(activityID)
	local activityData = self:getActivityData(activityID)
	return activityData.useGoldDay or 0
end
function activityCommonSignCtrl:getSignInfo(activityID)
	local activityData = self:getActivityData(activityID)
	if not activityData.signInfo then
		_UPVALUE0_ = activityData.signInfo
	end
	return activityData.signInfo
end
function activityCommonSignCtrl:getExtraRewardInfo(activityID)
	local activityData = self:getActivityData(activityID)
	if not activityData.extraRewardInfo then
		_UPVALUE0_ = activityData.extraRewardInfo
	end
	return activityData.extraRewardInfo
end
function activityCommonSignCtrl:getSignInfoByDay(activityID, day)
	local signInfo = self:getSignInfo(activityID)
	return signInfo[tostring(day)] or gSignRewardType.NO_SIGN
end
function activityCommonSignCtrl:getSignTypeByDay(...)
	return self:getSignInfoByDay(...)
end
function activityCommonSignCtrl:getExtraRewardInfoByDay(activityID, day)
	local extraRewardInfo = self:getExtraRewardInfo(activityID)
	return extraRewardInfo[tostring(day)] or gSignRewardStatus.NO_REWARD
end
function activityCommonSignCtrl:getGroup(activityID)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	return activityShowCtrl:getParamClassType(activityID)
end
function activityCommonSignCtrl:isCanReceive(activityID)
	if not clientEventMgr.checkCastleLvByActivityID(activityID) then
		return false, 0
	end
	local ret = false
	local retNum = 0
	local curDay = self:getCurDay(activityID)
	if self:getSignTypeByDay(activityID, curDay) == gSignRewardType.NO_SIGN then
		ret = true
		retNum = retNum + 1
	end
	if ret and not needRedNumConfig[activityID] then
		return true, -1
	end
	local activityCommonSignRead = include("activityCommonSignRead")
	local cumuDayArray = activityCommonSignRead.getCumuDayArray(activityID)
	for _, day in pairs(cumuDayArray) do
		if self:getExtraRewardInfoByDay(activityID, day) == gSignRewardStatus.CAN_RECEIVE then
			ret = true
			retNum = retNum + 1
			if ret and not needRedNumConfig[activityID] then
				return true, -1
			end
		end
	end
	return ret, retNum
end
function activityCommonSignCtrl:getReceiveStatusAndNum(activityID)
	return self:isCanReceive(activityID)
end
function activityCommonSignCtrl:getCostGold(activityID)
	local activityCommonSignRead = include("activityCommonSignRead")
	local time = self:getUseGoldDay(activityID) + 1
	return activityCommonSignRead.getRemedyPrice(activityID, time)
end
return activityCommonSignCtrl

local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local eidSignCtrl = class("eidSignCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function eidSignCtrl:ctor(properties)
	eidSignCtrl.super.ctor(self, properties)
	self:resetData()
	self.activityID = gActivityTimeActivityID.EID_SIGN_ACTIVITY
end
function eidSignCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_EID_SIGN_MODULE, gCmd.REQ_EID_SIGN_INIT, handler(self, self.reqEidSignInitRsp))
	msgCtrl.register(gCmd.CMD_EID_SIGN_MODULE, gCmd.REQ_EID_SIGN_COMMON_SIGN, handler(self, self.reqEidSignCommonSignRsp))
	msgCtrl.register(gCmd.CMD_EID_SIGN_MODULE, gCmd.REQ_EID_SIGN_USE_GOLD_SIGN, handler(self, self.reqEidSignUseGoldSignRsp))
	msgCtrl.register(gCmd.CMD_EID_SIGN_MODULE, gCmd.REQ_EID_SIGN_GET_EXTRA, handler(self, self.reqEidSignGetExtraRsp))
	self:registerNotify()
end
function eidSignCtrl:Logout()
	eidSignCtrl.super.Logout(self)
	self:resetData()
end
function eidSignCtrl:resetData()
	self.initData, _UPVALUE0_ = nil, nil
end
function eidSignCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.EID_SIGN, handler(self, self.notifyHandler))
end
function eidSignCtrl:notifyHandler(event)
	dump(event.data, "eidSignCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		self.initData = v.initData
		_ENV = nil
		;(nil).msg = "MESSAGE_ACTIVITY_9001537_UPDATE"
		SoraDSendMessage(nil)
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		;(nil).eventID = self.activityID
		SoraDSendMessage(nil)
	end
end
function eidSignCtrl:sendReqInitDataMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_EID_SIGN_MODULE, gCmd.REQ_EID_SIGN_INIT, nil)
end
function eidSignCtrl:reqEidSignInitRsp(content)
	dump(content, "eidSignCtrl:reqEidSignInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData = content.rspdata.initData
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001537_UPDATE"
		SoraDSendMessage(gErrDef.Err_None)
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		gErrDef.Err_None.eventID = self.activityID
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function eidSignCtrl:reqEidSignCommonSign()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_EID_SIGN_MODULE, gCmd.REQ_EID_SIGN_COMMON_SIGN, nil)
end
function eidSignCtrl:reqEidSignCommonSignRsp(content)
	dump(content, "eidSignCtrl:reqEidSignCommonSignRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData = content.rspdata.initData
		SoraDMailGainItems(content.rspdata.reward, true)
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_ACTIVITY_9001537_UPDATE"
		SoraDSendMessage(content.rspdata.reward)
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		content.rspdata.reward.eventID = self.activityID
		SoraDSendMessage(content.rspdata.reward)
	end
end
function eidSignCtrl:reqEidSignUseGoldSign(day)
	serverproxy = nil
	;(nil).day = day
	serverproxy:Request(gCmd.CMD_EID_SIGN_MODULE, gCmd.REQ_EID_SIGN_USE_GOLD_SIGN, nil)
end
function eidSignCtrl:reqEidSignUseGoldSignRsp(content)
	dump(content, "eidSignCtrl:reqEidSignUseGoldSignRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData = content.rspdata.initData
		SoraDMailGainItems(content.rspdata.reward, true)
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_ACTIVITY_9001537_UPDATE"
		SoraDSendMessage(content.rspdata.reward)
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		content.rspdata.reward.eventID = self.activityID
		SoraDSendMessage(content.rspdata.reward)
	end
end
function eidSignCtrl:reqEidSignGetExtra(day)
	serverproxy = nil
	;(nil).day = day
	serverproxy:Request(gCmd.CMD_EID_SIGN_MODULE, gCmd.REQ_EID_SIGN_GET_EXTRA, nil)
end
function eidSignCtrl:reqEidSignGetExtraRsp(content)
	dump(content, "eidSignCtrl:reqEidSignGetExtraRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData = content.rspdata.initData
		SoraDMailGainItems(content.rspdata.reward, true)
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_ACTIVITY_9001537_UPDATE"
		SoraDSendMessage(content.rspdata.reward)
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		content.rspdata.reward.eventID = self.activityID
		SoraDSendMessage(content.rspdata.reward)
	end
end
function eidSignCtrl:getStatusByDay(day)
	if day > self:getCurDay() then
		return gIceCrazyNightStatus.UNREACH
	elseif self:getCurDay() == day then
		if self:getRecordByDay(day) then
			return gIceCrazyNightStatus.RECEIVED
		else
			return gIceCrazyNightStatus.RECEIVE
		end
	elseif self:getRecordByDay(day) then
		return gIceCrazyNightStatus.RECEIVED
	end
	return 0
end
function eidSignCtrl:getExtraStatusByDay(day)
	if self:getExtraRecordByDay(day) then
		return gIceCrazyNightStatus.RECEIVED
	elseif day <= self:getTotalSignDay() then
		return gIceCrazyNightStatus.RECEIVE
	end
	return gIceCrazyNightStatus.UNREACH
end
function eidSignCtrl:getCurDay()
	return self.initData.curDay or 1
end
function eidSignCtrl:getRecordByDay(day)
	return self.initData.record and self.initData.record[tostring(day)]
end
function eidSignCtrl:getTotalSignDay()
	if self.initData.record then
		return table.nums(self.initData.record)
	end
	return 0
end
function eidSignCtrl:getShowIndex()
	local curDay = self:getCurDay()
	if not self:getRecordByDay(curDay) then
		return math.min(7, curDay)
	else
		for i = 1, 7 do
			if not self:getRecordByDay(i) then
				return i
			end
		end
	end
	return math.min(7, curDay)
end
function eidSignCtrl:getExtraRecordByDay(day)
	return self.initData.extraRecord and self.initData.extraRecord[tostring(day)]
end
function eidSignCtrl:getReceiveStatusAndNum()
	local num = 0
	for day = 1, self:getCurDay() do
		local status = self:getStatusByDay(day)
		if status == gIceCrazyNightStatus.RECEIVE or status == 0 then
			num = num + 1
		end
	end
	if self:getExtraStatusByDay(7) == gIceCrazyNightStatus.RECEIVE then
		num = num + 1
	end
	return 0 < num, -1
end
return eidSignCtrl

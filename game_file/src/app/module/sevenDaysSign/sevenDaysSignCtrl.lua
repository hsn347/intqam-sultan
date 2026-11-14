local GameModule = include("GameModule")
local sevenDaysSignCtrl = class("sevenDaysSignCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function sevenDaysSignCtrl:ctor(properties)
	sevenDaysSignCtrl.super.ctor(self, properties)
end
function sevenDaysSignCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_SEVEN_DAYS_SIGN_MODULE, gCmd.REQ_SEVEN_DAYS_SIGN_INFO, handler(self, self.sendReqInfoRsp))
	msgCtrl.register(gCmd.CMD_SEVEN_DAYS_SIGN_MODULE, gCmd.REQ_SLOT_LOTTERY, handler(self, self.sendReqSignRsp))
	self:resetData()
end
function sevenDaysSignCtrl:resetData()
	self.signData, _UPVALUE0_ = nil, nil
end
function sevenDaysSignCtrl:Logout()
	self:resetData()
	sevenDaysSignCtrl.super.Logout(self)
end
function sevenDaysSignCtrl:initClientData(data)
	self.signData = data
end
function sevenDaysSignCtrl:sendReqInfo()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_SEVEN_DAYS_SIGN_MODULE, gCmd.REQ_SEVEN_DAYS_SIGN_INFO, data)
end
function sevenDaysSignCtrl:sendReqSign()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_SEVEN_DAYS_SIGN_MODULE, gCmd.REQ_SLOT_LOTTERY, data)
end
function sevenDaysSignCtrl:getActivityDate(...)
	local startDate = self.signData.beginTime
	local totalDays = self:getTotalDays()
	local endDate = startDate + 86400 * totalDays - 1
	return startDate, endDate
end
function sevenDaysSignCtrl:getTotalDays(...)
	local nType = self.signData.nType
	if 1 == nType then
		return 7
	elseif 2 == nType then
		return 14
	else
		return 0
	end
end
function sevenDaysSignCtrl:checkHasSign(day)
	local signDays = self.signData.signDays
	if signDays and next(signDays) then
		for i, v in ipairs(signDays) do
			if v == day then
				return true
			end
		end
	end
	return false
end
function sevenDaysSignCtrl:getCurDay(...)
	local curTime = serviceFunctions.systemTime()
	local lastTime = self.signData.updateTime
	local day = #self.signData.signDays
	if lastTime == 0 then
		day = 1
	elseif not serviceFunctions.isSameDay(curTime, lastTime) then
		day = day + 1
	end
	return day
end
function sevenDaysSignCtrl:getSignType(...)
	return self.signData.nType
end
function sevenDaysSignCtrl:getRewardInfo(day)
	if self.signData.cfg and self.signData.cfg[tostring(day)] then
		return self.signData.cfg[tostring(day)]
	end
	_ENV = self.signData.cfg[tostring(day)]
	return self.signData.cfg[tostring(day)]
end
function sevenDaysSignCtrl:getReceiveStatusAndNum(...)
	if not self.signData or not next(self.signData) then
		return false, 0
	end
	if self:checkHasSign(self:getCurDay()) then
		return false, 0
	end
	return true, 1
end
function sevenDaysSignCtrl:sendReqInfoRsp(content)
	if gErrDef.Err_None == content.err then
		self.signData = content.data
		_ENV = content.err
		content.err.msg = "MESSAGE_SEVENDAYSSIGN_REQ_INFO_BACK"
		SoraDSendMessage(content.err)
	end
end
function sevenDaysSignCtrl:sendReqSignRsp(content)
	if gErrDef.Err_None == content.err then
		if content.data.signDays then
			self.signData.signDays = content.data.signDays
		end
		if content.data.updateTime then
			self.signData.updateTime = content.data.updateTime
		end
		_ENV = content.data.updateTime
		content.data.updateTime.msg = "MESSAGE_SEVENDAYSSIGN_SIGN_BACK"
		SoraDSendMessage(content.data.updateTime)
		_ENV = content.data.updateTime
		content.data.updateTime.msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		SoraDSendMessage(content.data.updateTime)
	end
end
return sevenDaysSignCtrl

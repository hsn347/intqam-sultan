local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local RamadanSign2023Ctrl = class("RamadanSign2023Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function RamadanSign2023Ctrl:ctor(properties)
	RamadanSign2023Ctrl.super.ctor(self, properties)
	self:resetData()
	self.activityID = gActivityTimeActivityID.RAMADAN_SIGN_2023_ACTIVITY
end
function RamadanSign2023Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_SIGN_REWARD_ACTIVITY_MODULE, gCmd.REQ_RAMADAN_SIGN_2023_ACTIVITY_INIT, handler(self, self.reqRamadanSign2023ActivityInitRsp))
	msgCtrl.register(gCmd.CMD_SIGN_REWARD_ACTIVITY_MODULE, gCmd.REQ_RAMADAN_SIGN_2023_ACTIVITY_SIGN, handler(self, self.reqRamadanSign2023ActivitySignRsp))
	msgCtrl.register(gCmd.CMD_SIGN_REWARD_ACTIVITY_MODULE, gCmd.REQ_RAMADAN_SIGN_2023_ACTIVITY_USE_GOLD_SIGN, handler(self, self.reqRamadanSign2023ActivityUseGoldSignRsp))
	msgCtrl.register(gCmd.CMD_SIGN_REWARD_ACTIVITY_MODULE, gCmd.REQ_RAMADAN_SIGN_2023_ACTIVITY_GET_EXTRA_REWARD, handler(self, self.reqRamadanSign2023ActivityGetExtraRewardRsp))
	self:registerNotify()
end
function RamadanSign2023Ctrl:Logout()
	RamadanSign2023Ctrl.super.Logout(self)
	self:resetData()
end
function RamadanSign2023Ctrl:resetData()
	self.handle_notify = nil
	self.curDay = nil
	self.useGoldDay = nil
	self.totalDay = nil
	self.extraRewardInfo, _UPVALUE0_, self.signInfo, _UPVALUE0_, self.totalSignDay = nil, nil, nil, nil, nil
	self.classType = 1
end
function RamadanSign2023Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.SIGN_REWARD_ACTIVITY, handler(self, self.notifyHandler))
end
function RamadanSign2023Ctrl:notifyHandler(event)
	local content = event.data[1]
	if content.activityID ~= self.activityID then
		return
	end
	dump(content, "RamadanSign2023Ctrl:notifyHandler")
	if content and content.curDay then
		self.curDay = content.curDay
		self.totalDay = content.totalDay
		self.totalSignDay = content.totalSignDay
		self.useGoldDay = content.useGoldDay
		self.signInfo = content.signInfo
		self.extraRewardInfo = content.extraRewardInfo
		_ENV = content
		content.msg = "MESSAGE_RAMADAN_2023_SIGN"
		content.subMsg = "init"
		SoraDSendMessage(content)
		_ENV = content
		content.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		content.eventID = self.activityID
		SoraDSendMessage(content)
	end
end
function RamadanSign2023Ctrl:sendReqInitDataMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_SIGN_REWARD_ACTIVITY_MODULE, gCmd.REQ_RAMADAN_SIGN_2023_ACTIVITY_INIT, nil)
end
function RamadanSign2023Ctrl:reqRamadanSign2023ActivityInitRsp(content)
	dump(content, "RamadanSign2023Ctrl:reqRamadanSign2023ActivityInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local data = content.data
		if data then
			self.totalDay = data.totalDay
			self.curDay = data.curDay
			self.totalSignDay = data.totalSignDay
			self.useGoldDay = data.useGoldDay
			self.signInfo = data.signInfo
			self.classType = data.classType
			self.extraRewardInfo = data.extraRewardInfo
		end
		_ENV = "RamadanSign2023Ctrl:reqRamadanSign2023ActivityInitRsp(content)"
		;("RamadanSign2023Ctrl:reqRamadanSign2023ActivityInitRsp(content)").msg = "MESSAGE_RAMADAN_2023_SIGN"
		;("RamadanSign2023Ctrl:reqRamadanSign2023ActivityInitRsp(content)").subMsg = "init"
		SoraDSendMessage("RamadanSign2023Ctrl:reqRamadanSign2023ActivityInitRsp(content)")
		_ENV = "RamadanSign2023Ctrl:reqRamadanSign2023ActivityInitRsp(content)"
		;("RamadanSign2023Ctrl:reqRamadanSign2023ActivityInitRsp(content)").msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		;("RamadanSign2023Ctrl:reqRamadanSign2023ActivityInitRsp(content)").eventID = self.activityID
		SoraDSendMessage("RamadanSign2023Ctrl:reqRamadanSign2023ActivityInitRsp(content)")
	end
end
function RamadanSign2023Ctrl:reqRamadanSign2023ActivitySign()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_SIGN_REWARD_ACTIVITY_MODULE, gCmd.REQ_RAMADAN_SIGN_2023_ACTIVITY_SIGN, nil)
end
function RamadanSign2023Ctrl:reqRamadanSign2023ActivitySignRsp(content)
	dump(content, "RamadanSign2023Ctrl:reqRamadanSign2023ActivitySignRsp(content)", 10)
	if content.err == gErrDef.Err_None and content.data then
		local data = content.data
		self.signInfo = data.signInfo
		self.extraRewardInfo = data.extraRewardInfo
		self.totalSignDay = data.totalSignDay
		SoraDMailGainItems(data.items, true)
		_ENV = data.items
		data.items.msg = "MESSAGE_RAMADAN_2023_SIGN"
		data.items.subMsg = "sign"
		data.items.blockDay = data.day
		SoraDSendMessage(data.items)
		_ENV = data.items
		data.items.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		data.items.eventID = self.activityID
		SoraDSendMessage(data.items)
	end
end
function RamadanSign2023Ctrl:reqRamadanSign2023ActivityUseGoldSign(signDay)
	serverproxy = nil
	;(nil).signDay = signDay
	serverproxy:Request(gCmd.CMD_SIGN_REWARD_ACTIVITY_MODULE, gCmd.REQ_RAMADAN_SIGN_2023_ACTIVITY_USE_GOLD_SIGN, nil)
end
function RamadanSign2023Ctrl:reqRamadanSign2023ActivityUseGoldSignRsp(content)
	dump(content, "RamadanSign2023Ctrl:reqRamadanSign2023ActivityUseGoldSignRsp(content)", 10)
	if content.err == gErrDef.Err_None and content.data then
		local data = content.data
		self.signInfo = data.signInfo
		self.extraRewardInfo = data.extraRewardInfo
		self.useGoldDay = data.useGoldDay
		self.totalSignDay = data.totalSignDay
		SoraDMailGainItems(data.items, true)
		_ENV = data.items
		data.items.msg = "MESSAGE_RAMADAN_2023_SIGN"
		data.items.subMsg = "sign"
		data.items.blockDay = data.day
		SoraDSendMessage(data.items)
		_ENV = data.items
		data.items.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		data.items.eventID = self.activityID
		SoraDSendMessage(data.items)
	end
end
function RamadanSign2023Ctrl:reqRamadanSign2023ActivityGetExtraReward(extraDay)
	serverproxy = nil
	;(nil).extraDay = extraDay
	serverproxy:Request(gCmd.CMD_SIGN_REWARD_ACTIVITY_MODULE, gCmd.REQ_RAMADAN_SIGN_2023_ACTIVITY_GET_EXTRA_REWARD, nil)
end
function RamadanSign2023Ctrl:reqRamadanSign2023ActivityGetExtraRewardRsp(content)
	dump(content, "RamadanSign2023Ctrl:reqRamadanSign2023ActivityGetExtraRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None and content.data then
		if content.data.day then
			self.extraRewardInfo[tostring(content.data.day)] = gSignRewardStatus.ALREADY_RECEIVE
		end
		SoraDMailGainItems(content.data.items, true)
		_ENV = content.data.items
		content.data.items.msg = "MESSAGE_RAMADAN_2023_SIGN"
		content.data.items.subMsg = "extra"
		SoraDSendMessage(content.data.items)
		_ENV = content.data.items
		content.data.items.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		content.data.items.eventID = self.activityID
		SoraDSendMessage(content.data.items)
	end
end
function RamadanSign2023Ctrl:getTotalDay()
	return math.min(35, self.totalDay)
end
function RamadanSign2023Ctrl:getCurDay()
	return self.curDay
end
function RamadanSign2023Ctrl:getTotalSignDay()
	return self.totalSignDay
end
function RamadanSign2023Ctrl:getUseGoldDay()
	return self.useGoldDay
end
function RamadanSign2023Ctrl:getSignTypeByDay(day)
	local ret = gSignRewardType.NO_SIGN
	if self.signInfo and self.signInfo[tostring(day)] then
		ret = self.signInfo[tostring(day)]
	end
	return ret
end
function RamadanSign2023Ctrl:getExtraRewardType(day)
	if not self.extraRewardInfo then
		_ENV = self.extraRewardInfo
	end
	self.extraRewardInfo = self.extraRewardInfo
	if day <= self.totalSignDay and self.extraRewardInfo[tostring(day)] == "1" then
		return 3
	elseif day <= self.totalSignDay then
		return 2
	end
	return 1
end
function RamadanSign2023Ctrl:isCanReceive()
	if SoraDGetCastleLv() < CASTLE_LV6_LIMITED then
		return false, -1
	end
	local retNum = 0
	if self.curDay and self:getSignTypeByDay(self.curDay) == gSignRewardType.NO_SIGN then
		retNum = retNum + 1
	end
	if self.extraRewardInfo and next(self.extraRewardInfo) then
		for i, v in pairs(self.extraRewardInfo) do
			if v == gSignRewardStatus.CAN_RECEIVE then
				retNum = retNum + 1
			end
		end
	end
	return 0 < retNum, -1
end
function RamadanSign2023Ctrl:getReceiveStatusAndNum()
	return self:isCanReceive()
end
function RamadanSign2023Ctrl:getClassType()
	return self.classType
end
return RamadanSign2023Ctrl

local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local snowmanGiftCtrl = class("snowmanGiftCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function snowmanGiftCtrl:ctor(properties)
	snowmanGiftCtrl.super.ctor(self, properties)
	self:resetData()
end
function snowmanGiftCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_SIGN_REWARD_ACTIVITY_MODULE, gCmd.REQ_SNOW_MAN_GIFT_ACTIVITY_INIT, handler(self, self.reqSnowManGiftActivityInitRsp))
	msgCtrl.register(gCmd.CMD_SIGN_REWARD_ACTIVITY_MODULE, gCmd.REQ_SNOW_MAN_GIFT_ACTIVITY_SIGN, handler(self, self.reqSnowManGiftActivitySignRsp))
	msgCtrl.register(gCmd.CMD_SIGN_REWARD_ACTIVITY_MODULE, gCmd.REQ_SNOW_MAN_GIFT_ACTIVITY_USE_GOLD_SIGN, handler(self, self.reqSnowManGiftActivityUseGoldSignRsp))
	msgCtrl.register(gCmd.CMD_SIGN_REWARD_ACTIVITY_MODULE, gCmd.REQ_SNOW_MAN_GIFT_ACTIVITY_GET_EXTRA_REWARD, handler(self, self.reqSnowManGiftActivityGetExtraRewardRsp))
	self:registerNotify()
end
function snowmanGiftCtrl:Logout()
	snowmanGiftCtrl.super.Logout(self)
	self:resetData()
end
function snowmanGiftCtrl:resetData()
	self.curDay = 1
	self.useGoldDay = 0
	self.totalDay = 0
	self.extraRewardInfo, _UPVALUE0_, self.signInfo, _UPVALUE0_, self.totalSignDay = nil, nil, nil, nil, 0
end
function snowmanGiftCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.SIGN_REWARD_ACTIVITY, handler(self, self.notifyHandler))
end
function snowmanGiftCtrl:notifyHandler(event)
	local content = event.data[1]
	if content.activityID ~= gActivityTimeActivityID.SNOW_MAN_GIFT_ACTIVITY then
		return
	end
	dump(event.data, "snowmanGiftCtrl:notifyHandler", 10)
	if content then
		if content.curDay then
			self.curDay = content.curDay
		end
		if content.totalDay then
			self.totalDay = content.totalDay
		end
		if content.totalSignDay then
			self.totalSignDay = content.totalSignDay
		end
		if content.useGoldDay then
			self.useGoldDay = content.useGoldDay
		end
		if content.signInfo then
			self.signInfo = content.signInfo
		end
		if content.extraRewardInfo then
			self.extraRewardInfo = content.extraRewardInfo
		end
	end
	_ENV = event.data
	event.data.msg = "MESSAGE_SNOWMAN_GIFT_SIGN"
	event.data.subMsg = "init"
	SoraDSendMessage(event.data)
	_ENV = event.data
	event.data.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	event.data.eventID = gActivityTimeActivityID.SNOW_MAN_GIFT_ACTIVITY
	SoraDSendMessage(event.data)
end
function snowmanGiftCtrl:sendReqInitDataMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_SIGN_REWARD_ACTIVITY_MODULE, gCmd.REQ_SNOW_MAN_GIFT_ACTIVITY_INIT, nil)
end
function snowmanGiftCtrl:reqSnowManGiftActivitySign()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_SIGN_REWARD_ACTIVITY_MODULE, gCmd.REQ_SNOW_MAN_GIFT_ACTIVITY_SIGN, nil)
end
function snowmanGiftCtrl:reqSnowManGiftActivityUseGoldSign(signDay)
	serverproxy = nil
	;(nil).signDay = signDay
	serverproxy:Request(gCmd.CMD_SIGN_REWARD_ACTIVITY_MODULE, gCmd.REQ_SNOW_MAN_GIFT_ACTIVITY_USE_GOLD_SIGN, nil)
end
function snowmanGiftCtrl:reqSnowManGiftActivityGetExtraReward(extraDay)
	serverproxy = nil
	;(nil).extraDay = extraDay
	serverproxy:Request(gCmd.CMD_SIGN_REWARD_ACTIVITY_MODULE, gCmd.REQ_SNOW_MAN_GIFT_ACTIVITY_GET_EXTRA_REWARD, nil)
end
function snowmanGiftCtrl:reqSnowManGiftActivityInitRsp(content)
	dump(content, "snowmanGiftCtrl:reqSnowManGiftActivityInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local data = content.data
		if data then
			self.totalDay = data.totalDay
			self.curDay = data.curDay
			self.totalSignDay = data.totalSignDay
			self.useGoldDay = data.useGoldDay
			self.signInfo = data.signInfo
			self.extraRewardInfo = data.extraRewardInfo
		end
		_ENV = "snowmanGiftCtrl:reqSnowManGiftActivityInitRsp(content)"
		;("snowmanGiftCtrl:reqSnowManGiftActivityInitRsp(content)").msg = "MESSAGE_SNOWMAN_GIFT_SIGN"
		;("snowmanGiftCtrl:reqSnowManGiftActivityInitRsp(content)").subMsg = "init"
		SoraDSendMessage("snowmanGiftCtrl:reqSnowManGiftActivityInitRsp(content)")
	end
end
function snowmanGiftCtrl:reqSnowManGiftActivitySignRsp(content)
	dump(content, "snowmanGiftCtrl:reqSnowManGiftActivitySignRsp(content)", 10)
	if content.err == gErrDef.Err_None and content.data then
		local data = content.data
		self.signInfo = data.signInfo
		self.extraRewardInfo = data.extraRewardInfo
		self.totalSignDay = data.totalSignDay
		SoraDMailGainItems(data.items, true)
		_ENV = data.items
		data.items.msg = "MESSAGE_SNOWMAN_GIFT_SIGN"
		data.items.subMsg = "sign"
		data.items.blockDay = data.day
		SoraDSendMessage(data.items)
	end
end
function snowmanGiftCtrl:reqSnowManGiftActivityUseGoldSignRsp(content)
	dump(content, "snowmanGiftCtrl:reqSnowManGiftActivityUseGoldSignRsp(content)", 10)
	if content.err == gErrDef.Err_None and content.data then
		local data = content.data
		self.signInfo = data.signInfo
		self.extraRewardInfo = data.extraRewardInfo
		self.useGoldDay = data.useGoldDay
		self.totalSignDay = data.totalSignDay
		SoraDMailGainItems(data.items, true)
		_ENV = data.items
		data.items.msg = "MESSAGE_SNOWMAN_GIFT_SIGN"
		data.items.subMsg = "sign"
		data.items.blockDay = data.day
		SoraDSendMessage(data.items)
	end
end
function snowmanGiftCtrl:reqSnowManGiftActivityGetExtraRewardRsp(content)
	dump(content, "snowmanGiftCtrl:reqSnowManGiftActivityGetExtraRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None and content.data then
		if content.data.day then
			self.extraRewardInfo[tostring(content.data.day)] = gSignRewardStatus.ALREADY_RECEIVE
		end
		SoraDMailGainItems(content.data.items, true)
		_ENV = content.data.items
		content.data.items.msg = "MESSAGE_SNOWMAN_GIFT_SIGN"
		content.data.items.subMsg = "extra"
		SoraDSendMessage(content.data.items)
	end
end
function snowmanGiftCtrl:getTotalDay()
	return math.min(7, self.totalDay)
end
function snowmanGiftCtrl:getCurDay()
	return self.curDay
end
function snowmanGiftCtrl:getTotalSignDay()
	return self.totalSignDay
end
function snowmanGiftCtrl:getDayStatueByDay(day)
	if self.signInfo and self.signInfo[tostring(day)] then
		local status = tonumber(self.signInfo[tostring(day)])
		if 0 < status then
			return 2
		end
	end
	if day == self.curDay then
		return 0
	elseif day < self.curDay then
		return 3
	end
	return 1
end
function snowmanGiftCtrl:getSignTypeByDay(day)
	local ret = gSignRewardType.NO_SIGN
	if self.signInfo and self.signInfo[tostring(day)] then
		ret = self.signInfo[tostring(day)]
	end
	return ret
end
function snowmanGiftCtrl:getExtraRewardStatue(day)
	if not self.extraRewardInfo then
		_ENV = self.extraRewardInfo
	end
	self.extraRewardInfo = self.extraRewardInfo
	if day <= self.totalSignDay and self.extraRewardInfo[tostring(day)] == gSignRewardStatus.CAN_RECEIVE then
		return 0
	elseif day <= self.totalSignDay then
		return 2
	end
	return 1
end
function snowmanGiftCtrl:getReceiveStatusAndNum()
	local retNum = 0
	if self.curDay and self.curDay <= 7 and self:getSignTypeByDay(self.curDay) == gSignRewardType.NO_SIGN then
		retNum = retNum + 1
	end
	print(self.curDay, "snowmanGiftCtrl", retNum)
	if self.extraRewardInfo and next(self.extraRewardInfo) then
		for i, v in pairs(self.extraRewardInfo) do
			if v == gSignRewardStatus.CAN_RECEIVE then
				retNum = retNum + 1
			end
		end
	end
	return 0 < retNum, -1
end
return snowmanGiftCtrl

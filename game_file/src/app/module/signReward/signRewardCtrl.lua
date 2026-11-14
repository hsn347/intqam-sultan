local GameModule = include("GameModule")
local signRewardCtrl = class("signRewardCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local signRewadRead = include("signRewadRead")
function signRewardCtrl:ctor(properties)
	signRewardCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.SIGN_REWARD_ACTIVITY
	self:resetData()
end
function signRewardCtrl:Logout()
	signRewardCtrl.super.Logout(self)
	self:resetData()
end
function signRewardCtrl:resetData()
	self.handle_notify = nil
	self.curDay = nil
	self.useGoldDay = nil
	self.totalDay = nil
	self.extraRewardInfo, _UPVALUE0_, self.signInfo, _UPVALUE0_, self.totalSignDay = nil, nil, nil, nil, nil
end
function signRewardCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_SIGN_REWARD_ACTIVITY_MODULE, gCmd.REQ_SIGN_REWARD_ACTIVITY_INIT, handler(self, self.getInitResp))
	msgCtrl.register(gCmd.CMD_SIGN_REWARD_ACTIVITY_MODULE, gCmd.REQ_SIGN_REWARD_ACTIVITY_SIGN, handler(self, self.getSignResp))
	msgCtrl.register(gCmd.CMD_SIGN_REWARD_ACTIVITY_MODULE, gCmd.REQ_SIGN_REWARD_ACTIVITY_USE_GOLD_SIGN, handler(self, self.getGoldSignResp))
	msgCtrl.register(gCmd.CMD_SIGN_REWARD_ACTIVITY_MODULE, gCmd.REQ_SIGN_REWARD_ACTIVITY_GET_EXTRA_REWARD, handler(self, self.getExtraRewardResp))
	self:initLocalData()
	self:registerNotify()
end
function signRewardCtrl:initLocalData()
	local classType = SoraDGetCtrl("activityShowCtrl"):getParamClassType(self.activityID)
	self.localGoldInfo = signRewadRead.getGoldInfo()
	self.localRewardConfig = signRewadRead.getRewardConfig(classType)
	self.localCumuDayArray = signRewadRead.getCumuDayArray(classType)
end
function signRewardCtrl:initClientData(data)
	if not data then
		return
	end
	dump(data, "signRewardCtrl:initClientData", 10)
	self.totalDay = data.totalDay
	self.curDay = data.curDay
	self.totalSignDay = data.totalSignDay
	self.useGoldDay = data.useGoldDay
	self.signInfo = data.signInfo
	self.extraRewardInfo = data.extraRewardInfo
end
function signRewardCtrl:getChangeExtraAwardDay(beforeDay, afterDay)
	if beforeDay and afterDay and self.localCumuDayArray then
		for i, value in pairs(self.localCumuDayArray) do
			if value == afterDay and beforeDay < value then
				return value
			end
		end
	end
end
function signRewardCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.SIGN_REWARD_ACTIVITY, handler(self, self.notifyHandler))
end
function signRewardCtrl:notifyHandler(event)
	dump(event, "signRewardCtrl:notifyHandler==========", 10)
	local content = event.data[1]
	if content.activityID ~= self.activityID then
		return
	end
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
	_ENV = self.activityID
	self.activityID.msg = "MESSAGE_SERVER_EVENTCENTER_SIGNREWARD_EVENTCHANGE"
	SoraDSendMessage(self.activityID)
	_ENV = self.activityID
	self.activityID.msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
	SoraDSendMessage(self.activityID)
	_ENV = self.activityID
	self.activityID.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	self.activityID.eventID = self.activityID
	SoraDSendMessage(self.activityID)
end
function signRewardCtrl:sendReqInitDataMsg()
	serverproxy:Request(gCmd.CMD_SIGN_REWARD_ACTIVITY_MODULE, gCmd.REQ_SIGN_REWARD_ACTIVITY_INIT)
end
function signRewardCtrl:sendSignMsg()
	serverproxy:Request(gCmd.CMD_SIGN_REWARD_ACTIVITY_MODULE, gCmd.REQ_SIGN_REWARD_ACTIVITY_SIGN)
end
function signRewardCtrl:sendUseGoldSignMsg(signDay)
	local serverproxy, data
	data.signDay = signDay
	serverproxy:Request(gCmd.CMD_SIGN_REWARD_ACTIVITY_MODULE, gCmd.REQ_SIGN_REWARD_ACTIVITY_USE_GOLD_SIGN, data)
end
function signRewardCtrl:sendGetExtraRewardMsg(extraDay)
	local serverproxy, data
	data.extraDay = extraDay
	serverproxy:Request(gCmd.CMD_SIGN_REWARD_ACTIVITY_MODULE, gCmd.REQ_SIGN_REWARD_ACTIVITY_GET_EXTRA_REWARD, data)
end
function signRewardCtrl:getInitResp(content)
	dump(content, "signRewardCtrl:getInitResp")
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
	end
end
function signRewardCtrl:getSignResp(content)
	dump(content, "signRewardCtrl:getSignResp", 5)
	if content.err == gErrDef.Err_None then
		if content.data then
			local items = content.data.items
			local beforeDay = self.totalSignDay
			local day = content.data.day
			if content.data.signInfo then
				self.signInfo = content.data.signInfo
			end
			if content.data.extraRewardInfo then
				self.extraRewardInfo = content.data.extraRewardInfo
			end
			if content.data.totalSignDay then
				self.totalSignDay = content.data.totalSignDay
			end
			if content.data.items then
				SoraDMailGainItems(content.data.items, true)
			end
			local changeDay = self:getChangeExtraAwardDay(beforeDay, self.totalSignDay)
			if changeDay then
				_ENV = beforeDay
				beforeDay.msg = "MESSAGE_SERVER_EVENTCENTER_SIGNREWARD_LAMPREFRESH"
				beforeDay.lampDay = changeDay
				SoraDSendMessage(beforeDay)
			end
			_ENV = beforeDay
			beforeDay.msg = "MESSAGE_SERVER_EVENTCENTER_SIGNREWARD_BLOCKREFRESH"
			beforeDay.blockDay = day
			beforeDay.itemList = items
			SoraDSendMessage(beforeDay)
			_ENV = beforeDay
			beforeDay.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
			beforeDay.eventID = self.activityID
			SoraDSendMessage(beforeDay)
		end
	elseif content.err == gErrDef.Err_SIGN_REWARD_NOT_OPEN then
	elseif content.err == gErrDef.Err_SIGN_REWARD_BEFORE_NOT_SIGN then
	elseif content.err == gErrDef.Err_SIGN_REWARD_ALREADY_SIGN then
	elseif content.err == gErrDef.Err_BACKPACK_IS_FULL then
	end
end
function signRewardCtrl:getGoldSignResp(content)
	dump(content, "signRewardCtrl:getUseGoldSignResp", 5)
	if content.err == gErrDef.Err_None then
		if content.data then
			local items = content.data.items
			local beforeDay = self.totalSignDay
			local day = content.data.day
			if content.data.signInfo then
				self.signInfo = content.data.signInfo
			end
			if content.data.extraRewardInfo then
				self.extraRewardInfo = content.data.extraRewardInfo
			end
			if content.data.useGoldDay then
				self.useGoldDay = content.data.useGoldDay
			end
			if content.data.totalSignDay then
				self.totalSignDay = content.data.totalSignDay
			end
			if content.data.items then
				SoraDMailGainItems(content.data.items, true)
			end
			local changeDay = self:getChangeExtraAwardDay(beforeDay, self.totalSignDay)
			if changeDay then
				_ENV = beforeDay
				beforeDay.msg = "MESSAGE_SERVER_EVENTCENTER_SIGNREWARD_LAMPREFRESH"
				beforeDay.lampDay = changeDay
				SoraDSendMessage(beforeDay)
			end
			_ENV = beforeDay
			beforeDay.msg = "MESSAGE_SERVER_EVENTCENTER_SIGNREWARD_BLOCKREFRESH"
			beforeDay.blockDay = day
			beforeDay.itemList = items
			SoraDSendMessage(beforeDay)
			_ENV = beforeDay
			beforeDay.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
			beforeDay.eventID = self.activityID
			SoraDSendMessage(beforeDay)
		end
	elseif content.err == gErrDef.Err_SIGN_REWARD_NOT_OPEN then
	elseif content.err == gErrDef.Err_SIGN_REWARD_ALREADY_SIGN then
	elseif content.err == gErrDef.Err_SIGN_REWARD_ILLEGAL_DAY then
	elseif content.err == gErrDef.Err_BACKPACK_IS_FULL then
	elseif content.err == gErrDef.Err_SIGN_REWARD_GOLD_NOT_ENOUGH then
	end
end
function signRewardCtrl:getExtraRewardResp(content)
	if content.err == gErrDef.Err_None then
		if not self.extraRewardInfo then
			_ENV = self.extraRewardInfo
		end
		self.extraRewardInfo = self.extraRewardInfo
		if content.data then
			local day = content.data.day
			if day then
				self.extraRewardInfo[tostring(day)] = gSignRewardStatus.ALREADY_RECEIVE
			end
			if content.data.items then
				SoraDMailGainItems(content.data.items, true)
			end
			_ENV = content.data.items
			content.data.items.msg = "MESSAGE_SERVER_EVENTCENTER_SIGNREWARD_LAMPREFRESH"
			content.data.items.lampDay = day
			content.data.items.itemList = content.data.items
			SoraDSendMessage(content.data.items)
			_ENV = content.data.items
			content.data.items.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
			content.data.items.eventID = self.activityID
			SoraDSendMessage(content.data.items)
		end
	elseif content.err == gErrDef.Err_SIGN_REWARD_NOT_OPEN then
	elseif content.err == gErrDef.Err_SIGN_REWARD_GOLD_NO_REWARD then
	elseif content.err == gErrDef.Err_SIGN_REWARD_DAY_NOT_ENOUGH then
	elseif content.err == gErrDef.Err_SIGN_REWARD_GOLD_ALREADY_RECEIVE then
	elseif content.err == gErrDef.Err_BACKPACK_IS_FULL then
	end
end
function signRewardCtrl:getTotalDay()
	return self.totalDay
end
function signRewardCtrl:getCurDay()
	return self.curDay
end
function signRewardCtrl:getTotalSignDay()
	return self.totalSignDay
end
function signRewardCtrl:getUseGoldDay()
	return self.useGoldDay
end
function signRewardCtrl:getCostGold()
	local time = self:getUseGoldDay() + 1
	local gold = 0
	if self.localGoldInfo[time] then
		gold = self.localGoldInfo[time].price
	end
	return gold
end
function signRewardCtrl:getAwardByDay(day)
	local _ENV, ret
	local nDay = tonumber(day)
	if nDay and self.localRewardConfig[nDay] then
		ret, _ENV = self.localRewardConfig[nDay].normalReward, self.localRewardConfig[nDay].normalReward
		ret = self.localRewardConfig[nDay].normalReward or nil
	end
	return ret
end
function signRewardCtrl:getSignTypeByDay(day)
	local ret = gSignRewardType.NO_SIGN
	if self.signInfo and self.signInfo[tostring(day)] then
		ret = self.signInfo[tostring(day)]
	end
	return ret
end
function signRewardCtrl:getRewardConfig()
	return self.localRewardConfig
end
function signRewardCtrl:getCumuDayArray()
	return self.localCumuDayArray
end
function signRewardCtrl:getExtraAwardByDay(day)
	local _ENV, ret
	local nDay = tonumber(day)
	if nDay and self.localRewardConfig[nDay] then
		ret, _ENV = self.localRewardConfig[nDay].cumulateReward, self.localRewardConfig[nDay].cumulateReward
		ret = self.localRewardConfig[nDay].cumulateReward or nil
	end
	return ret
end
function signRewardCtrl:getExtraRewardInfoByDay(day)
	if not self.extraRewardInfo then
		_ENV = self.extraRewardInfo
	end
	self.extraRewardInfo = self.extraRewardInfo
	return self.extraRewardInfo[tostring(day)]
end
function signRewardCtrl:isCanReceive()
	if SoraDGetCastleLv() < CASTLE_LV6_LIMITED then
		ret = false
		return ret, 0
	end
	local ret = false
	local retNum = 0
	if self.curDay and self:getSignTypeByDay(self.curDay) == gSignRewardType.NO_SIGN then
		ret = true
		retNum = retNum + 1
	end
	for k, day in pairs(self.localCumuDayArray) do
		if self:getExtraRewardInfoByDay(day) == gSignRewardStatus.CAN_RECEIVE then
			ret = true
			retNum = retNum + 1
		end
	end
	return ret, retNum
end
function signRewardCtrl:getReceiveStatusAndNum()
	return self:isCanReceive()
end
function signRewardCtrl:dump()
	print("self.curDay", self.curDay)
	print("self.useGoldDay", self.useGoldDay)
	print("self.totalDay", self.totalDay)
	print("self.totalSignDay", self.totalSignDay)
end
return signRewardCtrl

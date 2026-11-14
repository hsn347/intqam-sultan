local GameModule = include("GameModule")
local signReward2022Ctrl = class("signReward2022Ctrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function signReward2022Ctrl:ctor(properties)
	signReward2022Ctrl.super.ctor(self, properties)
	self:resetData()
end
function signReward2022Ctrl:Logout()
	signReward2022Ctrl.super.Logout(self)
	self:resetData()
end
function signReward2022Ctrl:resetData()
	self.handle_notify = nil
	self.curDay = nil
	self.useGoldDay = nil
	self.totalDay = nil
	self.totalSignDay = nil
	self.extraRewardInfo, _UPVALUE0_, self.signInfo, _UPVALUE0_, self.refreshLv = nil, nil, nil, nil, 1
end
function signReward2022Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_SIGN_REWARD_ACTIVITY_MODULE, gCmd.REQ_SIGN_REWARD_2022_ACTIVITY_INIT, handler(self, self.getInitResp))
	msgCtrl.register(gCmd.CMD_SIGN_REWARD_ACTIVITY_MODULE, gCmd.REQ_SIGN_REWARD_2022_ACTIVITY_SIGN, handler(self, self.getSignResp))
	msgCtrl.register(gCmd.CMD_SIGN_REWARD_ACTIVITY_MODULE, gCmd.REQ_SIGN_REWARD_2022_ACTIVITY_USE_GOLD_SIGN, handler(self, self.getGoldSignResp))
	msgCtrl.register(gCmd.CMD_SIGN_REWARD_ACTIVITY_MODULE, gCmd.REQ_SIGN_REWARD_2022_ACTIVITY_GET_EXTRA_REWARD, handler(self, self.getExtraRewardResp))
end
function signReward2022Ctrl:initClientData(data)
	if not data then
		return
	end
	dump(data, "signReward2022Ctrl:initClientData", 10)
	self.totalDay = data.totalDay
	self.curDay = data.curDay
	self.totalSignDay = data.totalSignDay
	self.useGoldDay = data.useGoldDay
	self.refreshLv = data.refreshLv or SoraDGetCastleLv()
	self.signInfo = data.signInfo
	self.extraRewardInfo = data.extraRewardInfo
	self:registerNotify()
end
function signReward2022Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.SIGN_REWARD_ACTIVITY, handler(self, self.notifyHandler))
end
function signReward2022Ctrl:notifyHandler(event)
	local content = event.data[1]
	if content.activityID ~= gActivityTimeActivityID.SIGN_REWARD_2022_ACTIVITY then
		return
	end
	if content then
		dump(content, "signReward2022Ctrl:notifyHandler", 5)
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
		if content.refreshLv then
			self.refreshLv = content.refreshLv
		end
	end
	_ENV = content
	content.msg = "MESSAGE_SIGNREWARD_2022_UPDATE"
	SoraDSendMessage(content)
end
function signReward2022Ctrl:sendInitMsg()
	serverproxy:Request(gCmd.CMD_SIGN_REWARD_ACTIVITY_MODULE, gCmd.REQ_SIGN_REWARD_2022_ACTIVITY_INIT)
end
function signReward2022Ctrl:sendSignMsg()
	serverproxy:Request(gCmd.CMD_SIGN_REWARD_ACTIVITY_MODULE, gCmd.REQ_SIGN_REWARD_2022_ACTIVITY_SIGN)
end
function signReward2022Ctrl:sendUseGoldSignMsg(signDay)
	local serverproxy, data
	data.signDay = signDay
	serverproxy:Request(gCmd.CMD_SIGN_REWARD_ACTIVITY_MODULE, gCmd.REQ_SIGN_REWARD_2022_ACTIVITY_USE_GOLD_SIGN, data)
end
function signReward2022Ctrl:sendGetExtraRewardMsg(extraDay)
	local serverproxy, data
	data.extraDay = extraDay
	serverproxy:Request(gCmd.CMD_SIGN_REWARD_ACTIVITY_MODULE, gCmd.REQ_SIGN_REWARD_2022_ACTIVITY_GET_EXTRA_REWARD, data)
end
function signReward2022Ctrl:getInitResp(content)
	dump(content, "signReward2022Ctrl:getInitResp")
	if content.err == gErrDef.Err_None then
		local data = content.data
		if data then
			self.totalDay = data.totalDay
			self.curDay = data.curDay
			self.totalSignDay = data.totalSignDay
			self.useGoldDay = data.useGoldDay
			self.refreshLv = data.refreshLv or SoraDGetCastleLv()
			self.signInfo = data.signInfo
			self.extraRewardInfo = data.extraRewardInfo
		end
	end
end
function signReward2022Ctrl:getSignResp(content)
	dump(content, "signReward2022Ctrl:getSignResp", 5)
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
			SoraDMailGainItems(items, true)
		end
	elseif content.err == gErrDef.Err_SIGN_REWARD_NOT_OPEN then
	elseif content.err == gErrDef.Err_SIGN_REWARD_BEFORE_NOT_SIGN then
	elseif content.err == gErrDef.Err_SIGN_REWARD_ALREADY_SIGN then
		SoraDShowMsgTip(i18n("common_text_4608"))
	end
	_ENV = i18n("common_text_4608")
	i18n("common_text_4608").msg = "MESSAGE_SIGNREWARD_2022_UPDATE"
	SoraDSendMessage(i18n("common_text_4608"))
end
function signReward2022Ctrl:getGoldSignResp(content)
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
			SoraDMailGainItems(items, true)
		end
	elseif content.err == gErrDef.Err_SIGN_REWARD_NOT_OPEN then
	elseif content.err == gErrDef.Err_SIGN_REWARD_ALREADY_SIGN then
	elseif content.err == gErrDef.Err_SIGN_REWARD_ILLEGAL_DAY then
	elseif content.err == gErrDef.Err_BACKPACK_IS_FULL then
	elseif content.err == gErrDef.Err_SIGN_REWARD_GOLD_NOT_ENOUGH then
	end
	_ENV = gErrDef.Err_SIGN_REWARD_GOLD_NOT_ENOUGH
	gErrDef.Err_SIGN_REWARD_GOLD_NOT_ENOUGH.msg = "MESSAGE_SIGNREWARD_2022_UPDATE"
	SoraDSendMessage(gErrDef.Err_SIGN_REWARD_GOLD_NOT_ENOUGH)
end
function signReward2022Ctrl:getExtraRewardResp(content)
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
			local items = content.data.items
			SoraDMailGainItems(items, true)
		end
	elseif content.err == gErrDef.Err_SIGN_REWARD_NOT_OPEN then
	elseif content.err == gErrDef.Err_SIGN_REWARD_GOLD_NO_REWARD then
	elseif content.err == gErrDef.Err_SIGN_REWARD_DAY_NOT_ENOUGH then
	elseif content.err == gErrDef.Err_SIGN_REWARD_GOLD_ALREADY_RECEIVE then
	elseif content.err == gErrDef.Err_BACKPACK_IS_FULL then
	end
	_ENV = gErrDef.Err_BACKPACK_IS_FULL
	gErrDef.Err_BACKPACK_IS_FULL.msg = "MESSAGE_SIGNREWARD_2022_UPDATE"
	SoraDSendMessage(gErrDef.Err_BACKPACK_IS_FULL)
end
function signReward2022Ctrl:getTotalDay()
	return self.totalDay
end
function signReward2022Ctrl:getCurDay()
	return self.curDay
end
function signReward2022Ctrl:getTotalSignDay()
	return self.totalSignDay
end
function signReward2022Ctrl:getUseGoldDay()
	return self.useGoldDay
end
function signReward2022Ctrl:getRefreshLv()
	return self.refreshLv
end
function signReward2022Ctrl:getSignTypeByDay(day)
	local ret = gSignRewardType.NO_SIGN
	if self.signInfo and self.signInfo[tostring(day)] then
		ret = self.signInfo[tostring(day)]
	end
	return ret
end
function signReward2022Ctrl:getSignStatusByDay(day)
	local status = 0
	local signType = self.signInfo[tostring(day)] or gSignRewardType.NO_SIGN
	if signType == gSignRewardType.NO_SIGN then
		if self.curDay == day then
			status = 1
		elseif day < self.curDay then
			status = 3
		end
	else
		status = 2
	end
	return status
end
function signReward2022Ctrl:getExtraRewardInfoByDay(day)
	if not self.extraRewardInfo then
		_ENV = self.extraRewardInfo
	end
	self.extraRewardInfo = self.extraRewardInfo
	return self.extraRewardInfo[tostring(day)] or gSignRewardStatus.NO_REWARD
end
function signReward2022Ctrl:isCanReceive()
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
	local signRewadRead = include("signRewadRead")
	local cumuCfg, cumuDay = signRewadRead.getCumuSignCfg()
	local status = self:getExtraRewardInfoByDay(cumuDay)
	if status == gSignRewardStatus.CAN_RECEIVE then
		ret = true
		retNum = retNum + 1
	end
	return ret, retNum
end
function signReward2022Ctrl:getReceiveStatusAndNum()
	return self:isCanReceive()
end
return signReward2022Ctrl

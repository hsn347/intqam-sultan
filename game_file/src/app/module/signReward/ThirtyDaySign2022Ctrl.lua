local GameModule = include("GameModule")
local ThirtyDaySign2022Ctrl = class("ThirtyDaySign2022Ctrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local signRewadRead = include("signRewadRead")
function ThirtyDaySign2022Ctrl:ctor(properties)
	ThirtyDaySign2022Ctrl.super.ctor(self, properties)
	self:resetData()
end
function ThirtyDaySign2022Ctrl:Logout()
	ThirtyDaySign2022Ctrl.super.Logout(self)
	self:resetData()
end
function ThirtyDaySign2022Ctrl:resetData()
	print("ThirtyDaySign2022Ctrl:resetData")
	self.handle_notify = nil
	self.curDay = nil
	self.useGoldDay = nil
	self.totalDay = nil
	self.extraRewardInfo, _ENV, self.signInfo, _ENV, self.totalSignDay = print, print, print, print, nil
end
function ThirtyDaySign2022Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_SIGN_REWARD_ACTIVITY_MODULE, gCmd.REQ_ANNIVERSARY_SIGN_2022_ACTIVITY_INIT, handler(self, self.getInitResp))
	msgCtrl.register(gCmd.CMD_SIGN_REWARD_ACTIVITY_MODULE, gCmd.REQ_ANNIVERSARY_SIGN_2022_ACTIVITY_SIGN, handler(self, self.getSignResp))
	msgCtrl.register(gCmd.CMD_SIGN_REWARD_ACTIVITY_MODULE, gCmd.REQ_ANNIVERSARY_SIGN_2022_ACTIVITY_USE_GOLD_SIGN, handler(self, self.getGoldSignResp))
	msgCtrl.register(gCmd.CMD_SIGN_REWARD_ACTIVITY_MODULE, gCmd.REQ_ANNIVERSARY_SIGN_2022_ACTIVITY_GET_EXTRA_REWARD, handler(self, self.getExtraRewardResp))
	self:registerNotify()
end
function ThirtyDaySign2022Ctrl:initClientData(data)
	if not data then
		return
	end
	dump(data, "ThirtyDaySign2022Ctrl:initClientData", 10)
	self.totalDay = data.totalDay
	self.curDay = data.curDay
	self.totalSignDay = data.totalSignDay
	self.useGoldDay = data.useGoldDay
	self.signInfo = data.signInfo
	self.extraRewardInfo = data.extraRewardInfo
end
function ThirtyDaySign2022Ctrl:getChangeExtraAwardDay(beforeDay, afterDay)
	if beforeDay and afterDay and self.localCumuDayArray then
		for i, value in pairs(self.localCumuDayArray) do
			if value == afterDay and beforeDay < value then
				return value
			end
		end
	end
end
function ThirtyDaySign2022Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.SIGN_REWARD_ACTIVITY, handler(self, self.notifyHandler))
end
function ThirtyDaySign2022Ctrl:notifyHandler(event)
	local content = event.data[1]
	if content.activityID ~= gActivityTimeActivityID.ANNIVERSARY_SIGN_2022_ACTIVITY then
		return
	end
	dump(content, "ThirtyDaySign2022Ctrl:notifyHandler")
	if content and content.curDay then
		self.curDay = content.curDay
		self.totalDay = content.totalDay
		self.totalSignDay = content.totalSignDay
		self.useGoldDay = content.useGoldDay
		self.signInfo = content.signInfo
		self.extraRewardInfo = content.extraRewardInfo
		_ENV = content
		content.msg = "MESSAGE_ANNIVERSARY_2022_SIGN"
		content.subMsg = "init"
		SoraDSendMessage(content)
	end
end
function ThirtyDaySign2022Ctrl:sendReqInitDataMsg()
	serverproxy:Request(gCmd.CMD_SIGN_REWARD_ACTIVITY_MODULE, gCmd.REQ_ANNIVERSARY_SIGN_2022_ACTIVITY_INIT)
end
function ThirtyDaySign2022Ctrl:sendSignMsg()
	serverproxy:Request(gCmd.CMD_SIGN_REWARD_ACTIVITY_MODULE, gCmd.REQ_ANNIVERSARY_SIGN_2022_ACTIVITY_SIGN)
end
function ThirtyDaySign2022Ctrl:sendUseGoldSignMsg(signDay)
	serverproxy = nil
	;(nil).signDay = signDay
	serverproxy:Request(gCmd.CMD_SIGN_REWARD_ACTIVITY_MODULE, gCmd.REQ_ANNIVERSARY_SIGN_2022_ACTIVITY_USE_GOLD_SIGN, nil)
end
function ThirtyDaySign2022Ctrl:sendGetExtraRewardMsg(extraDay)
	serverproxy = nil
	;(nil).extraDay = extraDay
	serverproxy:Request(gCmd.CMD_SIGN_REWARD_ACTIVITY_MODULE, gCmd.REQ_ANNIVERSARY_SIGN_2022_ACTIVITY_GET_EXTRA_REWARD, nil)
end
function ThirtyDaySign2022Ctrl:getInitResp(content)
	dump(content, "ThirtyDaySign2022Ctrl:getInitResp")
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
		_ENV = "ThirtyDaySign2022Ctrl:getInitResp"
		;("ThirtyDaySign2022Ctrl:getInitResp").msg = "MESSAGE_ANNIVERSARY_2022_SIGN"
		;("ThirtyDaySign2022Ctrl:getInitResp").subMsg = "init"
		SoraDSendMessage("ThirtyDaySign2022Ctrl:getInitResp")
	end
end
function ThirtyDaySign2022Ctrl:getSignResp(content)
	dump(content, "ThirtyDaySign2022Ctrl:getSignResp", 5)
	if content.err == gErrDef.Err_None and content.data then
		local data = content.data
		self.signInfo = data.signInfo
		self.extraRewardInfo = data.extraRewardInfo
		self.totalSignDay = data.totalSignDay
		SoraDMailGainItems(data.items, true)
		_ENV = data.items
		data.items.msg = "MESSAGE_ANNIVERSARY_2022_SIGN"
		data.items.subMsg = "sign"
		data.items.blockDay = data.day
		SoraDSendMessage(data.items)
	end
end
function ThirtyDaySign2022Ctrl:getGoldSignResp(content)
	dump(content, "ThirtyDaySign2022Ctrl:getUseGoldSignResp", 5)
	if content.err == gErrDef.Err_None and content.data then
		local data = content.data
		self.signInfo = data.signInfo
		self.extraRewardInfo = data.extraRewardInfo
		self.useGoldDay = data.useGoldDay
		self.totalSignDay = data.totalSignDay
		SoraDMailGainItems(data.items, true)
		_ENV = data.items
		data.items.msg = "MESSAGE_ANNIVERSARY_2022_SIGN"
		data.items.subMsg = "sign"
		data.items.blockDay = data.day
		SoraDSendMessage(data.items)
	end
end
function ThirtyDaySign2022Ctrl:getExtraRewardResp(content)
	dump(content, "ThirtyDaySign2022Ctrl:getExtraRewardResp", 5)
	if content.err == gErrDef.Err_None and content.data then
		if content.data.day then
			self.extraRewardInfo[tostring(content.data.day)] = gSignRewardStatus.ALREADY_RECEIVE
		end
		SoraDMailGainItems(content.data.items, true)
		_ENV = content.data.items
		content.data.items.msg = "MESSAGE_ANNIVERSARY_2022_SIGN"
		content.data.items.subMsg = "extra"
		SoraDSendMessage(content.data.items)
	end
end
function ThirtyDaySign2022Ctrl:getTotalDay()
	return math.min(30, self.totalDay)
end
function ThirtyDaySign2022Ctrl:getCurDay()
	return self.curDay
end
function ThirtyDaySign2022Ctrl:getTotalSignDay()
	return self.totalSignDay
end
function ThirtyDaySign2022Ctrl:getUseGoldDay()
	return self.useGoldDay
end
function ThirtyDaySign2022Ctrl:getSignTypeByDay(day)
	local ret = gSignRewardType.NO_SIGN
	if self.signInfo and self.signInfo[tostring(day)] then
		ret = self.signInfo[tostring(day)]
	end
	return ret
end
function ThirtyDaySign2022Ctrl:getExtraRewardType(day)
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
function ThirtyDaySign2022Ctrl:isCanReceive()
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
	return 0 < retNum, retNum
end
function ThirtyDaySign2022Ctrl:getReceiveStatusAndNum()
	return self:isCanReceive()
end
return ThirtyDaySign2022Ctrl

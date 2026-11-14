local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local annivCountdown2022Ctrl = class("annivCountdown2022Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function annivCountdown2022Ctrl:ctor(properties)
	annivCountdown2022Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.ANNIVERSARY_2022_ACTIVITY
	self:resetData()
end
function annivCountdown2022Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_ICE_CRAZY_NIGHT_MODULE, gCmd.ANNIVERSARY_2022_ACTIVITY_INIT, handler(self, self.reqAnnivCountdownInitRsp))
	msgCtrl.register(gCmd.CMD_ICE_CRAZY_NIGHT_MODULE, gCmd.ANNIVERSARY_2022_ACTIVITY_RECEIVE, handler(self, self.reqAnnivCountdownRewardRsp))
	msgCtrl.register(gCmd.CMD_ICE_CRAZY_NIGHT_MODULE, gCmd.ANNIVERSARY_2022_ACTIVITY_SIGN, handler(self, self.reqAnnivCountdownSignRsp))
	self:registerNotify()
end
function annivCountdown2022Ctrl:initClientData(data)
	dump(data, "==annivCountdown2022Ctrl:initClientData==", 10)
	if not data then
		return
	end
	self:setData(data)
end
function annivCountdown2022Ctrl:Logout()
	annivCountdown2022Ctrl.super.Logout(self)
	self:resetData()
end
function annivCountdown2022Ctrl:resetData()
	self.cumuInfo, _UPVALUE0_, self.cumuDay = nil, nil, 1
	self.opencount = 1
	self.signInfo, _UPVALUE0_, self.receiveOrder = nil, nil, 0
	self.updateTime = 0
end
function annivCountdown2022Ctrl:setData(data)
	if not data then
		return
	end
	self.cumuDay = data.cumuDay
	self.cumuInfo = data.cumuInfo
	self.receiveOrder = data.receiveOrder
	self.signInfo = data.signInfo
	self.updateTime = data.updateTime
end
function annivCountdown2022Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.ICE_CRAZY, handler(self, self.notifyHandler))
end
function annivCountdown2022Ctrl:notifyHandler(event)
	dump(event.data, "annivCountdown2022Ctrl:notifyHandler", 10)
	for type, content in pairs(event.data) do
		if content.activityID == self.activityID then
			dump(event.data, "annivCountdown2022Ctr76767l:notifyHandler", 10)
			self:setData(content.iceCrazyData)
			_ENV = self
			self.msg = "MESSAGE_ANNIV_COUNTDOWN_2022"
			self.subMsg = "init"
			SoraDSendMessage(self)
		end
	end
end
function annivCountdown2022Ctrl:sendReqInitDataMsg()
	if self:isActivityOpen() then
		serverproxy:Request(gCmd.CMD_ICE_CRAZY_NIGHT_MODULE, gCmd.ANNIVERSARY_2022_ACTIVITY_INIT)
	end
end
function annivCountdown2022Ctrl:reqAnnivCountdownReward()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ICE_CRAZY_NIGHT_MODULE, gCmd.ANNIVERSARY_2022_ACTIVITY_RECEIVE, nil)
end
function annivCountdown2022Ctrl:reqAnnivCountdownSign(day, signType)
	serverproxy = nil
	;(nil).day = day
	;(nil).signType = signType
	serverproxy:Request(gCmd.CMD_ICE_CRAZY_NIGHT_MODULE, gCmd.ANNIVERSARY_2022_ACTIVITY_SIGN, nil)
end
function annivCountdown2022Ctrl:reqAnnivCountdownInitRsp(content)
	dump(content, "annivCountdown2022Ctrl:reqAnnivCountdownInitRsp", 10)
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata.iceCrazyData)
		_ENV = self
		self.msg = "MESSAGE_ANNIV_COUNTDOWN_2022"
		self.subMsg = "init"
		SoraDSendMessage(self)
	end
end
function annivCountdown2022Ctrl:reqAnnivCountdownRewardRsp(content)
	dump(content, "annivCountdown2022Ctrl:reqAnnivCountdownRewardRsp", 10)
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata.iceCrazyData)
		SoraDMailGainItems(content.rspdata.reward, true)
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_ANNIV_COUNTDOWN_2022"
		content.rspdata.reward.subMsg = "countdown"
		SoraDSendMessage(content.rspdata.reward)
	end
end
function annivCountdown2022Ctrl:reqAnnivCountdownSignRsp(content)
	dump(content, "annivCountdown2022Ctrl:reqAnnivCountdownSignRsp", 10)
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata.iceCrazyData)
		SoraDMailGainItems(content.rspdata.reward, true)
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_ANNIV_COUNTDOWN_2022"
		content.rspdata.reward.subMsg = "sign"
		SoraDSendMessage(content.rspdata.reward)
	end
end
function annivCountdown2022Ctrl:getReceiveStatusAndNum()
	if SoraDGetCastleLv() < CASTLE_LV6_LIMITED then
		return false, -1
	end
	local num = 0
	if self:getCountDownRewardState() == 2 then
		num = num + 1
	end
	num = num + self:getSignNum()
	dump(self:getCountDownRewardState(), "fkl7676dkfldkfl")
	dump(self:getSignNum(), "fkldkfldkfl")
	return 0 < num, num
end
function annivCountdown2022Ctrl:isActivityOpen()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local eventState = activityShowCtrl:getStateByID(self.activityID)
	return eventState == gActivityState.OPEN
end
function annivCountdown2022Ctrl:getCountDownRewardState()
	if self:isActivityOpen() then
		if self.receiveOrder == 0 then
			return 2
		end
		return 3
	end
	return 1
end
function annivCountdown2022Ctrl:getSignNum()
	if not self:isActivityOpen() then
		return 0
	end
	if table.nums(self.signInfo) < 7 then
		local num = math.min(self.cumuDay, 7)
		return num - table.nums(self.signInfo)
	elseif 0 < table.nums(self.cumuInfo) then
		return 7 - table.nums(self.signInfo)
	else
		return 7 - table.nums(self.signInfo) + 1
	end
	return 0
end
function annivCountdown2022Ctrl:getCumuDay()
	return self.cumuDay
end
function annivCountdown2022Ctrl:getSignState(day)
	if day <= self.cumuDay then
		if self.signInfo[tostring(day)] then
			return 3
		end
		return 2
	end
	return 1
end
function annivCountdown2022Ctrl:getDay7SignState(day)
	if day < 7 then
		if day <= self.cumuDay then
			if self.signInfo[tostring(day)] then
				return 3
			end
			return 2
		end
		return 1
	else
		if day > self.cumuDay or table.nums(self.signInfo) < 6 then
			return 1
		elseif self.signInfo[tostring(day)] then
			return 3
		end
		return 2
	end
end
function annivCountdown2022Ctrl:getBigRewardState()
	if table.nums(self.signInfo) < 7 then
		return 1
	elseif table.nums(self.cumuInfo) > 0 then
		return 3
	end
	return 2
end
return annivCountdown2022Ctrl

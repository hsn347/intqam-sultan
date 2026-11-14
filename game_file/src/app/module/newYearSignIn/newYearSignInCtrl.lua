local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local newYearSignInCtrl = class("newYearSignInCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function newYearSignInCtrl:ctor(properties)
	newYearSignInCtrl.super.ctor(self, properties)
	self:resetData()
end
function newYearSignInCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_NEW_YEAR_CARNIVAL_MODULE, gCmd.REQ_NEW_YEAR_CARNIVAL_INIT, handler(self, self.reqNewYearCarnivalInitRsp))
	msgCtrl.register(gCmd.CMD_NEW_YEAR_CARNIVAL_MODULE, gCmd.REQ_NEW_YEAR_CARNIVAL_SIGN, handler(self, self.reqNewYearCarnivalSignRsp))
	self:registerNotify()
end
function newYearSignInCtrl:Logout()
	newYearSignInCtrl.super.Logout(self)
	self:resetData()
end
function newYearSignInCtrl:resetData()
	self.signData, _UPVALUE0_ = nil, nil
	self.curDay = 1
end
function newYearSignInCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.NEW_YAER_CARNICAL_NEW_DAY, handler(self, self.notifyHandler))
end
function newYearSignInCtrl:notifyHandler(event)
	dump(event.data, "newYearSignInCtrl:notifyHandler", 10)
	for _, v in ipairs(event.data) do
		if v.type == "newDay" then
			self.curDay = math.min(7, v.curDay)
			_ENV = 7
			;(7).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
			SoraDSendMessage(7)
			_ENV = 7
			;(7).msg = "MESSAGE_NEW_YEAR_SIGN_IN_REFRESH"
			SoraDSendMessage(7)
		end
	end
end
function newYearSignInCtrl:sendReqInitDataMsg()
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NEW_YEAR_CARNIVAL_ACTIVITY) then
		_ENV = nil
		serverproxy:Request(gCmd.CMD_NEW_YEAR_CARNIVAL_MODULE, gCmd.REQ_NEW_YEAR_CARNIVAL_INIT, nil)
	end
end
function newYearSignInCtrl:reqNewYearCarnivalSign(signDay)
	serverproxy = nil
	;(nil).signDay = signDay
	serverproxy:Request(gCmd.CMD_NEW_YEAR_CARNIVAL_MODULE, gCmd.REQ_NEW_YEAR_CARNIVAL_SIGN, nil)
end
function newYearSignInCtrl:reqNewYearCarnivalInitRsp(content)
	dump(content, "newYearSignInCtrl:reqNewYearCarnivalInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.signData = content.rspdata.signData
		self.curDay = math.min(7, content.rspdata.curDay)
		if self.curDay < 7 then
			_ENV = 10
			;(10).byUID = true
			SoraDConfigSet("Game:NewYearSignInPanel:showLastDayEffect~bool", false, 10)
		end
		_ENV = "Game:NewYearSignInPanel:showLastDayEffect~bool"
		;("Game:NewYearSignInPanel:showLastDayEffect~bool").msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		SoraDSendMessage("Game:NewYearSignInPanel:showLastDayEffect~bool")
	end
end
function newYearSignInCtrl:reqNewYearCarnivalSignRsp(content)
	dump(content, "newYearSignInCtrl:reqNewYearCarnivalSignRsp(content)", 10)
	SoraDCloseLoading()
	if content.err == gErrDef.Err_None then
		SoraDMailGainItems(content.rspdata.reward, true)
		for i, v in pairs(content.rspdata.signData) do
			self.signData[i] = v
		end
		_ENV = pairs(content.rspdata.signData)
		pairs(content.rspdata.signData).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		SoraDSendMessage(pairs(content.rspdata.signData))
		_ENV = pairs(content.rspdata.signData)
		pairs(content.rspdata.signData).msg = "MESSAGE_NEW_YEAR_SIGN_IN_REFRESH"
		pairs(content.rspdata.signData).day = content.data.signDay
		SoraDSendMessage(pairs(content.rspdata.signData))
	end
end
function newYearSignInCtrl:getCurDay()
	return self.curDay
end
function newYearSignInCtrl:isDaySigned(day)
	return self.signData[tostring(day)] and true or false
end
function newYearSignInCtrl:getDayRewardStatus(day)
	if day > self.curDay then
		return 4
	elseif self:isDaySigned(day) then
		return 1
	elseif day == self.curDay then
		if day == 7 and self:getSignedNum() ~= 6 then
			return 5
		end
		return 2
	else
		return 3
	end
end
function newYearSignInCtrl:getSignedNum()
	return table.nums(self.signData)
end
function newYearSignInCtrl:getGoldCost()
	local count = 1
	for i, v in pairs(self.signData) do
		if v == 2 then
			count = count + 1
		end
	end
	return include("newYearSignInRead").getCostGoldSignByDay(count)
end
function newYearSignInCtrl:getReceiveStatusAndNum()
	local count = self.curDay - self:getSignedNum()
	if self.curDay == 7 and self:getSignedNum() < 6 then
		count = count - 1
	end
	return 0 < count, count
end
return newYearSignInCtrl

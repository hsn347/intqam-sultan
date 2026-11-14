local GameModule = include("GameModule")
local newKingFundCtrl = class("newKingFundCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function newKingFundCtrl:ctor(properties)
	newKingFundCtrl.super.ctor(self, properties)
end
function newKingFundCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_NEW_KING_FUND_MODULE, gCmd.REQ_NEW_KING_FUND_INFO, handler(self, self.sendReqInfoRsp))
	msgCtrl.register(gCmd.CMD_NEW_KING_FUND_MODULE, gCmd.REQ_NEW_KING_FUND_INVEST, handler(self, self.sendReqInvestRsp))
	self:resetData()
end
function newKingFundCtrl:resetData()
	self.fundData, _UPVALUE0_ = nil, nil
end
function newKingFundCtrl:Logout()
	self:resetData()
	newKingFundCtrl.super.Logout(self)
end
function newKingFundCtrl:initClientData(data)
	self.fundData = data
end
function newKingFundCtrl:sendReqInfo()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_NEW_KING_FUND_MODULE, gCmd.REQ_NEW_KING_FUND_INFO, data)
end
function newKingFundCtrl:sendReqInvest()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_NEW_KING_FUND_MODULE, gCmd.REQ_NEW_KING_FUND_INVEST, data)
end
function newKingFundCtrl:getFundData(...)
	return self.fundData
end
function newKingFundCtrl:checkHasInvest(day)
	for i, v in ipairs(self.fundData.joinDays) do
		if v == day then
			return true
		end
	end
end
function newKingFundCtrl:getReturnLeftTime(...)
	local curTime = serviceFunctions.systemTime()
	local endTime = self:getReturnEndTime()
	return endTime - curTime
end
function newKingFundCtrl:getReturnEndTime(...)
	return serviceFunctions.getTodayZeroHourUTC(self.fundData.regTime) + 604800
end
function newKingFundCtrl:getInvestLeftTime(...)
	return 86400 - (serviceFunctions.systemTime() - serviceFunctions.getTodayZeroHourUTC(serviceFunctions.systemTime()))
end
function newKingFundCtrl:isShowFundTime()
	if self:isAlreadyInvest() then
		return false
	else
		return true
	end
end
function newKingFundCtrl:isAlreadyInvest(...)
	if self.fundData and self.fundData.joinDays and #self.fundData.joinDays > 0 then
		return true
	end
end
function newKingFundCtrl:isShowFundPage()
	if not self.fundData or not next(self.fundData) then
		return false
	end
	if self:getReturnLeftTime() < 0 then
		return false
	end
	local isInvest = self:isAlreadyInvest()
	local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
	local isInConquestWar = conquestWarCtrl:isPlayerConquestWarMigration()
	if not isInvest and isInConquestWar then
		return false
	end
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	if not isInvest and false == activityShowCtrl:isActivityOpen(gActivityTimeActivityID.NEW_KING_FUND) then
		return false
	end
	local worldMapDefine = include("worldMapDefine")
	local isInPyramidWar = worldMapDefine.isInWar()
	if isInPyramidWar then
		return false
	end
	return true
end
function newKingFundCtrl:getReceiveStatusAndNum(...)
	if not self.fundData or not self.fundData.regTime then
		return false, 0
	end
	local curDay = serviceFunctions.differDays(self.fundData.regTime) + 1
	if self:checkHasInvest(curDay) then
		return false, 0
	end
	return true, 1
end
function newKingFundCtrl:sendReqInfoRsp(content)
	if gErrDef.Err_None == content.err then
		self.fundData = content.data
		_ENV = content.err
		content.err.msg = "MESSAGE_NEWKINGFUND_REFRESH"
		SoraDSendMessage(content.err)
	end
end
function newKingFundCtrl:sendReqInvestRsp(content)
	if gErrDef.Err_None == content.err then
		local data = content.data
		data.regTime = self.fundData.regTime
		self.fundData = data
		_ENV = nil
		;(nil).msg = "MESSAGE_NEWKINGFUND_REFRESH"
		SoraDSendMessage(nil)
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		SoraDSendMessage(nil)
	end
end
return newKingFundCtrl

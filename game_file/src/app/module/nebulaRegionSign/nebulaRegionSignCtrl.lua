local GameModule = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local gamemodulec = include("GameModule")
local nebulaRegionSignCtrl = class("nebulaRegionSignCtrl", gamemodulec)
function nebulaRegionSignCtrl:ctor(properties)
	nebulaRegionSignCtrl.super.ctor(self, properties)
	self:resetData()
end
function nebulaRegionSignCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_NEBULA_SIGN_MODULE, gCmd.REQ_NEBULA_SIGN_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_SIGN_MODULE, gCmd.REQ_NEBULA_SIGN_COMMON_SIGN, handler(self, self.reqSignRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_SIGN_MODULE, gCmd.REQ_NEBULA_SIGN_USE_GOLD_SIGN, handler(self, self.reqGoldSignResp))
	self:resetData()
	self:registerNotify()
	self:sendReqInitDataMsg()
end
function nebulaRegionSignCtrl:Logout()
	nebulaRegionSignCtrl.super.Logout(self)
	self:resetData()
end
function nebulaRegionSignCtrl:setData(data)
	self.costGold = data.costGold or 0
	self.curDay = data.curDay or 0
	if not data.record then
		_UPVALUE0_ = data.record
	end
	self.record = data.record
end
function nebulaRegionSignCtrl:resetData()
	self.costGold = 0
	self.record, _UPVALUE0_, self.curDay = nil, nil, 0
end
function nebulaRegionSignCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.NEBULA_SIGN, handler(self, self.notifyHandler))
end
function nebulaRegionSignCtrl:notifyHandler(event)
	dump(event.data, "nebulaRegionSignCtrl:notifyHandler", 10)
	for _, v in ipairs(event.data) do
		self:setData(v.initData)
		_ENV = self
		self.msg = "MESSAGE_NEBULA_SIGN_REFRESH"
		SoraDSendMessage(self)
	end
end
function nebulaRegionSignCtrl:sendReqInitDataMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_NEBULA_SIGN_MODULE, gCmd.REQ_NEBULA_SIGN_INIT, nil)
end
function nebulaRegionSignCtrl:reqNormalSign()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_NEBULA_SIGN_MODULE, gCmd.REQ_NEBULA_SIGN_COMMON_SIGN, nil)
end
function nebulaRegionSignCtrl:reqGoldSign(signDay)
	serverproxy = nil
	;(nil).day = signDay
	serverproxy:Request(gCmd.CMD_NEBULA_SIGN_MODULE, gCmd.REQ_NEBULA_SIGN_USE_GOLD_SIGN, nil)
end
function nebulaRegionSignCtrl:reqInitRsp(content)
	dump(content, "nebulaRegionSignCtrl:reqInitRsp", 10)
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata.initData)
		_ENV = self
		self.msg = "MESSAGE_NEBULA_SIGN_REFRESH"
		SoraDSendMessage(self)
	end
end
function nebulaRegionSignCtrl:reqSignRsp(content)
	dump(content, "nebulaRegionSignCtrl:reqSignRsp", 10)
	if content.err == gErrDef.Err_None then
		SoraDMailGainItems(content.rspdata.reward, true)
		self:setData(content.rspdata.initData)
		_ENV = self
		self.msg = "MESSAGE_NEBULA_SIGN_REFRESH"
		SoraDSendMessage(self)
	end
end
function nebulaRegionSignCtrl:reqGoldSignResp(content)
	dump(content, "nebulaRegionSignCtrl:getGoldSignResp", 10)
	if content.err == gErrDef.Err_None then
		SoraDMailGainItems(content.rspdata.reward, true)
		self:setData(content.rspdata.initData)
		_ENV = self
		self.msg = "MESSAGE_NEBULA_SIGN_REFRESH"
		SoraDSendMessage(self)
	end
end
function nebulaRegionSignCtrl:getCurDay()
	return self.curDay
end
function nebulaRegionSignCtrl:isDaySigned(day)
	return self.record[tostring(day)] and true or false
end
function nebulaRegionSignCtrl:getReceiveStatusAndNum()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NEBULA_SIGN_ACTIVITY) or SoraDGetCastleLv() < CASTLE_LV110_LIMITED then
		return false
	end
	if self.record[tostring(self.curDay)] then
		return false
	else
		return true, -1
	end
end
return nebulaRegionSignCtrl

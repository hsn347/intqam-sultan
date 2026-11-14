local gametop = gModuleMgr.getObject("gametop")
local GameModule = include("GameModule")
local payBackCtrl = class("payBackCtrl", GameModule)
local msgCtrl = include("msgCtrl")
local serverproxy = gModuleMgr.getObject("serverproxy")
function payBackCtrl:ctor(properties)
	payBackCtrl.super.ctor(self, properties)
end
function payBackCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_PAY_BACK_MODULE, gCmd.REQ_PAY_BACK_BUY, handler(self, self.payBackBuyRsp))
	self:resetData()
	self:registerNotify()
end
function payBackCtrl:resetData()
	self.payBackData, _UPVALUE0_ = nil, nil
end
function payBackCtrl:initClientData(data)

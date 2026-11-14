local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local rechargeExchangeCtrl = class("rechargeExchangeCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function rechargeExchangeCtrl:ctor(properties)
	rechargeExchangeCtrl.super.ctor(self, properties)
	self:resetData()
end
function rechargeExchangeCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_RECHARGE_EXCHANGE_MODULE, gCmd.REQ_RECHARGE_EXCHANG_INIT, handler(self, self.reqRechargeExchangInitRsp))
	msgCtrl.register(gCmd.CMD_RECHARGE_EXCHANGE_MODULE, gCmd.REQ_RECHARGE_EXCHANG_BUY, handler(self, self.reqRechargeExchangBuyRsp))
	msgCtrl.register(gCmd.CMD_RECHARGE_EXCHANGE_MODULE, gCmd.REQ_RECHARGE_EXCHANG_EXCHANGE, handler(self, self.reqRechargeExchangeRsp))
end
function rechargeExchangeCtrl:Logout()
	rechargeExchangeCtrl.super.Logout(self)
	self:resetData()
end
function rechargeExchangeCtrl:resetData()
end
function rechargeExchangeCtrl:reqRechargeExchangInit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_RECHARGE_EXCHANGE_MODULE, gCmd.REQ_RECHARGE_EXCHANG_INIT, nil)
end
function rechargeExchangeCtrl:reqRechargeExchangBuy(rid, param)

local warOrderCtrl = include("warOrderCtrl")
local warHornCtrl = class("warHornCtrl", warOrderCtrl)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local warOrderRead = include("warOrderRead")
local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
function warHornCtrl:ctor(properties)
	warHornCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.WAR_ORDER_ACTIVITY_9001581
	self:resetData()
end
function warHornCtrl:EnterGame()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_INIT", handler(self, self.reqActivityInitDataRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_WAR_ORDER_FESTIVAL_BUY, handler(self, self.reqWarOrderBuyRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_WAR_ORDER_FESTIVAL_RECEIVE, handler(self, self.reqWarOrderReceiveRsp))
	self:registerNotify()
end
function warHornCtrl:initClientData(data)
	if not data then
		return
	end
	dump(data, "==warHornCtrl:initClientData==", 10)
	self.initData = data
end
function warHornCtrl:reqWarOrderBuy(rid)
	serverproxy = nil
	;(nil).rid = rid
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_WAR_ORDER_FESTIVAL_BUY, nil)
end
function warHornCtrl:reqWarOrderReceive()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_WAR_ORDER_FESTIVAL_RECEIVE, nil)
end
function warHornCtrl:isShowBuff()
	return false
end
function warHornCtrl:getBuffVale(...)
	if not self:isShowBuff() then
		return 0
	end
	return warHornCtrl.super.getBuffVale(self, ...)
end
return warHornCtrl

local GameModule = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local escortCartMgr = include("escortCartMgr")
local escortCartCtrl = class("escortCartCtrl", GameModule)
function escortCartCtrl:ctor(properties)
	escortCartCtrl.super.ctor(self, properties)
end
function escortCartCtrl:EnterGame()
	escortCartCtrl.super.EnterGame(self)
	self.cartMgr = escortCartMgr.new()
	msgCtrl.register(gCmd.CMD_ESCORT_CART_MODULE, gCmd.REQ_ESCORT_CART_DATA, handler(self, self.onRspCartData))
	msgCtrl.register(gCmd.CMD_ESCORT_CART_MODULE, gCmd.REQ_ESCORT_CART_REFRESH, handler(self, self.onRspCartRefresh))
	msgCtrl.register(gCmd.CMD_ESCORT_CART_MODULE, gCmd.REQ_ESCORT_CART_APPOINT, handler(self, self.onRspCartAppoint))
	self:reqUpdateData()
end
function escortCartCtrl:Logout()
	escortCartCtrl.super.Logout(self)
	self.cartMgr = nil
end
function escortCartCtrl:initClientData(data)
	if not data then
		return
	end
	self.cartMgr.rewardMap = data.rewardMap
	self.cartMgr.cartMoveTimeMap = data.cartMoveTimeMap
end
function escortCartCtrl:reqCartData(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ESCORT_CART_MODULE, gCmd.REQ_ESCORT_CART_DATA, nil, ...)
end
function escortCartCtrl:reqCartRefresh(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ESCORT_CART_MODULE, gCmd.REQ_ESCORT_CART_REFRESH, nil, ...)
end
function escortCartCtrl:reqCartAppoint(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ESCORT_CART_MODULE, gCmd.REQ_ESCORT_CART_APPOINT, nil, ...)
end
function escortCartCtrl:onRspCartData(rsp)
	if rsp.err == gErrDef.Err_None then
		self.cartMgr:setCurrCartLv(rsp.data.currCartLv)
		self.cartMgr:setRefreshCount(rsp.data.refreshCount)
		self.cartMgr:setRefreshTime(rsp.data.refreshTime)
		self.cartMgr:setNextRefreshGold(rsp.data.nextRefreshGold)
		_ENV = self.cartMgr
		self.cartMgr.msg = "MESSAGE_SERVER_ESCORT_REQ_CAR_DATA_BACK"
		self.cartMgr.data = rsp.data
		SoraDSendMessage(self.cartMgr)
	else
		_ENV = self.cartMgr
		self.cartMgr.msg = "MESSAGE_SERVER_ESCORT_REQ_CAR_DATA_FAILED"
		self.cartMgr.err = rsp.err
		self.cartMgr.data = rsp.data
		SoraDSendMessage(self.cartMgr)
	end
end
function escortCartCtrl:onRspCartRefresh(rsp)
	if rsp.err == gErrDef.Err_None then
		self.cartMgr:setCurrCartLv(rsp.data.currCartLv)
		self.cartMgr:setRefreshCount(rsp.data.refreshCount)
		self.cartMgr:setRefreshTime(rsp.data.refreshTime)
		self.cartMgr:setNextRefreshGold(rsp.data.nextRefreshGold)
		_ENV = self.cartMgr
		self.cartMgr.msg = "MESSAGE_SERVER_ESCORT_CAR_REFRESH_SUCCESS"
		self.cartMgr.data = rsp.data
		SoraDSendMessage(self.cartMgr)
	else
		_ENV = self.cartMgr
		self.cartMgr.msg = "ESCORT_REQ_CART_REFRESH_FAILED"
		self.cartMgr.err = rsp.err
		self.cartMgr.data = rsp.data
		SoraDSendMessage(self.cartMgr)
	end
end
function escortCartCtrl:onRspCartAppoint(rsp)
	if rsp.err == gErrDef.Err_None then
		self.cartMgr:setCurrCartLv(rsp.data.currCartLv)
		_ENV = self.cartMgr
		self.cartMgr.msg = "MESSAGE_SERVER_ESCORT_CAR_APPOINT_SUCCESS"
		self.cartMgr.data = rsp.data
		SoraDSendMessage(self.cartMgr)
	else
		SoraDShowMsgTip("Error !!")
		_ENV = "Error !!"
		;("Error !!").msg = "ESCORT_REQ_CART_APPOINT_FAILED"
		;("Error !!").err = rsp.err
		;("Error !!").data = rsp.data
		SoraDSendMessage("Error !!")
	end
end
function escortCartCtrl:reqUpdateData()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.ESCORT_CART, handler(self, self.onNotifyMsg))
end
function escortCartCtrl:onNotifyMsg(notification)
	print("[INFO] escortCartCtrl:onNotifyMsg")
	for i = 1, #notification.data do
		local msg = notification.data[i]
		if msg.rewardMap then
			self.cartMgr:setCartRewardMap(msg.rewardMap)
		end
	end
end
function escortCartCtrl:getRefreshGold()
	return self.cartMgr:getNextRefreshGold()
end
function escortCartCtrl:getCartReward(lv)
	return self.cartMgr:getCartReward(lv)
end
function escortCartCtrl:getCurrCartMoveTime()
	return self.cartMgr:getCurrCartMoveTime()
end
return escortCartCtrl

local GameModule = include("GameModule")
local iceBreakCtrl = class("iceBreakCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function iceBreakCtrl:ctor(properties)
	iceBreakCtrl.super.ctor(self, properties)
end
function iceBreakCtrl:EnterGame()
	gametop = nil
	;(nil).name = gEventName.event_req_player_data
	gametop.playertop_:dispatchEvent(nil)
	msgCtrl.register(gCmd.CMD_ICE_BREAK_MODULE, gCmd.REQ_ICE_BREAK_INIT, handler(self, self.reqInitResp))
	msgCtrl.register(gCmd.CMD_ICE_BREAK_MODULE, gCmd.REQ_ICE_BREAK_BUY, handler(self, self.reqBuyResp))
	msgCtrl.register(gCmd.CMD_ICE_BREAK_MODULE, gCmd.REQ_ICE_BREAK_TEST, handler(self, self.reqTestResp))
	self:resetData()
end
function iceBreakCtrl:resetData()
	self.handle_notify = nil
	self.iceBreakData = nil
	self.iceBreakID = nil
	self.endTime = nil
end
function iceBreakCtrl:Logout()
	self:resetData()
	iceBreakCtrl.super.Logout(self)
end
function iceBreakCtrl:initClientData(data)
	if not data then
		return
	end
	if data.iceBreakID then
		self.iceBreakID = data.iceBreakID
	end
	if data.iceBreakData then
		self.iceBreakData = data.iceBreakData
	end
	if data.endTime then
		self.endTime = data.endTime
	end
	self:registerNotify()
end
function iceBreakCtrl:dump()
end
function iceBreakCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.ICE_BREAK, handler(self, self.notifyHandler))
end
function iceBreakCtrl:notifyHandler(event)
	local content = event.data[1]
	if content then
		if content then
			self.iceBreakData = content.iceBreakData
		end
		if content.iceBreakID then
			self.iceBreakID = content.iceBreakID
		end
		if content.endTime then
			self.endTime = content.endTime
		end
		local buyReturnIceBreakID = content.buyReturnIceBreakID
		if true == content.rechargeSuccess then
			local mailid = content.mailid
			local reward = content.reward
			paymentManager.loopForFinishTransaction()
			_ENV = nil
			_ENV, (nil).msg = nil, "MESSAGE_SERVER_RECHARGECENTER_REFRESH"
			;(nil).result = true
			;(nil).rid = buyReturnIceBreakID
			;(nil).itemList = reward
			;(nil).data, (nil).mailID = nil, mailid
			SoraDSendMessage(nil)
		elseif false == content.rechargeSuccess then
			paymentManager.loopForFinishTransaction()
			_ENV = content.reward
			_ENV, content.reward.msg = SoraDSendMessage, "MESSAGE_SERVER_RECHARGECENTER_REFRESH"
			SoraDSendMessage.result = false
			content.reward.data, SoraDSendMessage.rid = SoraDSendMessage, buyReturnIceBreakID
			SoraDSendMessage(content.reward)
		end
		_ENV = content.reward
		content.reward.msg = "MESSAGE_MAIN_BREAKICE_UPDATE"
		SoraDSendMessage(content.reward)
	end
end
function iceBreakCtrl:sendInitMsg()
	serverproxy:Request(gCmd.CMD_ICE_BREAK_MODULE, gCmd.REQ_ICE_BREAK_INIT)
end
function iceBreakCtrl:sendBuyMsg(iceBreakID)
	local serverproxy, data
	data.iceBreakID = iceBreakID
	serverproxy:Request(gCmd.CMD_ICE_BREAK_MODULE, gCmd.REQ_ICE_BREAK_BUY, data)
end
function iceBreakCtrl:sendTestMsg()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_ICE_BREAK_MODULE, gCmd.REQ_ICE_BREAK_TEST, data)
end
function iceBreakCtrl:reqInitResp(ret)
	if ret and ret.data then
		local data = ret.data
	end
end
function iceBreakCtrl:reqBuyResp(ret)
	if ret and ret.data then
		local iceBreakID = ret.data.iceBreakID
		if ret.err == gErrDef.Err_None then
			local orderID = ret.data.orderID
			paymentManager.purchase(iceBreakID, orderID)
		else
			SoraDCloseLoading()
			paymentManager.isInRecharging = false
			if ret.err == gErrDef.Err_ICE_BREAK_GIFT_NOT_FOUIND then
			elseif ret.err == gErrDef.Err_ICE_BREAK_GIFT_ID_ERROR then
			end
		end
	end
end
function iceBreakCtrl:reqTestResp(ret)
	if ret and ret.data then
		local msg = "iceBreakCtrl noPayDay=" .. tostring(ret.data.noPayDay) .. ",rechargeStatus=" .. tostring(ret.data.rechargeStatus)
		SoraDShowMsgTip(msg)
	end
end
function iceBreakCtrl:getIceBreakID()
	return self.iceBreakID or 0
end
function iceBreakCtrl:getIceBreakEndTime()
	local ret = 0
	if self.endTime then
		ret = self.endTime - serviceFunctions.systemTime()
		if ret <= 0 then
			ret = 0
		end
	end
	return ret
end
function iceBreakCtrl:getIceBreakData()
	local _ENV, ret
	if self.iceBreakData and self.iceBreakData.endTime then
		self.iceBreakData.lastTime = self.iceBreakData.endTime - serviceFunctions.systemTime()
		if self.iceBreakData.lastTime > 0 then
			ret = self.iceBreakData
		end
	end
	return ret
end
return iceBreakCtrl

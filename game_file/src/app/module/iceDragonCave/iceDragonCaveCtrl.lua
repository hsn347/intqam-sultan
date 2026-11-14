local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local iceDragonCaveCtrl = class("iceDragonCaveCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local constantRead = include("constantRead")
local iceDragonCaveRead = include("iceDragonCaveRead")
function iceDragonCaveCtrl:ctor(properties)
	iceDragonCaveCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.ICE_DRAGON_CAVE_ACTIVITY
	self.itemID = 859501
	self:resetData()
end
function iceDragonCaveCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_ICE_DRAGON_CAVE_MODULE, gCmd.REQ_ICE_DRAGON_CAVE_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_ICE_DRAGON_CAVE_MODULE, gCmd.REQ_ICE_DRAGON_CAVE_DRAW_ONE, handler(self, self.reqCaveDrawOneRsp))
	msgCtrl.register(gCmd.CMD_ICE_DRAGON_CAVE_MODULE, gCmd.REQ_ICE_DRAGON_CAVE_DRAW_TEN, handler(self, self.reqCaveDrawTenRsp))
	msgCtrl.register(gCmd.CMD_ICE_DRAGON_CAVE_MODULE, gCmd.REQ_ICE_DRAGON_CAVE_RECEIVE, handler(self, self.reqCaveReceiveRsp))
	self:registerNotify()
	self:sendInitMsg()
end
function iceDragonCaveCtrl:initClientData(data)
	self.msgData = data
end
function iceDragonCaveCtrl:Logout()
	iceDragonCaveCtrl.super.Logout(self)
	self:resetData()
end
function iceDragonCaveCtrl:resetData()
	self.msgData = nil
end
function iceDragonCaveCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.ICE_DRAGON_CAVE, handler(self, self.notifyHandler))
end
function iceDragonCaveCtrl:notifyHandler(event)
	dump(event.data, "iceDragonCaveCtrl:notifyHandler", 10)
	for _, content in pairs(event.data) do
		if content then
			self:initClientData(content.initData)
			_ENV = self
			self.msg = "MESSAGE_ICE_DRAGON_UPDATE"
			SoraDSendMessage(self)
			_ENV = self
			self.msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
			self.activityID = self.activityID
			SoraDSendMessage(self)
		end
	end
end
function iceDragonCaveCtrl:sendInitMsg()
	if clientEventMgr.judgeIsOpen(self.activityID) then
		_ENV = nil
		serverproxy:Request(gCmd.CMD_ICE_DRAGON_CAVE_MODULE, gCmd.REQ_ICE_DRAGON_CAVE_INIT, nil)
	end
end
function iceDragonCaveCtrl:reqCaveDrawOne()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ICE_DRAGON_CAVE_MODULE, gCmd.REQ_ICE_DRAGON_CAVE_DRAW_ONE, nil)
end
function iceDragonCaveCtrl:reqCaveDrawTen()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ICE_DRAGON_CAVE_MODULE, gCmd.REQ_ICE_DRAGON_CAVE_DRAW_TEN, nil)
end
function iceDragonCaveCtrl:reqCaveReceive(draw)
	serverproxy = nil
	;(nil).draw = draw
	serverproxy:Request(gCmd.CMD_ICE_DRAGON_CAVE_MODULE, gCmd.REQ_ICE_DRAGON_CAVE_RECEIVE, nil)
end
function iceDragonCaveCtrl:reqInitRsp(content)
	dump(content, "iceDragonCaveCtrl:reqInit(content)", 10)
	if content.err == gErrDef.Err_None then
		self:initClientData(content.rspdata.initData)
		_ENV = self
		self.msg = "MESSAGE_ICE_DRAGON_UPDATE"
		SoraDSendMessage(self)
	end
end
function iceDragonCaveCtrl:reqCaveDrawOneRsp(content)
	dump(content, "iceDragonCaveCtrl:reqCaveDrawOneRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:initClientData(content.rspdata.initData)
		_ENV = self
		self.msg = "MESSAGE_ICE_DRAGON_UPDATE"
		self.reward = content.rspdata.reward
		SoraDSendMessage(self)
	end
end
function iceDragonCaveCtrl:reqCaveDrawTenRsp(content)
	dump(content, "iceDragonCaveCtrl:reqCaveDrawTenRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:initClientData(content.rspdata.initData)
		_ENV = self
		self.msg = "MESSAGE_ICE_DRAGON_UPDATE"
		self.reward = content.rspdata.reward
		SoraDSendMessage(self)
	end
end
function iceDragonCaveCtrl:reqCaveReceiveRsp(content)
	dump(content, "iceDragonCaveCtrl:reqCaveReceiveRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:initClientData(content.rspdata.initData)
		SoraDMailGainItems(content.rspdata.reward, true)
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_ICE_DRAGON_UPDATE"
		SoraDSendMessage(content.rspdata.reward)
	end
end
function iceDragonCaveCtrl:getReceiveStatusAndNum()
	if self.msgData then
		local retNum = 0
		local backpackCtrl = SoraDGetCtrl("backpackCtrl")
		local itemNum = backpackCtrl:getItemCount(self.itemID)
		if 0 < itemNum then
			return true, -1
		end
		local drawCount = self:getDrawCount()
		local rewardCfgList = iceDragonCaveRead.getRewardCfgList()
		for i, v in ipairs(rewardCfgList) do
			if drawCount >= v.draw and self:getIsReceived(v.draw) ~= gBtnTargetStatusDef.GOT then
				return true, -1
			end
		end
	else
		return false, 0
	end
end
function iceDragonCaveCtrl:getDrawCount()
	return self.msgData and self.msgData.cumuDrawCount or 0
end
function iceDragonCaveCtrl:getIsReceived(draw)
	if not self.msgData then
		return false
	end
	local drawCount = self:getDrawCount()
	if self.msgData.record[tostring(draw)] then
		return gBtnTargetStatusDef.GOT
	end
	if draw <= drawCount then
		return gBtnTargetStatusDef.GET
	end
	return gBtnTargetStatusDef.GO
end
function iceDragonCaveCtrl:getGroup()
	local param = SoraDGetCtrl("activityShowCtrl"):getParamByID(self.activityID)
	return param.classtype or 1
end
return iceDragonCaveCtrl

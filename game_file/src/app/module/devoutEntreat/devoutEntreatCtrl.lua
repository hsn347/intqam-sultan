local GameModule = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local devoutEntreatCtrl = class("devoutEntreatCtrl", GameModule)
function devoutEntreatCtrl:ctor(properties)
	devoutEntreatCtrl.super.ctor(self, properties)
end
function devoutEntreatCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_PLEAD_ACTIVITY_MODULE, gCmd.REQ_PLEAD_ACTIVITY_INIT, handler(self, self.sendReqRsp))
	msgCtrl.register(gCmd.CMD_PLEAD_ACTIVITY_MODULE, gCmd.REQ_PLEAD_ACTIVITY_CHOOSE, handler(self, self.sendReqRsp))
	msgCtrl.register(gCmd.CMD_PLEAD_ACTIVITY_MODULE, gCmd.REQ_PLEAD_ACTIVITY_PLEAD, handler(self, self.sendReqRsp))
	msgCtrl.register(gCmd.CMD_PLEAD_ACTIVITY_MODULE, gCmd.REQ_PLEAD_ACTIVITY_RESET, handler(self, self.sendReqRsp))
	msgCtrl.register(gCmd.CMD_PLEAD_ACTIVITY_MODULE, gCmd.REQ_PLEAD_ACTIVITY_START_PLEAD, handler(self, self.sendReqRsp))
	self:resetData()
	self:registerNotify()
end
function devoutEntreatCtrl:Logout()
	self:resetData()
	devoutEntreatCtrl.super.Logout(self)
end
function devoutEntreatCtrl:initClientData(content)
	dump(content, "==devoutEntreatCtrl:initClientData==", 20)
	if not content then
		return
	end
	self.pleadData = content.rspdata.pleadData
end
function devoutEntreatCtrl:resetData()
	self.pleadData, _UPVALUE0_ = nil, nil
end
function devoutEntreatCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.PLEAD_ACTIVITY, handler(self, self.notifyCallback))
end
function devoutEntreatCtrl:sendInitMsg()
	serverproxy:Request(gCmd.CMD_PLEAD_ACTIVITY_MODULE, gCmd.REQ_PLEAD_ACTIVITY_INIT)
end
function devoutEntreatCtrl:sendChooseMsg(data)
	dump(data, "sendChooseMsg", 10)
	serverproxy:Request(gCmd.CMD_PLEAD_ACTIVITY_MODULE, gCmd.REQ_PLEAD_ACTIVITY_CHOOSE, data)
end
function devoutEntreatCtrl:sendPleadMsg()
	serverproxy:Request(gCmd.CMD_PLEAD_ACTIVITY_MODULE, gCmd.REQ_PLEAD_ACTIVITY_PLEAD)
end
function devoutEntreatCtrl:sendResetMsg()
	serverproxy:Request(gCmd.CMD_PLEAD_ACTIVITY_MODULE, gCmd.REQ_PLEAD_ACTIVITY_RESET)
end
function devoutEntreatCtrl:sendBeginEntreatMsg()
	serverproxy:Request(gCmd.CMD_PLEAD_ACTIVITY_MODULE, gCmd.REQ_PLEAD_ACTIVITY_START_PLEAD)
end
function devoutEntreatCtrl:notifyCallback(event)
	if event and event.data and type(event.data) == "table" then
		for _, content in ipairs(event.data) do
			dump(content, "==devoutEntreatCtrl:notifyCallback==", 20)
			if content.activityID == gActivityTimeActivityID.PLEAD_ACTIVITY then
				local data = content
				self.pleadData = content.rspdata and content.rspdata.pleadData
				_ENV = "==devoutEntreatCtrl:notifyCallback=="
				;("==devoutEntreatCtrl:notifyCallback==").msg = "MESSAGE_DEVOUTENTREAT_INITDATA"
				SoraDSendMessage("==devoutEntreatCtrl:notifyCallback==")
			end
		end
	end
end
function devoutEntreatCtrl:sendReqRsp(content)
	dump(content, "==devoutEntreatCtrl:sendReqInfoRsp==", 20)
	if content.err == gErrDef.Err_None then
		self.pleadData = content.rspdata.pleadData
		local reward = content.rspdata and content.rspdata.reward
		_ENV = "==devoutEntreatCtrl:sendReqInfoRsp=="
		;("==devoutEntreatCtrl:sendReqInfoRsp==").msg = "MESSAGE_DEVOUTENTREAT_INITDATA"
		;("==devoutEntreatCtrl:sendReqInfoRsp==").reward = reward
		;("==devoutEntreatCtrl:sendReqInfoRsp==").position = content.rspdata and content.rspdata.position
		SoraDSendMessage("==devoutEntreatCtrl:sendReqInfoRsp==")
	end
end
function devoutEntreatCtrl:getClassType()
	return self.pleadData and self.pleadData.classtype or 1
end
function devoutEntreatCtrl:getLeftResetCont()
	return self.pleadData and self.pleadData.leftResetCont or 1
end
function devoutEntreatCtrl:getMaxResetCount()
	return self.pleadData and self.pleadData.maxResetCount or 1
end
function devoutEntreatCtrl:getPrizePoolTbl()
	if not self.pleadData or not self.pleadData.prizePool then
		_UPVALUE0_ = self.pleadData.prizePool
	end
	return self.pleadData.prizePool
end
function devoutEntreatCtrl:getActivityState()
	return self.pleadData and self.pleadData.stats or 1
end
function devoutEntreatCtrl:getIndexByPosition(position)
	local tmp = self:getPrizePoolTbl()
	local tbl = tmp[tostring(position)]
	return tbl and tbl.index
end
function devoutEntreatCtrl:isItemSelected(index)
	for i, v in pairs(self:getPrizePoolTbl()) do
		if v.index == index then
			return true
		end
	end
	return false
end
function devoutEntreatCtrl:getCostItemInfo()
	local _ENV, tmp
	if not self.pleadData or not self.pleadData.cost then
		_ENV = self.pleadData.cost
	end
	for i, v in pairs(self.pleadData.cost) do
		tmp.id = i
		tmp.count = v
	end
	return tmp
end
function devoutEntreatCtrl:isCanBeginEntreat()
	return table.nums(self:getPrizePoolTbl()) == 8
end
return devoutEntreatCtrl

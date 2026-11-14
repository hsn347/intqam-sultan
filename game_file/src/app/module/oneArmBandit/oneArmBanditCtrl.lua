local GameModule = include("GameModule")
local oneArmBanditCtrl = class("oneArmBanditCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function oneArmBanditCtrl:ctor(properties)
	oneArmBanditCtrl.super.ctor(self, properties)
end
function oneArmBanditCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_SLOT_MODULE, gCmd.REQ_SLOT_INOROUT, handler(self, self.sendReqInfoRsp))
	msgCtrl.register(gCmd.CMD_SLOT_MODULE, gCmd.REQ_SLOT_LOTTERY, handler(self, self.sendReqSlotRsp))
	self:resetData()
	self:registerNotify()
end
function oneArmBanditCtrl:resetData()
	_UPVALUE0_ = nil
	self.lastSlotdata, _UPVALUE0_, self.slotData, (nil).rankList, _UPVALUE0_, (nil).winners, _UPVALUE0_, (nil).jackpot, _UPVALUE0_, (nil).prizePool = nil, nil, nil, nil, nil, nil, nil, nil, nil, 0
end
function oneArmBanditCtrl:Logout()
	self:resetData()
	oneArmBanditCtrl.super.Logout(self)
end
function oneArmBanditCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.SLOT_MACHINE, handler(self, self.notifyCallback))
end
function oneArmBanditCtrl:notifyCallback(event)
	for i, content in ipairs(event.data) do
		dump(content, "==oneArmBanditCtrl:notifyCallback==", 5)
		local prizePool = content.data.prizePool
		local poolChange = false
		local addRecord = false
		local addjackpot = false
		local rankListChange = false
		if prizePool and prizePool ~= self.slotData.prizePool then
			self.slotData.prizePool = prizePool
			poolChange = true
		end
		local winner = content.data.winner
		if winner and next(winner) then
			addRecord = true
		end
		local jackpot = content.data.jackpot
		if jackpot and next(jackpot) then
			addjackpot = true
		end
		local rankData = content.data.rankData
		local index = content.data.index
		if rankData and next(rankData) and index and index <= 10 then
			rankListChange = true
			self:addRankData(index, rankData)
		end
		_ENV = self
		self.msg = "MESSAGE_ONEARMBANDIT_NOTIFY_BACK"
		self.poolChange = poolChange
		self.addRecord = addRecord
		self.record = winner
		self.addjackpot = addjackpot
		self.jackpot = jackpot
		self.rankListChange = rankListChange
		SoraDSendMessage(self)
	end
end
function oneArmBanditCtrl:sendReqInfoRsp(content)
	dump(content, "oneArmBanditCtrl:sendReqInfoRsp", 10)
	if gErrDef.Err_None == content.err then
		self.slotData = table.nums(content.data) > 0 and content.data or self.slotData
		_ENV = content.data
		content.data.msg = "MESSAGE_ONEARMBANDIT_REQ_INFO_BACK"
		SoraDSendMessage(content.data)
	end
end
function oneArmBanditCtrl:sendReqSlotRsp(content)
	dump(content, "oneArmBanditCtrl:sendReqSlotRsp", 10)
	if gErrDef.Err_None == content.err then
		self.lastSlotdata = content.data
		_ENV = content.err
		content.err.msg = "MESSAGE_ONEARMBANDIT_SLOT_BACK"
		SoraDSendMessage(content.err)
	end
end
function oneArmBanditCtrl:sendReqInfo(isInSlot)
	print("==oneArmBanditCtrl:sendReqInfo==", isInSlot)
	_ENV = print
	local print.isInSlot, data = isInSlot, print
	serverproxy:Request(gCmd.CMD_SLOT_MODULE, gCmd.REQ_SLOT_INOROUT, data)
end
function oneArmBanditCtrl:sendReqSlot(slotType)
	serverproxy = nil
	local (nil).type, data = slotType, nil
	serverproxy:Request(gCmd.CMD_SLOT_MODULE, gCmd.REQ_SLOT_LOTTERY, data)
end
function oneArmBanditCtrl:getSlotData(...)
	dump(self.slotData, "self.slotData", 10)
	if not self.slotData then
		_ENV = self.slotData
	end
	return self.slotData
end
function oneArmBanditCtrl:getLastSlotData(...)
	if not self.lastSlotdata then
		_UPVALUE0_ = self.lastSlotdata
	end
	return self.lastSlotdata
end
function oneArmBanditCtrl:addRecord(record)
	if not self.slotData.winners then
		self.slotData.winners, _ENV = nil, nil
	end
	local addIndex
	for i, v in ipairs(self.slotData.winners) do
		if v.time > record.time then
			addIndex = i
			break
		end
	end
	if addIndex then
		table.insert(self.slotData.winners, addIndex, record)
	else
		table.insert(self.slotData.winners, record)
	end
	if #self.slotData.winners > 50 then
		for i = 51, #self.slotData.winners do
			table.remove(self.slotData.winners, 1)
		end
	end
end
function oneArmBanditCtrl:addJackpot(jackpot)
	self.slotData.jackpot = jackpot
end
function oneArmBanditCtrl:addRankData(index, rankData)
	table.insert(self.slotData.rankList, index, rankData)
	local _ENV, list = table.insert, table.insert
	for i = 1, 10 do
		if self.slotData.rankList[i] then
			list[i] = self.slotData.rankList[i]
		end
	end
	self.slotData.rankList = list
end
return oneArmBanditCtrl

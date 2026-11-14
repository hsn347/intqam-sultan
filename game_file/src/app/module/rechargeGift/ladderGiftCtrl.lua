local gamemodulec = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local timerList = gModuleMgr.getObject("timerList")
local ladderGiftCtrl = class("ladderGiftCtrl", gamemodulec)
local LevelUpInfoList = require("app." .. LocalTblPath .. ".config_server.grownup_found_config")
function ladderGiftCtrl:buyGift(giftID)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_LADDER_GIFT_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_LADDER_GIFT_BUY, gCmd.REQ_LADDER_GIFT_BUY
	;(nil).data, gCmd.REQ_LADDER_GIFT_BUY.giftid = gCmd.REQ_LADDER_GIFT_BUY, giftID
	local msg
	serverproxy:SendMsg(msg)
end
function ladderGiftCtrl:receiveGrowUpReward(giftID, lv)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_LADDER_GIFT_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_LADDER_GIFT_RECEIVE, gCmd.REQ_LADDER_GIFT_RECEIVE
	gCmd.REQ_LADDER_GIFT_RECEIVE.giftid = giftID
	;(nil).data, gCmd.REQ_LADDER_GIFT_RECEIVE.lv = gCmd.REQ_LADDER_GIFT_RECEIVE, lv
	local msg
	serverproxy:SendMsg(msg)
end
function ladderGiftCtrl:buyGiftRsp(content)
	if content.err == gErrDef.Err_None then
		local giftid = content.data.giftid
		local orderID = content.rspdata.orderID
		paymentManager.purchase(giftid, orderID)
	else
		print("adderGiftCtrl:buyGiftRsp err", content.err)
		_ENV = "adderGiftCtrl:buyGiftRsp err"
		;("adderGiftCtrl:buyGiftRsp err").msg = "MESSAGE_CLIENT_RECHARGECENTER_POPVIEWCLOSE"
		SoraDSendMessage("adderGiftCtrl:buyGiftRsp err")
		_ENV = "adderGiftCtrl:buyGiftRsp err"
		;("adderGiftCtrl:buyGiftRsp err").msg = "MESSAGE_SERVER_RECHARGECENTER_RECHARGEVIEWREFRESH"
		SoraDSendMessage("adderGiftCtrl:buyGiftRsp err")
		SoraDCloseLoading()
		paymentManager.isInRecharging = false
	end
end
function ladderGiftCtrl:receiveGrowUpRewardRsp(content)
	dump(content, "ladderGiftCtrl:receiveGrowUpRewardRsp", 10)
	if content.err == gErrDef.Err_None then
		self.ladderData = content.rspdata.giftData
		local reward = content.rspdata.reward
		SoraDPopGainItem(reward[1].id, reward[1].count)
		_ENV = reward[1].id
		reward[1].id.msg = "MESSAGE_VALUE_REBATE_RECEIVE_REFRESH"
		SoraDSendMessage(reward[1].id)
		_ENV = reward[1].id
		reward[1].id.msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		SoraDSendMessage(reward[1].id)
	elseif content.err == gErrDef.Err_RECHARGE_LADDER_CAN_NOT_RECEIVE then
	end
end
function ladderGiftCtrl:noitfyDataRsp(event)
	dump(event, "ladderGiftCtrl:noitfyDataRsp")
	if event.data then
		for _, content in pairs(event.data) do
			self.ladderData = content.giftData
			if content.success == true then
				paymentManager.OnemtRechargeSuccess(content.price)
				paymentManager.loopForFinishTransaction()
				local reward = content.rewards
				local mailid = content.mailid
				local rid = content.giftid
				_ENV = nil
				_ENV, (nil).msg = nil, "MESSAGE_SERVER_RECHARGECENTER_REFRESH"
				;(nil).result = true
				;(nil).rid = rid
				;(nil).itemList = reward
				;(nil).data, (nil).mailID = nil, mailid
				SoraDSendMessage(nil)
			end
			_ENV = content.mailid
			content.mailid.msg = "MESSAGE_SERVER_RECHARGECENTER_RUIRUILADDER_REFRESH"
			SoraDSendMessage(content.mailid)
			_ENV = content.mailid
			content.mailid.msg = "MESSAGE_VALUE_REBATE_BUY_REFRESH"
			SoraDSendMessage(content.mailid)
		end
	end
end
function ladderGiftCtrl:getLadderData(...)
	return self.ladderData
end
function ladderGiftCtrl:trasnMyLadderData(...)
	local _ENV, ret
	if next(self.ladderData) then
		local warMadMan = self.ladderData.warMadMan
		if warMadMan and next(warMadMan) then
			local curID = warMadMan.curGiftID
			local curData = clone(warMadMan.ladderGiftList[1])
			local nextData = clone(warMadMan.ladderGiftList)
			table.remove(nextData, 1)
			curData.nextLadderList = nextData
			ret[tostring(curID)] = curData
		end
	end
	return ret
end
function ladderGiftCtrl:getLadderDataByID(id)
	local _ENV, giftData
	local activeDataList = clone(self:trasnMyLadderData())
	for k, v in pairs(activeDataList) do
		if tonumber(id) == tonumber(k) then
			giftData = v
			local giftStyle
			giftData.giftStyle = giftStyle
			giftData.leftTime = v.endtime - v.starttime
			break
		end
	end
	return giftData
end
function ladderGiftCtrl:getGrowUpHasEnter()
	return self.ladderData.growUpData and self.ladderData.growUpData.hasEnter and self.ladderData.growUpData.ladderGiftList
end
function ladderGiftCtrl:getGrowUpCurGiftID()
	return self.ladderData.growUpData and self.ladderData.growUpData.curGiftID
end
function ladderGiftCtrl:getGrowUpLadderGiftList()
	return self.ladderData.growUpData and self.ladderData.growUpData.ladderGiftList
end
function ladderGiftCtrl:getGrowUpBuyRecord(giftID)
	return self.ladderData.growUpData and self.ladderData.growUpData.buyRecord and self.ladderData.growUpData.buyRecord[tostring(giftID)]
end
function ladderGiftCtrl:getBoughtGift()
	if not self.ladderData.growUpData or not self.ladderData.growUpData.buyRecord then
		local _ENV, buyRecord = self.ladderData.growUpData.buyRecord, self.ladderData.growUpData.buyRecord
	end
	local _ENV, record
	for k, v in pairs(buyRecord) do
		record[tonumber(k)] = self:getReceiveNumByID(tonumber(k))
	end
	return record
end
function ladderGiftCtrl:getReceiveNumByID(rid)
	local num = 0
	for i, v in ipairs(self:getValueRebateInfoList()) do
		if rid == v.rid and self:getGrowUpBuyRecord(v.rid) and SoraDGetCastleLv() >= v.castleLevel and not self:getGrowUpReceive(v.rid, v.castleLevel) then
			num = num + 1
		end
	end
	return num
end
function ladderGiftCtrl:getGrowUpReceive(giftID, lv)
	local receiveKey = tostring(giftID) .. "_" .. tostring(lv)
	return self.ladderData.growUpData and self.ladderData.growUpData.receive and self.ladderData.growUpData.receive[receiveKey]
end
function ladderGiftCtrl:getReceiveStatusAndNum()
	local ret = false
	local retNum = 0
	for i, v in ipairs(self:getValueRebateInfoList()) do
		if self:getGrowUpBuyRecord(v.rid) and SoraDGetCastleLv() >= v.castleLevel and not self:getGrowUpReceive(v.rid, v.castleLevel) then
			ret = true
			retNum = retNum + 1
		end
	end
	return ret, retNum
end
function ladderGiftCtrl:getValueRebateInfoList()
	local _ENV, tbl
	for i, v in ipairs(LevelUpInfoList) do
		if v.type == 2 then
			table.insert(tbl, v)
		end
	end
	return tbl
end
function ladderGiftCtrl:ctor(properties)
	ladderGiftCtrl.super.ctor(self, properties)
	self:resetData()
end
function ladderGiftCtrl:resetData()
	self.ladderData, _UPVALUE0_ = nil, nil
end
function ladderGiftCtrl:initClientData(data)
	if nil == data then
		return
	end
	self.ladderData = data
	self:registerNotify()
end
function ladderGiftCtrl:EnterGame()
	ladderGiftCtrl.super.EnterGame(self)
	msgCtrl.register(gCmd.CMD_LADDER_GIFT_MODULE, gCmd.REQ_LADDER_GIFT_BUY, handler(self, self.buyGiftRsp))
	msgCtrl.register(gCmd.CMD_LADDER_GIFT_MODULE, gCmd.REQ_LADDER_GIFT_RECEIVE, handler(self, self.receiveGrowUpRewardRsp))
end
function ladderGiftCtrl:registerNotify(...)
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.LADDER_GIFT, handler(self, self.noitfyDataRsp))
end
function ladderGiftCtrl:Logout()
	ladderGiftCtrl.super.Logout(self)
	self:resetData()
end
return ladderGiftCtrl

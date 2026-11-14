local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local beachTreasureCtrl = class("beachTreasureCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function beachTreasureCtrl:ctor(properties)
	beachTreasureCtrl.super.ctor(self, properties)
	self:resetData()
end
function beachTreasureCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_BEACH_TREASURE_MODULE, gCmd.REQ_BEACH_TREASURE_INIT, handler(self, self.reqBeachTreasureInitRsp))
	msgCtrl.register(gCmd.CMD_BEACH_TREASURE_MODULE, gCmd.REQ_BEACH_TREASURE_LOTTERY, handler(self, self.reqBeachTreasureLotteryRsp))
	self:registerNotify()
end
function beachTreasureCtrl:Logout()
	beachTreasureCtrl.super.Logout(self)
	self:resetData()
end
function beachTreasureCtrl:resetData()
	self.rewardIds, _UPVALUE0_, self.lottoryTimes = nil, nil, 0
end
function beachTreasureCtrl:initClientData(data)
	if not data then
		return
	end
	dump(data, "==beachTreasureCtrl:initClientData==", 10)
	self.lottoryTimes = data.lottoryTimes or 0
	if not data.rewardIds then
		_ENV = data.rewardIds
	end
	self.rewardIds = data.rewardIds
end
function beachTreasureCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.BEACH_TREASURE, handler(self, self.notifyHandler))
end
function beachTreasureCtrl:notifyHandler(event)
	dump(event.data, "beachTreasureCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
	end
end
function beachTreasureCtrl:reqBeachTreasureInit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_BEACH_TREASURE_MODULE, gCmd.REQ_BEACH_TREASURE_INIT, nil)
end
function beachTreasureCtrl:reqBeachTreasureInitRsp(content)
	dump(content, "beachTreasureCtrl:reqBeachTreasureInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.lottoryTimes = content.rspdata.lottoryTimes or 0
		if not content.rspdata.rewardIds then
			_ENV = content.rspdata.rewardIds
		end
		self.rewardIds = content.rspdata.rewardIds
		self:checkGrandPrize()
	end
	_ENV = self
	self.msg = "MESSAGE_BEACH_HUNT_UPDATE"
	SoraDSendMessage(self)
end
function beachTreasureCtrl:reqBeachTreasureLottery(idx)
	serverproxy = nil
	;(nil).idx = idx
	serverproxy:Request(gCmd.CMD_BEACH_TREASURE_MODULE, gCmd.REQ_BEACH_TREASURE_LOTTERY, nil)
end
function beachTreasureCtrl:reqBeachTreasureLotteryRsp(content)
	dump(content, "beachTreasureCtrl:reqBeachTreasureLotteryRsp(content)", 10)
	local idx
	if content.err == gErrDef.Err_None then
		idx = content.data.idx
		local rewardIds = content.rspdata.rewardIds
		for k, v in pairs(rewardIds) do
			self.rewardIds[k] = v
		end
		if not content.rspdata.rewards then
			local _ENV, rewards = content.rspdata.rewards, content.rspdata.rewards
		end
		if next(rewards) then
			SoraDMailGainItems(rewards, true)
		end
		self:checkGrandPrize()
	end
	_ENV = content.rspdata.rewards
	content.rspdata.rewards.msg = "MESSAGE_BEACH_HUNT_UPDATE"
	content.rspdata.rewards.idx = idx
	SoraDSendMessage(content.rspdata.rewards)
end
function beachTreasureCtrl:checkGrandPrize()
	local isGrand = self:isGotGrandPrizes()
	if isGrand then
		local treasureBeachRead = include("treasureBeachRead")
		local cfg = treasureBeachRead.getBeachCfg()
		local _ENV, tbIdx
		for i, j in ipairs(cfg) do
			if not self:isInRewardIds(i) then
				table.insert(tbIdx, i)
			end
		end
		for k, v in pairs(self.rewardIds) do
			if v == 0 then
				self.rewardIds[k] = table.remove(tbIdx)
			end
		end
	end
end
function beachTreasureCtrl:getLottoryTimes()
	return self.lottoryTimes
end
function beachTreasureCtrl:getRewardIds()
	return self.rewardIds
end
function beachTreasureCtrl:isInRewardIds(idx)
	local ret = false
	local rewardId
	for k, v in pairs(self.rewardIds) do
		if v == idx then
			ret = true
			rewardId = tonumber(k)
			break
		end
	end
	return ret, rewardId
end
function beachTreasureCtrl:isRewarded(idx)
	return self.rewardIds[tostring(idx)] or false
end
function beachTreasureCtrl:isGotGrandPrizes()
	local treasureBeachRead = include("treasureBeachRead")
	local gIdx = treasureBeachRead.getGrandPrizesIdx()
	return self.rewardIds[tostring(gIdx)]
end
function beachTreasureCtrl:getReceiveStatusAndNum(...)
	local constantRead = include("constantRead")
	local costItemID = constantRead.getConstValue("TREASURE_BEACH_ITEM")
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local itemCount = backpackCtrl:getItemCount(costItemID)
	if itemCount >= constantRead.getConstValue("TREASURE_BEACH_NUM2", 7) then
		return true, -1
	end
	return false, 0
end
return beachTreasureCtrl

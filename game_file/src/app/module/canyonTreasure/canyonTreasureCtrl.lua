local gametop = gModuleMgr.getObject("gametop")
local GameModule = include("GameModule")
local canyonTreasureCtrl = class("canyonTreasureCtrl", GameModule)
local msgCtrl = include("msgCtrl")
local serverproxy = gModuleMgr.getObject("serverproxy")
function canyonTreasureCtrl:ctor(properties)
	canyonTreasureCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.RAIDERS_LOST_ARK
end
function canyonTreasureCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_CANYON_TREASURE_MODULE, gCmd.REQ_CANYON_TREASURE_INIT, handler(self, self.reqInitDataRsp))
	msgCtrl.register(gCmd.CMD_CANYON_TREASURE_MODULE, gCmd.REQ_CANYON_TREASURE_OPT_REWARD, handler(self, self.reqOptionalRewardRsp))
	msgCtrl.register(gCmd.CMD_CANYON_TREASURE_MODULE, gCmd.REQ_CANYON_TREASURE_LOTTORY, handler(self, self.reqLotteryRsp))
	self:resetData()
end
function canyonTreasureCtrl:resetData()
	self.clientData = nil
	self.huntData = nil
	self.commonData = nil
end
function canyonTreasureCtrl:Logout()
	self:resetData()
	canyonTreasureCtrl.super.Logout(self)
end
function canyonTreasureCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.CANYPON_TREASURE, handler(self, self.notifyHandler))
end
function canyonTreasureCtrl:notifyHandler(event)
	dump(event.data, "canyonTreasureCtrl:notifyHandler event.data", 10)
	for _, content in pairs(event.data) do
	end
end
function canyonTreasureCtrl:reqInitData()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_CANYON_TREASURE_MODULE, gCmd.REQ_CANYON_TREASURE_INIT, data)
end
function canyonTreasureCtrl:reqOptionalReward(canyonTreasureType, optinalRewards)
	serverproxy = nil
	;(nil).canyonTreasureType = canyonTreasureType
	local (nil).optinalRewards, data = optinalRewards, nil
	serverproxy:Request(gCmd.CMD_CANYON_TREASURE_MODULE, gCmd.REQ_CANYON_TREASURE_OPT_REWARD, data)
end
function canyonTreasureCtrl:reqLottery(canyonTreasureType, times, isDiscount)
	serverproxy = nil
	;(nil).canyonTreasureType = canyonTreasureType
	;(nil).times = times
	local (nil).isDiscount, data = isDiscount, nil
	serverproxy:Request(gCmd.CMD_CANYON_TREASURE_MODULE, gCmd.REQ_CANYON_TREASURE_LOTTORY, data)
end
function canyonTreasureCtrl:reqInitDataRsp(content)
	dump(content, "canyonTreasureCtrl:reqInitDataRsp===", 10)
	if content.err == gErrDef.Err_None then
		self.clientData = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_CANYON_TREASURE_INIT"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function canyonTreasureCtrl:reqOptionalRewardRsp(content)
	dump(content, "canyonTreasureCtrl:reqOptionalRewardRsp===", 10)
	if content.err == gErrDef.Err_None then
		local optinalRewards = content.rspdata.treasureData.optinalRewards
		local optTimes = content.rspdata.treasureData.optTimes
		if content.rspdata.canyonTreasureType == gCanyonTreasureHuntType.NORMAL then
			self.clientData.normal.optinalRewards = optinalRewards
			self.clientData.normal.optTimes = optTimes
		else
			self.clientData.senior.optinalRewards = optinalRewards
			self.clientData.senior.optTimes = optTimes
		end
		_ENV = gCanyonTreasureHuntType.NORMAL
		gCanyonTreasureHuntType.NORMAL.msg = "MESSAGE_SERVER_CANYON_TREASURE_OPTIONAL_REFRESH"
		SoraDSendMessage(gCanyonTreasureHuntType.NORMAL)
	end
end
function canyonTreasureCtrl:reqLotteryRsp(content)
	dump(content, "canyonTreasureCtrl:reqLotteryRsp===", 10)
	SoraDCloseLoading()
	if content.err == gErrDef.Err_None then
		self.commonData = content.rspdata
		self.huntData = content.data
		if content.data.canyonTreasureType == gCanyonTreasureHuntType.NORMAL then
			if not self.clientData.normal[tostring(1)] then
				self.clientData.normal[tostring(1)], _ENV = 1, 1
			end
			self.clientData.normal[tostring(1)].discount = content.rspdata.discount
			self.clientData.normal[tostring(1)].endTime = content.rspdata.endTime
			self.clientData.normal[tostring(1)].rewards = content.rspdata.rewards
			if content.data.times == 1 then
				self.clientData.normal.isFreeUsed = false
			end
		else
			if not self.clientData.senior[tostring(1)] then
				self.clientData.senior[tostring(1)], _ENV = 1, 1
			end
			self.clientData.senior[tostring(1)].discount = content.rspdata.discount
			self.clientData.senior[tostring(1)].endTime = content.rspdata.endTime
			self.clientData.senior[tostring(1)].rewards = content.rspdata.rewards
		end
		_ENV = content.rspdata.rewards
		content.rspdata.rewards.msg = "MESSAGE_SERVER_CANYON_TREASURE_HUNT_BACK"
		SoraDSendMessage(content.rspdata.rewards)
	end
end
function canyonTreasureCtrl:getHuntData()
	if self.huntData then
		return self.huntData
	end
end
function canyonTreasureCtrl:getCommonData()
	if self.commonData then
		return self.commonData
	end
end
function canyonTreasureCtrl:getOptinalRewardsByType(ctype)
	if not self.clientData or not next(self.clientData) then
		_ENV = next(self.clientData)
		return (next(self.clientData))
	end
	if ctype == gCanyonTreasureHuntType.NORMAL then
		if not self.clientData.normal.optinalRewards then
			_ENV = self.clientData.normal.optinalRewards
		end
		return self.clientData.normal.optinalRewards
	else
		if not self.clientData.senior.optinalRewards then
			_ENV = self.clientData.senior.optinalRewards
		end
		return self.clientData.senior.optinalRewards
	end
end
function canyonTreasureCtrl:getOpTimesByType(ctype)
	if not self.clientData or not next(self.clientData) then
		_ENV = next(self.clientData)
		return (next(self.clientData))
	end
	if ctype == gCanyonTreasureHuntType.NORMAL then
		return self.clientData.normal.optTimes or 0
	else
		return self.clientData.senior.optTimes or 0
	end
end
function canyonTreasureCtrl:getDisCountByType(ctype, times)
	if not self.clientData or not next(self.clientData) then
		_ENV = next(self.clientData)
		return (next(self.clientData))
	end
	local discount = 100
	if ctype == gCanyonTreasureHuntType.NORMAL then
		if self.clientData.normal[tostring(1)] and self.clientData.normal[tostring(1)].discount then
			discount = self.clientData.normal[tostring(1)].discount
		end
	elseif self.clientData.senior[tostring(1)] and self.clientData.senior[tostring(1)].discount then
		discount = self.clientData.senior[tostring(1)].discount
	end
	return discount
end
function canyonTreasureCtrl:getEndTimeByType(ctype, times)
	if not self.clientData or not next(self.clientData) then
		_ENV = next(self.clientData)
		return (next(self.clientData))
	end
	local endTime = 0
	if ctype == gCanyonTreasureHuntType.NORMAL then
		if self.clientData.normal[tostring(1)] and self.clientData.normal[tostring(1)].endTime then
			endTime = self.clientData.normal[tostring(1)].endTime
		end
	elseif self.clientData.senior[tostring(1)] and self.clientData.senior[tostring(1)].endTime then
		endTime = self.clientData.senior[tostring(1)].endTime
	end
	return endTime
end
function canyonTreasureCtrl:isFreeUsed()
	local isFreeUsed = true
	if self.clientData and self.clientData.normal.isFreeUsed == false then
		isFreeUsed = self.clientData.normal.isFreeUsed
	end
	return isFreeUsed
end
return canyonTreasureCtrl

local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001563_Ctrl = class("activity_9001563_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001563_Ctrl:ctor(properties)
	activity_9001563_Ctrl.super.ctor(self, properties)
	self:resetData()
end
function activity_9001563_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_COMMON_LOTTERY_9001563_MODULE, gCmd.CMD_COMMON_LOTTERY_9001563_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_COMMON_LOTTERY_9001563_MODULE, gCmd.CMD_COMMON_LOTTERY_9001563_LOTTERY, handler(self, self.reqLotteryRsp))
end
function activity_9001563_Ctrl:Logout()
	activity_9001563_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001563_Ctrl:resetData()
	self.initData, _UPVALUE0_ = nil, nil
end
function activity_9001563_Ctrl:sendReqInitDataMsg()
	self:reqInit()
end
function activity_9001563_Ctrl:reqInit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_COMMON_LOTTERY_9001563_MODULE, gCmd.CMD_COMMON_LOTTERY_9001563_INIT, nil)
end
function activity_9001563_Ctrl:reqInitRsp(content)
	dump(content, "activity_9001563_Ctrl:reqInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		if not content.rspdata then
			_ENV = content.rspdata
		end
		self.initData = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001563_UPDATE"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001563_Ctrl:reqLottery()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_COMMON_LOTTERY_9001563_MODULE, gCmd.CMD_COMMON_LOTTERY_9001563_LOTTERY, nil)
end
function activity_9001563_Ctrl:reqLotteryRsp(content)
	dump(content, "activity_9001563_Ctrl:reqLotteryRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		if not content.rspdata.initData then
			_ENV = content.rspdata.initData
		end
		self.initData = content.rspdata.initData
		if not content.rspdata.rewards then
			local _ENV, rewards = content.rspdata.rewards, content.rspdata.rewards
		end
		_ENV = "activity_9001563_Ctrl:reqLotteryRsp(content)"
		;("activity_9001563_Ctrl:reqLotteryRsp(content)").msg = "MESSAGE_ACTIVITY_9001563_UPDATE"
		;("activity_9001563_Ctrl:reqLotteryRsp(content)").rewards = rewards
		SoraDSendMessage("activity_9001563_Ctrl:reqLotteryRsp(content)")
	end
end
function activity_9001563_Ctrl:getLotteryCount(...)
	return self.initData.lotteryCount or 0
end
function activity_9001563_Ctrl:getLotteryRecord(...)
	if not self.initData.lotteryRecord then
		_UPVALUE0_ = self.initData.lotteryRecord
	end
	return self.initData.lotteryRecord
end
function activity_9001563_Ctrl:getIsLottery(order)
	local lotteryRecord = self:getLotteryRecord()
	return lotteryRecord[tostring(order)] == 1
end
function activity_9001563_Ctrl:getReceiveStatusAndNum(...)
	local newLotteryRead = include("newLotteryRead")
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	self.activityID = gActivityTimeActivityID.LOTTERY_ACTIVITY_9001563
	local cfgList = newLotteryRead.getConfig(self.activityID)
	local lotteryRecord = self:getLotteryRecord()
	if table.nums(lotteryRecord) == #cfgList then
		return false, 0
	end
	local itemID = newLotteryRead.getCostItemIDByActivityID(self.activityID)
	if 0 < backpackCtrl:getItemCount(itemID) then
		return true, -1
	end
	return false, 0
end
return activity_9001563_Ctrl

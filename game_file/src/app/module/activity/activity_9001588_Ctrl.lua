local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001588_Ctrl = class("activity_9001588_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001588_Ctrl:ctor(properties)
	activity_9001588_Ctrl.super.ctor(self, properties)
	self:resetData()
	self.activityID = gActivityTimeActivityID.LOTTERY_ACTIVITY_9001588
end
function activity_9001588_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_COMMON_LOTTERY_9001588_MODULE, gCmd.CMD_COMMON_LOTTERY_9001588_INIT, handler(self, self.reqCommonLottery9001588InitRsp))
	msgCtrl.register(gCmd.CMD_COMMON_LOTTERY_9001588_MODULE, gCmd.CMD_COMMON_LOTTERY_9001588_LOTTERY, handler(self, self.reqCommonLottery9001588LotteryRsp))
end
function activity_9001588_Ctrl:Logout()
	activity_9001588_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001588_Ctrl:resetData()
	self.initData, _UPVALUE0_ = nil, nil
end
function activity_9001588_Ctrl:reqCommonLottery9001588Init()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_COMMON_LOTTERY_9001588_MODULE, gCmd.CMD_COMMON_LOTTERY_9001588_INIT, nil)
end
function activity_9001588_Ctrl:reqCommonLottery9001588InitRsp(content)
	dump(content, "activity_9001588_Ctrl:reqCommonLottery9001588InitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001588_UPDATE"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001588_Ctrl:reqCommonLottery9001588Lottery(count)
	serverproxy = nil
	;(nil).count = count
	serverproxy:Request(gCmd.CMD_COMMON_LOTTERY_9001588_MODULE, gCmd.CMD_COMMON_LOTTERY_9001588_LOTTERY, nil)
end
function activity_9001588_Ctrl:reqCommonLottery9001588LotteryRsp(content)
	dump(content, "activity_9001588_Ctrl:reqCommonLottery9001588LotteryRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData = content.rspdata.initData
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001588_UPDATE"
		gErrDef.Err_None.ids = content.rspdata.ids
		gErrDef.Err_None.rewardDetail = content.rspdata.rewardDetail
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001588_Ctrl:getLotteryCount()
	return self.initData and self.initData.lotteryCount or 0
end
function activity_9001588_Ctrl:getLuckyValue()
	return self.initData and self.initData.luckyValue or 0
end
function activity_9001588_Ctrl:isFreeLottery()
	if self.initData and self.initData.isFree then
		return self.initData.isFree == 1
	end
	return false
end
function activity_9001588_Ctrl:getClassType()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	return activityShowCtrl:getParamClassType(self.activityID)
end
function activity_9001588_Ctrl:getReceiveStatusAndNum(...)
	if clientEventMgr.judgeIsOpen(self.activityID) then
		local newLotteryRead = include("newLotteryRead")
		local backpackCtrl = SoraDGetCtrl("backpackCtrl")
		local itemID = newLotteryRead.getCostItemIDByActivityID(self.activityID)
		if backpackCtrl:getItemCount(itemID) > 0 then
			return true, -1
		end
	end
	return false, 0
end
return activity_9001588_Ctrl

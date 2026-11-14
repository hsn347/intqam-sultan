local newLotteryRead = include("newLotteryRead")
local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local DesertMiningCtrl = class("DesertMiningCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function DesertMiningCtrl:ctor(properties)
	DesertMiningCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.LOTTERY_ACTIVITY_9001545
	self:resetData()
end
function DesertMiningCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_COMMON_LOTTERY_9001545_MODULE, gCmd.CMD_COMMON_LOTTERY_9001545_INIT, handler(self, self.reqCommonLottery9001545InitRsp))
	msgCtrl.register(gCmd.CMD_COMMON_LOTTERY_9001545_MODULE, gCmd.CMD_COMMON_LOTTERY_9001545_LOTTERY, handler(self, self.reqCommonLottery9001545LotteryRsp))
	msgCtrl.register(gCmd.CMD_COMMON_LOTTERY_9001545_MODULE, gCmd.CMD_COMMON_LOTTERY_9001545_STAGE_REWARD, handler(self, self.reqCommonLottery9001545StageRewardRsp))
end
function DesertMiningCtrl:Logout()
	DesertMiningCtrl.super.Logout(self)
	self:resetData()
end
function DesertMiningCtrl:resetData()
	self.initData, _UPVALUE0_ = nil, nil
end
function DesertMiningCtrl:sendReqInitDataMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_COMMON_LOTTERY_9001545_MODULE, gCmd.CMD_COMMON_LOTTERY_9001545_INIT, nil)
end
function DesertMiningCtrl:reqCommonLottery9001545InitRsp(content)
	dump(content, "DesertMiningCtrl:reqCommonLottery9001545InitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001545_UPDATE"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function DesertMiningCtrl:reqCommonLottery9001545Lottery(count)
	serverproxy = nil
	;(nil).count = count
	serverproxy:Request(gCmd.CMD_COMMON_LOTTERY_9001545_MODULE, gCmd.CMD_COMMON_LOTTERY_9001545_LOTTERY, nil)
end
function DesertMiningCtrl:reqCommonLottery9001545LotteryRsp(content)
	dump(content, "DesertMiningCtrl:reqCommonLottery9001545LotteryRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData = content.rspdata.initData
		_ENV = 10
		;(10).reward = content.rspdata.rewards
		uiManager:show("DesertMiningGetReward", 10)
		_ENV = uiManager
		uiManager.msg = "MESSAGE_ACTIVITY_9001545_UPDATE"
		SoraDSendMessage(uiManager)
	end
end
function DesertMiningCtrl:reqCommonLottery9001545StageReward(stageID)
	serverproxy = nil
	;(nil).stageID = stageID
	serverproxy:Request(gCmd.CMD_COMMON_LOTTERY_9001545_MODULE, gCmd.CMD_COMMON_LOTTERY_9001545_STAGE_REWARD, nil)
end
function DesertMiningCtrl:reqCommonLottery9001545StageRewardRsp(content)
	dump(content, "DesertMiningCtrl:reqCommonLottery9001545StageRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData = content.rspdata.initData
		SoraDMailGainItems(content.rspdata.rewards, true)
		_ENV = content.rspdata.rewards
		content.rspdata.rewards.msg = "MESSAGE_ACTIVITY_9001545_UPDATE"
		SoraDSendMessage(content.rspdata.rewards)
	end
end
function DesertMiningCtrl:getLotteryCount()
	return self.initData and self.initData.lotteryCount or 0
end
function DesertMiningCtrl:getStageStatus(stageIndx, num)
	if self.initData and self.initData.stageRecord and self.initData.stageRecord[tostring(stageIndx)] then
		return gBtnTargetStatusDef.GOT
	end
	if num <= self:getLotteryCount() then
		return gBtnTargetStatusDef.GET
	end
	return gBtnTargetStatusDef.GO
end
function DesertMiningCtrl:isFreeLottery()
	if self.initData and self.initData.isFree then
		return self.initData.isFree == 1
	end
	return false
end
function DesertMiningCtrl:getClassType()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	return activityShowCtrl:getParamClassType(self.activityID)
end
function DesertMiningCtrl:getReceiveStatusAndNum()
	local config = newLotteryRead.getStageConfig(self.activityID, self:getClassType())
	for i, v in ipairs(config) do
		if self:getStageStatus(v.stage, v.num) == gBtnTargetStatusDef.GET then
			return true, -1
		end
	end
	local itemID = newLotteryRead.getCostItemIDByActivityID(self.activityID)
	if SoraDGetCtrl("backpackCtrl"):getItemCount(itemID) > 0 then
		return true, -1
	end
	return false, 0
end
return DesertMiningCtrl

local newLotteryRead = include("newLotteryRead")
local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local happyEggCtrl = class("happyEggCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function happyEggCtrl:ctor(properties)
	happyEggCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.LOTTERY_ACTIVITY_9001544
	self:resetData()
end
function happyEggCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_COMMON_LOTTERY_9001544_MODULE, gCmd.CMD_COMMON_LOTTERY_9001544_INIT, handler(self, self.reqCommonLottery9001544InitRsp))
	msgCtrl.register(gCmd.CMD_COMMON_LOTTERY_9001544_MODULE, gCmd.CMD_COMMON_LOTTERY_9001544_SELECT, handler(self, self.reqCommonLottery9001544SelectRsp))
	msgCtrl.register(gCmd.CMD_COMMON_LOTTERY_9001544_MODULE, gCmd.CMD_COMMON_LOTTERY_9001544_LOTTERY, handler(self, self.reqCommonLottery9001544LotteryRsp))
	msgCtrl.register(gCmd.CMD_COMMON_LOTTERY_9001544_MODULE, gCmd.CMD_COMMON_LOTTERY_9001544_STAGE_REWARD, handler(self, self.reqCommonLottery9001544StageRewardRsp))
end
function happyEggCtrl:Logout()
	happyEggCtrl.super.Logout(self)
	self:resetData()
end
function happyEggCtrl:resetData()
	self.initData, _UPVALUE0_ = nil, nil
end
function happyEggCtrl:sendReqInitDataMsg()
	if SoraDGetCtrl("activityCenterUICtrl"):isHaveNewFlag(self.activityID) then
		_ENV = self.activityID
		self:saveChoosList(self.activityID)
	end
	_ENV = nil
	serverproxy:Request(gCmd.CMD_COMMON_LOTTERY_9001544_MODULE, gCmd.CMD_COMMON_LOTTERY_9001544_INIT, nil)
end
function happyEggCtrl:reqCommonLottery9001544InitRsp(content)
	dump(content, "happyEggCtrl:reqCommonLottery9001544InitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001544_UPDATE"
		gErrDef.Err_None.subMsg = "init"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function happyEggCtrl:reqCommonLottery9001544Select(indexAry)
	serverproxy = nil
	;(nil).indexAry = indexAry
	serverproxy:Request(gCmd.CMD_COMMON_LOTTERY_9001544_MODULE, gCmd.CMD_COMMON_LOTTERY_9001544_SELECT, nil)
end
function happyEggCtrl:reqCommonLottery9001544SelectRsp(content)
	dump(content, "happyEggCtrl:reqCommonLottery9001544SelectRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData = content.rspdata.initData
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001544_UPDATE"
		gErrDef.Err_None.subMsg = "select"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function happyEggCtrl:reqCommonLottery9001544Lottery()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_COMMON_LOTTERY_9001544_MODULE, gCmd.CMD_COMMON_LOTTERY_9001544_LOTTERY, nil)
end
function happyEggCtrl:reqCommonLottery9001544LotteryRsp(content)
	dump(content, "happyEggCtrl:reqCommonLottery9001544LotteryRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData = content.rspdata.initData
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001544_UPDATE"
		gErrDef.Err_None.subMsg = "lottery"
		gErrDef.Err_None.position = content.rspdata.lotteryIndex
		gErrDef.Err_None.reward = content.rspdata.rewards
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function happyEggCtrl:reqCommonLottery9001544StageReward(stageID)
	serverproxy = nil
	;(nil).stageID = stageID
	serverproxy:Request(gCmd.CMD_COMMON_LOTTERY_9001544_MODULE, gCmd.CMD_COMMON_LOTTERY_9001544_STAGE_REWARD, nil)
end
function happyEggCtrl:reqCommonLottery9001544StageRewardRsp(content)
	dump(content, "happyEggCtrl:reqCommonLottery9001544StageRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData = content.rspdata.initData
		SoraDMailGainItems(content.rspdata.rewards, true)
		SoraDShowMsgTip(i18n("Outstanding_text_07"))
		_ENV = i18n("Outstanding_text_07")
		i18n("Outstanding_text_07").msg = "MESSAGE_ACTIVITY_9001544_UPDATE"
		SoraDSendMessage(i18n("Outstanding_text_07"))
	end
end
function happyEggCtrl:getClassType()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	return activityShowCtrl:getParamClassType(self.activityID)
end
function happyEggCtrl:getReceiveStatusAndNum()
	local itemID = newLotteryRead.getCostItemIDByActivityID(self.activityID)
	local costNum = newLotteryRead.getCostNum(self.activityID, self:getRoundLotteryCount())
	if costNum <= SoraDGetCtrl("backpackCtrl"):getItemCount(itemID) then
		return true, -1
	end
	local config = newLotteryRead.getStageConfig(self.activityID, self:getClassType())
	for i, v in ipairs(config) do
		if self:getStageStatus(v.stage, v.num) == gBtnTargetStatusDef.GET then
			return true, -1
		end
	end
	return false, 0
end
function happyEggCtrl:getLotteryCount()
	return self.initData and self.initData.lotteryCount or 0
end
function happyEggCtrl:getRoundLotteryCount()
	local tmp = self:getPrizePoolTbl()
	local num = 0
	for i, v in ipairs(tmp) do
		if v.get == 1 then
			num = num + 1
		end
	end
	return num
end
function happyEggCtrl:saveChoosList(chooseIndex)
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:happyEggCtrl:chooseIndex~table", chooseIndex, nil)
	self.chooseIndexList = chooseIndex
end
function happyEggCtrl:isItemSelected(index)
	_ENV = nil
	;(nil).byUID = true
	if not SoraDConfigGet("Game:happyEggCtrl:chooseIndex~table", nil) then
		_ENV = SoraDConfigGet("Game:happyEggCtrl:chooseIndex~table", nil)
	end
	self.chooseIndexList = SoraDConfigGet("Game:happyEggCtrl:chooseIndex~table", nil)
	dump(self.chooseIndexList, "chooseIndexList")
	for i, v in ipairs(self.chooseIndexList) do
		if v == index then
			return true
		end
	end
	return false
end
function happyEggCtrl:getStageStatus(stageIndx, num)
	if self.initData and self.initData.stageRecord and self.initData.stageRecord[tostring(stageIndx)] then
		return gBtnTargetStatusDef.GOT
	end
	if num <= self:getLotteryCount() then
		return gBtnTargetStatusDef.GET
	end
	return gBtnTargetStatusDef.GO
end
function happyEggCtrl:getLeftResetCont()
	local max = self:getMaxResetCount()
	return max - (self.initData and self.initData.resetCount or 0)
end
function happyEggCtrl:getMaxResetCount()
	return include("constantRead").getConstValue("LAMP_SECRET_DAYLY_MAX_RESET", 100)
end
function happyEggCtrl:getPrizePoolTbl()
	if not self.initData or not self.initData.pool then
		_UPVALUE0_ = self.initData.pool
	end
	return self.initData.pool
end
function happyEggCtrl:isFirstChoose()
	if not self.initData or not self.initData.pool then
		local _ENV, tmp = self.initData.pool, self.initData.pool
	end
	return table.nums(tmp) == 0
end
function happyEggCtrl:isAllPoolGot()
	local tmp = self:getPrizePoolTbl()
	local num = 0
	for i, v in ipairs(tmp) do
		if v.get == 1 then
			num = num + 1
		end
	end
	return num == 8
end
function happyEggCtrl:isCanReset()
	local tmp = self:getPrizePoolTbl()
	if tmp[8] and tmp[8].get == 1 or tmp[7] and tmp[7].get == 1 then
		return true
	end
	return false
end
return happyEggCtrl

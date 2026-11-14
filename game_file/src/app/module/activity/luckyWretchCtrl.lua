local luckyWretchRead = include("luckyWretchRead")
local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local luckyWretchCtrl = class("luckyWretchCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function luckyWretchCtrl:ctor(properties)
	luckyWretchCtrl.super.ctor(self, properties)
	self:resetData()
	self.activityID = gActivityTimeActivityID.LUCKY_WRETCH_ACTIVITY
end
function luckyWretchCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_LUCKY_WRETCH_MODULE, gCmd.REQ_LUCKY_WRETCH_INIT, handler(self, self.reqLuckyWretchInitRsp))
	msgCtrl.register(gCmd.CMD_LUCKY_WRETCH_MODULE, gCmd.REQ_LUCKY_WRETCH_LOTTERY, handler(self, self.reqLuckyWretchLotteryRsp))
	msgCtrl.register(gCmd.CMD_LUCKY_WRETCH_MODULE, gCmd.REQ_LUCKY_WRETCH_LOTTERY_TEN, handler(self, self.reqLuckyWretchLotteryTenRsp))
	msgCtrl.register(gCmd.CMD_LUCKY_WRETCH_MODULE, gCmd.REQ_LUCKY_WRETCH_STAGE_REWARD, handler(self, self.reqLuckyWretchStageRewardRsp))
	self:registerNotify()
end
function luckyWretchCtrl:Logout()
	luckyWretchCtrl.super.Logout(self)
	self:resetData()
end
function luckyWretchCtrl:resetData()
	self.stageReward, _UPVALUE0_, self.lottoryTimes = nil, nil, 0
end
function luckyWretchCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.LUCKY_WRETCH, handler(self, self.notifyHandler))
end
function luckyWretchCtrl:notifyHandler(event)
	dump(event.data, "luckyWretchCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		if v.notifyType == "refreshData" then
			self.lottoryTimes = v.notifyData.lottoryTimes
			self.stageReward = v.notifyData.stageReward
			_ENV = nil
			;(nil).msg = "MESSAGE_ACTIVITY_9001494_UPDATE"
			;(nil).subMsg = "init"
			SoraDSendMessage(nil)
		end
	end
end
function luckyWretchCtrl:reqLuckyWretchInit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_LUCKY_WRETCH_MODULE, gCmd.REQ_LUCKY_WRETCH_INIT, nil)
end
function luckyWretchCtrl:reqLuckyWretchInitRsp(content)
	dump(content, "luckyWretchCtrl:reqLuckyWretchInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.lottoryTimes = content.rspdata.lottoryTimes
		self.stageReward = content.rspdata.stageReward
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001494_UPDATE"
		gErrDef.Err_None.subMsg = "init"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function luckyWretchCtrl:reqLuckyWretchLottery()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_LUCKY_WRETCH_MODULE, gCmd.REQ_LUCKY_WRETCH_LOTTERY, nil)
end
function luckyWretchCtrl:reqLuckyWretchLotteryRsp(content)
	dump(content, "luckyWretchCtrl:reqLuckyWretchLotteryRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local grade = content.rspdata.grade
		self.lottoryTimes = content.rspdata.lottoryTimes
		_ENV = nil
		;(nil).itemType = 1
		;(nil).rewards = content.rspdata.reward
		uiManager:show("CommonCongratulations", nil)
		_ENV = uiManager
		uiManager.msg = "MESSAGE_ACTIVITY_9001494_UPDATE"
		uiManager.subMsg = "one"
		uiManager.grade = grade
		uiManager.isGold = grade == 1
		SoraDSendMessage(uiManager)
	end
end
function luckyWretchCtrl:reqLuckyWretchLotteryTen()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_LUCKY_WRETCH_MODULE, gCmd.REQ_LUCKY_WRETCH_LOTTERY_TEN, nil)
end
function luckyWretchCtrl:reqLuckyWretchLotteryTenRsp(content)
	dump(content, "luckyWretchCtrl:reqLuckyWretchLotteryTenRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local grade = content.rspdata.grades[1]
		local isGold = false
		for index, value in ipairs(content.rspdata.grades) do
			if value == 1 then
				isGold = true
				grade = 1
			end
		end
		self.lottoryTimes = content.rspdata.lottoryTimes
		local _ENV, rewardList = content.rspdata.lottoryTimes, content.rspdata.lottoryTimes
		for i, v in ipairs(content.rspdata.reward) do
			table.insert(rewardList, v[1])
		end
		_ENV = nil
		;(nil).itemType = 2
		;(nil).rewards = rewardList
		uiManager:show("CommonCongratulations", nil)
		_ENV = uiManager
		uiManager.msg = "MESSAGE_ACTIVITY_9001494_UPDATE"
		uiManager.subMsg = "ten"
		uiManager.grade = grade
		uiManager.isGold = isGold
		SoraDSendMessage(uiManager)
	end
end
function luckyWretchCtrl:reqLuckyWretchStageReward(stage)
	serverproxy = nil
	;(nil).stage = stage
	serverproxy:Request(gCmd.CMD_LUCKY_WRETCH_MODULE, gCmd.REQ_LUCKY_WRETCH_STAGE_REWARD, nil)
end
function luckyWretchCtrl:reqLuckyWretchStageRewardRsp(content)
	dump(content, "luckyWretchCtrl:reqLuckyWretchStageRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.stageReward = content.rspdata.stageReward
		SoraDMailGainItems(content.rspdata.reward, true)
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_ACTIVITY_9001494_UPDATE"
		content.rspdata.reward.subMsg = "stage"
		SoraDSendMessage(content.rspdata.reward)
	end
end
function luckyWretchCtrl:getStageStatusByNum(stage, integral)
	local status = self.stageReward[tostring(stage)] or 0
	if status == 1 then
		return gBtnTargetStatusDef.GOT
	elseif integral <= self.lottoryTimes then
		return gBtnTargetStatusDef.GET
	else
		return gBtnTargetStatusDef.GO
	end
end
function luckyWretchCtrl:getReceiveStatusAndNum()
	local ret = 0
	local stageConfig = luckyWretchRead.getStageConfig(self:getClassType())
	for i, v in ipairs(stageConfig) do
		if self:getStageStatusByNum(v.stage, v.donateScore) == gBtnTargetStatusDef.GET then
			ret = ret + 1
		end
	end
	return 0 < ret, ret
end
function luckyWretchCtrl:getLottoryTimes()
	return self.lottoryTimes or 0
end
function luckyWretchCtrl:getClassType()
	return SoraDGetCtrl("activityShowCtrl"):getParamClassType(self.activityID)
end
return luckyWretchCtrl

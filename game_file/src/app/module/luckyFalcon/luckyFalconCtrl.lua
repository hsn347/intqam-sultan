local gametop = gModuleMgr.getObject("gametop")
local GameModule = include("GameModule")
local luckyFalconCtrl = class("luckyFalconCtrl", GameModule)
local msgCtrl = include("msgCtrl")
local serverproxy = gModuleMgr.getObject("serverproxy")
function luckyFalconCtrl:ctor(properties)
	luckyFalconCtrl.super.ctor(self, properties)
end
function luckyFalconCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_LUCKY_FALCON_MODULE, gCmd.REQ_LUCKY_FALCON_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_LUCKY_FALCON_MODULE, gCmd.REQ_LUCKY_FALCON_LOTTERY, handler(self, self.reqLotteryRsp))
	msgCtrl.register(gCmd.CMD_LUCKY_FALCON_MODULE, gCmd.REQ_LUCKY_FALCON_LOTTERY_TEN, handler(self, self.reqTenLotteryRsp))
	msgCtrl.register(gCmd.CMD_LUCKY_FALCON_MODULE, gCmd.REQ_LUCKY_FALCON_STAGE_REWARD, handler(self, self.reqGetStageRewardRsp))
	self:resetData()
	self:registerNotify()
	self:reqInitInfo()
end
function luckyFalconCtrl:initClientData(data)
	if not data then
		return
	end
end
function luckyFalconCtrl:resetData()
	self.clientData = nil
end
function luckyFalconCtrl:Logout()
	self:resetData()
	luckyFalconCtrl.super.Logout(self)
end
function luckyFalconCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.LUCKY_FALCON, handler(self, self.notifyHandler))
end
function luckyFalconCtrl:notifyHandler(event)
	dump(event.data, "luckyFalconCtrl:notifyHandler event.data", 10)
	for _, content in pairs(event.data) do
		dump(content, "luckyFalconCtrl")
		if content.type == "refreshData" then
		end
	end
end
function luckyFalconCtrl:reqInitInfo()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_LUCKY_FALCON_MODULE, gCmd.REQ_LUCKY_FALCON_INIT, data)
end
function luckyFalconCtrl:reqLottery()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_LUCKY_FALCON_MODULE, gCmd.REQ_LUCKY_FALCON_LOTTERY, data)
end
function luckyFalconCtrl:reqTenLottery()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_LUCKY_FALCON_MODULE, gCmd.REQ_LUCKY_FALCON_LOTTERY_TEN, data)
end
function luckyFalconCtrl:reqGetStageReward(stage)
	serverproxy = nil
	local (nil).stage, data = stage, nil
	serverproxy:Request(gCmd.CMD_LUCKY_FALCON_MODULE, gCmd.REQ_LUCKY_FALCON_STAGE_REWARD, data)
end
function luckyFalconCtrl:reqInitRsp(content)
	dump(content, "luckyFalconCtrl:reqInitRsp===", 10)
	if content.err == gErrDef.Err_None then
		self.clientData = content.rspdata
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_LUCKY_FALCON_INIT"
	SoraDSendMessage(gErrDef.Err_None)
end
function luckyFalconCtrl:reqLotteryRsp(content)
	dump(content, "luckyFalconCtrl:reqLotteryRsp===", 10)
	local isFirstLottery = false
	if content.err == gErrDef.Err_None then
		if self.clientData.lottoryTimes then
			if self.clientData.lottoryTimes == 0 and 0 < content.rspdata.lottoryTimes then
				isFirstLottery = true
			end
			self.clientData.lottoryTimes = content.rspdata.lottoryTimes
		end
		_ENV = content.rspdata.lottoryTimes
		content.rspdata.lottoryTimes.msg = "MESSAGE_LUCKY_FALCON_ROTTERY_REFRESH"
		content.rspdata.lottoryTimes.rewardList = content.rspdata.reward
		content.rspdata.lottoryTimes.isFirstLottery = isFirstLottery
		SoraDSendMessage(content.rspdata.lottoryTimes)
	end
	_ENV = content.rspdata.lottoryTimes
	content.rspdata.lottoryTimes.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	content.rspdata.lottoryTimes.eventID = gActivityTimeActivityID.LUCKY_FALCON
	SoraDSendMessage(content.rspdata.lottoryTimes)
end
function luckyFalconCtrl:reqTenLotteryRsp(content)
	dump(content, "luckyFalconCtrl:reqTenLotteryRsp===", 10)
	local isFirstLottery = false
	if content.err == gErrDef.Err_None and self.clientData.lottoryTimes then
		if self.clientData.lottoryTimes == 0 and 0 < content.rspdata.lottoryTimes then
			isFirstLottery = true
		end
		self.clientData.lottoryTimes = content.rspdata.lottoryTimes
	end
	_ENV = content.rspdata.lottoryTimes
	content.rspdata.lottoryTimes.msg = "MESSAGE_LUCKY_FALCON_ROTTERY_REFRESH"
	content.rspdata.lottoryTimes.rewardList = content.rspdata.reward
	content.rspdata.lottoryTimes.isFirstLottery = isFirstLottery
	SoraDSendMessage(content.rspdata.lottoryTimes)
	_ENV = content.rspdata.lottoryTimes
	content.rspdata.lottoryTimes.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	content.rspdata.lottoryTimes.eventID = gActivityTimeActivityID.LUCKY_FALCON
	SoraDSendMessage(content.rspdata.lottoryTimes)
end
function luckyFalconCtrl:reqGetStageRewardRsp(content)
	dump(content, "luckyFalconCtrl:reqGetStageRewardRsp===", 10)
	if content.err == gErrDef.Err_None then
		if content.rspdata.reward then
			SoraDMailGainItems(content.rspdata.reward, true)
		end
		if self.clientData.stageReward then
			self.clientData.stageReward = content.rspdata.stageReward
		end
	end
	_ENV = content.rspdata.stageReward
	content.rspdata.stageReward.msg = "MESSAGE_LUCKY_FALCON_STAGE_REFRESH"
	SoraDSendMessage(content.rspdata.stageReward)
	_ENV = content.rspdata.stageReward
	content.rspdata.stageReward.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	content.rspdata.stageReward.eventID = gActivityTimeActivityID.LUCKY_FALCON
	SoraDSendMessage(content.rspdata.stageReward)
end
function luckyFalconCtrl:getReceiveStatusAndNum(activityID)
	local show, num = false, -1
	if activityID == gActivityTimeActivityID.LUCKY_FALCON then
		local backpackCtrl = SoraDGetCtrl("backpackCtrl")
		local itemCount = backpackCtrl:getItemCount(836101)
		local unGetRewardNum = self:getUnGetStageRewardNum()
		if 0 < itemCount or 0 < unGetRewardNum then
			show = true
		end
	end
	return show, num
end
function luckyFalconCtrl:getRotteryTimes()
	local lottoryTimes = 0
	if self.clientData and self.clientData.lottoryTimes then
		lottoryTimes = self.clientData.lottoryTimes
	end
	return lottoryTimes
end
function luckyFalconCtrl:isStageRewardGot(stage)
	local isGot = false
	if self.clientData and self.clientData.stageReward and self.clientData.stageReward[tostring(stage)] then
		isGot = true
	end
	return isGot
end
function luckyFalconCtrl:getClassType()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local param = activityShowCtrl:getParamByID(gActivityTimeActivityID.LUCKY_FALCON)
	return param.classtype
end
function luckyFalconCtrl:getUnGetStageRewardNum()
	local classType = self:getClassType()
	local luckyFalconRead = include("luckyFalconRead")
	local rotteryTimes = self:getRotteryTimes()
	local unGetRewardNum = 0
	if classType ~= 0 then
		local rewardInfo = luckyFalconRead.getRewardInfo(classType)
		for i, v in ipairs(rewardInfo) do
			local isGot = self:isStageRewardGot(i)
			if rotteryTimes >= v.lotteryTime and not isGot then
				unGetRewardNum = unGetRewardNum + 1
			end
		end
	end
	return unGetRewardNum
end
return luckyFalconCtrl

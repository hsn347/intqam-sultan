local gametop = gModuleMgr.getObject("gametop")
local GameModule = include("GameModule")
local princeGiftCtrl = class("princeGiftCtrl", GameModule)
local msgCtrl = include("msgCtrl")
local serverproxy = gModuleMgr.getObject("serverproxy")
function princeGiftCtrl:ctor(properties)
	princeGiftCtrl.super.ctor(self, properties)
end
function princeGiftCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_PRINCE_GIFT_MODULE, gCmd.PRINCE_GIFT_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_PRINCE_GIFT_MODULE, gCmd.PRINCE_GIFT_BUY, handler(self, self.reqBuyPackageRsp))
	msgCtrl.register(gCmd.CMD_PRINCE_GIFT_MODULE, gCmd.PRINCE_GIFT_RECEIVE, handler(self, self.reqGetRewardRsp))
	msgCtrl.register(gCmd.CMD_PRINCE_GIFT_MODULE, gCmd.PRINCE_GIFT_RECEIVEALL, handler(self, self.reqGetAllRewardRsp))
	msgCtrl.register(gCmd.CMD_PRINCE_GIFT_MODULE, gCmd.PRINCE_GIFT_GUIDE, handler(self, self.reqFinishGuideRsp))
	self:resetData()
	self:registerNotify()
	self:reqInitInfo()
end
function princeGiftCtrl:initClientData(data)
	if not data then
		return
	end
end
function princeGiftCtrl:resetData()
	self.clientData = nil
end
function princeGiftCtrl:Logout()
	self:resetData()
	princeGiftCtrl.super.Logout(self)
end
function princeGiftCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.PRINCE_GIFT, handler(self, self.notifyHandler))
end
function princeGiftCtrl:notifyHandler(event)
	dump(event.data, "princeGiftCtrl:notifyHandler event.data", 10)
	for _, content in pairs(event.data) do
		dump(content, "slkdfjlskdjf")
		if content.type == "buyGift" then
			local score = content.data and content.data.phaseInfo2 and content.data.phaseInfo2.score or 0
			local lastScore = self.clientData and self.clientData.phaseInfo2 and self.clientData.phaseInfo2.score or 0
			self:setLastScore(lastScore, score)
			self.clientData = content.data
			_ENV = self
			self.msg = "MESSAGE_PRINCE_GIFT_BUY_PACKAGE"
			SoraDSendMessage(self)
			_ENV = self
			self.msg = "MESSAGE_PRINCE_GIFT_GUIDE_REFRESH"
			SoraDSendMessage(self)
		elseif content.type == "refresh" then
			self.clientData = content.data
		end
		_ENV = 0
		;(0).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		;(0).eventID = gActivityTimeActivityID.ORIENT_PRINCE_GIFT
		SoraDSendMessage(0)
	end
end
function princeGiftCtrl:reqInitInfo()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_PRINCE_GIFT_MODULE, gCmd.PRINCE_GIFT_INIT, data)
end
function princeGiftCtrl:reqBuyPackage(rechargeID)
	serverproxy = nil
	local (nil).rechargeID, data = rechargeID, nil
	serverproxy:Request(gCmd.CMD_PRINCE_GIFT_MODULE, gCmd.PRINCE_GIFT_BUY, data)
end
function princeGiftCtrl:reqGetReward(lv, claimType)
	serverproxy = nil
	;(nil).lv = lv
	local (nil).claimType, data = claimType, nil
	serverproxy:Request(gCmd.CMD_PRINCE_GIFT_MODULE, gCmd.PRINCE_GIFT_RECEIVE, data)
end
function princeGiftCtrl:reqGetAllReward()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_PRINCE_GIFT_MODULE, gCmd.PRINCE_GIFT_RECEIVEALL, data)
end
function princeGiftCtrl:reqFinishGuide()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_PRINCE_GIFT_MODULE, gCmd.PRINCE_GIFT_GUIDE, data)
end
function princeGiftCtrl:reqInitRsp(content)
	dump(content, "princeGiftCtrl:reqInitRsp===", 10)
	if content.err == gErrDef.Err_None then
		local score = content.rspdata and content.rspdata.phaseInfo2 and content.rspdata.phaseInfo2.score or 0
		local lastScore = self.clientData and self.clientData.phaseInfo2 and self.clientData.phaseInfo2.score or 0
		self:setLastScore(lastScore, score)
		self.clientData = content.rspdata
		_ENV = self
		self.msg = "MESSAGE_PRINCE_GIFT_INIT"
		SoraDSendMessage(self)
	end
end
function princeGiftCtrl:reqBuyPackageRsp(content)
	dump(content, "princeGiftCtrl:reqBuyPackageRsp===", 10)
	if content.err == gErrDef.Err_None then
		local orderID = content.rspdata.orderID
		paymentManager.purchase(content.data.rechargeID, orderID)
	elseif content.err == gErrDef.Err_ILLEGAL_PARAMS then
		SoraDShowMsgTip(i18n("recharge_gift_config_seven_text_13"))
	end
end
function princeGiftCtrl:reqGetRewardRsp(content)
	dump(content, "princeGiftCtrl:reqGetRewardRsp===", 10)
	if content.err == gErrDef.Err_None then
		if content.rspdata.reward then
			SoraDMailGainItems(content.rspdata.reward, true)
		end
		self.clientData = content.rspdata.data
		local isGotReward = self:getReceiveStatusAndNum(gActivityTimeActivityID.ORIENT_PRINCE_GIFT)
		_ENV = gActivityTimeActivityID.ORIENT_PRINCE_GIFT
		gActivityTimeActivityID.ORIENT_PRINCE_GIFT.msg = "MESSAGE_PRINCE_GIFT_GET_REWARD"
		gActivityTimeActivityID.ORIENT_PRINCE_GIFT.isGotReward = isGotReward
		SoraDSendMessage(gActivityTimeActivityID.ORIENT_PRINCE_GIFT)
		_ENV = gActivityTimeActivityID.ORIENT_PRINCE_GIFT
		gActivityTimeActivityID.ORIENT_PRINCE_GIFT.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		gActivityTimeActivityID.ORIENT_PRINCE_GIFT.eventID = gActivityTimeActivityID.ORIENT_PRINCE_GIFT
		SoraDSendMessage(gActivityTimeActivityID.ORIENT_PRINCE_GIFT)
	end
end
function princeGiftCtrl:reqGetAllRewardRsp(content)
	dump(content, "princeGiftCtrl:reqGetAllRewardRsp===", 10)
	if content.err == gErrDef.Err_None then
		if content.rspdata.reward then
			SoraDMailGainItems(content.rspdata.reward, true)
		end
		self.clientData = content.rspdata.data
		local isGotReward = self:getReceiveStatusAndNum(gActivityTimeActivityID.ORIENT_PRINCE_GIFT)
		_ENV = gActivityTimeActivityID.ORIENT_PRINCE_GIFT
		gActivityTimeActivityID.ORIENT_PRINCE_GIFT.msg = "MESSAGE_PRINCE_GIFT_GET_REWARD"
		gActivityTimeActivityID.ORIENT_PRINCE_GIFT.isGotReward = isGotReward
		SoraDSendMessage(gActivityTimeActivityID.ORIENT_PRINCE_GIFT)
		_ENV = gActivityTimeActivityID.ORIENT_PRINCE_GIFT
		gActivityTimeActivityID.ORIENT_PRINCE_GIFT.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		gActivityTimeActivityID.ORIENT_PRINCE_GIFT.eventID = gActivityTimeActivityID.ORIENT_PRINCE_GIFT
		SoraDSendMessage(gActivityTimeActivityID.ORIENT_PRINCE_GIFT)
	end
end
function princeGiftCtrl:reqFinishGuideRsp(content)
	dump(content, "princeGiftCtrl:reqFinishGuideRsp===", 10)
	if content.err == gErrDef.Err_None then
		self.clientData.guide = content.rspdata.guide
		_ENV = content.rspdata.guide
		content.rspdata.guide.msg = "MESSAGE_PRINCE_GIFT_GUIDE_REFRESH"
		SoraDSendMessage(content.rspdata.guide)
	end
end
function princeGiftCtrl:getReceiveStatusAndNum(activityID)
	local show, num = false, -1
	if activityID == gActivityTimeActivityID.ORIENT_PRINCE_GIFT then
		if self:getWhichStage() == 1 then
			local princeGiftRead = include("princeGiftRead")
			local unReceiveNum = princeGiftRead.getTotalUnreceiveRewardNum(self:getCurScore())
			_ENV = self:getCurScore()
			self:getCurScore().byUID = true
			local saveNum = SoraDConfigGet("Game:princeGiftView:rewardNum~integer", self:getCurScore())
			print("skdjflskjflsdkjf", unReceiveNum, saveNum)
			if unReceiveNum > saveNum then
				show = true
			end
		else
			local princeGiftRead = include("princeGiftRead")
			local unReceiveNum = princeGiftRead.getTotalUnreceiveRewardNum(self:getCurScore())
			if 0 < unReceiveNum then
				show = true
			end
		end
	end
	return show, num
end
function princeGiftCtrl:setLastScore(lastScore, score)
	_ENV = nil
	;(nil).byUID = true
	local writeScore = SoraDConfigGet("Game:princeGiftCtrl:score~integer", nil)
	if not writeScore or lastScore == writeScore then
		_ENV = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:princeGiftCtrl:score~integer", score, nil)
	end
end
function princeGiftCtrl:getLastLv()
	local princeGiftRead = include("princeGiftRead")
	_ENV = nil
	;(nil).byUID = true
	local writeScore = SoraDConfigGet("Game:princeGiftCtrl:score~integer", nil) or 0
	print("princeGiftCtrl:getLastLv", writeScore)
	local curLv, targetScore = princeGiftRead.getLevelInfoByScore(writeScore)
	return curLv
end
function princeGiftCtrl:isGuideFinish()
	local isFinished = false
	if self.clientData and self.clientData.guide then
		isFinished = self.clientData.guide
	end
	return isFinished
end
function princeGiftCtrl:getWhichStage()
	local stage = 1
	if self.clientData and self.clientData.phase then
		stage = self.clientData.phase
	end
	return stage
end
function princeGiftCtrl:getCurScore()
	local curScore = 0
	if self.clientData and self.clientData.phaseInfo2 and self.clientData.phaseInfo2.score then
		curScore = self.clientData.phaseInfo2.score
	end
	return curScore
end
function princeGiftCtrl:getFreeReceives()
	local freeReceives
	if self.clientData and self.clientData.phaseInfo2 and self.clientData.phaseInfo2.freeReceives then
		freeReceives = self.clientData.phaseInfo2.freeReceives
	end
	return freeReceives
end
function princeGiftCtrl:getPayReceives()
	local payReceives
	if self.clientData and self.clientData.phaseInfo2 and self.clientData.phaseInfo2.payReceives then
		payReceives = self.clientData.phaseInfo2.payReceives
	end
	return payReceives
end
function princeGiftCtrl:isReceiveReward(claimType, level)
	local isReceived = false
	local commonReceive = self:getFreeReceives()
	if claimType == 2 then
		commonReceive = self:getPayReceives()
	end
	if commonReceive and commonReceive[tostring(level)] then
		isReceived = true
	end
	return isReceived
end
function princeGiftCtrl:getIsBuy()
	local isBuy = false
	if self.clientData and self.clientData.phaseInfo2 and self.clientData.phaseInfo2.isBuy == 1 then
		isBuy = true
	end
	return isBuy
end
function princeGiftCtrl:getBuffEndTime()
	local buffEndTime = 0
	if self.clientData and self.clientData.phaseInfo1 and self.clientData.phaseInfo1.buffEndTime then
		buffEndTime = self.clientData.phaseInfo1.buffEndTime
	end
	return buffEndTime
end
function princeGiftCtrl:isGiftBuy(giftID)
	if giftID == 14140 then
		return self:getWhichStage() == 2
	elseif giftID == 14141 then
		return self:getIsBuy()
	end
end
return princeGiftCtrl

local GameModule = include("GameModule")
local magicHerbCtrl = class("magicHerbCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function magicHerbCtrl:ctor(properties)
	magicHerbCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.MAGIC_HERB_ACTIVITY
end
function magicHerbCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_MAGIC_HERB_IRRIGATE, handler(self, self.reqIrrigateRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_MAGIC_HERB_GET_REWARD, handler(self, self.reqGetRewardRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_MAGIC_HERB_GET_ALL_REWARD, handler(self, self.reqGetAllRewardRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_MAGIC_HERB_BUY_GIFT, handler(self, self.reqBuyGiftRsp))
	self:resetData()
	self:registerNotify()
end
function magicHerbCtrl:resetData()
	_UPVALUE0_ = nil
	;(nil).aid = 0
	;(nil).isFeeRewardUnlock = false
	;(nil).nourishmentCount = 0
	self.data, (nil).feeReward, _UPVALUE0_, (nil).freeReward, _UPVALUE0_, (nil).progress = nil, nil, nil, nil, nil, 0
end
function magicHerbCtrl:resetProgress()
	self.data.progress = 0
end
function magicHerbCtrl:setCurAid()
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	self.data.aid = allianceMgr:getOwnAid() or 0
end
function magicHerbCtrl:initClientData(data)
	if data and data[tostring(self.activityID)] then
		self:setActivityData(data[tostring(self.activityID)])
	end
end
function magicHerbCtrl:setActivityData(data)
	self.data = data
end
function magicHerbCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.MAGIC_HERB_ACTIVITY, handler(self, self.notifyHandler))
end
function magicHerbCtrl:notifyHandler(content)
	dump(content, "magicHerbCtrl:notifyHandler=====", 10)
	local notifydata = content.data
	for _, notifyMsg in ipairs(notifydata) do
		if notifyMsg.notifyType == "nourishmentCount" then
			self.data.nourishmentCount = notifyMsg.notifyData.nourishmentCount
		end
		if notifyMsg.notifyType == "progress" then
			self.data.progress = notifyMsg.notifyData.progress
		end
		if notifyMsg.notifyType == "buyGift" then
			self.data.isFeeRewardUnlock = notifyMsg.notifyData.success
			paymentManager.loopForFinishTransaction()
			local reward = notifyMsg.notifyData.reward
			local mailid = notifyMsg.notifyData.mailid
			local rid = notifyMsg.notifyData.rid
			_ENV = nil
			_ENV, (nil).msg = nil, "MESSAGE_SERVER_RECHARGECENTER_REFRESH"
			;(nil).result = notifyMsg.notifyData.success
			;(nil).rid = rid
			;(nil).itemList = reward
			;(nil).data, (nil).mailID = nil, mailid
			SoraDSendMessage(nil)
		end
	end
	_ENV = ipairs(notifydata)
	ipairs(notifydata).msg = "MESSAGE_ACTIVITY_MODULE_UPDATE_VIEW"
	ipairs(notifydata).eventID = self.activityID
	SoraDSendMessage(ipairs(notifydata))
	_ENV = ipairs(notifydata)
	ipairs(notifydata).msg = "MESSAGE_ACTIVITY_MAGICHERB_UPDATE"
	SoraDSendMessage(ipairs(notifydata))
	_ENV = ipairs(notifydata)
	ipairs(notifydata).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	ipairs(notifydata).eventID = self.activityID
	SoraDSendMessage(ipairs(notifydata))
end
function magicHerbCtrl:getIrrigateRewardNum()
	local num = 0
	local magicherbRead = include("magicherbRead")
	for k, v in ipairs(magicherbRead.getAward()) do
		if self:isPayUnlock() then
			if self:getCurPlan() >= v.plan and not self:isFeeAwardGot(v.index) then
				num = num + 1
			end
		elseif self:getCurPlan() >= v.plan and not self:isFreeAwardGot(v.index) then
			num = num + 1
		end
	end
	return 0 < num, num
end
function magicHerbCtrl:getTaskRewardNum()
	local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
	local ret, num = activityTaskComponentCtrl:getReceiveStatusAndNum(self.activityID)
	return ret, num
end
function magicHerbCtrl:getReceiveStatusAndNum()
	local ret = false
	local num = 0
	ret, num = self:getTaskRewardNum()
	if self:isSameAlliance() then
		local retI, numI = self:getIrrigateRewardNum()
		num = num + numI
	end
	ret = 0 < num
	return ret, num
end
function magicHerbCtrl:sendIrrigate(times)
	print("magicHerbCtrl:sendIrrigate=====times=", times)
	_ENV = nil
	;(nil).times = times or 1
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_MAGIC_HERB_IRRIGATE, nil)
end
function magicHerbCtrl:sendGetReward(idx)
	serverproxy = nil
	;(nil).idx = idx
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_MAGIC_HERB_GET_REWARD, nil)
end
function magicHerbCtrl:sendGetAllReward()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_MAGIC_HERB_GET_ALL_REWARD, nil)
end
function magicHerbCtrl:sendBuyGift()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_MAGIC_HERB_BUY_GIFT, nil)
end
function magicHerbCtrl:reqIrrigateRsp(content)
	dump(content, "==magicHerbCtrl:reqIrrigateRsp==", 20)
	if content.err == gErrDef.Err_None then
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_MAGICHERB_UPDATE"
	gErrDef.Err_None.isIrrigate = true
	SoraDSendMessage(gErrDef.Err_None)
end
function magicHerbCtrl:reqGetRewardRsp(content)
	dump(content, "==magicHerbCtrl:reqGetRewardRsp==", 20)
	if content.err == gErrDef.Err_None then
		self.data.feeReward = content.rspdata.feeReward
		self.data.freeReward = content.rspdata.freeReward
		local rewards = content.rspdata.rewards
		SoraDMailGainItems(rewards, true)
	end
	_ENV = SoraDMailGainItems
	SoraDMailGainItems.msg = "MESSAGE_ACTIVITY_MAGICHERB_UPDATE"
	SoraDSendMessage(SoraDMailGainItems)
	_ENV = SoraDMailGainItems
	SoraDMailGainItems.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	SoraDMailGainItems.eventID = self.activityID
	SoraDSendMessage(SoraDMailGainItems)
end
function magicHerbCtrl:reqGetAllRewardRsp(content)
	dump(content, "==magicHerbCtrl:reqGetAllRewardRsp==", 20)
	if content.err == gErrDef.Err_None then
		self.data.feeReward = content.rspdata.feeReward
		self.data.freeReward = content.rspdata.freeReward
		local rewards = content.rspdata.rewards
		SoraDMailGainItems(rewards, true)
	end
	_ENV = SoraDMailGainItems
	SoraDMailGainItems.msg = "MESSAGE_ACTIVITY_MAGICHERB_UPDATE"
	SoraDSendMessage(SoraDMailGainItems)
	_ENV = SoraDMailGainItems
	SoraDMailGainItems.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	SoraDMailGainItems.eventID = self.activityID
	SoraDSendMessage(SoraDMailGainItems)
end
function magicHerbCtrl:reqBuyGiftRsp(content)
	dump(content, "==magicHerbCtrl:reqBuyGiftRsp==", 20)
	if content.err == gErrDef.Err_None then
		local orderID = content.rspdata.orderID
		local magicherbRead = include("magicherbRead")
		paymentManager.purchase(magicherbRead.rechargeID, orderID)
	end
	_ENV = include("magicherbRead")
	include("magicherbRead").msg = "MESSAGE_ACTIVITY_MAGICHERB_UPDATE"
	SoraDSendMessage((include("magicherbRead")))
	_ENV = include("magicherbRead")
	include("magicherbRead").msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	include("magicherbRead").eventID = self.activityID
	SoraDSendMessage((include("magicherbRead")))
end
function magicHerbCtrl:isSameAlliance()
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local curAid = allianceMgr:getOwnAid() or 0
	local ret = true
	if curAid == 0 then
		ret = false
	else
		ret = self:getOriAid() == curAid
	end
	return ret
end
function magicHerbCtrl:getOriAid()
	return self.data.aid or 0
end
function magicHerbCtrl:isPayUnlock()
	return self.data.isFeeRewardUnlock
end
function magicHerbCtrl:getIrrigateCount()
	return self.data.nourishmentCount
end
function magicHerbCtrl:getCurPlan()
	return self.data.progress
end
function magicHerbCtrl:isCurPlanArrive(index)
	local magicherbRead = include("magicherbRead")
	local needPlan = magicherbRead.getPlanByIndex(index)
	print("index,needPlan=====", index, needPlan, self.data.progress)
	return needPlan <= self.data.progress
end
function magicHerbCtrl:isFreeAwardGot(idx)
	return self.data.freeReward[tostring(idx)] and true or false
end
function magicHerbCtrl:isFeeAwardGot(idx)
	return self.data.feeReward[tostring(idx)] and true or false
end
return magicHerbCtrl

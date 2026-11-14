local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001711_Ctrl = class("activity_9001711_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001711_Ctrl:ctor(properties)
	activity_9001711_Ctrl.super.ctor(self, properties)
	_UPVALUE11_ = activity_9001711_Ctrl.super.ctor
	self.activityIDList, activity_9001711_Ctrl.super.ctor[1] = activity_9001711_Ctrl.super.ctor, gActivityTimeActivityID.NORMAL_ACTIVITY_9001711
	self.activityIDList, activity_9001711_Ctrl.super.ctor[2] = activity_9001711_Ctrl.super.ctor, gActivityTimeActivityID.NORMAL_ACTIVITY_9001724
	self.activityIDList, activity_9001711_Ctrl.super.ctor[3] = activity_9001711_Ctrl.super.ctor, gActivityTimeActivityID.ADVENTURE_GIFT_BUILD304_ACTIVITY
	self.activityIDList, activity_9001711_Ctrl.super.ctor[4] = activity_9001711_Ctrl.super.ctor, gActivityTimeActivityID.ADVENTURE_GIFT_DRESS_ACTIVITY
	self.activityIDList, activity_9001711_Ctrl.super.ctor[5] = activity_9001711_Ctrl.super.ctor, gActivityTimeActivityID.ADVENTURE_GIFT_ONE_JINN_ACTIVITY
	self.activityIDList, activity_9001711_Ctrl.super.ctor[6] = activity_9001711_Ctrl.super.ctor, gActivityTimeActivityID.ADVENTURE_GIFT_ATTR_RUNE_ACTIVITY
	self.activityIDList, activity_9001711_Ctrl.super.ctor[7] = activity_9001711_Ctrl.super.ctor, gActivityTimeActivityID.ADVENTURE_GIFT_ASSE_RUNE_ACTIVITY
	self.activityIDList, activity_9001711_Ctrl.super.ctor[8] = activity_9001711_Ctrl.super.ctor, gActivityTimeActivityID.ADVENTURE_GIFT_RUNE_REMAK_ACTIVITY
	self.activityIDList, activity_9001711_Ctrl.super.ctor[9] = activity_9001711_Ctrl.super.ctor, gActivityTimeActivityID.ADVENTURE_GIFT_NEBULA_STONE_ACTIVITY
	self.activityIDList, activity_9001711_Ctrl.super.ctor[10] = activity_9001711_Ctrl.super.ctor, gActivityTimeActivityID.ADVENTURE_GIFT_METEOR_CRYSTAL_ACTIVITY
	self.activityIDList, activity_9001711_Ctrl.super.ctor[11] = activity_9001711_Ctrl.super.ctor, gActivityTimeActivityID.ADVENTURE_GIFT_DIVINE_BEAST_MARK_ACTIVITY
	self:resetData()
end
function activity_9001711_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_ADVENTURE_GIFT_MODULE, gCmd.REQ_ADVENTURE_GIFT_DATA, handler(self, self.reqInitRsp))
	self:registerNotify()
end
function activity_9001711_Ctrl:Logout()
	activity_9001711_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001711_Ctrl:resetData()
	self.msgData, _UPVALUE0_ = nil, nil
end
function activity_9001711_Ctrl:initClientData(data)
	dump(data, "activity_9001711_Ctrl:initClientData===")
end
function activity_9001711_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.USER_ACTIVITY, handler(self, self.notifyHandler))
end
function activity_9001711_Ctrl:notifyHandler(event)
	for _, v in pairs(event.data) do
		if table.indexof(self.activityIDList, v.activityID) then
			if v.notifyType == "triggerGift" then
				dump(v.notifyData, "activity_9001711_Ctrl:notifyHandler")
				self.msgData = v.notifyData.initData.gift
				if v.notifyData.opeType then
					local popGfit = v.notifyData.initData.gift[v.notifyData.opeType] or v.notifyData.initData.gift[tostring(v.notifyData.opeType)]
					dump(popGfit, "activity_9001711_Ctrl:notifyHandler")
					_ENV = popGfit
					popGfit.msg = "MESSAGE_ACTIVITY_9001711_UPDATE"
					popGfit.popGfit = popGfit
					SoraDSendMessage(popGfit)
				end
			elseif v.notifyType == "buyGift" then
				if v.notifyData.rechargeInfo.success then
					paymentManager.loopForFinishTransaction()
					local reward = v.notifyData.rechargeInfo.reward
					local rid = v.notifyData.rechargeInfo.rid
					local mailid = v.notifyData.rechargeInfo.mailid
					_ENV = nil
					_ENV, (nil).msg = nil, "MESSAGE_SERVER_RECHARGECENTER_REFRESH"
					;(nil).result = true
					;(nil).rid = rid
					;(nil).itemList = reward
					;(nil).data, (nil).mailID = nil, mailid
					SoraDSendMessage(nil)
				end
				if v.notifyData.gift then
					self.msgData = v.notifyData.gift
				end
				_ENV = v.notifyData.rechargeInfo.rid
				v.notifyData.rechargeInfo.rid.msg = "MESSAGE_ACTIVITY_9001711_UPDATE"
				SoraDSendMessage(v.notifyData.rechargeInfo.rid)
			end
		end
	end
end
function activity_9001711_Ctrl:sendReqInitDataMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ADVENTURE_GIFT_MODULE, gCmd.REQ_ADVENTURE_GIFT_DATA, nil)
end
function activity_9001711_Ctrl:reqInitRsp(content)
	dump(content, "activity_9001711_Ctrl:reqInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.msgData = content.rspdata.gift
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001711_UPDATE"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001711_Ctrl:getIsHaveGift()
	local giftNum = 0
	local systemTime = serviceFunctions.systemTime()
	local giftList = self:getGiftList()
	for _, v in pairs(giftList) do
		print("v.buyEndTime", v.buyEndTime, systemTime, v.buyEndTime - systemTime)
		if systemTime < v.buyEndTime then
			for _, v2 in pairs(v.giftMap) do
				if 0 < v2.remainNum then
					giftNum = giftNum + v2.remainNum
				end
			end
		end
	end
	return 0 < giftNum, giftNum
end
function activity_9001711_Ctrl:getGiftList()
	return self.msgData
end
function activity_9001711_Ctrl:getMinBuyEndTime()
	local minBuyEndTime
	local systemTime = serviceFunctions.systemTime()
	local giftList = self:getGiftList()
	for _, v in pairs(giftList) do
		if systemTime < v.buyEndTime and (minBuyEndTime == nil or minBuyEndTime > v.buyEndTime) then
			minBuyEndTime = v.buyEndTime
		end
	end
	return minBuyEndTime or 0
end
return activity_9001711_Ctrl

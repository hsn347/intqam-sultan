local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001601_Ctrl = class("activity_9001601_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local activity_9001601_Read = include("activity_9001601_Read")
function activity_9001601_Ctrl:ctor(properties)
	activity_9001601_Ctrl.super.ctor(self, properties)
	self.itemID = 867901
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001601
	self:resetData()
end
function activity_9001601_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_CRESCENT_BLESSING_MODULE, gCmd.REQ_CRESCENT_BLESSING_DATA, handler(self, self.reqInitDataRsp))
	msgCtrl.register(gCmd.CMD_CRESCENT_BLESSING_MODULE, gCmd.REQ_CRESCENT_BLESSING_DONATE, handler(self, self.reqDonateRsp))
	msgCtrl.register(gCmd.CMD_CRESCENT_BLESSING_MODULE, gCmd.REQ_CRESCENT_BLESSING_ALL_REWARD, handler(self, self.reqAllRewardRsp))
	msgCtrl.register(gCmd.CMD_CRESCENT_BLESSING_MODULE, gCmd.REQ_CRESCENT_BLESSING_BUY_GIFT, handler(self, self.reqBuyGiftRsp))
	self:registerNotify()
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	backpackCtrl:addItemChangeEvent(self.itemID, handler(self, self.notifyItemCount))
end
function activity_9001601_Ctrl:Logout()
	activity_9001601_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001601_Ctrl:resetData()
	_ENV = nil
	;(nil).state = gActivityState.CLOSE
	;(nil).opencount = 0
	;(nil).classtype = 1
	;(nil).scoreIdx = 1
	_UPVALUE3_, (nil).score = gActivityState.CLOSE, 0
	_UPVALUE3_, (nil).unlock, gActivityState.CLOSE[1] = gActivityState.CLOSE, gActivityState.CLOSE, true
	_UPVALUE3_, (nil).unlock, gActivityState.CLOSE[2] = gActivityState.CLOSE, gActivityState.CLOSE, false
	_UPVALUE3_, (nil).unlock, gActivityState.CLOSE[3] = gActivityState.CLOSE, gActivityState.CLOSE, false
	self.initData, (nil).gotRewardLv, gActivityState.CLOSE[1] = nil, gActivityState.CLOSE, 0
	self.initData, (nil).gotRewardLv, gActivityState.CLOSE[2] = nil, gActivityState.CLOSE, 0
	self.initData, (nil).gotRewardLv, gActivityState.CLOSE[3] = nil, gActivityState.CLOSE, 0
end
function activity_9001601_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.CRESCENT_BLESSING, handler(self, self.notifyHandler))
end
function activity_9001601_Ctrl:notifyHandler(event)
	dump(event.data, "activity_9001601_Ctrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		local notifyType = v.notifyType
		local notifyData = v.notifyData
		if notifyType == "buyGift" and notifyData.success then
			paymentManager.loopForFinishTransaction()
			local reward = notifyData.reward
			local rid = notifyData.rid
			_ENV = nil
			_ENV, (nil).msg = nil, "MESSAGE_SERVER_RECHARGECENTER_REFRESH"
			;(nil).result = true
			;(nil).rid = rid
			;(nil).data, (nil).itemList = nil, reward
			SoraDSendMessage(nil)
			local rid = notifyData.rid
			local giftType = activity_9001601_Read.getGiftTypeByRechargeID(rid)
			local unlock = self:getUnlock()
			unlock[giftType + 1] = true
			_ENV = nil
			;(nil).msg = "MESSAGE_ACTIVITY_9001601_UPDATE"
			;(nil).key = "buyGift"
			SoraDSendMessage(nil)
		end
	end
end
function activity_9001601_Ctrl:notifyItemCount(...)
	print("==activity_9001601_Ctrl:notifyItemCount==", ...)
	_ENV = "==activity_9001601_Ctrl:notifyItemCount=="
	;("==activity_9001601_Ctrl:notifyItemCount==").msg = "MESSAGE_ACTIVITY_9001601_UPDATE"
	;("==activity_9001601_Ctrl:notifyItemCount==").key = "itemCount"
	SoraDSendMessage("==activity_9001601_Ctrl:notifyItemCount==")
end
function activity_9001601_Ctrl:sendReqInitDataMsg(...)
	self:reqInitData()
end
function activity_9001601_Ctrl:reqInitData()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_CRESCENT_BLESSING_MODULE, gCmd.REQ_CRESCENT_BLESSING_DATA, nil)
end
function activity_9001601_Ctrl:reqInitDataRsp(content)
	dump(content, "activity_9001601_Ctrl:reqInitDataRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:setInitData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_ACTIVITY_9001601_UPDATE"
		self.key = "init"
		SoraDSendMessage(self)
	end
end
function activity_9001601_Ctrl:reqDonate()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_CRESCENT_BLESSING_MODULE, gCmd.REQ_CRESCENT_BLESSING_DONATE, nil)
end
function activity_9001601_Ctrl:reqDonateRsp(content)
	dump(content, "activity_9001601_Ctrl:reqDonateRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local oldScore = self:getScore()
		self:setInitData(content.rspdata)
		local addScore = self:getScore() - oldScore
		local rate = math.max(1, addScore / 1)
		_ENV = addScore / 1
		;(addScore / 1).msg = "MESSAGE_ACTIVITY_9001601_UPDATE"
		;(addScore / 1).key = "donate"
		;(addScore / 1).rate = rate
		SoraDSendMessage(addScore / 1)
	end
end
function activity_9001601_Ctrl:reqAllReward()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_CRESCENT_BLESSING_MODULE, gCmd.REQ_CRESCENT_BLESSING_ALL_REWARD, nil)
end
function activity_9001601_Ctrl:reqAllRewardRsp(content)
	dump(content, "activity_9001601_Ctrl:reqAllRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:setInitData(content.rspdata.data)
		SoraDMailGainItems(content.rspdata.reward, true)
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_ACTIVITY_9001601_UPDATE"
		content.rspdata.reward.key = "reward"
		SoraDSendMessage(content.rspdata.reward)
	end
end
function activity_9001601_Ctrl:reqBuyGift(rid)
	serverproxy = nil
	;(nil).rid = rid
	serverproxy:Request(gCmd.CMD_CRESCENT_BLESSING_MODULE, gCmd.REQ_CRESCENT_BLESSING_BUY_GIFT, nil)
end
function activity_9001601_Ctrl:reqBuyGiftRsp(content)
	dump(content, "activity_9001601_Ctrl:reqBuyGiftRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local rspdata = content.rspdata
		paymentManager.purchase(content.data.rid, rspdata.orderID)
	end
end
function activity_9001601_Ctrl:setInitData(initData)

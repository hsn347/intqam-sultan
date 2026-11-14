local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local sheepRunCtrl = class("sheepRunCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local sheepRunRead = include("sheepRunRead")
local constantRead = include("constantRead")
function sheepRunCtrl:ctor(properties)
	sheepRunCtrl.super.ctor(self, properties)
	_UPVALUE2_ = sheepRunCtrl.super.ctor
	self.giftIDs, sheepRunCtrl.super.ctor[1] = sheepRunCtrl.super.ctor, 14418
	self.giftIDs, sheepRunCtrl.super.ctor[2] = sheepRunCtrl.super.ctor, 14419
	self.itemID = 839901
	self.needNum = constantRead.getConstValue("RUNNINGSHEEP_ITEM_NEED", 10)
	self.friendHelpCount = constantRead.getConstValue("RUNNINGSHEEP_INVITED_EACH", 3)
	self:resetData()
end
function sheepRunCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_SHEEP_RUN_MODULE, gCmd.REQ_SHEEP_RUN_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_SHEEP_RUN_MODULE, gCmd.REQ_SHEEP_RUN_CHOOSE_FRIEND_1, handler(self, self.reqChooseFriend1Rsp))
	msgCtrl.register(gCmd.CMD_SHEEP_RUN_MODULE, gCmd.REQ_SHEEP_RUN_CHOOSE_FRIEND_2, handler(self, self.reqChooseFriend2Rsp))
	msgCtrl.register(gCmd.CMD_SHEEP_RUN_MODULE, gCmd.REQ_SHEEP_RUN_DELETE_FRIEND_HELP, handler(self, self.reqDeleteFriendRsp))
	msgCtrl.register(gCmd.CMD_SHEEP_RUN_MODULE, gCmd.REQ_SHEEP_RUN_CHOOSE_REWARD, handler(self, self.reqChooseRewarddRsp))
	msgCtrl.register(gCmd.CMD_SHEEP_RUN_MODULE, gCmd.REQ_SHEEP_RUN_CATCH, handler(self, self.reqCatchRsp))
	self:registerNotify()
end
function sheepRunCtrl:Logout()
	sheepRunCtrl.super.Logout(self)
	self:resetData()
end
function sheepRunCtrl:resetData()
	self.msgData = nil
end
function sheepRunCtrl:initClientData(data)
	dump(data, "==sheepRunCtrl:initClientData==", 10)
	if not data then
		return
	end
	self.msgData = data
	self.curPool = data.poolAmount
end
function sheepRunCtrl:reqInit(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_SHEEP_RUN_MODULE, gCmd.REQ_SHEEP_RUN_INIT, nil, ...)
end
function sheepRunCtrl:reqChooseFriend1(uid, ...)
	serverproxy = nil
	;(nil).uid = uid
	serverproxy:Request(gCmd.CMD_SHEEP_RUN_MODULE, gCmd.REQ_SHEEP_RUN_CHOOSE_FRIEND_1, nil, ...)
end
function sheepRunCtrl:reqChooseFriend2(uid, ...)
	serverproxy = nil
	;(nil).uid = uid
	serverproxy:Request(gCmd.CMD_SHEEP_RUN_MODULE, gCmd.REQ_SHEEP_RUN_CHOOSE_FRIEND_2, nil, ...)
end
function sheepRunCtrl:reqChooseReward(chooseID, count, ...)
	serverproxy = nil
	;(nil).chooseID = chooseID
	;(nil).count = count
	serverproxy:Request(gCmd.CMD_SHEEP_RUN_MODULE, gCmd.REQ_SHEEP_RUN_CHOOSE_REWARD, nil, ...)
end
function sheepRunCtrl:reqCatch(chooseEnd, ...)
	serverproxy = nil
	;(nil).chooseEnd = chooseEnd
	serverproxy:Request(gCmd.CMD_SHEEP_RUN_MODULE, gCmd.REQ_SHEEP_RUN_CATCH, nil, ...)
end
function sheepRunCtrl:reqDeleteFriend(...)
	print("sheepRunCtrl:reqDeleteFriend")
	serverproxy:Request(gCmd.CMD_SHEEP_RUN_MODULE, gCmd.REQ_SHEEP_RUN_DELETE_FRIEND_HELP, ...)
end
function sheepRunCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.SHEEP_RUN_ACTIVITY, handler(self, self.notifyHandler))
end
function sheepRunCtrl:notifyHandler(event)
	dump(event.data, "sheepRunCtrl:notifyHandler", 10)
	for _, content in pairs(event.data) do
		if content then
			self:initClientData(content)
			_ENV = self
			self.msg = "MESSAGE_SHEEP_RUN_INIT"
			SoraDSendMessage(self)
			_ENV = self
			self.msg = "MESSAGE_SHEEP_RUN_NOTIFY"
			self.data = content.curAllReward
			SoraDSendMessage(self)
			_ENV = self
			self.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
			self.eventID = gActivityTimeActivityID.SHEEP_RUN_ACTIVITY
			SoraDSendMessage(self)
			local rewards = content.curAllReward
			if rewards and 0 < #rewards then
				local view = SoraDCreatePanel("sheepRunReward")
				view:initData(rewards)
				view:show()
			end
			if SoraDIsGameGuide() then
				_ENV = view.show
				view.show.msg = "MESSAGE_SERVER_CLOSE_GUIDE"
				SoraDSendMessage(view.show)
			end
		end
	end
end
function sheepRunCtrl:reqInitRsp(content)
	dump(content, "sheepRunCtrl:reqInitRsp", 10)
	if content.err == gErrDef.Err_None then
		self:initClientData(content.rspdata.sheepRunData)
		_ENV = self
		self.msg = "MESSAGE_SHEEP_RUN_INIT"
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		self.eventID = gActivityTimeActivityID.SHEEP_RUN_ACTIVITY
		SoraDSendMessage(self)
	end
end
function sheepRunCtrl:reqChooseFriend1Rsp(content)
	dump(content, "sheepRunCtrl:reqChooseFriend1Rsp", 10)
	if content.err == gErrDef.Err_None then
		self:initClientData(content.rspdata.sheepRunData)
		if not content.rspdata.open then
			local tip = i18n("runningSheep_text_19")
			SoraDShowBuyBox(tip, nil, nil, function(exitType, other)
				if exitType ~= MSGBOX_CALLBACK_YES then
					return
				end
				self:reqChooseFriend2(content.data.uid)
			end)
			return
		end
		_UPVALUE1_ = SoraDShowBuyBox
		_ENV, SoraDShowBuyBox.msg = tip, "MESSAGE_SHEEP_RUN_CHOOSE_FRIEND"
		tip.idx = 1
		SoraDShowBuyBox[1] = tip
		SoraDSendMessage(SoraDShowBuyBox)
	elseif content.err == gErrDef.Err_SHEEP_RUN_FRIEND_HELP_LIMIT then
		_ENV = nil
		;(nil).var = self.friendHelpCount
		SoraDShowMsgTip(i18n("runningSheep_text_14", nil))
	elseif content.err == gErrDef.Err_SHEEP_RUN_FRIEND_TOTAL_HELP_LIMIT then
		SoraDShowMsgTip(i18n("runningSheep_text_13"))
	end
end
function sheepRunCtrl:reqChooseFriend2Rsp(content)
	dump(content, "sheepRunCtrl:reqChooseFriend2Rsp", 10)
	if content.err == gErrDef.Err_None then
		self:initClientData(content.rspdata.sheepRunData)
		_UPVALUE1_ = self
		_ENV, self.msg = content.rspdata.sheepRunData, "MESSAGE_SHEEP_RUN_CHOOSE_FRIEND"
		content.rspdata.sheepRunData.idx = 2
		self[1] = content.rspdata.sheepRunData
		SoraDSendMessage(self)
	elseif content.err == gErrDef.Err_SHEEP_RUN_FRIEND_HELP_LIMIT then
		_ENV = 10
		;(10).var = self.friendHelpCount
		SoraDShowMsgTip(i18n("runningSheep_text_14", 10))
	elseif content.err == gErrDef.Err_SHEEP_RUN_FRIEND_TOTAL_HELP_LIMIT then
		SoraDShowMsgTip(i18n("runningSheep_text_13"))
	end
end
function sheepRunCtrl:reqDeleteFriendRsp(content)
	dump(content, "sheepRunCtrl:reqDeleteRsp", 10)
	if content.err == gErrDef.Err_None then
		self:initClientData(content.rspdata.sheepRunData)
		_ENV = self
		self.msg = "MESSAGE_SHEEP_RUN_DELETE_FRIEND"
		SoraDSendMessage(self)
	end
end
function sheepRunCtrl:reqChooseRewarddRsp(content)
	dump(content, "sheepRunCtrl:reqChooseRewarddRsp", 10)
	if content.err == gErrDef.Err_None then
		self:initClientData(content.rspdata.sheepRunData)
		_ENV = self
		self.msg = "MESSAGE_SHEEP_RUN_CHOOSE_REWARD"
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		self.eventID = gActivityTimeActivityID.SHEEP_RUN_ACTIVITY
		SoraDSendMessage(self)
	end
end
function sheepRunCtrl:reqCatchRsp(content)
	dump(content, "sheepRunCtrl:reqCatchRsp", 10)
	if content.err == gErrDef.Err_None then
		if content.rspdata.catchReward then
			_ENV = gErrDef.Err_None
			gErrDef.Err_None.msg = "MESSAGE_SHEEP_RUN_CATCH_REWARD"
			gErrDef.Err_None.reward = content.rspdata.catchReward
			SoraDSendMessage(gErrDef.Err_None)
		end
		self:initClientData(content.rspdata.sheepRunData)
		_ENV = self
		self.msg = "MESSAGE_SHEEP_RUN_CATCH"
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		self.eventID = gActivityTimeActivityID.SHEEP_RUN_ACTIVITY
		SoraDSendMessage(self)
	end
end
function sheepRunCtrl:getReceiveStatusAndNum()
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local itemNum = backpackCtrl:getItemCount(self.itemID)
	if itemNum >= self.needNum then
		return true, -1
	else
		return false, 0
	end
end
function sheepRunCtrl:getIsBuy()
	return self.msgData and self.msgData.buytime ~= nil and self.msgData.buytime > 0
end
function sheepRunCtrl:getCurRewards()
	if not self.msgData then
		sheepRunRead = self.msgData
		return self.msgData
	end
	return sheepRunRead.getShowRewards()[self.curPool]
end
function sheepRunCtrl:getCatchEndTime()
	if not (self.msgData and self.msgData.catchInfo) or not self.msgData.catchInfo then
		return
	end
	return self.msgData.catchInfo.catchEndTime
end
function sheepRunCtrl:getLastCatchTime()
	local catchEndTime = self:getCatchEndTime()
	_UPVALUE1_ = nil
	;(nil)[1] = catchEndTime
	;(nil)[2] = serviceFunctions.systemTime()
	dump(nil, "sheepRunCtrl:getLastCatchTime")
	if catchEndTime == nil then
		return 0
	end
	return catchEndTime - serviceFunctions.systemTime()
end
function sheepRunCtrl:getCurPool()
	return self.curPool
end
function sheepRunCtrl:getCurContactUid()
	if not (self.msgData and self.msgData.catchInfo) or not self.msgData.catchInfo.uid then
		return
	end
	return self.msgData.catchInfo.uid
end
function sheepRunCtrl:getChooseID()
	return self.chooseID
end
function sheepRunCtrl:setChooseID(chooseID)
	self.chooseID = chooseID
end
function sheepRunCtrl:getChooseItem()
	local rewards = self:getCurRewards()
	if not rewards then
		return nil
	end
	for i, v in ipairs(rewards) do
		if v.item == self.chooseID then
			return v
		end
	end
	return nil
end
function sheepRunCtrl:getCurContactData()
	if not (self.msgData and self.msgData.catchInfo) or not self.msgData.catchInfo.uid then
		return
	end
	local contactCtrl = gametop.playertop_:getModule("contactCtrl")
	local contactData = contactCtrl:getContact(self.msgData.catchInfo.uid)
	return contactData
end
function sheepRunCtrl:getGiftData()
	local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
	local giftID = self.giftIDs[self:getCurPool()]
	local giftData = rechargeActivityCtrl:getRechargeActivityData(giftID)
	return giftData
end
function sheepRunCtrl:getFriendHelpCount(uid)
	if not (self.msgData and self.msgData.helpedInfo) or not self.msgData.helpedInfo["" .. uid] then
		return 0
	end
	return self.msgData.helpedInfo["" .. uid]
end
return sheepRunCtrl

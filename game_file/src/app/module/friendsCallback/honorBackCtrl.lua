local gamemodulec = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local honorBackCtrl = class("honorBackCtrl", gamemodulec)
local friendsCallbackRead = include("friendsCallbackRead")
function honorBackCtrl:ctor(properties)
	honorBackCtrl.super.ctor(self, properties)
	self.queue, honorBackCtrl = honorBackCtrl.super.ctor, honorBackCtrl.super.ctor
	self:resetData()
end
function honorBackCtrl:Logout()
	honorBackCtrl.super.Logout(self)
	self:resetData()
end
function honorBackCtrl:resetData()
	self.userData, _UPVALUE0_, self.activityData, _UPVALUE0_ = nil, nil, nil, nil
end
function honorBackCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_FRIEND_CALL_BACK_MODULE, gCmd.REQ_SET_INVITER_CODE, handler(self, self.commintInviteCodeRsp))
	msgCtrl.register(gCmd.CMD_FRIEND_CALL_BACK_MODULE, gCmd.REQ_COMMIT_COME_BACK_TASK, handler(self, self.missionCommitRsp))
	msgCtrl.register(gCmd.CMD_FRIEND_CALL_BACK_MODULE, gCmd.REQ_BUY_HONOR_GIFT, handler(self, self.buyGiftRsp))
	msgCtrl.register(gCmd.CMD_FRIEND_CALL_BACK_MODULE, gCmd.REQ_HONOR_SHOP_BUY, handler(self, self.buyItemRsp))
	msgCtrl.register(gCmd.CMD_FRIEND_CALL_BACK_MODULE, gCmd.REQ_HONOR_EXCHANGE, handler(self, self.gloryExchangeRsp))
	msgCtrl.register(gCmd.CMD_FRIEND_CALL_BACK_MODULE, gCmd.REQ_HONOR_LOGIN_GIFT, handler(self, self.honorLoginGiftRsp))
	msgCtrl.register(gCmd.CMD_FRIEND_CALL_BACK_MODULE, gCmd.REQ_HONOR_KINGGIFT_TASK_REWARD, handler(self, self.gloryTaskRewardRsp))
	msgCtrl.register(gCmd.CMD_FRIEND_CALL_BACK_MODULE, gCmd.REQ_HONOR_NEW_RETURN_GIFT, handler(self, self.honorNewReturnGiftRsp))
end
function honorBackCtrl:initClientData(retdata)
	dump(retdata, "honorBackCtrl:initClient", 10)
	if retdata then
		local returnBackData = retdata.userData.returnBackData
		self:setData(returnBackData)
		if not returnBackData.exchangeData then
			_ENV = returnBackData.exchangeData
		end
		self.exchangeData = returnBackData.exchangeData
		self:registerNotify()
	end
end
function honorBackCtrl:setData(returnBackData)
	self.giftBuyData = returnBackData.giftBuyData
	self.inviterCode = returnBackData.inviterCode
	self.inviterInfo = returnBackData.inviterInfo
	self.shopData = returnBackData.shopData
	self.returnBackTask = returnBackData.returnBackTask
	self.returnBackRewardFlag = returnBackData.returnBackRewardFlag
	self.totalRecharge = returnBackData.totalRecharge
	if not returnBackData.dailyTask then
		_UPVALUE0_ = returnBackData.dailyTask
	end
	self.gloryTask = returnBackData.dailyTask
	self.isReturnBack = returnBackData.isReturnBack
	self.newReturnGiftFlag = returnBackData.newReturnGiftFlag
	if not returnBackData.loginRewardFlag then
		_UPVALUE0_ = returnBackData.loginRewardFlag
	end
	self.loginRewardFlag = returnBackData.loginRewardFlag
	self.loginDays = returnBackData.loginDays
	self.lastLogoutTime = returnBackData.lastLogoutTime
end
function honorBackCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.FRIEND_HONORBACK, handler(self, self.notifyUpdate))
end
function honorBackCtrl:notifyUpdate(event)
	local notifydata = event.data
	dump(notifydata, "honorBackCtrl:notifyUpdate", 10)
	for k, v in ipairs(notifydata) do
		if v.type == "buyGift" then
			if v.data.success == true then
				paymentManager.OnemtRechargeSuccess(v.data.price)
				paymentManager.loopForFinishTransaction()
				self.giftBuyData = v.data.buyGiftList
				local reward = v.data.reward
				local mailid = v.data.mailid
				local rid = v.data.rid
				_ENV = nil
				_ENV, (nil).msg = nil, "MESSAGE_SERVER_RECHARGECENTER_REFRESH"
				;(nil).result = true
				;(nil).rid = rid
				;(nil).itemList = reward
				;(nil).data, (nil).mailID = nil, mailid
				SoraDSendMessage(nil)
				_ENV = nil
				;(nil).msg = "MESSAGE_SERVER_HONOR_BACK_UPDATE_GIFTS"
				SoraDSendMessage(nil)
			end
		elseif v.type == "updateMission" then
			self:updateMission(v.data)
			_ENV = self
			self.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
			self.eventID = gActivityTimeActivityID.FRIEND_HONORBACK
			SoraDSendMessage(self)
		elseif v.type == "updateDailyMission" then
			for k, v in ipairs(v.data) do
				local taskID = tostring(v.taskID)
				if self.gloryTask and self.gloryTask[taskID] then
					self.gloryTask[taskID].taskstatus = v.taskstatus
					self.gloryTask[taskID].curnum = v.curnum
				end
			end
		elseif v.type == "activityChange" then
			local returnBackData = v.data.userData.returnBackData
			self:setData(returnBackData)
		elseif v.type == "refreshDailyMission" then
			self.gloryTask = notifydata.data
		end
		_ENV = self.setData
		self.setData.msg = "MESSAGE_SERVER_HONOR_BACK_UPDATE_TASK"
		SoraDSendMessage(self.setData)
	end
end
function honorBackCtrl:updateMission(changeList)
	dump(changeList, "changeList")
	for k, v in ipairs(changeList) do
		local taskID = tostring(v.taskID)
		self.returnBackTask[taskID].taskstatus = v.taskstatus
		self.returnBackTask[taskID].curnum = v.curnum
	end
	dump(self.returnBackTask, "honorBackCtrl:updateMission", 10)
end
function honorBackCtrl:getInviteCode()
	return self.inviterCode
end
_ENV, honorBackCtrl.showLoginTaskNeedRedP = function(self)
	local bAward, _ = self:getLoginTaskReceiveStatusAndNum()
	return bAward
end, function(self)
	local bAward, _ = self:getLoginTaskReceiveStatusAndNum()
	return bAward
end
_ENV = nil
;(nil)[1] = gCallbackConditionType.LOGIN_DAY
;(nil)[2] = gCallbackConditionType.TRAIN_SOLDIER
;(nil)[3] = gCallbackConditionType.ATTACK_MONSTER_TIMES
;(function(self)
	local bAward, _ = self:getLoginTaskReceiveStatusAndNum()
	return bAward
end)[gHonorBackType.BackTask], (nil)[4] = nil, gCallbackConditionType.CASTLE_UPGRADE
_ENV = nil
;(nil)[1] = gCallbackConditionType.USE_SPEED_UP
;(nil)[2] = gCallbackConditionType.USE_GOLD
;(nil)[3] = gCallbackConditionType.WISH_RESOURCE
;(function(self)
	local bAward, _ = self:getLoginTaskReceiveStatusAndNum()
	return bAward
end)[gHonorBackType.AdvancedTask], (nil)[4] = nil, gCallbackConditionType.USE_HERO_BOX
local function taskConfig(self)
	local bAward, _ = self:getLoginTaskReceiveStatusAndNum()
	return bAward
end
function honorBackCtrl:getTaskConfig(...)
	return taskConfig
end
function honorBackCtrl:checkRedStateByTaskType(taskType)
	local showRed = false
	local data = friendsCallbackRead.getTaskTypeConfig(taskType)
	for i, v in ipairs(data) do
		if self:getTaskState(v.taskID) == gFriendCallbackTaskStatus.TASK_STATUS_COMPLETE then
			showRed = true
			break
		end
	end
	return showRed
end
function honorBackCtrl:showCommonTaskNeedRedP(honorType)
	for i, v in ipairs(taskConfig[honorType]) do
		if self:checkRedStateByTaskType(v) then
			return true
		end
	end
	return false
end
function honorBackCtrl:showGloryTaskNeedRedP()
	if not self.gloryTask then
		_ENV = self.gloryTask
	end
	for k, v in pairs(self.gloryTask) do
		if v.taskstatus == gFriendCallbackTaskStatus.TASK_STATUS_COMPLETE then
			return true
		end
	end
	return false
end
function honorBackCtrl:getTaskState(taskID)
	if self.returnBackTask and self.returnBackTask[tostring(taskID)] then
		return self.returnBackTask[tostring(taskID)].taskstatus
	end
end
function honorBackCtrl:getTaskCurNum(taskID)
	if self.returnBackTask and self.returnBackTask[tostring(taskID)] then
		return self.returnBackTask[tostring(taskID)].curnum
	end
end
function honorBackCtrl:canBuy(shopItemID)
	if not self.shopData or not self.shopData[tostring(shopItemID)] then
		return true
	end
	for k, v in ipairs(friendsCallbackRead.honorShopConfig) do
		if v.shopItemID == shopItemID then
			return self.shopData[tostring(shopItemID)] < v.limitNum
		end
	end
end
function honorBackCtrl:getBenefitGiftList()
	local _ENV, tempList
	if not self.giftBuyData then
		for k, v in ipairs(friendsCallbackRead.honorGiftsConfig) do
			if self.totalRecharge >= v.RechargeSection[1] and self.totalRecharge <= v.RechargeSection[2] then
				table.insert(tempList, v)
			end
		end
	else
		for k, v in ipairs(friendsCallbackRead.honorGiftsConfig) do
			if not self.giftBuyData[tostring(v.giftID)] and self.totalRecharge >= v.RechargeSection[1] and self.totalRecharge <= v.RechargeSection[2] then
				table.insert(tempList, v)
			end
		end
	end
	return tempList
end
function honorBackCtrl:isReceiveReturnGift()
	return self.returnBackRewardFlag
end
function honorBackCtrl:getInviterInfo()
	return self.inviterInfo
end
function honorBackCtrl:getReceiveStatusAndNum()
	local bAward = false
	local num = 0
	if self.returnBackTask then
		for k, v in pairs(self.returnBackTask) do
			if v.taskstatus == gFriendCallbackTaskStatus.TASK_STATUS_COMPLETE then
				num = num + 1
				bAward = true
			end
		end
	end
	local bAward1, num1 = self:getLoginTaskReceiveStatusAndNum()
	if bAward1 then
		num = num + num1
		bAward = true
	end
	local friendPetCtrl = SoraDGetCtrl("friendPetCtrl")
	local bAward2 = friendPetCtrl:showPetNeedRedP()
	if bAward2 then
		num = num + 1
		bAward = true
	end
	print("现在的num", num)
	return bAward, num
end
function honorBackCtrl:getLoginTaskReceiveStatusAndNum(...)
	local bAward = false
	local num = 0
	if 0 < self:getLoginDays() then
		for i = 1, self:getLoginDays() do
			if self:getLoginDaysState(i) == gFriendCallbackTaskStatus.TASK_STATUS_COMPLETE then
				num = num + 1
				bAward = true
			end
		end
	end
	return bAward, num
end
function honorBackCtrl:getGlotyTaskInfo(taskID)
	return self.gloryTask[tostring(taskID)]
end
function honorBackCtrl:reqCommitInvalidCode(_data)
	local data = _data
	serverproxy:Request(gCmd.CMD_FRIEND_CALL_BACK_MODULE, gCmd.REQ_SET_INVITER_CODE, data)
end
function honorBackCtrl:reqCommitTask(_data)
	local data = _data
	serverproxy:Request(gCmd.CMD_FRIEND_CALL_BACK_MODULE, gCmd.REQ_COMMIT_COME_BACK_TASK, data)
end
function honorBackCtrl:reqBuyItem(_data)
	dump(_data, "honorBackCtrl:reqBuyItem", 10)
	local data = _data
	serverproxy:Request(gCmd.CMD_FRIEND_CALL_BACK_MODULE, gCmd.REQ_HONOR_SHOP_BUY, data)
end
function honorBackCtrl:reqGloryExchange(data)
	dump(data, "honorBackCtrl:reqGloryExchange")
	serverproxy:Request(gCmd.CMD_FRIEND_CALL_BACK_MODULE, gCmd.REQ_HONOR_EXCHANGE, data)
end
function honorBackCtrl:reqBuyGiftsItem(_data)
	local data = _data
	serverproxy:Request(gCmd.CMD_FRIEND_CALL_BACK_MODULE, gCmd.REQ_BUY_HONOR_GIFT, data)
end
function honorBackCtrl:reqGloryTaskReward(taskID)
	serverproxy = nil
	local (nil).taskID, data = taskID, nil
	serverproxy:Request(gCmd.CMD_FRIEND_CALL_BACK_MODULE, gCmd.REQ_HONOR_KINGGIFT_TASK_REWARD, data)
end
function honorBackCtrl:reqHonorLoginGift(rewardDay)
	serverproxy = nil
	local (nil).rewardDay, data = rewardDay, nil
	serverproxy:Request(gCmd.CMD_FRIEND_CALL_BACK_MODULE, gCmd.REQ_HONOR_LOGIN_GIFT, data)
end
function honorBackCtrl:reqHonorNewReturnGift()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_FRIEND_CALL_BACK_MODULE, gCmd.REQ_HONOR_NEW_RETURN_GIFT, nil)
end
function honorBackCtrl:commintInviteCodeRsp(content)
	local err = content.err
	if err == gErrDef.Err_None then
		local data = content.rspdata
		if data then
			self.returnBackRewardFlag = data.returnBackRewardFlag
			self.inviterInfo = data.inviterInfo
			self.inviterCode = data.inviterCode
			if content.rspdata.reward then
				SoraDMailGainItems(content.rspdata.reward, true)
			end
		end
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_SERVER_HONOR_BACK_COMMIT_CODE"
		SoraDSendMessage(content.rspdata.reward)
	elseif err == gErrDef.Err_FRIEND_MAX_INVITE_NUM then
		SoraDShowMsgTip(i18n("returnnew_text_026"))
	else
		SoraDShowMsgTip(i18n("return_text_26"))
	end
end
function honorBackCtrl:missionCommitRsp(content)
	dump(content, "honorBackCtrl:missionCommitRsp(content)", 10)
	local err = content.err
	if err == gErrDef.Err_None then
		local mission = content.rspdata.mission
		if mission then
			self.returnBackTask[tostring(mission.taskID)].taskstatus = mission.taskstatus
			_ENV = mission.taskstatus
			mission.taskstatus.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
			mission.taskstatus.eventID = gActivityTimeActivityID.FRIEND_HONORBACK
			SoraDSendMessage(mission.taskstatus)
		end
		if content.rspdata.reward then
			SoraDMailGainItems(content.rspdata.reward, true)
		end
	end
	_ENV = SoraDMailGainItems
	SoraDMailGainItems.msg = "MESSAGE_SERVER_HONOR_BACK_UPDATE_TASK"
	SoraDSendMessage(SoraDMailGainItems)
end
function honorBackCtrl:buyItemRsp(content)
	local err = content.err
	if err == gErrDef.Err_None then
		local rspdata = content.rspdata
		self.shopData = rspdata.shopData
		if rspdata.reward then
			SoraDMailGainItems(rspdata.reward, true)
		end
		_ENV = rspdata.reward
		rspdata.reward.msg = "MESSAGE_SERVER_HONOR_BACK_UPDATE_SHOP"
		SoraDSendMessage(rspdata.reward)
	end
end
function honorBackCtrl:gloryExchangeRsp(content)
	dump(content, "gloryExchangeRsp", 5)
	SoraDCloseLoading()
	local err = content.err
	if err == gErrDef.Err_None then
		local rspdata = content.rspdata
		self.exchangeData = rspdata.exchangeData
		if rspdata.reward then
			SoraDMailGainItems(rspdata.reward, true)
		end
		_ENV = rspdata.reward
		rspdata.reward.msg = "MESSAGE_SERVER_HONOR_BACK_UPDATE_TASK"
		SoraDSendMessage(rspdata.reward)
	end
end
function honorBackCtrl:gloryTaskRewardRsp(content)
	dump(content, "gloryTaskRewardRsp", 5)
	SoraDCloseLoading()
	local err = content.err
	if err == gErrDef.Err_None then
		local rspdata = content.rspdata
		if rspdata.missionInfo then
			local taskID = tostring(rspdata.missionInfo.taskID)
			self.gloryTask[taskID] = rspdata.missionInfo
		end
		if rspdata.reward then
			SoraDMailGainItems(rspdata.reward, true)
		end
		_ENV = rspdata.reward
		rspdata.reward.msg = "MESSAGE_SERVER_HONOR_BACK_UPDATE_TASK"
		SoraDSendMessage(rspdata.reward)
	end
end
function honorBackCtrl:buyGiftRsp(content)
	local err = content.err
	if err == gErrDef.Err_None then
		local giftid = content.data.rechargeID
		local orderID = content.rspdata.orderID
		paymentManager.purchase(giftid, orderID)
	else
		print("adderGiftCtrl:buyGiftRsp err", content.err)
		_ENV = "adderGiftCtrl:buyGiftRsp err"
		;("adderGiftCtrl:buyGiftRsp err").msg = "MESSAGE_SERVER_HONOR_BACK_UPDATE_GIFTS"
		SoraDSendMessage("adderGiftCtrl:buyGiftRsp err")
		SoraDCloseLoading()
		paymentManager.isInRecharging = false
	end
end
function honorBackCtrl:honorLoginGiftRsp(content)
	dump(content, "honorLoginGiftRsp", 5)
	if content.err == gErrDef.Err_None then
		local rspdata = content.rspdata
		self.loginRewardFlag = rspdata.loginRewardFlag
		if rspdata.rewardInfo then
			SoraDMailGainItems(rspdata.rewardInfo, true)
		end
		_ENV = rspdata.rewardInfo
		rspdata.rewardInfo.msg = "MESSAGE_SERVER_HONOR_BACK_UPDATE_TASK"
		SoraDSendMessage(rspdata.rewardInfo)
		_ENV = rspdata.rewardInfo
		rspdata.rewardInfo.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		rspdata.rewardInfo.eventID = gActivityTimeActivityID.FRIEND_HONORBACK
		SoraDSendMessage(rspdata.rewardInfo)
	end
end
function honorBackCtrl:honorNewReturnGiftRsp(content)
	dump(content, "friendsCallbackCtrl:honorNewReturnGiftRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.newReturnGiftFlag = content.rspdata.newReturnGiftFlag
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_HONOR_RETURN_GIFT"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function honorBackCtrl:getCanReceiveByDay(day)
	return false
end
function honorBackCtrl:isAlreadyReceiveByDay(day)
	return false
end
function honorBackCtrl:getCurrentDay()
	return 1
end
function honorBackCtrl:getLoginDaysState(days)
	if self.loginDays and days <= self.loginDays then
		if self.loginRewardFlag[tostring(days)] then
			return gFriendCallbackTaskStatus.TASK_STATUS_COMPLETE_DONE
		else
			return gFriendCallbackTaskStatus.TASK_STATUS_COMPLETE
		end
	else
		return gFriendCallbackTaskStatus.TASK_STATUS_DOING
	end
end
function honorBackCtrl:getLoginDays(...)
	return self.loginDays or 0
end
function honorBackCtrl:checkHonorBackGift(...)
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.FRIEND_HONORBACK) and self.isReturnBack and not self.newReturnGiftFlag then
		return true
	end
end
function honorBackCtrl:getLastLogoutTime(...)
	return self.lastLogoutTime or 0
end
return honorBackCtrl

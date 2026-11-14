local wiseTutorRead = include("wiseTutorRead")
local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local wiseTutorCtrl = class("wiseTutorCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function wiseTutorCtrl:ctor(properties)
	wiseTutorCtrl.super.ctor(self, properties)
	self:resetData()
	self.activityID = gActivityTimeActivityID.WISE_TUTOR_ACTIVITY
end
function wiseTutorCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_PALACE_OF_WISDOM_MODULE, gCmd.REQ_PALACE_OF_WISDOM_DATA, handler(self, self.reqPalaceOfWisdomDataRsp))
	msgCtrl.register(gCmd.CMD_PALACE_OF_WISDOM_MODULE, gCmd.REQ_PALACE_OF_WISDOM_REWARD, handler(self, self.reqPalaceOfWisdomRewardRsp))
	msgCtrl.register(gCmd.CMD_PALACE_OF_WISDOM_MODULE, gCmd.REQ_PALACE_OF_WISDOM_TASK, handler(self, self.reqPalaceOfWisdomTaskRsp))
	msgCtrl.register(gCmd.CMD_PALACE_OF_WISDOM_MODULE, gCmd.REQ_PALACE_OF_WISDOM_GIFT, handler(self, self.reqPalaceOfWisdomGiftRsp))
	msgCtrl.register(gCmd.CMD_PALACE_OF_WISDOM_MODULE, gCmd.REQ_PALACE_OF_WISDOM_UNLOCK, handler(self, self.reqPalaceOfWisdomUnlockRsp))
	self:registerNotify()
end
function wiseTutorCtrl:Logout()
	wiseTutorCtrl.super.Logout(self)
	self:resetData()
end
function wiseTutorCtrl:resetData()
	self.activityData, _UPVALUE0_ = nil, nil
	self.giftMsgData = nil
	self.questComponent = nil
end
function wiseTutorCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.PALACE_OF_WISDOM, handler(self, self.notifyHandler))
end
function wiseTutorCtrl:notifyHandler(event)
	dump(event.data, "wiseTutorCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		if v.type == "progressUpdate" then
			if self.questComponent then
				self.questComponent:onNotify_progressUpdate(v.notifyData)
			end
		elseif v.type == "resetActivity" then
			self.activityData = v.data
			self:createQuestComponent(v.data.quest)
			_ENV = self
			self.msg = "MESSAGE_WISE_TUTOR_REFRESH"
			SoraDSendMessage(self)
			_ENV = self
			self.msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
			self.activityID = self.activityID
			SoraDSendMessage(self)
		elseif v.type == "updateExpNLv" then
			self.activityData.curLevel = v.data.curLevel
			self.activityData.curExp = v.data.curExp
			_ENV = v.data.curExp
			v.data.curExp.msg = "MESSAGE_WISE_TUTOR_REFRESH"
			v.data.curExp.subMsg = "upgradeLv"
			SoraDSendMessage(v.data.curExp)
		elseif v.type == "buyGift" then
			if v.success then
				_ENV = v.data.curExp
				v.data.curExp.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
				v.data.curExp.eventID = self.activityID
				SoraDSendMessage(v.data.curExp)
				paymentManager.loopForFinishTransaction()
				local reward = v.reward
				local giftInfo = wiseTutorRead.getGiftAwardInfo(self:getLevelIndex())
				if giftInfo then
					_ENV = self:getLevelIndex()
					self:getLevelIndex().id = gIDDef.GOLD
					self:getLevelIndex().count = giftInfo.Gold
					table.insert(reward, self:getLevelIndex())
				end
				local rid = v.rid
				_ENV = reward
				reward.result = true
				reward.rid = rid
				self.giftMsgData, reward.itemList = reward, reward
			end
		elseif v.type == "unlockFurther" then
			self.activityData.bUnlockFurther = v.data.bUnlockFurther
			_ENV = v.data.bUnlockFurther
			v.data.bUnlockFurther.msg = "MESSAGE_WISE_TUTOR_REFRESH"
			v.data.bUnlockFurther.subMsg = "upgradeLock"
			v.data.bUnlockFurther.showUnlock = true
			SoraDSendMessage(v.data.bUnlockFurther)
		end
	end
end
function wiseTutorCtrl:sendReqInitDataMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_PALACE_OF_WISDOM_MODULE, gCmd.REQ_PALACE_OF_WISDOM_DATA, nil)
end
function wiseTutorCtrl:reqPalaceOfWisdomReward()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_PALACE_OF_WISDOM_MODULE, gCmd.REQ_PALACE_OF_WISDOM_REWARD, nil)
end
function wiseTutorCtrl:reqPalaceOfWisdomTask(questID)
	serverproxy = nil
	;(nil).questID = questID
	serverproxy:Request(gCmd.CMD_PALACE_OF_WISDOM_MODULE, gCmd.REQ_PALACE_OF_WISDOM_TASK, nil)
end
function wiseTutorCtrl:reqPalaceOfWisdomGift()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_PALACE_OF_WISDOM_MODULE, gCmd.REQ_PALACE_OF_WISDOM_GIFT, nil)
end
function wiseTutorCtrl:reqPalaceOfWisdomUnlock()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_PALACE_OF_WISDOM_MODULE, gCmd.REQ_PALACE_OF_WISDOM_UNLOCK, nil)
end
function wiseTutorCtrl:reqPalaceOfWisdomDataRsp(content)
	dump(content, "wiseTutorCtrl:reqPalaceOfWisdomDataRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		if not content.rspdata then
			_ENV = content.rspdata
		end
		self.activityData = content.rspdata
		self:createQuestComponent(content.rspdata.quest)
		_ENV = self
		self.msg = "MESSAGE_WISE_TUTOR_REFRESH"
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		self.activityID = self.activityID
		SoraDSendMessage(self)
	else
	end
end
function wiseTutorCtrl:reqPalaceOfWisdomRewardRsp(content)
	dump(content, "wiseTutorCtrl:reqPalaceOfWisdomRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.activityData.gotGiftList = content.rspdata.gotGiftList
		self.activityData.gotGiftListFurther = content.rspdata.gotGiftListFurther
		local _ENV, param = self.activityData, self.activityData
		if content.rspdata.reward and next(content.rspdata.reward) then
			_ENV = 10
			;(10).isSpecial = false
			;(10).reward = content.rspdata.reward
			table.insert(param, 10)
		end
		if content.rspdata.rewardFurther and next(content.rspdata.rewardFurther) then
			_ENV = 10
			;(10).isSpecial = true
			;(10).reward = content.rspdata.rewardFurther
			table.insert(param, 10)
		end
		uiManager:show("wiseTutorGainAward", param)
		_ENV = uiManager
		uiManager.msg = "MESSAGE_WISE_TUTOR_REFRESH"
		uiManager.subMsg = "upgradeLv"
		SoraDSendMessage(uiManager)
	else
		SoraDShowMsgTip(i18n("alliance_stronghold_text_008"))
	end
end
function wiseTutorCtrl:reqPalaceOfWisdomTaskRsp(content)
	dump(content, "wiseTutorCtrl:reqPalaceOfWisdomTaskRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV = content.err
		local _ENV, content.err.err, myContent = content.err, content.err, content.err
		content.err.questID = content.data.questID
		content.err.reward = content.rspdata.reward
		myContent.rspdata, content.err.activityID = content.err, self.activityID
		self.questComponent:reqRuestClaimRewardRsp(myContent)
	else
		local questID = content.data.questID
		_ENV = self.questComponent
		self.questComponent.msg = "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD"
		self.questComponent.activityID = self.activityID
		self.questComponent.questID = questID
		self.questComponent.isSuccess = false
		SoraDSendMessage(self.questComponent)
	end
end
function wiseTutorCtrl:reqPalaceOfWisdomGiftRsp(content)
	dump(content, "wiseTutorCtrl:reqPalaceOfWisdomGiftRsp(content)", 10)
	SoraDCloseLoading()
	if content.err == gErrDef.Err_None then
		local orderID = content.rspdata.orderID
		paymentManager.purchase(content.rspdata.rechargeID, orderID)
	end
end
function wiseTutorCtrl:reqPalaceOfWisdomUnlockRsp(content)
	dump(content, "wiseTutorCtrl:reqPalaceOfWisdomUnlockRsp(content)", 10)
	SoraDCloseLoading()
	if content.err == gErrDef.Err_None then
		self.activityData.bUnlockFurther = content.rspdata.bUnlockFurther
		_ENV = content.rspdata.bUnlockFurther
		content.rspdata.bUnlockFurther.msg = "MESSAGE_WISE_TUTOR_REFRESH"
		content.rspdata.bUnlockFurther.subMsg = "upgradeLock"
		content.rspdata.bUnlockFurther.showUnlock = true
		SoraDSendMessage(content.rspdata.bUnlockFurther)
	end
end
function wiseTutorCtrl:createQuestComponent(questData)
	if self.questComponent then
		self.questComponent:setQuestData(questData)
	else
		local activityTaskComponent = include("activityTaskComponent")
		self.questComponent = activityTaskComponent.new()
		self.questComponent:setActivityID(self.activityID)
		self.questComponent:setQuestData(questData)
	end
end
function wiseTutorCtrl:getStateInfo()
	local state = gActivityState.CLOSE
	local time = (self.activityData.nextRefreshTime or 0) - serviceFunctions.systemTime()
	if self.activityData.beginTime and 0 < self.activityData.beginTime and 0 < time then
		state = gActivityState.OPEN
	end
	return state, time
end
function wiseTutorCtrl:isUnLock()
	return self.activityData.bUnlockFurther
end
function wiseTutorCtrl:getExp()
	return self.activityData.curExp
end
function wiseTutorCtrl:getLevel()
	return self.activityData.curLevel
end
function wiseTutorCtrl:getLevelIndex()
	return self.activityData.curLevelIndex
end
function wiseTutorCtrl:isNormalRewardGot(key)
	if self.activityData.gotGiftList[tostring(key)] then
		return true
	end
	return false
end
function wiseTutorCtrl:isSpecialRewardGot(key)
	if self.activityData.gotGiftListFurther[tostring(key)] then
		return true
	end
	return false
end
function wiseTutorCtrl:isTaskClaimed(taskID)
	if self.questComponent then
		return self.questComponent:isTaskClaimed(taskID)
	end
	return false
end
function wiseTutorCtrl:isTaskFinished(taskID)
	if self.questComponent then
		return self.questComponent:isTaskFinished(taskID)
	end
	return false
end
function wiseTutorCtrl:getTaskProgress(taskID)
	if self.questComponent then
		return self.questComponent:getTaskProgress(taskID)
	end
	return 0
end
function wiseTutorCtrl:isNormalRewardGet(lv)
	if lv and lv <= self:getLevel() and not self:isNormalRewardGot(lv) then
		return true
	end
	return false
end
function wiseTutorCtrl:isSpecialRewardGet(lv)
	if lv and self:isUnLock() and lv <= self:getLevel() and not self:isSpecialRewardGot(lv) then
		return true
	end
	return false
end
function wiseTutorCtrl:isSpecialRewardGetEx(lv)
	if lv and lv <= self:getLevel() and not self:isSpecialRewardGot(lv) then
		return true
	end
	return false
end
function wiseTutorCtrl:getLvRewardStatusAndNum()
	local num = 0
	for i, index in ipairs(wiseTutorRead.getLvRewardList(self:getLevelIndex())) do
		local lvInfo = wiseTutorRead.getRewardInfoByIndex(index)
		local lv = lvInfo.Lv
		if lv then
			if self:isNormalRewardGet(lv) then
				num = num + math.ceil(#lvInfo.LvReward1 / 2)
			end
			if self:isSpecialRewardGet(lv) then
				num = num + math.ceil(#lvInfo.LvReward2 / 2)
			end
		end
	end
	return num
end
function wiseTutorCtrl:getTaskStatusAndNum()
	local redNum = 0
	if self.questComponent then
		local _
		_, redNum = self.questComponent:getReceiveStatusAndNumByQuestList(wiseTutorRead.getTaskListByIndex(self:getLevelIndex()))
	end
	return redNum
end
function wiseTutorCtrl:getLockStatusAndNum()
	local itemInfo = wiseTutorRead.getUnlockItem(self:getLevelIndex())
	dump(itemInfo, "wiseTutorCtrl:getReceiveStatusAndNum")
	if itemInfo and next(itemInfo) then
		local isCanLock = include("publicUtil").getCount(itemInfo[1]) >= itemInfo[2]
		return isCanLock and not self:isUnLock()
	end
	return false
end
function wiseTutorCtrl:getReceiveStatusAndNum()
	local redNum = self:getTaskStatusAndNum()
	redNum = redNum + self:getLvRewardStatusAndNum()
	redNum = redNum + (self:getLockStatusAndNum() and 1 or 0)
	return 0 < redNum, redNum
end
function wiseTutorCtrl:getTaskList()
	local taskList = wiseTutorRead.getTaskListByIndex(self:getLevelIndex())
	table.sort(taskList, function(l, r)
		local lState = self:getTaskState(l)
		local rState = self:getTaskState(r)
		if lState == rState then
			return l < r
		else
			return lState < rState
		end
	end)
	return taskList
end
function wiseTutorCtrl:getTaskState(taskID)
	return self:isTaskClaimed(taskID) and gBtnTargetStatusDef.GOT or self:isTaskFinished(taskID) and gBtnTargetStatusDef.GET or gBtnTargetStatusDef.GO
end
function wiseTutorCtrl:isMaxLevel()
	return SoraDGetCastleLv() > wiseTutorRead.getMaxEffectCastleLv()
end
function wiseTutorCtrl:isBuffEffect()
	return self:isUnLock() and not self:isMaxLevel()
end
function wiseTutorCtrl:getBuffVale(effectType)
	_ENV = nil
	;(nil)[gBuffEffect.UPGRADE_CASTLE_COST_RES_REDUCE_FOR_POW] = 1
	local (nil)[gBuffEffect.BUILD_SPEED_BOOST_FOR_POW], effectTypeToIndex = 2, nil
	local steate, _ = self:getStateInfo()
	local effectInfo = wiseTutorRead.getNowEffectInfo(SoraDGetCastleLv()).PrivilegeEffect
	if steate == gActivityState.OPEN and effectInfo and self:isBuffEffect() and effectTypeToIndex[effectType] then
		local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
		local index = effectTypeToIndex[effectType]
		local effect, _ = buffltCtrl:getEffect(effectInfo[index or 1])
		print(effect, "wiseTutorCtrleffect")
		return effect
	else
		return 0
	end
end
function wiseTutorCtrl:isTaskShow(fogLv)
	local info = SoraDGetCtrl("kingdomMapCtrl"):getNormalFogData()
	if info and info.lv then
		return fogLv < info.lv
	else
		return true
	end
end
function wiseTutorCtrl:getGiftMsgData()
	return self.giftMsgData
end
function wiseTutorCtrl:resetGiftData()
	self.giftMsgData = nil
end
return wiseTutorCtrl

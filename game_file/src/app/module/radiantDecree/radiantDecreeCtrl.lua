local radiantDecreeRead = include("radiantDecreeRead")
local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local radiantDecreeCtrl = class("radiantDecreeCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function radiantDecreeCtrl:ctor(properties)
	radiantDecreeCtrl.super.ctor(self, properties)
	self:resetData()
	self.activityID = gActivityTimeActivityID.RADIANT_DECREE_ACTIVITY
	self.initData = false
end
function radiantDecreeCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_RADIANT_DECREE_MODULE, gCmd.REQ_RADIANT_DECREE_DATA, handler(self, self.reqRadiantDecreeDataRsp))
	msgCtrl.register(gCmd.CMD_RADIANT_DECREE_MODULE, gCmd.REQ_RADIANT_DECREE_REWARD, handler(self, self.reqRadiantDecreeRewardRsp))
	msgCtrl.register(gCmd.CMD_RADIANT_DECREE_MODULE, gCmd.REQ_RADIANT_DECREE_TASK, handler(self, self.reqRadiantDecreeTaskRsp))
	msgCtrl.register(gCmd.CMD_RADIANT_DECREE_MODULE, gCmd.REQ_RADIANT_DECREE_GIFT, handler(self, self.reqRadiantDecreeGiftRsp))
	msgCtrl.register(gCmd.CMD_RADIANT_DECREE_MODULE, gCmd.REQ_RADIANT_DECREE_UNLOCK, handler(self, self.reqRadiantDecreeUnlockRsp))
	msgCtrl.register(gCmd.CMD_RADIANT_DECREE_MODULE, gCmd.REQ_RADIANT_DECREE_GIFTEX, handler(self, self.reqRadiantDecreeStatusGiftRsp))
	self:registerNotify()
end
function radiantDecreeCtrl:Logout()
	radiantDecreeCtrl.super.Logout(self)
	self:resetData()
end
function radiantDecreeCtrl:resetData()
	self.activityData, _UPVALUE0_ = nil, nil
	self.giftMsgData = nil
	self.questComponent = nil
	self.activityData.bUnlockFurther = false
	self.activityData.beginTime = 0
end
function radiantDecreeCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.REDIANT_DECREE, handler(self, self.notifyHandler))
end
function radiantDecreeCtrl:notifyHandler(event)
	dump(event.data, "radiantDecreeCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		if v.type == "progressUpdate" then
			if self.questComponent then
				self.questComponent:onNotify_progressUpdate(v.notifyData)
			end
		elseif v.type == "resetActivity" then
			self.activityData = v.data
			self:createQuestComponent(v.data.quest)
			_ENV = self
			self.msg = "MESSAGE_RADIANT_DECREE_REFRESH"
			SoraDSendMessage(self)
			_ENV = self
			self.msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
			self.activityID = self.activityID
			SoraDSendMessage(self)
		elseif v.type == "updateExpNLv" then
			self.activityData.curLevel = v.data.curLevel
			self.activityData.curExp = v.data.curExp
			_ENV = v.data.curExp
			v.data.curExp.msg = "MESSAGE_RADIANT_DECREE_REFRESH"
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
				local giftInfo = radiantDecreeRead.getGiftInfoByRid(v.rid)
				if giftInfo then
					_ENV = nil
					;(nil).id = gIDDef.GOLD
					;(nil).count = giftInfo.Gold
					table.insert(reward, nil)
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
			v.data.bUnlockFurther.msg = "MESSAGE_RADIANT_DECREE_REFRESH"
			v.data.bUnlockFurther.subMsg = "upgradeLock"
			v.data.bUnlockFurther.showUnlock = true
			SoraDSendMessage(v.data.bUnlockFurther)
		elseif v.type == "unlockFurtherStatue" then
			self.activityData.bUnlockFurtherStatue = v.data.bUnlockFurtherStatue
			_ENV = v.data.bUnlockFurtherStatue
			v.data.bUnlockFurtherStatue.msg = "MESSAGE_RADIANT_DECREE_REFRESH"
			v.data.bUnlockFurtherStatue.subMsg = "unlockStatue"
			SoraDSendMessage(v.data.bUnlockFurtherStatue)
		elseif v.type == "beginActivity" then
			self.initData = true
			if not v.data then
				_ENV = v.data
			end
			self.activityData = v.data
			self:createQuestComponent(v.data.quest)
			_ENV = self
			self.msg = "MESSAGE_RADIANT_DECREE_REFRESH"
			self.subMsg = "init"
			SoraDSendMessage(self)
			_ENV = self
			self.msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
			self.activityID = self.activityID
			SoraDSendMessage(self)
		end
	end
end
function radiantDecreeCtrl:sendReqInitDataMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_RADIANT_DECREE_MODULE, gCmd.REQ_RADIANT_DECREE_DATA, nil)
end
function radiantDecreeCtrl:reqRadiantDecreeReward()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_RADIANT_DECREE_MODULE, gCmd.REQ_RADIANT_DECREE_REWARD, nil)
end
function radiantDecreeCtrl:reqRadiantDecreeTask(questID)
	serverproxy = nil
	;(nil).questID = questID
	serverproxy:Request(gCmd.CMD_RADIANT_DECREE_MODULE, gCmd.REQ_RADIANT_DECREE_TASK, nil)
end
function radiantDecreeCtrl:reqRadiantDecreeGift()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_RADIANT_DECREE_MODULE, gCmd.REQ_RADIANT_DECREE_GIFT, nil)
end
function radiantDecreeCtrl:reqRadiantDecreeUnlock()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_RADIANT_DECREE_MODULE, gCmd.REQ_RADIANT_DECREE_UNLOCK, nil)
end
function radiantDecreeCtrl:reqRadiantDecreeStatueGift()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_RADIANT_DECREE_MODULE, gCmd.REQ_RADIANT_DECREE_GIFTEX, nil)
end
function radiantDecreeCtrl:reqRadiantDecreeDataRsp(content)
	dump(content, "radiantDecreeCtrl:reqRadiantDecreeDataRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData = true
		if not content.rspdata then
			_ENV = content.rspdata
		end
		self.activityData = content.rspdata
		self:createQuestComponent(content.rspdata.quest)
		_ENV = self
		self.msg = "MESSAGE_RADIANT_DECREE_REFRESH"
		self.subMsg = "init"
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		self.activityID = self.activityID
		SoraDSendMessage(self)
		return
	end
	if content.err == gErrDef.Err_PALACE_OF_WISDOM_NOT_OPEN then
		self.initData = false
		_ENV = gErrDef.Err_PALACE_OF_WISDOM_NOT_OPEN
		gErrDef.Err_PALACE_OF_WISDOM_NOT_OPEN.msg = "MESSAGE_RADIANT_DECREE_REFRESH"
		gErrDef.Err_PALACE_OF_WISDOM_NOT_OPEN.subMsg = "notOpen"
		SoraDSendMessage(gErrDef.Err_PALACE_OF_WISDOM_NOT_OPEN)
	end
end
function radiantDecreeCtrl:reqRadiantDecreeRewardRsp(content)
	dump(content, "radiantDecreeCtrl:reqRadiantDecreeRewardRsp(content)", 10)
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
		_ENV = param
		param.msg = "MESSAGE_RADIANT_DECREE_REFRESH"
		param.subMsg = "reward"
		param.param = param
		SoraDSendMessage(param)
		return
	end
	if content.err == gErrDef.Err_PALACE_OF_WISDOM_NO_REWARD then
		_ENV = gErrDef.Err_PALACE_OF_WISDOM_NO_REWARD
		gErrDef.Err_PALACE_OF_WISDOM_NO_REWARD.msg = "MESSAGE_RADIANT_DECREE_REFRESH"
		gErrDef.Err_PALACE_OF_WISDOM_NO_REWARD.subMsg = "noReward"
		SoraDSendMessage(gErrDef.Err_PALACE_OF_WISDOM_NO_REWARD)
	end
end
function radiantDecreeCtrl:reqRadiantDecreeTaskRsp(content)
	dump(content, "radiantDecreeCtrl:reqRadiantDecreeTaskRsp(content)", 10)
	if content.err == gErrDef.Err_None and content.rspdata and content.data then
		local questId = content.data.questID
		_ENV = gErrDef.Err_None
		local _ENV, gErrDef.Err_None.err, myContent = content.err, content.err, gErrDef.Err_None
		content.err.questID = questId
		content.err.reward = content.rspdata.reward
		myContent.rspdata, content.err.activityID = content.err, self.activityID
		self.questComponent:reqRuestClaimRewardRsp(myContent)
		_ENV = self.questComponent
		self.questComponent.msg = "MESSAGE_RADIANT_DECREE_REFRESH"
		self.questComponent.subMsg = "taskReturn"
		SoraDSendMessage(self.questComponent)
	elseif content.data and content.data.questID then
		local questId = content.data.questID
		_ENV = SoraDSendMessage
		SoraDSendMessage.msg = "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD"
		SoraDSendMessage.activityID = self.activityID
		SoraDSendMessage.questID = questId
		SoraDSendMessage.isSuccess = false
		SoraDSendMessage(SoraDSendMessage)
		_ENV = SoraDSendMessage
		SoraDSendMessage.msg = "MESSAGE_RADIANT_DECREE_REFRESH"
		SoraDSendMessage.subMsg = "taskReturn"
		SoraDSendMessage(SoraDSendMessage)
	end
end
function radiantDecreeCtrl:reqRadiantDecreeGiftRsp(content)
	dump(content, "radiantDecreeCtrl:reqRadiantDecreeGiftRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local orderID = content.rspdata.orderID
		paymentManager.purchase(content.rspdata.rechargeID, orderID)
		return
	end
	if content.err == gErrDef.Err_PALACE_OF_WISDOM_UNLOCKED then
		_ENV = gErrDef.Err_PALACE_OF_WISDOM_UNLOCKED
		gErrDef.Err_PALACE_OF_WISDOM_UNLOCKED.msg = "MESSAGE_RADIANT_DECREE_REFRESH"
		gErrDef.Err_PALACE_OF_WISDOM_UNLOCKED.subMsg = "alreadyUnlock"
		SoraDSendMessage(gErrDef.Err_PALACE_OF_WISDOM_UNLOCKED)
	end
end
function radiantDecreeCtrl:reqRadiantDecreeStatusGiftRsp(content)
	dump(content, "radiantDecreeCtrl:reqRadiantDecreeGiftRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local orderID = content.rspdata.orderID
		paymentManager.purchase(content.rspdata.rechargeID, orderID)
		return
	end
	if content.err == gErrDef.Err_PALACE_OF_WISDOM_UNLOCKED then
		_ENV = gErrDef.Err_PALACE_OF_WISDOM_UNLOCKED
		gErrDef.Err_PALACE_OF_WISDOM_UNLOCKED.msg = "MESSAGE_RADIANT_DECREE_REFRESH"
		gErrDef.Err_PALACE_OF_WISDOM_UNLOCKED.subMsg = "alreadyUnlock"
		SoraDSendMessage(gErrDef.Err_PALACE_OF_WISDOM_UNLOCKED)
	end
end
function radiantDecreeCtrl:reqRadiantDecreeUnlockRsp(content)
	dump(content, "radiantDecreeCtrl:reqRadiantDecreeUnlockRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.activityData.bUnlockFurther = content.rspdata.bUnlockFurther
		_ENV = content.rspdata.bUnlockFurther
		content.rspdata.bUnlockFurther.msg = "MESSAGE_RADIANT_DECREE_REFRESH"
		content.rspdata.bUnlockFurther.subMsg = "unlock"
		SoraDSendMessage(content.rspdata.bUnlockFurther)
		return
	end
	if content.err == gErrDef.Err_PALACE_OF_WISDOM_UNLOCKED then
		_ENV = gErrDef.Err_PALACE_OF_WISDOM_UNLOCKED
		gErrDef.Err_PALACE_OF_WISDOM_UNLOCKED.msg = "MESSAGE_RADIANT_DECREE_REFRESH"
		gErrDef.Err_PALACE_OF_WISDOM_UNLOCKED.subMsg = "alreadyUnlock"
		SoraDSendMessage(gErrDef.Err_PALACE_OF_WISDOM_UNLOCKED)
	end
end
function radiantDecreeCtrl:createQuestComponent(questData)
	if self.questComponent then
		self.questComponent:setQuestData(questData)
	else
		local activityTaskComponent = include("activityTaskComponent")
		self.questComponent = activityTaskComponent.new()
		self.questComponent:setActivityID(self.activityID)
		self.questComponent:setQuestData(questData)
	end
end
function radiantDecreeCtrl:getStateInfo()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local param = activityShowCtrl:getParamByID(self.activityID)
	if activityShowCtrl:getStateByID(self.activityID) == gActivityState.OPEN and (SoraDGetBuildStarLv() >= param.limitMinLevel and SoraDGetBuildStarLv() <= param.limitMaxLevel or self:isActOpen()) then
		local eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
		if self.activityData and eventTime then
			return gActivityState.OPEN, eventTime.timerNode.timer:getRemainTime()
		else
			return gActivityState.CLOSE
		end
	end
	return gActivityState.CLOSE
end
function radiantDecreeCtrl:isDataInit()
	return self.initData and table.nums(self.activityData) > 0
end
function radiantDecreeCtrl:getActivityData()
	return self.activityData
end
function radiantDecreeCtrl:isUnLock()
	return self.activityData.bUnlockFurther
end
function radiantDecreeCtrl:isUnLockStatue()
	return self.activityData.bUnlockFurtherStatue
end
function radiantDecreeCtrl:canUnlockStatue()
	if SoraDIsBraveOpen() then
		return true
	end
	return false
end
function radiantDecreeCtrl:getShowNum()
	local isShowCity = not self:isUnLock()
	local isShowStatue = self:canUnlockStatue() and not self:isUnLockStatue()
	return (isShowCity and 1 or 0) + (isShowStatue and 2 or 0)
end
function radiantDecreeCtrl:isActOpen()
	if not self.activityData or not self.activityData.beginTime then
		return false
	end
	return self.activityData.beginTime > 0 and true or false
end
function radiantDecreeCtrl:getExp()
	return self.activityData.curExp
end
function radiantDecreeCtrl:getLevel()
	return self.activityData.curLevel
end
function radiantDecreeCtrl:getLimitMinLevel()
	if not self.activityData.limitLevel then
		return 0
	end
	return self.activityData.limitLevel[1]
end
function radiantDecreeCtrl:getLimitMaxLevel()
	if not self.activityData.limitLevel then
		return 0
	end
	return self.activityData.limitLevel[2]
end
function radiantDecreeCtrl:getLevelIndex()
	return self.activityData.curLevelIndex
end
function radiantDecreeCtrl:getGiftIndex(isStatue)
	if isStatue then
		return radiantDecreeRead.getGiftIndex(self.activityData.statueLevel, isStatue)
	else
		return radiantDecreeRead.getGiftIndex(self.activityData.castleLevel, isStatue)
	end
end
function radiantDecreeCtrl:getCurEffectIndex()
	return self.activityData.curEffectIndex or 0
end
function radiantDecreeCtrl:isNormalRewardGot(key)
	if self.activityData.gotGiftList[tostring(key)] then
		return true
	end
	return false
end
function radiantDecreeCtrl:isSpecialRewardGot(key)
	if self.activityData.gotGiftListFurther[tostring(key)] then
		return true
	end
	return false
end
function radiantDecreeCtrl:isTaskClaimed(taskID)
	if self.questComponent then
		return self.questComponent:isTaskClaimed(taskID)
	end
	return false
end
function radiantDecreeCtrl:isTaskFinished(taskID)
	if self.questComponent then
		return self.questComponent:isTaskFinished(taskID)
	end
	return false
end
function radiantDecreeCtrl:getTaskProgress(taskID)
	if self.questComponent then
		return self.questComponent:getTaskProgress(taskID)
	end
	return 0
end
function radiantDecreeCtrl:isNormalRewardGet(lv)
	if lv and lv <= self:getLevel() and not self:isNormalRewardGot(lv) then
		return true
	end
	return false
end
function radiantDecreeCtrl:isSpecialRewardGet(lv)
	if lv and self:isUnLock() and lv <= self:getLevel() and not self:isSpecialRewardGot(lv) then
		return true
	end
	return false
end
function radiantDecreeCtrl:isSpecialRewardGetEx(lv)
	if lv and lv <= self:getLevel() and not self:isSpecialRewardGot(lv) then
		return true
	end
	return false
end
function radiantDecreeCtrl:getLvRewardStatusAndNum()
	local num = 0
	for i, index in ipairs(radiantDecreeRead.getLvRewardList(self:getLevelIndex())) do
		local lvInfo = radiantDecreeRead.getRewardInfoByIndex(index)
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
function radiantDecreeCtrl:getTaskStatusAndNum()
	local redNum = 0
	if self.questComponent then
		local _
		_, redNum = self.questComponent:getReceiveStatusAndNumByQuestList(radiantDecreeRead.getTaskListByIndex(self:getLevelIndex()))
	end
	return redNum
end
function radiantDecreeCtrl:getLockStatusAndNum()
	do return false end
	local itemInfo = radiantDecreeRead.getUnlockItem(self:getLevelIndex())
	if itemInfo and next(itemInfo) then
		local isCanLock = include("publicUtil").getCount(itemInfo[1]) >= itemInfo[2]
		return isCanLock and not self:isUnLock()
	end
	return false
end
function radiantDecreeCtrl:getReceiveStatusAndNum()
	local redNum = self:getTaskStatusAndNum()
	redNum = redNum + self:getLvRewardStatusAndNum()
	redNum = redNum + (self:getLockStatusAndNum() and 1 or 0)
	return 0 < redNum, redNum
end
function radiantDecreeCtrl:getTaskList()
	local taskList = radiantDecreeRead.getTaskListByIndex(self:getLevelIndex())
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
function radiantDecreeCtrl:getTaskState(taskID)
	return self:isTaskClaimed(taskID) and gBtnTargetStatusDef.GOT or self:isTaskFinished(taskID) and gBtnTargetStatusDef.GET or gBtnTargetStatusDef.GO
end
function radiantDecreeCtrl:isMaxLevel()
	return SoraDGetBuildStarLv() > self:getLimitMaxLevel()
end
function radiantDecreeCtrl:isMaxEffect()
	return SoraDGetBuildStarLv() > self:getLimitMaxLevel()
end
_ENV, radiantDecreeCtrl.isBuffEffect = function(self, bid, iid)
	local state, leftTime = self:getStateInfo()
	if state == gActivityState.OPEN then
		if bid == BUILDID.STAR_BRAVE_STATUE then
			return self:isUnLockStatue() and self:isEffectLv(bid, iid, true)
		else
			return self:isUnLock() and self:isLvEnough() and self:isEffectLv(bid, iid, false)
		end
	end
	return false
end, function(self, bid, iid)
	local state, leftTime = self:getStateInfo()
	if state == gActivityState.OPEN then
		if bid == BUILDID.STAR_BRAVE_STATUE then
			return self:isUnLockStatue() and self:isEffectLv(bid, iid, true)
		else
			return self:isUnLock() and self:isLvEnough() and self:isEffectLv(bid, iid, false)
		end
	end
	return false
end
;(function(self, bid, iid)
	local state, leftTime = self:getStateInfo()
	if state == gActivityState.OPEN then
		if bid == BUILDID.STAR_BRAVE_STATUE then
			return self:isUnLockStatue() and self:isEffectLv(bid, iid, true)
		else
			return self:isUnLock() and self:isLvEnough() and self:isEffectLv(bid, iid, false)
		end
	end
	return false
end)[gBuffEffect.RADIANT_DECREE_UPGRADE_COST_RES_REDUCE] = false
;(function(self, bid, iid)
	local state, leftTime = self:getStateInfo()
	if state == gActivityState.OPEN then
		if bid == BUILDID.STAR_BRAVE_STATUE then
			return self:isUnLockStatue() and self:isEffectLv(bid, iid, true)
		else
			return self:isUnLock() and self:isLvEnough() and self:isEffectLv(bid, iid, false)
		end
	end
	return false
end)[gBuffEffect.RADIANT_DECREE_BUILD_SPEED_BOOST] = false
;(function(self, bid, iid)
	local state, leftTime = self:getStateInfo()
	if state == gActivityState.OPEN then
		if bid == BUILDID.STAR_BRAVE_STATUE then
			return self:isUnLockStatue() and self:isEffectLv(bid, iid, true)
		else
			return self:isUnLock() and self:isLvEnough() and self:isEffectLv(bid, iid, false)
		end
	end
	return false
end)[gBuffEffect.RADIANT_DECREE_AMBER_REDUCE] = false
;(function(self, bid, iid)
	local state, leftTime = self:getStateInfo()
	if state == gActivityState.OPEN then
		if bid == BUILDID.STAR_BRAVE_STATUE then
			return self:isUnLockStatue() and self:isEffectLv(bid, iid, true)
		else
			return self:isUnLock() and self:isLvEnough() and self:isEffectLv(bid, iid, false)
		end
	end
	return false
end)[gBuffEffect.RADIANT_DECREE_ASTRAL_MINE_REDUCE] = false
;(function(self, bid, iid)
	local state, leftTime = self:getStateInfo()
	if state == gActivityState.OPEN then
		if bid == BUILDID.STAR_BRAVE_STATUE then
			return self:isUnLockStatue() and self:isEffectLv(bid, iid, true)
		else
			return self:isUnLock() and self:isLvEnough() and self:isEffectLv(bid, iid, false)
		end
	end
	return false
end)[gBuffEffect.RADIANT_DECREE_UPGRADE_COST_RES_REDUCE_STATUE] = true
;(function(self, bid, iid)
	local state, leftTime = self:getStateInfo()
	if state == gActivityState.OPEN then
		if bid == BUILDID.STAR_BRAVE_STATUE then
			return self:isUnLockStatue() and self:isEffectLv(bid, iid, true)
		else
			return self:isUnLock() and self:isLvEnough() and self:isEffectLv(bid, iid, false)
		end
	end
	return false
end)[gBuffEffect.RADIANT_DECREE_BUILD_SPEED_BOOST_STATUE] = true
;(function(self, bid, iid)
	local state, leftTime = self:getStateInfo()
	if state == gActivityState.OPEN then
		if bid == BUILDID.STAR_BRAVE_STATUE then
			return self:isUnLockStatue() and self:isEffectLv(bid, iid, true)
		else
			return self:isUnLock() and self:isLvEnough() and self:isEffectLv(bid, iid, false)
		end
	end
	return false
end)[gBuffEffect.RADIANT_DECREE_AMBER_REDUCE_STATUE] = true
local (function(self, bid, iid)
	local state, leftTime = self:getStateInfo()
	if state == gActivityState.OPEN then
		if bid == BUILDID.STAR_BRAVE_STATUE then
			return self:isUnLockStatue() and self:isEffectLv(bid, iid, true)
		else
			return self:isUnLock() and self:isLvEnough() and self:isEffectLv(bid, iid, false)
		end
	end
	return false
end)[gBuffEffect.RADIANT_DECREE_ASTRAL_MINE_REDUCE_STATUE], isStatueByEffectType = true, function(self, bid, iid)
	local state, leftTime = self:getStateInfo()
	if state == gActivityState.OPEN then
		if bid == BUILDID.STAR_BRAVE_STATUE then
			return self:isUnLockStatue() and self:isEffectLv(bid, iid, true)
		else
			return self:isUnLock() and self:isLvEnough() and self:isEffectLv(bid, iid, false)
		end
	end
	return false
end
function radiantDecreeCtrl:getBuffVale(effectType, buildData)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.RADIANT_DECREE_ACTIVITY) then
		return 0
	end
	if not buildData then
		buildData, _ENV = 0, 0
	end
	if not self:isBuffEffect(buildData.bid, buildData.iid) then
		return 0
	end
	_ENV = 0
	;(0)[gBuffEffect.RADIANT_DECREE_UPGRADE_COST_RES_REDUCE] = 1
	;(0)[gBuffEffect.RADIANT_DECREE_BUILD_SPEED_BOOST] = 2
	;(0)[gBuffEffect.RADIANT_DECREE_AMBER_REDUCE] = 3
	local _ENV, (0)[gBuffEffect.RADIANT_DECREE_ASTRAL_MINE_REDUCE], effectTypeToIndex = gBuffEffect.RADIANT_DECREE_ASTRAL_MINE_REDUCE, 4, 0
	gBuffEffect.RADIANT_DECREE_ASTRAL_MINE_REDUCE[gBuffEffect.RADIANT_DECREE_UPGRADE_COST_RES_REDUCE_STATUE] = 1
	gBuffEffect.RADIANT_DECREE_ASTRAL_MINE_REDUCE[gBuffEffect.RADIANT_DECREE_BUILD_SPEED_BOOST_STATUE] = 2
	gBuffEffect.RADIANT_DECREE_ASTRAL_MINE_REDUCE[gBuffEffect.RADIANT_DECREE_AMBER_REDUCE_STATUE] = 3
	local gBuffEffect.RADIANT_DECREE_ASTRAL_MINE_REDUCE[gBuffEffect.RADIANT_DECREE_ASTRAL_MINE_REDUCE_STATUE], braveEffectTypeToIndex = 4, gBuffEffect.RADIANT_DECREE_ASTRAL_MINE_REDUCE
	local effectInfo = radiantDecreeRead.getNowEffectInfo().PrivilegeEffect
	if isStatueByEffectType[effectType] then
		effectInfo = radiantDecreeRead.getNowStatueEffectInfo().PrivilegeEffect
	end
	if effectInfo and (effectTypeToIndex[effectType] or braveEffectTypeToIndex[effectType]) then
		local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
		local index = effectTypeToIndex[effectType] or braveEffectTypeToIndex[effectType]
		if effectInfo[index or 1] == nil then
			return 0
		end
		local effect, _ = buffltCtrl:getEffect(effectInfo[index or 1])
		return effect
	else
		return 0
	end
end
function radiantDecreeCtrl:isTaskShow(fogLv)
	local info = SoraDGetCtrl("kingdomMapCtrl"):getNormalFogData()
	if info and info.lv then
		return fogLv < info.lv
	else
		return true
	end
end
function radiantDecreeCtrl:isLvEnough()
	local lv = self:getLevel()
	if lv ~= nil and lv >= radiantDecreeRead.getBuffLimitLv(self:getLevelIndex()) then
		return true
	end
	return false
end
function radiantDecreeCtrl:isEffectLv(bid, iid, isStatue)
	local cityCtrl = SoraDGetCtrl("cityCtrl")
	local lv = cityCtrl:getBuildStarLv(bid, iid)
	if lv < radiantDecreeRead.getMaxEffectLevel(isStatue) then
		return true
	end
	return false
end
function radiantDecreeCtrl:getGiftMsgData()
	return self.giftMsgData
end
function radiantDecreeCtrl:resetGiftData()
	self.giftMsgData = nil
end
return radiantDecreeCtrl

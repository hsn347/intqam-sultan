local artisanHouseltCtrl = include("artisanHouseltCtrl")
local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local artisanHouseCtrl = class("artisanHouseCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function artisanHouseCtrl:ctor(properties)
	artisanHouseCtrl.super.ctor(self, properties)
	self:resetData()
	self.activityID = gActivityTimeActivityID.ARTISAN_HOUSE_ACTIVITY
	self.initData = false
end
function artisanHouseCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_CRAFTSMAN_PALACE_MODULE, gCmd.REQ_CRAFTSMAN_PALACE_DATA, handler(self, self.reqPalaceOfCraftsmanDataRsp))
	msgCtrl.register(gCmd.CMD_CRAFTSMAN_PALACE_MODULE, gCmd.REQ_CRAFTSMAN_PALACE_REWARD, handler(self, self.reqPalaceOfCraftsmanRewardRsp))
	msgCtrl.register(gCmd.CMD_CRAFTSMAN_PALACE_MODULE, gCmd.REQ_CRAFTSMAN_PALACE_TASK, handler(self, self.reqPalaceOfCraftsmanTaskRsp))
	msgCtrl.register(gCmd.CMD_CRAFTSMAN_PALACE_MODULE, gCmd.REQ_CRAFTSMAN_PALACE_GIFT, handler(self, self.reqPalaceOfCraftsmanGiftRsp))
	msgCtrl.register(gCmd.CMD_CRAFTSMAN_PALACE_MODULE, gCmd.REQ_CRAFTSMAN_PALACE_UNLOCK, handler(self, self.reqPalaceOfCraftsmanUnlockRsp))
	self:registerNotify()
end
function artisanHouseCtrl:Logout()
	artisanHouseCtrl.super.Logout(self)
	self:resetData()
end
function artisanHouseCtrl:resetData()
	self.activityData, _UPVALUE0_ = nil, nil
	self.giftMsgData = nil
	self.questComponent = nil
	self.activityData.bUnlockFurther = false
	self.activityData.beginTime = 0
end
function artisanHouseCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.CRAFTSMAN_PALACE, handler(self, self.notifyHandler))
end
function artisanHouseCtrl:notifyHandler(event)
	dump(event.data, "artisanHouseCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		if v.type == "progressUpdate" then
			if self.questComponent then
				self.questComponent:onNotify_progressUpdate(v.notifyData)
			end
		elseif v.type == "resetActivity" then
			self.activityData = v.data
			self:createQuestComponent(v.data.quest)
			_ENV = self
			self.msg = "MESSAGE_ARTISAN_HOUSE_REFRESH"
			SoraDSendMessage(self)
			_ENV = self
			self.msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
			self.activityID = self.activityID
			SoraDSendMessage(self)
		elseif v.type == "updateExpNLv" then
			self.activityData.curLevel = v.data.curLevel
			self.activityData.curExp = v.data.curExp
			_ENV = v.data.curExp
			v.data.curExp.msg = "MESSAGE_ARTISAN_HOUSE_REFRESH"
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
				local giftInfo = artisanHouseltCtrl.getGiftAwardInfo(self:getLevelIndex())
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
			v.data.bUnlockFurther.msg = "MESSAGE_ARTISAN_HOUSE_REFRESH"
			v.data.bUnlockFurther.subMsg = "upgradeLock"
			v.data.bUnlockFurther.showUnlock = true
			SoraDSendMessage(v.data.bUnlockFurther)
		elseif v.type == "beginActivity" then
			self.initData = true
			if not v.data then
				_ENV = v.data
			end
			self.activityData = v.data
			self:createQuestComponent(v.data.quest)
			_ENV = self
			self.msg = "MESSAGE_ARTISAN_HOUSE_REFRESH"
			self.subMsg = "init"
			SoraDSendMessage(self)
			_ENV = self
			self.msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
			self.activityID = self.activityID
			SoraDSendMessage(self)
		end
	end
end
function artisanHouseCtrl:sendReqInitDataMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_CRAFTSMAN_PALACE_MODULE, gCmd.REQ_CRAFTSMAN_PALACE_DATA, nil)
end
function artisanHouseCtrl:reqPalaceOfCraftsmanReward()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_CRAFTSMAN_PALACE_MODULE, gCmd.REQ_CRAFTSMAN_PALACE_REWARD, nil)
end
function artisanHouseCtrl:reqPalaceOfCraftsmanTask(questID)
	serverproxy = nil
	;(nil).questID = questID
	serverproxy:Request(gCmd.CMD_CRAFTSMAN_PALACE_MODULE, gCmd.REQ_CRAFTSMAN_PALACE_TASK, nil)
end
function artisanHouseCtrl:reqPalaceOfCraftsmanGift()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_CRAFTSMAN_PALACE_MODULE, gCmd.REQ_CRAFTSMAN_PALACE_GIFT, nil)
end
function artisanHouseCtrl:reqPalaceOfCraftsmanUnlock()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_CRAFTSMAN_PALACE_MODULE, gCmd.REQ_CRAFTSMAN_PALACE_UNLOCK, nil)
end
function artisanHouseCtrl:reqPalaceOfCraftsmanDataRsp(content)
	dump(content, "artisanHouseCtrl:reqPalaceOfCraftsmanDataRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData = true
		if not content.rspdata then
			_ENV = content.rspdata
		end
		self.activityData = content.rspdata
		self:createQuestComponent(content.rspdata.quest)
		_ENV = self
		self.msg = "MESSAGE_ARTISAN_HOUSE_REFRESH"
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
		gErrDef.Err_PALACE_OF_WISDOM_NOT_OPEN.msg = "MESSAGE_ARTISAN_HOUSE_REFRESH"
		gErrDef.Err_PALACE_OF_WISDOM_NOT_OPEN.subMsg = "notOpen"
		SoraDSendMessage(gErrDef.Err_PALACE_OF_WISDOM_NOT_OPEN)
	end
end
function artisanHouseCtrl:reqPalaceOfCraftsmanRewardRsp(content)
	dump(content, "artisanHouseCtrl:reqPalaceOfCraftsmanRewardRsp(content)", 10)
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
		param.msg = "MESSAGE_ARTISAN_HOUSE_REFRESH"
		param.subMsg = "reward"
		param.param = param
		SoraDSendMessage(param)
		return
	end
	if content.err == gErrDef.Err_PALACE_OF_WISDOM_NO_REWARD then
		_ENV = gErrDef.Err_PALACE_OF_WISDOM_NO_REWARD
		gErrDef.Err_PALACE_OF_WISDOM_NO_REWARD.msg = "MESSAGE_ARTISAN_HOUSE_REFRESH"
		gErrDef.Err_PALACE_OF_WISDOM_NO_REWARD.subMsg = "noReward"
		SoraDSendMessage(gErrDef.Err_PALACE_OF_WISDOM_NO_REWARD)
	end
end
function artisanHouseCtrl:reqPalaceOfCraftsmanTaskRsp(content)
	dump(content, "artisanHouseCtrl:reqPalaceOfCraftsmanTaskRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local questId = content.data.questID
		_ENV = gErrDef.Err_None
		local _ENV, gErrDef.Err_None.err, myContent = content.err, content.err, gErrDef.Err_None
		content.err.questID = questId
		content.err.reward = content.rspdata.reward
		myContent.rspdata, content.err.activityID = content.err, self.activityID
		self.questComponent:reqRuestClaimRewardRsp(myContent)
		_ENV = self.questComponent
		self.questComponent.msg = "MESSAGE_ARTISAN_HOUSE_REFRESH"
		self.questComponent.subMsg = "taskReturn"
		SoraDSendMessage(self.questComponent)
	else
		local questId = content.data.questID
		_ENV = SoraDSendMessage
		SoraDSendMessage.msg = "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD"
		SoraDSendMessage.activityID = self.activityID
		SoraDSendMessage.questID = questId
		SoraDSendMessage.isSuccess = false
		SoraDSendMessage(SoraDSendMessage)
		_ENV = SoraDSendMessage
		SoraDSendMessage.msg = "MESSAGE_ARTISAN_HOUSE_REFRESH"
		SoraDSendMessage.subMsg = "taskReturn"
		SoraDSendMessage(SoraDSendMessage)
	end
end
function artisanHouseCtrl:reqPalaceOfCraftsmanGiftRsp(content)
	dump(content, "artisanHouseCtrl:reqPalaceOfCraftsmanGiftRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local orderID = content.rspdata.orderID
		paymentManager.purchase(content.rspdata.rechargeID, orderID)
		return
	end
	if content.err == gErrDef.Err_PALACE_OF_WISDOM_UNLOCKED then
		_ENV = gErrDef.Err_PALACE_OF_WISDOM_UNLOCKED
		gErrDef.Err_PALACE_OF_WISDOM_UNLOCKED.msg = "MESSAGE_ARTISAN_HOUSE_REFRESH"
		gErrDef.Err_PALACE_OF_WISDOM_UNLOCKED.subMsg = "alreadyUnlock"
		SoraDSendMessage(gErrDef.Err_PALACE_OF_WISDOM_UNLOCKED)
	end
end
function artisanHouseCtrl:reqPalaceOfCraftsmanUnlockRsp(content)
	dump(content, "artisanHouseCtrl:reqPalaceOfCraftsmanUnlockRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.activityData.bUnlockFurther = content.rspdata.bUnlockFurther
		_ENV = content.rspdata.bUnlockFurther
		content.rspdata.bUnlockFurther.msg = "MESSAGE_ARTISAN_HOUSE_REFRESH"
		content.rspdata.bUnlockFurther.subMsg = "unlock"
		SoraDSendMessage(content.rspdata.bUnlockFurther)
		return
	end
	if content.err == gErrDef.Err_PALACE_OF_WISDOM_UNLOCKED then
		_ENV = gErrDef.Err_PALACE_OF_WISDOM_UNLOCKED
		gErrDef.Err_PALACE_OF_WISDOM_UNLOCKED.msg = "MESSAGE_ARTISAN_HOUSE_REFRESH"
		gErrDef.Err_PALACE_OF_WISDOM_UNLOCKED.subMsg = "alreadyUnlock"
		SoraDSendMessage(gErrDef.Err_PALACE_OF_WISDOM_UNLOCKED)
	end
end
function artisanHouseCtrl:createQuestComponent(questData)
	if self.questComponent then
		self.questComponent:setQuestData(questData)
	else
		local activityTaskComponent = include("activityTaskComponent")
		self.questComponent = activityTaskComponent.new()
		self.questComponent:setActivityID(self.activityID)
		self.questComponent:setQuestData(questData)
	end
end
function artisanHouseCtrl:getStateInfo()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local param = activityShowCtrl:getParamByID(self.activityID)
	if activityShowCtrl:getStateByID(self.activityID) == gActivityState.OPEN and (SoraDGetCastleLv() >= param.limitMinLevel and SoraDGetCastleLv() <= param.limitMaxLevel or self:isActOpen()) then
		local eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.ARTISAN_HOUSE_ACTIVITY)
		if self.activityData and eventTime then
			return gActivityState.OPEN, eventTime.timerNode.timer:getRemainTime()
		else
			return gActivityState.CLOSE
		end
	end
	return gActivityState.CLOSE
end
function artisanHouseCtrl:isDataInit()
	return self.initData and table.nums(self.activityData) > 0
end
function artisanHouseCtrl:isUnLock()
	return self.activityData.bUnlockFurther
end
function artisanHouseCtrl:isActOpen()
	if not self.activityData or not self.activityData.beginTime then
		return false
	end
	return self.activityData.beginTime > 0 and true or false
end
function artisanHouseCtrl:getExp()
	return self.activityData.curExp
end
function artisanHouseCtrl:getLevel()
	return self.activityData.curLevel
end
function artisanHouseCtrl:getLimitMinLevel()
	return self.activityData.limitLevel[1]
end
function artisanHouseCtrl:getLevelIndex()
	return self.activityData.curLevelIndex
end
function artisanHouseCtrl:isNormalRewardGot(key)
	if self.activityData.gotGiftList[tostring(key)] then
		return true
	end
	return false
end
function artisanHouseCtrl:isSpecialRewardGot(key)
	if self.activityData.gotGiftListFurther[tostring(key)] then
		return true
	end
	return false
end
function artisanHouseCtrl:isTaskClaimed(taskID)
	if self.questComponent then
		return self.questComponent:isTaskClaimed(taskID)
	end
	return false
end
function artisanHouseCtrl:isTaskFinished(taskID)
	if self.questComponent then
		return self.questComponent:isTaskFinished(taskID)
	end
	return false
end
function artisanHouseCtrl:getTaskProgress(taskID)
	if self.questComponent then
		return self.questComponent:getTaskProgress(taskID)
	end
	return 0
end
function artisanHouseCtrl:isNormalRewardGet(lv)
	if lv and lv <= self:getLevel() and not self:isNormalRewardGot(lv) then
		return true
	end
	return false
end
function artisanHouseCtrl:isSpecialRewardGet(lv)
	if lv and self:isUnLock() and lv <= self:getLevel() and not self:isSpecialRewardGot(lv) then
		return true
	end
	return false
end
function artisanHouseCtrl:isSpecialRewardGetEx(lv)
	if lv and lv <= self:getLevel() and not self:isSpecialRewardGot(lv) then
		return true
	end
	return false
end
function artisanHouseCtrl:getLvRewardStatusAndNum()
	local num = 0
	for i, index in ipairs(artisanHouseltCtrl.getLvRewardList(self:getLevelIndex())) do
		local lvInfo = artisanHouseltCtrl.getRewardInfoByIndex(index)
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
function artisanHouseCtrl:getTaskStatusAndNum()
	local redNum = 0
	if self.questComponent then
		local _
		_, redNum = self.questComponent:getReceiveStatusAndNumByQuestList(artisanHouseltCtrl.getTaskListByIndex(self:getLevelIndex()))
	end
	return redNum
end
function artisanHouseCtrl:getLockStatusAndNum()
	local itemInfo = artisanHouseltCtrl.getUnlockItem(self:getLevelIndex())
	dump(itemInfo, "artisanHouseCtrl:getReceiveStatusAndNum")
	if itemInfo and next(itemInfo) then
		local isCanLock = include("publicUtil").getCount(itemInfo[1]) >= itemInfo[2]
		return isCanLock and not self:isUnLock()
	end
	return false
end
function artisanHouseCtrl:getReceiveStatusAndNum()
	local redNum = self:getTaskStatusAndNum()
	redNum = redNum + self:getLvRewardStatusAndNum()
	redNum = redNum + (self:getLockStatusAndNum() and 1 or 0)
	return 0 < redNum, redNum
end
function artisanHouseCtrl:getTaskList()
	local taskList = artisanHouseltCtrl.getTaskListByIndex(self:getLevelIndex())
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
function artisanHouseCtrl:getTaskState(taskID)
	return self:isTaskClaimed(taskID) and gBtnTargetStatusDef.GOT or self:isTaskFinished(taskID) and gBtnTargetStatusDef.GET or gBtnTargetStatusDef.GO
end
function artisanHouseCtrl:isMaxLevel()
	return SoraDGetCastleLv() > artisanHouseltCtrl.getMaxEffectCastleLv()
end
function artisanHouseCtrl:isBuffEffect()
	return self:isUnLock() and not self:isMaxLevel()
end
function artisanHouseCtrl:getBuffVale(effectType)
	_ENV = nil
	;(nil)[gBuffEffect.UPGRADE_CASTLE_COST_RES_REDUCE_FOR_POW] = 1
	local (nil)[gBuffEffect.BUILD_SPEED_BOOST_FOR_POW], effectTypeToIndex = 2, nil
	local steate, _ = self:getStateInfo()
	local effectInfo = artisanHouseltCtrl.getNowEffectInfo(SoraDGetCastleLv()).PrivilegeEffect
	if steate == gActivityState.OPEN and effectInfo and self:isBuffEffect() and effectTypeToIndex[effectType] then
		local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
		local index = effectTypeToIndex[effectType]
		local effect, _ = buffltCtrl:getEffect(effectInfo[index or 1])
		print(effect, "artisanHouseCtrleffect")
		return effect
	else
		return 0
	end
end
function artisanHouseCtrl:isTaskShow(fogLv)
	local info = SoraDGetCtrl("kingdomMapCtrl"):getNormalFogData()
	if info and info.lv then
		return fogLv < info.lv
	else
		return true
	end
end
function artisanHouseCtrl:getGiftMsgData()
	return self.giftMsgData
end
function artisanHouseCtrl:resetGiftData()
	self.giftMsgData = nil
end
return artisanHouseCtrl

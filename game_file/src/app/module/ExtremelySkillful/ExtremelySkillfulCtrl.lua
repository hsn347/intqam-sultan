local extremelySkillfulRead = include("extremelySkillfulRead")
local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local ExtremelySkillfulCtrl = class("ExtremelySkillfulCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function ExtremelySkillfulCtrl:ctor(properties)
	ExtremelySkillfulCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.EXTREMELY_SKILLFUIL
	self:resetData()
end
function ExtremelySkillfulCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_MARVELOUS_WORKMANSHIP_MODULE, gCmd.REQ_MARVELOUS_WORKMANSHIP_DATA, handler(self, self.reqMarvelousWorkmanshipDataRsp))
	msgCtrl.register(gCmd.CMD_MARVELOUS_WORKMANSHIP_MODULE, gCmd.REQ_MARVELOUS_WORKMANSHIP_REWARD, handler(self, self.reqMarvelousWorkmanshipRewardRsp))
	msgCtrl.register(gCmd.CMD_MARVELOUS_WORKMANSHIP_MODULE, gCmd.REQ_MARVELOUS_WORKMANSHIP_TASK, handler(self, self.reqMarvelousWorkmanshipTaskRsp))
	msgCtrl.register(gCmd.CMD_MARVELOUS_WORKMANSHIP_MODULE, gCmd.REQ_MARVELOUS_WORKMANSHIP_GIFT, handler(self, self.reqMarvelousWorkmanshipGiftRsp))
	self:registerNotify()
end
function ExtremelySkillfulCtrl:Logout()
	ExtremelySkillfulCtrl.super.Logout(self)
	self:resetData()
end
function ExtremelySkillfulCtrl:resetData()
	self.activityData, _UPVALUE0_ = nil, nil
	self.giftMsgData = nil
	self.questComponent = nil
end
function ExtremelySkillfulCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.MARVELOUS_WORKMANSHIP, handler(self, self.notifyHandler))
end
function ExtremelySkillfulCtrl:notifyHandler(event)
	dump(event.data, "ExtremelySkillfulCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		if v.notifyType == "progressUpdate" then
			if self.questComponent then
				self.questComponent:onNotify_progressUpdate(v.notifyData)
			end
		elseif v.notifyType == "updateExp" then
			self.activityData.curLevel = v.curLevel
			self.activityData.curExp = v.curExp
			self.activityData.exp = v.exp
			_ENV = v.exp
			v.exp.msg = "MESSAGE_EXTREMELY_SKILLFUL_REFRESH"
			v.exp.subMsg = "upgradeLv"
			SoraDSendMessage(v.exp)
			_ENV = v.exp
			v.exp.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
			v.exp.eventID = self.activityID
			SoraDSendMessage(v.exp)
		elseif v.notifyType == "buyGift" and v.success then
			paymentManager.loopForFinishTransaction()
			local reward = v.reward
			local giftInfo = extremelySkillfulRead.getGiftAwardInfoByRid(v.rid, self:getGroupIndex())
			if giftInfo then
				_ENV = self:getGroupIndex()
				self:getGroupIndex().id = gIDDef.GOLD
				self:getGroupIndex().count = giftInfo.Gold
				table.insert(reward, self:getGroupIndex())
			end
			local rid = v.rid
			_ENV = reward
			reward.result = true
			reward.rid = rid
			self.giftMsgData, reward.itemList = reward, reward
			if rid == 19183 then
				self.activityData.bUnlockFurther = true
				_ENV = self:getGroupIndex()
				self:getGroupIndex().title = "MarvelousWorkmanship_18"
				uiManager:show("ExtremelySkillfulUnlock", self:getGroupIndex())
			else
				self.activityData.bUnlockFurtherEx = true
				_ENV = self:getGroupIndex()
				self:getGroupIndex().title = "MarvelousWorkmanship_19"
				uiManager:show("ExtremelySkillfulUnlock", self:getGroupIndex())
			end
			_ENV = uiManager
			uiManager.msg = "MESSAGE_EXTREMELY_SKILLFUL_REFRESH"
			uiManager.subMsg = "upgradeLock"
			uiManager.showUnlock = true
			SoraDSendMessage(uiManager)
			_ENV = uiManager
			uiManager.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
			uiManager.eventID = self.activityID
			SoraDSendMessage(uiManager)
		end
	end
end
function ExtremelySkillfulCtrl:sendReqInitDataMsg()
	print("clientEventMgr.judgeIsOpen(self.activityID)", clientEventMgr.judgeIsOpen(self.activityID), self.activityID)
	if self:isActivityOpen() then
		_ENV = nil
		serverproxy:Request(gCmd.CMD_MARVELOUS_WORKMANSHIP_MODULE, gCmd.REQ_MARVELOUS_WORKMANSHIP_DATA, nil)
	end
end
function ExtremelySkillfulCtrl:reqMarvelousWorkmanshipReward()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_MARVELOUS_WORKMANSHIP_MODULE, gCmd.REQ_MARVELOUS_WORKMANSHIP_REWARD, nil)
end
function ExtremelySkillfulCtrl:reqMarvelousWorkmanshipTask(questID)
	serverproxy = nil
	;(nil).questID = questID
	serverproxy:Request(gCmd.CMD_MARVELOUS_WORKMANSHIP_MODULE, gCmd.REQ_MARVELOUS_WORKMANSHIP_TASK, nil)
end
function ExtremelySkillfulCtrl:reqMarvelousWorkmanshipGift(giftType)
	serverproxy = nil
	;(nil).giftType = giftType
	serverproxy:Request(gCmd.CMD_MARVELOUS_WORKMANSHIP_MODULE, gCmd.REQ_MARVELOUS_WORKMANSHIP_GIFT, nil)
end
function ExtremelySkillfulCtrl:reqMarvelousWorkmanshipDataRsp(content)
	dump(content, "ExtremelySkillfulCtrl:reqMarvelousWorkmanshipDataRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		if not content.rspdata then
			_ENV = content.rspdata
		end
		self.activityData = content.rspdata
		self:createQuestComponent(content.rspdata.quest)
		_ENV = self
		self.msg = "MESSAGE_EXTREMELY_SKILLFUL_REFRESH"
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		self.activityID = self.activityID
		SoraDSendMessage(self)
	end
end
function ExtremelySkillfulCtrl:reqMarvelousWorkmanshipRewardRsp(content)
	dump(content, "ExtremelySkillfulCtrl:reqMarvelousWorkmanshipRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.activityData.rewardLevel = content.rspdata.rewardLevel
		self.activityData.rewardLevelFurther = content.rspdata.rewardLevelFurther
		self.activityData.rewardLevelFurtherEx = content.rspdata.rewardLevelFurtherEx
		local _ENV, param = self.activityData, self.activityData
		if not content.rspdata.rewardGrade then
			local _ENV, rewardGrade = content.rspdata.rewardGrade, content.rspdata.rewardGrade
		end
		if rewardGrade.grade1 and next(rewardGrade.grade1) then
			_ENV = nil
			;(nil).index = 0
			;(nil).reward = rewardGrade.grade1
			;(nil).title = "MarvelousWorkmanship_24"
			table.insert(param, nil)
		end
		if rewardGrade.grade2 and next(rewardGrade.grade2) then
			_ENV = nil
			;(nil).index = 1
			;(nil).reward = rewardGrade.grade2
			;(nil).title = "MarvelousWorkmanship_25"
			table.insert(param, nil)
		end
		if rewardGrade.grade3 and next(rewardGrade.grade3) then
			_ENV = nil
			;(nil).index = 2
			;(nil).reward = rewardGrade.grade3
			;(nil).title = "MarvelousWorkmanship_26"
			table.insert(param, nil)
		end
		uiManager:show("ExtremelySkillfulGainAward", param)
		_ENV = uiManager
		uiManager.msg = "MESSAGE_EXTREMELY_SKILLFUL_REFRESH"
		uiManager.subMsg = "gainReward"
		SoraDSendMessage(uiManager)
	else
		SoraDShowMsgTip(i18n("alliance_stronghold_text_008"))
	end
end
function ExtremelySkillfulCtrl:reqMarvelousWorkmanshipTaskRsp(content)
	dump(content, "ExtremelySkillfulCtrl:reqMarvelousWorkmanshipTaskRsp(content)", 10)
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
function ExtremelySkillfulCtrl:reqMarvelousWorkmanshipGiftRsp(content)
	dump(content, "ExtremelySkillfulCtrl:reqMarvelousWorkmanshipGiftRsp(content)", 10)
	SoraDCloseLoading()
	if content.err == gErrDef.Err_None then
		local orderID = content.rspdata.orderID
		local rechargeID = extremelySkillfulRead.getGiftAwardInfo(content.data.giftType, self:getGroupIndex()).RechargeID
		paymentManager.purchase(rechargeID, orderID)
	end
end
function ExtremelySkillfulCtrl:createQuestComponent(questData)
	if self.questComponent then
		self.questComponent:setQuestData(questData)
	else
		local activityTaskComponent = include("activityTaskComponent")
		self.questComponent = activityTaskComponent.new()
		self.questComponent:setActivityID(self.activityID)
		self.questComponent:setQuestData(questData)
	end
end
function ExtremelySkillfulCtrl:getRewardLevel()
	return self.activityData.rewardLevel or 0
end
function ExtremelySkillfulCtrl:getRewardLevelFurther()
	return self.activityData.rewardLevelFurther or 0
end
function ExtremelySkillfulCtrl:getRewardLevelFurtherEx()
	return self.activityData.rewardLevelFurtherEx or 0
end
function ExtremelySkillfulCtrl:getUnlockFurther()
	return self.activityData.bUnlockFurther
end
function ExtremelySkillfulCtrl:getUnlockFurtherEx()
	return self.activityData.bUnlockFurtherEx
end
function ExtremelySkillfulCtrl:getBuffIndex()
	if self:getUnlockFurtherEx() then
		return 3
	elseif self:getUnlockFurther() then
		return 2
	else
		if self:getLevel() >= 10 then
			return 1
		end
		return 0
	end
end
function ExtremelySkillfulCtrl:getExp()
	return self.activityData.curExp or 0
end
function ExtremelySkillfulCtrl:getLevel()
	return self.activityData.curLevel or 0
end
function ExtremelySkillfulCtrl:isMaxLvByType(type)
	local info = extremelySkillfulRead.getMaxEffectCastleLv(type, self:getGroupIndex())
	if info[1] == 1 then
		return SoraDGetCastleLv() > info[3]
	elseif info[1] == 2 then
		return SoraDGetBuildStarLv() > info[3]
	end
	return true
end
function ExtremelySkillfulCtrl:getGroupIndex()
	return SoraDGetCtrl("activityShowCtrl"):getParamClassType(self.activityID)
end
function ExtremelySkillfulCtrl:getTaskList()
	local taskList = extremelySkillfulRead.getTaskListByIndex(self:getGroupIndex())
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
function ExtremelySkillfulCtrl:getTaskState(taskID)
	return self:isTaskClaimed(taskID) and gBtnTargetStatusDef.GOT or self:isTaskFinished(taskID) and gBtnTargetStatusDef.GET or gBtnTargetStatusDef.GO
end
function ExtremelySkillfulCtrl:isTaskClaimed(taskID)
	if self.questComponent then
		return self.questComponent:isTaskClaimed(taskID)
	end
	return false
end
function ExtremelySkillfulCtrl:isTaskFinished(taskID)
	if self.questComponent then
		return self.questComponent:isTaskFinished(taskID)
	end
	return false
end
function ExtremelySkillfulCtrl:getTaskProgress(taskID)
	if self.questComponent then
		return self.questComponent:getTaskProgress(taskID)
	end
	return 0
end
function ExtremelySkillfulCtrl:getGiftMsgData()
	return self.giftMsgData
end
function ExtremelySkillfulCtrl:resetGiftData()
	self.giftMsgData = nil
end
function ExtremelySkillfulCtrl:isTaskShow(fogLv)
	local info = SoraDGetCtrl("kingdomMapCtrl"):getNormalFogData()
	if info and info.lv then
		return fogLv < info.lv
	else
		return true
	end
end
function ExtremelySkillfulCtrl:getRewardState(type, lv)
	if type == 1 then
		if lv <= self:getRewardLevel() then
			return gBtnTargetStatusDef.GOT
		elseif lv <= self:getLevel() then
			return gBtnTargetStatusDef.GET
		end
	elseif type == 2 then
		if lv <= self:getRewardLevelFurther() then
			return gBtnTargetStatusDef.GOT
		elseif self:getUnlockFurther() and lv <= self:getLevel() then
			return gBtnTargetStatusDef.GET
		end
	elseif type == 3 then
		if lv <= self:getRewardLevelFurtherEx() then
			return gBtnTargetStatusDef.GOT
		elseif self:getUnlockFurtherEx() and lv <= self:getLevel() then
			return gBtnTargetStatusDef.GET
		end
	end
	return gBtnTargetStatusDef.GO
end
function ExtremelySkillfulCtrl:getBuffVale(effectType)
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		return 0
	end
	local value = 0
	local index = self:getBuffIndex()
	for i = 1, 3 do
		local effectInfo, isEffect = extremelySkillfulRead.getNowEffectInfo(i)
		local privilegeEffect = effectInfo.PrivilegeEffect
		if i <= index and isEffect then
			local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
			for i, v in ipairs(privilegeEffect) do
				if buffltCtrl:getEffectType(v) == effectType then
					local effect, _ = buffltCtrl:getEffect(v)
					print("ExtremelySkillfulCtrl:getBuffVale-3", effect, effectType, index, i)
					value = value + effect
					break
				end
			end
		end
	end
	return value
end
function ExtremelySkillfulCtrl:isBuffEffect()
	local index = self:getBuffIndex()
	for i = 1, 3 do
		local effectInfo, isEffect = extremelySkillfulRead.getNowEffectInfo(i)
		if i <= index and isEffect then
			return true
		end
	end
	return false
end
function ExtremelySkillfulCtrl:isActivityOpen()
	if clientEventMgr.judgeIsOpen(self.activityID) then
		local limitLevel = SoraDGetCtrl("activityShowCtrl"):getParamByID(self.activityID)
		local nowLv = SoraDGetCastleLv()
		if limitLevel and nowLv >= (limitLevel.limitMinLevel or 9999) and nowLv <= (limitLevel.limitMaxLevel or 0) then
			return true
		end
	end
	return false
end
function ExtremelySkillfulCtrl:getLvRewardStatusAndNum()
	local num = 0
	for i, lvInfo in ipairs(extremelySkillfulRead.getLvRewardList(self:getGroupIndex())) do
		local lv = lvInfo.Lv
		if lv then
			if self:getRewardState(1, lv) == gBtnTargetStatusDef.GET then
				num = num + math.ceil(#lvInfo.LvReward1 / 2)
			end
			if self:getRewardState(2, lv) == gBtnTargetStatusDef.GET then
				num = num + math.ceil(#lvInfo.LvReward2 / 2)
			end
			if self:getRewardState(3, lv) == gBtnTargetStatusDef.GET then
				num = num + math.ceil(#lvInfo.LvReward3 / 2)
			end
		end
	end
	return num
end
function ExtremelySkillfulCtrl:getTaskStatusAndNum()
	local redNum = 0
	if self.questComponent then
		local _
		_, redNum = self.questComponent:getReceiveStatusAndNumByQuestList(extremelySkillfulRead.getTaskListByIndex(self:getGroupIndex()))
	end
	return redNum
end
function ExtremelySkillfulCtrl:getLockStatusAndNum()
	return false
end
function ExtremelySkillfulCtrl:getReceiveStatusAndNum(activityID)
	local redNum = self:getTaskStatusAndNum()
	redNum = redNum + self:getLvRewardStatusAndNum()
	redNum = redNum + (self:getLockStatusAndNum() and 1 or 0)
	return 0 < redNum, redNum
end
function ExtremelySkillfulCtrl:getBuffInfoByTypeIndex(type, lv, buffIndex)
	local effectType
	local buffNum = 0
	local buffltCtrl = include("buffltCtrl")
	for i = 1, 3 do
		if i <= type then
			local info = extremelySkillfulRead.getNowEffectInfo(i, lv)
			local buffID = info.PrivilegeEffect[buffIndex]
			effectType = buffltCtrl:getEffectType(buffID)
			buffNum = buffNum + (buffltCtrl:getEffect(buffID) or 0)
		end
	end
	return effectType, buffNum
end
return ExtremelySkillfulCtrl

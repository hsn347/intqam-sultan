local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local nebulaCelebrationRead = include("nebulaCelebrationRead")
local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
local eventQuestRead = include("eventQuestRead")
local nebulaCelebrationCtrl = class("nebulaCelebrationCtrl", gamemodulec)
_ENV = "nebulaCelebrationCtrl"
;("nebulaCelebrationCtrl").Daily = 1
local ("nebulaCelebrationCtrl").Normal, QuestType = 2, "nebulaCelebrationCtrl"
local activityID = gActivityTimeActivityID.NEBULA_CELEBRATION_ACTIVITY
function nebulaCelebrationCtrl:ctor(properties)
	nebulaCelebrationCtrl.super.ctor(self, properties)
	self:resetData()
end
function nebulaCelebrationCtrl:initClientData(data)
	dump(data, "nebulaCelebrationCtrl:initClientData", 10)
end
function nebulaCelebrationCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_NEBULA_CELEBRATION_MODULE, gCmd.REQ_NEBULA_CELEBRATION_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_CELEBRATION_MODULE, gCmd.REQ_NEBULA_CELEBRATION_CLAIM_REWARD, handler(self, self.reqClaimRewardRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_CELEBRATION_MODULE, gCmd.REQ_NEBULA_CELEBRATION_BUY_STARLIGHT, handler(self, self.reqBuyStarLightRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_CELEBRATION_MODULE, gCmd.REQ_NEBULA_CELEBRATION_RECIEVE_REWARD, handler(self, self.reqRecieveRewardRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_CELEBRATION_MODULE, gCmd.REQ_NEBULA_CELEBRATION_BUY_GIFT, handler(self, self.reqBuyGiftRsp))
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.NEBULA_CELEBRATION, handler(self, self.notifyHandler))
	self:sendReqInit()
end
function nebulaCelebrationCtrl:notifyHandler(event)
	dump(event.data, "nebulaCelebrationCtrl:notifyHandler", 10)
	for _, data in ipairs(event.data) do
		if data.notifyType == "refreshData" then
			self:setData(data.notifyData)
			_ENV = self
			self.msg = "MESSAGE_NEBULA_CELEBRATION_INIT"
			SoraDSendMessage(self)
		elseif data.notifyType == "buyGift" then
			self:popRechargeSuccessView(data.notifyData)
			self:setUnlockFlag(true)
			_ENV = self
			self.msg = "MESSAGE_NEBULA_CELEBRATION_BUY_GIFT_SUCCESS"
			self.data = data.notifyData
			SoraDSendMessage(self)
		end
	end
end
function nebulaCelebrationCtrl:setUnlockFlag(v)
	self._unlockFlag = v
end
function nebulaCelebrationCtrl:getUnlockFlag()
	return self._unlockFlag
end
function nebulaCelebrationCtrl:popRechargeSuccessView(v)
	local rechargePopMsg = function(goods, mid, rid)
		if goods and next(goods) ~= nil then
			_ENV = nil
			;(nil).itemList = goods
			;(nil).mailID = mid
			;(nil).rid = rid
			uiManager:show("gemGoodsBuyGiftSuccess", nil)
		end
	end
	local _rid = v.rid
	local goods = v.reward
	local mailID = v.mailID
	rechargePopMsg(goods, mailID, _rid)
end
function nebulaCelebrationCtrl:onActivityOpen()
	self:sendReqInit()
end
function nebulaCelebrationCtrl:isActivityOpen()
	return SoraDGetCtrl("activityShowCtrl"):isActivityOpen(activityID)
end
function nebulaCelebrationCtrl:onActivityClose()
	self:resetData()
end
function nebulaCelebrationCtrl:resetData()
	_UPVALUE0_ = nil
	;(nil).isSeniorRewardUnlock = false
	;(nil).round = 0
	;(nil).dailyQuestData, (nil).claimedQuest, _UPVALUE0_, (nil).finishedQuest, _UPVALUE0_, (nil).questProgress, _UPVALUE0_, _UPVALUE0_, (nil).questData, (nil).claimedQuest, _UPVALUE0_, (nil).finishedQuest, _UPVALUE0_, (nil).questProgress, _UPVALUE0_, _UPVALUE0_, (nil).starlightNum = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 0
	;(nil).maxSeniorRewardLv = 0
	;(nil).maxRewardLv = 0
	;(nil).lv = 0
	self.data, (nil).exp = nil, 0
	self.lv = 0
	self.exp = 0
	self.expMax = 0
end
function nebulaCelebrationCtrl:setData(data)
	self.data = data
	self.lv, self.exp, self.expMax = nebulaCelebrationRead.getLvByExp(self:getClassType(), self.data.starlightNum)
end
function nebulaCelebrationCtrl:isTaskClaimed(taskId, questType)
	local data = self:getQuestData(questType)
	return data and data.claimedQuest and data.claimedQuest[tostring(taskId)]
end
function nebulaCelebrationCtrl:isTaskFinished(taskId, questType)
	local data = self:getQuestData(questType)
	return data and data.finishedQuest and data.finishedQuest[tostring(taskId)]
end
function nebulaCelebrationCtrl:getTaskProgress(taskId, questType)
	local data = self:getQuestData(questType)
	return data and data.questProgress and data.questProgress[tostring(taskId)] or 0
end
function nebulaCelebrationCtrl:getQuestData(questType)
	if questType == QuestType.Daily then
		return self.data.dailyQuestData
	else
		return self.data.questData
	end
end
function nebulaCelebrationCtrl:getTaskAmount(taskId)
	local taskCfg = eventQuestRead.getTaskConfig(taskId)
	if taskCfg and taskCfg.aim then
		return taskCfg.aim
	end
	return 0
end
function nebulaCelebrationCtrl:skipTo(taskInfo, taskDes)
	print("任务跳转：", taskInfo.taskID)
	local guideId = taskInfo.guideId
	local tbParam = mildGuideManager:splitGuideParam(guideId)
	if tbParam.id == gNewPLayerTaskType.POP_TIP then
		SoraDShowMsgTip(i18n(taskDes))
	end
	if guideId then
		local ret, notNeedClose = mildGuideManager:starMildByNewPlayerStringParam(guideId)
		if not notNeedClose then
			SoraDRemoveAllPanelFromManager()
		end
	end
end
function nebulaCelebrationCtrl:taskReddot()
	return self:hasTaskRewardByType(QuestType.Daily) or self:hasTaskRewardByType(QuestType.Normal)
end
function nebulaCelebrationCtrl:hasTaskRewardByType(questType)
	local questData = self:getQuestData(questType)
	if not questData or not questData.finishedQuest then
		return false
	end
	for key, value in pairs(questData.finishedQuest) do
		if not questData.claimedQuest or not questData.claimedQuest[key] then
			return true
		end
	end
end
function nebulaCelebrationCtrl:getTaskList(questType)
	if questType == QuestType.Daily then
		return nebulaCelebrationRead.getDailyTaskList(self:getClassType())
	else
		local questList = nebulaCelebrationRead.getTaskList(self:getClassType())
		local QuestType, ret = self:getClassType()
		for _, listQuest in ipairs(questList) do
			local finalQuestId
			for _, questId in ipairs(listQuest) do
				finalQuestId = questId
				if not self:isTaskClaimed(questId, QuestType.Normal) then
					break
				end
			end
			table.insert(ret, finalQuestId)
		end
		return ret
	end
end
function nebulaCelebrationCtrl:getClassType()
	local param = SoraDGetCtrl("activityShowCtrl"):getParamByID(activityID)
	return param.classtype or 1
end
function nebulaCelebrationCtrl:getActivitySeasonEndTime()
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local endTime = activityShowCtrl:getEndTimeSecond(activityID)
	return endTime
end
function nebulaCelebrationCtrl:getActivityLeftTime()
	local endTime = self:getActivitySeasonEndTime()
	local sysTime = serviceFunctions.systemTime()
	if endTime > sysTime then
		return endTime - sysTime
	end
	return 0
end
function nebulaCelebrationCtrl:isActiveGold()
	return self.data.isSeniorRewardUnlock
end
function nebulaCelebrationCtrl:getStarlightNum()
	return self.data.starlightNum
end
function nebulaCelebrationCtrl:getCurLevel()
	return self.lv
end
function nebulaCelebrationCtrl:getCurLevelExp()
	return self.exp
end
function nebulaCelebrationCtrl:getCurLevelExpMax()
	return self.expMax
end
function nebulaCelebrationCtrl:getRewardLevel()
	return self.data.maxRewardLv
end
function nebulaCelebrationCtrl:getRewardLevelGold()
	return self.data.maxSeniorRewardLv
end
function nebulaCelebrationCtrl:hasAward(level)
	local curLv = self:getCurLevel()
	local rewardLv = self:getRewardLevel()
	local classType = self:getClassType()
	local cfg
	if curLv > rewardLv then
		for i = rewardLv + 1, curLv do
			cfg = nebulaCelebrationRead.getLevelReward(i, classType)
			if #cfg.normalReward > 0 then
				return true
			end
		end
	end
	if self:isActiveGold() then
		local reardLvGold = self:getRewardLevelGold()
		for i = reardLvGold + 1, curLv do
			cfg = nebulaCelebrationRead.getLevelReward(i, classType)
			if 0 < #cfg.seniorReward then
				return true
			end
		end
	end
end
function nebulaCelebrationCtrl:getReceiveStatusAndNum()
	if not self:isActivityOpen() then
		return false
	end
	if self:hasAward() then
		return true, -1
	end
	if self:taskReddot() then
		return true, -1
	end
end
function nebulaCelebrationCtrl:getRewardList()
	return nebulaCelebrationRead.getRewardList(self:getClassType())
end
function nebulaCelebrationCtrl:getMaxLevel()
	return #self:getRewardList()
end
function nebulaCelebrationCtrl:sendReqInit()
	print("nebulaCelebrationCtrl:sendReqInit")
	_ENV = nil
	serverproxy:Request(gCmd.CMD_NEBULA_CELEBRATION_MODULE, gCmd.REQ_NEBULA_CELEBRATION_INIT, nil)
end
function nebulaCelebrationCtrl:sendReqClaimReward(questId)
	print("nebulaCelebrationCtrl:sendReqClaimReward", questId)
	_ENV = nil
	;(nil).questId = questId
	serverproxy:Request(gCmd.CMD_NEBULA_CELEBRATION_MODULE, gCmd.REQ_NEBULA_CELEBRATION_CLAIM_REWARD, nil)
end
function nebulaCelebrationCtrl:sendReqBuyStarLight(buyNum)
	print("nebulaCelebrationCtrl:sendReqBuyStarLight", buyNum)
	_ENV = nil
	;(nil).buyNum = buyNum
	serverproxy:Request(gCmd.CMD_NEBULA_CELEBRATION_MODULE, gCmd.REQ_NEBULA_CELEBRATION_BUY_STARLIGHT, nil)
end
function nebulaCelebrationCtrl:sendReqRecieveReward()
	print("nebulaCelebrationCtrl:sendReqRecieveReward")
	_ENV = nil
	serverproxy:Request(gCmd.CMD_NEBULA_CELEBRATION_MODULE, gCmd.REQ_NEBULA_CELEBRATION_RECIEVE_REWARD, nil)
end
function nebulaCelebrationCtrl:sendReqBuyGift()
	print("nebulaCelebrationCtrl:sendReqBuyGift")
	_ENV = nil
	serverproxy:Request(gCmd.CMD_NEBULA_CELEBRATION_MODULE, gCmd.REQ_NEBULA_CELEBRATION_BUY_GIFT, nil)
end
function nebulaCelebrationCtrl:reqInitRsp(content)
	dump(content, "nebulaCelebrationCtrl:reqInitRsp", 10)
	if content.err ~= gErrDef.Err_None then
		self:showError("nebulaCelebrationCtrl:reqInitRsp", content.err)
		return
	end
	self:setData(content.rspdata)
	_ENV = self
	self.msg = "MESSAGE_NEBULA_CELEBRATION_INIT"
	SoraDSendMessage(self)
end
function nebulaCelebrationCtrl:reqClaimRewardRsp(content)
	dump(content, "nebulaCelebrationCtrl:reqClaimRewardRsp", 10)
	if content.err ~= gErrDef.Err_None then
		self:showError("nebulaCelebrationCtrl:reqClaimRewardRsp", content.err)
		return
	end
	self:setData(content.rspdata.data)
	SoraDMailGainItems(content.rspdata.reward, true)
	_ENV = content.rspdata.reward
	content.rspdata.reward.msg = "MESSAGE_NEBULA_CELEBRATION_CLAIM_REWARD"
	content.rspdata.reward.reward = content.rspdata.reward
	SoraDSendMessage(content.rspdata.reward)
end
function nebulaCelebrationCtrl:reqBuyStarLightRsp(content)
	dump(content, "nebulaCelebrationCtrl:reqBuyStarLightRsp", 10)
	if content.err ~= gErrDef.Err_None then
		self:showError("nebulaCelebrationCtrl:reqBuyStarLightRsp", content.err)
		return
	end
	self:setData(content.rspdata)
	_ENV = self
	self.msg = "MESSAGE_NEBULA_CELEBRATION_BUY_STARLIGHT"
	self.buyNum = content.data.buyNum
	SoraDSendMessage(self)
end
function nebulaCelebrationCtrl:reqRecieveRewardRsp(content)
	dump(content, "nebulaCelebrationCtrl:reqRecieveRewardRsp", 10)
	if content.err ~= gErrDef.Err_None then
		self:showError("nebulaCelebrationCtrl:reqRecieveRewardRsp", content.err)
		return
	end
	self:setData(content.rspdata.data)
	SoraDMailGainItems(content.rspdata.reward, true)
	_ENV = content.rspdata.reward
	content.rspdata.reward.msg = "MESSAGE_NEBULA_CELEBRATION_CLAIM_ALL_REWARD"
	content.rspdata.reward.reward = content.rspdata.reward
	SoraDSendMessage(content.rspdata.reward)
end
function nebulaCelebrationCtrl:reqBuyGiftRsp(content)
	dump(content, "nebulaCelebrationCtrl:reqBuyGiftRsp", 10)
	if content.err ~= gErrDef.Err_None then
		self:showError("nebulaCelebrationCtrl:reqBuyGiftRsp", content.err)
		return
	end
	local rechargeId = nebulaCelebrationRead.getRecharge().RechargeID
	paymentManager.purchase(rechargeId, content.rspdata.orderID)
end
function nebulaCelebrationCtrl:showError(strMsg, err)
	if device.platform == "mac" then
		_ENV = nil
		;(nil).content = strMsg .. err
		uiManager:show("MessageBox", nil)
	else
		print(strMsg, err)
	end
end
return nebulaCelebrationCtrl

local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local newStartMainCtrl = class("newStartMainCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function newStartMainCtrl:ctor(properties)
	newStartMainCtrl.super.ctor(self, properties)
	self:resetData()
end
function newStartMainCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_NEW_START_MAIN_MODULE, gCmd.REQ_NEW_START_MAIN_INIT_NEW, handler(self, self.reqInitNewRsp))
	msgCtrl.register(gCmd.CMD_NEW_START_MAIN_MODULE, gCmd.REQ_NEW_START_MAIN_INPUT_CORRELTION, handler(self, self.reqCorreltionRsp))
	msgCtrl.register(gCmd.CMD_NEW_START_MAIN_MODULE, gCmd.REQ_NEW_START_MAIN_INIT_OLD, handler(self, self.reqInitOldRsp))
	msgCtrl.register(gCmd.CMD_NEW_START_MAIN_MODULE, gCmd.REQ_NEW_START_MAIN_INIT_CODE, handler(self, self.reqInitCodeRsp))
	msgCtrl.register(gCmd.CMD_NEW_START_MAIN_MODULE, gCmd.REQ_NEW_START_MAIN_CHECK_CORRELTION, handler(self, self.reqCheckCorreltionRsp))
	msgCtrl.register(gCmd.CMD_NEW_START_MAIN_MODULE, gCmd.REQ_NEW_START_MAIN_GET_ASK_REWARD, handler(self, self.reqGetAskRewardRsp))
	msgCtrl.register(gCmd.CMD_NEW_START_REWARD_MODULE, gCmd.REQ_NEW_START_REWARD_REWARD, handler(self, self.reqNewStartRewardRsp))
	self:reqInitNew()
end
function newStartMainCtrl:Logout()
	newStartMainCtrl.super.Logout(self)
	self:resetData()
end
function newStartMainCtrl:resetData()
	self.actInit, _UPVALUE0_, self.activityData, _UPVALUE0_ = nil, nil, nil, nil
end
function newStartMainCtrl:reqInitNew()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_NEW_START_MAIN_MODULE, gCmd.REQ_NEW_START_MAIN_INIT_NEW, nil)
end
function newStartMainCtrl:reqCorreltion(code)
	serverproxy = nil
	;(nil).code = code
	serverproxy:Request(gCmd.CMD_NEW_START_MAIN_MODULE, gCmd.REQ_NEW_START_MAIN_INPUT_CORRELTION, nil)
end
function newStartMainCtrl:reqInitOld()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_NEW_START_MAIN_MODULE, gCmd.REQ_NEW_START_MAIN_INIT_OLD, nil)
end
function newStartMainCtrl:reqInitCode()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_NEW_START_MAIN_MODULE, gCmd.REQ_NEW_START_MAIN_INIT_CODE, nil)
end
function newStartMainCtrl:reqCheckCorreltion(code)
	serverproxy = nil
	;(nil).code = code
	serverproxy:Request(gCmd.CMD_NEW_START_MAIN_MODULE, gCmd.REQ_NEW_START_MAIN_CHECK_CORRELTION, nil)
end
function newStartMainCtrl:reqGetAskReward(gold)
	serverproxy, serverproxy = nil, nil
	;(nil).gold = gold
	serverproxy:Request(gCmd.CMD_NEW_START_MAIN_MODULE, gCmd.REQ_NEW_START_MAIN_GET_ASK_REWARD, nil, nil)
end
function newStartMainCtrl:reqNewStartReward()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_NEW_START_REWARD_MODULE, gCmd.REQ_NEW_START_REWARD_REWARD, nil)
end
function newStartMainCtrl:reqInitNewRsp(content)
	dump(content, "newStartMainCtrl:reqInitNewRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.activityData = content.rspData
		if self:checkCanCorreltion() then
			local cityBuildFunction = include("cityBuildFunction")
			_ENV = "cityBuildFunction"
			local ("cityBuildFunction").pType, param = uiDequeTypeTab.NEWSERVER_CORRELATION, "cityBuildFunction"
			cityBuildFunction:checkNewServerCorrelation(param)
		end
		_ENV = "cityBuildFunction"
		;("cityBuildFunction").msg = "MESSAGE_NEW_START_INITNEW"
		SoraDSendMessage("cityBuildFunction")
	end
end
function newStartMainCtrl:checkCanCorreltion()
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NEW_START_NEWMAIN_ACTIVITY) and self:getInheritData().userState ~= 2 then
		_ENV = nil
		;(nil).byLTID = true
		local code = SoraDConfigGet("Game:GameSettingView:newStartCode~string", nil)
		print("code", code)
		if code and code ~= "" then
			return true, code
		end
	end
	return false
end
function newStartMainCtrl:clearCorreltionCode()
	_ENV = nil
	;(nil).byLTID = true
	SoraDConfigSet("Game:GameSettingView:newStartCode~string", "", nil)
end
function newStartMainCtrl:reqCorreltionRsp(content)
	dump(content, "newStartMainCtrl:reqCorreltionRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.activityData = content.rspData
		SoraDShowMsgTip(i18n("newstart_text_30"))
		_ENV = i18n("newstart_text_30")
		i18n("newstart_text_30").msg = "MESSAGE_NEW_START_CORRELTION_REFRESH"
		SoraDSendMessage(i18n("newstart_text_30"))
	else
		SoraDShowMsgTip(i18n("newstart_text_31"))
	end
	self:clearCorreltionCode()
end
function newStartMainCtrl:reqInitOldRsp(content)
	dump(content, "newStartMainCtrl:reqInitOldRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_NEW_START_INITOLD_REFRESH"
		gErrDef.Err_None.rspData = content.rspData
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function newStartMainCtrl:reqInitCodeRsp(content)
	dump(content, "newStartMainCtrl:reqInitCodeRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_NEW_START_CODE_REFRESH"
		gErrDef.Err_None.correlationCode = content.rspData.correlationCode
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function newStartMainCtrl:reqCheckCorreltionRsp(content)
	dump(content, "newStartMainCtrl:reqCheckCorreltionRsp(content)", 10)
	SoraDCloseLoading()
	if content.err == gErrDef.Err_None then
	else
		SoraDShowMsgTip(i18n("newstart_text_31"))
	end
end
function newStartMainCtrl:reqGetAskRewardRsp(content)
	dump(content, "newStartMainCtrl:reqGetAskRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.activityData = content.rspData
		local gold = content.clientData and content.clientData.gold
		if gold then
			_ENV, _UPVALUE1_ = "newStartMainCtrl:reqGetAskRewardRsp(content)", gErrDef.Err_None
			;("newStartMainCtrl:reqGetAskRewardRsp(content)").id = gIDDef.GOLD
			;("newStartMainCtrl:reqGetAskRewardRsp(content)").count = gold
			local gErrDef.Err_None[1], itemData = "newStartMainCtrl:reqGetAskRewardRsp(content)", gErrDef.Err_None
			SoraDMailGainItems(itemData, true)
		end
	end
end
function newStartMainCtrl:reqNewStartRewardRsp(content)
	dump(content, "newStartMainCtrl:reqNewStartRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		SoraDCloseLoading()
		local rewards = content.rspdata.rewards
		SoraDMailGainItems(rewards, true)
		local data = self:getActivityData(gActivityTimeActivityID.NEW_START_REWARD_ACTIVITY)
		data.isReward = true
		_ENV = gActivityTimeActivityID.NEW_START_REWARD_ACTIVITY
		gActivityTimeActivityID.NEW_START_REWARD_ACTIVITY.msg = "MESSAGE_NEW_START_GETREWARD_BACK"
		SoraDSendMessage(gActivityTimeActivityID.NEW_START_REWARD_ACTIVITY)
	end
end
function newStartMainCtrl:getActivityData(activityID)
	dump(self.activityData, "newStartMainCtrl:getActivityData")
	if activityID then
		if not self.activityData[tostring(activityID)] then
			_ENV = self.activityData[tostring(activityID)]
		end
		return self.activityData[tostring(activityID)]
	end
	if not self.activityData then
		_ENV = self.activityData
	end
	return self.activityData
end
function newStartMainCtrl:getInheritData(...)
	if not self:getActivityData(gActivityTimeActivityID.NEW_START_NEWMAIN_ACTIVITY) then
		_ENV = self:getActivityData(gActivityTimeActivityID.NEW_START_NEWMAIN_ACTIVITY)
	end
	return (self:getActivityData(gActivityTimeActivityID.NEW_START_NEWMAIN_ACTIVITY))
end
function newStartMainCtrl:openView(...)
	if SoraDGetCastleLv() < CASTLE_LV6_LIMITED then
		uiManager:show("NewStartInherit")
	else
		uiManager:show("NewServerReturn")
	end
end
function newStartMainCtrl:jumpToActivity(eid)
	if uiManager:isShow("NewServerReturn") then
		uiManager:getProxy("NewServerReturn"):jumpToActivity(eid)
	else
		_ENV = nil
		;(nil).eid = eid
		uiManager:show("NewServerReturn", nil)
	end
end
function newStartMainCtrl:getReceiveStatusAndNum()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local activityIDList = activityShowCtrl:getActivityGroup(gActivityCenterUIEnum.NEWSERVERBACK_ACTIVITY)
	for activityID, _ in pairs(activityIDList) do
		if clientEventMgr.judgeIsOpen(activityID) then
			local red = self:getReceiveStatusAndNumByActID(activityID)
			if red then
				return true, -1
			end
		end
	end
	return false, 0
end
function newStartMainCtrl:getRednumByActivityIDWhenLoading(activityID)
	if activityID == gActivityTimeActivityID.NEW_START_EFFECT_ACTIVITY then
		return false, 0
	elseif activityID == gActivityTimeActivityID.NEW_START_REWARD_ACTIVITY then
		local data = self:getActivityData(activityID)
		if not next(data) then
			return false
		end
		return not data.isReward, -1
	elseif activityID == gActivityTimeActivityID.WEALTH_ACTIVITY then
		local newServerReturnltCtrl = include("newServerReturnltCtrl")
		local eventQuestRead = include("eventQuestRead")
		local data = self:getActivityData(activityID)
		if not next(data) then
			return false
		end
		for i, v in pairs(data.taskFinishProcess) do
			local questInfo = eventQuestRead.getTaskConfig(tonumber(i))
			if v >= questInfo.aim and not data.taskRewardRecord[i] then
				return true, -1
			end
		end
		return false, 0
	elseif activityID == gActivityTimeActivityID.ROAD_TO_REVIVE_ACTIVITY then
		local data = self:getActivityData(activityID)
		if not next(data) then
			return false
		end
		if data.quest and data.quest.finishedQuest and next(data.quest.finishedQuest) then
			for i, v in pairs(data.quest.finishedQuest) do
				if not data.quest.claimedQuest[i] then
					return true, -1
				end
			end
			return false, 0
		end
	elseif activityID == gActivityTimeActivityID.VICIOUS_PET_ACTIVITY then
		local data = self:getActivityData(activityID)
		if not next(data) then
			return false
		end
		local backpackCtrl = SoraDGetCtrl("backpackCtrl")
		local itemFeedCount = backpackCtrl:getItemCount(848001)
		local itemWalkCount = backpackCtrl:getItemCount(849001)
		if 1 <= itemFeedCount then
			return true
		end
		local patrolEndtime = data.patrolEndtime
		if 0 < patrolEndtime then
			return false
		elseif patrolEndtime == 0 then
			return true
		elseif 1 <= itemWalkCount then
			return true
		end
		return false
	elseif activityID == gActivityTimeActivityID.SUDAN_RISING_ACTIVITY then
		local data = self:getActivityData(activityID)
		if not next(data) then
			return false
		end
		if data.quest and data.quest.finishedQuest and next(data.quest.finishedQuest) then
			for i, v in pairs(data.quest.finishedQuest) do
				if not data.quest.claimedQuest[i] then
					return true, -1
				end
			end
			return false, 0
		end
	else
		return false, 0
	end
end
function newStartMainCtrl:getRednumByActivityID(activityID)
	if activityID == gActivityTimeActivityID.NEW_START_EFFECT_ACTIVITY then
		return false, 0
	elseif activityID == gActivityTimeActivityID.NEW_START_REWARD_ACTIVITY then
		local data = self:getActivityData(activityID)
		if not next(data) then
			return false
		end
		return not data.isReward, -1
	elseif activityID == gActivityTimeActivityID.WEALTH_ACTIVITY then
		local actCtrl = SoraDGetCtrl("inheritGiftCtrl")
		return actCtrl:getReceiveStatusAndNum()
	elseif activityID == gActivityTimeActivityID.ROAD_TO_REVIVE_ACTIVITY then
		local actCtrl = SoraDGetCtrl("revivalRoadCtrl")
		return actCtrl:getReceiveStatusAndNum()
	elseif activityID == gActivityTimeActivityID.VICIOUS_PET_ACTIVITY then
		local actCtrl = SoraDGetCtrl("newServerPetCtrl")
		return actCtrl:getReceiveStatusAndNum()
	elseif activityID == gActivityTimeActivityID.SUDAN_RISING_ACTIVITY then
		local actCtrl = SoraDGetCtrl("riseOfSultanCtrl")
		return actCtrl:getReceiveStatusAndNum()
	elseif activityID == gActivityTimeActivityID.BACK_TO_TOP_ACTIVITY then
		local actCtrl = SoraDGetCtrl("backToTopCtrl")
		return actCtrl:getReceiveStatusAndNum()
	else
		return false, 0
	end
end
function newStartMainCtrl:setActInitFlag(activityID)
	self.actInit[tostring(activityID)] = true
end
function newStartMainCtrl:getReceiveStatusAndNumByActID(activityID)
	local red = false
	if self.actInit[tostring(activityID)] then
		red = self:getRednumByActivityID(activityID)
	else
		red = self:getRednumByActivityIDWhenLoading(activityID)
	end
	if red then
		return true, -1
	end
	return false, 0
end
function newStartMainCtrl:checkIsInherit(...)
	local data = self:getInheritData()
	return data.userState == 2
end
function newStartMainCtrl:checkPopAskRewardView(...)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NEW_START_NEWMAIN_ACTIVITY) then
		return false
	end
	local data = self:getInheritData()
	return not data.askReward
end
return newStartMainCtrl

local GameModule = include("GameModule")
local newPlayerTaskCtrl = class("newPlayerTaskCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function newPlayerTaskCtrl:ctor(properties)
	newPlayerTaskCtrl.super.ctor(self, properties)
end
function newPlayerTaskCtrl:EnterGame()
	gametop = nil
	;(nil).name = gEventName.event_req_player_data
	gametop.playertop_:dispatchEvent(nil)
	msgCtrl.register(gCmd.CMD_NEW_PLAYRE_TASK_MODULE, gCmd.REQ_NEW_PLAYRE_TASK_INIT, handler(self, self.getInitResp))
	msgCtrl.register(gCmd.CMD_NEW_PLAYRE_TASK_MODULE, gCmd.REQ_NEW_PLAYRE_TASK_RECEIVE_TASK_REWARD, handler(self, self.getTaskRewardResp))
	msgCtrl.register(gCmd.CMD_NEW_PLAYRE_TASK_MODULE, gCmd.REQ_NEW_PLAYRE_TASK_RECEIVE_CHAPTER_REWARD, handler(self, self.getChapterRewardResp))
	msgCtrl.register(gCmd.CMD_NEW_PLAYRE_TASK_MODULE, gCmd.REQ_NEW_PLAYRE_TASK_ACTIVITY_CENTER, function(...)
	end)
	self:resetData()
end
function newPlayerTaskCtrl:resetData()
	self.handle_notify = nil
	self.curChapterID = nil
	self.taskInfo = nil
end
function newPlayerTaskCtrl:Logout()
	self:resetData()
	newPlayerTaskCtrl.super.Logout(self)
end
function newPlayerTaskCtrl:initClientData(data)
	if not data then
		return
	end
	self.curChapterID = data.curChapterID
	self.taskInfo = data.taskInfo
	self:registerNotify()
	if self.curChapterID and (self.curChapterID == 0 or self.curChapterID > 4103100) then
		local guideCtrl = SoraDGetCtrl("guideCtrl")
		guideCtrl:CompleteGuideStep(nil, gGuideStep.HERO_UNLOCK_STEP_1)
	end
	if self.curChapterID and (self.curChapterID == 0 or self.curChapterID > 4103000) then
		local guideCtrl = SoraDGetCtrl("guideCtrl")
		guideCtrl:CompleteGuideStep(nil, gGuideStep.CHAPTER_REWARD_STEP_1)
	end
end
function newPlayerTaskCtrl:dump()
	local newPlayerTaskRead = include("newPlayerTaskRead")
	local allChapterID = newPlayerTaskRead.getAllChapterID()
	for key, chapterID in pairs(allChapterID) do
		local castleLevel = newPlayerTaskRead.getCastleLevelByChapterID(chapterID)
		print("newPlayerTaskCtrl chapterID=", chapterID, "castleLevel=", castleLevel)
		local allTaskID = newPlayerTaskRead.getTaskIDByChapterID(chapterID)
		local reward = newPlayerTaskRead.getRewardByChapterID(chapterID)
		for _, taskID in pairs(allTaskID) do
			local reward2 = newPlayerTaskRead:getRewardByTaskID(taskID)
		end
	end
end
function newPlayerTaskCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.NEW_PLAYRE_TASK, handler(self, self.notifyHandler))
end
function newPlayerTaskCtrl:notifyHandler(event)
	dump(event, "newPlayerTaskCtrl:notifyHandler event")
	for index, content in pairs(event.data) do
		if content then
			if content.curChapterID then
				self.curChapterID = content.curChapterID
			end
			if content.taskInfo then
				self.taskInfo = content.taskInfo
			end
			local isNew = false
			if content.newChapter then
				isNew = true
			end
			_ENV = nil
			;(nil).msg = "MESSAGE_NEW_PLAYER_QUEST_UPDATE"
			;(nil).isNew = isNew
			SoraDSendMessage(nil)
		end
	end
end
function newPlayerTaskCtrl:sendInitMsg()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_NEW_PLAYRE_TASK_MODULE, gCmd.REQ_NEW_PLAYRE_TASK_INIT, data)
end
function newPlayerTaskCtrl:sendReceiveTaskReward(taskID)
	local serverproxy, data
	data.taskID = taskID
	serverproxy:Request(gCmd.CMD_NEW_PLAYRE_TASK_MODULE, gCmd.REQ_NEW_PLAYRE_TASK_RECEIVE_TASK_REWARD, data)
end
function newPlayerTaskCtrl:sendReceiveChapterReward()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_NEW_PLAYRE_TASK_MODULE, gCmd.REQ_NEW_PLAYRE_TASK_RECEIVE_CHAPTER_REWARD, data)
end
function newPlayerTaskCtrl:sendToActivityCenter(...)
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_NEW_PLAYRE_TASK_MODULE, gCmd.REQ_NEW_PLAYRE_TASK_ACTIVITY_CENTER, data)
end
function newPlayerTaskCtrl:getInitResp(ret)
	if not (ret and ret.data) or ret.err == gErrDef.Err_None then
	end
end
function newPlayerTaskCtrl:getTaskRewardResp(ret)
	if ret and ret.data then
		local data = ret.data
		if ret.err == gErrDef.Err_None then
			if data.taskInfo then
				self.taskInfo = data.taskInfo
			end
			local reward = ret.data.reward
			local expReward
			for k, v in pairs(reward) do
				if v.id and v.id == gIDType.EXP and v.count and v.count > 0 then
					expReward = v.count
					break
				end
			end
			if expReward then
				_ENV = pairs(reward)
				pairs(reward).msg = "MESSAGE_MAINSCEN_EXP_UPDATE"
				pairs(reward).addEXP = expReward
				SoraDSendMessage(pairs(reward))
			end
		elseif ret.err == gErrDef.Err_NEW_PLAYER_CHAPTER_NOT_OPEN then
		elseif ret.err == gErrDef.Err_NEW_PLAYER_TASK_NOT_FINISH then
		elseif ret.err == gErrDef.Err_NEW_PLAYER_TASK_ALREADY_RECEIVE then
		end
	end
	_ENV = ret.err
	ret.err.msg = "MESSAGE_NEW_PLAYER_QUEST_GET"
	SoraDSendMessage(ret.err)
end
function newPlayerTaskCtrl:getChapterRewardResp(ret)
	dump(ret, "newPlayerTaskCtrl:getChapterRewardResp", 10)
	if ret and ret.data then
		local data = ret.data
		if ret.err == gErrDef.Err_None then
			local newPlayerTaskRead = include("newPlayerTaskRead")
			local reward = data.reward
			if data.taskInfo then
				self.taskInfo = data.taskInfo
			end
			if data.curChapterID then
				self.curChapterID = data.curChapterID
			end
			local expReward
			for i, v in ipairs(ret.data.reward) do
				if v.id and v.id == gIDType.EXP and v.count and v.count > 0 then
					expReward = v.count
					break
				end
			end
			if expReward then
				_ENV = ipairs(ret.data.reward)
				ipairs(ret.data.reward).msg = "MESSAGE_MAINSCEN_EXP_UPDATE"
				ipairs(ret.data.reward).addEXP = expReward
				SoraDSendMessage(ipairs(ret.data.reward))
			end
			local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
			if lordInfoCtrl:getUserAgreementPop() then
				SoraDAddPopupWindow(function()
					SoraDAgreementBox(true)
				end, uiDequeTypeTab.AGREEMENT)
			else
				local panel = SoraDCreatePanel("newPlayerQuestPrizeView")
				panel:initData(reward)
				panel:show()
			end
		elseif ret.err == gErrDef.Err_NEW_PLAYER_CHAPTER_NOT_OPEN then
		elseif ret.err == gErrDef.Err_NEW_PLAYER_TASK_NOT_FINISH then
		end
	end
	_ENV = ret.err
	ret.err.msg = "MESSAGE_NEW_PLAYER_QUEST_CHAPTER"
	SoraDSendMessage(ret.err)
end
function newPlayerTaskCtrl:getCurChapterID()
	return self.curChapterID
end
function newPlayerTaskCtrl:getTaskInfo()
	return self.taskInfo
end
function newPlayerTaskCtrl:isTaskFinish(taskID)
	local ret = false
	if self.taskInfo and self.taskInfo[tostring(taskID)] then
		ret = self.taskInfo[tostring(taskID)].finishStatus or false
	end
	return ret
end
function newPlayerTaskCtrl:isTaskRewardCanReceive(taskID)
	local ret = false
	if self.taskInfo and self.taskInfo[tostring(taskID)] then
		ret = self.taskInfo[tostring(taskID)].receiveStatus or false
	end
	return ret
end
function newPlayerTaskCtrl:isChapterRewardCanReceive()
	if not self.curChapterID and self.curChapterID <= 0 then
		return false
	end
	if self.taskInfo then
		for _, value in pairs(self.taskInfo) do
			if value.finishStatus == false then
				return false
			end
		end
	end
	return true
end
function newPlayerTaskCtrl:updateGuideChapterReward(...)
	local guideCtrl = SoraDGetCtrl("guideCtrl")
	if not guideCtrl:isGuideNotCompleted(gGuideModule.CHAPTER_REWARD) then
		return
	end
	if self.curChapterID and self.curChapterID == 4103000 and self:isChapterRewardCanReceive() then
		guideCtrl:updateGuideModule(gGuideModule.CHAPTER_REWARD)
	end
end
return newPlayerTaskCtrl

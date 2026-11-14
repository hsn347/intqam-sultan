local GameModule = include("GameModule")
local lightShiningCtrl = class("lightShiningCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function lightShiningCtrl:ctor(properties)
	lightShiningCtrl.super.ctor(self, properties)
	_UPVALUE5_, self.activityID = gActivityTimeActivityID.GLORIOUS_SHINE_ACTIVITY, gActivityTimeActivityID.GLORIOUS_SHINE_ACTIVITY
	_UPVALUE5_, self.buffArray, gActivityTimeActivityID.GLORIOUS_SHINE_ACTIVITY[1] = gActivityTimeActivityID.GLORIOUS_SHINE_ACTIVITY, gActivityTimeActivityID.GLORIOUS_SHINE_ACTIVITY, 5447
	_UPVALUE5_, self.buffArray, gActivityTimeActivityID.GLORIOUS_SHINE_ACTIVITY[2] = gActivityTimeActivityID.GLORIOUS_SHINE_ACTIVITY, gActivityTimeActivityID.GLORIOUS_SHINE_ACTIVITY, 5448
	_UPVALUE5_, self.buffArray, gActivityTimeActivityID.GLORIOUS_SHINE_ACTIVITY[3] = gActivityTimeActivityID.GLORIOUS_SHINE_ACTIVITY, gActivityTimeActivityID.GLORIOUS_SHINE_ACTIVITY, 5449
	_UPVALUE5_, self.buffArray, gActivityTimeActivityID.GLORIOUS_SHINE_ACTIVITY[4] = gActivityTimeActivityID.GLORIOUS_SHINE_ACTIVITY, gActivityTimeActivityID.GLORIOUS_SHINE_ACTIVITY, 5450
	_UPVALUE5_, self.buffArray, gActivityTimeActivityID.GLORIOUS_SHINE_ACTIVITY[5] = gActivityTimeActivityID.GLORIOUS_SHINE_ACTIVITY, gActivityTimeActivityID.GLORIOUS_SHINE_ACTIVITY, 5454
	self.buffType, gActivityTimeActivityID.GLORIOUS_SHINE_ACTIVITY[1] = gActivityTimeActivityID.GLORIOUS_SHINE_ACTIVITY, 476
	self.buffType, gActivityTimeActivityID.GLORIOUS_SHINE_ACTIVITY[2] = gActivityTimeActivityID.GLORIOUS_SHINE_ACTIVITY, 432
	self.buffType, gActivityTimeActivityID.GLORIOUS_SHINE_ACTIVITY[3] = gActivityTimeActivityID.GLORIOUS_SHINE_ACTIVITY, 477
	self.buffType, gActivityTimeActivityID.GLORIOUS_SHINE_ACTIVITY[4] = gActivityTimeActivityID.GLORIOUS_SHINE_ACTIVITY, 478
	self.buffType, gActivityTimeActivityID.GLORIOUS_SHINE_ACTIVITY[5] = gActivityTimeActivityID.GLORIOUS_SHINE_ACTIVITY, 479
end
function lightShiningCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_GLORIOUS_SHINE_OPEN_BUFF, handler(self, self.reqOpenBuffRsp))
	self:resetData()
	self:registerNotify()
end
function lightShiningCtrl:resetData()
	self.questData, _UPVALUE0_ = nil, nil
	self.starPoint = 0
	self.buffList, _UPVALUE0_, self.isLight = nil, nil, 0
	self.buffTime = nil
end
function lightShiningCtrl:initClientData(data)
	if data and data[tostring(self.activityID)] then
		self:setActivityData(data[tostring(self.activityID)])
	end
end
function lightShiningCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.USER_ACTIVITY, handler(self, self.notifyHandler))
end
function lightShiningCtrl:notifyHandler(content)
	local notifydata = content.data
	for _, notifyMsg in ipairs(notifydata) do
		local activityID = notifyMsg.activityID
		if tonumber(activityID) ~= self.activityID then
			return
		end
		self:setActivityData(notifyMsg.notifyData)
		_ENV = self
		self.msg = "MESSAGE_ACTIVITY_MODULE_UPDATE_VIEW"
		self.eventID = self.activityID
		SoraDSendMessage(self)
	end
	_ENV = ipairs(notifydata)
	ipairs(notifydata).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	ipairs(notifydata).eventID = self.activityID
	SoraDSendMessage(ipairs(notifydata))
end
function lightShiningCtrl:setActivityData(activityData)
	dump(activityData, "lightShiningCtrl==activityData=========", 10)
	if not activityData then
		return
	end
	if activityData.questID then
		if not self.questData then
			self.questData, _ENV = self.questData, self.questData
		end
		if not self.questData.claimedQuest then
			self.questData.claimedQuest, _ENV = activityData, activityData
		end
		if activityData.reward then
			self.questData.claimedQuest[tostring(activityData.questID)] = 1
		end
		if activityData.progress then
			if not self.questData.questProgress then
				self.questData.questProgress, _ENV = tostring(activityData.questID), tostring(activityData.questID)
			end
			self.questData.questProgress[tostring(activityData.questID)] = activityData.progress
		end
		if activityData.isFinish then
			if not self.questData.finishedQuest then
				self.questData.finishedQuest, _ENV = tostring(activityData.questID), tostring(activityData.questID)
			end
			self.questData.finishedQuest[tostring(activityData.questID)] = 1
		end
	end
	local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
	if not activityTaskComponentCtrl:getQuestData(self.activityID) then
		local _ENV, serverData = activityTaskComponentCtrl:getQuestData(self.activityID), activityTaskComponentCtrl:getQuestData(self.activityID)
	end
	self.questData = serverData
	if activityData.questData then
		self.questData = activityData.questData
	end
	if activityData.starPoint then
		self.starPoint = activityData.starPoint
		if self.starPoint == 0 then
			_ENV = nil
			;(nil).byUID = true
			SoraDConfigSet("Game:eventLightShining:isShowed~bool", false, nil)
		end
	end
	if activityData.isLight then
		self.isLight = activityData.isLight
	end
	if activityData.buffList and next(activityData.buffList) then
		self.buffList = activityData.buffList
	end
	if activityData.buffTime then
		self.buffTime = activityData.buffTime
	end
end
function lightShiningCtrl:sendReqOpenBuff()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_GLORIOUS_SHINE_OPEN_BUFF, nil)
end
function lightShiningCtrl:reqOpenBuffRsp(content)
	dump(content, "==lightShiningCtrl:reqOpenBuffRsp==", 20)
	if content.err == gErrDef.Err_None then
		self.buffTime = content.rspdata.buffTime
		self.isLight = 1
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_MODULE_UPDATE_VIEW"
	gErrDef.Err_None.eventID = self.activityID
	SoraDSendMessage(gErrDef.Err_None)
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	gErrDef.Err_None.eventID = self.activityID
	SoraDSendMessage(gErrDef.Err_None)
end
function lightShiningCtrl:reqGetBuffRsp(content)
	dump(content, "==lightShiningCtrl:reqGetBuffRsp==", 20)
	if content.err == gErrDef.Err_None then
		self.buffTime = content.rspdata.buffTime
		if content.rspdata.buffList and next(content.rspdata.buffList) then
			self.buffList = content.rspdata.buffList
		end
	end
	_ENV = content.rspdata.buffList
	content.rspdata.buffList.msg = "MESSAGE_ACTIVITY_MODULE_UPDATE_VIEW"
	content.rspdata.buffList.eventID = self.activityID
	SoraDSendMessage(content.rspdata.buffList)
end
function lightShiningCtrl:getReceiveStatusAndNum()
	local retNum = 0
	if self.questData and self.questData.finishedQuest and self.questData.claimedQuest then
		for k, v in pairs(self.questData.finishedQuest) do
			if not self.questData.claimedQuest[tostring(k)] then
				retNum = retNum + 1
			end
		end
	end
	if self:getStarPoint() >= 4 and not self:isLightToday() then
		return true, 0 < retNum and retNum or -1
	end
	return 0 < retNum, retNum
end
function lightShiningCtrl:isLightToday()
	return self.isLight == 1
end
function lightShiningCtrl:getStarPoint()
	return self.starPoint
end
function lightShiningCtrl:getBuffID(buffType)
	for k, v in ipairs(self.buffType) do
		if v == buffType then
			return self.buffArray[k]
		end
	end
end
function lightShiningCtrl:isBuffActive()
	local ret = false
	local buffCtrl = SoraDGetCtrl("buffCtrl")
	for k, v in ipairs(self.buffArray) do
		local remainTime = buffCtrl:getRemainTimeByBuffID(v)
		if remainTime and 0 < remainTime then
			ret = true
			break
		end
	end
	return ret
end
function lightShiningCtrl:getBuffList()
	local buffCtrl = SoraDGetCtrl("buffCtrl")
	for k, v in ipairs(self.buffArray) do
		local remainTime = buffCtrl:getRemainTimeByBuffID(v)
		if remainTime and 0 < remainTime and not SoraDisInList(v, self.buffList) then
			table.insert(self.buffList, v)
		end
	end
	return self.buffList
end
function lightShiningCtrl:isInBuffList(buffList)
	local ret = false
	for k, v in ipairs(buffList) do
		if SoraDisInList(v, self.buffList) then
			ret = true
			break
		end
	end
	return ret
end
function lightShiningCtrl:isXYBuffActive()
	local ret = false
	local isActive = self:isBuffActive()
	if isActive and SoraDisInList(5449, self.buffList) then
		ret = true
	end
	return ret
end
return lightShiningCtrl

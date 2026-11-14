local GameModule = include("GameModule")
local greatChallengeCtrl = class("greatChallengeCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function greatChallengeCtrl:ctor(properties)
	greatChallengeCtrl.super.ctor(self, properties)
end
function greatChallengeCtrl:EnterGame()
	gametop = nil
	;(nil).name = gEventName.event_req_player_data
	gametop.playertop_:dispatchEvent(nil)
	msgCtrl.register(gCmd.CMD_GREAT_CHALLENGE_ACTIVITY_MODULE, gCmd.REQ_GREAT_CHALLENGE_ACTIVITY_INIT, handler(self, self.getInitResp))
	msgCtrl.register(gCmd.CMD_GREAT_CHALLENGE_ACTIVITY_MODULE, gCmd.REQ_GREAT_CHALLENGE_ACTIVITY_RECEIVE, handler(self, self.getReceiveResp))
	self:resetData()
end
function greatChallengeCtrl:resetData()
	self.handle_notify = nil
	self.challengeData = nil
end
function greatChallengeCtrl:Logout()
	self:resetData()
	greatChallengeCtrl.super.Logout(self)
end
function greatChallengeCtrl:initClientData(data)
	if not data then
		return
	end
	self.challengeData = data.challengeData
	self:registerNotify()
end
function greatChallengeCtrl:dump()
end
function greatChallengeCtrl:addChallengeData(data)
	if data and next(data) then
		if not self.challengeData then
			_ENV = self.challengeData
		end
		self.challengeData = self.challengeData
		for activityID, value in pairs(data) do
			self.challengeData[tostring(activityID)] = value
		end
	end
end
function greatChallengeCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.GREAT_CHALLENGE, handler(self, self.notifyHandler))
end
function greatChallengeCtrl:notifyHandler(event)
	for _, content in pairs(event.data) do
		if content then
			self:addChallengeData(content)
			_ENV = self
			self.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
			self.eventID = gActivityCenterUIEnum.GREAT_CHALLENGE
			SoraDSendMessage(self)
		end
	end
end
function greatChallengeCtrl:sendInitMsg()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_GREAT_CHALLENGE_ACTIVITY_MODULE, gCmd.REQ_GREAT_CHALLENGE_ACTIVITY_INIT, data)
end
function greatChallengeCtrl:sendReceiveReward(activityID, stage)
	local serverproxy, data
	data.activityID = activityID
	data.stage = stage
	serverproxy:Request(gCmd.CMD_GREAT_CHALLENGE_ACTIVITY_MODULE, gCmd.REQ_NEW_PLAYRE_TASK_RECEIVE_TASK_REWARD, data)
end
function greatChallengeCtrl:getInitResp(ret)
	if ret and ret.rspdata and ret.err == gErrDef.Err_None then
		self:addChallengeData(ret.rspdata.challengeData)
	end
end
function greatChallengeCtrl:getReceiveResp(ret)
	if ret and ret.rspdata then
		local data = ret.data
		if ret.err == gErrDef.Err_None then
			self:addChallengeData(ret.rspdata.challengeData)
			local reward = ret.rspdata.reward
			local _ENV, itemList = self, self
			for k, v in pairs(reward) do
				itemList[v.itemID] = v.num
			end
			SoraDMailGainItems(itemList)
			_ENV = itemList
			itemList.msg = "MESSAGE_WONDERFUL_CHALLENGE_GET_REWARD_SUCCESS"
			SoraDSendMessage(itemList)
			_ENV = itemList
			itemList.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
			itemList.eventID = data.activityID
			SoraDSendMessage(itemList)
		end
	end
end
function greatChallengeCtrl:getReceiveStatusAndNum2(activityID)
	local tempData = self:getChallengeDataByActivityID(activityID)
	if tempData and next(tempData) then
		local ret = false
		local num = 0
		for _, value in pairs(tempData) do
			if type(value) == "table" and false == value.receive and self:getCurFinishCount(activityID) >= value.amount then
				ret = true
				num = num + 1
			end
		end
		return ret, num
	end
	return false, 0
end
function greatChallengeCtrl:getReceiveStatusAndNum(activityID)
	if activityID == gActivityCenterUIEnum.GREAT_CHALLENGE then
		local ret = false
		local num = 0
		_ENV, _UPVALUE8_ = nil, nil
		_ENV, (nil).aid = gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_1, gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_1
		_ENV, gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_1.aid = gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_2, gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_2
		_ENV, gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_2.aid = gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_3, gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_3
		_ENV, gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_3.aid = gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_4, gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_4
		_ENV, gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_4.aid = gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_5, gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_5
		_ENV, gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_5.aid = gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_6, gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_6
		_ENV, gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_6.aid = gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_7, gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_7
		gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_7.aid = gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_8
		;(nil)[1] = nil
		;(nil)[2] = gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_1
		;(nil)[3] = gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_2
		;(nil)[4] = gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_3
		;(nil)[5] = gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_4
		;(nil)[6] = gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_5
		;(nil)[7] = gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_6
		local (nil)[8], activityIDTable = gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_7, nil
		for i, v in ipairs(activityIDTable) do
			local ret1, num1 = self:getReceiveStatusAndNum2(v.aid)
			num = num + num1
		end
		return 0 < num, num
	end
	return self:getReceiveStatusAndNum2(activityID)
end
function greatChallengeCtrl:getChallengeDataByActivityID(activityID)
	local _ENV, ret
	if self.challengeData and self.challengeData[tostring(activityID)] then
		for k, v in pairs(self.challengeData[tostring(activityID)]) do
			if tonumber(k) then
				table.insert(ret, v)
			end
		end
		table.sort(ret, function(a, b)
			return a.amount < b.amount
		end)
	end
	return ret
end
function greatChallengeCtrl:getCurFinishCount(activityID)
	local ret = 0
	if self.challengeData and self.challengeData[tostring(activityID)] then
		ret = self.challengeData[tostring(activityID)].curFinishCount
	end
	return ret
end
return greatChallengeCtrl

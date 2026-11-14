local sultansBackRead = include("sultansBackRead")
local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local sultansBackCtrl = class("sultansBackCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function sultansBackCtrl:ctor(properties)
	sultansBackCtrl.super.ctor(self, properties)
	self:resetData()
end
function sultansBackCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_SULTAN_BACK_MODULE, gCmd.SULTAN_BACK_LOGIN_INIT, handler(self, self.reqBackLoginInitRsp))
	msgCtrl.register(gCmd.CMD_SULTAN_BACK_MODULE, gCmd.SULTAN_BACK_LOGIN_DAY_RECEIVE, handler(self, self.reqBackLoginDayReceiveRsp))
	msgCtrl.register(gCmd.CMD_SULTAN_BACK_MODULE, gCmd.SULTAN_BACK_LOGIN_CUMU_RECEIVE, handler(self, self.reqBackLoginCumuReceiveRsp))
	msgCtrl.register(gCmd.CMD_SULTAN_BACK_RETURN_MODULE, gCmd.SULTAN_BACK_RETURN_INIT, handler(self, self.reqBackKingTaskInitRsp))
	msgCtrl.register(gCmd.CMD_SULTAN_BACK_RETURN_MODULE, gCmd.SULTAN_BACK_RETURN_REWARD, handler(self, self.reqBackKingTaskReceiveRsp))
	msgCtrl.register(gCmd.CMD_SULTAN_WAR_QUEST_MODULE, gCmd.SULTAN_WAR_QUEST_INIT, handler(self, self.reqBackWarTaskInitRsp))
	msgCtrl.register(gCmd.CMD_SULTAN_WAR_QUEST_MODULE, gCmd.SULTAN_WAR_QUEST_CLAIM_REWARD, handler(self, self.reqBackWarTaskReceiveRsp))
	msgCtrl.register(gCmd.CMD_SULTAN_WAR_QUEST_MODULE, gCmd.SULTAN_WAR_QUEST_TOTAL_REWARD, handler(self, self.reqBackWarTotalTaskReceiveRsp))
	msgCtrl.register(gCmd.CMD_SULTAN_BACK_WELCOME_MODULE, gCmd.SULTAN_BACK_WELCOME_INIT, handler(self, self.reqWelcomeInitRsp))
	msgCtrl.register(gCmd.CMD_SULTAN_BACK_WELCOME_MODULE, gCmd.SULTAN_BACK_WELCOME_REWARD, handler(self, self.reqWelcomeRewardRsp))
	msgCtrl.register(gCmd.CMD_SULTAN_BACK_LUXURYGIFT_MODULE, gCmd.SULTAN_BACK_LUXURYGIFT_INIT, handler(self, self.reqLuxuryGiftInitRsp))
	msgCtrl.register(gCmd.CMD_SULTAN_BACK_LUXURYGIFT_MODULE, gCmd.SULTAN_BACK_LUXURYGIFT_REWARD, handler(self, self.reqLuxuryGiftRewardRsp))
	msgCtrl.register(gCmd.CMD_SULTAN_BACK_MODULE, gCmd.SULTAN_BACK_REBATE_INIT, handler(self, self.rebateInitRSP))
	msgCtrl.register(gCmd.CMD_SULTAN_BACK_MODULE, gCmd.SULTAN_BACK_REBATE_RECEIVE, handler(self, self.rebateReceiveRSP))
	msgCtrl.register(gCmd.CMD_SULTAN_BACK_FRIENDS_MODULE, gCmd.REQ_SULTAN_BACK_FRIENDS_INIT, handler(self, self.reqCallFriendsInitRsp))
	msgCtrl.register(gCmd.CMD_SULTAN_BACK_FRIENDS_MODULE, gCmd.REQ_SULTAN_BACK_FRIENDS_REWARD, handler(self, self.reqCallFriendsRewardRsp))
	msgCtrl.register(gCmd.CMD_SULTAN_BACK_COMEBACK_MODULE, gCmd.REQ_SULTAN_BACK_COMEBACK_INIT, handler(self, self.reqFriendsComeBackInitRsp))
	msgCtrl.register(gCmd.CMD_SULTAN_BACK_COMEBACK_MODULE, gCmd.REQ_SULTAN_BACK_COMEBACK_REWARD, handler(self, self.reqFriendsComeBackRewardRsp))
	self:registerNotify()
	self:reqBackKingTaskInit()
	self:reqBackWarTaskInit()
	self:reqWelcomeInit()
	self:reqLuxuryGiftInit()
	self:reqCallFriendsInit()
	self:reqFriendsComeBackInit()
end
function sultansBackCtrl:Logout()
	sultansBackCtrl.super.Logout(self)
	self:resetData()
end
function sultansBackCtrl:resetData()
	self.activityData, _UPVALUE0_, self.rebateData, _UPVALUE0_, self.welcomeBackData, _UPVALUE0_, self.friendComeBackData, _UPVALUE0_, self.callFriendData, _UPVALUE0_, self.warTotalTask, _UPVALUE0_, self.questComponentList, _UPVALUE0_, self.loginTaskList, _UPVALUE0_ = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
end
function sultansBackCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.SULTAN_BACK_MAIN, handler(self, self.notifyMainHandler))
	self.handle_notify_1 = notifyCtrl:register(gNotifyID.SULTAN_WAR_QUEST, handler(self, self.notifyWarTaskHandler))
	notifyCtrl:register(gNotifyID.SULTAN_BACK_LUXURYGIFT, handler(self, self.notifyLuxuryGiftHandler))
end
function sultansBackCtrl:notifyMainHandler(event)
	dump(event.data, "sultansBackCtrl:notifyMainHandler", 10)
	for _, info in ipairs(event.data) do
		for activityID, v in pairs(info) do
			if tonumber(activityID) == gActivityTimeActivityID.SULTAN_BACK_LOGIN_ACTIVITY then
				self.loginTaskList = v.record
				_ENV = gActivityTimeActivityID.SULTAN_BACK_LOGIN_ACTIVITY
				gActivityTimeActivityID.SULTAN_BACK_LOGIN_ACTIVITY.msg = "MESSAGE_SULTANSBACK_LOGINTASK_REFRESH"
				SoraDSendMessage(gActivityTimeActivityID.SULTAN_BACK_LOGIN_ACTIVITY)
				_ENV = gActivityTimeActivityID.SULTAN_BACK_LOGIN_ACTIVITY
				gActivityTimeActivityID.SULTAN_BACK_LOGIN_ACTIVITY.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
				gActivityTimeActivityID.SULTAN_BACK_LOGIN_ACTIVITY.activityID = tonumber(activityID)
				SoraDSendMessage(gActivityTimeActivityID.SULTAN_BACK_LOGIN_ACTIVITY)
			elseif tonumber(activityID) == gActivityTimeActivityID.SULTAN_BACK_REBATE_ACTIVITY then
				self.rebateData = v
				_ENV = gActivityTimeActivityID.SULTAN_BACK_REBATE_ACTIVITY
				gActivityTimeActivityID.SULTAN_BACK_REBATE_ACTIVITY.msg = "MESSAGE_SULTANSBACK_RREBATE_REFRESH"
				SoraDSendMessage(gActivityTimeActivityID.SULTAN_BACK_REBATE_ACTIVITY)
				_ENV = gActivityTimeActivityID.SULTAN_BACK_REBATE_ACTIVITY
				gActivityTimeActivityID.SULTAN_BACK_REBATE_ACTIVITY.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
				gActivityTimeActivityID.SULTAN_BACK_REBATE_ACTIVITY.activityID = tonumber(activityID)
				SoraDSendMessage(gActivityTimeActivityID.SULTAN_BACK_REBATE_ACTIVITY)
			elseif tonumber(activityID) == gActivityTimeActivityID.SULTAN_BACK_RETURN_ACTIVITY then
				if self.questComponentList[tonumber(activityID)] then
					self.questComponentList[tonumber(activityID)]:onNotify_progressUpdate(v)
				end
			elseif tonumber(activityID) == gActivityTimeActivityID.SULTAN_BACK_CALL_FRIENDS then
				self.callFriendData = v
				_ENV = gActivityTimeActivityID.SULTAN_BACK_CALL_FRIENDS
				gActivityTimeActivityID.SULTAN_BACK_CALL_FRIENDS.msg = "MESSAGE_SULTANSBACK_CALLFRIENDS_REFRESH"
				SoraDSendMessage(gActivityTimeActivityID.SULTAN_BACK_CALL_FRIENDS)
				_ENV = gActivityTimeActivityID.SULTAN_BACK_CALL_FRIENDS
				gActivityTimeActivityID.SULTAN_BACK_CALL_FRIENDS.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
				gActivityTimeActivityID.SULTAN_BACK_CALL_FRIENDS.activityID = tonumber(activityID)
				SoraDSendMessage(gActivityTimeActivityID.SULTAN_BACK_CALL_FRIENDS)
			end
		end
	end
end
function sultansBackCtrl:notifyWarTaskHandler(event)
	dump(event.data, "sultansBackCtrl:notifyWarTaskHandler", 10)
	local activityID = gActivityTimeActivityID.SULTAN_BACK_RETURN_ACTIVITY
	for _, info in ipairs(event.data) do
		if info.type == "refreshData" and self.questComponentList[activityID] then
			self.questComponentList[activityID]:setQuestData(info.questData)
			_ENV = self.questComponentList[activityID]
			self.questComponentList[activityID].msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
			self.questComponentList[activityID].eventID = activityID
			SoraDSendMessage(self.questComponentList[activityID])
			_ENV = self.questComponentList[activityID]
			self.questComponentList[activityID].msg = "MESSAGE_ACTIVITY_MODULE_UPDATE_TASK"
			self.questComponentList[activityID].activityID = activityID
			SoraDSendMessage(self.questComponentList[activityID])
		end
	end
end
function sultansBackCtrl:notifyLuxuryGiftHandler(event)
	dump(event.data, "sultansBackCtrl:notifyLuxuryGiftHandler", 10)
	for _, info in ipairs(event.data) do
		if info.reward then
			local activityId = gActivityTimeActivityID.SULTAN_BACK_LUXURYGIFT_ACTIVITY
			local data = self:getActivityData(activityId)
			data.reward = info.reward
			self:setActivityData(activityId, data)
			_ENV = self
			self.msg = "MESSAGE_SULTANSBACK_LUXURYGIFT_REFRESH"
			SoraDSendMessage(self)
			_ENV = self
			self.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
			self.activityID = activityId
			SoraDSendMessage(self)
		end
	end
end
function sultansBackCtrl:initClientData(data)
	if not data then
		return
	end
	dump(data, "sultansBackCtrl:initClientData", 10)
	for activityID, v in pairs(data) do
		activityID = tonumber(activityID)
		if activityID == gActivityTimeActivityID.SULTAN_BACK_LOGIN_ACTIVITY then
			self.loginTaskList = v.record
		elseif activityID == gActivityTimeActivityID.SULTAN_BACK_REBATE_ACTIVITY then
			self.rebateData = v
		elseif activityID == gActivityTimeActivityID.SULTAN_BACK_CALL_FRIENDS then
			self.callFriendData = v
		elseif activityID == gActivityTimeActivityID.SULTAN_BACK_FRIEND_COMEBACK then
			self.friendComeBackData = v
		elseif activityID == gActivityTimeActivityID.SULTAN_BACK_WELCOME_ACTIVITY then
			self.welcomeBackData = v
		end
	end
end
function sultansBackCtrl:setActivityData(activityId, data)

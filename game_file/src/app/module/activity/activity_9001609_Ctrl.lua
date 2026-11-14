local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001609_Ctrl = class("activity_9001609_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001609_Ctrl:ctor(properties)
	activity_9001609_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.HONOR_BACK_SIGN
	self:resetData()
end
function activity_9001609_Ctrl:EnterGame()
	print("==activity_9001609_Ctrl:EnterGame==")
	msgCtrl.register(gCmd.CMD_HONOR_BACK_RECALL_FRIENDS_MODULE, gCmd.REQ_HONOR_BACK_RECALL_FRIENDS_DATA, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_HONOR_BACK_RECALL_FRIENDS_MODULE, gCmd.REQ_HONOR_BACK_RECALL_FRIENDS_BINDING, handler(self, self.reqBindingRsp))
	msgCtrl.register(gCmd.CMD_HONOR_BACK_RECALL_FRIENDS_MODULE, gCmd.REQ_HONOR_BACK_RECALL_FRIENDS_TASK_REWARD, handler(self, self.reqTaskRewardRsp))
	self:registerNotify()
end
function activity_9001609_Ctrl:Logout()
	activity_9001609_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001609_Ctrl:resetData()
	self.taskReward, _UPVALUE0_, self.backers, _UPVALUE0_ = nil, nil, nil, nil
	self.backTime = nil
	self.invitorUid = nil
end
function activity_9001609_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.HONOR_BACK_RECALL_FRIENDS, handler(self, self.notifyHandler))
end
function activity_9001609_Ctrl:notifyHandler(event)
	dump(event, "activity_9001609_Ctrl:notifyHandler===========", 10)
	for k, v in ipairs(event.data) do
		if v.backers then
			self.backers = v.backers
		end
		if v.taskReward then
			self.taskReward = v.taskReward
		end
	end
	_ENV = ipairs(event.data)
	ipairs(event.data).msg = "MESSAGE_ACTIVITY_9001609_UPDATE"
	SoraDSendMessage(ipairs(event.data))
	_ENV = ipairs(event.data)
	ipairs(event.data).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	ipairs(event.data).eventID = self.activityID
	ipairs(event.data).activityID = self.activityID
	SoraDSendMessage(ipairs(event.data))
end
function activity_9001609_Ctrl:sendReqInitDataMsg()
	serverproxy:Request(gCmd.CMD_HONOR_BACK_RECALL_FRIENDS_MODULE, gCmd.REQ_HONOR_BACK_RECALL_FRIENDS_DATA)
end
function activity_9001609_Ctrl:sendBindingMsg(pid)
	serverproxy = nil
	;(nil).pid = pid
	serverproxy:Request(gCmd.CMD_HONOR_BACK_RECALL_FRIENDS_MODULE, gCmd.REQ_HONOR_BACK_RECALL_FRIENDS_BINDING, nil)
end
function activity_9001609_Ctrl:sendTaskRewardMsg(taskId)
	serverproxy = nil
	;(nil).taskId = taskId
	serverproxy:Request(gCmd.CMD_HONOR_BACK_RECALL_FRIENDS_MODULE, gCmd.REQ_HONOR_BACK_RECALL_FRIENDS_TASK_REWARD, nil)
end
function activity_9001609_Ctrl:reqInitRsp(content)
	dump(content, "activity_9001609_Ctrl:reqInitRsp", 10)
	if content.err == gErrDef.Err_None then
		if not content.rspdata then
			local _ENV, data = content.rspdata, content.rspdata
		end
		self.backTime = data.backTime
		self.invitorUid = data.invitorUid
		if not data.backers then
			_ENV = data.backers
		end
		self.backers = data.backers
		if not data.taskReward then
			_ENV = data.taskReward
		end
		self.taskReward = data.taskReward
	end
end
function activity_9001609_Ctrl:reqBindingRsp(content)
	dump(content, "activity_9001609_Ctrl:reqBindingRsp")
	if content.err == gErrDef.Err_None then
		local data = content.rspdata.data
		self.invitorUid = data.invitorUid
		if content.rspdata.reward then
			SoraDMailGainItems(content.rspdata.reward, true)
		end
	elseif content.err == gErrDef.ERR_PID_NOT_EXIST then
		SoraDShowMsgTip(i18n("common_text_1245"))
	elseif content.err == gErrDef.Err_HONOR_BACK_RECALL_FRIENDS_CANT_BIND_BACKER then
		SoraDShowMsgTip(i18n("recallfriends_text_18"))
	elseif content.err == gErrDef.Err_HONOR_BACK_RECALL_FRIENDS_BIND_TARGET_TIMES_LIMIT then
		SoraDShowMsgTip(i18n("recallfriends_text_01"))
	end
	_ENV = i18n("recallfriends_text_01")
	i18n("recallfriends_text_01").msg = "MESSAGE_ACTIVITY_9001609_UPDATE"
	SoraDSendMessage(i18n("recallfriends_text_01"))
end
function activity_9001609_Ctrl:reqTaskRewardRsp(content)
	dump(content, "activity_9001609_Ctrl:reqTaskRewardRsp", 10)
	if content.err == gErrDef.Err_None then
		if not content.rspdata.data.taskReward then
			_ENV = content.rspdata.data.taskReward
		end
		self.taskReward = content.rspdata.data.taskReward
		if content.rspdata.reward then
			SoraDMailGainItems(content.rspdata.reward, true)
		end
	end
	_ENV = content.rspdata.reward
	content.rspdata.reward.msg = "MESSAGE_ACTIVITY_9001609_UPDATE"
	SoraDSendMessage(content.rspdata.reward)
end
function activity_9001609_Ctrl:isTaskRewarded(taskId)
	return self.taskReward[tostring(taskId)] and true or false
end
function activity_9001609_Ctrl:isBacker()
	return self.backTime and true or false
end
function activity_9001609_Ctrl:isBindInvitor()
	return self.invitorUid and true or false
end
function activity_9001609_Ctrl:getBackers()
	local _ENV, ret
	if self.backers then
		for k, v in pairs(self.backers) do
			v.uid = tonumber(k)
			table.insert(ret, v)
		end
	end
	table.sort(ret, function(a, b)
		return a.uid < b.uid
	end)
	return ret
end
function activity_9001609_Ctrl:getBackersCount()
	return self.backers and table.nums(self.backers) or 0
end
function activity_9001609_Ctrl:getBackersTotalRecharge()
	local cumuRecharge = 0
	if not self.backers then
		_ENV = self.backers
	end
	for k, v in pairs(self.backers) do
		cumuRecharge = cumuRecharge + (v.recharge or 0)
	end
	return cumuRecharge
end
function activity_9001609_Ctrl:getBackersCountReachDailyPoint()
	local count = 0
	local constantRead = include("constantRead")
	if not self.backers then
		_ENV = self.backers
	end
	for _, backer in pairs(self.backers) do
		if backer.dailyPoint and backer.dailyPoint >= constantRead.getConstValue("PLAYER_GLORY_RETURN_DAILY_TARGET_NUM") then
			count = count + 1
		end
	end
	return count
end
return activity_9001609_Ctrl

local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local friendsCallbackCtrl = class("friendsCallbackCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local serverproxy = gModuleMgr.getObject("serverproxy")
local friendsCallbackRead = include("friendsCallbackRead")
function friendsCallbackCtrl:ctor(properties)
	friendsCallbackCtrl.super.ctor(self, properties)
	self:resetData()
end
function friendsCallbackCtrl:Logout()
	friendsCallbackCtrl.super.Logout(self)
	self:resetData()
end
function friendsCallbackCtrl:resetData()
	self.totalGift, _UPVALUE0_, self.shopData, _UPVALUE0_, self.myInviteList, _UPVALUE0_, self.inviteTaskData, _UPVALUE0_ = nil, nil, nil, nil, nil, nil, nil, nil
	self.totalGold = 0
	self.inviteCode = 0
end
function friendsCallbackCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_FRIEND_CALL_BACK_MODULE, gCmd.REQ_COMMIT_CALL_BACK_TASK, handler(self, self.missionCommitRsp))
	msgCtrl.register(gCmd.CMD_FRIEND_CALL_BACK_MODULE, gCmd.REQ_BUY_ITEM_CALL_BACK, handler(self, self.buyItemRsp))
end
function friendsCallbackCtrl:initClientData(retdata)
	if retdata then
		local callbackData = retdata.userData.callBackData
		self.inviteTaskData = callbackData.inviteTaskData
		self.myInviteList = callbackData.myInviteList
		self.shopData = callbackData.shopData
		self.totalGift = callbackData.totalGift
		self.totalGold = callbackData.totalGold
		self.inviteCode = retdata.userData.inviteCode
		self:registerNotify()
	end
end
function friendsCallbackCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.FRIEND_CALLBACK, handler(self, self.notifyUpdate))
end
function friendsCallbackCtrl:notifyUpdate(event)
	dump(event.data, "friendsCallbackCtrl:notifyUpdate", 10)
	for k, v in ipairs(event.data) do
		if v.type == "updateMission" then
			print("进来更新了")
			self:updateMission(v.data)
		elseif v.type == "callbackData" then
			self.inviteTaskData = v.data.inviteTaskData
			self.myInviteList = v.data.myInviteList
			self.shopData = v.data.shopData
			self.totalGift = v.data.totalGift
			self.totalGold = v.data.totalGold
			_ENV = self
			self.msg = "MESSAGE_SERVER_FRIEND_BACK_UPDATE_GOLD"
			SoraDSendMessage(self)
		elseif v.type == "activityChange" then
			local callbackData = v.data.userData.callBackData
			self.inviteTaskData = callbackData.inviteTaskData
			self.myInviteList = callbackData.myInviteList
			self.shopData = callbackData.shopData
			self.totalGift = callbackData.totalGift
			self.totalGold = callbackData.totalGold
			self.inviteCode = v.data.userData.inviteCode
		end
	end
	_ENV = ipairs(event.data)
	ipairs(event.data).msg = "MESSAGE_SERVER_FRIEND_BACK_UPDATE_TASK"
	SoraDSendMessage(ipairs(event.data))
end
function friendsCallbackCtrl:updateMission(changeList)
	for k, v in ipairs(changeList) do
		self.inviteTaskData[tostring(v.taskID)].taskstatus = v.taskstatus
	end
	dump(self.inviteTaskData, "friendsCallbackCtrl:updateMission====self.inviteTaskData", 10)
end
function friendsCallbackCtrl:getInviteCode()
	return self.inviteCode
end
function friendsCallbackCtrl:getTaskState(taskID)
	print("现在的taskid", taskID)
	if self.inviteTaskData and self.inviteTaskData[tostring(taskID)] then
		return self.inviteTaskData[tostring(taskID)].taskstatus
	end
end
function friendsCallbackCtrl:getTaskCurNum(taskID)
	if self.inviteTaskData and self.inviteTaskData[tostring(taskID)] then
		return self.inviteTaskData[tostring(taskID)].curnum
	end
end
function friendsCallbackCtrl:getTaskTotalNum(taskID)
	return #friendsCallbackRead.callbackTaskGiftConfig
end
function friendsCallbackCtrl:getGoldNum()
	return self.totalGold
end
function friendsCallbackCtrl:getGiftsNum()
	return self.totalGift
end
function friendsCallbackCtrl:getInviteList()
	return self.myInviteList
end
function friendsCallbackCtrl:getExchangeID()
	return friendsCallbackRead.returnShopConfig[1].changeID.id
end
function friendsCallbackCtrl:canBuy(shopItemID)
	if not self.shopData or not self.shopData[tostring(shopItemID)] then
		return true
	end
	for k, v in ipairs(friendsCallbackRead.returnShopConfig) do
		if v.shopItemID == shopItemID then
			return self.shopData[tostring(shopItemID)] < v.limitNum
		end
	end
end
function friendsCallbackCtrl:reqCommitTask(_data)
	local data = _data
	serverproxy:Request(gCmd.CMD_FRIEND_CALL_BACK_MODULE, gCmd.REQ_COMMIT_CALL_BACK_TASK, data)
end
function friendsCallbackCtrl:reqBuyItem(_data)
	dump(_data, "riendsCallbackCtrl:reqBuyItem", 10)
	local data = _data
	serverproxy:Request(gCmd.CMD_FRIEND_CALL_BACK_MODULE, gCmd.REQ_BUY_ITEM_CALL_BACK, data)
end
function friendsCallbackCtrl:missionCommitRsp(content)
	dump(content, "friendsCallbackCtrl:missionCommitRsp(content)", 10)
	local err = content.err
	if err == gErrDef.Err_None then
		local mission = content.rspdata.mission
		if mission then
			self.inviteTaskData[tostring(mission.taskID)].taskstatus = mission.taskstatus
		end
		if content.rspdata.reward then
			SoraDMailGainItems(content.rspdata.reward, true)
		end
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_SERVER_FRIEND_BACK_UPDATE_TASK"
		SoraDSendMessage(content.rspdata.reward)
	end
end
function friendsCallbackCtrl:buyItemRsp(content)
	dump(content, "friendsCallbackCtrl:buyItemRsp(content)", 10)
	local err = content.err
	if err == gErrDef.Err_None then
		local rspdata = content.rspdata
		self.shopData = rspdata.shopData
		if rspdata.reward then
			SoraDMailGainItems(rspdata.reward, true)
		end
		_ENV = rspdata.reward
		rspdata.reward.msg = "MESSAGE_SERVER_FRIEND_BACK_UPDATE_SHOP"
		SoraDSendMessage(rspdata.reward)
		_ENV = rspdata.reward
		rspdata.reward.msg = "MESSAGE_SERVER_FRIEND_BACK_UPDATE_GOLD"
		SoraDSendMessage(rspdata.reward)
	end
end
return friendsCallbackCtrl

local GameModule = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local godRewardsRead = include("godRewardsRead")
local godRewardsCtrl = class("godRewardsCtrl", GameModule)
function godRewardsCtrl:ctor(properties)
	godRewardsCtrl.super.ctor(self, properties)
end
function godRewardsCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_UPGRADE_REWARD_MODULE, gCmd.REQ_UPGRADE_REWARD_RECEIVE, handler(self, self.sendReqGetRewardRsp))
	msgCtrl.register(gCmd.CMD_UPGRADE_REWARD_MODULE, gCmd.REQ_UPGRADE_REWARD_INIT, handler(self, self.sendReqInitRsp))
	self:resetData()
	self:registerNotify()
end
function godRewardsCtrl:Logout()
	self:resetData()
	godRewardsCtrl.super.Logout(self)
end
function godRewardsCtrl:initClientData(content)
	if not content then
		return
	end
	self:sendReqInit()
	self.activityData = content
end
function godRewardsCtrl:resetData()
	self.activityData, _UPVALUE0_ = nil, nil
	self.boxCount = 0
end
function godRewardsCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.UPGRADE_REWARD_ACTIVITY, handler(self, self.notifyCallback))
end
function godRewardsCtrl:notifyCallback(event)
	if event and event.data and type(event.data) == "table" then
		for _, content in ipairs(event.data) do
			self.activityData = content.initData
			self.boxCount = content.boxCount
			_ENV = nil
			;(nil).msg = "MESSAGE_GODREWARDS_REFRESH"
			SoraDSendMessage(nil)
			_ENV = nil
			;(nil).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
			;(nil).eventID = gActivityTimeActivityID.UPGRADE_REWARD_ACTIVITY
			SoraDSendMessage(nil)
		end
	end
end
function godRewardsCtrl:sendReqInitRsp(content)
	if content.err == gErrDef.Err_None then
		self.activityData = content.rspdata.initData
		self.boxCount = content.rspdata.boxCount
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_GODREWARDS_REFRESH"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function godRewardsCtrl:sendReqGetRewardRsp(content)
	if content.err == gErrDef.Err_None then
		self.activityData = content.rspdata.initData
		local num = content.rspdata.boxCount - self.boxCount
		self.boxCount = content.rspdata.boxCount
		_ENV = nil
		;(nil).msg = "MESSAGE_GODREWARDS_REFRESH"
		;(nil).taskID = content.data.taskID
		SoraDSendMessage(nil)
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		;(nil).eventID = gActivityTimeActivityID.UPGRADE_REWARD_ACTIVITY
		SoraDSendMessage(nil)
	end
end
function godRewardsCtrl:sendReqInit()
	serverproxy:Request(gCmd.CMD_UPGRADE_REWARD_MODULE, gCmd.REQ_UPGRADE_REWARD_INIT)
end
function godRewardsCtrl:sendReqGetReward(data)
	serverproxy:Request(gCmd.CMD_UPGRADE_REWARD_MODULE, gCmd.REQ_UPGRADE_REWARD_RECEIVE, data)
end
function godRewardsCtrl:getTaskInfo()
	local _ENV, tmpBack
	local giftID, itemID = self:getPrivilegeLevel()
	for i, v in pairs(self.activityData) do
		local taskConfig = godRewardsRead.getTaskConfigByIndex(i)
		local taskDescribe = godRewardsRead.getTaskDescribeByIndex(i)
		local tmp = v
		if taskConfig then
			tmp.award = serviceFunctions.table_copy_table(taskConfig.extraReward)
			table.insert(tmp.award, itemID)
			table.insert(tmp.award, taskConfig.count)
			tmp.totalNum = taskConfig.num
			tmp.taskType = taskConfig.taskType
			tmp.textDes = taskDescribe.des
			tmp.isAct = taskDescribe.isAct
			tmp.guideId = taskDescribe.guideId
			tmp.questID = tonumber(i)
			tmp.status = gBtnTargetStatusDef.GO
			if v.receive then
				tmp.status = gBtnTargetStatusDef.GOT
			elseif v.finishCount >= taskConfig.num then
				tmp.status = gBtnTargetStatusDef.GET
			end
			table.insert(tmpBack, tmp)
		end
	end
	table.sort(tmpBack, function(a, b)
		if a.status ~= b.status then
			return a.status < b.status
		end
		return a.questID < b.questID
	end)
	return tmpBack
end
function godRewardsCtrl:getReceivedBox()
	return self.boxCount
end
function godRewardsCtrl:getPrivilegeLevel()
	local itemID
	local giftID = 0
	dump(godRewardsRead.getGiftIDTbl(), "godRewardsRead.getGiftID()", 10)
	local privilegeGiftCtrl = SoraDGetCtrl("privilegeGiftCtrl")
	for i, v in pairs(godRewardsRead.getGiftIDTbl()) do
		if 0 < v and privilegeGiftCtrl:getErrByRechargeID(v) == gErrDef.Err_PRIVILEGE_GIFT_ALREADY_BUY then
			return v, i
		elseif v == 0 then
			itemID = i
		end
	end
	print("godRewardsCtrl:getPrivilegeLevel()", giftID, itemID)
	return giftID, itemID
end
function godRewardsCtrl:getReceiveStatusAndNum(activityID)
	local count = 0
	for i, v in pairs(self.activityData) do
		local taskConfig = godRewardsRead.getTaskConfigByIndex(i)
		if not v.receive and v.finishCount >= taskConfig.num then
			count = count + 1
		end
	end
	print("godRewardsCtrl:getReceiveStatusAndNum", count)
	return 0 < count, count
end
function godRewardsCtrl:getActivityData()
	if not self.activityData then
		_UPVALUE0_ = self.activityData
	end
	return self.activityData
end
return godRewardsCtrl

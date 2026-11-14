local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001611_Ctrl = class("activity_9001611_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001611_Ctrl:ctor(properties)
	activity_9001611_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.HONOR_BACK_DAILY_ACTIVITY
	self:resetData()
end
function activity_9001611_Ctrl:EnterGame()
	print("==activity_9001611_Ctrl:EnterGame==")
	msgCtrl.register(gCmd.CMD_HONOR_BACK_DAILY_MODULE, gCmd.REQ_HONOR_BACK_DAILY_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_HONOR_BACK_DAILY_MODULE, gCmd.REQ_HONOR_BACK_DAILY_REWARD, handler(self, self.reqRewardRsp))
	self:registerNotify()
end
function activity_9001611_Ctrl:Logout()
	activity_9001611_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001611_Ctrl:resetData()
	self.rewardInfo, _UPVALUE0_, self.taskCompletTimes, _UPVALUE0_, self.taskProcess, _UPVALUE0_, self.point = nil, nil, nil, nil, nil, nil, 0
end
function activity_9001611_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.HHONOR_BACK_DAILY, handler(self, self.notifyHandler))
end
function activity_9001611_Ctrl:notifyHandler(event)
	dump(event, "activity_9001611_Ctrl:notifyHandler===========", 10)
	for k, v in ipairs(event.data) do
		if v.type == "refresData" then
			self.point = v.data.point
			self.taskProcess = v.data.taskProcess
			self.taskCompletTimes = v.data.taskCompletTimes
			self.rewardInfo = v.data.rewardInfo
		end
	end
	_ENV = ipairs(event.data)
	ipairs(event.data).msg = "MESSAGE_ACTIVITY_9001611_UPDATE"
	SoraDSendMessage(ipairs(event.data))
	_ENV = ipairs(event.data)
	ipairs(event.data).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	ipairs(event.data).eventID = self.activityID
	ipairs(event.data).activityID = self.activityID
	SoraDSendMessage(ipairs(event.data))
end
function activity_9001611_Ctrl:sendReqInitDataMsg()
	serverproxy:Request(gCmd.CMD_HONOR_BACK_DAILY_MODULE, gCmd.REQ_HONOR_BACK_DAILY_INIT)
end
function activity_9001611_Ctrl:sendRewardMsg(rewardType, target)
	serverproxy = nil
	;(nil).rewardType = rewardType
	;(nil).target = target
	serverproxy:Request(gCmd.CMD_HONOR_BACK_DAILY_MODULE, gCmd.REQ_HONOR_BACK_DAILY_REWARD, nil)
end
function activity_9001611_Ctrl:reqInitRsp(content)
	dump(content, "activity_9001611_Ctrl:reqInitRsp")
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self.point = data.point
		self.taskProcess = data.taskProcess
		self.taskCompletTimes = data.taskCompletTimes
		self.rewardInfo = data.rewardInfo
	end
end
function activity_9001611_Ctrl:reqRewardRsp(content)
	dump(content, "activity_9001611_Ctrl:reqRewardRsp", 5)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata.initData
		self.point = data.point
		self.taskProcess = data.taskProcess
		self.taskCompletTimes = data.taskCompletTimes
		self.rewardInfo = data.rewardInfo
		if content.rspdata.rewards then
			SoraDMailGainItems(content.rspdata.rewards, true)
		end
	end
	_ENV = SoraDMailGainItems
	SoraDMailGainItems.msg = "MESSAGE_ACTIVITY_9001611_UPDATE"
	SoraDSendMessage(SoraDMailGainItems)
	_ENV = SoraDMailGainItems
	SoraDMailGainItems.msg = "MESSAGE_ACTIVITY_9001608_UPDATE_RED"
	SoraDMailGainItems.activityID = self.activityID
	SoraDSendMessage(SoraDMailGainItems)
end
function activity_9001611_Ctrl:getReceiveStatusAndNum()
	local retNum = 0
	local activity_9001611_Read = include("activity_9001611_Read")
	local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
	local backStarLv = lordInfoCtrl:getBackStarLv()
	local targetList = activity_9001611_Read.getTargetCfg(self:getGroup(), backStarLv)
	for k, v in ipairs(targetList) do
		if self:getPoint() >= v.target and not self:isRewarded(v.rewardtype, v.target) then
			retNum = retNum + 1
		end
	end
	return 0 < retNum, retNum
end
function activity_9001611_Ctrl:getPoint()
	return self.point
end
function activity_9001611_Ctrl:isRewarded(rewardtype, target)
	return self.rewardInfo[tostring(rewardtype)] and self.rewardInfo[tostring(rewardtype)][tostring(target)] or false
end
function activity_9001611_Ctrl:getTimes(index)
	return self.taskCompletTimes[tostring(index)] or 0
end
function activity_9001611_Ctrl:getGroup()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local param = activityShowCtrl:getParamByID(self.activityID)
	local _classtype = param.classtype and param.classtype or 1
	return _classtype
end
return activity_9001611_Ctrl

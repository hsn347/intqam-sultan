local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001673_Ctrl = class("activity_9001673_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001673_Ctrl:ctor(properties)
	activity_9001673_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.RECHARGE_INTERFACE_ACTIVITY
	self:resetData()
end
function activity_9001673_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_RECHARGE_INTERFACE_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_RECHARGE_INTERFACE_REWARD, handler(self, self.reqRewardRsp))
end
function activity_9001673_Ctrl:Logout()
	activity_9001673_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001673_Ctrl:resetData()
	self.isGetAward = false
end
function activity_9001673_Ctrl:initClientData(userActivityModule)
	if not userActivityModule then
		return
	end
	local activityData = userActivityModule[tostring(self.activityID)]
	if activityData and next(activityData) then
		dump(activityData, "==activity_9001673_Ctrl:initClientData==", 10)
		self.isGetAward = activityData.isGetAward
		self:aotoSwitch()
	end
end
function activity_9001673_Ctrl:getReceiveStatusAndNum()
	local num = 0
	local ret, doStage, stageTime = self:checkStage()
	if ret and doStage == 1 and not self:isGetReward() then
		num = 1
	end
	return 0 < num, num
end
function activity_9001673_Ctrl:checkStage()
	local ret = false
	local doStage = 0
	local stageTime = 0
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	if not activityShowCtrl:isActivityOpen(self.activityID) then
		return ret, doStage, stageTime
	end
	ret = true
	doStage = activityShowCtrl:getDoStageByID(self.activityID)
	if doStage == 0 then
		stageTime = activityShowCtrl:getEndTimeSession(self.activityID, doStage + 1) - serviceFunctions.systemTime()
	elseif doStage == 1 then
		stageTime = activityShowCtrl:getEndTimeSecond(self.activityID) - serviceFunctions.systemTime()
	end
	return ret, doStage, stageTime
end
function activity_9001673_Ctrl:getReaminTime()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	return activityShowCtrl:getEndTimeSecond(self.activityID) - serviceFunctions.systemTime()
end
function activity_9001673_Ctrl:aotoSwitch()
	local ret, doStage, stageTime = self:checkStage()
	print("ret,doStage,stageTime=======", ret, doStage, stageTime)
	if ret and doStage == 1 then
		GLOBAL_GAME_RECHARGE_MODE = true
		_ENV = doStage
		doStage.byUID = true
		SoraDConfigSet("Game:GameOptionsView:recharge~bool", GLOBAL_GAME_RECHARGE_MODE, doStage)
	end
end
function activity_9001673_Ctrl:sendReqInitDataMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_RECHARGE_INTERFACE_INIT, nil)
end
function activity_9001673_Ctrl:reqInitRsp(content)
	dump(content, "activity_9001673_Ctrl:reqInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:aotoSwitch()
	end
end
function activity_9001673_Ctrl:reqRewardMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_RECHARGE_INTERFACE_REWARD, nil)
end
function activity_9001673_Ctrl:reqRewardRsp(content)
	dump(content, "activity_9001673_Ctrl:reqRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.isGetAward = content.rspdata.isGetAward
		local rewards = content.rspdata.rewards
		if rewards and next(rewards) then
			SoraDMailGainItems(rewards, true)
		end
		_ENV = rewards
		rewards.msg = "MESSAGE_ACTIVITY_9001673_UPDATE"
		SoraDSendMessage(rewards)
	end
end
function activity_9001673_Ctrl:isGetReward()
	return self.isGetAward
end
return activity_9001673_Ctrl

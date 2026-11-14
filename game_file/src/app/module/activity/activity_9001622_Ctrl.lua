local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001622_Ctrl = class("activity_9001622_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001622_Ctrl:ctor(properties)
	activity_9001622_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.END_OF_RAMADAN_ADVANCE
	self:resetData()
end
function activity_9001622_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_END_OF_RAMADAN_ADVANCE_MODULE, gCmd.REQ_END_OF_RAMADAN_ADVANCE_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_END_OF_RAMADAN_ADVANCE_MODULE, gCmd.REQ_END_OF_RAMADAN_ADVANCE_REWARD, handler(self, self.reqRewardRsp))
end
function activity_9001622_Ctrl:Logout()
	activity_9001622_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001622_Ctrl:resetData()
	_UPVALUE0_ = nil
	self.initData, (nil).isGet = nil, false
end
function activity_9001622_Ctrl:initClientData(data)
	if not data then
		return
	end
	dump(data, "==activity_9001622_Ctrl:initClientData==", 10)
	self.initData = data
end
function activity_9001622_Ctrl:sendReqInitDataMsg(...)
	self:resetData()
end
function activity_9001622_Ctrl:reqInit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_END_OF_RAMADAN_ADVANCE_MODULE, gCmd.REQ_END_OF_RAMADAN_ADVANCE_INIT, nil)
end
function activity_9001622_Ctrl:reqInitRsp(content)
	dump(content, "activity_9001622_Ctrl:reqInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		if not content.rspdata then
			_ENV = content.rspdata
		end
		self.initData = content.rspdata
	end
end
function activity_9001622_Ctrl:reqReward()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_END_OF_RAMADAN_ADVANCE_MODULE, gCmd.REQ_END_OF_RAMADAN_ADVANCE_REWARD, nil)
end
function activity_9001622_Ctrl:reqRewardRsp(content)
	dump(content, "activity_9001622_Ctrl:reqRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData.isGet = true
		local rewards = content.rspdata.rewards
		if rewards then
			SoraDMailGainItems(rewards, true)
		end
		_ENV = rewards
		rewards.msg = "MESSAGE_ACTIVITY_9001622_UPDATE"
		SoraDSendMessage(rewards)
	end
end
function activity_9001622_Ctrl:getIsGet(...)
	return self.initData.isGet or false
end
function activity_9001622_Ctrl:getReceiveStatusAndNum(activityID)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local doStage = activityShowCtrl:getDoStageByID(self.activityID)
	if doStage == 1 and not self:getIsGet() then
		return true, -1
	else
		return false, 0
	end
end
function activity_9001622_Ctrl:getRewardItemList(...)
	local lftar_notice = require_data("lftar_notice", true).data
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local classType = activityShowCtrl:getParamClassType(self.activityID)
	local reward = lftar_notice[classType].reward
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	local itemList = serviceFunctions.tableFormat(reward, nil)
	return itemList
end
return activity_9001622_Ctrl

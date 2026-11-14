local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001597_Ctrl = class("activity_9001597_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001597_Ctrl:ctor(properties)
	activity_9001597_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.CALENDAR_ACTIVITY_9001597
	self:resetData()
end
function activity_9001597_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_RAMADAN_SALYUT_CREATE, handler(self, self.reqCreateRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_RAMADAN_SALYUT_PLAY_FIREWORKS, handler(self, self.reqPlayRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_RAMADAN_SALYUT_PLAY_RECEIVE_ALLIANCE_REWARD, handler(self, self.reqReceiveRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_RAMADAN_SALYUT_DELETE, handler(self, self.reqDeleteRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_RAMADAN_SALYUT_RANKLIST, handler(self, self.reqRankRsp))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_INIT", handler(self, self.activityInitRsp))
end
function activity_9001597_Ctrl:Logout()
	activity_9001597_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001597_Ctrl:resetData()
	self.msgData, _UPVALUE0_ = nil, nil
end
function activity_9001597_Ctrl:initClientData(userActivityModule)
	if not userActivityModule then
		return
	end
	dump(self.msgData, "==activity_9001597_Ctrl:initClientData==", 10)
	local activityData = userActivityModule[tostring(self.activityID)]
	if activityData and next(activityData) then
		self.msgData = activityData
	end
end
function activity_9001597_Ctrl:activityInitRsp(target, event)
	if event.activityID == self.activityID then
		dump(event, "==activity_9001597_Ctrl:activityInitRsp==", 10)
		self.msgData = event.initData
		_ENV = event
		event.msg = "MESSAGE_ACTIVITY_9001597_UPDATE"
		SoraDSendMessage(event)
	end
end
function activity_9001597_Ctrl:sendReqInitDataMsg()
	local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
	activityTaskComponentCtrl:sendReqInit()
end
function activity_9001597_Ctrl:reqCreate(x, y)
	serverproxy = nil
	;(nil).x = x
	;(nil).y = y
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_RAMADAN_SALYUT_CREATE, nil)
end
function activity_9001597_Ctrl:reqCreateRsp(content)
	dump(content, "activity_9001597_Ctrl:reqCreateRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.msgData = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001597_UPDATE"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001597_Ctrl:reqPlay(itemID, count)
	serverproxy = nil
	;(nil).itemID = itemID
	;(nil).count = count
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_RAMADAN_SALYUT_PLAY_FIREWORKS, nil)
end
function activity_9001597_Ctrl:reqPlayRsp(content)
	dump(content, "activity_9001597_Ctrl:reqPlayRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.msgData = content.rspdata
		SoraDMailGainItems(content.rspdata.rewards, true, nil, nil, 1)
		self.msgData.rewards = nil
		_ENV = content.rspdata.rewards
		content.rspdata.rewards.msg = "MESSAGE_ACTIVITY_9001597_UPDATE"
		SoraDSendMessage(content.rspdata.rewards)
	end
end
function activity_9001597_Ctrl:reqReceive(index)
	serverproxy = nil
	;(nil).index = index
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_RAMADAN_SALYUT_PLAY_RECEIVE_ALLIANCE_REWARD, nil)
end
function activity_9001597_Ctrl:reqReceiveRsp(content)
	dump(content, "activity_9001597_Ctrl:reqReceiveRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.msgData = content.rspdata
		SoraDMailGainItems(content.rspdata.rewards, true)
		self.msgData.rewards = nil
		_ENV = content.rspdata.rewards
		content.rspdata.rewards.msg = "MESSAGE_ACTIVITY_9001597_UPDATE"
		SoraDSendMessage(content.rspdata.rewards)
	end
end
function activity_9001597_Ctrl:reqDelete()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_RAMADAN_SALYUT_DELETE, nil)
end
function activity_9001597_Ctrl:reqDeleteRsp(content)
	dump(content, "activity_9001597_Ctrl:reqExchangeRsp(content)", 10)
	if content.err == gErrDef.Err_None or content.err == nil then
		self.msgData = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001597_UPDATE"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001597_Ctrl:reqRank(iBegin, count)
	serverproxy = nil
	;(nil).iBegin = iBegin
	;(nil).count = count
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_RAMADAN_SALYUT_RANKLIST, nil)
end
function activity_9001597_Ctrl:reqRankRsp(content)
	dump(content, "activity_9001597_Ctrl:reqRankRsp(content)", 10)
	if content.err == gErrDef.Err_None or content.err == nil then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001597_RANK"
		gErrDef.Err_None.rspdata = content.rspdata
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001597_Ctrl:getReceiveStatusAndNum()
	local activity_9001597_Read = include("activity_9001597_Read")
	local boxInfo = activity_9001597_Read.getBoxCfgs()
	local num = 0
	local isJoin = self:getIsJoinAlliance()
	if isJoin then
		for i, v in ipairs(boxInfo) do
			if self:getBoxRewardDataStatus(v.index, v.score) == gBtnTargetStatusDef.GET then
				num = num + 1
			end
		end
	end
	return 0 < num, num
end
function activity_9001597_Ctrl:getCDTime()
	if self.msgData.createCD and self.msgData.createCD > 0 then
		local lastCD = self.msgData.createCD - serviceFunctions.systemTime()
		dump(lastCD, "lastCD")
		return lastCD
	end
	return 0
end
function activity_9001597_Ctrl:getBoxRewardDataStatus(index, num)
	if self.msgData.allianceRewardMark and self.msgData.allianceRewardMark[tostring(index)] then
		return gBtnTargetStatusDef.GOT
	end
	local nowNum = self:getBoxRewardNum()
	_UPVALUE2_ = index
	index[1] = num
	index[2] = nowNum
	dump(index, "num <= nowNum")
	if num <= nowNum then
		return gBtnTargetStatusDef.GET
	end
	return gBtnTargetStatusDef.GO
end
function activity_9001597_Ctrl:getBoxRewardNum()
	return self.msgData.allianceScore or 0
end
function activity_9001597_Ctrl:getIsJoinAlliance()
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	return allianceMgr:hasJoinAlliance(true)
end
function activity_9001597_Ctrl:getIsCanBuild()
	return self.msgData.isMergeSalyut
end
function activity_9001597_Ctrl:getBuildData()
	if self.msgData.buildData and self.msgData.buildData.endTime > serviceFunctions.systemTime() then
		return self.msgData.buildData
	end
	return nil
end
function activity_9001597_Ctrl:getIsCanBuildLand(x, y)
	if x >= gBlackLandRect.ltX and x <= gBlackLandRect.rbX and y >= gBlackLandRect.ltY and y <= gBlackLandRect.rbY then
		return true
	end
	return false
end
return activity_9001597_Ctrl

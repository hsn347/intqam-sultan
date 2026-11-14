local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local lightGuardianCtrl = class("lightGuardianCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function lightGuardianCtrl:ctor(properties)
	self.activityID = gActivityTimeActivityID.RADIANCE_GUARDIAN_ACTIVITY
	lightGuardianCtrl.super.ctor(self, properties)
	self:resetData()
end
function lightGuardianCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_RADIANCE_GUARDIAN_MODULE, gCmd.REQ_RADIANCE_GUARDIAN_INIT_DATA, handler(self, self.reqRadianceGuardianInitDataRsp))
	msgCtrl.register(gCmd.CMD_RADIANCE_GUARDIAN_MODULE, gCmd.REQ_RADIANCE_GUARDIAN_REWARD, handler(self, self.reqRadianceGuardianRewardRsp))
	msgCtrl.register(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_PLAYER_GUARD_SCORE_RANK, handler(self, self.reqRadianceGuardianRankRsp))
	self:reqRadianceGuardianInitData()
end
function lightGuardianCtrl:Logout()
	lightGuardianCtrl.super.Logout(self)
	self:resetData()
end
function lightGuardianCtrl:resetData()
	self.activityData, _UPVALUE0_ = nil, nil
end
function lightGuardianCtrl:reqRadianceGuardianInitData()
	serverproxy:Request(gCmd.CMD_RADIANCE_GUARDIAN_MODULE, gCmd.REQ_RADIANCE_GUARDIAN_INIT_DATA)
end
function lightGuardianCtrl:reqRadianceGuardianReward(stage)
	serverproxy = nil
	;(nil).stage = stage
	serverproxy:Request(gCmd.CMD_RADIANCE_GUARDIAN_MODULE, gCmd.REQ_RADIANCE_GUARDIAN_REWARD, nil)
end
function lightGuardianCtrl:reqRadianceGuardianRank(data)
	serverproxy:Request(gCmd.CMD_RADIANCE_WAR_MODULE, gCmd.REQ_RADIANCE_WAR_PLAYER_GUARD_SCORE_RANK, data)
end
function lightGuardianCtrl:reqRadianceGuardianInitDataRsp(content)
	dump(content, "lightGuardianCtrl:reqRadianceGuardianInitDataRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.activityData = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_RADIANCE_GUARDIAN_REFRESH"
		gErrDef.Err_None.subMsg = "init"
		SoraDSendMessage(gErrDef.Err_None)
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		gErrDef.Err_None.eventID = self.activityID
		SoraDSendMessage(gErrDef.Err_None)
	elseif content.err == gErrDef.ERR_MODULE_SWITCH_CLOSE then
		_ENV = gErrDef.ERR_MODULE_SWITCH_CLOSE
		gErrDef.ERR_MODULE_SWITCH_CLOSE.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		gErrDef.ERR_MODULE_SWITCH_CLOSE.eventID = self.activityID
		SoraDSendMessage(gErrDef.ERR_MODULE_SWITCH_CLOSE)
	end
end
function lightGuardianCtrl:reqRadianceGuardianRewardRsp(content)
	dump(content, "lightGuardianCtrl:reqRadianceGuardianRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		SoraDMailGainItems(content.rspdata.reward, true)
		self.activityData.reward[tostring(content.rspdata.stage)] = 1
		_ENV = tostring(content.rspdata.stage)
		tostring(content.rspdata.stage).msg = "MESSAGE_RADIANCE_GUARDIAN_REFRESH"
		tostring(content.rspdata.stage).subMsg = "getReward"
		SoraDSendMessage((tostring(content.rspdata.stage)))
		_ENV = tostring(content.rspdata.stage)
		tostring(content.rspdata.stage).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		tostring(content.rspdata.stage).eventID = self.activityID
		SoraDSendMessage((tostring(content.rspdata.stage)))
	end
end
function lightGuardianCtrl:reqRadianceGuardianRankRsp(content)
	dump(content, "lightGuardianCtrl:reqRadianceGuardianRankRsp(content)", 10)
	_ENV = content
	content.msg = "MESSAGE_RADIANCE_GUARDIAN_REFRESH"
	content.subMsg = "rank"
	if not content.rspdata then
		_ENV = content.rspdata
	end
	content.infoData = content.rspdata
	SoraDSendMessage(content)
end
function lightGuardianCtrl:getProperties(key)
	return self.activityData[key]
end
function lightGuardianCtrl:getReceiveStatusAndNum()
	local retNum = 0
	if not self.activityData.reward then
		local _ENV, reward = self.activityData.reward, self.activityData.reward
	end
	for i = 1, self.activityData.stage or 0 do
		if reward[tostring(i)] == 0 then
			retNum = retNum + 1
		end
	end
	print("lightGuardianCtrl:getReceiveStatusAndNum", retNum)
	return 0 < retNum, retNum
end
return lightGuardianCtrl

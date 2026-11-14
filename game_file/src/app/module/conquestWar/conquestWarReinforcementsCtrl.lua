local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local conquestWarReinforcementsCtrl = class("conquestWarReinforcementsCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function conquestWarReinforcementsCtrl:ctor(properties)
	conquestWarReinforcementsCtrl.super.ctor(self, properties)
	self:resetData()
end
function conquestWarReinforcementsCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_CONQUEST_WAR_MODULE, gCmd.CMD_CONQUEST_WAR_INVITE_INFO, handler(self, self.reqConquestWarInviteInfoRsp))
	msgCtrl.register(gCmd.CMD_CONQUEST_WAR_MODULE, gCmd.CMD_CONQUEST_WAR_AGREE_INVITE, handler(self, self.reqConquestWarAgreeInviteRsp))
	msgCtrl.register(gCmd.CMD_CONQUEST_WAR_MODULE, gCmd.CMD_CONQUEST_WAR_AGREE_CANCEL, handler(self, self.reqConquestWarAgreeCancelRsp))
	msgCtrl.register(gCmd.CMD_CONQUEST_WAR_MODULE, gCmd.CMD_CONQUEST_WAR_REJECT_INVITE, handler(self, self.reqConquestWarRejectInviteRsp))
	msgCtrl.register(gCmd.CMD_CONQUEST_WAR_MODULE, gCmd.CMD_CONQUEST_WAR_SERRCH_USER, handler(self, self.reqConquestWarSerrchUserRsp))
	msgCtrl.register(gCmd.CMD_CONQUEST_WAR_MODULE, gCmd.CMD_CONQUEST_WAR_MATCH_REINFORCE, handler(self, self.reqConquestWarMatchReinforceRsp))
	msgCtrl.register(gCmd.CMD_CONQUEST_WAR_MODULE, gCmd.CMD_CONQUEST_WAR_TOP10_CAN_RF, handler(self, self.reqConquestWarTop10hUserRsp))
	msgCtrl.register(gCmd.CMD_CONQUEST_WAR_MODULE, gCmd.CMD_CONQUEST_WAR_HOSPITAL_SWITCH, handler(self, self.reqConquestWarHospitalSwitchRsp))
	self:registerNotify()
end
function conquestWarReinforcementsCtrl:Logout()
	conquestWarReinforcementsCtrl.super.Logout(self)
	self:resetData()
end
function conquestWarReinforcementsCtrl:resetData()
	self.inviteInfo, _UPVALUE0_ = nil, nil
	self.strength = 0
	self.hospitalSwitch = false
end
function conquestWarReinforcementsCtrl:registerNotify()
	print("conquestWarReinforcementsCtrl-registerNotify")
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.CONQUEST_WAR, handler(self, self.notifyHandler))
end
function conquestWarReinforcementsCtrl:notifyHandler(event)
	dump(event.data, "conquestWarReinforcementsCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		self.inviteInfo = v.notifyData.inviteInfo
		self.strength = v.notifyData.strength
		self.hospitalSwitch = v.notifyData.hospitalSwitch
		_ENV = nil
		;(nil).msg = "MESSAGE_CONQUESTWAR_REINFORCEMENTS"
		;(nil).subMsg = "inviteUpdate"
		SoraDSendMessage(nil)
	end
end
function conquestWarReinforcementsCtrl:sendReqInitDataMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_CONQUEST_WAR_MODULE, gCmd.CMD_CONQUEST_WAR_INVITE_INFO, nil)
end
function conquestWarReinforcementsCtrl:reqConquestWarInviteInfoRsp(content)
	dump(content, "conquestWarReinforcementsCtrl:reqConquestWarInviteInfoRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.inviteInfo = content.rspdata.inviteInfo
		self.strength = content.rspdata.strength
		self.hospitalSwitch = content.rspdata.hospitalSwitch
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_CONQUESTWAR_REINFORCEMENTS"
		gErrDef.Err_None.subMsg = "init"
		SoraDSendMessage(gErrDef.Err_None)
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		gErrDef.Err_None.eventID = gActivityTimeActivityID.KINGDOM_BATTLE
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function conquestWarReinforcementsCtrl:reqConquestWarAgreeInvite(data)
	serverproxy:Request(gCmd.CMD_CONQUEST_WAR_MODULE, gCmd.CMD_CONQUEST_WAR_AGREE_INVITE, data)
end
function conquestWarReinforcementsCtrl:reqConquestWarAgreeInviteRsp(content)
	dump(content, "conquestWarReinforcementsCtrl:reqConquestWarAgreeInviteRsp(content)", 10)
	self.inviteInfo = content.rspdata.inviteInfo
	_ENV = content
	content.msg = "MESSAGE_CONQUESTWAR_REINFORCEMENTS"
	content.subMsg = "inviteUpdate"
	SoraDSendMessage(content)
	_ENV = content
	content.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	content.eventID = gActivityTimeActivityID.KINGDOM_BATTLE
	SoraDSendMessage(content)
	if content.err == gErrDef.Err_None then
	elseif content.err == gErrDef.Err_CONQUESTWAR_MAX_STRENGTH then
		SoraDShowMsgTip(i18n("conquestwar_text_33"))
	elseif content.err == gErrDef.Err_CONQUESTWAR_MAX_MATCH_USER_STRENGTH then
		SoraDShowMsgTip(i18n("conquestwar_text_33"))
	elseif content.err == gErrDef.Err_CONQUESTWAR_AGREE_NUM_LIMIT then
		SoraDShowMsgTip(i18n("conquestwar_text_32"))
	end
end
function conquestWarReinforcementsCtrl:reqConquestWarAgreeCancel(data)
	serverproxy:Request(gCmd.CMD_CONQUEST_WAR_MODULE, gCmd.CMD_CONQUEST_WAR_AGREE_CANCEL, data)
end
function conquestWarReinforcementsCtrl:reqConquestWarAgreeCancelRsp(content)
	dump(content, "conquestWarReinforcementsCtrl:reqConquestWarAgreeCancelRsp(content)", 10)
	self.inviteInfo = content.rspdata.inviteInfo
	_ENV = content
	content.msg = "MESSAGE_CONQUESTWAR_REINFORCEMENTS"
	content.subMsg = "inviteUpdate"
	SoraDSendMessage(content)
	_ENV = content
	content.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	content.eventID = gActivityTimeActivityID.KINGDOM_BATTLE
	SoraDSendMessage(content)
end
function conquestWarReinforcementsCtrl:reqConquestWarRejectInvite(data)
	serverproxy:Request(gCmd.CMD_CONQUEST_WAR_MODULE, gCmd.CMD_CONQUEST_WAR_REJECT_INVITE, data)
end
function conquestWarReinforcementsCtrl:reqConquestWarRejectInviteRsp(content)
	dump(content, "conquestWarReinforcementsCtrl:reqConquestWarRejectInviteRsp(content)", 10)
	self.inviteInfo = content.rspdata.inviteInfo
	_ENV = content
	content.msg = "MESSAGE_CONQUESTWAR_REINFORCEMENTS"
	content.subMsg = "inviteUpdate"
	SoraDSendMessage(content)
	_ENV = content
	content.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	content.eventID = gActivityTimeActivityID.KINGDOM_BATTLE
	SoraDSendMessage(content)
end
function conquestWarReinforcementsCtrl:reqConquestWarSerrchUser(data)
	serverproxy:Request(gCmd.CMD_CONQUEST_WAR_MODULE, gCmd.CMD_CONQUEST_WAR_SERRCH_USER, data)
end
function conquestWarReinforcementsCtrl:reqConquestWarSerrchUserRsp(content)
	dump(content, "conquestWarReinforcementsCtrl:reqConquestWarSerrchUserRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_CONQUESTWAR_REINFORCEMENTS"
		gErrDef.Err_None.userList = content.rspdata
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function conquestWarReinforcementsCtrl:reqConquestWarMatchReinforce()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_CONQUEST_WAR_MODULE, gCmd.CMD_CONQUEST_WAR_MATCH_REINFORCE, nil)
end
function conquestWarReinforcementsCtrl:reqConquestWarMatchReinforceRsp(content)
	dump(content, "conquestWarReinforcementsCtrl:reqConquestWarMatchReinforceRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_CONQUESTWAR_REINFORCEMENTS"
		gErrDef.Err_None.subMsg = "reinforcementsList"
		gErrDef.Err_None.rspdata = content.rspdata
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function conquestWarReinforcementsCtrl:reqConquestWarTop10hUser()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_CONQUEST_WAR_MODULE, gCmd.CMD_CONQUEST_WAR_TOP10_CAN_RF, nil)
end
function conquestWarReinforcementsCtrl:reqConquestWarTop10hUserRsp(content)
	dump(content, "conquestWarReinforcementsCtrl:reqConquestWarTop10hUserRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local _ENV, userList = content.err, content.err
		local maxStrength = SoraDGetCtrl("conquestWarCtrl"):getMaxStrength()
		for index, value in ipairs(content.rspdata) do
			if maxStrength >= value.strength then
				table.insert(userList, value)
			end
		end
		dump(userList, "userList")
		_ENV = userList
		userList.msg = "MESSAGE_CONQUESTWAR_REINFORCEMENTS"
		userList.userList = userList
		SoraDSendMessage(userList)
	end
end
function conquestWarReinforcementsCtrl:reqConquestWarHospitalSwitch(switch)
	serverproxy = nil
	;(nil).switch = switch
	serverproxy:Request(gCmd.CMD_CONQUEST_WAR_MODULE, gCmd.CMD_CONQUEST_WAR_HOSPITAL_SWITCH, nil)
end
function conquestWarReinforcementsCtrl:reqConquestWarHospitalSwitchRsp(content)
	dump(content, "conquestWarReinforcementsCtrl:reqConquestWarHospitalSwitchRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.hospitalSwitch = content.rspdata.hospitalSwitch
	end
end
function conquestWarReinforcementsCtrl:getInviteInfo()
	local _ENV, ret
	if not self.inviteInfo then
		_ENV = self.inviteInfo
	end
	for i, v in pairs(self.inviteInfo) do
		table.insert(ret, v)
	end
	return ret
end
function conquestWarReinforcementsCtrl:getStrength()
	return self.strength
end
function conquestWarReinforcementsCtrl:getAgreeKindom()
	if not self.inviteInfo then
		_ENV = self.inviteInfo
	end
	for i, v in pairs(self.inviteInfo) do
		if v.state == gConquestWarReinforcementsState.AGREE then
			return v.kid, v.matchKid
		end
	end
end
function conquestWarReinforcementsCtrl:getReceiveStatusAndNum()
	local num = 0
	if not self.inviteInfo then
		_ENV = self.inviteInfo
	end
	for i, v in pairs(self.inviteInfo) do
		if v.state == gConquestWarReinforcementsState.INVETED then
			num = num + 1
		end
	end
	return 0 < num, num
end
function conquestWarReinforcementsCtrl:getHospitalSwitch()
	return self.hospitalSwitch
end
return conquestWarReinforcementsCtrl

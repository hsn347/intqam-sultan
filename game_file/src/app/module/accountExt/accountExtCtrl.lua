local GameModule = include("GameModule")
local accountExtCtrl = class("accountExtCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function accountExtCtrl:ctor(properties)
	accountExtCtrl.super.ctor(self, properties)
end
function accountExtCtrl:resetData()
	self.pid = nil
	self.inviteCode = nil
	self.bInvite = nil
	self.inviteName = nil
	self.inviteKingdomid = nil
	self.inviteNum = nil
	self.inviterUid = nil
	self.inviteAllianceName = nil
	self.isGM = nil
	self.inviteCD = nil
	self.facebookReward = false
end
function accountExtCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_ACCOUNTEXT_MODULE, gCmd.REQ_ACCOUNTEXT_PID, handler(self, self.getAccountExtData))
	msgCtrl.register(gCmd.CMD_ACCOUNTEXT_MODULE, gCmd.REQ_ACCOUNTEXT_INVITED, handler(self, self.repSetInviteCode))
	msgCtrl.register(gCmd.CMD_ACCOUNTEXT_MODULE, gCmd.REQ_ACCOUNTEXT_REPLACE_CODE, handler(self, self.repReplaceInviteCode))
	msgCtrl.register(gCmd.CMD_ACCOUNTEXT_MODULE, gCmd.REQ_ACCOUNTEXT_DELETE, handler(self, self.repDeleteInviterRsp))
	self:resetData()
	self:initAccountExt()
	self:registerNotify()
end
function accountExtCtrl:initAccountExt(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ACCOUNTEXT_MODULE, gCmd.REQ_ACCOUNTEXT_PID, nil, ...)
end
function accountExtCtrl:getAccountExtData(content)
	local data = content.data
	if "table" == type(data) then
		self.pid = data.pid
		self.inviteCode = data.inviteCode
		self.bInvite = data.bInvite
		self.inviteName = data.inviteName
		self.inviteKingdomid = data.inviteKingdomid
		self.inviteNum = data.inviteNum
		self.inviterUid = data.inviterUid
		self.inviteAllianceName = data.inviteAllianceName
		self.isGM = data.isGM
		self.inviteCD = data.inviteCD
		self.facebookReward = data.facebookReward
	end
end
function accountExtCtrl:setInviteCode(inviteCode)
	serverproxy:Request(gCmd.CMD_ACCOUNTEXT_MODULE, gCmd.REQ_ACCOUNTEXT_INVITED, inviteCode)
end
function accountExtCtrl:replaceInviteCode(inviteCode)
	serverproxy:Request(gCmd.CMD_ACCOUNTEXT_MODULE, gCmd.REQ_ACCOUNTEXT_REPLACE_CODE, inviteCode)
end
function accountExtCtrl:reqDeleteInviter()
	serverproxy:Request(gCmd.CMD_ACCOUNTEXT_MODULE, gCmd.REQ_ACCOUNTEXT_DELETE)
end
function accountExtCtrl:Logout()
	self:resetData()
	accountExtCtrl.super.Logout(self)
end
function accountExtCtrl:repSetInviteCode(content)
	local result = false
	if gErrDef.Err_ACCOUNTEXT_NOT_INVITECODE == content.err then
		SoraDShowMsgTip(i18n("common_text_1064"))
	elseif gErrDef.Err_ACCOUNTEXT_ALREADY_INVITED == content.err then
		SoraDShowMsgTip(i18n("common_text_973"))
	elseif gErrDef.Err_ACCOUNTEXT_SELF_CANT_INVITED == content.err then
		SoraDShowMsgTip(i18n("common_text_1066"))
	elseif gErrDef.Err_None == content.err then
		SoraDShowMsgTip(i18n("common_text_979"))
		result = true
		local data = content.data
		self.bInvite = data.bInvite
		self.inviteName = data.inviteName
		self.inviteKingdomid = data.inviteKingdomid
		self.inviteNum = data.inviteNum
		self.inviterUid = data.inviterUid
		self.inviteAllianceName = data.inviteAllianceName
		self.inviteCD = data.inviteCD
	end
	_ENV = data.inviteCD
	data.inviteCD.msg = "MESSAGE_SERVER_OPTION_INPUTTHEINVITECODE"
	data.inviteCD.retdate = result
	SoraDSendMessage(data.inviteCD)
end
function accountExtCtrl:repReplaceInviteCode(ret)
	if ret.err == gErrDef.Err_ACCOUNTEXT_IN_CD_TIME then
		SoraDShowMsgTip(i18n("common_text_046"))
	elseif ret.err == gErrDef.Err_ACCOUNTEXT_SELF_CANT_INVITED then
		SoraDShowMsgTip(i18n("common_text_1066"))
	elseif ret.err == gErrDef.Err_ACCOUNTEXT_NOT_INVITED then
		SoraDShowMsgTip(i18n("common_text_1064"))
	elseif ret.err == gErrDef.Err_ACCOUNTEXT_NOT_INVITECODE then
		SoraDShowMsgTip(i18n("common_text_1064"))
	elseif ret.err == gErrDef.Err_ACCOUNTEXT_THE_SAME then
		SoraDShowMsgTip(i18n("common_text_973"))
	else
		local data = ret.data
		self.inviteName = data.inviteName
		self.inviteKingdomid = data.inviteKingdomid
		self.inviteNum = data.inviteNum
		self.inviterUid = data.inviterUid
		self.inviteAllianceName = data.inviteAllianceName
		self.inviteCD = data.inviteCD
		SoraDShowMsgTip(i18n("common_text_1523"))
	end
	_ENV = SoraDShowMsgTip
	SoraDShowMsgTip.msg = "MESSAGE_SERVER_OPTION_INPUTTHEINVITECODE"
	SoraDSendMessage(SoraDShowMsgTip)
end
function accountExtCtrl:repDeleteInviterRsp(ret)
	dump(ret, "accountExtCtrl:repDeleteInviterRsp", 10)
	if ret.err == gErrDef.Err_None then
		local data = ret.data
		self.inviteName = data.inviteName
		self.inviteKingdomid = data.inviteKingdomid
		self.inviteNum = data.inviteNum
		self.inviterUid = data.inviterUid
		self.inviteAllianceName = data.inviteAllianceName
		self.inviteCD = data.inviteCD
	end
	_ENV = data.inviteCD
	data.inviteCD.msg = "MESSAGE_SERVER_OPTION_INPUTTHEINVITECODE"
	SoraDSendMessage(data.inviteCD)
end
function accountExtCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.ACCOUNT_EXTINFO, handler(self, self.notifyAccountExt))
end
function accountExtCtrl:notifyAccountExt(event)
	if event and event.data and type(event.data) == "table" then
		for _, content in ipairs(event.data) do
			dump(content, "accountExtCtrl:notifyAccountExt")
			if content.isGM then
				self.isGM = content.isGM
			end
			if content.inviteNum then
				self.inviteNum = content.inviteNum
			end
			if content.inviteCD then
				self.inviteCD = content.inviteCD
			end
		end
	end
	_ENV = ipairs(event.data)
	ipairs(event.data).msg = "MESSAGE_SERVER_OPTION_INPUTTHEINVITECODE"
	SoraDSendMessage(ipairs(event.data))
end
function accountExtCtrl:sendInitAccountExt()
	self:initAccountExt()
end
function accountExtCtrl:getAccountPid()
	return self.pid
end
function accountExtCtrl:getAccountInviteCode()
	return self.inviteCode
end
function accountExtCtrl:getBeInvite()
	return self.bInvite
end
function accountExtCtrl:getInviteName()
	return self.inviteName
end
function accountExtCtrl:getInviteKingdomid()
	return self.inviteKingdomid
end
function accountExtCtrl:getInviteNum()
	return self.inviteNum
end
function accountExtCtrl:getinviteUid()
	return self.inviterUid
end
function accountExtCtrl:getInviteAllianceName()
	return self.inviteAllianceName
end
function accountExtCtrl:getInviteCD()
	if self.inviteCD then
		return self.inviteCD - serviceFunctions.systemTime()
	end
	return 0
end
function accountExtCtrl:getIsGM()
	return 1 == self.isGM
end
function accountExtCtrl:isReceiveFacebookReward()
	return self.facebookReward
end
function accountExtCtrl:getReceiveStatusAndNum()
	local ret = false
	local retNum = 0
	if not self.facebookReward then
		ret = true
		retNum = -1
	end
	return ret, retNum
end
return accountExtCtrl

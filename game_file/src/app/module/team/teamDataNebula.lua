local teamDataNebula = class("teamDataNebula", include("teamDataBase"))
local teamDef = include("teamDef")
function teamDataNebula:ctor(teamType)
	teamDataNebula.super.ctor(self, teamType)
end
local getUserList = function(event)
	if event.err == gErrDef.Err_None then
		if not event.rspdata then
			local _ENV, memberList = event.rspdata, event.rspdata
		end
		_ENV = nil
		;(nil).msg = "MESSAGE_NEBULA_TEAM_INVITE_LIST_BACK"
		;(nil).memberList = memberList
		SoraDSendMessage(nil)
	else
		_ENV = SoraDSendMessage
		SoraDSendMessage.memberList, _ENV, SoraDSendMessage.msg = nil, nil, "MESSAGE_NEBULA_TEAM_INVITE_LIST_BACK"
		SoraDSendMessage(SoraDSendMessage)
	end
end
_ENV = include("teamDataBase")
include("teamDataBase")[gCmd.REQ_TEAM_INIT_DATA] = function(event)
	if event.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_NEBULA_TEAM_INIT_DATA"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
include("teamDataBase")[gCmd.REQ_TEAM_CREATE] = function(event)
	_ENV = nil
	;(nil).msg = "MESSAGE_NEBULA_TEAM_CREATE_BACk"
	;(nil).err = event.err
	SoraDSendMessage(nil)
	if event.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("nebula_war_text_0222"))
	end
end
include("teamDataBase")[gCmd.REQ_TEAM_KICK] = function(event)
	local err = event.err
	if err == gErrDef.Err_None then
		_ENV = nil
		;(nil).name = event.data.nickName
		SoraDShowMsgTip(i18n("nebula_war_text_0048", nil))
		_ENV = i18n("nebula_war_text_0048", nil)
		i18n("nebula_war_text_0048", nil).msg = "MESSAGE_NEBULA_TEAM_KICK_BACK"
		SoraDSendMessage(i18n("nebula_war_text_0048", nil))
	end
end
include("teamDataBase")[gCmd.REQ_TEAM_QUIT] = function(event)
	if event.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("free_team_text_75"))
	else
		SoraDShowMsgTip(i18n("nebula_war_text_0015"))
	end
	_ENV = i18n("nebula_war_text_0015")
	i18n("nebula_war_text_0015").msg = "MESSAGE_NEBULA_TEAM_QUIT_BACk"
	i18n("nebula_war_text_0015").err = event.err
	SoraDSendMessage(i18n("nebula_war_text_0015"))
end
include("teamDataBase")[gCmd.REQ_TEAM_DISMISS] = function(event)
	if event.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_NEBULA_TEAM_DISMISS_BACk"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
include("teamDataBase")[gCmd.REQ_TEAM_TRANSFER_LEADER] = function(event)
	if event.err == gErrDef.Err_None then
		local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
		if nebulaActivityCtrl:getMyTeamInfo():getIsSuperTeam() then
			SoraDShowMsgTip(i18n("nebula_war_text_0380"))
		else
			SoraDShowMsgTip(i18n("nebula_war_text_0046"))
		end
		_ENV = i18n("nebula_war_text_0046")
		i18n("nebula_war_text_0046").msg = "MESSAGE_NEBULA_TEAM_TRANSFER_LEADER"
		SoraDSendMessage(i18n("nebula_war_text_0046"))
	end
end
include("teamDataBase")[gCmd.REQ_TEAM_APPLY_JOIN] = function(event)
	if event.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("remains_text_25"))
	end
	_ENV = i18n("remains_text_25")
	i18n("remains_text_25").msg = "MESSAGE_NEBULA_TEAM_APPLY_JOIN_BACK"
	i18n("remains_text_25").err = event.err
	SoraDSendMessage(i18n("remains_text_25"))
end
include("teamDataBase")[gCmd.REQ_TEAM_AGREE_APPLY] = function(event)
	if event.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("nebula_war_text_0042"))
	end
	_ENV = i18n("nebula_war_text_0042")
	i18n("nebula_war_text_0042").msg = "MESSAGE_NEBULA_TEAM_AGREE_APPLY_BACK"
	i18n("nebula_war_text_0042").err = event.err
	i18n("nebula_war_text_0042").uid = event.data.uid
	SoraDSendMessage(i18n("nebula_war_text_0042"))
end
include("teamDataBase")[gCmd.REQ_TEAM_AGREE_INVITE] = function(event)
	if event.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("togetherTeam_text_66"))
	elseif event.err == gErrDef.Err_NEBULA_WAR_STATE_ERR then
		SoraDShowMsgTip(i18n("nebula_war_text_0512"))
	end
	_ENV = i18n("nebula_war_text_0512")
	i18n("nebula_war_text_0512").msg = "MESSAGE_NEBULA_TEAM_BEINVITE_BACK"
	SoraDSendMessage(i18n("nebula_war_text_0512"))
end
include("teamDataBase")[gCmd.REQ_TEAM_REJECT_INVITE] = function(event)
	_ENV = nil
	;(nil).msg = "MESSAGE_NEBULA_TEAM_BEINVITE_BACK"
	SoraDSendMessage(nil)
end
include("teamDataBase")[gCmd.REQ_TEAM_INVITE_JOIN] = function(event)
	if event.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("notice_0092"))
		_ENV = i18n("notice_0092")
		i18n("notice_0092").msg = "MESSAGE_NEBULA_TEAM_INVITE_JOIN_BACK"
		i18n("notice_0092").uid = event.data.uid
		SoraDSendMessage(i18n("notice_0092"))
	elseif event.err == gErrDef.Err_NEBULA_NOT_SAME_CAMP_KINDOM then
		SoraDShowMsgTip(i18n("nebula_war_text_0036"))
	end
end
include("teamDataBase")[gCmd.REQ_TEAM_SEARCH_TEAM] = function(event)
	if event.err == gErrDef.Err_None then
		if not event.rspdata then
			local _ENV, teamList = event.rspdata, event.rspdata
		end
		if not event.data then
			local _ENV, data = event.data, event.data
		end
		_ENV = nil
		;(nil).msg = "MESSAGE_NEBULA_TEAM_LIST_BACK"
		;(nil).teamList = teamList
		;(nil).data = data
		SoraDSendMessage(nil)
	else
		_ENV = event.data
		event.data.teamList, _ENV, event.data.msg = SoraDSendMessage, SoraDSendMessage, "MESSAGE_NEBULA_TEAM_LIST_BACK"
		SoraDSendMessage(event.data)
	end
end
include("teamDataBase")[gCmd.REQ_TEAM_GET_TEAM_MEMBER_INFO] = function(event)
	if event.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_NEBULA_TEAM_MEMBER_INFO_BACK"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
include("teamDataBase")[gCmd.REQ_TEAM_GET_TEAM_APPLY_INFO] = function(event)
	if event.err == gErrDef.Err_None then
		if not event.rspdata then
			local _ENV, retdata = event.rspdata, event.rspdata
		end
		local memberList = teamDef.transMemberList(retdata)
		_ENV = nil
		;(nil).msg = "MESSAGE_NEBULA_TEAM_APPLY_LIST_BACK"
		;(nil).memberList = memberList
		SoraDSendMessage(nil)
	end
end
include("teamDataBase")[gCmd.REQ_TEAM_GET_ALLY_INFO] = getUserList
include("teamDataBase")[gCmd.REQ_TEAM_GET_FRIEND_INFO] = getUserList
include("teamDataBase")[gCmd.REQ_TEAM_SEARCH_USER] = getUserList
include("teamDataBase")[gCmd.REQ_TEAM_SET_NAME] = function(event)
	_ENV = nil
	;(nil).msg = "MESSAGE_NEBULA_TEAM_CHANGE_INFO"
	;(nil).err = event.err
	SoraDSendMessage(nil)
end
include("teamDataBase")[gCmd.REQ_TEAM_SET_ABBR] = function(event)
	_ENV = nil
	;(nil).msg = "MESSAGE_NEBULA_TEAM_CHANGE_INFO"
	;(nil).err = event.err
	SoraDSendMessage(nil)
end
include("teamDataBase")[gCmd.REQ_TEAM_TRANSFER_COMMANDER] = function(event)
	if event.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("nebula_war_text_0380"))
		_ENV = i18n("nebula_war_text_0380")
		i18n("nebula_war_text_0380").msg = "MESSAGE_NEBULA_TEAM_TRANSFER_LEADER"
		SoraDSendMessage(i18n("nebula_war_text_0380"))
	end
end
include("teamDataBase")[gCmd.REQ_TEAM_SUPER_TEAM_INFO] = function(event)
	dump(event, "==REQ_TEAM_SUPER_TEAM_INFO==", 5)
	_ENV = event
	event.msg = "MESSAGE_NEBULA_TEAM_SUPER_TEAM_INFO"
	event.teamList = event.rspdata
	SoraDSendMessage(event)
end
include("teamDataBase")[gCmd.REQ_TEAM_SIGN_UP_SUPER_TEAM] = function(event)
	if event.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("nebula_war_text_0514"))
		_ENV = i18n("nebula_war_text_0514")
		i18n("nebula_war_text_0514").msg = "MESSAGE_NEBULA_TEAM_SIGN_UP_UPDATE"
		i18n("nebula_war_text_0514").num = event.rspdata.num
		SoraDSendMessage(i18n("nebula_war_text_0514"))
	end
end
include("teamDataBase")[gCmd.REQ_TEAM_CANCEL_SUPER_TEAM] = function(event)
	if event.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("nebula_war_text_0398"))
		_ENV = i18n("nebula_war_text_0398")
		i18n("nebula_war_text_0398").msg = "MESSAGE_NEBULA_TEAM_SIGN_UP_UPDATE"
		i18n("nebula_war_text_0398").num = event.rspdata.num
		SoraDSendMessage(i18n("nebula_war_text_0398"))
	end
end
include("teamDataBase")[gCmd.REQ_TEAM_SIGN_SUPER_TEAM_NUM] = function(event)
	dump(event, "==REQ_TEAM_SIGN_SUPER_TEAM_NUM==")
	if event.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_NEBULA_TEAM_SIGN_UP_UPDATE"
		gErrDef.Err_None.num = event.rspdata.num
		SoraDSendMessage(gErrDef.Err_None)
	end
end
local _ENV, include("teamDataBase")[gCmd.REQ_TEAM_SIGN_SUPER_TEAM_FC_RANK], cmdTable = gCmd.REQ_TEAM_SIGN_SUPER_TEAM_FC_RANK, function(event)
	dump(event, "==REQ_TEAM_SIGN_SUPER_TEAM_FC_RANK==", 10)
	if event.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_NEBULA_TEAM_SUPER_TEAM_FC_RANK"
		gErrDef.Err_None.rspdata = event.rspdata
		SoraDSendMessage(gErrDef.Err_None)
	end
end, include("teamDataBase")
local gCmd.REQ_TEAM_SIGN_SUPER_TEAM_FC_RANK[gErrDef.Err_NEBULA_WAR_CASTLE_LEVEL], codeConfig = "remains_text_20", gCmd.REQ_TEAM_SIGN_SUPER_TEAM_FC_RANK
local showErrorNotice = function(err)
	if err == gErrDef.Err_None then
		return
	end
	if codeConfig[err] then
		SoraDShowMsgTip(i18n(codeConfig[err]))
	end
end
function teamDataNebula:onMsgRsp(event)
	local fun = cmdTable[event.subcmd]
	if fun then
		fun(event)
	end
	if event.err ~= gErrDef.Err_None then
		showErrorNotice(event.err)
	end
end
function teamDataNebula:onMsg(msgData)
	local notifyType = msgData.notifyType
	_ENV = nil
	;(nil).msg = "MESSAGE_NEBULA_TEAM_INFO_NOTIFY"
	;(nil).notifyType = notifyType
	;(nil).key = msgData.k
	SoraDSendMessage(nil)
	if notifyType == "AGREE_APPLY" then
		if self:getIsSuperTeam() then
			if not self:isTeamLeader() then
				_ENV = msgData.k
				msgData.k.team = self:getTeamName()
				local showMsg = i18n("nebula_war_text_0438", msgData.k)
				SoraDShowMsgBox(showMsg)
			end
		else
			local teamInfo = msgData.teamInfo
			_ENV = self:getTeamName()
			_ENV = nil
			;(nil).abbr = teamInfo.abbr
			;(nil).name = teamInfo.name
			self:getTeamName().team = i18n("common_text_186", nil)
			local showMsg = i18n("nebula_war_text_0043", (self:getTeamName()))
			SoraDShowMsgBox(showMsg)
		end
	elseif notifyType == "QUIT" then
		_ENV = i18n("nebula_war_text_0043", (self:getTeamName()))
		i18n("nebula_war_text_0043", (self:getTeamName())).msg = "MESSAGE_NEBULA_TEAM_MEMBER_QUIT"
		i18n("nebula_war_text_0043", (self:getTeamName())).uid = msgData.uid
		SoraDSendMessage((i18n("nebula_war_text_0043", (self:getTeamName()))))
	end
end
function teamDataNebula:getTeamName()
	return teamDef.getTeamName_Legend(self)
end
function teamDataNebula:reqTeamTransferCommander(uid)
	print("teamDataNebula:reqTeamTransferCommander", uid)
	_ENV = nil
	;(nil).uid = uid
	self:Request(gCmd.REQ_TEAM_TRANSFER_COMMANDER, nil)
end
function teamDataNebula:reqTeamSuperTeamInfo()
	print("teamDataNebula:reqTeamSuperTeamInfo")
	self:Request(gCmd.REQ_TEAM_SUPER_TEAM_INFO)
end
function teamDataNebula:reqTeamAddAssembler(uid)
	print("teamDataNebula:reqTeamAddAssembler", uid)
	_ENV = nil
	;(nil).uid = uid
	self:Request(gCmd.REQ_TEAM_ADD_ASSEMBLER, nil)
end
function teamDataNebula:reqTeamDelAssembler(uid)
	print("teamDataNebula:reqTeamDelAssembler", uid)
	_ENV = nil
	;(nil).uid = uid
	self:Request(gCmd.REQ_TEAM_DEL_ASSEMBLER, nil)
end
function teamDataNebula:getIsSuperTeam(...)
	return teamDef.getIsSuperTeam(self)
end
function teamDataNebula:reqSignUpSuperTeam()
	print("teamDataNebula:reqSignUpSuperTeam")
	self:Request(gCmd.REQ_TEAM_SIGN_UP_SUPER_TEAM)
end
function teamDataNebula:reqCancelSuperTeam()
	print("teamDataNebula:reqCancelSuperTeam")
	self:Request(gCmd.REQ_TEAM_CANCEL_SUPER_TEAM)
end
function teamDataNebula:reqSignUpNum()
	print("teamDataNebula:reqSignUpNum")
	self:Request(gCmd.REQ_TEAM_SIGN_SUPER_TEAM_NUM)
end
function teamDataNebula:getIsSignUpSuperTeam(...)
	if self:isHasTeam() then
		return self.setting.signUp
	else
		return false
	end
end
function teamDataNebula:getSignUpTime(...)
	if self:isHasTeam() then
		return self.setting.signUpTime or 0
	else
		return 0
	end
end
function teamDataNebula:getSignUpCDRemainTime(...)
	local signUpTime = self:getSignUpTime()
	if 0 < signUpTime then
		local constantRead = include("constantRead")
		local time = constantRead.getConstValue("NEBULA_WARS_ENROLL_CD_TIME", 3600)
		return math.max(0, signUpTime + time - serviceFunctions.systemTime())
	end
	return 0
end
function teamDataNebula:reqSignSuperTeamRank(iBegin, nCount)
	_ENV = nil
	;(nil).min = iBegin
	;(nil).max = iBegin + nCount - 1
	self:Request(gCmd.REQ_TEAM_SIGN_SUPER_TEAM_FC_RANK, nil)
end
return teamDataNebula

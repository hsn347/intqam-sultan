local teamDataNebulaAllStar = class("teamDataNebulaAllStar", include("teamDataBase"))
local teamDef = include("teamDef")
function teamDataNebulaAllStar:ctor(teamType)
	teamDataNebulaAllStar.super.ctor(self, teamType)
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
	end
end
include("teamDataBase")[gCmd.REQ_TEAM_KICK] = function(event)
	local err = event.err
	if err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("chat_text_34"))
	elseif err == gErrDef.Err_TEAM_NO_PERMISSION then
		SoraDShowMsgTip(i18n("nebulaemperor_text_65"))
	elseif err == gErrDef.Err_TEAM_TARGET_NOT_IN_SELF_KID then
		SoraDShowMsgTip(i18n("common_text_3400"))
	else
		SoraDShowMsgTip(i18n("notice_0026"))
	end
	_ENV = i18n("notice_0026")
	i18n("notice_0026").msg = "MESSAGE_NEBULA_TEAM_KICK_BACK"
	SoraDSendMessage(i18n("notice_0026"))
end
include("teamDataBase")[gCmd.REQ_TEAM_QUIT] = function(event)
	if event.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("free_team_text_75"))
	end
	_ENV = i18n("free_team_text_75")
	i18n("free_team_text_75").msg = "MESSAGE_NEBULA_TEAM_QUIT_BACk"
	i18n("free_team_text_75").err = event.err
	SoraDSendMessage(i18n("free_team_text_75"))
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
		SoraDShowMsgTip(i18n("remains_text_49"))
	end
	_ENV = i18n("remains_text_49")
	i18n("remains_text_49").msg = "MESSAGE_NEBULA_TEAM_AGREE_APPLY_BACK"
	i18n("remains_text_49").err = event.err
	i18n("remains_text_49").uid = event.data.uid
	SoraDSendMessage(i18n("remains_text_49"))
end
include("teamDataBase")[gCmd.REQ_TEAM_REJECT_APPLY] = function(event)
	_ENV = nil
	;(nil).msg = "MESSAGE_NEBULA_TEAM_AGREE_APPLY_BACK"
	;(nil).err = event.err
	;(nil).uid = event.data.uid
	SoraDSendMessage(nil)
end
include("teamDataBase")[gCmd.REQ_TEAM_AGREE_INVITE] = function(event)
	_ENV = nil
	;(nil).msg = "MESSAGE_NEBULA_TEAM_BEINVITE_BACK"
	SoraDSendMessage(nil)
	if event.err == gErrDef.Err_None then
		local proxy = uiManager:getProxy("NebulaAllStarTeam")
		if not proxy then
			local nebulaAllStarUtil = include("nebulaAllStarUtil")
			nebulaAllStarUtil.openTeamView()
		end
	end
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
	elseif event.err == gErrDef.Err_IN_TEAM then
		SoraDShowMsgTip(i18n("NebulaAllstar_246"))
	elseif event.err == gErrDef.Err_NEBULA_ALL_STAR_CASTLE_LEVEL then
		SoraDShowMsgTip(i18n("NebulaAllstar_247"))
	elseif event.err == gErrDef.Err_TEAM_NOT_SAME_REGION then
		SoraDShowMsgTip(i18n("nebulaemperor_text_39"))
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
include("teamDataBase")[gCmd.REQ_TEAM_ADD_COMMANDER] = function(event)
	if event.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("alliance_office_text_04"))
	end
end
include("teamDataBase")[gCmd.REQ_TEAM_DEL_COMMANDER] = function(event)
	if event.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("nebula_war_text_0313"))
	end
end
include("teamDataBase")[gCmd.REQ_TEAM_NEBULA_ALL_STAR_TEAM_INFO] = function(event, self)
	dump(event, "==REQ_TEAM_NEBULA_ALL_STAR_TEAM_INFO==", 5)
	if not event.rspdata then
		local _ENV, teamInfo = event.rspdata, event.rspdata
	end
	_ENV = "==REQ_TEAM_NEBULA_ALL_STAR_TEAM_INFO=="
	;("==REQ_TEAM_NEBULA_ALL_STAR_TEAM_INFO==").msg = "MESSAGE_NEBULA_ALLSTAR_TEAM_INFO"
	;("==REQ_TEAM_NEBULA_ALL_STAR_TEAM_INFO==").teamInfo = teamInfo
	SoraDSendMessage("==REQ_TEAM_NEBULA_ALL_STAR_TEAM_INFO==")
end
local _ENV, include("teamDataBase")[gCmd.REQ_TEAM_INVITED_USERS_INFO], cmdTable = gCmd.REQ_TEAM_INVITED_USERS_INFO, function(event, self)
	dump(event, "==REQ_TEAM_INVITED_USERS_INFO==", 5)
	if not event.rspdata then
		local _ENV, invitedUsers = event.rspdata, event.rspdata
	end
	local needInfo = event.data.needInfo
	_ENV = 5
	;(5).msg = "MESSAGE_NEBULA_ALLSTAR_INVITED_USERS"
	;(5).invitedUsers = invitedUsers
	;(5).needInfo = needInfo
	SoraDSendMessage(5)
end, include("teamDataBase")
local gCmd.REQ_TEAM_INVITED_USERS_INFO[gErrDef.Err_NEBULA_WAR_CASTLE_LEVEL], codeConfig = "remains_text_20", gCmd.REQ_TEAM_INVITED_USERS_INFO
local showErrorNotice = function(err)
	if err == gErrDef.Err_None then
		return
	end
	if codeConfig[err] then
		SoraDShowMsgTip(i18n(codeConfig[err]))
	end
end
function teamDataNebulaAllStar:onMsgRsp(event)
	local fun = cmdTable[event.subcmd]
	if fun then
		fun(event, self)
	end
	if event.err ~= gErrDef.Err_None then
		showErrorNotice(event.err)
	end
end
function teamDataNebulaAllStar:onMsg(msgData)
	local notifyType = msgData.notifyType
	_UPVALUE0_ = nil
	;(nil).msg = "MESSAGE_NEBULA_TEAM_INFO_NOTIFY"
	;(nil).notifyType = notifyType
	;(nil).key = msgData.k
	self:sendMessage(nil)
	if notifyType == "QUIT" then
		_UPVALUE0_ = nil
		;(nil).msg = "MESSAGE_NEBULA_TEAM_MEMBER_QUIT"
		;(nil).uid = msgData.uid
		self:sendMessage(nil)
	end
end
function teamDataNebulaAllStar:sendMessage(data, ...)
	data.teamType = self:getTeamType()
	SoraDSendMessage(data, ...)
end
function teamDataNebulaAllStar:getTeamName()
	return teamDef.getTeamName_Nebula(self.abbr)
end
function teamDataNebulaAllStar:getTeamNameRaw(...)
	return teamDataNebulaAllStar.super.getTeamNameRaw(self)
end
function teamDataNebulaAllStar:reqTeamAddCommander(uid)
	print("teamDataNebulaAllStar:reqTeamAddCommander", uid)
	_ENV = nil
	;(nil).uid = uid
	self:Request(gCmd.REQ_TEAM_ADD_COMMANDER, nil)
end
function teamDataNebulaAllStar:reqTeamDelCommander(uid)
	print("teamDataNebulaAllStar:reqTeamDelCommander", uid)
	_ENV = nil
	;(nil).uid = uid
	self:Request(gCmd.REQ_TEAM_DEL_COMMANDER, nil)
end
function teamDataNebulaAllStar:getCommanderCount(...)
	if not self.setting or not self.setting.commanders then
		local _ENV, commanders = self.setting.commanders, self.setting.commanders
	end
	return table.nums(commanders)
end
function teamDataNebulaAllStar:isTeamCommander(uid)
	local gametop = gModuleMgr.getObject("gametop")
	local ownUid = uid or gametop.playertop_:getPlayerID()
	if not self.setting or not self.setting.commanders then
		local _ENV, commanders = self.setting.commanders, self.setting.commanders
	end
	return commanders[tostring(ownUid)] == 1
end
function teamDataNebulaAllStar:doInvitedInfo()
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_LEGEND_TEAM_INVITED_INFO"
	SoraDSendMessage(nil)
end
function teamDataNebulaAllStar:reqTeamNebulaAllStarTeamInfo(teamType)
	print("teamDataNebulaAllStar:reqTeamNebulaAllStarTeamInfo")
	_ENV = nil
	;(nil).teamType = teamType
	self:Request(gCmd.REQ_TEAM_NEBULA_ALL_STAR_TEAM_INFO, nil)
end
function teamDataNebulaAllStar:reqTeamInvitedUsersInfo(needInfo)
	print("teamDataNebulaAllStar:reqTeamInvitedUsersInfo")
	_ENV = nil
	;(nil).needInfo = needInfo
	self:Request(gCmd.REQ_TEAM_INVITED_USERS_INFO, nil)
end
function teamDataNebulaAllStar:getIsSuperTeam(...)
	return self:isHasTeam() and teamDef.getIsSuperTeam(self)
end
function teamDataNebulaAllStar:getIsBackupTeam(...)
	return self:isHasTeam() and not teamDef.getIsSuperTeam(self)
end
return teamDataNebulaAllStar

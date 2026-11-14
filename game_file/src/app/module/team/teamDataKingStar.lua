local teamDataKingStar = class("teamDataKingStar", include("teamDataBase"))
local teamDef = include("teamDef")
function teamDataKingStar:ctor(teamType)
	teamDataKingStar.super.ctor(self, teamType)
end
local getUserList = function(event)
	local err = event.err
	if err == gErrDef.Err_None then
		if not event.rspdata then
			local _ENV, retdata = event.rspdata, event.rspdata
		end
		local teamList = retdata
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_LEGEND_TEAM_APPROVAL_LIST_INVITED_BACK"
		;(nil).teamList = teamList
		SoraDSendMessage(nil)
	else
		_ENV = retdata
		retdata.teamList, _ENV, retdata.msg = SoraDSendMessage, SoraDSendMessage, "MESSAGE_SERVER_LEGEND_TEAM_APPROVAL_LIST_INVITED_BACK"
		SoraDSendMessage(retdata)
	end
end
_ENV = include("teamDataBase")
include("teamDataBase")[gCmd.REQ_TEAM_AGREE_APPLY] = function(event)
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_LEGEND_TEAM_APPROVAL_AGREE_BACK"
	;(nil).err = event.err
	;(nil).uid = event.data.uid
	SoraDSendMessage(nil)
end
include("teamDataBase")[gCmd.REQ_TEAM_REJECT_APPLY] = function(event)
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_LEGEND_TEAM_APPROVAL_INFO"
	;(nil).err = event.err
	;(nil).uid = event.data.uid
	;(nil).subMsg = "rejectApply"
	SoraDSendMessage(nil)
end
include("teamDataBase")[gCmd.REQ_TEAM_AGREE_APPLY_BATCH] = function(event)
	local err = event.err
	if err == gErrDef.Err_IN_TEAM then
		SoraDShowMsgTip(i18n("legendaryking_text_92"))
	elseif err == gErrDef.Err_TEAM_TARGET_NOT_IN_SELF_KID then
		SoraDShowMsgTip(i18n("legendaryking_text_91"))
	end
	_ENV = i18n("legendaryking_text_91")
	i18n("legendaryking_text_91").msg = "MESSAGE_SERVER_LEGEND_TEAM_APPROVAL_INFO"
	i18n("legendaryking_text_91").err = event.err
	i18n("legendaryking_text_91").uidList = event.data.uidList
	i18n("legendaryking_text_91").subMsg = "agreeApplyBatch"
	SoraDSendMessage(i18n("legendaryking_text_91"))
end
include("teamDataBase")[gCmd.REQ_TEAM_REJECT_APPLY_BATCH] = function(event)
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_LEGEND_TEAM_APPROVAL_INFO"
	;(nil).err = event.err
	;(nil).uidList = event.data.uidList
	;(nil).subMsg = "rejectApplyBatch"
	SoraDSendMessage(nil)
end
include("teamDataBase")[gCmd.REQ_TEAM_AGREE_INVITE] = function(event)
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_LEGEND_TEAM_INVITE_BACK"
	;(nil).err = event.err
	SoraDSendMessage(nil)
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_LEGEND_TEAM_MY_INFO"
	SoraDSendMessage(nil)
end
include("teamDataBase")[gCmd.REQ_TEAM_REJECT_INVITE] = function(event)
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_LEGEND_TEAM_INVITE_BACK"
	;(nil).err = event.err
	SoraDSendMessage(nil)
end
include("teamDataBase")[gCmd.REQ_TEAM_APPLY_JOIN] = function(event)
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_LEGEND_TEAM_JOIN_BACK"
	;(nil).err = event.err
	SoraDSendMessage(nil)
end
include("teamDataBase")[gCmd.REQ_TEAM_CREATE] = function(event)
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_LEGEND_TEAM_CREATE_BACK"
	;(nil).err = event.err
	SoraDSendMessage(nil)
	if event.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_UI_LEGEND_TEAM_MY_INFO"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
include("teamDataBase")[gCmd.REQ_TEAM_INVITE_JOIN] = function(event)
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_LEGEND_TEAM_APPROVAL_INVITED_BACK"
	;(nil).err = event.err
	;(nil).uid = event.data.uid
	SoraDSendMessage(nil)
end
include("teamDataBase")[gCmd.REQ_TEAM_KICK] = function(event)
	local err = event.err
	if err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("remains_text_45"))
	end
	_ENV = i18n("remains_text_45")
	i18n("remains_text_45").msg = "MESSAGE_SERVER_LEGEND_TEAM_MEMBER_EXPEL"
	i18n("remains_text_45").err = event.err
	SoraDSendMessage(i18n("remains_text_45"))
end
include("teamDataBase")[gCmd.REQ_TEAM_QUIT] = function(event)
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_LEGEND_TEAM_QUIT_BACK"
	;(nil).err = event.err
	SoraDSendMessage(nil)
	if event.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("free_team_text_75"))
		_ENV = i18n("free_team_text_75")
		i18n("free_team_text_75").msg = "MESSAGE_UI_LEGEND_TEAM_MY_INFO"
		SoraDSendMessage(i18n("free_team_text_75"))
	end
end
include("teamDataBase")[gCmd.REQ_TEAM_DISMISS] = function(event)
	if event.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_UI_LEGEND_TEAM_MY_INFO"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
include("teamDataBase")[gCmd.REQ_TEAM_SEARCH_TEAM] = function(event)
	local err = event.err
	if err == gErrDef.Err_None then
		if not event.rspdata then
			local _ENV, retdata = event.rspdata, event.rspdata
		end
		local teamList = retdata
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_LEGEND_TEAM_LIST_BACK"
		;(nil).teamList = teamList
		SoraDSendMessage(nil)
	end
end
include("teamDataBase")[gCmd.REQ_TEAM_SEARCH_USER] = getUserList
include("teamDataBase")[gCmd.REQ_TEAM_GET_ALLY_INFO] = getUserList
include("teamDataBase")[gCmd.REQ_TEAM_GET_FRIEND_INFO] = getUserList
include("teamDataBase")[gCmd.REQ_TEAM_SEND_INVITATION] = function(event)
	local err = event.err
	if err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("remains_text_148"))
	end
end
include("teamDataBase")[gCmd.REQ_TEAM_SET_NAME] = function(event)
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_LEGEND_TEAM_CHANGE_INFO"
	;(nil).err = event.err
	SoraDSendMessage(nil)
end
include("teamDataBase")[gCmd.REQ_TEAM_SET_ABBR] = function(event)
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_LEGEND_TEAM_CHANGE_INFO"
	;(nil).err = event.err
	SoraDSendMessage(nil)
end
include("teamDataBase")[gCmd.REQ_TEAM_SET_FLAG] = function(event)
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_LEGEND_TEAM_CHANGE_FLAG"
	;(nil).err = event.err
	SoraDSendMessage(nil)
end
include("teamDataBase")[gCmd.REQ_TEAM_TRANSFER_LEADER] = function(event)
	local err = event.err
	if err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("remains_text_41"))
		_ENV = i18n("remains_text_41")
		i18n("remains_text_41").msg = "MESSAGE_UI_LEGEND_TEAM_MY_INFO"
		SoraDSendMessage(i18n("remains_text_41"))
	end
	_ENV = i18n("remains_text_41")
	i18n("remains_text_41").msg = "MESSAGE_SERVER_LEGEND_TEAM_LEADER_CHANGE"
	i18n("remains_text_41").err = event.err
	SoraDSendMessage(i18n("remains_text_41"))
end
include("teamDataBase")[gCmd.REQ_TEAM_GET_TEAM_INFO] = function(event)
	local err = event.err
	if err == gErrDef.Err_None then
		local retdata = event.rspdata
		local teamInfo = retdata
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_LEGEND_TEAM_INFO"
		;(nil).teamInfo = teamInfo
		;(nil).err = err
		SoraDSendMessage(nil)
	else
		_ENV = retdata
		retdata.msg = "MESSAGE_SERVER_LEGEND_TEAM_INFO"
		retdata.err = err
		SoraDSendMessage(retdata)
	end
end
include("teamDataBase")[gCmd.REQ_TEAM_GET_TEAM_MEMBER_INFO] = function(event)
	local err = event.err
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_LEGEND_TEAM_MEMBER_INFO_BACK"
	;(nil).err = err
	SoraDSendMessage(nil)
end
include("teamDataBase")[gCmd.REQ_TEAM_GET_TEAM_APPLY_INFO] = function(event)
	local err = event.err
	if err == gErrDef.Err_None then
		if not event.rspdata then
			local _ENV, retdata = event.rspdata, event.rspdata
		end
		local teamList = teamDef.transMemberList(retdata)
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_LEGEND_TEAM_APPROVAL_LIST_ADD_BACK"
		;(nil).teamList = teamList
		SoraDSendMessage(nil)
	else
		_ENV = teamDef.transMemberList(retdata)
		teamDef.transMemberList(retdata).teamList, _ENV, teamDef.transMemberList(retdata).msg = SoraDSendMessage, SoraDSendMessage, "MESSAGE_SERVER_LEGEND_TEAM_APPROVAL_LIST_ADD_BACK"
		SoraDSendMessage((teamDef.transMemberList(retdata)))
	end
end
local include("teamDataBase")[gCmd.REQ_TEAM_INIT_DATA], cmdTable = function(event)
	if event.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_UI_LEGEND_TEAM_MY_INFO"
		SoraDSendMessage(gErrDef.Err_None)
	end
end, include("teamDataBase")
function teamDataKingStar:onMsgRsp(event)
	local fun = cmdTable[event.subcmd]
	if fun then
		fun(event)
	end
end
function teamDataKingStar:onMsg(msgData)
	local notifyType = msgData.notifyType
	if notifyType == "UPDATE_SETTING" then
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_LEGEND_TEAM_CHANGE_FLAG"
		SoraDSendMessage(nil)
	elseif notifyType == "APPLY_JOIN" or notifyType == "HAS_APPLY" then
		_ENV = nil
		;(nil).msg = "MESSAGE_GREEN_POINT_UPDATE"
		;(nil).type = GREEN_POINT_NOTICE_TYPE.ALLIANCE
		SoraDSendMessage(nil)
	end
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_LEGEND_TEAM_MY_INFO"
	SoraDSendMessage(nil)
end
function teamDataKingStar:getTeamName()
	return teamDef.getTeamName_Legend(self)
end
function teamDataKingStar:getTeamNameRaw()
	return self.name
end
function teamDataKingStar:getTeamAbbr()
	return self.abbr
end
function teamDataKingStar:getTeamFlag()
	if self:isHasTeam() then
		return self.setting.flag
	end
	return false
end
function teamDataKingStar:doInvitedInfo()
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_LEGEND_TEAM_INVITED_INFO"
	SoraDSendMessage(nil)
end
return teamDataKingStar

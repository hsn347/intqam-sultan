local teamDataRemains = class("teamDataRemains", include("teamDataBase"))
local teamDef = include("teamDef")
function teamDataRemains:ctor(teamType)
	teamDataRemains.super.ctor(self, teamType)
end
local getUserList = function(event)
	local err = event.err
	if err == gErrDef.Err_None then
		if not event.rspdata then
			local _ENV, retdata = event.rspdata, event.rspdata
		end
		local teamList = retdata
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_REMAINS_TEAM_APPROVAL_LIST_INVITED_BACK"
		;(nil).teamList = teamList
		SoraDSendMessage(nil)
	else
		_ENV = retdata
		retdata.teamList, _ENV, retdata.msg = SoraDSendMessage, SoraDSendMessage, "MESSAGE_SERVER_REMAINS_TEAM_APPROVAL_LIST_INVITED_BACK"
		SoraDSendMessage(retdata)
	end
end
_ENV = include("teamDataBase")
include("teamDataBase")[gCmd.REQ_TEAM_AGREE_APPLY] = function(event)
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_REMAINS_TEAM_APPROVAL_AGREE_BACK"
	;(nil).err = event.err
	;(nil).uid = event.data.uid
	SoraDSendMessage(nil)
end
include("teamDataBase")[gCmd.REQ_TEAM_AGREE_INVITE] = function(event)
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_REMAINS_TEAM_DISPATCH_BACK"
	;(nil).err = event.err
	SoraDSendMessage(nil)
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_TEAM_MY_INFO"
	SoraDSendMessage(nil)
end
include("teamDataBase")[gCmd.REQ_TEAM_APPLY_JOIN] = function(event)
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_REMAINS_TEAM_DISPATCH_BACK"
	;(nil).err = event.err
	SoraDSendMessage(nil)
end
include("teamDataBase")[gCmd.REQ_TEAM_CANCEL_MATCH] = function(event)
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_REMAINS_TEAM_MATCH_CANCEL_BACK"
	;(nil).err = event.err
	SoraDSendMessage(nil)
	if event.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_REMAINS_WAR_MATCH_STATUS"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
include("teamDataBase")[gCmd.REQ_TEAM_CREATE] = function(event)
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_REMAINS_TEAM_DISPATCH_BACK"
	;(nil).err = event.err
	SoraDSendMessage(nil)
	if event.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_UI_TEAM_MY_INFO"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
include("teamDataBase")[gCmd.REQ_TEAM_INVITE_JOIN] = function(event)
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_REMAINS_TEAM_APPROVAL_INVITED_BACK"
	;(nil).err = event.err
	;(nil).uid = event.data.uid
	SoraDSendMessage(nil)
end
include("teamDataBase")[gCmd.REQ_TEAM_JOIN] = function(event)
end
include("teamDataBase")[gCmd.REQ_TEAM_KICK] = function(event)
	local err = event.err
	if err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("remains_text_45"))
	end
	_ENV = i18n("remains_text_45")
	i18n("remains_text_45").msg = "MESSAGE_SERVER_REMAINS_TEAM_MEMBER_EXPEL"
	i18n("remains_text_45").err = event.err
	SoraDSendMessage(i18n("remains_text_45"))
end
include("teamDataBase")[gCmd.REQ_TEAM_MATCH] = function(event)
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_REMAINS_TEAM_MATCH_BACK"
	;(nil).err = event.err
	SoraDSendMessage(nil)
	if event.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_REMAINS_WAR_MATCH_STATUS"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
include("teamDataBase")[gCmd.REQ_TEAM_QUIT] = function(event)
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_REMAINS_TEAM_QUIT_BACK"
	;(nil).err = event.err
	SoraDSendMessage(nil)
	if event.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_UI_TEAM_MY_INFO"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
include("teamDataBase")[gCmd.REQ_TEAM_DISMISS] = function(event)
	if event.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_UI_TEAM_MY_INFO"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
include("teamDataBase")[gCmd.REQ_TEAM_REJECT_APPLY] = function(event)
end
include("teamDataBase")[gCmd.REQ_TEAM_SEARCH_TEAM] = function(event)
	local err = event.err
	if err == gErrDef.Err_None then
		if not event.rspdata then
			local _ENV, retdata = event.rspdata, event.rspdata
		end
		local teamList = retdata
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_REMAINS_TEAM_LIST_BACK"
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
end
include("teamDataBase")[gCmd.REQ_TEAM_TRANSFER_LEADER] = function(event)
	local err = event.err
	if err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("remains_text_41"))
		_ENV = i18n("remains_text_41")
		i18n("remains_text_41").msg = "MESSAGE_UI_TEAM_MY_INFO"
		SoraDSendMessage(i18n("remains_text_41"))
	end
	_ENV = i18n("remains_text_41")
	i18n("remains_text_41").msg = "MESSAGE_SERVER_REMAINS_TEAM_LEADER_CHANGE"
	i18n("remains_text_41").err = event.err
	SoraDSendMessage(i18n("remains_text_41"))
end
include("teamDataBase")[gCmd.REQ_TEAM_CHANGE_TROOP] = function(event)
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_REMAINS_TEAM_DISPATCH_BACK"
	;(nil).err = event.err
	SoraDSendMessage(nil)
end
include("teamDataBase")[gCmd.REQ_TEAM_GET_TEAM_INFO] = function(event)
	local err = event.err
	if err == gErrDef.Err_None then
		local retdata = event.rspdata
		local teamInfo = retdata
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_REMAINS_TEAM_INFO"
		;(nil).teamInfo = teamInfo
		;(nil).err = err
		SoraDSendMessage(nil)
	else
		_ENV = retdata
		retdata.msg = "MESSAGE_SERVER_REMAINS_TEAM_INFO"
		retdata.err = err
		SoraDSendMessage(retdata)
	end
end
include("teamDataBase")[gCmd.REQ_TEAM_GET_TEAM_MEMBER_INFO] = function(event)
	local err = event.err
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_REMAINS_TEAM_MEMBER_INFO_BACK"
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
		;(nil).msg = "MESSAGE_SERVER_REMAINS_TEAM_APPROVAL_LIST_ADD_BACK"
		;(nil).teamList = teamList
		SoraDSendMessage(nil)
	else
		_ENV = teamDef.transMemberList(retdata)
		teamDef.transMemberList(retdata).teamList, _ENV, teamDef.transMemberList(retdata).msg = SoraDSendMessage, SoraDSendMessage, "MESSAGE_SERVER_REMAINS_TEAM_APPROVAL_LIST_ADD_BACK"
		SoraDSendMessage((teamDef.transMemberList(retdata)))
	end
end
local include("teamDataBase")[gCmd.REQ_TEAM_INIT_DATA], cmdTable = function(event)
	if event.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_UI_TEAM_MY_INFO"
		SoraDSendMessage(gErrDef.Err_None)
	end
end, include("teamDataBase")
function teamDataRemains:onMsgRsp(event)
	local fun = cmdTable[event.subcmd]
	if fun then
		fun(event)
	end
end
function teamDataRemains:onMsg(msgData)
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_TEAM_MY_INFO"
	SoraDSendMessage(nil)
end
function teamDataRemains:getTeamName()
	return teamDef.getTeamName(self)
end
function teamDataRemains:isMaching()
	if self:isHasTeam() then
		return self.setting.lock
	end
	return false
end
function teamDataRemains:doInvitedInfo()
	if next(self.inviteList) then
		_ENV = self.inviteList
		self.inviteList.msg = "MESSAGE_SERVER_REMAINS_TEAM_INVITED_INFO"
		SoraDSendMessage(self.inviteList)
	end
end
function teamDataRemains:getInvitedInfo()
	if not self.inviteList[1] then
		_UPVALUE0_ = self.inviteList[1]
	end
	return self.inviteList[1]
end
return teamDataRemains

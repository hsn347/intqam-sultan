local teamDataNebulaEmperor = class("teamDataNebulaEmperor", include("teamDataBase"))
local teamDef = include("teamDef")
function teamDataNebulaEmperor:ctor(teamType)
	teamDataNebulaEmperor.super.ctor(self, teamType)
end
local SoraDSendNebulaEmperorMessage = function(data, ...)
	data.teamType = teamDef.teamAreaEnum.NEBULA_EMPEROR
	SoraDSendMessage(data, ...)
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
include("teamDataBase")[gCmd.REQ_TEAM_AGREE_INVITE] = function(event)
	_ENV = nil
	;(nil).msg = "MESSAGE_NEBULA_TEAM_BEINVITE_BACK"
	SoraDSendMessage(nil)
	if event.err == gErrDef.Err_None then
		local proxy = uiManager:getProxy("NebulaEmperorTeam")
		if not proxy then
			local nebulaEmperorUtil = include("nebulaEmperorUtil")
			nebulaEmperorUtil.openTeamView()
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
		SoraDShowMsgTip(i18n("nebulaemperor_text_41"))
	elseif event.err == gErrDef.ERR_CASTLE_LV_NOT_ENOUGH then
		local nebulaEmperorRead = include("nebulaEmperorRead")
		local starLv = nebulaEmperorRead.getNeedLv()
		_ENV = i18n("nebulaemperor_text_41")
		i18n("nebulaemperor_text_41").lv = starLv
		SoraDShowMsgTip(i18n("nebulaemperor_text_42", i18n("nebulaemperor_text_41")))
	elseif event.err == gErrDef.Err_TEAM_NO_PERMISSION then
		SoraDShowMsgTip(i18n("nebulaemperor_text_44"))
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
include("teamDataBase")[gCmd.REQ_TEAM_NEBULA_EMPEROR_TEAM_INFO] = function(event, self)
	dump(event, "==REQ_TEAM_NEBULA_EMPEROR_TEAM_INFO==", 5)
	if not event.rspdata then
		local _ENV, teamInfo = event.rspdata, event.rspdata
	end
	local inviteList = self:getInvitedInfo()
	for __, team in ipairs(inviteList) do
		if team.tid == teamInfo.tid then
			team.memberCount = teamInfo.memberCount
		end
	end
	_ENV = ipairs(inviteList)
	ipairs(inviteList).msg = "MESSAGE_NEBULA_EMPEROR_TEAM_INFO"
	ipairs(inviteList).teamInfo = teamInfo
	SoraDSendMessage(ipairs(inviteList))
end
include("teamDataBase")[gCmd.REQ_TEAM_ADD_ASSEMBLER] = function(event)
	if event.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("alliance_office_text_04"))
	end
end
include("teamDataBase")[gCmd.REQ_TEAM_DEL_ASSEMBLER] = function(event)
	if event.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("nebula_war_text_0313"))
	end
end
include("teamDataBase")[gCmd.REQ_TEAM_ADD_COMMANDER] = function(event)
	if event.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("alliance_office_text_04"))
	end
end
local _ENV, include("teamDataBase")[gCmd.REQ_TEAM_DEL_COMMANDER], cmdTable = gCmd.REQ_TEAM_DEL_COMMANDER, function(event)
	if event.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("nebula_war_text_0313"))
	end
end, include("teamDataBase")
local gCmd.REQ_TEAM_DEL_COMMANDER[gErrDef.Err_NEBULA_WAR_CASTLE_LEVEL], codeConfig = "remains_text_20", gCmd.REQ_TEAM_DEL_COMMANDER
local showErrorNotice = function(err)
	if err == gErrDef.Err_None then
		return
	end
	if codeConfig[err] then
		SoraDShowMsgTip(i18n(codeConfig[err]))
	end
end
function teamDataNebulaEmperor:onMsgRsp(event)
	local fun = cmdTable[event.subcmd]
	if fun then
		fun(event, self)
	end
	if event.err ~= gErrDef.Err_None then
		showErrorNotice(event.err)
	end
end
function teamDataNebulaEmperor:onMsg(msgData)
	local notifyType = msgData.notifyType
	SoraDSendNebulaEmperorMessage = nil
	;(nil).msg = "MESSAGE_NEBULA_TEAM_INFO_NOTIFY"
	;(nil).notifyType = notifyType
	;(nil).key = msgData.k
	SoraDSendNebulaEmperorMessage(nil)
	if notifyType == "AGREE_APPLY" then
		if not self:isTeamLeader() then
			SoraDShowMsgBox(i18n("nebulaemperor_text_207"))
		end
	elseif notifyType == "QUIT" then
		SoraDSendNebulaEmperorMessage = i18n("nebulaemperor_text_207")
		i18n("nebulaemperor_text_207").msg = "MESSAGE_NEBULA_TEAM_MEMBER_QUIT"
		i18n("nebulaemperor_text_207").uid = msgData.uid
		SoraDSendNebulaEmperorMessage(i18n("nebulaemperor_text_207"))
	end
end
function teamDataNebulaEmperor:getTeamName()
	return teamDef.getTeamName_Nebula(self.abbr)
end
function teamDataNebulaEmperor:getTeamNameRaw(...)
	return teamDataNebulaEmperor.super.getTeamNameRaw(self)
end
function teamDataNebulaEmperor:reqTeamNebulaEmperorTeamInfo()
	print("teamDataNebulaEmperor:reqTeamNebulaEmperorTeamInfo")
	self:Request(gCmd.REQ_TEAM_NEBULA_EMPEROR_TEAM_INFO)
end
function teamDataNebulaEmperor:reqTeamAddAssembler(uid)
	print("teamDataNebulaEmperor:reqTeamAddAssembler", uid)
	_ENV = nil
	;(nil).uid = uid
	self:Request(gCmd.REQ_TEAM_ADD_ASSEMBLER, nil)
end
function teamDataNebulaEmperor:reqTeamDelAssembler(uid)
	print("teamDataNebulaEmperor:reqTeamDelAssembler", uid)
	_ENV = nil
	;(nil).uid = uid
	self:Request(gCmd.REQ_TEAM_DEL_ASSEMBLER, nil)
end
function teamDataNebulaEmperor:reqTeamAddCommander(uid)
	print("teamDataNebulaEmperor:reqTeamAddCommander", uid)
	_ENV = nil
	;(nil).uid = uid
	self:Request(gCmd.REQ_TEAM_ADD_COMMANDER, nil)
end
function teamDataNebulaEmperor:reqTeamDelCommander(uid)
	print("teamDataNebulaEmperor:reqTeamDelCommander", uid)
	_ENV = nil
	;(nil).uid = uid
	self:Request(gCmd.REQ_TEAM_DEL_COMMANDER, nil)
end
function teamDataNebulaEmperor:getAssemblerCount(...)
	if not self.setting or not self.setting.assemblers then
		local _ENV, assemblers = self.setting.assemblers, self.setting.assemblers
	end
	return table.nums(assemblers)
end
function teamDataNebulaEmperor:isTeamAssembler(uid)
	local gametop = gModuleMgr.getObject("gametop")
	local ownUid = uid or gametop.playertop_:getPlayerID()
	if not self.setting or not self.setting.assemblers then
		local _ENV, assemblers = self.setting.assemblers, self.setting.assemblers
	end
	return assemblers[tostring(ownUid)] == 1
end
function teamDataNebulaEmperor:getCommanderCount(...)
	if not self.setting or not self.setting.commanders then
		local _ENV, commanders = self.setting.commanders, self.setting.commanders
	end
	return table.nums(commanders)
end
function teamDataNebulaEmperor:isTeamCommander(uid)
	local gametop = gModuleMgr.getObject("gametop")
	local ownUid = uid or gametop.playertop_:getPlayerID()
	if not self.setting or not self.setting.commanders then
		local _ENV, commanders = self.setting.commanders, self.setting.commanders
	end
	return commanders[tostring(ownUid)] == 1
end
function teamDataNebulaEmperor:doInvitedInfo()
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_LEGEND_TEAM_INVITED_INFO"
	SoraDSendMessage(nil)
end
return teamDataNebulaEmperor

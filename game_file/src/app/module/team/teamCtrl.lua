local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local teamCtrl = class("teamCtrl", gamemodulec)
local msgCtrl = include("msgCtrl")
local serverproxy = gModuleMgr.getObject("serverproxy")
local teamDataFactory = include("teamDataFactory")
_ENV = "teamDataFactory"
;("teamDataFactory")[gCmd.REQ_TEAM_AGREE_APPLY] = "teamAgreeApplyRSP"
;("teamDataFactory")[gCmd.REQ_TEAM_AGREE_INVITE] = "teamAgreeInviteRSP"
;("teamDataFactory")[gCmd.REQ_TEAM_APPLY_JOIN] = "teamApplyJoinRSP"
;("teamDataFactory")[gCmd.REQ_TEAM_CANCEL_MATCH] = "teamCancelMatchRSP"
;("teamDataFactory")[gCmd.REQ_TEAM_CREATE] = "teamCreateRSP"
;("teamDataFactory")[gCmd.REQ_TEAM_DISMISS] = "teamDismissRSP"
;("teamDataFactory")[gCmd.REQ_TEAM_INIT_DATA] = "teamInitDataRSP"
;("teamDataFactory")[gCmd.REQ_TEAM_INVITE_JOIN] = "teamInviteJoinRSP"
;("teamDataFactory")[gCmd.REQ_TEAM_JOIN] = "teamJoinRSP"
;("teamDataFactory")[gCmd.REQ_TEAM_KICK] = "teamKickRSP"
;("teamDataFactory")[gCmd.REQ_TEAM_MATCH] = "teamMatchRSP"
;("teamDataFactory")[gCmd.REQ_TEAM_QUIT] = "teamQuitRSP"
;("teamDataFactory")[gCmd.REQ_TEAM_REJECT_APPLY] = "teamRejectApplyRSP"
;("teamDataFactory")[gCmd.REQ_TEAM_REJECT_INVITE] = "teamRejectInviteRSP"
;("teamDataFactory")[gCmd.REQ_TEAM_SEARCH_TEAM] = "teamSearchRSP"
;("teamDataFactory")[gCmd.REQ_TEAM_SEND_INVITATION] = "teamSendInvitationRSP"
;("teamDataFactory")[gCmd.REQ_TEAM_SET_NAME] = "teamSetNameRSP"
;("teamDataFactory")[gCmd.REQ_TEAM_SET_ABBR] = "teamSetAbbrRSP"
;("teamDataFactory")[gCmd.REQ_TEAM_SET_FLAG] = "teamSetFlagRSP"
;("teamDataFactory")[gCmd.REQ_TEAM_TRANSFER_LEADER] = "teamTransferLeaderRSP"
;("teamDataFactory")[gCmd.REQ_TEAM_GET_TEAM_INFO] = "teamGetTeamInfoRSP"
;("teamDataFactory")[gCmd.REQ_TEAM_GET_TEAM_MEMBER_INFO] = "teamGetTeamMemberInfoRSP"
;("teamDataFactory")[gCmd.REQ_TEAM_GET_TEAM_APPLY_INFO] = "teamGetTeamApplyInfoRSP"
;("teamDataFactory")[gCmd.REQ_TEAM_CHANGE_TROOP] = "teamChangeTroopRSP"
;("teamDataFactory")[gCmd.REQ_TEAM_SEARCH_USER] = "teamSearchUserRSP"
;("teamDataFactory")[gCmd.REQ_TEAM_GET_ALLY_INFO] = "teamSearchAllianceRSP"
;("teamDataFactory")[gCmd.REQ_TEAM_GET_FRIEND_INFO] = "teamSearchFriendRSP"
;("teamDataFactory")[gCmd.REQ_TEAM_TRANSFER_COMMANDER] = "teamTransferCommanderRSP"
;("teamDataFactory")[gCmd.REQ_TEAM_SUPER_TEAM_INFO] = "teamSuperTeamInfoRSP"
;("teamDataFactory")[gCmd.REQ_TEAM_NEBULA_EMPEROR_TEAM_INFO] = "teamSuperTeamInfoRSP"
;("teamDataFactory")[gCmd.REQ_TEAM_ADD_ASSEMBLER] = "reqTeamAddAssemblerRSP"
;("teamDataFactory")[gCmd.REQ_TEAM_DEL_ASSEMBLER] = "reqTeamDelAssemblerRSP"
;("teamDataFactory")[gCmd.REQ_TEAM_ADD_COMMANDER] = "reqTeamAddCommanderRSP"
;("teamDataFactory")[gCmd.REQ_TEAM_DEL_COMMANDER] = "reqTeamDelCommanderRSP"
;("teamDataFactory")[gCmd.REQ_TEAM_SIGN_UP_SUPER_TEAM] = ""
;("teamDataFactory")[gCmd.REQ_TEAM_CANCEL_SUPER_TEAM] = ""
;("teamDataFactory")[gCmd.REQ_TEAM_SIGN_SUPER_TEAM_NUM] = ""
;("teamDataFactory")[gCmd.REQ_TEAM_SIGN_SUPER_TEAM_FC_RANK] = ""
;("teamDataFactory")[gCmd.REQ_TEAM_NEBULA_ALL_STAR_TEAM_INFO] = ""
;("teamDataFactory")[gCmd.REQ_TEAM_INVITED_USERS_INFO] = ""
;("teamDataFactory")[gCmd.REQ_TEAM_AGREE_APPLY_BATCH] = "teamAgreeApplyBatchRSP"
local ("teamDataFactory")[gCmd.REQ_TEAM_REJECT_APPLY_BATCH], cmdTable = "teamRejectApplyBatchRSP", "teamDataFactory"
function teamCtrl:getTeamRemains()
	local teamDef = include("teamDef")
	local teamAreaEnum = teamDef.teamAreaEnum
	return self:getTeamData(teamAreaEnum.RUINS)
end
function teamCtrl:getTeamLgend()
	local teamDef = include("teamDef")
	local teamAreaEnum = teamDef.teamAreaEnum
	return self:getTeamData(teamAreaEnum.LEGEND_LORD)
end
function teamCtrl:getTeamKingStar()
	local teamDef = include("teamDef")
	local teamAreaEnum = teamDef.teamAreaEnum
	return self:getTeamData(teamAreaEnum.LEGEND_LORD_FOR_SEP)
end
function teamCtrl:getTeamNebula(...)
	local teamDef = include("teamDef")
	local teamAreaEnum = teamDef.teamAreaEnum
	return self:getTeamData(teamAreaEnum.NEBULA_WAR)
end
function teamCtrl:getTeamNebulaEmperor(...)
	local teamDef = include("teamDef")
	local teamAreaEnum = teamDef.teamAreaEnum
	return self:getTeamData(teamAreaEnum.NEBULA_EMPEROR)
end
function teamCtrl:getTeamData(teamType)
	if not teamType then
		return
	end
	local team = self.tableData[teamType]
	if not team then
		team = teamDataFactory:createTeamData(teamType)
		self.tableData[teamType] = team
	end
	return team
end
function teamCtrl:reqTeamMsg(cmd, data)
	serverproxy:Request(gCmd.CMD_TEAM_MODULE, cmd, data)
end
function teamCtrl:ctor(properties)
	teamCtrl.super.ctor(self, properties)
	self.tableData, teamCtrl = teamCtrl.super.ctor, teamCtrl.super.ctor
end
function teamCtrl:EnterGame()
	_ENV = nil
	;(nil).byUID = true
	if not SoraDConfigGet("Game:teamCtrl:lastTeamMsgTimes~table", nil) then
		_ENV = SoraDConfigGet("Game:teamCtrl:lastTeamMsgTimes~table", nil)
	end
	self.lastTeamMsgTimes = SoraDConfigGet("Game:teamCtrl:lastTeamMsgTimes~table", nil)
	local handle = handler(self, self.onMsgRsp)
	for cmd, _ in pairs(cmdTable) do
		msgCtrl.register(gCmd.CMD_TEAM_MODULE, cmd, handle)
	end
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.NOTIFY_TEAM, handler(self, self.onMsg))
	self:resetData()
end
function teamCtrl:resetData()
	for _, v in pairs(self.tableData) do
		v:resetData()
	end
end
function teamCtrl:Logout()
	teamCtrl.super.Logout(self)
	self:resetData()
end
function teamCtrl:initClientData(data)
	if not data then
		return
	end
end
function teamCtrl:onMsg(event)
	local data = event.data
	if data then
		for _, msg in pairs(data) do
			local areaEnum = msg.areaEnum
			local msgName = "notify_" .. msg.notifyType
			local teamData = self:dispatchData(areaEnum, msgName, msg)
			if teamData then
				teamData:onMsg(msg)
			end
		end
	end
end
function teamCtrl:dispatchData(areaEnum, funName, data)
	local teamData = self:getTeamData(areaEnum)
	if teamData then
		local fun = teamData[funName]
		if fun then
			fun(teamData, data)
		end
	end
	return teamData
end
function teamCtrl:onMsgRsp(event)
	dump(event, "teamCtrl:onMsgRsp", 10)
	local data = event.data
	if data then
		local areaEnum = data.areaEnum
		local msgName = cmdTable[event.subcmd]
		local teamData = self:dispatchData(areaEnum, msgName, event)
		if teamData then
			teamData:onMsgRsp(event)
		end
	end
end
function teamCtrl:getLastTeamMsgTime(teamType)
	return self.lastTeamMsgTimes[tostring(teamType)] or 0
end
function teamCtrl:setLastTeamMsgTime(teamType, time)
	self.lastTeamMsgTimes[tostring(teamType)] = time
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:teamCtrl:lastTeamMsgTimes~table", self.lastTeamMsgTimes, nil)
end
return teamCtrl

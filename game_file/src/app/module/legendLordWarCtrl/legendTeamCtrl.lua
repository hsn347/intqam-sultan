local gamemodulec = include("GameModule")
local legendTeamCtrl = class("legendTeamCtrl", gamemodulec)
local gametop = gModuleMgr.getObject("gametop")
local serverproxy = gModuleMgr.getObject("serverproxy")
local legendTeamDef = include("legendTeamDef")
function legendTeamCtrl:reqCreateTeam(name, abbr, flag)
	print("legendTeamCtrl:reqCreateTeam", name, abbr, flag)
	_ENV = print
	print.name = name
	print.abbr = abbr
	local print.flag, areaData = flag or 1, print
	self.myTeamInfo:reqTeamCreate(areaData)
end
function legendTeamCtrl:reqCheckName(name)
	print("legendTeamCtrl:reqCheckName", name)
	local legendTeamUtil = include("legendTeamUtil")
	local err = legendTeamUtil.checkTeamName(name, true)
	if err == gErrDef.Err_None then
		_ENV = nil
		;(nil).name = name
		serverproxy:Request(gCmd.CMD_RUINS_WAR_MODULE, gCmd.CMD_RUINS_WAR_CHECK_NAME, nil)
	end
	return err
end
function legendTeamCtrl:reqGetTeamList(kid, aid, name)
	print("legendTeamCtrl:reqGetTeamList")
	self.myTeamInfo:reqTeamSearch(kid, aid, name)
end
function legendTeamCtrl:reqGetUserList(kid, name)
	print("legendTeamCtrl:reqGetUserList")
	self.myTeamInfo:reqTeamSearchUser(kid, name)
end
function legendTeamCtrl:reqGetAllianceList(isFilter)
	print("legendTeamCtrl:reqGetAllianceList")
	self.myTeamInfo:reqTeamSearchAlliance(isFilter)
end
function legendTeamCtrl:reqGetFriendList(isFilter)
	print("legendTeamCtrl:reqGetFriendList")
	self.myTeamInfo:reqTeamSearchFriend(isFilter)
end
function legendTeamCtrl:reqApplyJoin(teamId)
	print("legendTeamCtrl:reqApplyJoin", teamId)
	self.myTeamInfo:reqTeamApplyJoin(teamId)
end
function legendTeamCtrl:reqAgreeApplyJoin(uid)
	print("legendTeamCtrl:reqAgreeApplyJoin", uid)
	self.myTeamInfo:reqTeamAgreeApply(uid)
end
function legendTeamCtrl:reqDismissTeam()
	print("legendTeamCtrl:reqDismissTeam")
	self.myTeamInfo:reqTeamDismiss()
end
function legendTeamCtrl:reqExpelMember(uid)
	print("legendTeamCtrl:reqExpelMember", uid)
	self.myTeamInfo:reqTeamKick(uid)
end
function legendTeamCtrl:reqQuitTeam()
	print("legendTeamCtrl:reqQuitTeam")
	self.myTeamInfo:reqTeamQuit()
end
function legendTeamCtrl:reqDemiseTeam(uid)
	print("legendTeamCtrl:reqDemiseTeam", uid)
	self.myTeamInfo:reqTeamTransferLeader(uid)
end
function legendTeamCtrl:reqInviteJoinTeam(uid, kid)
	print("legendTeamCtrl:reqInviteJoinTeam", uid, kid)
	self.myTeamInfo:reqTeamInviteJoin(uid, kid)
end
function legendTeamCtrl:reqAgreeInviteJoin(teamId)
	print("legendTeamCtrl:reqAgreeInviteJoin", teamId)
	self.myTeamInfo:reqTeamAgreeInvite(teamId)
end
function legendTeamCtrl:reqRejectInviteJoin(teamId)
	print("legendTeamCtrl:reqRejectInviteJoin", teamId)
	self.myTeamInfo:reqTeamRejectInvite(teamId)
end
function legendTeamCtrl:reqGetTeamInfo(teamId)
	print("legendTeamCtrl:reqGetTeamInfo", teamId)
	self.myTeamInfo:reqTeamGetTeamInfo(teamId)
end
function legendTeamCtrl:reqGetMemberInfo()
	print("legendTeamCtrl:reqGetMemberInfo")
	self.myTeamInfo:reqTeamGetTeamMemberInfo()
end
function legendTeamCtrl:reqGetApplyList()
	print("legendTeamCtrl:reqGetApplyList")
	self.myTeamInfo:reqTeamGetTeamApplyInfo()
end
function legendTeamCtrl:reqTeamSetName(name)
	print("legendTeamCtrl:reqTeamSetName", name)
	self.myTeamInfo:reqTeamSetName(name)
end
function legendTeamCtrl:reqTeamSetAbbr(abbr)
	print("legendTeamCtrl:reqTeamSetAbbr", abbr)
	self.myTeamInfo:reqTeamSetAbbr(abbr)
end
function legendTeamCtrl:reqTeamSetFlag(flag)
	print("legendTeamCtrl:reqTeamSetFlag", flag)
	self.myTeamInfo:reqTeamSetFlag(flag)
end
function legendTeamCtrl:reqTeamInitData()
	print("legendTeamCtrl:reqTeamInitData")
	self.myTeamInfo:reqTeamInitData()
end
function legendTeamCtrl:getTeamLeaderKickCD()
	return self.myTeamInfo:getTeamLeaderKickCD()
end
function legendTeamCtrl:reqTeamAddCommander(uid)
	print("legendTeamCtrl:reqTeamAddCommander")
	self.myTeamInfo:reqTeamAddCommander(uid)
end
function legendTeamCtrl:reqTeamDelCommander(uid)
	print("legendTeamCtrl:reqTeamDelCommander", uid)
	self.myTeamInfo:reqTeamDelCommander(uid)
end
function legendTeamCtrl:isHasTeam()
	return self.myTeamInfo:isHasTeam()
end
function legendTeamCtrl:getTeamID()
	return self.myTeamInfo:getTeamID()
end
function legendTeamCtrl:isTeamLeader()
	return self.myTeamInfo:isTeamLeader()
end
function legendTeamCtrl:getCommanders()
	return self.myTeamInfo:getCommanders()
end
function legendTeamCtrl:getCommanderCount()
	return self.myTeamInfo:getCommanderCount()
end
function legendTeamCtrl:isTeamCommander(uid)
	return self.myTeamInfo:isTeamCommander(uid)
end
function legendTeamCtrl:getTeamRemainNum()
	local num = self:getTeamMemberNum()
	return math.max(0, legendTeamDef.TEAM_MEMBER_MAX - num)
end
function legendTeamCtrl:getTeamMemberNum()
	local count = 0
	local memberList = self.myTeamInfo:getTeamMemberListRaw()
	local commanders = self.myTeamInfo:getCommanders()
	for uidStr, _ in pairs(memberList) do
		if not commanders or not commanders[uidStr] then
			count = count + 1
		end
	end
	return count
end
function legendTeamCtrl:getMyTeamInfo()
	return self.myTeamInfo
end
function legendTeamCtrl:getTeamMemberList()
	return self.myTeamInfo:getTeamMemberList()
end
function legendTeamCtrl:getTeamMemberInfo(uid)
	if not self.myTeamInfo:getTeamMemberList() then
		_ENV = self.myTeamInfo:getTeamMemberList()
	end
	for _, v in ipairs((self.myTeamInfo:getTeamMemberList())) do
		if v.uid == uid then
			return v
		end
	end
end
function legendTeamCtrl:isTeamHasApproval()
	return self.myTeamInfo and self.myTeamInfo:isTeamHasApproval()
end
function legendTeamCtrl:getTeamFlag()
	return self.myTeamInfo:getTeamFlag() or 1
end
function legendTeamCtrl:getTeamNameRaw()
	return self.myTeamInfo:getTeamNameRaw()
end
function legendTeamCtrl:getTeamAbbr()
	return self.myTeamInfo:getTeamAbbr()
end
function legendTeamCtrl:ctor(properties)
	legendTeamCtrl.super.ctor(self, properties)
end
function legendTeamCtrl:EnterGame()
	self:resetData()
end
function legendTeamCtrl:resetData()
	self.playerInfo, _UPVALUE0_ = nil, nil
	self:initMyTeam()
end
function legendTeamCtrl:Logout()
	legendTeamCtrl.super.Logout(self)
	self:resetData()
end
function legendTeamCtrl:getInvitedInfo()
	return self.myTeamInfo:getInvitedInfo()
end
function legendTeamCtrl:isHasInvitedInfo()
	return self.myTeamInfo:isHasInvitedInfo()
end
function legendTeamCtrl:setMyTeamInfo(data)
	self.myTeamInfo = data
end
function legendTeamCtrl:initClientData(data)
	print("legendTeamCtrl:initClientData")
	if self:updateMyTeam() then
		self.myTeamInfo:reqTeamInitData()
	end
end
function legendTeamCtrl:initMyTeam()
	local teamCtrl = gametop.playertop_:getModule("teamCtrl")
	local team = teamCtrl:getTeamLgend()
	self:setMyTeamInfo(team)
end
function legendTeamCtrl:updateMyTeam()
	print("legendTeamCtrl:updateMyTeam")
	local teamDef = include("teamDef")
	local teamAreaEnum = teamDef.teamAreaEnum
	local areaType, isOpen
	do
		local legendLordWarCtrl = gametop.playertop_:getModule("legendLordWarCtrl")
		if legendLordWarCtrl:isLegendLordTeamOpen() then
			areaType = teamAreaEnum.LEGEND_LORD
			isOpen = true
		else
			local hegemonCtrl = gametop.playertop_:getModule("hegemonCtrl")
			if hegemonCtrl:isHegemonTeamOpen() then
				local activityID = hegemonCtrl:getJoinActivity()
				if activityID then
					areaType = teamAreaEnum.LEGEND_HEGEMON_1 + activityID - gActivityTimeActivityID.LEGEND_HEGEMON_1
					isOpen = true
				else
				end
			end
		end
	end
	if self.myTeamInfo then
		print(areaType, "areaType")
		if areaType then
			local oldType = self.myTeamInfo:getTeamType()
			if oldType ~= areaType then
				local teamCtrl = gametop.playertop_:getModule("teamCtrl")
				local team = teamCtrl:getTeamData(areaType)
				self:setMyTeamInfo(team)
				self.myTeamInfo:resetData()
				_ENV = self.myTeamInfo
				self.myTeamInfo.msg = "MESSAGE_UI_LEGEND_TEAM_MY_INFO"
				SoraDSendMessage(self.myTeamInfo)
				_ENV = self.myTeamInfo
				self.myTeamInfo.msg = "MESSAGE_SERVER_LEGEND_TEAM_INVITED_INFO"
				SoraDSendMessage(self.myTeamInfo)
			end
		else
			self.myTeamInfo:resetData()
			_ENV = self.myTeamInfo
			self.myTeamInfo.msg = "MESSAGE_UI_LEGEND_TEAM_MY_INFO"
			SoraDSendMessage(self.myTeamInfo)
			_ENV = self.myTeamInfo
			self.myTeamInfo.msg = "MESSAGE_SERVER_LEGEND_TEAM_INVITED_INFO"
			SoraDSendMessage(self.myTeamInfo)
		end
	end
	return isOpen
end
function legendTeamCtrl:getTeamType()
	return self.myTeamInfo:getTeamType()
end
function legendTeamCtrl:isPrepareStatus()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local status = activityShowCtrl:getStateByID(gActivityTimeActivityID.LEGEND_LORD)
	if status == gActivityState.PREPARE then
		local param = activityShowCtrl:getParamByID(gActivityTimeActivityID.LEGEND_LORD)
		if param.curState == ACTIVITY_STATE.PREPARE then
			return true
		end
	end
	return false
end
return legendTeamCtrl

local gamemodulec = include("GameModule")
local kingStarTeamCtrl = class("kingStarTeamCtrl", gamemodulec)
local gametop = gModuleMgr.getObject("gametop")
local serverproxy = gModuleMgr.getObject("serverproxy")
local legendTeamDef = include("legendTeamDef")
function kingStarTeamCtrl:reqCreateTeam(name, abbr, flag)
	print("kingStarTeamCtrl:reqCreateTeam", name, abbr, flag)
	_ENV = print
	print.name = name
	print.abbr = abbr
	local print.flag, areaData = flag or 1, print
	self.myTeamInfo:reqTeamCreate(areaData)
end
function kingStarTeamCtrl:reqCheckName(name)
	print("kingStarTeamCtrl:reqCheckName", name)
	local legendTeamUtil = include("legendTeamUtil")
	local err = legendTeamUtil.checkTeamName(name, true)
	if err == gErrDef.Err_None then
		_ENV = nil
		;(nil).name = name
		serverproxy:Request(gCmd.CMD_RUINS_WAR_MODULE, gCmd.CMD_RUINS_WAR_CHECK_NAME, nil)
	end
	return err
end
function kingStarTeamCtrl:reqGetTeamList(kid, aid, name)
	print("kingStarTeamCtrl:reqGetTeamList")
	self.myTeamInfo:reqTeamSearch(kid, aid, name)
end
function kingStarTeamCtrl:reqGetUserList(kid, name)
	print("kingStarTeamCtrl:reqGetUserList")
	self.myTeamInfo:reqTeamSearchUser(kid, name)
end
function kingStarTeamCtrl:reqGetAllianceList(isFilter)
	print("kingStarTeamCtrl:reqGetAllianceList")
	self.myTeamInfo:reqTeamSearchAlliance(isFilter)
end
function kingStarTeamCtrl:reqGetFriendList(isFilter)
	print("kingStarTeamCtrl:reqGetFriendList")
	self.myTeamInfo:reqTeamSearchFriend(isFilter)
end
function kingStarTeamCtrl:reqApplyJoin(teamId)
	print("kingStarTeamCtrl:reqApplyJoin", teamId)
	self.myTeamInfo:reqTeamApplyJoin(teamId)
end
function kingStarTeamCtrl:reqAgreeApplyJoin(uid)
	print("kingStarTeamCtrl:reqAgreeApplyJoin", uid)
	self.myTeamInfo:reqTeamAgreeApply(uid)
end
function kingStarTeamCtrl:reqDismissTeam()
	print("kingStarTeamCtrl:reqDismissTeam")
	self.myTeamInfo:reqTeamDismiss()
end
function kingStarTeamCtrl:reqExpelMember(uid)
	print("kingStarTeamCtrl:reqExpelMember", uid)
	self.myTeamInfo:reqTeamKick(uid)
end
function kingStarTeamCtrl:reqQuitTeam()
	print("kingStarTeamCtrl:reqQuitTeam")
	self.myTeamInfo:reqTeamQuit()
end
function kingStarTeamCtrl:reqDemiseTeam(uid)
	print("kingStarTeamCtrl:reqDemiseTeam", uid)
	self.myTeamInfo:reqTeamTransferLeader(uid)
end
function kingStarTeamCtrl:reqInviteJoinTeam(uid, kid)
	print("kingStarTeamCtrl:reqInviteJoinTeam", uid, kid)
	self.myTeamInfo:reqTeamInviteJoin(uid, kid)
end
function kingStarTeamCtrl:reqAgreeInviteJoin(teamId)
	print("kingStarTeamCtrl:reqAgreeInviteJoin", teamId)
	self.myTeamInfo:reqTeamAgreeInvite(teamId)
end
function kingStarTeamCtrl:reqRejectInviteJoin(teamId)
	print("kingStarTeamCtrl:reqRejectInviteJoin", teamId)
	self.myTeamInfo:reqTeamRejectInvite(teamId)
end
function kingStarTeamCtrl:reqGetTeamInfo(teamId)
	print("kingStarTeamCtrl:reqGetTeamInfo", teamId)
	self.myTeamInfo:reqTeamGetTeamInfo(teamId)
end
function kingStarTeamCtrl:reqGetMemberInfo()
	print("kingStarTeamCtrl:reqGetMemberInfo")
	self.myTeamInfo:reqTeamGetTeamMemberInfo()
end
function kingStarTeamCtrl:reqGetApplyList()
	print("kingStarTeamCtrl:reqGetApplyList")
	self.myTeamInfo:reqTeamGetTeamApplyInfo()
end
function kingStarTeamCtrl:reqTeamSetName(name)
	print("kingStarTeamCtrl:reqTeamSetName", name)
	self.myTeamInfo:reqTeamSetName(name)
end
function kingStarTeamCtrl:reqTeamSetAbbr(abbr)
	print("kingStarTeamCtrl:reqTeamSetAbbr", abbr)
	self.myTeamInfo:reqTeamSetAbbr(abbr)
end
function kingStarTeamCtrl:reqTeamSetFlag(flag)
	print("kingStarTeamCtrl:reqTeamSetFlag", flag)
	self.myTeamInfo:reqTeamSetFlag(flag)
end
function kingStarTeamCtrl:reqTeamInitData()
	print("kingStarTeamCtrl:reqTeamInitData")
	self.myTeamInfo:reqTeamInitData()
end
function kingStarTeamCtrl:isHasTeam()
	return self.myTeamInfo:isHasTeam()
end
function kingStarTeamCtrl:getTeamID()
	return self.myTeamInfo:getTeamID()
end
function kingStarTeamCtrl:isTeamLeader()
	return self.myTeamInfo:isTeamLeader()
end
function kingStarTeamCtrl:getTeamRemainNum()
	local num = self:getTeamMemberNum()
	return math.max(0, legendTeamDef.TEAM_MEMBER_MAX - num)
end
function kingStarTeamCtrl:getTeamMemberNum()
	return self.myTeamInfo:getTeamMemberNum()
end
function kingStarTeamCtrl:getMyTeamInfo()
	return self.myTeamInfo
end
function kingStarTeamCtrl:getTeamMemberList()
	return self.myTeamInfo:getTeamMemberList()
end
function kingStarTeamCtrl:isTeamHasApproval()
	return self.myTeamInfo and self.myTeamInfo:isTeamHasApproval()
end
function kingStarTeamCtrl:getTeamFlag()
	return self.myTeamInfo:getTeamFlag() or 1
end
function kingStarTeamCtrl:getTeamNameRaw()
	return self.myTeamInfo:getTeamNameRaw()
end
function kingStarTeamCtrl:getTeamAbbr()
	return self.myTeamInfo:getTeamAbbr()
end
function kingStarTeamCtrl:ctor(properties)
	kingStarTeamCtrl.super.ctor(self, properties)
end
function kingStarTeamCtrl:EnterGame()
	self:resetData()
end
function kingStarTeamCtrl:resetData()
	self:initMyTeam()
end
function kingStarTeamCtrl:Logout()
	kingStarTeamCtrl.super.Logout(self)
	self:resetData()
end
function kingStarTeamCtrl:getInvitedInfo()
	return self.myTeamInfo:getInvitedInfo()
end
function kingStarTeamCtrl:isHasInvitedInfo()
	return self.myTeamInfo:isHasInvitedInfo()
end
function kingStarTeamCtrl:setMyTeamInfo(data)
	self.myTeamInfo = data
end
function kingStarTeamCtrl:initClientData(data)
	print("kingStarTeamCtrl:initClientData")
	if self:updateMyTeam() then
		self.myTeamInfo:reqTeamInitData()
	end
end
function kingStarTeamCtrl:initMyTeam()
	local teamCtrl = gametop.playertop_:getModule("teamCtrl")
	local team = teamCtrl:getTeamKingStar()
	self:setMyTeamInfo(team)
end
function kingStarTeamCtrl:getLegendLordTeamOpenKingdomID()
	_ENV = nil
	;(nil)[1] = worldMapDefine.KINGSTAR_KINGDOM_ID
	;(nil)[2] = worldMapDefine.KINGSTAR_KINGDOM_ID_9001646
	local (nil)[3], cfg = worldMapDefine.KINGSTAR_KINGDOM_ID_9001647, nil
	local legendLordWarCtrl = SoraDGetCtrl("legendLordWarCtrl")
	for _, v in ipairs(cfg) do
		if legendLordWarCtrl:isLegendLordTeamOpen(v) or legendLordWarCtrl:isLegendLordActivityOpen(v) or legendLordWarCtrl:isLegendLordActivityOpenOrSetTitle(v) then
			return v
		end
	end
	return worldMapDefine.KINGSTAR_KINGDOM_ID
end
function kingStarTeamCtrl:updateMyTeam()
	print("kingStarTeamCtrl:updateMyTeam")
	local teamDef = include("teamDef")
	local teamAreaEnum = teamDef.teamAreaEnum
	local areaType, isOpen
	_ENV, _ENV = nil, nil
	;(nil).id = worldMapDefine.KINGSTAR_KINGDOM_ID
	_ENV, (nil)[1], (nil).teamType = nil, nil, teamAreaEnum.LEGEND_LORD_FOR_SEP
	;(nil).id = worldMapDefine.KINGSTAR_KINGDOM_ID_9001646
	_ENV, (nil)[2], (nil).teamType = nil, nil, teamAreaEnum.LEGEND_LORD_9001646
	;(nil).id = worldMapDefine.KINGSTAR_KINGDOM_ID_9001647
	;(nil)[3], (nil).teamType = nil, teamAreaEnum.LEGEND_LORD_9001647
	local kidToTeamTypeCfg
	do
		local legendLordWarCtrl = gametop.playertop_:getModule("legendLordWarCtrl")
		for _, v in ipairs(kidToTeamTypeCfg) do
			if legendLordWarCtrl:isLegendLordTeamOpen(v.id) then
				areaType = v.teamType
				isOpen = true
				break
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
function kingStarTeamCtrl:getTeamType()
	return self.myTeamInfo:getTeamType()
end
return kingStarTeamCtrl

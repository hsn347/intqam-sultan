local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local nebulaWarUtil = include("nebulaWarUtil")
local teamDef = include("teamDef")
local baseProxy = require("fgui.base.baseProxy")
local NebulaWarTeamJoinProxy = class("NebulaWarTeamJoinProxy", baseProxy)
function NebulaWarTeamJoinProxy:onRegisterEvent()
	print("=======NebulaWarTeamJoinProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_TEAM_CREATE_BACk", handler(self, self.onMsgTeamCreateBack))
	SoraDAddMessage(self, "MESSAGE_NEBULA_TEAM_LIST_BACK", handler(self, self.onMsgTeamListBack))
	SoraDAddMessage(self, "MESSAGE_NEBULA_TEAM_INFO_NOTIFY", handler(self, self.onMsgTeamInfoNotify))
	SoraDAddMessage(self, "MESSAGE_NEBULA_TEAM_BEINVITE_BACK", handler(self, self.onMsgBeInviteBack))
	SoraDAddMessage(self, "MESSAGE_NEBULA_TEAM_APPLY_JOIN_BACK", handler(self, self.onMsgApplyJoinBack))
	SoraDAddMessage(self, "MESSAGE_NEBULAWAR_REFRESH_DATA", handler(self, self.onMsgStateChange))
end
function NebulaWarTeamJoinProxy:onMsgTeamCreateBack(target, event)
	if event.err == gErrDef.Err_None then
		self:refreshMyTeamInfo()
	end
end
function NebulaWarTeamJoinProxy:onMsgTeamListBack(target, event)
	SoraDCloseLoading(self.view:displayObject())
	if not event.data then
		local _ENV, data = event.data, event.data
	end
	local checkCamp = true
	if data.kid then
		checkCamp = false
	end
	local _ENV, teamList = data.kid, data.kid
	if not event.teamList then
		_ENV = event.teamList
	end
	for i, team in ipairs(event.teamList) do
		local memberCount = table.nums(team.memberList)
		if not checkCamp or nebulaWarUtil.checkTeamInSameCamp(team.kid) then
			team.memberCount = memberCount
			team.totalFc = teamDef.getTeamTotalFc(team)
			team.isSuperTeam = teamDef.getIsSuperTeam(team)
			table.insert(teamList, team)
		end
	end
	table.sort(teamList, function(a, b)
		if a.isSuperTeam ~= b.isSuperTeam then
			return a.isSuperTeam
		end
		if a.totalFc ~= b.totalFc then
			return a.totalFc > b.totalFc
		end
		return a.tid < b.tid
	end)
	self.view:refreshTeamList(teamList)
end
function NebulaWarTeamJoinProxy:onMsgTeamInfoNotify(target, event)
	if event.teamType and event.teamType ~= self.view.teamType then
		return
	end
	local justLook = self.param and self.param.justLook
	if justLook then
		return
	end
	local notifyType = event.notifyType
	if notifyType == "INVITE_JOIN" then
		self.view:refreshBeInviteBtn()
	else
		self:refreshMyTeamInfo()
	end
end
function NebulaWarTeamJoinProxy:onMsgBeInviteBack(target, event)
	local myTeamInfo = nebulaActivityCtrl:getMyTeamInfo()
	if myTeamInfo:isHasTeam() then
		uiManager:show("NebulaWarTeam")
		self:removeView(self.view)
	else
		self.view:refreshBeInviteBtn()
	end
end
function NebulaWarTeamJoinProxy:refreshMyTeamInfo(...)
	local myTeamInfo = nebulaActivityCtrl:getMyTeamInfo()
	if myTeamInfo:isHasTeam() then
		SoraDRemoveAllAfterPanelFromManager(self.view)
		uiManager:show("NebulaWarTeam")
	end
end
function NebulaWarTeamJoinProxy:onMsgApplyJoinBack(target, event)
	local err = event.err
	if err == gErrDef.Err_NOT_FOUND_TEAM or err == gErrDef.Err_TEAM_MEMBER_FULL then
		self.view:req4Data()
	elseif err == gErrDef.Err_NEBULA_NOT_SAME_CAMP_KINDOM then
		SoraDShowMsgTip(i18n("nebula_war_text_0054"))
	end
end
function NebulaWarTeamJoinProxy:onMsgStateChange(...)
	self.view:updateState()
end
return NebulaWarTeamJoinProxy

local baseProxy = require("fgui.base.baseProxy")
local NebulaWarTeamInviteProxy = class("NebulaWarTeamInviteProxy", baseProxy)
function NebulaWarTeamInviteProxy:onRegisterEvent()
	print("=======NebulaWarTeamInviteProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_TEAM_INVITE_LIST_BACK", handler(self, self.onMsgInviteListBack))
	SoraDAddMessage(self, "MESSAGE_NEBULA_TEAM_INFO_NOTIFY", handler(self, self.onMsgTeamInfoNotify))
	SoraDAddMessage(self, "MESSAGE_NEBULA_TEAM_INVITE_JOIN_BACK", handler(self, self.onMsgInviteJoinBack))
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_INVITED_USERS", handler(self, self.onMsgUpdateInvitedUsers))
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_REFRESH_DATA", handler(self, self.onMsgRefreshData))
end
function NebulaWarTeamInviteProxy:onMsgInviteListBack(target, event)
	SoraDCloseLoading(self.view:displayObject())
	if not event.memberList then
		local _ENV, memberList = event.memberList, event.memberList
	end
	local teamAreaEnum = include("teamDef").teamAreaEnum
	if self.view.teamType == teamAreaEnum.NEBULA_ALL_STAR then
		local nebulaWarUtil = include("nebulaWarUtil")
		local _ENV, ret = "nebulaWarUtil", "nebulaWarUtil"
		for i, v in ipairs(memberList) do
			if nebulaWarUtil.checkKingdomInSameCamp(v.kid) then
				table.insert(ret, v)
			end
		end
		memberList = ret
		if #memberList == 0 then
			SoraDShowMsgTip(i18n("NebulaAllstar_81"))
		end
	end
	table.sort(memberList, function(a, b)
		if a.totalFc ~= b.totalFc then
			return a.totalFc > b.totalFc
		end
		return a.uid < b.uid
	end)
	self.view:refreshMemberList(memberList)
end
function NebulaWarTeamInviteProxy:onMsgTeamInfoNotify(target, event)
	if event.teamType and event.teamType ~= self.view.teamType then
		return
	end
	local notifyType = event.notifyType
	_UPVALUE0_ = self.view.teamType
	self.view.teamType.JOIN = true
	local self.view.teamType.QUIT, config = true, self.view.teamType
	if config[notifyType] then
		self.view:refreshTextRemain()
	end
end
function NebulaWarTeamInviteProxy:onMsgInviteJoinBack(target, event)
	self.view:onMsgInviteJoinBack(target, event)
end
function NebulaWarTeamInviteProxy:onMsgUpdateInvitedUsers(...)
	self.view:onMsgUpdateInvitedUsers(...)
end
function NebulaWarTeamInviteProxy:onMsgRefreshData(...)
	local teamAreaEnum = include("teamDef").teamAreaEnum
	if self.view.teamType ~= teamAreaEnum.NEBULA_ALL_STAR then
		return
	end
	local nebulaAllStarUtil = include("nebulaAllStarUtil")
	if not nebulaAllStarUtil.checkQuitTeamState() then
		SoraDRemoveAllAfterPanelFromManager(self.view)
		return
	end
end
return NebulaWarTeamInviteProxy

local gametop = gModuleMgr.getObject("gametop")
local teamCtrl = gametop.playertop_:getModule("teamCtrl")
local teamDef = include("teamDef")
local teamDataBase = class("teamDataBase")
function teamDataBase:ctor(teamType)
	self._teamType = teamType
	self:resetData()
end
function teamDataBase:getTeamType()
	return self._teamType
end
function teamDataBase:resetData()
	self.tid = 0
	self.name = ""
	self.abbr = nil
	self.leader = 0
	self.inviteList, _UPVALUE0_, self.setting, _UPVALUE0_, self.memberList, _UPVALUE0_, self.chatChannelID = nil, nil, nil, nil, nil, nil, 0
	self.hasApplyUsers = false
	self.hasNewTeamMsg = false
	self.lastTeamMsgTime = 0
end
function teamDataBase:setMyTeamInfo(data)
	self:resetData()
	local _ENV, teamInfo = self.resetData, data or self.resetData
	for k, v in pairs(teamInfo) do
		self[k] = v
	end
end
function teamDataBase:setInvitedInfo(data)

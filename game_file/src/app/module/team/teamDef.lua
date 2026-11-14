local _ENV, _ENV, teamDef
;(nil).RUINS = 1
;(nil).LEGEND_LORD = 2
;(nil).LEGEND_HEGEMON_1 = 3
;(nil).LEGEND_HEGEMON_2 = 4
;(nil).LEGEND_HEGEMON_3 = 5
;(nil).LEGEND_HEGEMON_4 = 6
;(nil).LEGEND_HEGEMON_5 = 7
;(nil).LEGEND_HEGEMON_6 = 8
;(nil).NEBULA_WAR = 9
;(nil).LEGEND_LORD_FOR_SEP = 10
;(nil).NEBULA_EMPEROR = 12
;(nil).NEBULA_ALL_STAR = 13
;(nil).MERGE_SERVER_SHOW = 14
;(nil).LEGEND_LORD_9001646 = 15
;(nil).LEGEND_LORD_9001647 = 16
;(nil).KOH_MIGRATE = 101
;(nil).ACTIVITY_9001657 = 102
;(nil).ACTIVITY_9001725 = 103
_ENV, teamDef.teamAreaEnum, (nil).ACTIVITY_9001731 = nil, nil, 104
;(nil).DISMISS = "DISMISS"
;(nil).UPDATE_NAME = "UPDATE_NAME"
;(nil).UPDATE_ABBR = "UPDATE_ABBR"
;(nil).UPDATE_SETTING = "UPDATE_SETTING"
;(nil).UPDATE_LEADER = "UPDATE_LEADER"
;(nil).JOIN = "JOIN"
;(nil).QUIT = "QUIT"
;(nil).KICK = "KICK"
;(nil).APPLY_JOIN = "APPLY_JOIN"
;(nil).AGREE_APPLY = "AGREE_APPLY"
;(nil).REJECT_APPLY = "REJECT_APPLY"
;(nil).INVITE_JOIN = "INVITE_JOIN"
teamDef.teamPublishMsgType, (nil).UPDATE_EXTRAINFO = nil, "UPDATE_EXTRAINFO"
function teamDef.transMemberList(memberListOld)
	local _ENV, memberList
	if memberListOld then
		for k, v in pairs(memberListOld) do
			local member = v
			if member then
				member.uid = tonumber(k)
				member.headid = member.headid or member.iconID
				table.insert(memberList, member)
			end
		end
	end
	return memberList
end
function teamDef.getTeamName(team)
	local name = team.name
	local player = team.memberList[tostring(team.leader)]
	if player then
		name = player.nickName
		local leagueAbbrName = player.allianceAbbr
		if leagueAbbrName then
			_ENV = nil
			;(nil).abbr = leagueAbbrName
			;(nil).name = player.nickName
			name = i18n("common_text_186", nil)
		end
	end
	_ENV = "common_text_186"
	;("common_text_186").name = name
	return i18n("common_text_119", "common_text_186")
end
function teamDef.getTeamName_Legend(team)
	local name = team.name
	local leagueAbbrName = team.abbr
	if leagueAbbrName then
		_ENV = nil
		;(nil).abbr = leagueAbbrName
		;(nil).name = name
		name = i18n("common_text_186", nil)
	end
	return name
end
function teamDef.getTeamLeaderName(team)
	local player = team.memberList[tostring(team.leader)]
	if player then
		return player.nickName
	end
	return team.name
end
function teamDef.getTeamLeaderKid(team)
	local player = team.memberList[tostring(team.leader)]
	if player then
		return player.kid
	end
end
function teamDef.getTeamTotalFc(team)
	local totalFc = 0
	for k, v in pairs(team.memberList) do
		totalFc = totalFc + v.totalFc
	end
	return totalFc
end
function teamDef.namkVailidCheck(nickName, data)
	local __err
	if nickName then
		if not data then
			data, _ENV = nil, nil
		end
		local lenMax = data.lenMax or 15
		local lenMin = data.lenMin or 1
		if lenMax < string.utf8len(nickName) then
			__err = gErrDef.Err_NICKNAME
		elseif lenMin > string.utf8len(nickName) then
			__err = gErrDef.Err_NICKNAME_MIN_SIZE
		elseif string.sub(nickName, 1, 1) == "(" then
			__err = gErrDef.Err_NICKNAME_BRACKET
		elseif string.match(nickName, "$SoarDragon&") then
			__err = gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER
		elseif string.match(nickName, "[%%%*%^%$%[%]%*%+%-%?#&]+") then
			__err = gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER
		elseif string.match(nickName, "\n") then
			__err = gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER
		elseif string.match(nickName, "\r") then
			__err = gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER
		elseif string.match(nickName, " ") then
			__err = gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER
		else
			__err = gErrDef.Err_None
			return true, __err
		end
	else
		__err = gErrDef.Err_NICKNAME
	end
	return false, __err
end
function teamDef.getTeamName_Nebula(abbr)
	if teamDef.checkIsSuperTeamAbbr(abbr) then
		local teamName = teamDef.getSuperTeamNameRaw(abbr)
		teamDef = nil
		;(nil).abbr = abbr
		;(nil).name = teamName
		return i18n("common_text_186", nil)
	end
end
function teamDef.checkIsSuperTeamAbbr(abbr)
	if abbr and string.len(abbr) == 2 then
		return true
	else
		return false
	end
end
function teamDef.getSuperTeamNameRaw(abbr)
	if teamDef.checkIsSuperTeamAbbr(abbr) then
		local nebulaWarRead = include("nebulaWarRead")
		local campAbbr = string.sub(abbr, 1, 1)
		local index = tonumber(string.sub(abbr, 2, 2))
		local campType = nebulaWarRead.getWarCampType(campAbbr)
		local campName = nebulaWarRead.getWarCampName(campType)
		teamDef = string.sub(abbr, 2, 2)
		string.sub(abbr, 2, 2).camp = campName
		local teamName = i18n("nebula_war_text_0368", string.sub(abbr, 2, 2)) .. index
		return teamName
	end
end
function teamDef.getIsSuperTeam(team)
	return team.setting and team.setting.isSuperTeam or false
end
function teamDef.getTeamTotalFcLock(team)
	return team.setting and team.setting.totalFc or 0
end
function teamDef.isTeamLeader(team, uid)
	return team.leader and team.leader == uid
end
function teamDef.isTeamCommander(team, uid)
	if not team.setting or not team.setting.commanders then
		local _ENV, commanders = team.setting.commanders, team.setting.commanders
	end
	return commanders[tostring(uid)] == 1
end
function teamDef.getLeaderCommanderList(team)
	local _ENV, ret
	local memberList = team.memberList
	local player = memberList[tostring(team.leader)]
	if player then
		player.uid = tonumber(team.leader)
		table.insert(ret, player)
	end
	if not team.setting or not team.setting.commanders then
		local _ENV, commanders = team.setting.commanders, team.setting.commanders
	end
	local _ENV, tempList = ret, ret
	for k, __ in pairs(commanders) do
		local player = memberList[tostring(k)]
		if player then
			player.uid = tonumber(k)
			table.insert(tempList, player)
		end
	end
	table.sort(tempList, function(a, b)
		if a.totalFc ~= b.totalFc then
			return a.totalFc > b.totalFc
		end
		return a.uid < b.uid
	end)
	for __, v in ipairs(tempList) do
		table.insert(ret, v)
	end
	return ret
end
return teamDef

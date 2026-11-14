local legendTeamDef = include("legendTeamDef")
local _ENV, legendTeamUtil = "legendTeamDef", "legendTeamDef"
local gametop = gModuleMgr.getObject("gametop")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local legendTeamCtrl = gametop.playertop_:getModule("legendTeamCtrl")
local kingStarTeamCtrl = gametop.playertop_:getModule("kingStarTeamCtrl")
local legendLordWarCtrl = gametop.playertop_:getModule("legendLordWarCtrl")
local hegemonCtrl = gametop.playertop_:getModule("hegemonCtrl")
_ENV = gametop.playertop_
gametop.playertop_.NONE = 1
gametop.playertop_.TIPS = 2
gametop.playertop_.REFRESH = 3
legendTeamUtil.errType, gametop.playertop_.CLOSE = gametop.playertop_, 4
local errType = legendTeamUtil.errType
_ENV = "hegemonCtrl"
;("hegemonCtrl")[gErrDef.Err_RUINS_WAR_CASTLE_LV_NOT_ENOUGH] = errType.TIPS
;("hegemonCtrl")[gErrDef.Err_CASTLE_LEVEL_IS_NOT_REACHED] = errType.TIPS
;("hegemonCtrl")[gErrDef.Err_RUINS_WAR_TEAM_NAME_ILLEGAL] = errType.TIPS
;("hegemonCtrl")[gErrDef.Err_RUINS_WAR_TEAM_NAME_HAVE] = errType.TIPS
;("hegemonCtrl")[gErrDef.Err_RUINS_WAR_TEAM_NOT_FOUND] = errType.CLOSE
;("hegemonCtrl")[gErrDef.Err_RUINS_WAR_FULL_TEAM] = errType.CLOSE
;("hegemonCtrl")[gErrDef.Err_RUINS_WAR_TEAM_STATE_ERR] = errType.CLOSE
;("hegemonCtrl")[gErrDef.Err_RUINS_WAR_PLAYER_NOT_IN_TEAM] = errType.CLOSE
;("hegemonCtrl")[gErrDef.Err_RUINS_WAR_NOT_TEAM_LEADER] = errType.CLOSE
;("hegemonCtrl")[gErrDef.Err_RUINS_WAR_HAVE_TEAM] = errType.CLOSE
;("hegemonCtrl")[gErrDef.Err_RUINS_WAR_IS_TEAM_LEADER] = errType.TIPS
;("hegemonCtrl")[gErrDef.Err_RUINS_WAR_PLAYER_IS_IN_TEAM] = errType.TIPS
;("hegemonCtrl")[gErrDef.Err_RUINS_WAR_HAS_INVITE] = errType.REFRESH
;("hegemonCtrl")[gErrDef.Err_RUINS_WAR_MEMBER_NOT_ENOUGH] = errType.TIPS
;("hegemonCtrl")[gErrDef.Err_RUINS_WAR_PLAYER_NOT_APPLY] = errType.REFRESH
;("hegemonCtrl")[gErrDef.Err_RUINS_WAR_TEAM_NAME_LENGTH] = errType.TIPS
;("hegemonCtrl")[gErrDef.Err_ACTIVITY_NOT_START] = errType.TIPS
;("hegemonCtrl")[gErrDef.Err_NOT_FOUND_TEAM] = errType.CLOSE
;("hegemonCtrl")[gErrDef.Err_IN_TEAM] = errType.REFRESH
;("hegemonCtrl")[gErrDef.Err_NOT_IN_TEAM] = errType.TIPS
;("hegemonCtrl")[gErrDef.Err_TEAM_ALREADY_IS_MEMBER] = errType.CLOSE
;("hegemonCtrl")[gErrDef.Err_TEAM_MEMBER_FULL] = errType.CLOSE
;("hegemonCtrl")[gErrDef.Err_TEAM_LOCK] = errType.CLOSE
;("hegemonCtrl")[gErrDef.Err_TEAM_APPLY_INVALID] = errType.REFRESH
;("hegemonCtrl")[gErrDef.Err_TEAM_REPEAT_APPLY] = errType.CLOSE
;("hegemonCtrl")[gErrDef.Err_TEAM_INVITE_INVALID] = errType.CLOSE
;("hegemonCtrl")[gErrDef.Err_TEAM_REPEAT_INVITE] = errType.TIPS
;("hegemonCtrl")[gErrDef.Err_TEAM_NOT_IN_SELF_KID] = errType.TIPS
;("hegemonCtrl")[gErrDef.Err_TEAM_TARGET_NOT_IN_SELF_KID] = errType.TIPS
;("hegemonCtrl")[gErrDef.Err_TEAM_KINGDOM_NOT_JOIN_ACT] = errType.TIPS
local ("hegemonCtrl")[gErrDef.Err_TEAM_NOT_SAME_HEGMON_STATUE], codeConfig = errType.REFRESH, "hegemonCtrl"
function legendTeamUtil.getErrType(err)
	local et = codeConfig[err] or errType.NONE
	return et
end
function legendTeamUtil.checkTeamName(teamName)
	local err = gErrDef.Err_None
	if teamName == nil or string.utf8len(teamName) < 3 then
		err = gErrDef.Err_RUINS_WAR_TEAM_NAME_LENGTH
	else
	end
	return err
end
function legendTeamUtil.checkTeamBase(mapid)
	local err = gErrDef.Err_None
	do
		local castle_limited
		local isLegendJoinActivity = false
		if worldMapDefine.isKingStarMapId(mapid) then
			if kingStarTeamCtrl:isHasTeam() then
				err = gErrDef.Err_RUINS_WAR_HAVE_TEAM
			else
				isLegendJoinActivity = legendLordWarCtrl:isLegendLordTeamOpen(mapid)
				elseif legendTeamCtrl:isHasTeam() then
					err = gErrDef.Err_RUINS_WAR_HAVE_TEAM
				else
					isLegendJoinActivity = legendLordWarCtrl:isLegendLordTeamOpen()
					if isLegendJoinActivity then
						local constantRead = include("constantRead")
						castle_limited = constantRead.getConstValue("LEGEND_LORD_WAR_LV_LIMIT", _G.CASTLE_LV50_LIMITED)
					else
						local isHegemonJoinActivity = hegemonCtrl:isHegemonTeamOpen()
						if isHegemonJoinActivity then
							castle_limited = _G.CASTLE_LV30_LIMITED
						else
							err = gErrDef.Err_ACTIVITY_NOT_START
							goto lbl_72
						end
					end
					if castle_limited then
						local buiLevel = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
						if castle_limited > buiLevel then
							err = gErrDef.Err_RUINS_WAR_CASTLE_LV_NOT_ENOUGH
						else
						end
					end
				end
			end
	end
	::lbl_72::
	return err
end
function legendTeamUtil.checkCreateTeam(mapid)
	local err
	err = legendTeamUtil.checkTeamBase(mapid)
	if err == gErrDef.Err_None then
	end
	return err
end
function legendTeamUtil.checkJoinTeam(teamData, mapid)
	local err
	err = legendTeamUtil.checkTeamBase(mapid)
	if err == gErrDef.Err_None then
		local count = legendTeamUtil.getTeamMemberNum(teamData)
		if count >= legendTeamDef.TEAM_MEMBER_MAX then
			err = gErrDef.Err_RUINS_WAR_FULL_TEAM
		else
		end
	end
	return err
end
function legendTeamUtil.checkInviteJoin(mapid)
	local err
	err = legendTeamUtil.checkTeamBase(mapid)
	if err == gErrDef.Err_None then
	end
	return err
end
function legendTeamUtil.checkAgreeInviteTeam(inviteInfo, mapid)
	local err
	err = legendTeamUtil.checkTeamBase(mapid)
	if err == gErrDef.Err_None then
		if worldMapDefine.isInKingdomBattle() then
			err = gErrDef.Err_TEAM_NOT_IN_SELF_KID
		else
			if inviteInfo and inviteInfo.memberCount and inviteInfo.memberCount >= legendTeamDef.TEAM_MEMBER_MAX then
				err = gErrDef.Err_RUINS_WAR_FULL_TEAM
			else
			end
		end
	end
	return err
end
function legendTeamUtil.checkExpelMember(member, mapid)
	local err = gErrDef.Err_None
	if worldMapDefine.isKingStarMapId(mapid) then
		if not kingStarTeamCtrl:isTeamLeader() then
			err = gErrDef.Err_RUINS_WAR_NOT_TEAM_LEADER
		else
		end
		goto lbl_27
	else
		if not legendTeamCtrl:isTeamLeader() then
			err = gErrDef.Err_RUINS_WAR_NOT_TEAM_LEADER
		else
		end
	end
	::lbl_27::
	return err
end
function legendTeamUtil.checkDismissTeam(mapid)
	local err = gErrDef.Err_None
	if worldMapDefine.isKingStarMapId(mapid) then
		if kingStarTeamCtrl:getTeamMemberNum() > 1 then
			err = gErrDef.Err_RUINS_WAR_MEMBER_NOT_ENOUGH
		else
			if not kingStarTeamCtrl:isTeamLeader() then
				err = gErrDef.Err_RUINS_WAR_NOT_TEAM_LEADER
				goto lbl_50
			end
			elseif legendTeamCtrl:getTeamMemberNum() > 1 then
				err = gErrDef.Err_RUINS_WAR_MEMBER_NOT_ENOUGH
			elseif not legendTeamCtrl:isTeamLeader() then
				err = gErrDef.Err_RUINS_WAR_NOT_TEAM_LEADER
			else
				if worldMapDefine.inInCrossWar() then
					err = gErrDef.Err_TEAM_NOT_IN_SELF_KID
				else
				end
			end
		end
	::lbl_50::
	return err
end
function legendTeamUtil.checkQuitTeam(mapid)
	local err = gErrDef.Err_None
	if worldMapDefine.isKingStarMapId(mapid) then
		if kingStarTeamCtrl:isTeamLeader() then
			err = gErrDef.Err_RUINS_WAR_IS_TEAM_LEADER
			goto lbl_34
		end
	else
		if legendTeamCtrl:isTeamLeader() then
			err = gErrDef.Err_RUINS_WAR_IS_TEAM_LEADER
	end
	else
		if worldMapDefine.inInCrossWar() then
			err = gErrDef.Err_TEAM_NOT_IN_SELF_KID
		else
		end
	end
	::lbl_34::
	return err
end
function legendTeamUtil.errShowTips(err)
	if err == gErrDef.Err_None then
		return
	end
	if err == gErrDef.Err_RUINS_WAR_CASTLE_LV_NOT_ENOUGH or err == gErrDef.Err_CASTLE_LEVEL_IS_NOT_REACHED then
		local castle_limited
		local isLegendJoinActivity = legendLordWarCtrl:isLegendLordTeamOpen() or legendLordWarCtrl:isLegendLordTeamOpen(worldMapDefine.KINGSTAR_KINGDOM_ID)
		if isLegendJoinActivity then
			local constantRead = include("constantRead")
			castle_limited = constantRead.getConstValue("LEGEND_LORD_WAR_LV_LIMIT", _G.CASTLE_LV50_LIMITED)
		else
			castle_limited = _G.CASTLE_LV30_LIMITED
		end
		local buildLogic = include("buildLogic")
		local warLv = buildLogic.transformBuildLvToWarLv(castle_limited)
		if 0 < warLv then
			_ENV = nil
			;(nil).lv = warLv
			local lv = i18n("common_text_1948", nil)
			_ENV = nil
			;(nil).num = lv
			SoraDShowMsgTip(i18n("common_text_1795", nil))
		else
			_ENV = i18n("common_text_1795", nil)
			i18n("common_text_1795", nil).num = castle_limited
			SoraDShowMsgTip(i18n("common_text_1795", i18n("common_text_1795", nil)))
		end
	else
		local msgNotice = include("msgNotice")
		local notice_id = msgNotice.getTipCode(err)
		if notice_id then
			local fun = msgNotice.getSpecialFun(notice_id)
			if nil == fun then
				print("notice_id =", err, notice_id)
				_ENV = "notice_id ="
				;("notice_id =").msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
				;("notice_id =").messageID = notice_id
				SoraDSendMessage("notice_id =")
			end
		else
			_ENV = SoraDSendMessage
			SoraDSendMessage.msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			SoraDSendMessage.messageID = err
			SoraDSendMessage(SoraDSendMessage)
		end
	end
end
function legendTeamUtil.openView(mapid)
	if worldMapDefine.isKingStarMapId(mapid) then
		if kingStarTeamCtrl:isHasTeam() then
			local panel = SoraDCreatePanel("kingStarTeamView")
			panel:show()
		else
			local panel = SoraDCreatePanel("kingStarTeamApplyListView")
			local activityID = worldMapDefine.getKingStarActivityID(mapid)
			panel:initActivityID(activityID)
			panel:show()
		end
	elseif legendTeamCtrl:isHasTeam() then
		local panel = SoraDCreatePanel("legendTeamView")
		panel:show()
	else
		local panel = SoraDCreatePanel("legendTeamApplyListView")
		panel:show()
	end
end
function legendTeamUtil.openTeamView(mapid)
	if worldMapDefine.isKingStarMapId(mapid) then
		if kingStarTeamCtrl:isHasTeam() and not SoraDSearchPanelFromManagerByName("kingStarTeamView") then
			local panel = SoraDCreatePanel("kingStarTeamView")
			panel:show()
		end
		return
	end
	if legendTeamCtrl:isHasTeam() and not SoraDSearchPanelFromManagerByName("legendTeamView") then
		local panel = SoraDCreatePanel("legendTeamView")
		panel:show()
	end
end
function legendTeamUtil.openTeamWar(mapid)
	if worldMapDefine.isKingStarMapId(mapid) then
		if kingStarTeamCtrl:isHasTeam() then
			local panel = uiManager:show("AllianceWarView")
			panel.view:setShowTeamTab(worldMapDefine.KINGSTAR_KINGDOM_ID)
		end
		return
	end
	if legendTeamCtrl:isHasTeam() then
		local panel = uiManager:show("AllianceWarView")
		panel.view:setShowTeamTab()
	elseif worldMapDefine.isLegendMapId(gametop.playertop_:getMapID()) then
		SoraDShowMsgTip(i18n("legendary_commander_text32"))
	end
end
function legendTeamUtil.openPreView(teamId, mapid)
	if teamId and 0 < teamId then
		if worldMapDefine.isKingStarMapId(mapid) then
			if kingStarTeamCtrl:isHasTeam() and kingStarTeamCtrl:getTeamID() == teamId then
				local panel = SoraDCreatePanel("kingStarTeamView")
				panel:show()
			else
				local panel = SoraDCreatePanel("kingStarTeamInfo")
				panel:show()
				panel:initData(teamId, mapid)
			end
			return
		end
		if legendTeamCtrl:isHasTeam() and legendTeamCtrl:getTeamID() == teamId then
			local panel = SoraDCreatePanel("legendTeamView")
			panel:show()
		else
			local panel = SoraDCreatePanel("legendTeamInfo")
			panel:show()
			panel:initData(teamId)
		end
	end
end
function legendTeamUtil.openHelp(mapid)
	local isLegendJoinActivity = legendLordWarCtrl:isLegendLordTeamOpen(mapid)
	if isLegendJoinActivity then
		if worldMapDefine.isKingStarMapId(mapid) then
			userSDKManager.showFAQSection(_G.gSDKDef.FAQSectionType.LEGGEND_LORD)
		else
			userSDKManager.showSingleFAQ(_G.gSDKDef.FAQSingleType.KING_STAR_BATTLE)
		end
	elseif IsArClient then
		userSDKManager.showFAQSection(_G.gSDKDef.FAQSectionType.HEGEMON_LORD)
	else
		userSDKManager.showSingleFAQ(_G.gSDKDef.FAQSingleType.HEGEMON_LORD_ROS)
	end
end
function legendTeamUtil.getMemberName(member)
	local name = member.nickName
	local allianceAbbr = member.allianceAbbr
	if allianceAbbr ~= nil and string.len(allianceAbbr) > 0 then
		_ENV = nil
		;(nil).abbr = allianceAbbr
		;(nil).name = member.nickName
		name = i18n("common_text_186", nil)
	end
	if member.kid then
		if worldMapDefine.isLegendLordKingdomID(member.kid) then
			name = name .. "#" .. i18n("common_text_4244")
		else
			name = name .. "#" .. tostring(member.kid)
		end
	end
	return name
end
function legendTeamUtil.checkName(name)
	local __err = gErrDef.Err_None
	name = string.trim(name)
	do
		local length = gConstValue.ALLIANCE_NAME_LENGTH
		local curlen = string.utf8len(name)
		if not (curlen >= length.min) or not (curlen <= length.max) then
			__err = gErrDef.Err_ALLIANCE_CREATE_INPUT_LENS
		else
			do
				local matchFun = function(c)
					if not serviceFunctions.isArAlphabet(c) and not serviceFunctions.isEnAlphabet(c) and not tonumber(c) and " " ~= c then
						return false
					end
					return true
				end
				if not serviceFunctions.isMatchPerfectly(name, matchFun) then
					__err = gErrDef.Err_ALLIANCE_CREATE_INPUT_IIIEGAL_CHARACTER
			end
			else
				if gModuleMgr.sharedMgr("shieldedWordsltCtrl"):hasShieldedWord(name) then
					__err = gErrDef.Err_ALLIANCE_NAME_ILLEGAL
				else
				end
			end
		end
	end
	return __err
end
function legendTeamUtil.checkAbbr(abbr)
	local __err = gErrDef.Err_None
	abbr = string.trim(abbr)
	do
		local length = gConstValue.ALLIANCE_ABBR_LENGTH
		local curlen = string.utf8len(abbr)
		if curlen > length.max or curlen < length.min then
			__err = gErrDef.Err_ALLIANCE_CREATE_INPUT_LENS
		elseif not serviceFunctions.isMatchEnNumAndArPerfectly(abbr) then
			__err = gErrDef.Err_ALLIANCE_CREATE_INPUT_IIIEGAL_CHARACTER
		else
			if gModuleMgr.sharedMgr("shieldedWordsltCtrl"):hasShieldedWord(abbr) then
				__err = gErrDef.Err_ALLIANCE_ABBR_ILLEGAL
			else
			end
		end
	end
	return __err
end
function legendTeamUtil.isWarTest()
	local constantRead = include("constantRead")
	local flag = constantRead.getConstValue("LEGEND_WAR_TEST_FLAG", 0)
	return 0 < flag
end
function legendTeamUtil.getCurTeamCtrl(mapid)
	if worldMapDefine.isKingStarMapId(mapid) then
		return kingStarTeamCtrl
	else
		return legendTeamCtrl
	end
end
function legendTeamUtil.getTeamMemberNum(data)
	local count = 0
	if data then
		for uidStr, _ in pairs(data.memberList) do
			if not (data and data.setting and data.setting.commanders) or not data.setting.commanders[uidStr] then
				count = count + 1
			end
		end
	end
	return count
end
return legendTeamUtil

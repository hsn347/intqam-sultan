local gametop = gModuleMgr.getObject("gametop")
local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local _ENV, _ENV, nebulaWarUtil = nil, "nebulaActivityCtrl", "nebulaActivityCtrl"
;(nil).group_frame = 100
;(nil).group_icon = 101
;(nil).group_title = 102
;(nil).group_dark = 103
;(nil).group_self = 104
nebulaWarUtil.GROUP_ID, (nil).group_win = nil, 105
function nebulaWarUtil.getIsDebug(...)
	return device.platform == "mac" or userSDKManager.isBeta() or userSDKManager.isGameDevelop()
end
function nebulaWarUtil.openTeamView()
	local curState = nebulaActivityCtrl:getActivityCurState()
	if curState < NEBULA_REGION_STATE.REGION_SHOW then
		SoraDShowMsgTip(i18n("nebula_war_text_0010"))
		return
	end
	if curState >= NEBULA_REGION_STATE.ROUND4END then
		SoraDShowMsgTip(i18n("remains_text_10"))
		return
	end
	local myTeamInfo = nebulaActivityCtrl:getMyTeamInfo()
	if myTeamInfo:isHasTeam() then
		uiManager:show("NebulaWarTeam")
		return
	end
	local castleLv = NEBULA_WAR_CASTLE_LEVEL
	if castleLv > SoraDGetCastleLv() then
		SoraDShowMsgTip(i18n("nebula_war_text_0011"))
		return
	end
	uiManager:show("NebulaWarTeamJoin")
end
function nebulaWarUtil.checkCreateTeam()
	local err = gErrDef.Err_None
	local curState = nebulaActivityCtrl:getActivityCurState()
	if curState < NEBULA_REGION_STATE.REGION_SHOW then
		SoraDShowMsgTip(i18n("nebula_war_text_0010"))
		return false, gErrDef.Err_NEBULA_WAR_STATE_ERR
	end
	if not nebulaWarUtil.checkJoinTeamState() then
		SoraDShowMsgTip(i18n("nebula_war_text_0512"))
		return false
	end
	local myTeamInfo = nebulaActivityCtrl:getMyTeamInfo()
	if myTeamInfo:isHasTeam() then
		return false, gErrDef.Err_RUINS_WAR_HAVE_TEAM
	end
	local castleLv = NEBULA_WAR_CASTLE_LEVEL
	if castleLv > SoraDGetCastleLv() then
		SoraDShowMsgTip(i18n("nebula_war_text_0229"))
		return false, gErrDef.Err_NEBULA_WAR_CASTLE_LEVEL
	end
	return true, gErrDef.Err_None
end
function nebulaWarUtil.getTeamRemainNum()
	local myTeamInfo = nebulaActivityCtrl:getMyTeamInfo()
	local num = myTeamInfo:getTeamMemberNum()
	local isSuperTeam = myTeamInfo:getIsSuperTeam()
	local merberMax = nebulaWarUtil.getTeamMerberMax(isSuperTeam)
	return math.max(0, merberMax - num)
end
function nebulaWarUtil.checkTeamInSameCamp(kid1, kid2)
	kid2 = kid2 or gametop.playertop_:getKingdomID()
	local data1 = nebulaActivityCtrl:getKingdomRegionAndGrop(kid1)
	local data2 = nebulaActivityCtrl:getKingdomRegionAndGrop(kid2)
	if data1.regionId ~= data2.regionId then
		return false
	end
	if data1.groupId == data2.groupId then
		return true
	end
	return false
end
function nebulaWarUtil.checkKingdomInSameCamp(kid1, kid2)
	kid2 = kid2 or gametop.playertop_:getKingdomID()
	local data1 = nebulaActivityCtrl:getKingdomRegionAndGrop(kid1)
	local data2 = nebulaActivityCtrl:getKingdomRegionAndGrop(kid2)
	return data1.regionId == data2.regionId
end
function nebulaWarUtil.getSameCampKidList(...)
	local nebulaActivityCtrl, ret
	local regionInfo = nebulaActivityCtrl:getSelfRegionInfo()
	for groupId, group in ipairs(regionInfo.groups) do
		for _, kid in ipairs(group) do
			if nebulaWarUtil.checkTeamInSameCamp(kid) then
				table.insert(ret, kid)
			end
		end
	end
	table.sort(ret)
	return ret
end
function nebulaWarUtil.checkQuitTeamState(...)
	_ENV = nil
	;(nil)[NEBULA_REGION_STATE.ROUND1ROOM] = true
	;(nil)[NEBULA_REGION_STATE.ROUND1BATTLE] = true
	;(nil)[NEBULA_REGION_STATE.ROUND1END] = true
	;(nil)[NEBULA_REGION_STATE.ROUND2ROOM] = true
	;(nil)[NEBULA_REGION_STATE.ROUND2BATTLE] = true
	;(nil)[NEBULA_REGION_STATE.ROUND2END] = true
	;(nil)[NEBULA_REGION_STATE.ROUND3ROOM] = true
	;(nil)[NEBULA_REGION_STATE.ROUND3BATTLE] = true
	;(nil)[NEBULA_REGION_STATE.ROUND3END] = true
	;(nil)[NEBULA_REGION_STATE.ROUND4ROOM] = true
	;(nil)[NEBULA_REGION_STATE.ROUND4BATTLE] = true
	local (nil)[NEBULA_REGION_STATE.ROUND4END], stateConfig = true, nil
	return not nebulaWarUtil.checkStateConfig(stateConfig)
end
function nebulaWarUtil.checkChangeTeamNameState(...)
	_ENV = nil
	;(nil)[NEBULA_REGION_STATE.ROUND1BATTLE] = true
	;(nil)[NEBULA_REGION_STATE.ROUND2BATTLE] = true
	;(nil)[NEBULA_REGION_STATE.ROUND3BATTLE] = true
	local (nil)[NEBULA_REGION_STATE.ROUND4BATTLE], stateConfig = true, nil
	return not nebulaWarUtil.checkStateConfig(stateConfig)
end
function nebulaWarUtil.checkStateConfig(stateConfig, state)
	state = state or nebulaActivityCtrl:getActivityCurState()
	if stateConfig[state] then
		return true
	else
		return false
	end
end
function nebulaWarUtil.checkShowEnterBtn(state)
	_ENV = nil
	;(nil)[NEBULA_REGION_STATE.ROUND1BATTLE] = true
	;(nil)[NEBULA_REGION_STATE.ROUND2BATTLE] = true
	;(nil)[NEBULA_REGION_STATE.ROUND3BATTLE] = true
	local (nil)[NEBULA_REGION_STATE.ROUND4BATTLE], stateConfig = true, nil
	return nebulaWarUtil.checkStateConfig(stateConfig, state)
end
function nebulaWarUtil.checkShowLastRoundRankBtn(state)
	if worldMapDefine.isInNebula() then
		return false
	end
	_ENV = false
	;(false)[NEBULA_REGION_STATE.ROUND2MATCH] = true
	;(false)[NEBULA_REGION_STATE.ROUND3MATCH] = true
	;(false)[NEBULA_REGION_STATE.ROUND4MATCH] = true
	local (false)[NEBULA_REGION_STATE.SETTLE], stateConfig = true, false
	return nebulaWarUtil.checkStateConfig(stateConfig)
end
function nebulaWarUtil.getLastRound(...)
	local curState = nebulaActivityCtrl:getActivityCurState()
	local lastRound = 4
	if curState < NEBULA_REGION_STATE.ROUND3MATCH then
		lastRound = 1
	elseif curState < NEBULA_REGION_STATE.ROUND4MATCH then
		lastRound = 2
	elseif curState < NEBULA_REGION_STATE.SETTLE then
		lastRound = 3
	end
	return lastRound
end
function nebulaWarUtil.openCampView(showRound)
	if nebulaActivityCtrl:getActivityCurState() >= NEBULA_REGION_STATE.REGION_SHOW then
		nebulaActivityCtrl = nil
		;(nil).activityID = gActivityTimeActivityID.NEBULA_CAMP_INTEGRAL_ACTIVITY
		;(nil).showRound = showRound
		uiManager:show("NebulaWarCampKingdom", nil)
	else
		SoraDShowMsgTip(i18n("nebula_war_text_0006"))
	end
end
function nebulaWarUtil.checkEnterBattleField(enterCallback)
	local curState = nebulaActivityCtrl:getActivityCurState()
	if not nebulaWarUtil.checkShowEnterBtn() then
		SoraDShowMsgBox(i18n("nebula_war_text_0077"), i18n("common_text_054"))
		return
	end
	local castleLv = NEBULA_WAR_CASTLE_LEVEL
	if castleLv > SoraDGetCastleLv() then
		SoraDShowMsgBox(i18n("nebula_war_text_0078"), i18n("common_text_204"))
		return
	end
	if worldMapDefine.inInCrossWar() then
		SoraDShowMsgBox(i18n("atlantiswar_text_0009"), i18n("common_text_204"))
		return
	end
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	if kingdomMapCtrl:isHasQueue() ~= 0 then
		SoraDShowMsgBox(i18n("atlantiswar_text_0010"), i18n("common_text_204"))
		return
	end
	local armyCtrl = SoraDGetCtrl("armyCtrl")
	if 0 < armyCtrl:getCuringArmyCount() or 0 < armyCtrl:getTotalWoundedArmyCount() then
		SoraDShowMsgBox(i18n("nebula_war_text_0079"), i18n("common_text_477"), nil, function(eventType)
			if eventType == MSGBOX_CALLBACK_YES then
				local worldMapWarDef = include("worldMapWarDef")
				worldMapWarDef.openHospitalView()
			end
		end)
		return
	end
	local endTime = nebulaActivityCtrl:getStateBeginTime(NEBULA_REGION_STATE.ROUND4END)
	if endTime - serviceFunctions.systemTime() <= 300 then
		SoraDShowMsgBox(i18n("devilvalley_text_40"), i18n("common_text_204"))
		return
	end
	local myTeamInfo = nebulaActivityCtrl:getMyTeamInfo()
	if not myTeamInfo:isHasTeam() then
		SoraDShowMsgBox(i18n("nebula_war_text_0081"), i18n("common_text_477"), nil, function(callType)
			if callType == MSGBOX_CALLBACK_YES then
				nebulaWarUtil.openTeamView()
			end
		end)
		return
	end
	enterCallback()
	return true
end
function nebulaWarUtil.openTowerView(...)
	if nebulaWarUtil.checkNebulaTowerState() then
		uiManager:show("Nebulatower")
	else
		SoraDShowMsgTip(i18n("nebula_war_text_0245"))
	end
end
function nebulaWarUtil.jumpToBigWorldNebulaTower(...)
	if nebulaWarUtil.checkNebulaTowerState() then
		SoraDRemoveAllPanelFromManager()
		local bigWorldView = uiManager:show("BigWorldView").view
		bigWorldView:moveToKingdom(nil, true)
	else
		SoraDShowMsgTip(i18n("nebula_war_text_0245"))
	end
end
function nebulaWarUtil.checkNebulaTowerState(...)
	if worldMapDefine.isInNebula() then
		return false
	end
	local curState = nebulaActivityCtrl:getActivityCurState()
	if curState >= NEBULA_REGION_STATE.REGION_SHOW and curState <= NEBULA_REGION_STATE.SETTLE then
		return true
	end
	return false
end
function nebulaWarUtil.openRewardView(...)
	local curState = nebulaActivityCtrl:getActivityCurState()
	if curState >= NEBULA_REGION_STATE.REGION_SHOW then
		local constantRead = include("constantRead")
		local value = constantRead.getConstValue("NEBULA_WARS_REWARD_PREVIEW", 0)
		if value == 0 then
			SoraDShowMsgTip(i18n("nebula_war_text_0591"))
		else
			uiManager:show("NebulaWarRewardShow")
		end
	else
		SoraDShowMsgTip(i18n("common_text_699"))
	end
end
function nebulaWarUtil.transformState(srcState)
	_ENV = nil
	;(nil)[NEBULA_REGION_STATE.SCREEN_OTHER_KINGDOM] = NEBULA_REGION_STATE.SCREEN_SEED_KINGDOM
	;(nil)[NEBULA_REGION_STATE.ROUND1MATCH] = NEBULA_REGION_STATE.REGION_SHOW
	;(nil)[NEBULA_REGION_STATE.ROUND1TEAM] = NEBULA_REGION_STATE.REGION_SHOW
	;(nil)[NEBULA_REGION_STATE.ROUND1FOMATION] = NEBULA_REGION_STATE.REGION_SHOW
	;(nil)[NEBULA_REGION_STATE.ROUND1END] = NEBULA_REGION_STATE.ROUND1BATTLE
	;(nil)[NEBULA_REGION_STATE.ROUND2TEAM] = NEBULA_REGION_STATE.ROUND2MATCH
	;(nil)[NEBULA_REGION_STATE.ROUND2FOMATION] = NEBULA_REGION_STATE.ROUND2MATCH
	;(nil)[NEBULA_REGION_STATE.ROUND2END] = NEBULA_REGION_STATE.ROUND2BATTLE
	;(nil)[NEBULA_REGION_STATE.ROUND3TEAM] = NEBULA_REGION_STATE.ROUND3MATCH
	;(nil)[NEBULA_REGION_STATE.ROUND3FOMATION] = NEBULA_REGION_STATE.ROUND3MATCH
	;(nil)[NEBULA_REGION_STATE.ROUND3END] = NEBULA_REGION_STATE.ROUND3BATTLE
	;(nil)[NEBULA_REGION_STATE.ROUND4TEAM] = NEBULA_REGION_STATE.ROUND4MATCH
	;(nil)[NEBULA_REGION_STATE.ROUND4FOMATION] = NEBULA_REGION_STATE.ROUND4MATCH
	local (nil)[NEBULA_REGION_STATE.ROUND4END], config = NEBULA_REGION_STATE.ROUND4BATTLE, nil
	return config[srcState] or srcState or NEBULA_REGION_STATE.SCREEN_SEED_KINGDOM
end
function nebulaWarUtil.getStateName(curState)
	_ENV = nil
	;(nil)[NEBULA_REGION_STATE.SCREEN_SEED_KINGDOM] = "nebula_war_text_0491"
	;(nil)[NEBULA_REGION_STATE.REGION_SHOW] = "nebula_war_text_0565"
	;(nil)[NEBULA_REGION_STATE.ROUND1ROOM] = "nebula_war_text_0566"
	;(nil)[NEBULA_REGION_STATE.ROUND1BATTLE] = "nebula_war_text_0082"
	;(nil)[NEBULA_REGION_STATE.ROUND2MATCH] = "nebula_war_text_0565"
	;(nil)[NEBULA_REGION_STATE.ROUND2ROOM] = "nebula_war_text_0566"
	;(nil)[NEBULA_REGION_STATE.ROUND2BATTLE] = "nebula_war_text_0083"
	;(nil)[NEBULA_REGION_STATE.ROUND3MATCH] = "nebula_war_text_0565"
	;(nil)[NEBULA_REGION_STATE.ROUND3ROOM] = "nebula_war_text_0566"
	;(nil)[NEBULA_REGION_STATE.ROUND3BATTLE] = "nebula_war_text_0084"
	;(nil)[NEBULA_REGION_STATE.ROUND4MATCH] = "nebula_war_text_0565"
	;(nil)[NEBULA_REGION_STATE.ROUND4ROOM] = "nebula_war_text_0566"
	;(nil)[NEBULA_REGION_STATE.ROUND4BATTLE] = "nebula_war_text_0238"
	local (nil)[NEBULA_REGION_STATE.SETTLE], state2name = "nebula_war_text_0063", nil
	local _state = nebulaWarUtil.transformState(curState)
	return i18n(state2name[_state]) or ""
end
function nebulaWarUtil.getEventCenterStateName(curState)
	_ENV = nil
	;(nil)[NEBULA_REGION_STATE.SCREEN_SEED_KINGDOM] = "nebula_war_text_0567"
	;(nil)[NEBULA_REGION_STATE.REGION_SHOW] = "nebula_war_text_0565"
	;(nil)[NEBULA_REGION_STATE.ROUND1ROOM] = "nebula_war_text_0566"
	;(nil)[NEBULA_REGION_STATE.ROUND1BATTLE] = "nebula_war_text_0568"
	;(nil)[NEBULA_REGION_STATE.ROUND2MATCH] = "nebula_war_text_0565"
	;(nil)[NEBULA_REGION_STATE.ROUND2ROOM] = "nebula_war_text_0566"
	;(nil)[NEBULA_REGION_STATE.ROUND2BATTLE] = "nebula_war_text_0568"
	;(nil)[NEBULA_REGION_STATE.ROUND3MATCH] = "nebula_war_text_0565"
	;(nil)[NEBULA_REGION_STATE.ROUND3ROOM] = "nebula_war_text_0566"
	;(nil)[NEBULA_REGION_STATE.ROUND3BATTLE] = "nebula_war_text_0568"
	;(nil)[NEBULA_REGION_STATE.ROUND4MATCH] = "nebula_war_text_0565"
	;(nil)[NEBULA_REGION_STATE.ROUND4ROOM] = "nebula_war_text_0566"
	;(nil)[NEBULA_REGION_STATE.ROUND4BATTLE] = "nebula_war_text_0568"
	local (nil)[NEBULA_REGION_STATE.SETTLE], state2name = "nebula_war_text_0569", nil
	local _state = nebulaWarUtil.transformState(curState)
	return i18n(state2name[_state]) or ""
end
function nebulaWarUtil.getStateEndTime(curState)
	_ENV = nil
	;(nil)[NEBULA_REGION_STATE.ROUND1MATCH] = NEBULA_REGION_STATE.ROUND1ROOM
	;(nil)[NEBULA_REGION_STATE.ROUND1TEAM] = NEBULA_REGION_STATE.ROUND1ROOM
	;(nil)[NEBULA_REGION_STATE.ROUND1FOMATION] = NEBULA_REGION_STATE.ROUND1ROOM
	;(nil)[NEBULA_REGION_STATE.ROUND1ROOM] = NEBULA_REGION_STATE.ROUND1BATTLE
	;(nil)[NEBULA_REGION_STATE.ROUND1END] = NEBULA_REGION_STATE.ROUND2ROOM
	;(nil)[NEBULA_REGION_STATE.ROUND2MATCH] = NEBULA_REGION_STATE.ROUND2ROOM
	;(nil)[NEBULA_REGION_STATE.ROUND2TEAM] = NEBULA_REGION_STATE.ROUND2ROOM
	;(nil)[NEBULA_REGION_STATE.ROUND2FOMATION] = NEBULA_REGION_STATE.ROUND2ROOM
	;(nil)[NEBULA_REGION_STATE.ROUND2ROOM] = NEBULA_REGION_STATE.ROUND2BATTLE
	;(nil)[NEBULA_REGION_STATE.ROUND2END] = NEBULA_REGION_STATE.ROUND3ROOM
	;(nil)[NEBULA_REGION_STATE.ROUND3MATCH] = NEBULA_REGION_STATE.ROUND3ROOM
	;(nil)[NEBULA_REGION_STATE.ROUND3TEAM] = NEBULA_REGION_STATE.ROUND3ROOM
	;(nil)[NEBULA_REGION_STATE.ROUND3FOMATION] = NEBULA_REGION_STATE.ROUND3ROOM
	;(nil)[NEBULA_REGION_STATE.ROUND3ROOM] = NEBULA_REGION_STATE.ROUND3BATTLE
	;(nil)[NEBULA_REGION_STATE.ROUND3END] = NEBULA_REGION_STATE.ROUND4ROOM
	;(nil)[NEBULA_REGION_STATE.ROUND4MATCH] = NEBULA_REGION_STATE.ROUND4ROOM
	;(nil)[NEBULA_REGION_STATE.ROUND4TEAM] = NEBULA_REGION_STATE.ROUND4ROOM
	;(nil)[NEBULA_REGION_STATE.ROUND4FOMATION] = NEBULA_REGION_STATE.ROUND4ROOM
	;(nil)[NEBULA_REGION_STATE.ROUND4ROOM] = NEBULA_REGION_STATE.ROUND4BATTLE
	local (nil)[NEBULA_REGION_STATE.FINISH], config = NEBULA_REGION_STATE.FINISH, nil
	local nextState = config[curState] or curState + 1
	return nebulaActivityCtrl:getStateBeginTime(nextState)
end
function nebulaWarUtil.getTimeLineData()
	_ENV, _UPVALUE14_ = nil, nil
	;(nil).state = NEBULA_REGION_STATE.SCREEN_SEED_KINGDOM
	_ENV, (nil).name = i18n("nebula_war_text_0567"), i18n("nebula_war_text_0567")
	i18n("nebula_war_text_0567").state = NEBULA_REGION_STATE.REGION_SHOW
	_ENV, i18n("nebula_war_text_0567").name = i18n("nebula_war_text_0565"), i18n("nebula_war_text_0565")
	i18n("nebula_war_text_0565").state = NEBULA_REGION_STATE.ROUND1ROOM
	_ENV, i18n("nebula_war_text_0565").name = i18n("nebula_war_text_0566"), i18n("nebula_war_text_0566")
	i18n("nebula_war_text_0566").state = NEBULA_REGION_STATE.ROUND1BATTLE
	_ENV, i18n("nebula_war_text_0566").name = i18n("nebula_war_text_0570"), i18n("nebula_war_text_0570")
	i18n("nebula_war_text_0570").state = NEBULA_REGION_STATE.ROUND2MATCH
	_ENV, i18n("nebula_war_text_0570").name = i18n("nebula_war_text_0571"), i18n("nebula_war_text_0571")
	i18n("nebula_war_text_0571").state = NEBULA_REGION_STATE.ROUND2ROOM
	_ENV, i18n("nebula_war_text_0571").name = i18n("nebula_war_text_0572"), i18n("nebula_war_text_0572")
	i18n("nebula_war_text_0572").state = NEBULA_REGION_STATE.ROUND2BATTLE
	_ENV, i18n("nebula_war_text_0572").name = i18n("nebula_war_text_0573"), i18n("nebula_war_text_0573")
	i18n("nebula_war_text_0573").state = NEBULA_REGION_STATE.ROUND3MATCH
	_ENV, i18n("nebula_war_text_0573").name = i18n("nebula_war_text_0574"), i18n("nebula_war_text_0574")
	i18n("nebula_war_text_0574").state = NEBULA_REGION_STATE.ROUND3ROOM
	_ENV, i18n("nebula_war_text_0574").name = i18n("nebula_war_text_0575"), i18n("nebula_war_text_0575")
	i18n("nebula_war_text_0575").state = NEBULA_REGION_STATE.ROUND3BATTLE
	_ENV, i18n("nebula_war_text_0575").name = i18n("nebula_war_text_0576"), i18n("nebula_war_text_0576")
	i18n("nebula_war_text_0576").state = NEBULA_REGION_STATE.ROUND4MATCH
	_ENV, i18n("nebula_war_text_0576").name = i18n("nebula_war_text_0577"), i18n("nebula_war_text_0577")
	i18n("nebula_war_text_0577").state = NEBULA_REGION_STATE.ROUND4ROOM
	_ENV, i18n("nebula_war_text_0577").name = i18n("nebula_war_text_0578"), i18n("nebula_war_text_0578")
	i18n("nebula_war_text_0578").state = NEBULA_REGION_STATE.ROUND4BATTLE
	_ENV, i18n("nebula_war_text_0578").name = i18n("nebula_war_text_0579"), i18n("nebula_war_text_0579")
	i18n("nebula_war_text_0579").state = NEBULA_REGION_STATE.SETTLE
	i18n("nebula_war_text_0579").name = i18n("nebula_war_text_0569")
	;(nil)[1] = nil
	;(nil)[2] = i18n("nebula_war_text_0567")
	;(nil)[3] = i18n("nebula_war_text_0565")
	;(nil)[4] = i18n("nebula_war_text_0566")
	;(nil)[5] = i18n("nebula_war_text_0570")
	;(nil)[6] = i18n("nebula_war_text_0571")
	;(nil)[7] = i18n("nebula_war_text_0572")
	;(nil)[8] = i18n("nebula_war_text_0573")
	;(nil)[9] = i18n("nebula_war_text_0574")
	;(nil)[10] = i18n("nebula_war_text_0575")
	;(nil)[11] = i18n("nebula_war_text_0576")
	;(nil)[12] = i18n("nebula_war_text_0577")
	;(nil)[13] = i18n("nebula_war_text_0578")
	local (nil)[14], config = i18n("nebula_war_text_0579"), nil
	local _ENV, ret
	for i, v in ipairs(config) do
		local beginTime = nebulaActivityCtrl:getStateBeginTime(v.state)
		local endTime
		if v.state == NEBULA_REGION_STATE.SETTLE then
			endTime = nebulaActivityCtrl:getStateBeginTime(v.state + 1)
		else
			endTime = nebulaActivityCtrl:getStateBeginTime(config[i + 1].state)
		end
		local timeStr = string.format("%s -- %s", os.date("!%m/%d %H:%M", beginTime), os.date("!%m/%d %H:%M", endTime))
		v.timeStr = timeStr
	end
	return config
end
function nebulaWarUtil.getRegionId(...)
	return nebulaActivityCtrl:getSelfRegionId()
end
function nebulaWarUtil.getRegionGroup(...)
	local _, regionId = nebulaActivityCtrl:getKingdomRegionType()
	local nebulaWarRead = include("nebulaWarRead")
	return nebulaWarRead.getAreaGroup(regionId)
end
_ENV, nebulaWarUtil.getIsNewRegionGroup = function()
	local group = nebulaWarUtil.getRegionGroup()
	if group == 2 then
		return true
	end
end, function()
	local group = nebulaWarUtil.getRegionGroup()
	if group == 2 then
		return true
	end
end
;(function()
	local group = nebulaWarUtil.getRegionGroup()
	if group == 2 then
		return true
	end
end).NoTransfer = 3
;(function()
	local group = nebulaWarUtil.getRegionGroup()
	if group == 2 then
		return true
	end
end).WarArea = 5
;(function()
	local group = nebulaWarUtil.getRegionGroup()
	if group == 2 then
		return true
	end
end).WarAreaSuper = 7
local (function()
	local group = nebulaWarUtil.getRegionGroup()
	if group == 2 then
		return true
	end
end).forbidAreaSuper, Area_Type = 8, function()
	local group = nebulaWarUtil.getRegionGroup()
	if group == 2 then
		return true
	end
end
function nebulaWarUtil.checkIsInForbidArea(selfManorRect, areaType)
	if areaType == Area_Type.WarAreaSuper then
		local nebulaWarRead = include("nebulaWarRead")
		for __, forbidRect in ipairs(nebulaWarRead.getSuperWarAreaRectList()) do
			if cc.rectIntersectsRect(selfManorRect, forbidRect) then
				return true
			end
		end
	elseif areaType == Area_Type.WarArea then
		local nebulaWarRead = include("nebulaWarRead")
		for __, forbidRect in ipairs(nebulaWarRead.getSuperWarAreaForbidRectList()) do
			if cc.rectIntersectsRect(selfManorRect, forbidRect) then
				return false
			end
		end
		return true
	elseif areaType == Area_Type.NoTransfer then
		local nebulaWarRead = include("nebulaWarRead")
		for __, forbidRect in ipairs(nebulaWarRead.getForbidRectList()) do
			if cc.rectIntersectsRect(selfManorRect, forbidRect) then
				return true
			end
		end
		if nebulaWarUtil.checkIsInForbidArea(selfManorRect, Area_Type.forbidAreaSuper) then
			return true
		end
	elseif areaType == Area_Type.forbidAreaSuper then
		if nebulaWarUtil.checkIsInForbidArea(selfManorRect, Area_Type.WarAreaSuper) then
			return false
		end
		if nebulaWarUtil.checkIsInForbidArea(selfManorRect, Area_Type.WarArea) then
			return false
		end
		return true
	end
	return false
end
function nebulaWarUtil.getEnemyCamp(...)
	local selfCamp = nebulaActivityCtrl:getSelfCamp()
	if selfCamp == NEBULA_WAR_CAMP.SOUTH then
		return NEBULA_WAR_CAMP.NORTH
	else
		return NEBULA_WAR_CAMP.SOUTH
	end
end
function nebulaWarUtil.checkIsCanTransfer(selfManorRect)
	if nebulaWarUtil.checkIsInForbidArea(selfManorRect, Area_Type.NoTransfer) then
		return false
	end
	local isSuperTeam = nebulaActivityCtrl:getMyTeamInfo():getIsSuperTeam()
	if isSuperTeam then
		if nebulaWarUtil.checkIsInForbidArea(selfManorRect, Area_Type.WarArea) then
			return false, worldMapLayInstanceTypeErrorDef.nebulaWar_warArea
		end
	elseif nebulaWarUtil.checkIsInForbidArea(selfManorRect, Area_Type.WarAreaSuper) then
		return false, worldMapLayInstanceTypeErrorDef.nebulaWar_superWarArea
	end
	return true
end
function nebulaWarUtil.checkIsWarRange(selfManorRect)
	return false
end
function nebulaWarUtil.checkIsCanZhanling(point)
	return false, i18n("nebula_war_text_0490")
end
function nebulaWarUtil.checkIsCanGongji(point)
	local targetRect = cc.rect(point.x, point.y, 0, 0)
	local isSuperTeam = nebulaActivityCtrl:getMyTeamInfo():getIsSuperTeam()
	if isSuperTeam then
		if nebulaWarUtil.checkIsInForbidArea(targetRect, Area_Type.WarArea) then
			return false, i18n("nebula_war_text_0408")
		end
	elseif nebulaWarUtil.checkIsInForbidArea(targetRect, Area_Type.WarAreaSuper) then
		return false, i18n("nebula_war_text_0407")
	end
	return true
end
function nebulaWarUtil.getBigWorldKingdomList(regionType, regionId, useBase)
	local kingdomCtrl = SoraDGetCtrl("kingdomCtrl")
	local _ENV, kingdomlist = "kingdomCtrl", "kingdomCtrl"
	if useBase then
		kingdomlist = kingdomCtrl:getBaseKingdomList()
	else
		kingdomlist = kingdomCtrl:getKingdomList()
	end
	local _ENV, kingdomMap = kingdomCtrl:getKingdomList(), kingdomCtrl:getKingdomList()
	for __, v in pairs(kingdomlist) do
		kingdomMap[v.kid] = v
	end
	local _ENV, realKingdomList = (for generator), pairs(kingdomlist)
	if regionType == NEBULA_REGION_TYPE.HEGEMONY_REGION then
		local hegemonyRegion = nebulaActivityCtrl:getHegemonyRegionData()
		local region = hegemonyRegion[regionId]
		for groupId, group in ipairs(region) do
			for _, kid in ipairs(group) do
				local kingdom = kingdomMap[kid]
				if kingdom then
					table.insert(realKingdomList, kingdom)
				end
			end
		end
	elseif regionType == NEBULA_REGION_TYPE.PREPARE_FOR_WAR then
		local prepareForWarRegion = nebulaActivityCtrl:getPrepareForWarRegionData()
		for i, kid in ipairs(prepareForWarRegion) do
			local kingdom = kingdomMap[kid]
			if kingdom then
				table.insert(realKingdomList, kingdom)
			end
		end
		local toBePrepareForWarRegion = nebulaActivityCtrl:getToBePrepareForWarRegionData()
		for i, kid in ipairs(toBePrepareForWarRegion) do
			local kingdom = kingdomMap[kid]
			if kingdom then
				table.insert(realKingdomList, kingdom)
			end
		end
	else
		for i = 1, #kingdomlist do
			if kingdomlist[i].kid < GAME_KINGDOM_ID_ASSIGN.LEGEND.START then
				local regionType = nebulaActivityCtrl:getKingdomRegionType(kingdomlist[i].kid)
				if regionType == NEBULA_REGION_TYPE.SEPARATIST_REGIME then
					table.insert(realKingdomList, kingdomlist[i])
				end
			end
			if not commonCheck.NEBULA_AREA and worldMapDefine.isLegendLordKingdomID(kingdomlist[i].kid) then
				table.insert(realKingdomList, kingdomlist[i])
			end
		end
	end
	return realKingdomList
end
function nebulaWarUtil.isInWarForbidSpeed(queue, noshowTips)
	return false
end
function nebulaWarUtil.getRelationType(fromCamp, selfCamp, fromTeamId, selfTeamId)
	selfCamp = selfCamp or nebulaActivityCtrl:getSelfCamp()
	selfTeamId = selfTeamId or nebulaActivityCtrl:getSelfTeamId()
	local relationType = gMapAllianceRelationType.NORMAL
	if fromCamp and 0 < fromCamp then
		if fromCamp == selfCamp then
			if fromTeamId == selfTeamId then
				relationType = gMapAllianceRelationType.SELF
			else
				relationType = gMapAllianceRelationType.NORMAL
			end
		else
			relationType = gMapAllianceRelationType.ENEMY
		end
	end
	return relationType
end
function nebulaWarUtil.getSupremacyRoadRemainTime(...)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local activityID = gActivityTimeActivityID.SUPREMACY_ROAD_ACTIVITY
	local curRound = activityShowCtrl:getParamClassType(activityID)
	_ENV = activityShowCtrl
	activityShowCtrl[1] = NEBULA_REGION_STATE.ROUND1END
	activityShowCtrl[2] = NEBULA_REGION_STATE.ROUND2END
	activityShowCtrl[3] = NEBULA_REGION_STATE.ROUND3END
	local activityShowCtrl[4], config = NEBULA_REGION_STATE.ROUND4END, activityShowCtrl
	local endTime = nebulaActivityCtrl:getStateBeginTime(config[curRound])
	local remainTime = endTime - serviceFunctions.systemTime()
	return remainTime
end
function nebulaWarUtil.getTeamMerberMax(isSuperTeam)
	local constantRead = include("constantRead")
	local value = constantRead.getConstValue("NEBULA_WARS_ARMY_NUM", 30)
	return value
end
function nebulaWarUtil.getSuperTeamNumMax(...)
	local constantRead = include("constantRead")
	local value = constantRead.getConstValue("NEBULA_WARS_PEAKTEAM_NUM", 5)
	return value
end
function nebulaWarUtil.checkBuildCanAttack(mapInstance)
	local buildName = mapInstance:getFavoriteName()
	local isSuperTeam = nebulaActivityCtrl:getMyTeamInfo():getIsSuperTeam()
	local showMsg, jumpIndex
	local guideID = 105
	if mapInstance:getSubType() == gWorldTypeServerDef.subTypeNebulaWarFort then
		if isSuperTeam then
			nebulaActivityCtrl = nil
			;(nil).build = buildName
			showMsg = i18n("nebula_war_text_0405", nil)
			jumpIndex = 4
		end
	elseif not isSuperTeam then
		nebulaActivityCtrl = nil
		;(nil).build = buildName
		showMsg = i18n("nebula_war_text_0403", nil)
		jumpIndex = 3
	end
	if showMsg then
		SoraDShowMsgBox(showMsg, i18n("common_text_829"), nil, function(callType)
			if callType ~= MSGBOX_CALLBACK_YES then
				return
			end
			_ENV = nil
			;(nil).instanceType = 0
			;(nil).classId = guideID
			;(nil).title = i18n("common_text_001")
			;(nil).jumpIndex = jumpIndex
			uiManager:show("WorldMapExplain", nil)
		end)
		return false
	end
	return true
end
function nebulaWarUtil.checkBuildCanAttack2(subType)
	local isSuperTeam = nebulaActivityCtrl:getMyTeamInfo():getIsSuperTeam()
	if subType == gWorldTypeServerDef.subTypeNebulaWarFort then
		if isSuperTeam then
			return false
		end
	elseif not isSuperTeam then
		return false
	end
	return true
end
function nebulaWarUtil.getMapBuildPosition(subType)
	_ENV = nil
	;(nil)[gWorldTypeServerDef.subTypeNebulaWarPalace] = cc.p(-40, 100)
	;(nil)[gWorldTypeServerDef.subTypeNebulaWarFort] = cc.p(20, 0)
	;(nil)[gWorldTypeServerDef.subTypeNebulaWarBigMine] = cc.p(-60, 20)
	local (nil)[gWorldTypeServerDef.subTypeNebulaWarSmallMine], config = cc.p(-50, 20), nil
	return config[subType] or cc.p(0, 0)
end
function nebulaWarUtil.checkCanMass(...)
	return true
end
function nebulaWarUtil.getSelfPlayerID(...)
	local gametop = gModuleMgr.getObject("gametop")
	return gametop.playertop_:getPlayerID()
end
function nebulaWarUtil.checkShowSuperTeamBtn()
	local curState = nebulaActivityCtrl:getActivityCurState()
	if curState >= NEBULA_REGION_STATE.REGION_SHOW and curState <= NEBULA_REGION_STATE.ROUND4BATTLE then
		return true
	end
	return false
end
function nebulaWarUtil.checkSuperTeamSignUpState(state)
	_ENV = nil
	;(nil)[NEBULA_REGION_STATE.REGION_SHOW] = true
	;(nil)[NEBULA_REGION_STATE.ROUND1MATCH] = true
	;(nil)[NEBULA_REGION_STATE.ROUND1TEAM] = true
	;(nil)[NEBULA_REGION_STATE.ROUND1FOMATION] = true
	;(nil)[NEBULA_REGION_STATE.ROUND2MATCH] = true
	;(nil)[NEBULA_REGION_STATE.ROUND2TEAM] = true
	;(nil)[NEBULA_REGION_STATE.ROUND2FOMATION] = true
	;(nil)[NEBULA_REGION_STATE.ROUND3MATCH] = true
	;(nil)[NEBULA_REGION_STATE.ROUND3TEAM] = true
	;(nil)[NEBULA_REGION_STATE.ROUND3FOMATION] = true
	;(nil)[NEBULA_REGION_STATE.ROUND4MATCH] = true
	;(nil)[NEBULA_REGION_STATE.ROUND4TEAM] = true
	local (nil)[NEBULA_REGION_STATE.ROUND4FOMATION], stateConfig = true, nil
	return nebulaWarUtil.checkStateConfig(stateConfig, state)
end
function nebulaWarUtil.openSuperTeamSignUpView(...)
	if nebulaWarUtil.checkSuperTeamSignUpState() then
		uiManager:show("NebulaWarSignUpBegin")
	else
		uiManager:show("NebulaWarSignUpEnd")
	end
end
function nebulaWarUtil.getSuperTeamSignUpRemainTime(...)
	_ENV = nil
	;(nil)[1] = NEBULA_REGION_STATE.ROUND1ROOM
	;(nil)[2] = NEBULA_REGION_STATE.ROUND2ROOM
	;(nil)[3] = NEBULA_REGION_STATE.ROUND3ROOM
	local (nil)[4], config = NEBULA_REGION_STATE.ROUND4ROOM, nil
	local curState = nebulaActivityCtrl:getActivityCurState()
	for __, v in ipairs(config) do
		if v >= curState then
			local stageTime = nebulaActivityCtrl:getStateBeginTime(v)
			local time = stageTime - serviceFunctions.systemTime()
			return math.max(0, time)
		end
	end
	return 0
end
function nebulaWarUtil.openPersonScroeView()
	local curState = nebulaActivityCtrl:getActivityCurState()
	if curState >= NEBULA_REGION_STATE.REGION_SHOW then
		local constantRead = include("constantRead")
		local value = constantRead.getConstValue("NEBULA_WARS_REWARD_PREVIEW", 0)
		if value == 0 then
			SoraDShowMsgTip(i18n("nebula_war_text_0591"))
		else
			nebulaActivityCtrl = i18n("nebula_war_text_0591")
			i18n("nebula_war_text_0591").activityID = gActivityTimeActivityID.NEBULA_REGION_ACTIVITY
			uiManager:show("MagicLampStage", i18n("nebula_war_text_0591"))
		end
	else
		SoraDShowMsgTip(i18n("common_text_699"))
	end
end
function nebulaWarUtil.getFightGroupId(...)
	local round = nebulaActivityCtrl:getCurRound()
	local groupId = nebulaActivityCtrl:getSelfGroupId()
	local roundAgainst = nebulaActivityCtrl:getRoundAgainst(round)
	local index = table.indexof(roundAgainst, groupId)
	if index then
		if index % 2 == 1 then
			return roundAgainst[index + 1]
		else
			return roundAgainst[index - 1]
		end
	end
end
function nebulaWarUtil.getGroupIdByCamp(camp)
	local round = nebulaActivityCtrl:getCurRound()
	local groupId = nebulaActivityCtrl:getSelfGroupId()
	local roundAgainst = nebulaActivityCtrl:getRoundAgainst(round)
	local index = table.indexof(roundAgainst, groupId)
	if index then
		local againstId = math.ceil(index / 2)
		index = (againstId - 1) * 2 + camp
		return roundAgainst[index]
	end
end
function nebulaWarUtil.getCampByGroupId(groupId, round)
	round = round or nebulaActivityCtrl:getCurRound()
	local roundAgainst = nebulaActivityCtrl:getRoundAgainst(round)
	local index = table.indexof(roundAgainst, groupId)
	if index then
		if index % 2 == 1 then
			return NEBULA_WAR_CAMP.SOUTH
		else
			return NEBULA_WAR_CAMP.NORTH
		end
	end
end
function nebulaWarUtil.getOutWarSelfCamp(round)
	local groupId = nebulaActivityCtrl:getSelfGroupId()
	return nebulaWarUtil.getCampByGroupId(groupId, round)
end
function nebulaWarUtil.getGroupIdByKid(kid)
	local data = nebulaActivityCtrl:getKingdomRegionAndGrop(kid)
	return data.groupId
end
function nebulaWarUtil.getAddSeasonScore(winScore, loseScore)
	local constantRead = include("constantRead")
	local winBaseScore = constantRead.getConstValue("NEBULA_WARS_WIN_INTEGRAL", 20)
	local loseBaseScore = constantRead.getConstValue("NEBULA_WARS_LOSE_INTEGRAL", 10)
	local totalBaseScore = winBaseScore + loseBaseScore
	local totalScore = winScore
	local score = math.ceil((winScore - loseScore) / totalScore * totalBaseScore)
	return winBaseScore + score, loseBaseScore
end
function nebulaWarUtil.getWarRealStartTime(...)
	local constantRead = include("constantRead")
	local warStartTime = nebulaActivityCtrl:getWarStartTime()
	local readyTime = constantRead.getConstValue("NEBULA_WARS_READY_TIME", 300)
	return warStartTime - readyTime
end
function nebulaWarUtil.getMineScoreRemainTime(buildId)
	local nebulaWarRead = include("nebulaWarRead")
	local startTime = nebulaWarRead.getBuildStartTime(buildId)
	local refreshtime = nebulaWarRead.getBuildTime(buildId)
	local warStartTime = nebulaWarUtil.getWarRealStartTime()
	local totalTime = serviceFunctions.systemTime() - (warStartTime + startTime)
	local count = math.max(0, math.floor(totalTime / refreshtime)) + 1
	local num = nebulaWarRead.getMineQueueNum(buildId)
	if not num[count] then
		return
	end
	if num[count] ~= 0 then
		if totalTime < 0 then
			return -totalTime
		else
			return refreshtime - totalTime % refreshtime
		end
	else
		for i = count + 1, #num do
			if num[i] ~= 0 then
				if totalTime < 0 then
					return refreshtime * (i - count) - totalTime
				else
					return rrefreshtime * (i - count + 1) - totalTime % refreshtime
				end
			end
		end
	end
end
function nebulaWarUtil.getMonsterRemainTime(npcId)
	local nebulaWarRead = include("nebulaWarRead")
	local warStartTime = nebulaWarUtil.getWarRealStartTime()
	local refresh = nebulaWarRead.getMonsterRefresh(npcId)
	for __, time in ipairs(refresh) do
		local remainTime = warStartTime + time - serviceFunctions.systemTime()
		if 0 < remainTime then
			return remainTime
		end
	end
	return 0
end
function nebulaWarUtil.IsStateNoUse(state)
	_ENV = nil
	;(nil)[NEBULA_REGION_STATE.SCREEN_OTHER_KINGDOM] = true
	;(nil)[NEBULA_REGION_STATE.ROUND1MATCH] = true
	;(nil)[NEBULA_REGION_STATE.ROUND1TEAM] = true
	;(nil)[NEBULA_REGION_STATE.ROUND1FOMATION] = true
	;(nil)[NEBULA_REGION_STATE.ROUND2TEAM] = true
	;(nil)[NEBULA_REGION_STATE.ROUND2FOMATION] = true
	;(nil)[NEBULA_REGION_STATE.ROUND3TEAM] = true
	;(nil)[NEBULA_REGION_STATE.ROUND3FOMATION] = true
	;(nil)[NEBULA_REGION_STATE.ROUND4TEAM] = true
	local (nil)[NEBULA_REGION_STATE.ROUND4FOMATION], stateConfig = true, nil
	return nebulaWarUtil.checkStateConfig(stateConfig, state)
end
function nebulaWarUtil.checkIsInWarReady(state)
	_ENV = nil
	;(nil)[NEBULA_REGION_STATE.ROUND1ROOM] = true
	;(nil)[NEBULA_REGION_STATE.ROUND2ROOM] = true
	;(nil)[NEBULA_REGION_STATE.ROUND3ROOM] = true
	local (nil)[NEBULA_REGION_STATE.ROUND4ROOM], stateConfig = true, nil
	return nebulaWarUtil.checkStateConfig(stateConfig, state)
end
function nebulaWarUtil.checkConstantJoinTeam(...)
	local constantRead = include("constantRead")
	local value = constantRead.getConstValue("NEBULA_WARS_JOIN_TEAM", 1)
	return value == 1
end
function nebulaWarUtil.checkJoinTeamState(...)
	if nebulaWarUtil.checkConstantJoinTeam() then
		return nebulaWarUtil.checkSuperTeamSignUpState(...)
	else
		local curState = nebulaActivityCtrl:getActivityCurState()
		return curState >= NEBULA_REGION_STATE.REGION_SHOW
	end
end
function nebulaWarUtil.openMilepostView(...)
	if not nebulaWarUtil.checkMilepostState() then
		SoraDShowMsgTip(i18n("nebula_war_text_0258"))
	else
		uiManager:show("NbulaMileStone")
	end
end
function nebulaWarUtil.checkMilepostState(...)
	local curState = nebulaActivityCtrl:getActivityCurState()
	if curState >= NEBULA_REGION_STATE.REGION_SHOW then
		return true
	else
		return false
	end
end
function nebulaWarUtil.getNebulaGroupAgainstId(groupId, round)
	local roundAgainst = nebulaActivityCtrl:getRoundAgainst(round)
	local index = table.indexof(roundAgainst, groupId)
	if index then
		return math.ceil(index / 2)
	end
end
function nebulaWarUtil.getMyBattldId(round)
	round = round or nebulaActivityCtrl:getCurRound()
	if 4 <= round then
		local groupId = nebulaActivityCtrl:getSelfGroupId()
		local roundAgainst = nebulaActivityCtrl:getRoundAgainst(4)
		local index = table.indexof(roundAgainst, groupId)
		if index then
			return math.ceil(index / 2)
		end
	end
	return 0
end
function nebulaWarUtil.getGroupCount(...)
	if nebulaWarUtil.checkSelfCampType1() then
		return 8
	else
		return 4
	end
end
function nebulaWarUtil.checkSelfCampType1()
	local nebulaWarRead = include("nebulaWarRead")
	local regionId = nebulaWarUtil.getRegionId()
	return nebulaWarRead.checkCampType1(regionId)
end
function nebulaWarUtil.openOfficerView(...)
	local nebulaPrivilegeCtrl = SoraDGetCtrl("nebulaPrivilegeCtrl")
	local round = nebulaPrivilegeCtrl:getRound()
	if 4 <= round and nebulaWarUtil.checkSelfCampType1() then
		uiManager:show("NebulaOfficer1")
	else
		uiManager:show("NebulaOfflcer")
	end
end
function nebulaWarUtil.getWinAndLoseCount(groupId, showRound)
	local roundSettleData = nebulaActivityCtrl:getRoundSettleData(groupId)
	local _showRound = showRound or nebulaActivityCtrl:getCurRound()
	local winCount, loseCount = 0, 0
	for i = 1, _showRound do
		local data = roundSettleData[tostring(i)]
		if data and data.isWin then
			winCount = winCount + 1
		else
			loseCount = loseCount + 1
		end
	end
	return winCount, loseCount
end
function nebulaWarUtil.getSeasonScore(groupId, showRound)
	local roundSettleData = nebulaActivityCtrl:getRoundSettleData(groupId)
	local _showRound = showRound or nebulaActivityCtrl:getCurRound()
	local score = 0
	for i = 1, _showRound do
		local data = roundSettleData[tostring(i)]
		score = score + (data and data.score or 0)
	end
	return score
end
function nebulaWarUtil.checkShowScheduleBtn(...)
	if not nebulaWarUtil.checkSelfCampType1() then
		return false
	end
	local curState = nebulaActivityCtrl:getActivityCurState()
	if curState >= NEBULA_REGION_STATE.ROUND1ROOM then
		return true
	end
	return false
end
function nebulaWarUtil.getScheduleRound()
	local curState = nebulaActivityCtrl:getActivityCurState()
	nebulaActivityCtrl = nebulaActivityCtrl
	nebulaActivityCtrl[1] = NEBULA_REGION_STATE.ROUND1ROOM
	nebulaActivityCtrl[2] = NEBULA_REGION_STATE.ROUND2ROOM
	nebulaActivityCtrl[3] = NEBULA_REGION_STATE.ROUND3ROOM
	local nebulaActivityCtrl[4], config = NEBULA_REGION_STATE.ROUND4ROOM, nebulaActivityCtrl
	for round, state in ipairs(config) do
		if state > curState then
			return round - 1
		end
	end
	return #config
end
return nebulaWarUtil

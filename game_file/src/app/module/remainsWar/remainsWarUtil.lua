local _ENV, remainsWarUtil
local gametop = gModuleMgr.getObject("gametop")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local remainsTeamCtrl = gametop.playertop_:getModule("remainsTeamCtrl")
local armyCtrl = gametop.playertop_:getModule("armyCtrl")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
_ENV = gametop.playertop_
gametop.playertop_.NONE = 1
gametop.playertop_.TIPS = 2
gametop.playertop_.REFRESH = 3
remainsWarUtil.errType, gametop.playertop_.CLOSE = gametop.playertop_, 4
local errType = remainsWarUtil.errType
_ENV = "kingdomMapCtrl"
;("kingdomMapCtrl")[gErrDef.Err_RUINS_WAR_NOT_IN_MATCH_STATE] = errType.CLOSE
;("kingdomMapCtrl")[gErrDef.Err_RUINS_WAR_NOT_JOIN_ALLIANCE] = errType.CLOSE
;("kingdomMapCtrl")[gErrDef.Err_RUINS_WAR_CASTLE_LV_NOT_ENOUGH] = errType.TIPS
;("kingdomMapCtrl")[gErrDef.Err_RUINS_WAR_TEAM_NAME_ILLEGAL] = errType.TIPS
;("kingdomMapCtrl")[gErrDef.Err_RUINS_WAR_TEAM_NAME_HAVE] = errType.TIPS
;("kingdomMapCtrl")[gErrDef.Err_RUINS_WAR_TEAM_BATTLE_TIMES] = errType.TIPS
;("kingdomMapCtrl")[gErrDef.Err_RUINS_WAR_EMPTY_ARMY] = errType.TIPS
;("kingdomMapCtrl")[gErrDef.Err_RUINS_WAR_ARMY_NOT_ENOUGH] = errType.REFRESH
;("kingdomMapCtrl")[gErrDef.Err_RUINS_WAR_TEAM_NOT_FOUND] = errType.CLOSE
;("kingdomMapCtrl")[gErrDef.Err_RUINS_WAR_NOT_SAME_ALLIANCE] = errType.CLOSE
;("kingdomMapCtrl")[gErrDef.Err_RUINS_WAR_FULL_TEAM] = errType.CLOSE
;("kingdomMapCtrl")[gErrDef.Err_RUINS_WAR_TEAM_STATE_ERR] = errType.CLOSE
;("kingdomMapCtrl")[gErrDef.Err_RUINS_WAR_PLAYER_NOT_IN_TEAM] = errType.CLOSE
;("kingdomMapCtrl")[gErrDef.Err_RUINS_WAR_NOT_TEAM_LEADER] = errType.CLOSE
;("kingdomMapCtrl")[gErrDef.Err_RUINS_WAR_HAVE_TEAM] = errType.CLOSE
;("kingdomMapCtrl")[gErrDef.Err_RUINS_WAR_IS_TEAM_LEADER] = errType.TIPS
;("kingdomMapCtrl")[gErrDef.Err_RUINS_WAR_PLAYER_IS_IN_TEAM] = errType.TIPS
;("kingdomMapCtrl")[gErrDef.Err_RUINS_WAR_HAS_INVITE] = errType.REFRESH
;("kingdomMapCtrl")[gErrDef.Err_RUINS_WAR_MEMBER_NOT_ENOUGH] = errType.TIPS
;("kingdomMapCtrl")[gErrDef.Err_RUINS_WAR_TEAM_NOT_MATCH] = errType.REFRESH
;("kingdomMapCtrl")[gErrDef.Err_RUINS_WAR_NOT_IN_BATTLE_STATE] = errType.REFRESH
;("kingdomMapCtrl")[gErrDef.Err_RUINS_WAR_HAVE_WOUNDEDARMY] = errType.NONE
;("kingdomMapCtrl")[gErrDef.Err_RUINS_WAR_HAS_MASS_QUEUE] = errType.TIPS
;("kingdomMapCtrl")[gErrDef.Err_RUINS_WAR_PLAYER_NOT_APPLY] = errType.REFRESH
;("kingdomMapCtrl")[gErrDef.Err_RUINS_WAR_QUIT_BATTLE_FAIL] = errType.TIPS
;("kingdomMapCtrl")[gErrDef.Err_RUINS_WAR_TEAM_NAME_LENGTH] = errType.TIPS
;("kingdomMapCtrl")[gErrDef.Err_RUINS_WAR_ALREADY_SHARED] = errType.TIPS
;("kingdomMapCtrl")[gErrDef.Err_RUINS_WAR_SHARE_ERROR_CDTIME] = errType.TIPS
;("kingdomMapCtrl")[gErrDef.Err_NOT_FOUND_TEAM] = errType.CLOSE
;("kingdomMapCtrl")[gErrDef.Err_IN_TEAM] = errType.TIPS
;("kingdomMapCtrl")[gErrDef.Err_NOT_IN_TEAM] = errType.CLOSE
;("kingdomMapCtrl")[gErrDef.Err_TEAM_ALREADY_IS_MEMBER] = errType.CLOSE
;("kingdomMapCtrl")[gErrDef.Err_TEAM_MEMBER_FULL] = errType.CLOSE
;("kingdomMapCtrl")[gErrDef.Err_TEAM_LOCK] = errType.CLOSE
;("kingdomMapCtrl")[gErrDef.Err_TEAM_APPLY_INVALID] = errType.CLOSE
;("kingdomMapCtrl")[gErrDef.Err_TEAM_REPEAT_APPLY] = errType.CLOSE
;("kingdomMapCtrl")[gErrDef.Err_TEAM_INVITE_INVALID] = errType.CLOSE
local ("kingdomMapCtrl")[gErrDef.Err_TEAM_REPEAT_INVITE], codeConfig = errType.TIPS, "kingdomMapCtrl"
function remainsWarUtil.getErrType(err)
	local et = codeConfig[err] or errType.NONE
	return et
end
function remainsWarUtil.checkTeamName(teamName)
	local err = gErrDef.Err_None
	if teamName == nil or string.utf8len(teamName) < 3 then
		err = gErrDef.Err_RUINS_WAR_TEAM_NAME_LENGTH
	else
	end
	return err
end
function remainsWarUtil.checkTeamBase()
	local err = gErrDef.Err_None
	if remainsTeamCtrl:isHasTeam() then
		err = gErrDef.Err_RUINS_WAR_HAVE_TEAM
	else
		local buiLevel = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
		local castle_limited = _G.CASTLE_LV27_LIMITED
		if buiLevel < castle_limited then
			err = gErrDef.Err_RUINS_WAR_CASTLE_LV_NOT_ENOUGH
		elseif not remainsTeamCtrl:isWarMatchBegin() then
			err = gErrDef.Err_RUINS_WAR_NOT_IN_MATCH_STATE
		else
			if not remainsTeamCtrl:isPlayerHasBattleTimes() then
				err = gErrDef.Err_RUINS_WAR_TEAM_BATTLE_TIMES
			else
			end
		end
	end
	return err
end
function remainsWarUtil.checkCreateTeam()
	local err
	err = remainsWarUtil.checkTeamBase()
	if err == gErrDef.Err_None then
	end
	return err
end
function remainsWarUtil.checkJoinTeam()
	local err
	err = remainsWarUtil.checkTeamBase()
	if err == gErrDef.Err_None then
	end
	return err
end
function remainsWarUtil.checkInviteJoin()
	local err
	err = remainsWarUtil.checkTeamBase()
	if err == gErrDef.Err_None then
	end
	return err
end
function remainsWarUtil.checkAdjustTeam()
	local err = gErrDef.Err_None
	return err
end
function remainsWarUtil.checkMatch()
	local err = gErrDef.Err_None
	if not remainsTeamCtrl:isTeamLeader() then
		err = gErrDef.Err_RUINS_WAR_NOT_TEAM_LEADER
	else
		local memberNum = remainsTeamCtrl:getTeamMemberNum()
		if memberNum < _G.TEAM_MEMBER_MIN then
			err = gErrDef.Err_RUINS_WAR_MEMBER_NOT_ENOUGH
		else
		end
	end
	return err
end
function remainsWarUtil.checkCaneclMatch()
	local err = gErrDef.Err_None
	if not remainsTeamCtrl:isTeamLeader() then
		err = gErrDef.Err_RUINS_WAR_NOT_TEAM_LEADER
	else
	end
	return err
end
function remainsWarUtil.checkEnterBattleField()
	local err = gErrDef.Err_None
	if not remainsTeamCtrl:isTeamCanInWar() then
		err = gErrDef.Err_RUINS_WAR_TEAM_NOT_MATCH
	elseif armyCtrl:getCuringArmyCount() > 0 then
		err = gErrDef.Err_RUINS_WAR_HAVE_WOUNDEDARMY
		SoraDShowMsgBox(i18n("remains_text_63"), i18n("common_text_054"), nil, nil)
	elseif 0 < armyCtrl:getTotalWoundedArmyCount() then
		err = gErrDef.Err_RUINS_WAR_HAVE_WOUNDEDARMY
		SoraDShowMsgBox(i18n("remains_text_63"), i18n("common_text_402"), nil, function(eventType)
			if eventType == MSGBOX_CALLBACK_YES then
				local worldMapWarDef = include("worldMapWarDef")
				worldMapWarDef.openHospitalView()
			end
		end)
	elseif kingdomMapCtrl.kingdomMapCell:hasWoundedQueueArmy() then
		err = gErrDef.Err_RUINS_WAR_HAVE_WOUNDEDARMY
		SoraDShowMsgTip(i18n("remains_text_171"))
	else
		local queueCtrl = gametop.playertop_:getModule("queueCtrl")
		if queueCtrl:queryQueue(gQueueTypeDef.prompt_army) then
			err = gErrDef.Err_RUINS_WAR_HAVE_WOUNDEDARMY
			SoraDShowMsgBox(i18n("remains_text_183"), i18n("common_text_477"), nil, function(eventType)
				if eventType == MSGBOX_CALLBACK_YES then
					uiManager:show("troopFlagView")
				end
			end)
		else
			local haveMass = kingdomMapCtrl:isHasMassQueue()
			if haveMass then
				err = gErrDef.Err_RUINS_WAR_HAS_MASS_QUEUE
			else
			end
		end
	end
	return err
end
function remainsWarUtil.checkQutiBattleField()
	local err = gErrDef.Err_None
	do
		local haveMass = kingdomMapCtrl:isHasMassQueue()
		if haveMass then
			err = gErrDef.Err_RUINS_WAR_HAS_MASS_QUEUE
		else
		end
	end
	return err
end
function remainsWarUtil.caclulateMatchPoint(memberList)
	local total = 0
	for _, v in ipairs(memberList) do
		total = total + v.rankScore
	end
	local memberNum = #memberList
	local matchPoint = 0
	if 0 < memberNum then
		matchPoint = total / memberNum
		matchPoint = matchPoint * (memberNum + 8) / 16
		matchPoint = math.ceil(matchPoint)
	end
	return matchPoint
end
function remainsWarUtil.errShowTips(err)
	if err == gErrDef.Err_None then
		return
	end
	if err == gErrDef.Err_RUINS_WAR_CASTLE_LV_NOT_ENOUGH then
		local castle_limited = _G.CASTLE_LV27_LIMITED
		_ENV = nil
		;(nil).num = castle_limited
		SoraDShowMsgTip(i18n("common_text_1795", nil))
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
			elseif "function" == type(fun) then
			end
		else
			_ENV = type(fun)
			type(fun).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			type(fun).messageID = err
			SoraDSendMessage((type(fun)))
		end
	end
end
local MONSTER_RECT_MY = cc.rect(0, 0, 10, 10)
local MONSTER_RECT_ZJSSG = cc.rect(59, 59, 10, 10)
local PLAYER_BORN_RECT_SOUTH = cc.rect(0, 59, 10, 10)
local PLAYER_BORN_RECT_NORTH = cc.rect(59, 0, 10, 10)
local MONSTER_BORN_RECT_WEST = cc.rect(4, 4, 1, 1)
local MONSTER_BORN_RECT_EAST = cc.rect(63, 63, 1, 1)
function remainsWarUtil.checkIsInMonsterArea(rect, point)
	if cc.rectContainsPoint(rect, point) then
		return true
	end
	return false
end
function remainsWarUtil.checkIsInForbidAreaZhanling(point)
	local bRet
	bRet = remainsWarUtil.checkIsInMonsterArea(MONSTER_BORN_RECT_WEST, point)
	bRet = bRet or remainsWarUtil.checkIsInMonsterArea(MONSTER_BORN_RECT_EAST, point)
	return bRet
end
function remainsWarUtil.checkIsInForbidArea(point)
	local bRet
	bRet = remainsWarUtil.checkIsInMonsterArea(PLAYER_BORN_RECT_SOUTH, point)
	if not bRet then
		bRet = remainsWarUtil.checkIsInMonsterArea(PLAYER_BORN_RECT_NORTH, point)
		if not bRet then
			bRet = remainsWarUtil.checkIsInMonsterArea(MONSTER_BORN_RECT_WEST, point)
			bRet = bRet or remainsWarUtil.checkIsInMonsterArea(MONSTER_BORN_RECT_EAST, point)
		end
	end
	return bRet
end
_ENV, remainsWarUtil.checkIsInBornArea = function(point)
	local bRet
	bRet = remainsWarUtil.checkIsInMonsterArea(PLAYER_BORN_RECT_SOUTH, point)
	bRet = bRet or remainsWarUtil.checkIsInMonsterArea(PLAYER_BORN_RECT_NORTH, point)
	return bRet
end, function(point)
	local bRet
	bRet = remainsWarUtil.checkIsInMonsterArea(PLAYER_BORN_RECT_SOUTH, point)
	bRet = bRet or remainsWarUtil.checkIsInMonsterArea(PLAYER_BORN_RECT_NORTH, point)
	return bRet
end
;(function(point)
	local bRet
	bRet = remainsWarUtil.checkIsInMonsterArea(PLAYER_BORN_RECT_SOUTH, point)
	bRet = bRet or remainsWarUtil.checkIsInMonsterArea(PLAYER_BORN_RECT_NORTH, point)
	return bRet
end)[6] = 500
local (function(point)
	local bRet
	bRet = remainsWarUtil.checkIsInMonsterArea(PLAYER_BORN_RECT_SOUTH, point)
	bRet = bRet or remainsWarUtil.checkIsInMonsterArea(PLAYER_BORN_RECT_NORTH, point)
	return bRet
end)[7], BOSS_BUFF_ADD = 500, function(point)
	local bRet
	bRet = remainsWarUtil.checkIsInMonsterArea(PLAYER_BORN_RECT_SOUTH, point)
	bRet = bRet or remainsWarUtil.checkIsInMonsterArea(PLAYER_BORN_RECT_NORTH, point)
	return bRet
end
if not _G.IsArClient then
	_ENV = _G.IsArClient
	_G.IsArClient[10] = 500
	BOSS_BUFF_ADD, _G.IsArClient[11] = _G.IsArClient, 500
end
function remainsWarUtil.getBossBuffByID(bossID)
	return BOSS_BUFF_ADD[bossID] or 0
end
function remainsWarUtil.checkIsInMonsterBuffAddArea(point)
	local monsterID = 0
	do
		local bRet = remainsWarUtil.checkIsInMonsterArea(MONSTER_RECT_MY, point)
		if bRet then
			monsterID = _G.IsArClient and 6 or 10
		end
		bRet = remainsWarUtil.checkIsInMonsterArea(MONSTER_RECT_ZJSSG, point)
		if bRet then
			monsterID = _G.IsArClient and 7 or 11
		end
	end
	return monsterID
end
function remainsWarUtil.checkIsInMonsterAreaMy(point)
	return remainsWarUtil.checkIsInMonsterArea(MONSTER_RECT_MY, point)
end
function remainsWarUtil.checkIsInMonsterAreaZJSSG(point)
	return remainsWarUtil.checkIsInMonsterArea(MONSTER_RECT_ZJSSG, point)
end
function remainsWarUtil.isForbitWarByInBorn()
	if worldMapDefine.isInRemains() then
		local myCityTilePoint = cityCtrl:getCurCityPos()
		dump(myCityTilePoint, "myCityTilePoint", 10)
		return remainsWarUtil.checkIsInBornArea(myCityTilePoint)
	end
end
function remainsWarUtil.checkJoinAllianceInvite()
	local err
	err = remainsWarUtil.checkTeamBase()
	if err == gErrDef.Err_None and remainsTeamCtrl:isHasTeam() then
		err = gErrDef.Err_RUINS_WAR_HAVE_TEAM
	else
	end
	return err
end
function remainsWarUtil.doAllianceInvite(values, check)
	local err = remainsWarUtil.checkJoinAllianceInvite()
	if gErrDef.Err_None == err then
		local panel = SoraDCreatePanel("teamDispatchArmyView")
		panel:show()
		panel:initAddView(values)
		return true
	elseif err == gErrDef.Err_RUINS_WAR_HAVE_TEAM then
		SoraDShowMsgTip(i18n("remains_text_56"))
	else
		remainsWarUtil.errShowTips(err)
	end
end
function remainsWarUtil.addVSEffect(nodeVS)
	_ENV, _ENV = nil, nil
	;(nil).plist = "et_pipeivs_01.plist"
	_ENV, (nil)[1], (nil).scale = nil, nil, 0.76
	_ENV, (nil).plist = nil, "et_wupinbeijing_01.plist"
	;(nil).x = -3.4
	;(nil).pos, (nil).y = nil, -6.96
	_ENV, (nil)[2], (nil).scale = nil, nil, 1.95
	;(nil).plist = "et_orangebx_02.plist"
	;(nil).pos = cc.p(-4, 0)
	;(nil)[3], (nil).scale = nil, 1.85
	local param
	local et_node = SoraDCreateEffectNode(param)
	et_node:addTo(nodeVS, 2)
end
function remainsWarUtil.addVSAnimation(panel, spVSBG)
	local showEffect = function()
		local act_eBg = SoraDCreatAnimation("etNodeVS")
		local v = SoraDGetChildByName(act_eBg, "Sprite_VS")
		if v:isOpacityModifyRGB() then
			v:setBlendFunc(gl.ONE, gl.ONE)
		else
			v:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
		end
		act_eBg:setPosition(cc.p(spVSBG:getContentSize().width / 2, spVSBG:getContentSize().height / 2))
		act_eBg:addTo(spVSBG, 10)
	end
	if _G.SoraDIsFileExistByKey("vsmvp") then
		_ENV, _UPVALUE1_ = "vsmvp", _G.SoraDIsFileExistByKey("vsmvp")
		;("vsmvp").name = "Common/vsmvp"
		local _G.SoraDIsFileExistByKey("vsmvp")[1], imgArray = "vsmvp", _G.SoraDIsFileExistByKey("vsmvp")
		panel:loadImages(imgArray, function()
			showEffect()
		end)
	end
end
function remainsWarUtil.addMvpEffect(spMVP)
	_ENV, _ENV = nil, nil
	;(nil).plist = "et_vsmvp_01.plist"
	;(nil)[1], (nil).scale = nil, 1.23
	local param
	local et_node = SoraDCreateEffectNode(param)
	et_node:setPosition(cc.p(30, 30))
	et_node:addTo(spMVP, 2)
end
function remainsWarUtil.addMVPAnimation(panel, spMVP)
	local showEffect = function()
		local act_eBg = SoraDCreatAnimation("etNodeMVP")
		local v = SoraDGetChildByName(act_eBg, "Sprite_MVP")
		if v:isOpacityModifyRGB() then
			v:setBlendFunc(gl.ONE, gl.ONE)
		else
			v:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
		end
		act_eBg:addTo(spMVP, 10)
		act_eBg:setPosition(cc.p(25, 20.5))
	end
	if _G.SoraDIsFileExistByKey("vsmvp") then
		_ENV, _UPVALUE1_ = "vsmvp", _G.SoraDIsFileExistByKey("vsmvp")
		;("vsmvp").name = "Common/vsmvp"
		local _G.SoraDIsFileExistByKey("vsmvp")[1], imgArray = "vsmvp", _G.SoraDIsFileExistByKey("vsmvp")
		panel:loadImages(imgArray, function()
			showEffect()
		end)
	end
end
function remainsWarUtil.checkResultShare()
	local err = gErrDef.Err_None
	if remainsTeamCtrl:isRemainsWarShared() then
		err = gErrDef.Err_RUINS_WAR_ALREADY_SHARED
	else
	end
	return err
end
function remainsWarUtil.checkHistoryShare()
	local err = gErrDef.Err_None
	if remainsTeamCtrl:getHistoryShareLeftCDTime() > 0 then
		err = gErrDef.Err_RUINS_WAR_SHARE_ERROR_CDTIME
	else
	end
	return err
end
function remainsWarUtil.doOpenShareSettleInfo(customData)
	if not customData.values then
		local _ENV, values = customData.values, customData.values
	end
	local panel = SoraDCreatePanel("remainsWarResultShareView")
	panel:show()
	panel:initData(values)
end
function remainsWarUtil.doOpenShareSeasonInfo(customData, serverMsg)
	if not customData.values.seasonInfo then
		local _ENV, info = customData.values.seasonInfo, customData.values.seasonInfo
	end
	local panel = SoraDCreatePanel("remainsWarHistoryShareView")
	panel:show()
	panel:initData(info, serverMsg)
end
function remainsWarUtil.checkIsInRemainsXianXia(showTips)
	if not include("pyramidWarltCtrl").checkPwXianXiaSai(not showTips) then
		return true
	end
	return false
end
function remainsWarUtil.checkIsReqSyncRw()
	return SoraDIsAnchor()
end
function remainsWarUtil.isSelfIn(data)

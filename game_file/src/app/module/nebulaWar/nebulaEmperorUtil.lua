local gametop = gModuleMgr.getObject("gametop")
local nebulaEmperorCtrl = SoraDGetCtrl("nebulaEmperorCtrl")
local nebulaEmperorRead = include("nebulaEmperorRead")
local _ENV, nebulaEmperorUtil = "nebulaEmperorRead", "nebulaEmperorRead"
function nebulaEmperorUtil.getRelationType(fromCamp, selfCamp)
	selfCamp = selfCamp or nebulaEmperorCtrl:getSelfCamp()
	local relationType = gMapAllianceRelationType.NORMAL
	if fromCamp and 0 < fromCamp then
		if fromCamp == selfCamp then
			relationType = gMapAllianceRelationType.SELF
		else
			relationType = gMapAllianceRelationType.ENEMY
		end
	end
	return relationType
end
function nebulaEmperorUtil.getTeamRemainNum()
	local myTeamInfo = nebulaEmperorCtrl:getMyTeamInfo()
	local num = myTeamInfo:getTeamMemberNum()
	local merberMax = nebulaEmperorRead.getTeamNumMax()
	return math.max(0, merberMax - num)
end
function nebulaEmperorUtil.getAreaName(regionId)
	regionId = regionId or nebulaEmperorCtrl:getSelfCamp()
	local nebulaWarRead = include("nebulaWarRead")
	return nebulaWarRead.getAreaName(regionId)
end
function nebulaEmperorUtil.getAreaBigIcon(regionId)
	regionId = regionId or nebulaEmperorCtrl:getSelfCamp()
	local nebulaWarRead = include("nebulaWarRead")
	return nebulaWarRead.getAreaBigIcon(regionId)
end
function nebulaEmperorUtil.getAreaIcon(regionId)
	regionId = regionId or nebulaEmperorCtrl:getSelfCamp()
	local nebulaWarRead = include("nebulaWarRead")
	return nebulaWarRead.getAreaIcon(regionId)
end
function nebulaEmperorUtil.getTeamName(regionId)
	regionId = regionId or nebulaEmperorCtrl:getSelfCamp()
	local nebulaWarRead = include("nebulaWarRead")
	local areaAbbr = nebulaWarRead.getAreaAbbr(regionId)
	local teamName = nebulaEmperorUtil.getTeamNameRaw(regionId)
	nebulaEmperorCtrl = nil
	;(nil).abbr = areaAbbr
	;(nil).name = teamName
	return i18n("common_text_186", nil)
end
function nebulaEmperorUtil.getTeamNameRaw(regionId)
	regionId = regionId or nebulaEmperorCtrl:getSelfCamp()
	local areaName = nebulaEmperorUtil.getAreaName(regionId)
	nebulaEmperorCtrl = nil
	;(nil).name = areaName
	return i18n("nebulaemperor_text_31", nil)
end
function nebulaEmperorUtil.checkEnterBattleField(enterCallback)
	local myTeamInfo = nebulaEmperorCtrl:getMyTeamInfo()
	if not myTeamInfo:isHasTeam() then
		SoraDShowMsgBox(i18n("nebulaemperor_text_8"), i18n("common_text_477"), nil, function(callType)
			if callType == MSGBOX_CALLBACK_YES then
				nebulaEmperorUtil.openTeamView()
			end
		end)
		return
	end
	local armyCtrl = SoraDGetCtrl("armyCtrl")
	if armyCtrl:getCuringArmyCount() > 0 or 0 < armyCtrl:getTotalWoundedArmyCount() then
		SoraDShowMsgBox(i18n("nebulaemperor_text_10"), i18n("common_text_402"), nil, function(eventType)
			if eventType == MSGBOX_CALLBACK_YES then
				local worldMapWarDef = include("worldMapWarDef")
				worldMapWarDef.openHospitalView()
			end
		end)
		return
	end
	if worldMapDefine.inInCrossWar() then
		SoraDShowMsgTip(i18n("atlantiswar_text_0009"))
		return
	end
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	if kingdomMapCtrl:isHasQueue() ~= 0 then
		SoraDShowMsgTip(i18n("atlantiswar_text_0010"))
		return
	end
	enterCallback()
	return true
end
function nebulaEmperorUtil.reqQuitBattlefield(...)
	nebulaEmperorCtrl:reqQuitBattlefield()
	SoraDShowLoading()
end
function nebulaEmperorUtil.checkWoundedCount(...)
	local armyCtrl = SoraDGetCtrl("armyCtrl")
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local woundedCount = armyCtrl:getTotalWoundedArmyCount()
	local curingNum = armyCtrl:getCuringArmyCount() or 0
	if 0 < woundedCount and 0 < woundedCount - curingNum or kingdomMapCtrl.kingdomMapCell:hasWoundedQueueArmy() then
		return true
	else
		return false
	end
end
function nebulaEmperorUtil.gotoQuitBattleField(...)
	local quitBattleField = function()
		if nebulaEmperorUtil.isWarTest() and nebulaEmperorUtil.checkWoundedCount() then
			SoraDShowMsgTip(i18n("nebulaemperor_text_236"))
			return
		end
		local showMsg = i18n("nebulaemperor_text_226")
		if nebulaEmperorUtil.checkActivityState(ACTIVITY_STATE.ACTIVE) then
			showMsg = i18n("atlantiswar_text_0016")
		end
		if not nebulaEmperorUtil.isWarTest() then
			local armyLogic = include("armyLogic")
			if armyLogic.isUnlockWarTechnology() and SoraDIsBrave8Level() then
				local percent = nebulaEmperorRead.getCostResPercent() * 100
				nebulaEmperorUtil = i18n("nebulaemperor_text_236")
				i18n("nebulaemperor_text_236").percent = percent
				showMsg = i18n("nebulaemperor_text_73", i18n("nebulaemperor_text_236")) .. showMsg
			end
		end
		SoraDShowMsgBox(showMsg, i18n("common_text_204"), i18n("common_text_185"), function(callType)
			if callType == MSGBOX_CALLBACK_YES then
				nebulaEmperorUtil.reqQuitBattlefield()
			end
		end)
	end
	if nebulaEmperorUtil.checkWoundedCount() then
		local panel = SoraDCreatePanel("legendGoBackTips")
		panel:setHandle(function()
			quitBattleField()
		end)
		panel:show()
	else
		quitBattleField()
	end
end
function nebulaEmperorUtil.checkJoinTeam(...)
	local starLv = nebulaEmperorRead.getNeedLv()
	if starLv > SoraDGetBuildStarLv() then
		nebulaEmperorRead = nil
		;(nil).lv = starLv
		SoraDShowMsgTip(i18n("nebulaemperor_text_42", nil))
		return
	end
	return true
end
function nebulaEmperorUtil.checkQuitTeamState(...)
	if nebulaEmperorUtil.checkActivityState(ACTIVITY_STATE.ACTIVE) then
		return
	end
	return true
end
function nebulaEmperorUtil.checkActivityState(state)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local curState = activityShowCtrl:getParamCurState(gActivityTimeActivityID.NEBULA_EMPEROR_ACTIVITY)
	return curState == state
end
function nebulaEmperorUtil.openTeamView()
	if not nebulaEmperorUtil.checkActivityState(ACTIVITY_STATE.PREPARE) and not nebulaEmperorUtil.checkActivityState(ACTIVITY_STATE.ACTIVE) then
		SoraDShowMsgTip(i18n("nebulaemperor_text_240"))
		return
	end
	uiManager:show("NebulaEmperorTeam")
end
function nebulaEmperorUtil.getTeamChatAction(...)
	_UPVALUE7_ = nil
	;(nil)[1] = ffa.delay(1.0)
	;(nil)[2] = ffa.rotateTo(0.25, 10)
	;(nil)[3] = ffa.rotateTo(0.21666666666666667, -10)
	;(nil)[4] = ffa.rotateTo(0.2, 8)
	;(nil)[5] = ffa.rotateTo(0.16666666666666666, -5)
	;(nil)[6] = ffa.rotateTo(0.15, 2)
	;(nil)[7] = ffa.rotateTo(0.15, 0)
	;(nil)[8] = ffa.delay(1.0)
	;(nil)[9] = ffa.delay(1.0)
	local seq = ffa.seq(nil)
	return ffa.repeatForever(seq)
end
function nebulaEmperorUtil.getHandler_onClickHelp(...)
	return function()
		SoraDPlaySound()
		nebulaEmperorUtil.showSingleFAQ()
	end
end
_ENV, nebulaEmperorUtil.showSingleFAQ = function(...)
	userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.NEBULA_EMPEROR)
end, function(...)
	userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.NEBULA_EMPEROR)
end
;(function(...)
	userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.NEBULA_EMPEROR)
end).WarArea = 1
;(function(...)
	userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.NEBULA_EMPEROR)
end).Edge = 2
;(function(...)
	userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.NEBULA_EMPEROR)
end).CoreArea = 3
;(function(...)
	userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.NEBULA_EMPEROR)
end).Born = 4
local (function(...)
	userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.NEBULA_EMPEROR)
end).ForbidArea, Area_Type = 10, function(...)
	userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.NEBULA_EMPEROR)
end
function nebulaEmperorUtil.checkIsInForbidArea(targetRect)
	local list = nebulaEmperorRead.getBuildIDListByType(1)
	for __, buildID in ipairs(list) do
		local pos = nebulaEmperorRead.getBuildPos(buildID)
		local size = nebulaEmperorRead.getBuildSize(buildID)
		local radius = nebulaEmperorRead.getConstValue("prohibitFrame1", 10)
		local width = size + radius * 2 - 1
		local forbidRect = cc.rect(pos.x - radius, pos.y - radius, width, width)
		if cc.rectIntersectsRect(targetRect, forbidRect) then
			return true
		end
	end
	local list = nebulaEmperorRead.getBuildIDListByType(2)
	for __, buildID in ipairs(list) do
		local pos = nebulaEmperorRead.getBuildPos(buildID)
		local size = nebulaEmperorRead.getBuildSize(buildID)
		local radius = nebulaEmperorRead.getConstValue("prohibitFrame2", 5)
		local width = size + radius * 2 - 1
		local forbidRect = cc.rect(pos.x - radius, pos.y - radius, width, width)
		if cc.rectIntersectsRect(targetRect, forbidRect) then
			return true
		end
	end
	return false
end
function nebulaEmperorUtil.checkIsInArea(targetRect, areaType, camp)
	if areaType == Area_Type.ForbidArea then
		return nebulaEmperorUtil.checkIsInForbidArea(targetRect)
	end
	local cfgs = nebulaEmperorRead.getMapAreaConfig(areaType, camp)
	if not next(cfgs) then
		return false
	end
	for __, cfg in ipairs(cfgs) do
		_UPVALUE4_ = nil
		;(nil)[1] = "beginX"
		;(nil)[2] = "beginY"
		;(nil)[3] = "endX"
		;(nil)[4] = "endY"
		local rects = serviceFunctions.tableFormat(cfg, nil)
		for __, rect in ipairs(rects) do
			local clientPos = cc.p(rect.beginX, rect.beginY)
			local width = rect.endX - rect.beginX + 1
			local height = rect.endY - rect.beginY + 1
			local forbidRect = cc.rect(clientPos.x, clientPos.y, width - 1, height - 1)
			if cc.rectIntersectsRect(targetRect, forbidRect) then
				return true
			end
		end
	end
	return false
end
function nebulaEmperorUtil.checkIsCanTransfer(targetRect)
	if nebulaEmperorUtil.checkIsInArea(targetRect, Area_Type.WarArea) then
		if nebulaEmperorUtil.checkIsInArea(targetRect, Area_Type.ForbidArea) then
			return false, worldMapLayInstanceTypeErrorDef.nebulaEmperor_forbid
		end
		return true
	end
	if nebulaEmperorUtil.checkIsInArea(targetRect, Area_Type.Edge) then
		return false, worldMapLayInstanceTypeErrorDef.nebulaEmperor_edge
	end
	local selfCamp = nebulaEmperorCtrl:getSelfCamp()
	if not nebulaEmperorUtil.checkIsInArea(targetRect, Area_Type.Born, selfCamp) then
		return false, worldMapLayInstanceTypeErrorDef.nebulaEmperor_born
	end
	return true
end
function nebulaEmperorUtil.checkIsCanZhanling(point)
	if nebulaEmperorUtil.isForbitWarByInBorn() then
		return false, i18n("nebulaemperor_text_220")
	end
	local targetRect = cc.rect(point.x, point.y, 0, 0)
	if nebulaEmperorUtil.checkIsInArea(targetRect, Area_Type.WarArea) then
		if nebulaEmperorUtil.checkIsInArea(targetRect, Area_Type.ForbidArea) then
			return false, i18n("nebulaemperor_text_231")
		end
		return true
	end
	if nebulaEmperorUtil.checkIsInArea(targetRect, Area_Type.Edge) then
		return false, i18n("nebulaemperor_text_234")
	end
	return false, i18n("nebulaemperor_text_138")
end
function nebulaEmperorUtil.isForbitWarByInBorn()
	if worldMapDefine.isInNebulaEmperor() then
		local cityCtrl = SoraDGetCtrl("cityCtrl")
		local cityPos = cityCtrl:getCurCityPos()
		return nebulaEmperorUtil.isTileInBornArea(cityPos)
	end
end
function nebulaEmperorUtil.isTileInBornArea(tile)
	local targetRect = cc.rect(tile.x, tile.y, 0, 0)
	return nebulaEmperorUtil.checkIsInArea(targetRect, Area_Type.Born)
end
function nebulaEmperorUtil.getMapBuildPosition(subType)
	_ENV = nil
	;(nil)[gWorldTypeServerDef.subTypeNebulaEmperorWarPalace] = cc.p(-90, 50)
	;(nil)[gWorldTypeServerDef.subTypeNebulaEmperorWarTower] = cc.p(-135, 125)
	local (nil)[gWorldTypeServerDef.subTypeNebulaEmperorWarCamp], config = cc.p(-32, 88), nil
	return config[subType] or cc.p(0, 0)
end
function nebulaEmperorUtil.checkIsInWarFog(tilePos)
	local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
	local hegemonyRegion = nebulaActivityCtrl:getHegemonyRegionData()
	local regionCount = #hegemonyRegion
	if 10 <= regionCount then
		return false
	end
	local targetRect = cc.rect(tilePos.x, tilePos.y, 0, 0)
	for regionID = regionCount + 1, 10 do
		if nebulaEmperorUtil.checkIsInArea(targetRect, Area_Type.Born, regionID) then
			return true
		end
	end
	return false
end
function nebulaEmperorUtil.isWarTest()
	local flag = nebulaEmperorRead.getConstValue("nebulaemperortest", 0)
	return 0 < flag
end
function nebulaEmperorUtil.openGiftView(...)
	if nebulaEmperorUtil.isWarTest() then
		SoraDShowMsgTip(i18n("nebulaemperor_text_238"))
		return
	end
	uiManager:show("NebulaEmperorGift")
end
return nebulaEmperorUtil

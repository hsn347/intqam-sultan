local gametop = gModuleMgr.getObject("gametop")
local armyCtrl = SoraDGetCtrl("armyCtrl")
local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
local atlantisActivityCtrl = SoraDGetCtrl("atlantisActivityCtrl")
local atlantisWarCtrl = SoraDGetCtrl("atlantisWarCtrl")
local mapSyncUtilClient = include("mapSyncUtilClient")
local _ENV, atlantisWarUtil = "mapSyncUtilClient", "mapSyncUtilClient"
function atlantisWarUtil.checkAreaState(point, otherData)
	if not otherData then
		otherData, atlantisWarUtil = nil, nil
	end
	if atlantisWarUtil.checkIsBattleAreaAndNotOpen(point) then
		atlantisWarUtil = atlantisWarUtil.checkIsBattleAreaAndNotOpen(point)
		atlantisWarUtil.checkIsBattleAreaAndNotOpen(point).isCanZhanling = false
		atlantisWarUtil.checkIsBattleAreaAndNotOpen(point).isCanQiancheng = false
		return (atlantisWarUtil.checkIsBattleAreaAndNotOpen(point))
	end
	local ignoreMarshal = otherData.ignoreMarshal
	if not ignoreMarshal then
		local isTouch, ret = atlantisWarUtil.isTouchMarshal(point)
		if isTouch then
			return ret
		end
	end
	local ignoreBlackLand = otherData.ignoreBlackLand
	if not ignoreBlackLand then
		local isTouch, ret = atlantisWarUtil.isTouchBlackLand(point)
		if isTouch then
			return ret
		end
	end
	local mapAtlantisArea = include("mapAtlantisArea")
	local cityCtrl = SoraDGetCtrl("cityCtrl")
	local myPoint = cityCtrl:getCurCityPos()
	local selfArea = atlantisWarCtrl:getSelfCamp()
	local isTargetInBattleArea = mapAtlantisArea.checkInArea(point.x, point.y, ATLANTIS_WAR_AREA.WAR)
	local isSelfInBattleArea = mapAtlantisArea.checkInArea(myPoint.x, myPoint.y, ATLANTIS_WAR_AREA.WAR)
	local isTargetInSelfArea = mapAtlantisArea.checkInArea(point.x, point.y, selfArea)
	local isTransfer = otherData.isTransfer
	if isTransfer or isSelfInBattleArea and isTargetInBattleArea or not isSelfInBattleArea and isTargetInSelfArea then
		local ret = mapAtlantisArea.isTouchTerrain(point)
		if ret then
			local isCanQiancheng = true
			if isTransfer then
				isCanQiancheng = false
			end
			atlantisWarUtil = nil
			;(nil).isCanZhanling = false
			;(nil).isCanQiancheng = isCanQiancheng
			return nil
		end
	end
	local state = 0
	if isTargetInSelfArea then
		state = 1
	elseif not isTargetInBattleArea then
		state = 2
	else
		state = 3
	end
	if isSelfInBattleArea then
		state = state + 3
	end
	_UPVALUE5_, atlantisWarUtil = nil, false
	_UPVALUE5_, (false)[1], (nil)[1] = nil, nil, true
	_UPVALUE5_, (false)[1], (nil)[2] = nil, nil, true
	_UPVALUE5_, (false)[1], (nil)[3] = nil, nil, false
	_UPVALUE5_, (false)[1], (nil)[4] = nil, nil, nil
	_UPVALUE5_, (false)[1], (nil)[5] = nil, nil, nil
	_UPVALUE5_, (false)[1], (nil)[6] = nil, nil, i18n("atlantiswar_text_0252")
	_UPVALUE5_, (false)[1], (nil)[7] = nil, nil, i18n("atlantiswar_text_0252")
	_UPVALUE4_, (false)[2], (nil)[1] = nil, nil, false
	_UPVALUE4_, (false)[2], (nil)[2] = nil, nil, false
	_UPVALUE4_, (false)[2], (nil)[3] = nil, nil, false
	_UPVALUE4_, (false)[2], (nil)[4] = nil, nil, i18n("atlantiswar_text_0059")
	_UPVALUE4_, (false)[2], (nil)[5] = nil, nil, i18n("atlantiswar_text_0239")
	_UPVALUE4_, (false)[2], (nil)[6] = nil, nil, i18n("atlantiswar_text_0252")
	_UPVALUE4_, (false)[2], (nil)[7] = nil, nil, i18n("atlantiswar_text_0252")
	_UPVALUE5_, (false)[3], (nil)[1] = nil, nil, false
	_UPVALUE5_, (false)[3], (nil)[2] = nil, nil, true
	_UPVALUE5_, (false)[3], (nil)[3] = nil, nil, true
	_UPVALUE5_, (false)[3], (nil)[4] = nil, nil, i18n("atlantiswar_text_0062")
	_UPVALUE5_, (false)[3], (nil)[5] = nil, nil, i18n("atlantiswar_text_0237")
	_UPVALUE5_, (false)[3], (nil)[6] = nil, nil, i18n("atlantiswar_text_0237")
	_UPVALUE5_, (false)[3], (nil)[7] = nil, nil, i18n("atlantiswar_text_0237")
	_UPVALUE5_, (false)[4], (nil)[1] = nil, nil, false
	_UPVALUE5_, (false)[4], (nil)[2] = nil, nil, true
	_UPVALUE5_, (false)[4], (nil)[3] = nil, nil, false
	_UPVALUE5_, (false)[4], (nil)[4] = nil, nil, i18n("atlantiswar_text_0063")
	_UPVALUE5_, (false)[4], (nil)[5] = nil, nil, i18n("atlantiswar_text_0238")
	_UPVALUE5_, (false)[4], (nil)[6] = nil, nil, i18n("atlantiswar_text_0252")
	_UPVALUE5_, (false)[4], (nil)[7] = nil, nil, i18n("atlantiswar_text_0252")
	_UPVALUE3_, (false)[5], (nil)[1] = nil, nil, false
	_UPVALUE3_, (false)[5], (nil)[2] = nil, nil, false
	_UPVALUE3_, (false)[5], (nil)[3] = nil, nil, false
	_UPVALUE3_, (false)[5], (nil)[4] = nil, nil, i18n("atlantiswar_text_0059")
	_UPVALUE3_, (false)[5], (nil)[5] = nil, nil, i18n("atlantiswar_text_0239")
	_UPVALUE3_, (false)[5], (nil)[6] = nil, nil, i18n("atlantiswar_text_0252")
	_UPVALUE3_, (false)[5], (nil)[7] = nil, nil, i18n("atlantiswar_text_0252")
	;(false)[6], (nil)[1] = nil, true
	;(false)[6], (nil)[2] = nil, true
	;(false)[6], (nil)[3] = nil, true
	local config = false
	local ret = config[state]
	atlantisWarUtil = true
	;(true).isCanZhanling = ret[1]
	;(true).isCanQiancheng = ret[2]
	;(true).isCanZhencha = ret[3]
	;(true).tipTips = ret[4]
	;(true).clickTips = ret[5]
	;(true).zhenchaTips = ret[6]
	return true
end
function atlantisWarUtil.isTouchBlackLand(point)
	local ABL = require_data("atlantiswar_black_land", true).data
	for i, v in ipairs(ABL) do
		local landPos = mapSyncUtilClient.serverTOClientPos(cc.p(v.x, v.y))
		local size = v.size
		if util.isPointInRect(cc.rect(landPos.x, landPos.y, size - 1, size - 1), point.x, point.y) then
			print("==atlantisWarUtil.isTouchBlackLand==", i)
			local buildName = atlantisWarUtil.getBuildName(i)
			_ENV = point.y
			point.y.name = buildName
			point.y.num1 = size
			point.y.num2 = size
			local tips = i18n("atlantiswar_text_0251", point.y)
			_ENV = point.y
			point.y.isCanZhanling = false
			point.y.isCanQiancheng = false
			point.y.tipTips = tips
			point.y.clickTips = tips
			return true, point.y
		end
	end
	return false
end
function atlantisWarUtil.isTouchMarshal(point)
	local marshalPointList = atlantisWarUtil.getMarshalPointList()
	for i, v in ipairs(marshalPointList) do
		local size = 2
		local tilePoint = v.tilePoint
		local buildId = v.buildId
		if util.isPointInRect(cc.rect(tilePoint.x, tilePoint.y, size - 1, size - 1), point.x, point.y) then
			local ret, tips = atlantisWarUtil.checkCanMoveInMarshal(buildId)
			if ret then
				atlantisWarUtil = point.y
				point.y.isCanZhanling = false
				point.y.isCanQiancheng = true
				point.y.clickTips = i18n("common_text_485")
				return true, point.y
			else
				atlantisWarUtil = point.y
				point.y.isCanZhanling = false
				point.y.isCanQiancheng = false
				point.y.clickTips = tips
				point.y.clickZhanlingTips = i18n("common_text_485")
				return true, point.y
			end
		end
	end
end
function atlantisWarUtil.checkIsBattleAreaAndNotOpen(point)
	local mapAtlantisArea = include("mapAtlantisArea")
	local isInBattleArea = mapAtlantisArea.checkInArea(point.x, point.y, ATLANTIS_WAR_AREA.WAR)
	if isInBattleArea then
		local time = atlantisWarCtrl:getWarStageRemainTime(gAtlantisWarStageType.warAreaReady)
		if 0 < time then
			return true
		end
	end
end
function atlantisWarUtil.checkCanMoveInMarshal(buildId)
	local marshalMap = atlantisWarCtrl:getMarshalMap()
	local marshalData = marshalMap[tostring(buildId)]
	if marshalData and marshalData.camp == atlantisWarCtrl:getSelfCamp() then
		local memberClass = atlantisWarCtrl:getSelfMemberClass()
		if 3 <= memberClass then
			return true
		else
			return false, i18n("atlantiswar_text_0095")
		end
	end
	local AMBC = require_data("atlantiswar_map_build_config").data
	atlantisWarCtrl = i18n("atlantiswar_text_0095")
	i18n("atlantiswar_text_0095").var = i18n(AMBC[buildId].name)
	local errTips = i18n("atlantiswar_text_0093", i18n("atlantiswar_text_0095"))
	return false, errTips
end
local _ENV, marshalPointList = function(buildId)
	local marshalMap = atlantisWarCtrl:getMarshalMap()
	local marshalData = marshalMap[tostring(buildId)]
	if marshalData and marshalData.camp == atlantisWarCtrl:getSelfCamp() then
		local memberClass = atlantisWarCtrl:getSelfMemberClass()
		if 3 <= memberClass then
			return true
		else
			return false, i18n("atlantiswar_text_0095")
		end
	end
	local AMBC = require_data("atlantiswar_map_build_config").data
	atlantisWarCtrl = i18n("atlantiswar_text_0095")
	i18n("atlantiswar_text_0095").var = i18n(AMBC[buildId].name)
	local errTips = i18n("atlantiswar_text_0093", i18n("atlantiswar_text_0095"))
	return false, errTips
end, function(buildId)
	local marshalMap = atlantisWarCtrl:getMarshalMap()
	local marshalData = marshalMap[tostring(buildId)]
	if marshalData and marshalData.camp == atlantisWarCtrl:getSelfCamp() then
		local memberClass = atlantisWarCtrl:getSelfMemberClass()
		if 3 <= memberClass then
			return true
		else
			return false, i18n("atlantiswar_text_0095")
		end
	end
	local AMBC = require_data("atlantiswar_map_build_config").data
	atlantisWarCtrl = i18n("atlantiswar_text_0095")
	i18n("atlantiswar_text_0095").var = i18n(AMBC[buildId].name)
	local errTips = i18n("atlantiswar_text_0093", i18n("atlantiswar_text_0095"))
	return false, errTips
end
function atlantisWarUtil.getMarshalPointList(...)
	if next(marshalPointList) then
		return marshalPointList
	end
	_UPVALUE3_ = marshalPointList
	marshalPointList[1] = 902
	marshalPointList[2] = 903
	local marshalPointList[3], buildings = 904, marshalPointList
	local AMB = require_data("atlantiswar_map_build", true).data
	local _ENV, config = "atlantiswar_map_build", "atlantiswar_map_build"
	for i, v in ipairs(buildings) do
		local param = AMB[v].actionParam
		local x, y = serviceFunctions.getPosFromMapKey(param)
		local tilePoint = mapSyncUtilClient.serverTOClientPos(cc.p(x, y))
		_ENV = cc.p(x, y)
		cc.p(x, y).tilePoint = tilePoint
		cc.p(x, y).buildId = v
		table.insert(marshalPointList, cc.p(x, y))
	end
	return marshalPointList
end
function atlantisWarUtil.getBuildName(landIndex)
	local ABL = require_data("atlantiswar_black_land", true).data
	local AMB = require_data("atlantiswar_map_build", true).data
	local buildId = ABL[landIndex].buildId
	local mapType = AMB[buildId].mapType
	local name = ""
	if mapType == gMapObjTypeDef.mapTypeAtlantisWarBuilding then
		local AMBC = require_data("atlantiswar_map_build_config").data
		name = AMBC[buildId].name
	elseif mapType == gMapObjTypeDef.mapTypeAtlantisWarBoss then
		local bossType = AMB[buildId].type
		name = worldMapDefine.getWorldBossName(bossType)
	end
	return i18n(name)
end
function atlantisWarUtil.checkIsInForbidAreaZhanling(point)
	local ret = atlantisWarUtil.checkAreaState(point)
	return ret.isCanZhanling
end
function atlantisWarUtil.checkIsInForbidAreaQiancheng(point)
	atlantisWarUtil = nil
	;(nil).isTransfer = true
	local ret = atlantisWarUtil.checkAreaState(point, nil)
	return ret.isCanQiancheng
end
function atlantisWarUtil.checkBuildState(siteClassID)
	local mapAtlantisArea = include("mapAtlantisArea")
	local AMB = require_data("atlantiswar_map_build", true).data
	local mapType = AMB[siteClassID].mapType
	local subType = AMB[siteClassID].type
	if mapType == gMapObjTypeDef.mapTypeAtlantisWarBuilding and (subType == gWorldTypeServerDef.subMapTypeAtlantisWarPalace or subType == gWorldTypeServerDef.subMapTypeAtlantisWarFort) then
		local cityCtrl = SoraDGetCtrl("cityCtrl")
		local myPoint = cityCtrl:getCurCityPos()
		local isSelfInBattleArea = mapAtlantisArea.checkInArea(myPoint.x, myPoint.y, ATLANTIS_WAR_AREA.WAR)
		if isSelfInBattleArea then
			_ENV = myPoint.x
			myPoint.x.isCanZhanling = true
			return myPoint.x
		else
			_ENV = myPoint.x
			myPoint.x.isCanZhanling = false
			myPoint.x.clickTips = i18n("atlantiswar_text_0237")
			return myPoint.x
		end
	end
	local selfCamp = atlantisWarCtrl:getSelfCamp()
	local campList = AMB[siteClassID].camp
	if table.indexof(campList, selfCamp) then
		_ENV = table.indexof(campList, selfCamp)
		table.indexof(campList, selfCamp).isCanZhanling = true
		return (table.indexof(campList, selfCamp))
	else
		_ENV = table.indexof(campList, selfCamp)
		table.indexof(campList, selfCamp).isCanZhanling = false
		table.indexof(campList, selfCamp).clickTips = i18n("atlantiswar_text_0239")
		table.indexof(campList, selfCamp).zhenchaTips = i18n("atlantiswar_text_0252")
		return (table.indexof(campList, selfCamp))
	end
end
function atlantisWarUtil.checkCanJoinMass(data, showTips)
	if not worldMapDefine.isInAtlantis() then
		return true
	end
	local ret
	if data.mapType == gMapObjTypeDef.mapTypeAtlantisWarBuilding and data.objId then
		ret = atlantisWarUtil.checkBuildState(data.objId)
	else
		local point = cc.p(data.x, data.y)
		_ENV = nil
		;(nil).ignoreBlackLand = true
		;(nil).ignoreMarshal = true
		ret = atlantisWarUtil.checkAreaState(point, nil)
	end
	if ret.isCanZhanling then
		return true
	end
	if showTips then
		SoraDShowMsgTip(ret.clickTips)
	end
	return false
end
function atlantisWarUtil.playFireAnimation(parent)
	local rightFire = SoraDGetChildByName(SoraDGetChildByName(parent, "FireNode_Right"), "dh_Fire")
	local leftFire = SoraDGetChildByName(SoraDGetChildByName(parent, "FireNode_Left"), "dh_Fire")
	local frames = display.newFrames("dh_tongtt8" .. "_%.2d.png", 0, 20)
	local animation = display.newAnimation(frames, 0.1)
	rightFire:playAnimationForever(animation)
	leftFire:playAnimationForever(animation)
	local sparkLeft = SoraDGetChildByName(parent, "G_dh_zhongnu3_02")
	local sparkRight = SoraDGetChildByName(parent, "G_dh_zhongnu3_01")
	local sparkFrames1 = display.newFramesEx("dh_zhongnu3" .. "_%.2d.png", 8, 15, 15)
	local sparkFrames2 = display.newFrames("dh_zhongnu3" .. "_%.2d.png", 0, 15)
	sparkLeft:playAnimationForever(display.newAnimation(sparkFrames1, 0.1))
	sparkRight:playAnimationForever(display.newAnimation(sparkFrames2, 0.1))
end
function atlantisWarUtil.getCampLoadingBarImage(camp)
	local atlantisWarCtrl = SoraDGetCtrl("atlantisWarCtrl")
	local selfCamp = atlantisWarCtrl:getSelfCamp()
	local imageName = "frame_shmc_barred.png"
	if selfCamp == camp then
		imageName = "frame_shmc_barblue.png"
	elseif camp % 2 == 1 then
		imageName = "frame_shmc_barred.png"
	elseif camp % 2 == 0 then
		imageName = "frame_shmc_barlose.png"
	end
	return imageName
end
function atlantisWarUtil.getCampTextColor(camp)
	local atlantisWarCtrl = SoraDGetCtrl("atlantisWarCtrl")
	local selfCamp = atlantisWarCtrl:getSelfCamp()
	local textColor = cc.c3b(230, 82, 82)
	if selfCamp == camp then
		textColor = cc.c3b(185, 241, 255)
	elseif camp % 2 == 1 then
		textColor = cc.c3b(230, 82, 82)
	elseif camp % 2 == 0 then
		textColor = cc.c3b(213, 155, 113)
	end
	return textColor
end
function atlantisWarUtil.checkEnterBattleField()
	local err = gErrDef.Err_None
	if atlantisActivityCtrl:getActivityCurState() ~= ATLANTIS_WAR_STATE.BATTLE then
		err = gErrDef.Err_ATLANTIS_WAR_STATE_ERR
		SoraDShowMsgBox(i18n("atlantiswar_text_0007"), i18n("common_text_054"), nil, nil)
	else
		local cityCtrl = SoraDGetCtrl("cityCtrl")
		local buiLevel = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
		if buiLevel < ATLANTIS_WAR_CASTLE_LEVEL then
			err = gErrDef.Err_ATLANTIS_WAR_CASTLE_LEVEL
			SoraDShowMsgBox(i18n("atlantiswar_text_0008"), i18n("common_text_204"), nil, nil)
		elseif worldMapDefine.inInCrossWar() then
			err = gErrDef.Err_ATLANTIS_WAR_NOT_IN_SELF_KINGDOM
			SoraDShowMsgBox(i18n("atlantiswar_text_0009"), i18n("common_text_204"), nil, nil)
		elseif kingdomMapCtrl:isHasQueue() ~= 0 then
			err = gErrDef.Err_ATLANTIS_WAR_STATE_ERR
			SoraDShowMsgBox(i18n("atlantiswar_text_0010"), i18n("common_text_204"), nil, nil)
		elseif 0 < armyCtrl:getCuringArmyCount() then
			err = gErrDef.Err_ATLANTIS_WAR_STATE_ERR
			SoraDShowMsgBox(i18n("atlantiswar_text_0011"), i18n("common_text_477"), nil, function(eventType)
				if eventType == MSGBOX_CALLBACK_YES then
					local worldMapWarDef = include("worldMapWarDef")
					worldMapWarDef.openHospitalView()
				end
			end)
		elseif 0 < armyCtrl:getTotalWoundedArmyCount() then
			err = gErrDef.Err_ATLANTIS_WAR_STATE_ERR
			SoraDShowMsgBox(i18n("atlantiswar_text_0011"), i18n("common_text_477"), nil, function(eventType)
				if eventType == MSGBOX_CALLBACK_YES then
					local worldMapWarDef = include("worldMapWarDef")
					worldMapWarDef.openHospitalView()
				end
			end)
		elseif atlantisActivityCtrl:getStageEndTime() - serviceFunctions.systemTime() <= 300 then
			err = gErrDef.Err_ATLANTIS_WAR_STATE_ERR
			SoraDShowMsgBox(i18n("common_text_4960"), i18n("common_text_204"), nil, nil)
		elseif 0 < atlantisActivityCtrl:getLastManualQuitTime() then
			local leftTime = serviceFunctions.systemTime() - atlantisActivityCtrl:getLastManualQuitTime()
			print("leftTime", leftTime)
			if leftTime < ATLANTIS_WAR_QUITFILED_CD then
				err = gErrDef.Err_ATLANTIS_WAR_IN_ENTER_CD
				_ENV = nil
				;(nil).time = math.ceil((ATLANTIS_WAR_QUITFILED_CD - leftTime) / 60)
				SoraDShowMsgBox(i18n("common_text_3402", nil), i18n("common_text_204"), nil, nil)
			else
			end
		end
	end
	return err
end
local _curWarStage
local setCurWarStage = function(stage)
	stage = {}
	_curWarStage = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:atlantisWarUtil:curWarStage~integer", _curWarStage, nil)
end
local delayCallOnce = function(delay)
	SoraDDelayCallOnce("atlantisWarUtil.showWarStageView", function()
		atlantisWarUtil.showWarStageView()
		atlantisWarUtil = nil
		;(nil).msg = "MESSAGE_ATLANTISWAR_REFRESH_STAGE"
		SoraDSendMessage(nil)
	end, delay)
end
function atlantisWarUtil.initWarStageView(...)
	local warData = atlantisWarCtrl:getWarData()
	local keyStr = string.format("%d_%d", warData.round or 0, warData.season or 0)
	atlantisWarCtrl = warData.season or 0
	;(warData.season or 0).byUID = true
	local keyConfig = SoraDConfigGet("Game:atlantisWarUtil:keyStr~string", warData.season or 0) or ""
	if keyStr ~= keyConfig then
		setCurWarStage(0)
		atlantisWarCtrl = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:atlantisWarUtil:keyStr~string", keyStr, nil)
	else
		atlantisWarCtrl = keyStr
		keyStr.byUID = true
	end
	atlantisWarUtil.showWarStageView()
end
function atlantisWarUtil.showWarStageView(...)
	local stage, lefttime = atlantisWarCtrl:getWarStage()
	if stage == gAtlantisWarStageType.battleEnd then
		return
	end
	atlantisWarCtrl = gAtlantisWarStageType.battleEnd
	atlantisWarCtrl = nil
	;(nil).bossClassID = gBossType.atlantisWarWlyn
	gAtlantisWarStageType.battleEnd[gAtlantisWarStageType.wlynReady], (nil).isAppear = nil, false
	atlantisWarCtrl = nil
	;(nil).bossClassID = gBossType.atlantisWarWlyn
	gAtlantisWarStageType.battleEnd[gAtlantisWarStageType.wlynIng], (nil).isAppear = nil, true
	atlantisWarCtrl = nil
	;(nil).bossClassID = gBossType.atlantisWarSd
	gAtlantisWarStageType.battleEnd[gAtlantisWarStageType.sdReady], (nil).isAppear = nil, false
	atlantisWarCtrl = nil
	;(nil).bossClassID = gBossType.atlantisWarSd
	gAtlantisWarStageType.battleEnd[gAtlantisWarStageType.sdIng], (nil).isAppear = nil, true
	local bossAppearConfig = gAtlantisWarStageType.battleEnd
	local config
	if stage == gAtlantisWarStageType.wlynReady and lefttime <= 3 and _curWarStage < 1 then
		config = bossAppearConfig[stage]
		setCurWarStage(1)
		delayCallOnce(4)
	elseif stage == gAtlantisWarStageType.wlynIng and _curWarStage < 1 then
		config = bossAppearConfig[stage]
		setCurWarStage(1)
		delayCallOnce(lefttime - 3)
	elseif stage == gAtlantisWarStageType.sdReady and lefttime <= 3 and _curWarStage < 2 then
		config = bossAppearConfig[stage]
		setCurWarStage(2)
		delayCallOnce(4)
	elseif stage == gAtlantisWarStageType.sdIng and _curWarStage < 2 then
		config = bossAppearConfig[stage]
		setCurWarStage(2)
		delayCallOnce(lefttime - 3)
	end
	if config then
		if not SoraDIsGameGuide() then
			local panel = SoraDCreatePanel("atlantisBossAppear")
			panel:initData(config)
			panel:show()
		end
		return true
	elseif stage == gAtlantisWarStageType.warAreaReady and lefttime <= 3 and _curWarStage < 3 then
		setCurWarStage(3)
		delayCallOnce(4)
		if not SoraDIsGameGuide() then
			SoraDCreatePanel("atlantisBattleAreaOpen"):show()
		end
		return true
	elseif stage == gAtlantisWarStageType.warAreaIng and _curWarStage < 3 then
		setCurWarStage(3)
		if not SoraDIsGameGuide() then
			SoraDCreatePanel("atlantisBattleAreaAttack"):show()
		end
		return true
	end
	delayCallOnce(math.max(3, lefttime - 3))
end
function atlantisWarUtil.showPlayerDebuffMsgTip(notifyData)
	local tip = ""
	local effect = notifyData.buff.effect
	local selfPlayerID = gametop.playertop_:getPlayerID() or 0
	local isSelf = notifyData.uid == selfPlayerID
	local selfCamp = atlantisWarCtrl:getSelfCamp()
	local sameCamp = selfCamp and selfCamp == notifyData.camp
	local userName = notifyData.name
	local opNickName = notifyData.opNickName
	if effect == gBuffEffect.DAMAGE_BOOST then
		if isSelf then
			gametop = nil
			;(nil).var = opNickName
			tip = i18n("atlantiswar_skill_text_044", nil)
		end
	elseif effect == gBuffEffect.CURE_SOLDIER_SPEED_BOOST then
		if isSelf then
			gametop = nil
			;(nil).var = opNickName
			tip = i18n("atlantiswar_skill_text_051", nil)
		end
	elseif effect == gBuffEffect.RUINS_WAR_MOVE_CITY_LOCKED then
		if sameCamp then
			if isSelf then
				tip = i18n("remains_text_360")
			else
				gametop = nil
				;(nil).name = userName
				tip = i18n("remains_text_359", nil)
			end
		else
			gametop = nil
			;(nil).name = userName
			tip = i18n("atlantiswar_text_0433", nil)
		end
	elseif effect == gBuffEffect.RUINS_WAR_SPEED_QUEUE_LOCKED then
		if sameCamp then
			if isSelf then
				tip = i18n("remains_text_365")
			else
				gametop = nil
				;(nil).name = userName
				tip = i18n("remains_text_385", nil)
			end
		else
			gametop = nil
			;(nil).name = userName
			tip = i18n("atlantiswar_text_0434", nil)
		end
	end
	if tip and tip ~= "" then
		SoraDShowMsgTip(tip)
	end
end
function atlantisWarUtil.getBossEffectList(bossClassID)
	local _ENV, effectList
	local index
	if bossClassID == gBossType.atlantisWarWlyn then
		index = 1
	elseif bossClassID == gBossType.atlantisWarSd then
		index = 2
	end
	local AMB = require_data("atlantiswar_master_buff", true).data
	local Buff = AMB[index].Buff
	local Buff1 = AMB[index].Buff1
	for i = 1, #Buff, 5 do
		_ENV = nil
		;(nil).boss = bossClassID
		;(nil).effect = Buff[i]
		table.insert(effectList, nil)
	end
	for i = 1, #Buff1, 4 do
		_ENV = nil
		;(nil).boss = bossClassID
		;(nil).effect = Buff1[i]
		;(nil).value = Buff1[i + 2]
		table.insert(effectList, nil)
	end
	return effectList
end
function atlantisWarUtil.getTargetSubType(siteClassID)
	local AMB = require_data("atlantiswar_map_build", true).data
	local target = AMB[siteClassID].actionParam
	return AMB[target].type
end
function atlantisWarUtil.getWorldMapAtlantisWarInfo()
	local currentScene = display.getRunningScene()
	local warInfoNode
	if currentScene.name == "MainScene" then
		warInfoNode = currentScene:getChildByName("worldMapAtlantisWarInfo")
		if not warInfoNode then
			warInfoNode = SoraDCreatePanel("worldMapAtlantisWarInfo")
			warInfoNode:setName("worldMapAtlantisWarInfo")
			warInfoNode:setPosition(cc.p(display.cx, display.height - 95 + display.iPhoneXBottom))
			warInfoNode:setVisible(false)
			warInfoNode:addTo(currentScene, 2)
		end
	end
	return warInfoNode
end
function atlantisWarUtil.removeWorldMapAtlantisWarInfo()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local warInfoNode = currentScene:getChildByName("worldMapAtlantisWarInfo")
		if warInfoNode then
			warInfoNode:removeFromParent()
		end
	end
end
local atlantiswar_team = require_data("atlantiswar_team").data
function atlantisWarUtil.checkCanNotifyFocusPos(...)
	local memberClass = atlantisWarCtrl:getSelfMemberClass()
	return table.indexof(atlantiswar_team[1].rank, memberClass)
end
function atlantisWarUtil.checkCanMass(...)
	local memberClass = atlantisWarCtrl:getSelfMemberClass()
	return table.indexof(atlantiswar_team[8].rank, memberClass)
end
function atlantisWarUtil.checkCanUseSpeedInQueue(...)
	local memberClass = atlantisWarCtrl:getSelfMemberClass()
	return table.indexof(atlantiswar_team[9].rank, memberClass)
end
function atlantisWarUtil.jumpToBoss(bossType)
	local mapSyncUtilClient = include("mapSyncUtilClient")
	local AMB = require_data("atlantiswar_map_build", true).data
	local selfCamp = atlantisWarCtrl:getSelfCamp()
	local jumpPos
	for k, v in pairs(AMB) do
		if v.mapType == gMapObjTypeDef.mapTypeAtlantisWarBoss and bossType == v.type and table.indexof(v.camp, selfCamp) then
			jumpPos = mapSyncUtilClient.serverTOClientPos(cc.p(v.x, v.y))
			break
		end
	end
	SoraDGotoWorldMapPoint(jumpPos)
end
function atlantisWarUtil.jumpToBuild(buildId)
	local AMB = require_data("atlantiswar_map_build", true).data
	local data = AMB[buildId]
	local mapSyncUtilClient = include("mapSyncUtilClient")
	local jumpPos = mapSyncUtilClient.serverTOClientPos(cc.p(data.x, data.y))
	SoraDGotoWorldMapPoint(jumpPos)
end
function atlantisWarUtil.getSelfCampBossId(bossType)
	local atlantisActivityRead = include("atlantisActivityRead")
	local selfCamp = atlantisWarCtrl:getSelfCamp()
	for buildId, build in pairs(atlantisActivityRead.getMapBuildConfigs()) do
		if build.mapType == gMapObjTypeDef.mapTypeAtlantisWarBoss and table.indexof(build.camp, selfCamp) and bossType == build.type then
			return buildId
		end
	end
end
function atlantisWarUtil.getBuildIdByParams(params)
	local buildId = params.buildId
	if buildId then
		return buildId
	end
	local atlantisActivityRead = include("atlantisActivityRead")
	local instanceType = params.instanceType
	if instanceType == gMapObjTypeDef.mapTypeAtlantisWarBoss then
		local bossType = params.bossType or gBossType.atlantisWarWlyn
		local buildId = atlantisWarUtil.getSelfCampBossId(bossType)
		return buildId
	else
		local subType = params.subType or gWorldTypeServerDef.subMapTypeAtlantisWarPalace
		local buildIdList = atlantisActivityRead.getMapBuildIdList(instanceType, subType)
		local buildId = buildIdList[1]
		return buildId
	end
end
function atlantisWarUtil.getPalaceTimeDays()
	local constantRead = include("constantRead")
	local lastTime = constantRead.getConstValue("ATLANTIS_SIGNATURE_TIME", 0)
	local oneDay = 86400
	return math.ceil(lastTime / oneDay)
end
function atlantisWarUtil.getKingdomCount()
	return atlantisWarUtil.isNewMap() and 4 or 6
end
function atlantisWarUtil.isNewMap()
	return IsArClient
end
function atlantisWarUtil.openExchangeShop()
	if atlantisWarUtil.isNewMap() then
		if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ROARING_FLAME_WAR_EXCHANGE, true) then
			uiManager:show("RoaringFlame_Shop")
		end
	else
		SoraDCreatePanel("atlantisShopView"):show()
	end
end
return atlantisWarUtil

local _ENV, queueTimeUtil
local gametop = gModuleMgr.getObject("gametop")
local kingdomMapLib = include("kingdomMapLib")
local worldMapFunction = include("worldMapFunction")
local kingdomMapUtil = include("kingdomMapUtil")
local attributeSystem = include("attributeSystem")
function queueTimeUtil.getSpeedPlus()
	local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local allianceScience = gametop.playertop_:getModule("allianceScience")
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local allianceWarCtrl = gametop.playertop_:getModule("allianceWarCtrl")
	local mapBuffCtrl = SoraDGetCtrl("mapBuffCtrl")
	local allianceTechPlus = 0
	local otherPlus = 0
	local buffValue = buffCtrl:getBuffEffect(gBuffEffect.MARCH_SPEED_BOOST) or 0
	local attrAdd = mapBuffCtrl:getBuffEffect(gAttributeEnum.MARCH_SPEED_BOOST_RAGNE)
	buffValue = buffValue + attrAdd / 10
	local deBuffValue = buffCtrl:getBuffEffect(gBuffEffect.MARCH_SPEED_REDUCE) or 0
	local radianceBuffValue = 0
	if worldMapDefine.isInRadiance() then
		radianceBuffValue = buffCtrl:getBuffEffect(gBuffEffect.RADIANCE_MARCH_SPEED_BOOST) or 0
	end
	local lordSkillPlus = lordInfoCtrl:getTechnologyPower(gLordTechnologyType.FORCE_OFF_MARCH_SPEED) or 0
	lordSkillPlus = lordSkillPlus * 1000
	local techPlus = technologyCtrl:getTechnologyPower(gTechnologyType.MARCH_SPEED) or 0
	techPlus = techPlus * 1000
	local battlefieldType = SoraDGetCtrl("kingdomMapCtrl"):getKingdomClass() or gKingdomClassType.normal
	local killNPCQueueType = gMapMoveLineServerType.moveLineTypeAttackLord
	gametop = nil
	;(nil).battleField = battlefieldType
	local (nil).dispatchType, attrFilter = killNPCQueueType, nil
	local attrPlus = attributeSystem.query(gAttributeEnum.DISPATCH_SPEED_RATE, attrFilter) or 0
	attrPlus = attrPlus / 10
	local allPlus = lordSkillPlus + techPlus + allianceTechPlus + otherPlus + buffValue + attrPlus - deBuffValue + radianceBuffValue
	return allPlus / 1000
end
function queueTimeUtil.getSpeedPlusShow()
	local basePlus = queueTimeUtil.getSpeedPlus()
	local warPlus = 0
	if worldMapDefine.isInAtlantis() then
		warPlus = include("constantRead").getConstValue("ATLANTIS_WAR_MARCH_SPEED", 0) / 1000
	end
	return (1 + basePlus) * (1 + warPlus) - 1
end
function queueTimeUtil.getKillNpcSpeedPlus(noHero)
	local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local allianceScience = gametop.playertop_:getModule("allianceScience")
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
	local killNpcSpeedPlus = 0
	local killNpcPlus = technologyCtrl:getTechnologyPower(gTechnologyType.KILL_MARCH_SPEED) or 0
	killNpcSpeedPlus = killNpcSpeedPlus + killNpcPlus * 1000
	print("killNpcPlus=", killNpcPlus)
	local retConquestWarBuff = conquestWarCtrl:getConquestWarWinBuffList(gBuffEffect.MARCH_MONSTER_SPEED_BOOST)
	if 0 < retConquestWarBuff.totalEffect then
		killNpcSpeedPlus = killNpcSpeedPlus + retConquestWarBuff.totalEffect * 1000
	end
	local buffEffect = buffCtrl:getBuffEffect(gBuffEffect.MARCH_MONSTER_SPEED_BOOST, nil, noHero)
	killNpcSpeedPlus = killNpcSpeedPlus + (buffEffect or 0)
	print("buffEffect=", buffEffect)
	local techPower = lordInfoCtrl:getTechnologyPower(gLordTechnologyType.ATTACKING_MONSTER_MARCH_SPEED) or 0
	killNpcSpeedPlus = killNpcSpeedPlus + techPower * 1000
	print("techPower=", techPower)
	local killNPCQueueType = gMapMoveLineServerType.moveLineTypeKillNpc
	gametop = "techPower="
	local ("techPower=").dispatchType, attrFilter = killNPCQueueType, "techPower="
	local attrPlus = attributeSystem.query(gAttributeEnum.DISPATCH_SPEED_RATE, attrFilter) or 0
	attrPlus = attrPlus / 10
	killNpcSpeedPlus = killNpcSpeedPlus + attrPlus
	return killNpcSpeedPlus
end
function queueTimeUtil.getKillNpcSpeedPlusShow(...)
	local basePlus = queueTimeUtil.getKillNpcSpeedPlus(...) / 1000
	local warPlus = 0
	if worldMapDefine.isInAtlantis() then
		warPlus = include("constantRead").getConstValue("ATLANTIS_WAR_MARCH_SPEED", 0) / 1000
	end
	return ((1 + basePlus) * (1 + warPlus) - 1) * 1000
end
function queueTimeUtil.getArmyMoveTime(mapObjType, worldMapTipButtonType, lstArmy, toPoint, otherData)
	print("queueTimeUtil.getArmyMoveTime", mapObjType, worldMapTipButtonType, lstArmy, toPoint)
	if not otherData then
		otherData, _ENV = print, print
	end
	local mainInstanceType = otherData.mainInstanceType
	local heroSpeedAdd = otherData.heroSpeedAdd
	local realDispatchType = otherData.realDispatchType
	local heroMarchMonsterAdd = otherData.heroMarchMonsterAdd
	local godArmsList = otherData.godArmsList
	local extraAttrAdd = otherData.extraAttrAdd
	local bossType = otherData.bossType
	local isJoinMass = otherData.isJoinMass
	local commandHallTaskID = otherData.commandHallTaskID
	local npcID = otherData.npcID
	local escortCartCtrl = gametop.playertop_:getModule("escortCartCtrl")
	if worldMapTipButtonType == worldMapDefine.worldMapTipButtonType_yayun then
		return escortCartCtrl:getCurrCartMoveTime()
	elseif worldMapTipButtonType == worldMapDefine.worldMapTipButtonType_bangzhuyayun then
		return ESCORT_ASSIST_ACCEPT_WAIT_ESCORT_TIMEOUT
	elseif worldMapTipButtonType == worldMapDefine.worldMapTipButtonType_lueduo then
		return 0
	end
	if mapObjType == gMapObjTypeDef.bubbleLandGift then
		return include("constantRead").getConstValue("BUBBLE_ISLAND_REBULD_MOVE_TIME")
	end
	if mapObjType == gMapObjTypeDef.fantasyLandGift then
		return include("constantRead").getConstValue("FANTASYLAND_MOVE_TIME")
	end
	if mapObjType == gMapObjType.danateMeterialBoss then
		return include("constantRead").getConstValue("COLLECT_CHALLENGE_MONSTER_MOVE_SPEED", 30)
	end
	if mapObjType == gMapObjTypeDef.wastelandBoss or mapObjType == gMapObjTypeDef.mapObjTypeNpc and worldMapDefine.checkIsWastelandMonster(npcID) then
		return include("constantRead").getConstValue("WASTELAND_SPEED", 5)
	end
	if mapObjType == gMapObjTypeDef.roaringFlameWarBuilding and npcID then
		local roaringFlameWarRead = include("roaringFlameWarRead")
		local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
		local subType = roaringFlameWarRead.getBuildSubType(npcID)
		if subType == gWorldTypeServerDef.subTypeRoaringFlameWarPhoenix and not roaringFlameWarCtrl:checkInWarStatus() then
			return roaringFlameWarRead.getConstValue("FLAMES_DUNES_RES_SPEED_TIEM", 5)
		end
	end
	if mapObjType == gMapObjTypeDef.roaringFlameWarNpc then
		local roaringFlameWarRead = include("roaringFlameWarRead")
		return roaringFlameWarRead.getConstValue("FLAMES_DUNES_RES_SPEED_TIEM", 5)
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local fromPoint = cityCtrl:getCurCityPos()
	_ENV = cityCtrl
	cityCtrl.x = tonumber(toPoint.x)
	toPoint, cityCtrl.y = cityCtrl, tonumber(toPoint.y)
	local fromSize = serviceFunctions.getMapObjSizeByMapType(gMapObjTypeDef.mapObjTypePlayer)
	local toSize = serviceFunctions.getMapObjSizeByMapType(mapObjType)
	_ENV = mapObjType
	mapObjType.x = fromPoint.x + gPointClientPointPlus + (fromSize - 1) * gMovelinePointCorrect
	_ENV, fromPoint, mapObjType.y = mapObjType, mapObjType, fromPoint.y + gPointClientPointPlus + (fromSize - 1) * gMovelinePointCorrect
	mapObjType.x = toPoint.x + gPointClientPointPlus + (toSize - 1) * gMovelinePointCorrect
	toPoint, mapObjType.y = mapObjType, toPoint.y + gPointClientPointPlus + (toSize - 1) * gMovelinePointCorrect
	local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local allianceScience = gametop.playertop_:getModule("allianceScience")
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
	local allianceWarCtrl = gametop.playertop_:getModule("allianceWarCtrl")
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	local allianceTechPlus = 0
	local otherPlus = 0
	local quickWarPlus = 0
	local quickSkillPlus = buffCtrl:getBuffEffect(gBuffEffect.MARCH_SPEED_BOOST, gBuffSource.SKILL) or 0
	local buffValue = buffCtrl:getBuffEffect(gBuffEffect.MARCH_SPEED_BOOST) or 0
	local deBuffValue = buffCtrl:getBuffEffect(gBuffEffect.MARCH_SPEED_REDUCE) or 0
	local heroSkillPlus = heroSpeedAdd or 0
	local inWarStatePlus = 0
	if kingdomMapCtrl:getKingdomClass() == gKingdomClassType.normal then
		inWarStatePlus = kingdomMapCtrl.kingdomMapCell:getInWarStateSpeed()
	end
	local radianceBuffValue = 0
	if worldMapDefine.isInRadiance() then
		radianceBuffValue = buffCtrl:getBuffEffect(gBuffEffect.RADIANCE_MARCH_SPEED_BOOST) or 0
	end
	local atlantisBuffValue = 0
	local mapBuffCtrl = SoraDGetCtrl("mapBuffCtrl")
	local attrAdd = mapBuffCtrl:getBuffEffect(gAttributeEnum.MARCH_SPEED_BOOST_RAGNE)
	atlantisBuffValue = attrAdd / 10
	local roaringFlameValue = 0
	if worldMapDefine.isInRoaringFlame() then
		local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
		roaringFlameValue = roaringFlameWarCtrl:getDecreeBuffValue(gBuffEffect.MARCH_SPEED_BOOST)
	end
	local simulatedDrillPlus = 0
	if worldMapDefine.isInSimulatedDrill() then
		simulatedDrillPlus = CONST_VALUE.SIMULATED_DRILL_SPEED or 0
	end
	buffValue = buffValue - deBuffValue - quickSkillPlus + heroSkillPlus + radianceBuffValue + atlantisBuffValue + roaringFlameValue
	buffValue = buffValue + simulatedDrillPlus
	local lordSkillPlus = lordInfoCtrl:getTechnologyPower(gLordTechnologyType.FORCE_OFF_MARCH_SPEED) or 0
	lordSkillPlus = lordSkillPlus * 1000
	local techPlus = technologyCtrl:getTechnologyPower(gTechnologyType.MARCH_SPEED) or 0
	techPlus = techPlus * 1000
	print("mapObjType=", mapObjType)
	if mapObjType == gMapObjTypeDef.mapObjTypeNpc or mapObjType == gMapObjTypeDef.nebulaNpc or mapObjType == gMapObjTypeDef.mapTypeMonsterFiesta or mapObjType == gMapObjTypeDef.mapObjTypeBoss or mapObjType == gMapObjTypeDef.mapTypeHeroBattleBoss1 or mapObjType == gMapObjTypeDef.mapTypeHeroBattleBoss2 or mapObjType == gMapObjTypeDef.mapTypeWrathBeast or mainInstanceType == gMapObjTypeDef.mapObjTypeBoss or mainInstanceType == gMapObjTypeDef.mapTypeHeroBattleBoss1 or mainInstanceType == gMapObjTypeDef.mapTypeHeroBattleBoss2 or mainInstanceType == gMapObjTypeDef.mapTypeWrathBeast or bossType == gBossType.lostRuinsBoss or bossType == gBossType.snowWolfLostBoss or bossType == gBossType.windTowerBoss or bossType == gBossType.fireDragon1 or worldMapDefine.worldMapTipButtonType_alliancepet_3 == realDispatchType or mapObjType == gMapObjTypeDef.mapTypeHuntFair or mapObjType == gMapObjTypeDef.mapTypeSemluk or mapObjType == gMapObjTypeDef.footballMonster or mapObjType == gMapObjTypeDef.fireDragon2 or mapObjType == gMapObjTypeDef.sweetMeatRobber or mainInstanceType == gMapObjTypeDef.mapTypeAtlantisWarBoss then
		local killNpcPlus = technologyCtrl:getTechnologyPower(gTechnologyType.KILL_MARCH_SPEED) or 0
		otherPlus = otherPlus + killNpcPlus * 1000
		local buffEffect = buffCtrl:getBuffEffect(gBuffEffect.MARCH_MONSTER_SPEED_BOOST)
		otherPlus = otherPlus + (buffEffect or 0)
		otherPlus = otherPlus + (heroMarchMonsterAdd or 0)
		local retConquestWarBuff = conquestWarCtrl:getConquestWarWinBuffList(gBuffEffect.MARCH_MONSTER_SPEED_BOOST)
		local conquestWarPlus = retConquestWarBuff.totalEffect
		if 0 < retConquestWarBuff.totalEffect then
			otherPlus = otherPlus + retConquestWarBuff.totalEffect * 1000
		end
		local techPower = lordInfoCtrl:getTechnologyPower(gLordTechnologyType.ATTACKING_MONSTER_MARCH_SPEED) or 0
		print("techPower=", techPower)
		otherPlus = otherPlus + techPower * 1000
		quickSkillPlus = 0
		local achiBuffValue = buffCtrl:getBuffEffect(gBuffEffect.MARCH_SPEED_BOOST, gBuffSource.ACHIEVEMENT) or 0
		buffValue = buffValue - achiBuffValue
	elseif mapObjType == gMapObjTypeDef.mapTypeRadianceWarResource then
		local plus = include("constantRead").getConstValue("RADIANCE_RESOURCE_WALKSPEED", 300)
		quickWarPlus = quickWarPlus + plus
	elseif worldMapTipButtonType == worldMapDefine.worldMapTipButtonType_ziyuanYuanzhu then
		local alliancePower = allianceScience:getScienceAddValue(gAScienceType.TRADING_ARMY_SPEED) or 0
		otherPlus = otherPlus + alliancePower * 1000
	elseif worldMapTipButtonType == worldMapDefine.worldMapTipButtonType_shibingYuabzhu then
		if mapObjType == gMapObjTypeDef.mapObjTypeBuilding then
			local alliancePower = allianceScience:getScienceAddValue(gAScienceType.REINFORCEMENTS_SPEED) or 0
			otherPlus = otherPlus + alliancePower * 1000
			local buffEffectAllianceMarch = buffCtrl:getBuffEffect(gBuffEffect.ASSISTANCE_SPEED_BOOST, gBuffSource.SKILL) or 0
			otherPlus = otherPlus + buffEffectAllianceMarch
		end
	elseif worldMapTipButtonType == worldMapDefine.worldMapTipButtonType_xuanZhan or worldMapTipButtonType == worldMapDefine.worldMapTipButtonType_zuduiYuanzhu then
		local alliancePower
		local worldMapWarDef = include("worldMapWarDef")
		if worldMapWarDef.checkFullAllianceScience() then
			alliancePower = _G.LEGEND_WAR_BUFF.ALLIANCE_ARMY_SPEED
		else
			alliancePower = allianceScience:getScienceAddValue(gAScienceType.ALLIANCE_ARMY_SPEED) or 0
		end
		otherPlus = otherPlus + alliancePower * 1000
	end
	if worldMapDefine.isInAtlantis() then
		local warPlus = include("constantRead").getConstValue("ATLANTIS_WAR_MARCH_SPEED", 0)
		quickWarPlus = quickWarPlus + warPlus
	end
	if worldMapDefine.isInRemains() then
		local warPlus = include("constantRead").getConstValue("RUINS_WAR_ADD_SPEED", 0)
		quickWarPlus = quickWarPlus + warPlus
	end
	if mapObjType ~= gMapObjTypeDef.mapObjTypePlayer and (worldMapTipButtonType == worldMapDefine.worldMapTipButtonType_xuanZhan or worldMapTipButtonType == worldMapDefine.worldMapTipButtonType_zuduiYuanzhu) then
		local buffEffect = buffCtrl:getBuffEffect(gBuffEffect.MASS_ATTACK_SPEED_UP)
		otherPlus = otherPlus + (buffEffect or 0)
	end
	if worldMapTipButtonType == worldMapDefine.worldMapTipButtonType_ziyuanYuanzhu or worldMapTipButtonType == worldMapDefine.worldMapTipButtonType_zhenCha then
		lordSkillPlus = 0
		techPlus = 0
		quickSkillPlus = 0
		local achiBuffValue = buffCtrl:getBuffEffect(gBuffEffect.MARCH_SPEED_BOOST, gBuffSource.ACHIEVEMENT) or 0
		buffValue = buffValue - achiBuffValue
		local vipBuffValue = buffCtrl:getBuffEffect(gBuffEffect.MARCH_SPEED_BOOST, gBuffSource.VIP) or 0
		buffValue = buffValue - vipBuffValue
		local officialBuffValue = buffCtrl:getBuffEffect(gBuffEffect.MARCH_SPEED_BOOST, gBuffSource.OFFICIAL) or 0
		buffValue = buffValue - officialBuffValue
	end
	if worldMapTipButtonType ~= worldMapDefine.worldMapTipButtonType_shibingYuabzhu and worldMapTipButtonType ~= worldMapDefine.worldMapTipButtonType_xuanZhan and worldMapTipButtonType ~= worldMapDefine.worldMapTipButtonType_ziyuanYuanzhu then
		allianceTechPlus = 0
	end
	attributeSystem.dump()
	local queueType = worldMapDefine.convetToMapMoveLineType(mapObjType, worldMapTipButtonType, toPoint, isJoinMass)
	local armyPercentTab = serviceFunctions.getArmyPercentData(lstArmy)
	local getArmsMapList = function(armsList)
		local _ENV, retList
		if type(armsList) == "table" then
			for k, v in pairs(armsList) do
				if type(v) == "number" and 0 < v then
					retList[v] = v
				end
			end
		end
		return retList
	end
	local useGodArmsList = getArmsMapList(godArmsList)
	local _ENV, battlefieldType = kingdomMapCtrl, kingdomMapCtrl:getKingdomClass() or gKingdomClassType.normal
	kingdomMapCtrl.dispatchType = queueType
	kingdomMapCtrl.unitPercent = armyPercentTab
	kingdomMapCtrl.useGodArms = useGodArmsList
	local kingdomMapCtrl.battleField, attrFilter = battlefieldType, kingdomMapCtrl
	local attrPlus = attributeSystem.query(gAttributeEnum.DISPATCH_SPEED_RATE, attrFilter) or 0
	attrPlus = attrPlus / 10
	extraAttrAdd = extraAttrAdd or 0
	local allPlus = lordSkillPlus + techPlus + allianceTechPlus + otherPlus + buffValue + inWarStatePlus + attrPlus + extraAttrAdd
	local oneTimeReduceTimeRate = buffCtrl:getBuffEffect(gBuffEffect.ONE_TIME_MARCH_TIME_REDUCE) or 0
	_ENV = gBuffEffect.ONE_TIME_MARCH_TIME_REDUCE
	gBuffEffect.ONE_TIME_MARCH_TIME_REDUCE.battlefieldType = battlefieldType
	gBuffEffect.ONE_TIME_MARCH_TIME_REDUCE.mapObjType = mapObjType
	gBuffEffect.ONE_TIME_MARCH_TIME_REDUCE.worldMapTipButtonType = worldMapTipButtonType
	gBuffEffect.ONE_TIME_MARCH_TIME_REDUCE.lstArmy = lstArmy
	gBuffEffect.ONE_TIME_MARCH_TIME_REDUCE.fromPoint = fromPoint
	gBuffEffect.ONE_TIME_MARCH_TIME_REDUCE.toPoint = toPoint
	gBuffEffect.ONE_TIME_MARCH_TIME_REDUCE.allPlus = allPlus
	gBuffEffect.ONE_TIME_MARCH_TIME_REDUCE.quickSkillPlus = quickSkillPlus
	gBuffEffect.ONE_TIME_MARCH_TIME_REDUCE.quickWarPlus = quickWarPlus
	gBuffEffect.ONE_TIME_MARCH_TIME_REDUCE.oneTimeReduceTimeRate = oneTimeReduceTimeRate
	gBuffEffect.ONE_TIME_MARCH_TIME_REDUCE.commandHallTaskID = commandHallTaskID
	local totalTime = queueTimeUtil.getArmyBaseMoveTime(gBuffEffect.ONE_TIME_MARCH_TIME_REDUCE)
	return totalTime
end
function queueTimeUtil.getArmyBaseMoveTime(params)
	local battlefieldType = params.battlefieldType
	local mapObjType = params.mapObjType
	local worldMapTipButtonType = params.worldMapTipButtonType
	local lstArmy = params.lstArmy
	local fromPoint = params.fromPoint
	local toPoint = params.toPoint
	local allPlus = params.allPlus
	local quickSkillPlus = params.quickSkillPlus
	local quickWarPlus = params.quickWarPlus
	local oneTimeReduceTimeRate = params.oneTimeReduceTimeRate
	local commandHallTaskID = params.commandHallTaskID
	queueTimeUtil = nil
	;(nil).worldMapTipButtonType = worldMapTipButtonType
	;(nil).lstArmy = lstArmy
	;(nil).fromPoint = fromPoint
	;(nil).toPoint = toPoint
	;(nil).commandHallTaskID = commandHallTaskID
	local speed = queueTimeUtil.getArmyBaseMoveSpeed(nil)
	if worldMapTipButtonType ~= worldMapDefine.worldMapTipButtonType_commandHallNpc then
		speed = speed * ((1000 + allPlus) / 1000) * ((1000 + quickSkillPlus) / 1000) * ((1000 + quickWarPlus) / 1000) * (1000 / (1000 - oneTimeReduceTimeRate))
	end
	local totalTime = 0
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local lineSpan = queueTimeUtil.getArmyMoveLineSpan(battlefieldType, fromPoint, toPoint, mapObjType)
	for _, v in pairs(lineSpan) do
		local moveDistance = serviceFunctions.getMapDistance(v.startX, v.startY, v.endX, v.endY)
		local lineSpeed = speed
		if worldMapTipButtonType ~= worldMapDefine.worldMapTipButtonType_commandHallNpc and v.attrType == gMapMoveLineAttrType.moveLineAttrTypeWarArea then
			lineSpeed = lineSpeed * gMapWarAreaSpeedRate
			local blacklandDebuffEffect = buffCtrl:getBuffEffect(gBuffEffect.OTHER_KINGDOM_MARCH_BLACKLAND_SPEED_REDUCE)
			if blacklandDebuffEffect and 0 < blacklandDebuffEffect then
				lineSpeed = lineSpeed * (1000 - blacklandDebuffEffect) / 1000
			end
		end
		local useTime = math.ceil(moveDistance / lineSpeed)
		totalTime = totalTime + useTime
	end
	if worldMapTipButtonType == worldMapDefine.worldMapTipButtonType_commandHallNpc then
		local commandHallUtil = include("commandHallUtil")
		local marchTime = commandHallUtil.getRebelArmyMarchTime()
		if totalTime > marchTime then
			totalTime = marchTime
		end
	end
	if mapObjType == gMapObjTypeDef.captureMonkey then
		totalTime = math.min(totalTime, 10)
	end
	return totalTime
end
function queueTimeUtil.getArmyBaseMoveSpeed(params)
	local worldMapTipButtonType = params.worldMapTipButtonType
	local lstArmy = params.lstArmy
	local fromPoint = params.fromPoint
	local toPoint = params.toPoint
	local speed = 0
	local armyLogic = include("armyLogic")
	if worldMapTipButtonType == worldMapDefine.worldMapTipButtonType_zhenCha then
		speed = gScoutMoveSpeed
	elseif worldMapTipButtonType == worldMapDefine.worldMapTipButtonType_ziyuanYuanzhu then
		speed = gResourceHelpMoveSpeed
	elseif lstArmy then
		local armyltCtrl = include("armyltCtrl")
		for i = 1, #lstArmy do
			local v = lstArmy[i]
			local biographyAdd = armyLogic.getArmySpecial(tonumber(v.id), "cavalry", gBuffEffect.LEV_110_CAVALRY_MOVE_SPEED, 110)
			biographyAdd = biographyAdd + armyLogic.getArmySpecial(tonumber(v.id), "cavalry", gBuffEffect.LEV_120_CAVALRY_MOVE_SPEED, 120)
			local armySpeed = armyltCtrl.getArmyAttrAndSp(tonumber(v.id), ARMY_ATTR.SPEED, biographyAdd)
			if armySpeed and (speed == 0 or speed > armySpeed) then
				speed = armySpeed
			end
		end
	end
	if worldMapTipButtonType == worldMapDefine.worldMapTipButtonType_commandHallNpc then
		local taskID = params.commandHallTaskID
		local commandHallRead = include("commandHallRead")
		local taskData = commandHallRead.getTaskConfig(taskID)
		local plus = taskData.moveAdd / 1000
		if taskData.moveType == 2 then
			local constantRead = include("constantRead")
			speed = constantRead.getConstValue("COMMANDHALL_MOVETYPE2_SPEED", 50)
		end
		local technologyCtrl = SoraDGetCtrl("technologyCtrl")
		local commonandHallPlus = technologyCtrl:getTechnologyPower(gTechnologyType.COMMAND_HALL_MARCH_SPEED_UP)
		print("==commandHallNpc speed==", speed, plus, commonandHallPlus)
		speed = speed * (1 + plus + commonandHallPlus)
	end
	local s = serviceFunctions.getTwoPointDistance(fromPoint.x, fromPoint.y, toPoint.x, toPoint.y)
	local y = (1100 + s) / 1100
	return speed * y
end
function queueTimeUtil.getArmyMoveLineSpan(battlefieldType, fromPoint, toPoint, mapObjType)
	if battlefieldType ~= gKingdomClassType.normal then
		return queueTimeUtil.getArmyMoveLineSpan_war(fromPoint, toPoint, mapObjType)
	else
		return queueTimeUtil.getArmyMoveLineSpan_normal(fromPoint, toPoint, mapObjType)
	end
end
function queueTimeUtil.getArmyMoveLineSpan_war(fromPoint, toPoint, mapObjType)
	local _ENV, ret
	local attrType = gMapMoveLineAttrType.moveLineAttrTypeNormal
	_ENV = nil
	;(nil).startX = fromPoint.x
	;(nil).startY = fromPoint.y
	;(nil).endX = toPoint.x
	;(nil).endY = toPoint.y
	;(nil).attrType = attrType
	table.insert(ret, nil)
	return ret
end
function queueTimeUtil.getArmyMoveLineSpan_normal(fromPoint, toPoint, mapObjType)
	local _ENV, existPoint
	local _ENV, pointLst
	table.insert(pointLst, fromPoint)
	local point1 = serviceFunctions.getHitPoint(fromPoint, toPoint, gMapWarArea.leftTopPoint, gMapWarArea.rightTopPoint)
	local point2 = serviceFunctions.getHitPoint(fromPoint, toPoint, gMapWarArea.rightTopPoint, gMapWarArea.rightBottomPoint)
	local point3 = serviceFunctions.getHitPoint(fromPoint, toPoint, gMapWarArea.rightBottomPoint, gMapWarArea.leftBottomPoint)
	local point4 = serviceFunctions.getHitPoint(fromPoint, toPoint, gMapWarArea.leftBottomPoint, gMapWarArea.leftTopPoint)
	if point1 and not serviceFunctions.isPointSame(point1, fromPoint) and not serviceFunctions.isPointSame(point1, toPoint) then
		local mapKey = serviceFunctions.getMapKey(point1.x, point1.y)
		if not existPoint[mapKey] then
			table.insert(pointLst, point1)
			existPoint[mapKey] = mapKey
		end
	end
	if point2 and not serviceFunctions.isPointSame(point2, fromPoint) and not serviceFunctions.isPointSame(point2, toPoint) then
		local mapKey = serviceFunctions.getMapKey(point2.x, point2.y)
		if not existPoint[mapKey] then
			table.insert(pointLst, point2)
			existPoint[mapKey] = mapKey
		end
	end
	if point3 and not serviceFunctions.isPointSame(point3, fromPoint) and not serviceFunctions.isPointSame(point3, toPoint) then
		local mapKey = serviceFunctions.getMapKey(point3.x, point3.y)
		if not existPoint[mapKey] then
			table.insert(pointLst, point3)
			existPoint[mapKey] = mapKey
		end
	end
	if point4 and not serviceFunctions.isPointSame(point4, fromPoint) and not serviceFunctions.isPointSame(point4, toPoint) then
		local mapKey = serviceFunctions.getMapKey(point4.x, point4.y)
		if not existPoint[mapKey] then
			table.insert(pointLst, point4)
			existPoint[mapKey] = mapKey
		end
	end
	table.insert(pointLst, toPoint)
	local sortFunc
	if fromPoint.x < toPoint.x then
		function sortFunc(p1, p2)
			return p1.x < p2.x
		end
	elseif fromPoint.x > toPoint.x then
		function sortFunc(p1, p2)
			return p1.x > p2.x
		end
	elseif fromPoint.y < toPoint.y then
		function sortFunc(p1, p2)
			return p1.y < p2.y
		end
	else
		function sortFunc(p1, p2)
			return p1.x > p2.x
		end
	end
	table.sort(pointLst, sortFunc)
	_ENV = table.sort
	table.sort.startX = gMapWarArea.leftTopPoint.x
	table.sort.startY = gMapWarArea.leftTopPoint.y
	table.sort.endX = gMapWarArea.rightBottomPoint.x
	local table.sort.endY, warRang = gMapWarArea.rightBottomPoint.y, table.sort
	local _ENV, ret = gMapWarArea.rightBottomPoint.y, gMapWarArea.rightBottomPoint.y
	for i = 2, table.nums(pointLst) do
		local startPoint = pointLst[i - 1]
		local endPoint = pointLst[i]
		local attrType = gMapMoveLineAttrType.moveLineAttrTypeNormal
		if kingdomMapUtil.isInRang(startPoint.x, startPoint.y, warRang) and kingdomMapUtil.isInRang(endPoint.x, endPoint.y, warRang) then
			attrType = gMapMoveLineAttrType.moveLineAttrTypeWarArea
		end
		_ENV = endPoint.y
		endPoint.y.startX = startPoint.x
		endPoint.y.startY = startPoint.y
		endPoint.y.endX = endPoint.x
		endPoint.y.endY = endPoint.y
		endPoint.y.attrType = attrType
		table.insert(ret, endPoint.y)
	end
	return ret
end
function queueTimeUtil.getRemainTime(localQueueData)
	local curTime = serviceFunctions.systemTime()
	local remainTime = localQueueData.statusEndTime - curTime
	if remainTime < 0 then
		remainTime = 0
	end
	return remainTime
end
function queueTimeUtil.getTotalTime(localQueueData)
	local remainTime = localQueueData:getOrgStatusTotalTime()
	if remainTime < 0 then
		remainTime = 0
	end
	return remainTime
end
function queueTimeUtil.getFinishTime(localQueueData)
	local remainTime = localQueueData.statusEndTime or 0
	if remainTime < 0 then
		remainTime = 0
	end
	return remainTime
end
function queueTimeUtil.getFreeSpeedUpTime(itemType, queueType, queue)
	local freeSpeedUpTime = 0
	if itemType == gAbbrSpeedUpType.BUILD_UPGRADE then
		if queueType == gQueueTypeDef.garden_build_upgrade then
			return 0
		end
		local buildLogic = include("buildLogic")
		freeSpeedUpTime = buildLogic.getFreeSpeedUpTime(queue.data.lv)
		if queueType == gQueueTypeDef.build_star_queue or queueType == gQueueTypeDef.build_star_queue_privilege or queueType == gQueueTypeDef.glorious_upgrade then
			freeSpeedUpTime = buildLogic.getFreeStrongTime()
		end
	elseif itemType == gAbbrSpeedUpType.TECH then
		local technologyCtrl = SoraDGetCtrl("technologyCtrl")
		freeSpeedUpTime = technologyCtrl:getFreeSpeedUpTime(queueType)
	end
	return freeSpeedUpTime
end
return queueTimeUtil

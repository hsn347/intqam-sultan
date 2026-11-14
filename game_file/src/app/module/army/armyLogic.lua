local _ENV, armyLogic
local armyltCtrl = include("armyltCtrl")
local gametop = gModuleMgr.getObject("gametop")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local remainsWarCtrl = gametop.playertop_:getModule("remainsWarCtrl")
local cityltCtrl = include("cityltCtrl")
local buildLogic = include("buildLogic")
local worldMapDefine = include("worldMapDefine")
local attributeSystem = include("attributeSystem")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local heroCtrl = gametop.playertop_:getModule("heroCtrl")
local heroBiographyCtrl = gametop.playertop_:getModule("heroBiographyCtrl")
local armorSystemRead = gModuleMgr.sharedMgr("armorSystemRead")
local armyidsortfun = function(t)
	table.sort(t, function(l, r)
		if l and r then
			local lvL = l.armyid % 100
			local lvR = r.armyid % 100
			return lvL < lvR
		else
			return false
		end
	end)
end
local trapidsortfun = function(t)
	table.sort(t, function(a, b)
		if a.gewei == b.gewei then
			return a.shiwei < b.shiwei
		else
			return a.gewei < b.gewei
		end
	end)
end
function armyLogic.getArmySpecial(armyID, armyClass, buffType, armyLv)
	local ret = 0
	local alv = serviceFunctions.getArmyViewLev(armyID)
	local curArmyClass = serviceFunctions.getArmyClassByArmyId(armyID)
	if curArmyClass == armyClass then
		if armyLv then
			if alv == armyLv then
				ret = heroBiographyCtrl:queryHeroBiographyBuff(buffType)
			end
		else
			ret = heroBiographyCtrl:queryHeroBiographyBuff(buffType)
		end
	end
	return ret
end
function armyLogic.getArmySpecialWeight(armyID)
	local ret = 0
	local alv = serviceFunctions.getArmyViewLev(armyID)
	local curArmyClass = serviceFunctions.getArmyClassByArmyId(armyID)
	if curArmyClass == "charists" then
		if alv == 110 then
			ret = heroBiographyCtrl:queryHeroBiographyBuff(gBuffEffect.LEV_110_CHARISTS_WEIGHTPLUS_BOOST)
		end
		if alv == 115 then
			ret = heroBiographyCtrl:queryHeroBiographyBuff(gBuffEffect.LEV_115_CHARISTS_WEIGHTPLUS_BOOST)
		end
		if alv == 120 then
			ret = heroBiographyCtrl:queryHeroBiographyBuff(gBuffEffect.LEV_120_CHARISTS_WEIGHTPLUS_BOOST)
		end
	end
	return ret
end
function armyLogic.getArmySpecialAtk(armyID)
	local ret = 0
	local alv = serviceFunctions.getArmyViewLev(armyID)
	local curArmyClass = serviceFunctions.getArmyClassByArmyId(armyID)
	if curArmyClass == "infantry" then
		if alv == 120 then
			ret = heroBiographyCtrl:queryHeroBiographyBuff(gBuffEffect.LEV_120_INFANTRY_BASE_AK_PLUS)
		end
		if alv == 125 then
			ret = heroBiographyCtrl:queryHeroBiographyBuff(gBuffEffect.LEV_125_INFANTRY_BASE_AK_PLUS)
		end
	end
	if curArmyClass == "archer" and alv == 125 then
		ret = heroBiographyCtrl:queryHeroBiographyBuff(gBuffEffect.LEV_125_ARCHER_BASE_ATK)
	end
	return ret
end
function armyLogic.getArmySpecialDef(armyID)
	local ret = 0
	local alv = serviceFunctions.getArmyViewLev(armyID)
	local curArmyClass = serviceFunctions.getArmyClassByArmyId(armyID)
	if curArmyClass == "infantry" then
		if alv == 110 then
			ret = heroBiographyCtrl:queryHeroBiographyBuff(gBuffEffect.LEV_110_INFANTRY_BASE_DEFENSE)
		end
		if alv == 115 then
			ret = heroBiographyCtrl:queryHeroBiographyBuff(gBuffEffect.LEV_115_INFANTRY_BASE_DEFENSE)
		end
		if alv == 120 then
			ret = heroBiographyCtrl:queryHeroBiographyBuff(gBuffEffect.LEV_120_INFANTRY_BASE_DEFENSE)
		end
		if alv == 125 then
			ret = heroBiographyCtrl:queryHeroBiographyBuff(gBuffEffect.LEV_125_INFANTRY_BASE_DEFENSE)
		end
	end
	if curArmyClass == "archer" and alv == 125 then
		ret = heroBiographyCtrl:queryHeroBiographyBuff(gBuffEffect.LEV_125_ARCHER_BASE_DEFENSE)
	end
	if curArmyClass == "cavalry" and alv == 125 then
		ret = heroBiographyCtrl:queryHeroBiographyBuff(gBuffEffect.LEV_125_CAVALRY_BASE_DEFENSE)
	end
	return ret
end
local calcCostResCount = function(toResCount, fromResCount, count)
	local costResCount = (toResCount - fromResCount * 0.5) * count
	return math.ceil(costResCount)
end
function armyLogic.getArmyShowADH(armyid, bType)
	local attackShow, defendShow, bloodShow = 0, 0, 0
	local buffCtrl = SoraDGetCtrl("buffCtrl")
	local soldierType = armyltCtrl.getSoldierType(armyid)
	_UPVALUE4_ = armyid
	_UPVALUE3_, armyid[1] = gBuffSource.WAR_GEM, gBuffSource.WAR_GEM
	_UPVALUE3_, armyid[2] = gBuffSource.WAR_GEM, gBuffSource.EQUIPMENT
	_UPVALUE3_, armyid[3] = gBuffSource.WAR_GEM, gBuffSource.KINGDOM_LEVEL
	local _UPVALUE3_, armyid[4], sourceCfg = gBuffSource.WAR_GEM, gBuffSource.HERO_BIOGRAPHY, armyid
	_ENV, gBuffSource.WAR_GEM[1] = ARMY_ATTR.ATTACK, ARMY_ATTR.ATTACK
	_ENV, gBuffSource.WAR_GEM[2] = ARMY_ATTR.ATTACK, ARMY_ATTR.DEFENSE
	local _ENV, gBuffSource.WAR_GEM[3], tableKey = ARMY_ATTR.ATTACK, ARMY_ATTR.LIFE, gBuffSource.WAR_GEM
	_UPVALUE3_, _ENV = nil, ARMY_ATTR.LIFE
	_UPVALUE3_, ARMY_ATTR.LIFE.attack, (nil)[1] = nil, nil, gBuffEffect.SOLDIER_BASE_ATTACK
	_UPVALUE3_, ARMY_ATTR.LIFE.attack, (nil)[2] = nil, nil, gBuffEffect.INFANTRY_BASE_ATTACK
	_UPVALUE3_, ARMY_ATTR.LIFE.attack, (nil)[3] = nil, nil, "akPlus"
	_UPVALUE3_, ARMY_ATTR.LIFE.defend, (nil)[1] = nil, nil, gBuffEffect.SOLDIER_BASE_DEFENSE
	_UPVALUE3_, ARMY_ATTR.LIFE.defend, (nil)[2] = nil, nil, gBuffEffect.INFANTRY_BASE_DEFENSE
	_UPVALUE3_, ARMY_ATTR.LIFE.defend, (nil)[3] = nil, nil, "dfPlus"
	ARMY_ATTR.ATTACK[gSoldierType.SOLDIER_TYPE_BUBING], ARMY_ATTR.LIFE.blood, (nil)[1] = ARMY_ATTR.LIFE, nil, gBuffEffect.SOLDIER_BASE_HP
	ARMY_ATTR.ATTACK[gSoldierType.SOLDIER_TYPE_BUBING], ARMY_ATTR.LIFE.blood, (nil)[2] = ARMY_ATTR.LIFE, nil, gBuffEffect.INFANTRY_BASE_HP
	ARMY_ATTR.ATTACK[gSoldierType.SOLDIER_TYPE_BUBING], ARMY_ATTR.LIFE.blood, (nil)[3] = ARMY_ATTR.LIFE, nil, "hpPlus"
	_UPVALUE3_, _ENV = nil, ARMY_ATTR.LIFE
	_UPVALUE3_, ARMY_ATTR.LIFE.attack, (nil)[1] = nil, nil, gBuffEffect.SOLDIER_BASE_ATTACK
	_UPVALUE3_, ARMY_ATTR.LIFE.attack, (nil)[2] = nil, nil, gBuffEffect.CAVALRY_BASE_ATTACK
	_UPVALUE3_, ARMY_ATTR.LIFE.attack, (nil)[3] = nil, nil, "akPlus"
	_UPVALUE3_, ARMY_ATTR.LIFE.defend, (nil)[1] = nil, nil, gBuffEffect.SOLDIER_BASE_DEFENSE
	_UPVALUE3_, ARMY_ATTR.LIFE.defend, (nil)[2] = nil, nil, gBuffEffect.CAVALRY_BASE_DEFENSE
	_UPVALUE3_, ARMY_ATTR.LIFE.defend, (nil)[3] = nil, nil, "dfPlus"
	ARMY_ATTR.ATTACK[gSoldierType.SOLDIER_TYPE_QIBING], ARMY_ATTR.LIFE.blood, (nil)[1] = ARMY_ATTR.LIFE, nil, gBuffEffect.SOLDIER_BASE_HP
	ARMY_ATTR.ATTACK[gSoldierType.SOLDIER_TYPE_QIBING], ARMY_ATTR.LIFE.blood, (nil)[2] = ARMY_ATTR.LIFE, nil, gBuffEffect.CAVALRY_BASE_HP
	ARMY_ATTR.ATTACK[gSoldierType.SOLDIER_TYPE_QIBING], ARMY_ATTR.LIFE.blood, (nil)[3] = ARMY_ATTR.LIFE, nil, "hpPlus"
	_UPVALUE3_, _ENV = nil, ARMY_ATTR.LIFE
	_UPVALUE3_, ARMY_ATTR.LIFE.attack, (nil)[1] = nil, nil, gBuffEffect.SOLDIER_BASE_ATTACK
	_UPVALUE3_, ARMY_ATTR.LIFE.attack, (nil)[2] = nil, nil, gBuffEffect.ARCHER_BASE_ATTACK
	_UPVALUE3_, ARMY_ATTR.LIFE.attack, (nil)[3] = nil, nil, "akPlus"
	_UPVALUE3_, ARMY_ATTR.LIFE.defend, (nil)[1] = nil, nil, gBuffEffect.SOLDIER_BASE_DEFENSE
	_UPVALUE3_, ARMY_ATTR.LIFE.defend, (nil)[2] = nil, nil, gBuffEffect.ARCHER_BASE_DEFENSE
	_UPVALUE3_, ARMY_ATTR.LIFE.defend, (nil)[3] = nil, nil, "dfPlus"
	ARMY_ATTR.ATTACK[gSoldierType.SOLDIER_TYPE_GONGBING], ARMY_ATTR.LIFE.blood, (nil)[1] = ARMY_ATTR.LIFE, nil, gBuffEffect.SOLDIER_BASE_HP
	ARMY_ATTR.ATTACK[gSoldierType.SOLDIER_TYPE_GONGBING], ARMY_ATTR.LIFE.blood, (nil)[2] = ARMY_ATTR.LIFE, nil, gBuffEffect.ARCHER_BASE_HP
	ARMY_ATTR.ATTACK[gSoldierType.SOLDIER_TYPE_GONGBING], ARMY_ATTR.LIFE.blood, (nil)[3] = ARMY_ATTR.LIFE, nil, "hpPlus"
	_UPVALUE3_, _ENV = nil, ARMY_ATTR.LIFE
	_UPVALUE3_, ARMY_ATTR.LIFE.attack, (nil)[1] = nil, nil, gBuffEffect.SOLDIER_BASE_ATTACK
	_UPVALUE3_, ARMY_ATTR.LIFE.attack, (nil)[2] = nil, nil, gBuffEffect.CHARIOTS_BASE_ATTACK
	_UPVALUE3_, ARMY_ATTR.LIFE.attack, (nil)[3] = nil, nil, "akPlus"
	_UPVALUE3_, ARMY_ATTR.LIFE.defend, (nil)[1] = nil, nil, gBuffEffect.SOLDIER_BASE_DEFENSE
	_UPVALUE3_, ARMY_ATTR.LIFE.defend, (nil)[2] = nil, nil, gBuffEffect.CHARIOTS_BASE_DEFENSE
	_UPVALUE3_, ARMY_ATTR.LIFE.defend, (nil)[3] = nil, nil, "dfPlus"
	ARMY_ATTR.ATTACK[gSoldierType.SOLDIER_TYPE_CHEBING], ARMY_ATTR.LIFE.blood, (nil)[1] = ARMY_ATTR.LIFE, nil, gBuffEffect.SOLDIER_BASE_HP
	ARMY_ATTR.ATTACK[gSoldierType.SOLDIER_TYPE_CHEBING], ARMY_ATTR.LIFE.blood, (nil)[2] = ARMY_ATTR.LIFE, nil, gBuffEffect.CHARIOTS_BASE_HP
	ARMY_ATTR.ATTACK[gSoldierType.SOLDIER_TYPE_CHEBING], ARMY_ATTR.LIFE.blood, (nil)[3] = ARMY_ATTR.LIFE, nil, "hpPlus"
	_UPVALUE3_, _ENV = nil, ARMY_ATTR.LIFE
	_UPVALUE3_, ARMY_ATTR.LIFE.attack, (nil)[1] = nil, nil, gBuffEffect.SOLDIER_BASE_ATTACK
	_UPVALUE3_, ARMY_ATTR.LIFE.attack, (nil)[2] = nil, nil, gBuffEffect.ELITE_BASE_ATTACK
	_UPVALUE3_, ARMY_ATTR.LIFE.attack, (nil)[3] = nil, nil, "akPlus"
	_UPVALUE3_, ARMY_ATTR.LIFE.defend, (nil)[1] = nil, nil, gBuffEffect.SOLDIER_BASE_DEFENSE
	_UPVALUE3_, ARMY_ATTR.LIFE.defend, (nil)[2] = nil, nil, gBuffEffect.ELITE_BASE_DEFENSE
	_UPVALUE3_, ARMY_ATTR.LIFE.defend, (nil)[3] = nil, nil, "dfPlus"
	ARMY_ATTR.ATTACK[gSoldierType.SOLDIER_TYPE_ELITE], ARMY_ATTR.LIFE.blood, (nil)[1] = ARMY_ATTR.LIFE, nil, gBuffEffect.SOLDIER_BASE_HP
	ARMY_ATTR.ATTACK[gSoldierType.SOLDIER_TYPE_ELITE], ARMY_ATTR.LIFE.blood, (nil)[2] = ARMY_ATTR.LIFE, nil, gBuffEffect.ELITE_BASE_HP
	ARMY_ATTR.ATTACK[gSoldierType.SOLDIER_TYPE_ELITE], ARMY_ATTR.LIFE.blood, (nil)[3] = ARMY_ATTR.LIFE, nil, "hpPlus"
	local buffCfg = ARMY_ATTR.ATTACK
	local getShowValue = function(cfg, key)
		local buffList = cfg[key]
		local sourceValue = 0
		local baseValue = 0
		for k, v in pairs(sourceCfg) do
			local bValue = buffCtrl:getBuffEffect(buffList[1], v) or 0
			if v == gBuffSource.WAR_GEM then
				baseValue = baseValue + bValue
			else
				baseValue = baseValue + bValue / 1000
			end
		end
		for k, v in pairs(sourceCfg) do
			local bValue = buffCtrl:getBuffEffect(buffList[2], v) or 0
			baseValue = baseValue + bValue
		end
		if key == "attack" then
			local biographyAdd = armyLogic.getArmySpecialAtk(armyid)
			baseValue = baseValue + biographyAdd
			local petAdd = buffCtrl:getBuffEffect(gBuffEffect.SOLDIER_BASE_ATTACK, gBuffSource.PET) or 0
			baseValue = baseValue + petAdd
		end
		if key == "defend" then
			local biographyAdd = armyLogic.getArmySpecialDef(armyid)
			baseValue = baseValue + biographyAdd
		end
		if key == "blood" then
			local curArmyClass = serviceFunctions.getArmyClassByArmyId(armyid)
			local alv = serviceFunctions.getArmyViewLev(armyid)
			if curArmyClass == "archer" and alv == 125 then
				baseValue = baseValue + armyLogic.getArmySpecial(armyid, curArmyClass, gBuffEffect.LEV_125_ARCHER_BASE_HP)
			end
			if curArmyClass == "cavalry" and alv == 125 then
				baseValue = baseValue + armyLogic.getArmySpecial(armyid, curArmyClass, gBuffEffect.LEV_125_CAVALRY_BASE_HP)
			end
			if curArmyClass == "infantry" then
			end
			local petAdd = buffCtrl:getBuffEffect(gBuffEffect.SOLDIER_BASE_HP, gBuffSource.PET) or 0
			baseValue = baseValue + petAdd
		end
		local technologyCtrl = SoraDGetCtrl("technologyCtrl")
		baseValue = baseValue + technologyCtrl:getArmyBaseAdd(soldierType, key)
		local spSkill = 0
		local spInfo = armyltCtrl.mapArmySp[armyid]
		if spInfo then
			spSkill = spInfo[buffList[3]] or 0
		end
		sourceValue = sourceValue + spSkill / 1000
		return sourceValue, baseValue
	end
	local cfg = buffCfg[soldierType]
	if cfg then
		local attackValue = armyltCtrl.armyAttr(armyid, tableKey[1]) or 0
		local attackSV, attackBV = getShowValue(cfg, "attack")
		attackShow = SoraDPreciseDecimal((attackValue + attackBV) * (1 + attackSV), 1)
		local defendValue = armyltCtrl.armyAttr(armyid, tableKey[2]) or 0
		local defendSV, defendBV = getShowValue(cfg, "defend")
		defendShow = SoraDPreciseDecimal((defendValue + defendBV) * (1 + defendSV), 1)
		local bloodValue = armyltCtrl.armyAttr(armyid, tableKey[3]) or 0
		local bloodSV, bloodBV = getShowValue(cfg, "blood")
		bloodShow = SoraDPreciseDecimal((bloodValue + bloodBV) * (1 + bloodSV), 1)
	end
	if bType then
		if bType == 1 then
			return attackShow
		elseif bType == 2 then
			return defendShow
		elseif bType == 3 then
			return bloodShow
		end
	else
		return attackShow, defendShow, bloodShow
	end
end
function armyLogic.getCanTrainList(bid)
	local bid = tonumber(bid)
	local _ENV, ret = bid, bid
	local index = 1
	local blv = cityCtrl:getBuildMaxLv(bid)
	local isWarLv, wlv = buildLogic.isBuildWarLv(blv)
	local starLv = SoraDGetBuildStarLv(bid)
	if not armyltCtrl.getTrainArmyIDList(bid, wlv, starLv) then
		local _ENV, armyidlist = armyltCtrl.getTrainArmyIDList(bid, wlv, starLv), armyltCtrl.getTrainArmyIDList(bid, wlv, starLv)
	end
	local kingdomLevelDataModuleAPI = include("kingdomLevelDataModuleAPI")
	for k, armyid in pairs(armyidlist) do
		local iscantrain = armyLogic.isCanTrain(bid, armyid)
		if iscantrain then
			local isStarArmy = string.len(armyid) >= 10
			_ENV = nil
			;(nil).armyid = armyid
			;(nil).iscantrain = iscantrain
			;(nil).shiwei = math.floor(armyid % 100 / 10)
			;(nil).gewei = armyid % 10
			;(nil).isStarArmy = isStarArmy
			table.insert(ret, nil)
		end
	end
	local _ENV, cantrain = (for generator), pairs(armyidlist)
	local _ENV, cantnottrain = pairs(armyidlist)
	for i, v in ipairs(ret) do
		if v.iscantrain then
			table.insert(cantrain, v)
		else
			table.insert(cantnottrain, v)
		end
	end
	index = #cantrain
	if bid ~= BUILDID.FORTRESS then
		armyidsortfun(cantrain)
		armyidsortfun(cantnottrain)
	else
		trapidsortfun(cantrain)
		trapidsortfun(cantnottrain)
	end
	for i, v in ipairs(cantnottrain) do
		table.insert(cantrain, v)
	end
	return cantrain, index
end
function armyLogic.getCanTrainT(bid)
	local bid = tonumber(bid)
	local _ENV, ret = bid, bid
	local blv = cityCtrl:getBuildMaxLv(bid)
	local isWarLv, wlv = buildLogic.isBuildWarLv(blv)
	local starLv = SoraDGetBuildStarLv(bid)
	if not armyltCtrl.getTrainArmyIDList(bid, wlv, starLv) then
		local _ENV, armyidlist = armyltCtrl.getTrainArmyIDList(bid, wlv, starLv), armyltCtrl.getTrainArmyIDList(bid, wlv, starLv)
	end
	local kingdomLevelDataModuleAPI = include("kingdomLevelDataModuleAPI")
	for k, armyid in pairs(armyidlist) do
		local iscantrain = armyLogic.isCanTrain(bid, armyid)
		local armyLv = armyid % 100
		_ENV = nil
		;(nil).armyid = armyid
		;(nil).armyLv = armyLv
		;(nil).iscantrain = iscantrain
		table.insert(ret, nil)
	end
	table.sort(ret, function(a, b)
		return a.armyLv < b.armyLv
	end)
	local maxIndex = #ret
	local armyID = ret[maxIndex].armyid
	local isT = ret[maxIndex].iscantrain
	return armyID, isT
end
function armyLogic.getArmyIdByLevelAndBid(bid, level, wlv, starLv)
	local bid = tonumber(bid)
	local blv = cityCtrl:getBuildMaxLv(bid)
	if not wlv then
		_, wlv = buildLogic.isBuildWarLv(blv)
	end
	starLv = starLv or SoraDGetBuildStarLv(bid)
	local armyidlist = armyltCtrl.getTrainArmyIDList(bid, wlv, starLv)
	for _, armyid in pairs(armyidlist) do
		print("getCanTrainList", level, armyid, armyLogic.getArmyLV(armyid))
		if level == armyLogic.getArmyLV(armyid) then
			return armyid
		end
	end
end
function armyLogic.isCanTrain(bid, armyid)
	local bid = tonumber(bid)
	local armyid = tonumber(armyid)
	local ret = true
	local buildlv = cityCtrl:getBuildMaxLv(bid)
	local needlv = armyltCtrl.armyAttr(armyid, ARMY_ATTR.BARRACK_LEVEL)
	local starLv = SoraDGetBuildStarLv(bid)
	local starchange = armyltCtrl.armyAttr(armyid, ARMY_ATTR.STAR_CHANGE)
	local starLevel = armyltCtrl.armyAttr(armyid, ARMY_ATTR.STAR_LEVEL)
	if buildlv < needlv then
		ret = false
	end
	if starLv < starLevel then
		ret = false
	end
	local isWarframeArmy, armorType = armyltCtrl.isWarframeArmyID(armyid)
	if isWarframeArmy then
		if armorType == 1 then
			_ENV = nil
			;(nil).isArmyID = true
			;(nil).armyID = armyid
			ret = SoraDIsBrave8Level(nil)
		elseif armorType == 2 then
			_ENV = nil
			;(nil).isArmyID = true
			;(nil).armyID = armyid
			ret = SoraDIsGildedArmorOpen(nil)
		end
		if not IsArClient and serviceFunctions.systemTime() < include("constantRead").getConstValue("SOLDIERS_ARMOR_LIMIT_TIME_ROS") then
			ret = false
		end
	end
	return ret
end
function armyLogic.getTrainResCast(bid, armyid)
	local armyltCtrl, retCostRes
	local costres = armyltCtrl.armyAttr(armyid, ARMY_ATTR.COSTRES)
	if costres then
		for i = 1, #costres / 2 do
			local _resid = costres[2 * i - 1]
			local _rescount = costres[2 * i]
			_rescount = armyLogic.getArmyTrainResourceReduce(armyid, _rescount, _resid)
			local _curcount = cityCtrl:getResCount(_resid)
			armyltCtrl = _resid
			_resid.resid = _resid
			_resid.rescount = _rescount
			_resid.curcount = _curcount
			table.insert(retCostRes, _resid)
		end
	end
	local costtime = armyLogic.getTrainTime(armyid)
	if 800 < armyid and armyid < 899 then
		costtime = armyLogic.getTrapBuildTime(armyid)
	end
	armyltCtrl = armyLogic.getTrapBuildTime(armyid)
	armyLogic.getTrapBuildTime(armyid)._costRes = retCostRes
	local armyLogic.getTrapBuildTime(armyid)._costTime, retdata = costtime, armyLogic.getTrapBuildTime(armyid)
	if bid == BUILDID.ELITE_PALACE then
		local costElitePoint = armyltCtrl.getTrainCostElitePoint(armyid)
		local currentElitePoint = include("elitePalaceAPI"):getElitePoint()
		armyltCtrl = include("elitePalaceAPI")
		include("elitePalaceAPI").costElitePoint = costElitePoint
		local include("elitePalaceAPI").currentElitePoint, costElitePointInfo = currentElitePoint, include("elitePalaceAPI")
		retdata._costElitePointInfo = costElitePointInfo
	end
	return retdata
end
function armyLogic.armyIdMatchBid(bid, armyid)
	local bid = tonumber(bid)
	local armyid = tonumber(armyid)
	local ret = false
	local armyidlist = armyltCtrl.getArmyIDList(bid)
	for k, v in pairs(armyidlist) do
		if armyid == v then
			ret = true
			break
		end
	end
	return ret
end
function armyLogic.getEliteTroopTrainCountAdd()
	local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
	local techCount = technologyCtrl:getTechnologyPower(gTechnologyType.SOLDIER_COMPILE)
	gametop = technologyCtrl
	local technologyCtrl.buildingID, filterKey = BUILDID.ELITE_PALACE, technologyCtrl
	local attrValue = attributeSystem.query(gAttributeEnum.BUILDING_TRAIN_NUM, filterKey)
	return techCount + attrValue
end
function armyLogic.getEliteTroopMaxTrainCount()
	local defaultCount = 50
	local addCount = armyLogic.getEliteTroopTrainCountAdd()
	local trainCount = defaultCount + addCount
	local blv = cityCtrl:getBuildMaxLv(BUILDID.ELITE_PALACE)
	local limit = cityltCtrl.getSoldierLimit(blv)
	local armyCtrl = gametop.playertop_:getModule("armyCtrl")
	local currentArmyCount = armyCtrl:getCountByArmyType(gSoldierType.SOLDIER_TYPE_ELITE)
	local resurrectionCtrl = gametop.playertop_:getModule("resurrectionCtrl")
	local deadCountOfResurrection = resurrectionCtrl:getDeadArmyCount(gSoldierType.SOLDIER_TYPE_ELITE)
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local vip_add = buffCtrl:getBuffEffect(gBuffEffect.ELITE_SOLDIER_MAX_COUNT, gBuffSource.VIP) or 0
	local wargem_add = buffCtrl:getBuffEffect(gBuffEffect.ELITE_SOLDIER_MAX_COUNT, gBuffSource.WAR_GEM) or 0
	local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
	local tech_add = technologyCtrl:getTechnologyPower(gTechnologyType.ELITE_SOLDIER_LIMIT_VALUE_BOOST) or 0
	local lifeWaterCtrl = gametop.playertop_:getModule("lifeWaterCtrl")
	local deadCountOfLifeWater = lifeWaterCtrl:getDeadArmyCount(gSoldierType.SOLDIER_TYPE_ELITE)
	local queueCtrl = gametop.playertop_:getModule("queueCtrl")
	local promoteQueue = queueCtrl:queryQueue(gQueueTypeDef.prompt_army)
	local promotingArmy = 0
	if promoteQueue and promoteQueue.data.fromArmyID then
		local barrackID = armyltCtrl.armyAttr(promoteQueue.data.fromArmyID, ARMY_ATTR.BARRACK_ID)
		promotingArmy = barrackID == BUILDID.ELITE_PALACE and promoteQueue.data.count or 0
	end
	limit = limit + vip_add + wargem_add + tech_add - currentArmyCount - deadCountOfResurrection - deadCountOfLifeWater - promotingArmy
	limit = math.max(limit, 0)
	armyLogic, trainCount = math.min(trainCount, limit), math.min(trainCount, limit)
	math.min(trainCount, limit).base = defaultCount
	math.min(trainCount, limit).add = addCount
	local math.min(trainCount, limit).total, ret = trainCount, math.min(trainCount, limit)
	return ret
end
function armyLogic.getMaxTrainCount(bid)
	if BUILDID.ELITE_PALACE == bid then
		return armyLogic.getEliteTroopMaxTrainCount()
	end
	local init_count = 10
	local military_tent_traincount = buildLogic.getTrainCountAndSpeedAdd()
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local skill_countadd = lordInfoCtrl:getTechnologyPower(gLordTechnologyType.SINGLE_TRAINING_SOLDIERS_NUMBER)
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local buffAdd
	if IsArClient then
		buffAdd = buffCtrl:getBuffEffect(gBuffEffect.SINGLE_TRAINING_SOLDIERS_NUMBER) or 0
	else
		buffAdd = buffCtrl:getBuffEffect(gBuffEffect.SOLDIER_TRAIN_ADD_LIMIT) or 0
	end
	_ENV = buffCtrl:getBuffEffect(gBuffEffect.SOLDIER_TRAIN_ADD_LIMIT)
	local buffCtrl:getBuffEffect(gBuffEffect.SOLDIER_TRAIN_ADD_LIMIT).buildingID, filterKey = bid, buffCtrl:getBuffEffect(gBuffEffect.SOLDIER_TRAIN_ADD_LIMIT)
	local attrValue = attributeSystem.query(gAttributeEnum.BUILDING_TRAIN_NUM, filterKey)
	local armyCtrl = gametop.playertop_:getModule("armyCtrl")
	local toolAddInfo = armyCtrl:getSingleAddInfo()
	local tool_add_count = 0
	if toolAddInfo and next(toolAddInfo) and 0 < toolAddInfo.itemCount and 0 < toolAddInfo.addCount then
		tool_add_count = toolAddInfo.addCount
	end
	_ENV = toolAddInfo.addCount
	toolAddInfo.addCount.base = init_count + military_tent_traincount
	toolAddInfo.addCount.add = skill_countadd + buffAdd + attrValue
	local toolAddInfo.addCount.total, ret = skill_countadd + init_count + military_tent_traincount + tool_add_count + buffAdd + attrValue, toolAddInfo.addCount
	return ret
end
function armyLogic.getTrainTime(armyid)
	local armyid = tonumber(armyid)
	local basetime = armyltCtrl.armyAttr(armyid, ARMY_ATTR.TRAINING_TIME)
	local addPercent = 0
	if gSoldierType.SOLDIER_TYPE_ELITE == armyltCtrl.getSoldierType(armyid) then
		addPercent = armyLogic.getEliteSoldierAddPercent()
	else
		addPercent = armyLogic.getTrainTimeAddPercent(armyid)
	end
	local ret = basetime * (1 / (1 + addPercent))
	return ret
end
function armyLogic.getEliteSoldierAddPercent()
	local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
	local techAdd = technologyCtrl:getTechnologyPower(gTechnologyType.RECRUIT_HORN) or 0
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local equipadd = buffCtrl:getBuffEffect(gBuffEffect.TRAIN_SPEED_BOOST, gBuffSource.EQUIPMENT)
	equipadd = equipadd and equipadd / 1000 or 0
	local wargem_add = buffCtrl:getBuffEffect(gBuffEffect.TRAIN_SPEED_BOOST, gBuffSource.WAR_GEM) or 0
	wargem_add = wargem_add / 1000
	local vip_add = buffCtrl:getBuffEffect(gBuffEffect.ELITE_SOLDIER_TRAIN_SPEED_UP, gBuffSource.VIP) or 0
	vip_add = vip_add / 1000
	gametop = gBuffSource.VIP
	gBuffSource.VIP.buildingID = BUILDID.ELITE_PALACE
	local attrValue = attributeSystem.query(gAttributeEnum.BUILDING_TRAIN_SPEED_RATE, gBuffSource.VIP)
	attrValue = attrValue / 10000
	local addTotal = techAdd + equipadd + wargem_add + vip_add + attrValue
	return addTotal
end
function armyLogic.getTrainTimeAddPercent(armyid)
	local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local technologyAdd = technologyCtrl:getTechnologyPower(gTechnologyType.SOLDIERS_TRAIN_SPEED)
	local specialtechadd = armyLogic.getSpecialTechAddArmyTrain(armyid)
	local specialBuffAdd = armyLogic.getSpecialBuffAddArmyTrain(armyid)
	local _, military_tent_speedadd = buildLogic.getTrainCountAndSpeedAdd()
	local skill_speedadd = lordInfoCtrl:getTechnologyPower(gLordTechnologyType.SOLDIERS_TRAINING_SPEED)
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local buffValue = buffCtrl:getBuffEffect(gBuffEffect.TRAIN_SPEED_BOOST)
	buffValue = buffValue and buffValue / 1000 or 0
	local deBuffValue = buffCtrl:getBuffEffect(gBuffEffect.TRAIN_SPEED_REDUCE)
	deBuffValue = deBuffValue and deBuffValue / 1000 or 0
	local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
	local conquestwaradd = conquestWarCtrl:getConquestWarWinBuffList(gBuffEffect.TRAIN_SPEED_BOOST).totalEffect
	local bid = armyltCtrl.armyAttr(armyid, ARMY_ATTR.BARRACK_ID)
	gametop = nil
	;(nil).buildingID = bid
	local attrAdd = attributeSystem.query(gAttributeEnum.BUILDING_TRAIN_SPEED_RATE, nil)
	attrAdd = attrAdd / 10000
	local ret = buffValue - deBuffValue + technologyAdd + specialtechadd + military_tent_speedadd + skill_speedadd + conquestwaradd + specialBuffAdd + attrAdd
	return ret
end
function armyLogic.getTotalTrapCapacity()
	local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
	local bid = BUILDID.WALLS
	local walltrapcount = buildLogic.getBuildBaseValue(bid, "capacity")
	local technologyAdd = technologyCtrl:getTechnologyPower(gTechnologyType.TRAP_CAP)
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local gametop, buffValue = buffCtrl, buffCtrl:getBuffEffect(gBuffEffect.TRAP_MAX_NUM) or 0
	buffCtrl.base = walltrapcount
	buffCtrl.add = technologyAdd + buffValue
	local buffCtrl.total, ret = walltrapcount + technologyAdd + buffValue, buffCtrl
	return ret
end
function armyLogic.getMaxTrapBuildCount(armyid)
	local armyCtrl = gametop.playertop_:getModule("armyCtrl")
	local oneCount = 36000 / armyLogic.getTrapBuildTime(armyid)
	local trapTotalCount = armyLogic.getTotalTrapCapacity().total
	local curTrapCount = armyCtrl:getTrapTotalCount()
	local secondCount = trapTotalCount - curTrapCount
	local ret = oneCount
	if oneCount > secondCount then
		ret = secondCount
	end
	if ret < 0 then
		ret = 0
	end
	return math.floor(ret - 0.05)
end
function armyLogic.getTrapBuildTime(armyid)
	local basetime = armyltCtrl.armyAttr(armyid, ARMY_ATTR.TRAINING_TIME)
	local addPercent = armyLogic.getTrapBuildTimeAddPercent()
	local ret = basetime * (1 / (1 + addPercent))
	return ret
end
function armyLogic.getTrapBuildTimeAddPercent()
	local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local allianceScience = gametop.playertop_:getModule("allianceScience")
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local technologyAdd = technologyCtrl:getTechnologyPower(gTechnologyType.CONSTRUCTION_SPEED_TRAP)
	local skill_speedadd = lordInfoCtrl:getTechnologyPower(gLordTechnologyType.MANUFACTURING_SPEED_TRAPS)
	local allianceAdd = allianceScience:getScienceAddValue(gAScienceType.BUILD_TRAP_SPEED)
	local buffAdd = buffCtrl:getBuffEffect(gBuffEffect.MAKE_TRAP_SPEED_BOOST)
	buffAdd = buffAdd and buffAdd / 1000 or 0
	local ret = technologyAdd + skill_speedadd + allianceAdd + buffAdd
	return ret
end
function armyLogic.getHostpitalMaxCapacity()
	local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local baseTotalCapacity = buildLogic.getHostpitalTotalCapacity()
	local skill_add = lordInfoCtrl:getTechnologyPower(gLordTechnologyType.MAXIMUM_CAPACITY_HOSPITAL)
	local technologyAdd = technologyCtrl:getTechnologyPower(gTechnologyType.WOUNDED_QUANTITY)
	local vipadd = buffCtrl:getBuffEffect(gBuffEffect.WOUNDED_SOLDIER_LIMIT_BOOST, gBuffSource.VIP)
	if vipadd then
		vipadd = vipadd / 1000
	else
		vipadd = 0
	end
	local equipadd = buffCtrl:getBuffEffect(gBuffEffect.WOUNDED_SOLDIER_LIMIT_BOOST, gBuffSource.EQUIPMENT)
	if equipadd then
		equipadd = equipadd / 1000
	else
		equipadd = 0
	end
	local achieveadd = buffCtrl:getBuffEffect(gBuffEffect.WOUNDED_SOLDIER_LIMIT_BOOST, gBuffSource.ACHIEVEMENT)
	if achieveadd then
		achieveadd = achieveadd / 1000
	else
		achieveadd = 0
	end
	local petadd = buffCtrl:getBuffEffect(gBuffEffect.WOUNDED_SOLDIER_LIMIT_BOOST, gBuffSource.PET)
	if petadd then
		petadd = petadd / 1000
	else
		petadd = 0
	end
	local intetiorAdd = buffCtrl:getBuffEffect(gBuffEffect.WOUNDED_SOLDIER_LIMIT_BOOST, gBuffSource.PARLIAMENT)
	if intetiorAdd then
		intetiorAdd = intetiorAdd / 1000
	else
		intetiorAdd = 0
	end
	local buffAddValue = buffCtrl:getBuffEffect(gBuffEffect.WOUNDED_SOLDIER_VALUE_LIMIT_BOOST)
	buffAddValue = buffAddValue or 0
	local conquestwaradd = armyLogic.getConquestWarHostpitalMaxCapacityAddValue()
	local attrAdd = attributeSystem.query(gAttributeEnum.WOUNDED_CAPACITY_NUM) or 0
	local total = math.floor((1 + conquestwaradd) * (baseTotalCapacity + technologyAdd + skill_add + buffAddValue + attrAdd) * (1 + vipadd + equipadd + achieveadd + petadd + intetiorAdd))
	local totaladd = total - baseTotalCapacity
	gametop = 1 + vipadd + equipadd + achieveadd + petadd + intetiorAdd
	;(1 + vipadd + equipadd + achieveadd + petadd + intetiorAdd).base = baseTotalCapacity
	;(1 + vipadd + equipadd + achieveadd + petadd + intetiorAdd).add = totaladd
	local (1 + vipadd + equipadd + achieveadd + petadd + intetiorAdd).total, ret = total, 1 + vipadd + equipadd + achieveadd + petadd + intetiorAdd
	if worldMapDefine.isInWar() and not worldMapDefine.isInGarden() then
		ret.total = REGULAR_SEASON_WOUNDARMY_MAX
	end
	return ret
end
function armyLogic.getRadianceWarArmyCureTime(armyid)
	local radianceWarRead = include("radianceWarRead")
	local basecuretime = 0
	local sType, lv = armyltCtrl.getArmyTypeAndLv(armyid)
	basecuretime = radianceWarRead.getRadianceWarArmyCureTime(lv)
	local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
	local technologyAdd = technologyCtrl:getTechnologyPower(gTechnologyType.RADIANCE_WAR_WOUNDED_SOLDIER_RECOVERY_SPEED_ADD) or 0
	local ret = basecuretime * (1 / (1 + technologyAdd))
	return ret
end
function armyLogic.getArmyCureTime(armyid, ignoreLegend, isInRadience, warType)
	armyid = tonumber(armyid)
	if isInRadience then
		return armyLogic.getRadianceWarArmyCureTime(armyid)
	end
	return armyLogic.getNormalArmyCureTime(armyid, ignoreLegend, warType)
end
function armyLogic.getArmorArmyBaseCureTime(armyid)
	local tempArmyId = math.floor(tonumber(armyid) / 100) * 100 + 12
	local timeTemp = armyLogic.getTrainTime(tempArmyId)
	local armorId = armorSystemRead:getArmorIdByArmyId(armyid)
	local armorSystemCtrl = SoraDGetCtrl("armorSystemCtrl")
	local armorForgingTime = armorSystemCtrl:getArmorForgTime(armorId)
	local basetime = timeTemp + armorForgingTime
	return basetime
end
function armyLogic.getNormalArmyCureTime(armyid, ignoreLegend, warType)
	local basetime = 0
	local sType, lv = armyltCtrl.getArmyTypeAndLv(armyid)
	if armyltCtrl.isWarframeArmyID(armyid) then
		basetime = armyLogic.getArmorArmyBaseCureTime(armyid)
	else
		basetime = armyLogic.getTrainTime(armyid)
	end
	local basecuretime = basetime * gConstValue.UNIT_ARMY_CURE_TIME
	local addPercent = armyLogic.getArmyCureTimeAddPercent(armyid, ignoreLegend, warType)
	local ret = basecuretime * (1 / (1 + addPercent))
	return ret
end
function armyLogic.getAtlantisWarArmyCureTime(armyid)
	local curetime = armyLogic.getNormalArmyCureTime(armyid)
	local ret = curetime / 2
	return ret
end
function armyLogic.getRoaringFlameArmyCureTime(armyid)
	local curetime = armyLogic.getNormalArmyCureTime(armyid)
	local roaringFlameWarRead = include("roaringFlameWarRead")
	local percent = roaringFlameWarRead.getConstValue("FLAMES_DUNES_ARMY_CURE_TIME", 500) / 1000
	local ret = curetime * percent
	return ret
end
function armyLogic.getArmyCureTimeAddPercent(armyid, ignoreLegend, warType)
	local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local allianceMgr = SoraDGetCtrl("allianceMgr")
	local mapBuffCtrl = SoraDGetCtrl("mapBuffCtrl")
	local skill_add = lordInfoCtrl:getTechnologyPower(gLordTechnologyType.HOSPITAL_WOUNDED_SPEED)
	local technologyAdd = technologyCtrl:getTechnologyPower(gTechnologyType.WOUNDED_REPLY)
	local specialtechadd = armyLogic.getSpecialTechAddArmyCure(armyid)
	local specialBuffAdd = armyLogic.getSpecialBuffAddArmyCure(armyid)
	local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
	local conquestwaradd = conquestWarCtrl:getConquestWarWinBuffList(gBuffEffect.CURE_SOLDIER_SPEED_BOOST).totalEffect
	local buffAdd = buffCtrl:getBuffEffect(gBuffEffect.CURE_SOLDIER_SPEED_BOOST) or 0
	local attrAdd = mapBuffCtrl:getBuffEffect(gAttributeEnum.CURE_SOLDIER_SPEED_BOOST_RANGE)
	buffAdd = buffAdd + attrAdd / 10
	buffAdd = buffAdd / 1000
	local legendLordWarAdd = 0
	local radianWarAdd = 0
	local roaringFlameAdd = 0
	if not ignoreLegend then
		if worldMapDefine.isInLegendLord() or warType == gKingdomClassType.legendLord then
			local legendLordWarCtrl = gametop.playertop_:getModule("legendLordWarCtrl")
			local mapId = gametop.playertop_:getMapID()
			if warType == gKingdomClassType.legendLord then
				mapId = legendLordWarCtrl:getMapid()
			end
			legendLordWarAdd = legendLordWarCtrl:getCureSpeed(mapId)
		elseif worldMapDefine.isInRemains() then
			local constantRead = include("constantRead")
			legendLordWarAdd = constantRead.getConstCureSpeed_remains()
			legendLordWarAdd = legendLordWarAdd + remainsWarCtrl:getRemainsWarPlayerBuffValue(gBuffEffect.CURE_SOLDIER_SPEED_BOOST) / 1000
		elseif worldMapDefine.isInNebulaEmperor() then
			local nebulaEmperorRead = include("nebulaEmperorRead")
			legendLordWarAdd = nebulaEmperorRead.getTreatmentSpeed()
		elseif worldMapDefine.isInRoaringFlame() then
			local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
			roaringFlameAdd = roaringFlameWarCtrl:getDecreeBuffValue(gBuffEffect.CURE_SOLDIER_SPEED_BOOST) / 1000
		end
	end
	local gametop, battlefieldType = kingdomMapCtrl, kingdomMapCtrl:getKingdomClass() or gKingdomClassType.normal
	local kingdomMapCtrl.battleField, attrFilter = battlefieldType, kingdomMapCtrl
	local attrAdd = attributeSystem.query(gAttributeEnum.CURE_SOLDIER_SPEED_BOOST, attrFilter) or 0
	attrAdd = attrAdd / 10000
	local ret = skill_add + technologyAdd + specialtechadd + buffAdd + conquestwaradd + legendLordWarAdd + specialBuffAdd + attrAdd + radianWarAdd + roaringFlameAdd
	return ret
end
function armyLogic.isUnlockWarTechnology()
	_UPVALUE4_ = nil
	;(nil)[1] = 170046
	;(nil)[2] = 170047
	;(nil)[3] = 170048
	local (nil)[4], tidArray = 170049, nil
	local ret = false
	local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
	for k, v in ipairs(tidArray) do
		if technologyCtrl:getTechnoDataByID(v, "process") then
			ret = true
			break
		end
	end
	return ret
end
function armyLogic.cureWoundedArmyResTransfer(totalCostRes, warType)
	local meteorCrystalCount = totalCostRes[gIDDef.METEOR_CRYSTAL] or 0
	meteorCrystalCount = tonumber(meteorCrystalCount)
	local worldMapWarDef = include("worldMapWarDef")
	local crystalID = worldMapWarDef.getWarCrystalID(warType)
	local legendCrystalCount = cityCtrl:getResCount(crystalID)
	local coefficient = 0
	if worldMapDefine.isInNebulaEmperor() then
		local nebulaEmperorRead = include("nebulaEmperorRead")
		coefficient = nebulaEmperorRead.getConstValue("crystalchange", 1000)
		coefficient = coefficient / 1000
	else
		local constantRead = include("constantRead")
		coefficient = constantRead.getConstValue("LEGEND_CRYSTAL_CHANGE", 1000)
		coefficient = coefficient / 1000
	end
	local needLegendCrystal = meteorCrystalCount * coefficient
	if not worldMapWarDef.checkCanUseMeteorCrystal() then
		totalCostRes[gIDDef.METEOR_CRYSTAL] = 0
		totalCostRes[crystalID] = needLegendCrystal
	elseif legendCrystalCount >= needLegendCrystal then
		totalCostRes[gIDDef.METEOR_CRYSTAL] = 0
		totalCostRes[crystalID] = needLegendCrystal
	else
		local transMeteorCrystal = legendCrystalCount / coefficient
		if 0 < transMeteorCrystal then
			totalCostRes[gIDDef.METEOR_CRYSTAL] = meteorCrystalCount - transMeteorCrystal
			totalCostRes[crystalID] = legendCrystalCount
		end
	end
	return totalCostRes
end
function armyLogic.getArmyCureCostRes(armyid, ignoreLegend, warType)
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local armyid = tonumber(armyid)
	local gametop, retCostRes = armyid, armyid
	local costres = armyltCtrl.armyAttr(armyid, ARMY_ATTR.COSTRES)
	local _, level = armyltCtrl.getArmyTypeAndLv(armyid)
	if costres then
		for i = 1, #costres / 2 do
			local _resid = costres[2 * i - 1]
			local _rescount = costres[2 * i] * gConstValue.UNIT_ARMY_CURE_COSTRES
			local skill_add = lordInfoCtrl:getTechnologyPower(gLordTechnologyType.TREATMENT_WOUNDED_RESOURCE)
			local buff_add = buffCtrl:getBuffEffect(gBuffEffect.TREATMENT_WOUNDED_RESOURCE) or 0
			buff_add = buff_add and buff_add / 1000
			local finalValue = 1 - skill_add - buff_add
			if finalValue < 0 then
				finalValue = 0
				print("getArmyCureCostRes reduce 100%", armyid, finalValue)
			end
			_rescount = _rescount * finalValue
			if not ignoreLegend then
				if worldMapDefine.isInLegendLord() or warType == gKingdomClassType.legendLord then
					local legendLordWarCtrl = gametop.playertop_:getModule("legendLordWarCtrl")
					local mapId = gametop.playertop_:getMapID()
					if warType == gKingdomClassType.legendLord then
						mapId = legendLordWarCtrl:getMapid()
					end
					local percent = (100 - legendLordWarCtrl:getCostResPercent(mapId, level, _resid)) / 100
					_rescount = _rescount * percent
				elseif worldMapDefine.isInNebulaEmperor() then
					local nebulaEmperorRead = include("nebulaEmperorRead")
					local percent = nebulaEmperorRead.getCostResPercent(level, _resid)
					_rescount = _rescount * percent
				end
			end
			local _curcount = cityCtrl:getResCount(_resid)
			gametop = _resid
			_resid.resid = _resid
			_resid.rescount = _rescount
			_resid.curcount = _curcount
			table.insert(retCostRes, _resid)
		end
	end
	return retCostRes
end
function armyLogic.getArmyLV(armyid)
	local lv = armyid % 100
	return lv
end
function armyLogic.getTrapLV(trapid)
	local lv = trapid % 100 % 10
	return lv
end
function armyLogic.isStarArmy(armyid)
	local starLv = armyltCtrl.armyAttr(armyid, ARMY_ATTR.STAR_LEVEL)
	return 0 < starLv
end
function armyLogic.isElephantArmy(armyid)
	local ret = false
	local lv = armyLogic.getArmyLV(armyid)
	local isStar = armyLogic.isStarArmy(armyid)
	local soldierType = armyltCtrl.getSoldierType(armyid)
	if gSoldierType.SOLDIER_TYPE_CHEBING == soldierType and (lv == 11 or isStar) then
		ret = true
	end
	return ret
end
function armyLogic.getArmyCateCount()
	local _ENV, ret
	ret[BUILDID.CHARIOT_PLANT] = 0
	ret[BUILDID.STABLES] = 0
	ret[BUILDID.RANGE] = 0
	ret[BUILDID.BARRACKS] = 0
	local armyCtrl = gametop.playertop_:getModule("armyCtrl")
	local totalarmy = armyCtrl:getTotalArmyList()
	for k, v in pairs(totalarmy) do
		local armyid = tonumber(k)
		local armycount = tonumber(v)
		local soldierType = armyltCtrl.getSoldierType(armyid)
		if gSoldierType.SOLDIER_TYPE_BUBING == soldierType then
			ret[BUILDID.CHARIOT_PLANT] = ret[BUILDID.CHARIOT_PLANT] + armycount
		elseif gSoldierType.SOLDIER_TYPE_QIBING == soldierType then
			ret[BUILDID.STABLES] = ret[BUILDID.STABLES] + armycount
		elseif gSoldierType.SOLDIER_TYPE_GONGBING == soldierType then
			ret[BUILDID.RANGE] = ret[BUILDID.RANGE] + armycount
		elseif gSoldierType.SOLDIER_TYPE_CHEBING == soldierType then
			ret[BUILDID.BARRACKS] = ret[BUILDID.BARRACKS] + armycount
		end
	end
	local _ENV, arrayRet = (for generator), pairs(totalarmy)
	local index = 1
	if 0 < ret[BUILDID.STABLES] then
		_ENV = ret[BUILDID.STABLES]
		ret[BUILDID.STABLES].bid = BUILDID.STABLES
		arrayRet[index], ret[BUILDID.STABLES].number = ret[BUILDID.STABLES], ret[BUILDID.STABLES]
		index = index + 1
	end
	if ret[BUILDID.CHARIOT_PLANT] > 0 then
		_ENV = ret[BUILDID.CHARIOT_PLANT]
		ret[BUILDID.CHARIOT_PLANT].bid = BUILDID.CHARIOT_PLANT
		arrayRet[index], ret[BUILDID.CHARIOT_PLANT].number = ret[BUILDID.CHARIOT_PLANT], ret[BUILDID.CHARIOT_PLANT]
		index = index + 1
	end
	if 0 < ret[BUILDID.RANGE] then
		_ENV = ret[BUILDID.RANGE]
		ret[BUILDID.RANGE].bid = BUILDID.RANGE
		arrayRet[index], ret[BUILDID.RANGE].number = ret[BUILDID.RANGE], ret[BUILDID.RANGE]
		index = index + 1
	end
	if 0 < ret[BUILDID.BARRACKS] then
		_ENV = ret[BUILDID.BARRACKS]
		ret[BUILDID.BARRACKS].bid = BUILDID.BARRACKS
		arrayRet[index], ret[BUILDID.BARRACKS].number = ret[BUILDID.BARRACKS], ret[BUILDID.BARRACKS]
		index = index + 1
	end
	return arrayRet
end
function armyLogic.getEliteArmyCateCount()
	local eliteArmyTotal = 0
	local gametop, arrayRet
	local armyCtrl = gametop.playertop_:getModule("armyCtrl")
	local totalarmy = armyCtrl:getTotalArmyList()
	for k, v in pairs(totalarmy) do
		local armyid = tonumber(k)
		local armycount = tonumber(v)
		local soldierType = armyltCtrl.getSoldierType(armyid)
		if gSoldierType.SOLDIER_TYPE_ELITE == soldierType then
			eliteArmyTotal = eliteArmyTotal + armycount
		end
	end
	if 0 < eliteArmyTotal then
		gametop = pairs(totalarmy)
		pairs(totalarmy).bid = BUILDID.ELITE_PALACE
		pairs(totalarmy).number = eliteArmyTotal
		table.insert(arrayRet, pairs(totalarmy))
	end
	return arrayRet
end
function armyLogic.getCanBuildTrapMaxLV()
	local maxlv = 0
	local traplist = armyLogic.getCanTrainList(BUILDID.FORTRESS)
	for k, v in pairs(traplist) do
		if v.iscantrain then
			local lv = armyLogic.getTrapLV(v.armyid)
			if maxlv < lv then
				maxlv = lv
			end
		end
	end
	return maxlv
end
function armyLogic.randMaxLvTrapID()
	local maxlv = armyLogic.getCanBuildTrapMaxLV()
	local armyLogic, maxlvlist
	local traplist = armyLogic.getCanTrainList(BUILDID.FORTRESS)
	for k, v in pairs(traplist) do
		if v.iscantrain then
			local lv = armyLogic.getTrapLV(v.armyid)
			if maxlv == lv then
				table.insert(maxlvlist, v.armyid)
			end
		end
	end
	return maxlvlist
end
function armyLogic.getArmyTypeByID(armyid)
	local armyType
	for k, v in pairs(ID_TROOP) do
		if armyid >= v.START and armyid <= v.ENDID then
			armyType = k
			break
		end
	end
	return armyType
end
function armyLogic.isArmyQueueType(queueType)
	local ret = false
	local queueType = tonumber(queueType)
	if queueType == gQueueTypeDef.hostpital_queue then
		ret = true
	elseif queueType == gQueueTypeDef.chariot_plant_queue then
		ret = true
	elseif queueType == gQueueTypeDef.stables_queue then
		ret = true
	elseif queueType == gQueueTypeDef.range_queue then
		ret = true
	elseif queueType == gQueueTypeDef.barracks_queue then
		ret = true
	elseif queueType == gQueueTypeDef.frotress_queue then
		ret = true
	elseif queueType == gQueueTypeDef.elite_queue then
		ret = true
	elseif queueType == gQueueTypeDef.prompt_army then
		ret = true
	elseif queueType == gQueueTypeDef.armor_forging then
		ret = true
	end
	return ret
end
function armyLogic.getSpecialBuffAddArmyTrain(armyid)
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local ret = 0
	local armytp = armyltCtrl.armyAttr(armyid, ARMY_ATTR.ARMY_TYPE)
	local _, level = armyltCtrl.getArmyTypeAndLv(armyid)
	if armytp == gArmyType.infantryDf or armytp == gArmyType.infantryAk then
		local buffValue = buffCtrl:getBuffEffect(gBuffEffect.INFANTRY_TRAIN_BOOST) or 0
		if level <= 10 then
			local buffValue10 = buffCtrl:getBuffEffect(gBuffEffect.INFANTRY_TRAIN_BOOST_LESS_10) or 0
			buffValue = buffValue + buffValue10
		end
		if level <= 11 then
			local buffValue11 = buffCtrl:getBuffEffect(gBuffEffect.INFANTRY_TRAIN_BOOST_LESS_11) or 0
			buffValue = buffValue + buffValue11
		end
		ret = buffValue / 1000
	elseif armytp == gArmyType.cavalry or armytp == gArmyType.cavalryArrow then
		local buffValue = buffCtrl:getBuffEffect(gBuffEffect.CAVALRY_TRAIN_BOOST) or 0
		if level <= 10 then
			local buffValue10 = buffCtrl:getBuffEffect(gBuffEffect.CAVALRY_TRAIN_BOOST_LESS_10) or 0
			buffValue = buffValue + buffValue10
		end
		if level <= 11 then
			local buffValue11 = buffCtrl:getBuffEffect(gBuffEffect.CAVALRY_TRAIN_BOOST_LESS_11) or 0
			buffValue = buffValue + buffValue11
		end
		ret = buffValue / 1000
	elseif armytp == gArmyType.archer or armytp == gArmyType.crossbow then
		local buffValue = buffCtrl:getBuffEffect(gBuffEffect.ARCHER_TRAIN_BOOST) or 0
		if level <= 10 then
			local buffValue10 = buffCtrl:getBuffEffect(gBuffEffect.ARCHER_TRAIN_BOOST_LESS_10) or 0
			buffValue = buffValue + buffValue10
		end
		if level <= 11 then
			local buffValue11 = buffCtrl:getBuffEffect(gBuffEffect.ARCHER_TRAIN_BOOST_LESS_11) or 0
			buffValue = buffValue + buffValue11
		end
		ret = buffValue / 1000
	elseif armytp == gArmyType.charists or armytp == gArmyType.siegeVehicles then
		local buffValue = buffCtrl:getBuffEffect(gBuffEffect.SIEGE_VEHICLES_TRAIN_BOOST) or 0
		if level <= 10 then
			local buffValue10 = buffCtrl:getBuffEffect(gBuffEffect.SIEGE_VEHICLES_TRAIN_BOOST_LESS_10) or 0
			buffValue = buffValue + buffValue10
		end
		if level <= 11 then
			local buffValue11 = buffCtrl:getBuffEffect(gBuffEffect.SIEGE_VEHICLES_TRAIN_BOOST_LESS_11) or 0
			buffValue = buffValue + buffValue11
		end
		ret = buffValue / 1000
	end
	return ret
end
function armyLogic.getSpecialBuffAddArmyCure(armyid)
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local ret = 0
	local armytp = armyltCtrl.armyAttr(armyid, ARMY_ATTR.ARMY_TYPE)
	if armytp == gArmyType.infantryDf or armytp == gArmyType.infantryAk then
		local buffValue = buffCtrl:getBuffEffect(gBuffEffect.INFANTRY_CURE_BOOST) or 0
		ret = buffValue / 1000
	elseif armytp == gArmyType.cavalry or armytp == gArmyType.cavalryArrow then
		local buffValue = buffCtrl:getBuffEffect(gBuffEffect.CAVALRY_CURE_BOOST) or 0
		ret = buffValue / 1000
	elseif armytp == gArmyType.archer or armytp == gArmyType.crossbow then
		local buffValue = buffCtrl:getBuffEffect(gBuffEffect.ARCHER_CURE_BOOST) or 0
		ret = buffValue / 1000
	elseif armytp == gArmyType.charists or armytp == gArmyType.siegeVehicles then
		local buffValue = buffCtrl:getBuffEffect(gBuffEffect.SIEGE_VEHICLES_CURE_BOOST) or 0
		ret = buffValue / 1000
	end
	return ret
end
function armyLogic.getArmyTrainResourceReduce(armyid, resourceNum, resid)
	local ret = 0
	local buffValue = 0
	local suitArmyTpVal = 0
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local armytp = armyltCtrl.armyAttr(armyid, ARMY_ATTR.ARMY_TYPE)
	if armytp == gArmyType.infantryDf or armytp == gArmyType.infantryAk then
		buffValue = buffCtrl:getBuffEffect(gBuffEffect.INFANTRY_TRAIN_RESOURCE_REDUCE) or 0
		suitArmyTpVal = buffCtrl:getBuffEffect(gBuffEffect.SUIT_INFANTRY_TRAIN_RESOURCE_REDUCE) or 0
	elseif armytp == gArmyType.cavalry or armytp == gArmyType.cavalryArrow then
		buffValue = buffCtrl:getBuffEffect(gBuffEffect.CAVALRY_TRAIN_RESOURCE_REDUCE) or 0
		suitArmyTpVal = buffCtrl:getBuffEffect(gBuffEffect.SUIT_CAVALRY_TRAIN_RESOURCE_REDUCE) or 0
	elseif armytp == gArmyType.archer or armytp == gArmyType.crossbow then
		buffValue = buffCtrl:getBuffEffect(gBuffEffect.ARCHER_TRAIN_RESOURCE_REDUCE) or 0
		suitArmyTpVal = buffCtrl:getBuffEffect(gBuffEffect.SUIT_ARCHER_TRAIN_RESOURCE_REDUCE) or 0
	elseif armytp == gArmyType.charists or armytp == gArmyType.siegeVehicles then
		buffValue = buffCtrl:getBuffEffect(gBuffEffect.SIEGE_VEHICLES_TRAIN_RESOURCE_REDUCE) or 0
		suitArmyTpVal = buffCtrl:getBuffEffect(gBuffEffect.SUIT_SIEGE_VEHICLES_TRAIN_RESOURCE_REDUCE) or 0
	end
	buffValue = buffValue + (buffCtrl:getBuffEffect(gBuffEffect.ARMY_TRAIN_COST_RESOURCE_REDUCE) or 0)
	suitArmyTpVal = suitArmyTpVal + (buffCtrl:getBuffEffect(gBuffEffect.SUIT_ARMY_TRAIN_RESOURCE_REDUCE) or 0)
	buffValue = buffValue / 1000
	suitArmyTpVal = suitArmyTpVal / 1000
	print(suitArmyTpVal, "suitArmyTpVal")
	local reduceBuildMastery = buffCtrl:getBuffEffect(gBuffEffect.TRAIN_COST_RESOURCE_REDUCE) or 0
	reduceBuildMastery = reduceBuildMastery / 1000
	if armytp == gArmyType.elite or armytp == gArmyType.trap then
		reduceBuildMastery = 0
	end
	local reduceBuildStar = 0
	local calIndex = 1
	local buffID = 0
	local bid = 0
	local armyLv = armyid % 100
	if resid == gIDDef.FOOD then
		bid = BUILDID.FARM
	elseif resid == gIDDef.WOOD then
		bid = BUILDID.SAWMILL
	elseif resid == gIDDef.IRON then
		bid = BUILDID.IRON_MINE
	elseif resid == gIDDef.MITHRIL then
		bid = BUILDID.STEEL
	elseif resid == gIDDef.CRYSTAL then
		bid = BUILDID.CRYSTAL_MINE
	end
	if 0 < bid and 10 <= armyLv then
		local buildlist = cityCtrl:getBuildCellList(bid)
		for k, v in pairs(buildlist) do
			local starLv = 0
			if v.info and v.info.starLv then
				starLv = tonumber(v.info.starLv)
			end
			if not cityltCtrl.buildStarLvInfo(bid, starLv, "buff") then
				local gametop, buff = cityltCtrl.buildStarLvInfo(bid, starLv, "buff"), cityltCtrl.buildStarLvInfo(bid, starLv, "buff")
			end
			if 1 <= starLv then
				calIndex = calIndex * (1 - buff[2] / 10000)
			end
		end
		reduceBuildStar = reduceBuildStar + (1 - calIndex)
	end
	if armytp == gArmyType.elite or armytp == gArmyType.trap then
		reduceBuildStar = 0
	end
	ret = resourceNum * (1 - buffValue - reduceBuildStar) * (1 - reduceBuildMastery) * (1 - suitArmyTpVal)
	if ret < 0 then
		print("getArmyTrainResourceReduce", buffValue, armyid)
		ret = 0
	end
	return ret
end
function armyLogic.getSpecialTechAddArmyTrain(armyid)
	local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
	local ret = 0
	local armytp = armyltCtrl.armyAttr(armyid, ARMY_ATTR.ARMY_TYPE)
	if armytp == gArmyType.infantryDf or armytp == gArmyType.infantryAk then
		ret = technologyCtrl:getTechnologyPower(gTechnologyType.TRAIN_FOOTSOLDIER_SPEED_BOOST)
	elseif armytp == gArmyType.cavalry or armytp == gArmyType.cavalryArrow then
		ret = technologyCtrl:getTechnologyPower(gTechnologyType.TRAIN_CAVALRY_SPEED_BOOST)
	elseif armytp == gArmyType.archer or armytp == gArmyType.crossbow then
		ret = technologyCtrl:getTechnologyPower(gTechnologyType.TRAIN_ARCHER_SPEED_BOOST)
	elseif armytp == gArmyType.charists or armytp == gArmyType.siegeVehicles then
		ret = technologyCtrl:getTechnologyPower(gTechnologyType.TRAIN_CHARIOTS_SPEED_BOOST)
	end
	return ret
end
function armyLogic.getSpecialTechAddArmyCure(armyid)
	local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
	local ret = 0
	local armytp = armyltCtrl.armyAttr(armyid, ARMY_ATTR.ARMY_TYPE)
	if armytp == gArmyType.infantryDf or armytp == gArmyType.infantryAk then
		ret = technologyCtrl:getTechnologyPower(gTechnologyType.CURE_FOOTSOLDIER_SPEED_BOOST)
	elseif armytp == gArmyType.cavalry or armytp == gArmyType.cavalryArrow then
		ret = technologyCtrl:getTechnologyPower(gTechnologyType.CURE_CAVALRY_SPEED_BOOST)
	elseif armytp == gArmyType.archer or armytp == gArmyType.crossbow then
		ret = technologyCtrl:getTechnologyPower(gTechnologyType.CURE_ARCHER_SPEED_BOOST)
	elseif armytp == gArmyType.charists or armytp == gArmyType.siegeVehicles then
		ret = technologyCtrl:getTechnologyPower(gTechnologyType.CURE_CHARIOTS_SPEED_BOOST)
	end
	return ret
end
function armyLogic.getArmyCostFoodAddPercent()
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
	local costfooddebuff = buffCtrl:getBuffEffect(gBuffEffect.FOOD_CONSUME_REDUCE, gBuffSource.CITY)
	costfooddebuff = costfooddebuff and costfooddebuff / 1000 or 0
	local deBuffValue = buffCtrl:getBuffEffect(gBuffEffect.FOOD_CONSUME_BOOST)
	deBuffValue = deBuffValue and deBuffValue / 1000 or 0
	local buffValue = buffCtrl:getBuffEffect(gBuffEffect.FOOD_CONSUME_REDUCE)
	buffValue = buffValue and buffValue / 1000 or 0
	buffValue = buffValue - costfooddebuff
	local add_technology = technologyCtrl:getTechnologyPower(gTechnologyType.FRCES_CONSUMPTION)
	local ret = 1 / (1 + add_technology + buffValue - deBuffValue) * (1 - costfooddebuff)
	if ret < 0 then
		ret = 0
	end
	return ret
end
function armyLogic.getArmyIDListCanTrain(bid)
	local cityCtrl, ret
	local blv = cityCtrl:getBuildMaxLv(bid)
	local isWarLv, wlv = buildLogic.isBuildWarLv(blv)
	local armyidlist = armyltCtrl.getTrainArmyIDList(bid, wlv)
	for k, v in pairs(armyidlist) do
		if armyLogic.isCanTrain(bid, v) then
			table.insert(ret, v)
		end
	end
	return ret
end
function armyLogic.getConquestWarHostpitalMaxCapacityAddValue()
	local ret = 0
	local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
	if conquestWarCtrl.conquestWarState == gConquestWarState.OPENING then
		ret = CONQUESTWAR_HOSTPITAL_MAX_CAPACITY_ADD_VALUE
	end
	return ret
end
function armyLogic.transformNewArmyID(armyID)
	armyID = tonumber(armyID)
	if not armyID then
		Log.e("army log: transformNewArmyID failed! armyID = ", armyID)
		return armyID
	end
	local soldierType = armyltCtrl.getSoldierType(armyID)
	if gSoldierType.SOLDIER_TYPE_BUBING == soldierType or gSoldierType.SOLDIER_TYPE_QIBING == soldierType or gSoldierType.SOLDIER_TYPE_GONGBING == soldierType or gSoldierType.SOLDIER_TYPE_CHEBING == soldierType then
		local bid = armyltCtrl.armyAttr(armyID, ARMY_ATTR.BARRACK_ID)
		if bid then
			local blv = cityCtrl:getBuildMaxLv(bid)
			local ret, wlv = buildLogic.isBuildWarLv(blv)
			if ret then
				local newArmyID = serviceFunctions.transformArmyID(armyID, wlv)
				print(string.format("army log: oldArmyID(%s) -> newArmyID(%s), build(%s), blv(%s), wlv(%s)", tostring(armyID), tostring(newArmyID), tostring(bid), tostring(blv), tostring(wlv)))
				return newArmyID
			end
			return armyID
		end
	end
	return armyID
end
function armyLogic.getMaxPromoteCount(armyid)
	local resTrain = 0
	local buildID = armyltCtrl.getArmyAttrAndSp(armyid, ARMY_ATTR.BARRACK_ID)
	local ret = armyLogic.isCanTrain(buildID, armyid)
	local retdata = armyLogic.getTrainResCast(buildID, armyid)
	for i, v in ipairs(retdata._costRes) do
		if 0 < v.rescount then
			if resTrain == 0 then
				resTrain = math.max(1, math.floor(v.curcount / v.rescount))
			else
				resTrain = math.min(resTrain, math.floor(v.curcount / v.rescount))
			end
		end
	end
	local canTrain = 0
	if buildID == BUILDID.ELITE_PALACE then
		local eliteTrain = 0
		if retdata._costElitePointInfo then
			local costElitePointInfo = retdata._costElitePointInfo
			eliteTrain = math.floor(costElitePointInfo.currentElitePoint / costElitePointInfo.costElitePoint)
		end
		canTrain = math.min(armyLogic.getMaxTrainCount(buildID).total, eliteTrain)
	else
		canTrain = armyLogic.getMaxTrainCount(buildID).total
	end
	local armyCtrl = gametop.playertop_:getModule("armyCtrl")
	local ownCount = armyCtrl:getArmyCount(armyid, ARMY_OPTYPE.ALL_ARMY)
	return math.min(canTrain, ownCount)
end
function armyLogic.getPromptResCanBuy(fromArmyID, toArmyID, count)
	local fromCostRes = armyltCtrl.armyAttr(fromArmyID, ARMY_ATTR.COSTRES)
	fromCostRes = serviceFunctions.tableFormatToMap(fromCostRes)
	local fromElitePoint = armyltCtrl.armyAttr(fromArmyID, ARMY_ATTR.COST_ELITE_POINT)
	local toCostRes = armyltCtrl.armyAttr(toArmyID, ARMY_ATTR.COSTRES)
	toCostRes = serviceFunctions.tableFormatToMap(toCostRes)
	local toElitePoint = armyltCtrl.armyAttr(toArmyID, ARMY_ATTR.COST_ELITE_POINT)
	local armyltCtrl, res = toArmyID, toArmyID
	local elitePoint
	for toResID, toResCount in pairs(toCostRes) do
		local fromResCount = fromCostRes[toResID] or 0
		local costResCount = calcCostResCount(toResCount, fromResCount, count)
		if 0 < costResCount then
			armyltCtrl = count
			count.resid = toResID
			count.rescount = costResCount
			table.insert(res, count)
		end
	end
	if 0 < fromElitePoint and 0 < toElitePoint then
		local costElitePoint = calcCostResCount(toElitePoint, fromElitePoint, count)
		armyltCtrl = count
		count.resid = gIDDef.ELITE_POINT
		count.rescount = costElitePoint
		table.insert(res, count)
		elitePoint = costElitePoint
	end
	table.sort(res, function(a, b)
		return a.resid < b.resid
	end)
	return res, elitePoint
end
function armyLogic.getPromptTime(fromArmyID, toArmyID, count)
	local fromCostTime = armyLogic.getTrainTime(fromArmyID)
	local toCostTime = armyLogic.getTrainTime(toArmyID)
	local costTime = (toCostTime - fromCostTime * 0.2) * count
	costTime = math.ceil(costTime)
	return 0 < costTime and costTime or 0
end
function armyLogic.getPromptGold(needResList, leftTime)
	local gold = 0
	for k, v in ipairs(needResList) do
		if v.rescount > v.curcount then
			gold = gold + serviceFunctions.resConvertToGold(v.resid, math.max(0, v.rescount - v.curcount))
		end
	end
	if leftTime and 0 < leftTime then
		gold = gold + serviceFunctions.timeConvertToGold(leftTime or 0, true)
	end
	return gold
end
function armyLogic.getDemoArmyList(bid, lv, starLv)
	local bid = tonumber(bid)
	local _ENV, ret = bid, bid
	local isWarLv, wlv = buildLogic.isBuildWarLv(lv)
	if bid == BUILDID.ELITE_PALACE then
		wlv = 0
		starLv = 0
	end
	ret, _ENV = armyltCtrl.getTrainArmyIDList(bid, wlv, starLv), armyltCtrl.getTrainArmyIDList(bid, wlv, starLv)
	ret = armyltCtrl.getTrainArmyIDList(bid, wlv, starLv) or bid
	return ret
end
return armyLogic

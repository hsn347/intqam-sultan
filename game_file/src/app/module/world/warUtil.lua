local _ENV, warUtil
local gametop = gModuleMgr.getObject("gametop")
function warUtil.getWarPlus(noHero)
	local gametop, ret
	local allianceScience = gametop.playertop_:getModule("allianceScience")
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
	local allianceWarCtrl = gametop.playertop_:getModule("allianceWarCtrl")
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	local heroCtrl = SoraDGetCtrl("heroCtrl")
	local armyLogic = include("armyLogic")
	local armyltCtrl = include("armyltCtrl")
	local attributeSystem = include("attributeSystem")
	local allianceMgr = SoraDGetCtrl("allianceMgr")
	local mapBuffCtrl = SoraDGetCtrl("mapBuffCtrl")
	local legendMCtrl = SoraDGetCtrl("legendMCtrl")
	local uid, infantryKingPlus, cavalryKingPlus, archerKingPlus, charistsKingPlus, infantryNemesisPlus, cavalryNemesisPlus, archerNemesisPlus, charistsNemesisPlus, massAkPlus, armyHelpDfPlus
	local worldMapWarDef = include("worldMapWarDef")
	if worldMapWarDef.checkFullAllianceScience() then
		infantryKingPlus = _G.LEGEND_WAR_BUFF.INFANTRY_KING
		cavalryKingPlus = _G.LEGEND_WAR_BUFF.CAVALRY_KING
		archerKingPlus = _G.LEGEND_WAR_BUFF.ARCHER_KING
		charistsKingPlus = _G.LEGEND_WAR_BUFF.CHARISTS_KING
		infantryNemesisPlus = _G.LEGEND_WAR_BUFF.INFANTRY_NEMESIS
		cavalryNemesisPlus = _G.LEGEND_WAR_BUFF.CAVALRY_NEMESIS
		archerNemesisPlus = _G.LEGEND_WAR_BUFF.ARCHER_NEMESIS
		charistsNemesisPlus = _G.LEGEND_WAR_BUFF.CHARISTS_NEMESIS
		massAkPlus = _G.LEGEND_WAR_BUFF.ALLIANCE_ARMY_ATK_ADD
		armyHelpDfPlus = _G.LEGEND_WAR_BUFF.INNER_CITY_REINFORCEMENTS_DEF
	else
		infantryKingPlus = allianceScience:getScienceAddValue(gAScienceType.INFANTRY_KING) or 0
		cavalryKingPlus = allianceScience:getScienceAddValue(gAScienceType.CAVALRY_KING) or 0
		archerKingPlus = allianceScience:getScienceAddValue(gAScienceType.ARCHER_KING) or 0
		charistsKingPlus = allianceScience:getScienceAddValue(gAScienceType.CHARISTS_KING) or 0
		infantryNemesisPlus = allianceScience:getScienceAddValue(gAScienceType.INFANTRY_NEMESIS) or 0
		cavalryNemesisPlus = allianceScience:getScienceAddValue(gAScienceType.CAVALRY_NEMESIS) or 0
		archerNemesisPlus = allianceScience:getScienceAddValue(gAScienceType.ARCHER_NEMESIS) or 0
		charistsNemesisPlus = allianceScience:getScienceAddValue(gAScienceType.CHARISTS_NEMESIS) or 0
		massAkPlus = allianceScience:getScienceAddValue(gAScienceType.ALLIANCE_ARMY_ATK_ADD) or 0
		armyHelpDfPlus = allianceScience:getScienceAddValue(gAScienceType.INNER_CITY_REINFORCEMENTS_DEF) or 0
	end
	armyHelpDfPlus = armyHelpDfPlus * 1000
	ret.armyHelpDfPlus = armyHelpDfPlus
	infantryKingPlus = infantryKingPlus * 1000
	cavalryKingPlus = cavalryKingPlus * 1000
	archerKingPlus = archerKingPlus * 1000
	charistsKingPlus = charistsKingPlus * 1000
	infantryNemesisPlus = infantryNemesisPlus * 1000
	cavalryNemesisPlus = cavalryNemesisPlus * 1000
	archerNemesisPlus = archerNemesisPlus * 1000
	charistsNemesisPlus = charistsNemesisPlus * 1000
	ret.hpPlus, gametop, ret.reduceEnemyDfPlus, gametop, ret.dfPlus4Df, gametop, ret.dfPlus, gametop, ret.reduceSelfDmgPlus, gametop, ret.reduceEnemyDmgPlus, gametop, ret.dmgPlus, gametop, ret.reduceEnemyAkPlus, gametop, ret.akPlus4Df, gametop, ret.akPlus, gametop, massAkPlus = allianceScience:getScienceAddValue(gAScienceType.INNER_CITY_REINFORCEMENTS_DEF), allianceScience:getScienceAddValue(gAScienceType.INNER_CITY_REINFORCEMENTS_DEF), allianceScience:getScienceAddValue(gAScienceType.INNER_CITY_REINFORCEMENTS_DEF), allianceScience:getScienceAddValue(gAScienceType.INNER_CITY_REINFORCEMENTS_DEF), allianceScience:getScienceAddValue(gAScienceType.INNER_CITY_REINFORCEMENTS_DEF), allianceScience:getScienceAddValue(gAScienceType.INNER_CITY_REINFORCEMENTS_DEF), allianceScience:getScienceAddValue(gAScienceType.INNER_CITY_REINFORCEMENTS_DEF), allianceScience:getScienceAddValue(gAScienceType.INNER_CITY_REINFORCEMENTS_DEF), allianceScience:getScienceAddValue(gAScienceType.INNER_CITY_REINFORCEMENTS_DEF), allianceScience:getScienceAddValue(gAScienceType.INNER_CITY_REINFORCEMENTS_DEF), allianceScience:getScienceAddValue(gAScienceType.INNER_CITY_REINFORCEMENTS_DEF), allianceScience:getScienceAddValue(gAScienceType.INNER_CITY_REINFORCEMENTS_DEF), allianceScience:getScienceAddValue(gAScienceType.INNER_CITY_REINFORCEMENTS_DEF), allianceScience:getScienceAddValue(gAScienceType.INNER_CITY_REINFORCEMENTS_DEF), allianceScience:getScienceAddValue(gAScienceType.INNER_CITY_REINFORCEMENTS_DEF), allianceScience:getScienceAddValue(gAScienceType.INNER_CITY_REINFORCEMENTS_DEF), allianceScience:getScienceAddValue(gAScienceType.INNER_CITY_REINFORCEMENTS_DEF), allianceScience:getScienceAddValue(gAScienceType.INNER_CITY_REINFORCEMENTS_DEF), allianceScience:getScienceAddValue(gAScienceType.INNER_CITY_REINFORCEMENTS_DEF), allianceScience:getScienceAddValue(gAScienceType.INNER_CITY_REINFORCEMENTS_DEF), massAkPlus * 1000
	ret.dmgPlus2Target, gametop, ret.trapAkPlus = allianceScience:getScienceAddValue(gAScienceType.INNER_CITY_REINFORCEMENTS_DEF), allianceScience:getScienceAddValue(gAScienceType.INNER_CITY_REINFORCEMENTS_DEF), 0
	ret.castleWarDmgPlus, gametop, ret.chargeDmgPlus, gametop, ret.massAkPlus = allianceScience:getScienceAddValue(gAScienceType.INNER_CITY_REINFORCEMENTS_DEF), allianceScience:getScienceAddValue(gAScienceType.INNER_CITY_REINFORCEMENTS_DEF), allianceScience:getScienceAddValue(gAScienceType.INNER_CITY_REINFORCEMENTS_DEF), allianceScience:getScienceAddValue(gAScienceType.INNER_CITY_REINFORCEMENTS_DEF), massAkPlus
	ret.towerAkPlus = 0
	ret.towerInvReducePlus = 0
	for _, v in pairs(gArmyClassRefId) do
		ret.akPlus[v] = 0
		ret.akPlus4Df[v] = 0
		ret.reduceEnemyAkPlus[v] = 0
		ret.dmgPlus[v] = 0
		ret.reduceEnemyDmgPlus[v] = 0
		ret.reduceSelfDmgPlus[v] = 0
		ret.dfPlus[v] = 0
		ret.dfPlus4Df[v] = 0
		ret.reduceEnemyDfPlus[v] = 0
		ret.hpPlus[v] = 0
		ret.chargeDmgPlus[v] = 0
		ret.castleWarDmgPlus[v] = 0
	end
	local allianceWarData = allianceWarCtrl:getWarData()
	if allianceWarData.atkPlus and 0 < allianceWarData.atkPlus then
		for _, v in pairs(gArmyClassRefId) do
			ret.akPlus[v] = ret.akPlus[v] + allianceWarData.atkPlus
		end
	end
	if allianceWarData.defPlus and 0 < allianceWarData.defPlus then
		for _, v in pairs(gArmyClassRefId) do
			ret.dfPlus[v] = ret.dfPlus[v] + allianceWarData.defPlus
		end
	end
	if allianceWarData.hpPlus and 0 < allianceWarData.hpPlus then
		for _, v in pairs(gArmyClassRefId) do
			ret.hpPlus[v] = ret.hpPlus[v] + allianceWarData.hpPlus
		end
	end
	ret.dmgPlus[gArmyClassRefId.infantry] = ret.dmgPlus[gArmyClassRefId.infantry] + (infantryKingPlus or 0)
	ret.dmgPlus[gArmyClassRefId.cavalry] = ret.dmgPlus[gArmyClassRefId.cavalry] + (cavalryKingPlus or 0)
	ret.dmgPlus[gArmyClassRefId.archer] = ret.dmgPlus[gArmyClassRefId.archer] + (archerKingPlus or 0)
	ret.dmgPlus[gArmyClassRefId.charists] = ret.dmgPlus[gArmyClassRefId.charists] + (charistsKingPlus or 0)
	ret.reduceEnemyDmgPlus[gArmyClassRefId.infantry] = ret.reduceEnemyDmgPlus[gArmyClassRefId.infantry] + infantryNemesisPlus
	ret.reduceEnemyDmgPlus[gArmyClassRefId.cavalry] = ret.reduceEnemyDmgPlus[gArmyClassRefId.cavalry] + cavalryNemesisPlus
	ret.reduceEnemyDmgPlus[gArmyClassRefId.archer] = ret.reduceEnemyDmgPlus[gArmyClassRefId.archer] + archerNemesisPlus
	ret.reduceEnemyDmgPlus[gArmyClassRefId.charists] = ret.reduceEnemyDmgPlus[gArmyClassRefId.charists] + charistsNemesisPlus
	local buffAkPlus = buffCtrl:getBuffEffect(gBuffEffect.TROOP_ATTACK_BOOST, nil, noHero) or 0
	local attrAdd = mapBuffCtrl:getBuffEffect(gAttributeEnum.BATTLE_ATTACK_RATE_RANGE)
	buffAkPlus = buffAkPlus + attrAdd / 10
	if buffAkPlus and 0 < buffAkPlus then
		for _, v in pairs(gArmyClassRefId) do
			ret.akPlus[v] = ret.akPlus[v] + buffAkPlus
		end
	end
	local battlefieldType = kingdomMapCtrl:getKingdomClass() or gKingdomClassType.normal
	for _, v in pairs(gArmyClassRefId) do
		local battleUnit = v.armyTypes[1]
		gametop = nil
		;(nil).battleUnit = battleUnit
		local (nil).battleField, attrFilter = battlefieldType, nil
		local attrValue = attributeSystem.query(gAttributeEnum.BATTLE_ATTACK_RATE, attrFilter)
		if attrValue ~= 0 then
			attrValue = attrValue / 10
			ret.akPlus[v] = ret.akPlus[v] + attrValue
		end
	end
	local buffReduceSelfAkPlus = buffCtrl:getBuffEffect(gBuffEffect.TROOP_ATTACK_REDUCE, nil, noHero)
	if buffReduceSelfAkPlus and 0 < buffReduceSelfAkPlus then
		for _, v in pairs(gArmyClassRefId) do
			ret.akPlus[v] = ret.akPlus[v] - buffReduceSelfAkPlus
		end
	end
	local buffDfPlus = buffCtrl:getBuffEffect(gBuffEffect.TROOP_DEFENSE_BOOST, nil, noHero) or 0
	local attrAdd = mapBuffCtrl:getBuffEffect(gAttributeEnum.BATTLE_DEFEND_RATE_RANGE)
	buffDfPlus = buffDfPlus + attrAdd / 10
	if buffDfPlus and 0 < buffDfPlus then
		for _, v in pairs(gArmyClassRefId) do
			ret.dfPlus[v] = ret.dfPlus[v] + buffDfPlus
		end
	end
	for _, v in pairs(gArmyClassRefId) do
		local battleUnit = v.armyTypes[1]
		gametop = ret.dfPlus[v] + buffDfPlus
		;(ret.dfPlus[v] + buffDfPlus).battleUnit = battleUnit
		local (ret.dfPlus[v] + buffDfPlus).battleField, attrFilter = battlefieldType, ret.dfPlus[v] + buffDfPlus
		local attrValue = attributeSystem.query(gAttributeEnum.BATTLE_DEFEND_RATE, attrFilter)
		if attrValue ~= 0 then
			attrValue = attrValue / 10
			ret.dfPlus[v] = ret.dfPlus[v] + attrValue
		end
	end
	local buffReduceSelfDfPlus = buffCtrl:getBuffEffect(gBuffEffect.TROOP_DEFENSE_REDUCE, nil, noHero)
	if buffReduceSelfDfPlus and 0 < buffReduceSelfDfPlus then
		for _, v in pairs(gArmyClassRefId) do
			ret.dfPlus[v] = ret.dfPlus[v] - buffReduceSelfDfPlus
		end
	end
	local buffHpPlus = buffCtrl:getBuffEffect(gBuffEffect.TROOP_HP_BOOST, nil, noHero) or 0
	local attrAdd = mapBuffCtrl:getBuffEffect(gAttributeEnum.BATTLE_HP_RATE_RANGE)
	buffHpPlus = buffHpPlus + attrAdd / 10
	if buffHpPlus and 0 < buffHpPlus then
		for _, v in pairs(gArmyClassRefId) do
			ret.hpPlus[v] = ret.hpPlus[v] + buffHpPlus
		end
	end
	for _, v in pairs(gArmyClassRefId) do
		local battleUnit = v.armyTypes[1]
		gametop = ret.hpPlus[v] + buffHpPlus
		;(ret.hpPlus[v] + buffHpPlus).battleUnit = battleUnit
		local (ret.hpPlus[v] + buffHpPlus).battleField, attrFilter = battlefieldType, ret.hpPlus[v] + buffHpPlus
		local attrValue = attributeSystem.query(gAttributeEnum.BATTLE_HP_RATE, attrFilter)
		if attrValue ~= 0 then
			attrValue = attrValue / 10
			ret.hpPlus[v] = ret.hpPlus[v] + attrValue
		end
	end
	local petElitePlus = buffCtrl:getBuffEffect(gBuffEffect.ELITE_POWER_UP, nil, noHero)
	petElitePlus = petElitePlus or 0
	local damagePlus = buffCtrl:getBuffEffect(gBuffEffect.DAMAGE_BOOST, nil, noHero) or 0
	local attrAdd = mapBuffCtrl:getBuffEffect(gAttributeEnum.BATTLE_DAMAGE_RATE_RANGE)
	damagePlus = damagePlus + attrAdd / 10
	if damagePlus and 0 < damagePlus then
		for _, v in pairs(gArmyClassRefId) do
			ret.dmgPlus[v] = ret.dmgPlus[v] + damagePlus
		end
	end
	local archerDamageBoost = buffCtrl:getBuffEffect(gBuffEffect.ARCHER_DAMAGE_BOOST, nil, noHero)
	if archerDamageBoost and 0 < archerDamageBoost then
		ret.dmgPlus[gArmyClassRefId.archer] = ret.dmgPlus[gArmyClassRefId.archer] + archerDamageBoost
	end
	local infantryDamageBoost = buffCtrl:getBuffEffect(gBuffEffect.INFANTRY_DAMAGE_BOOST, nil, noHero)
	if infantryDamageBoost and 0 < infantryDamageBoost then
		ret.dmgPlus[gArmyClassRefId.infantry] = ret.dmgPlus[gArmyClassRefId.infantry] + infantryDamageBoost
	end
	local cavalryDamageBoost = buffCtrl:getBuffEffect(gBuffEffect.CAVALRY_DAMAGE_BOOST, nil, noHero)
	if cavalryDamageBoost and 0 < cavalryDamageBoost then
		ret.dmgPlus[gArmyClassRefId.cavalry] = ret.dmgPlus[gArmyClassRefId.cavalry] + cavalryDamageBoost
	end
	local infantryDamageBoost = technologyCtrl:getTechnologyPower(gTechnologyType.INFANTRY_DAMAGE_BOOST)
	if infantryDamageBoost and 0 < infantryDamageBoost then
		ret.dmgPlus[gArmyClassRefId.infantry] = ret.dmgPlus[gArmyClassRefId.infantry] + math.floor(infantryDamageBoost * 1000)
	end
	local cavalryDamageBoost = technologyCtrl:getTechnologyPower(gTechnologyType.CAVALRY_DAMAGE_BOOST)
	if cavalryDamageBoost and 0 < cavalryDamageBoost then
		ret.dmgPlus[gArmyClassRefId.cavalry] = ret.dmgPlus[gArmyClassRefId.cavalry] + math.floor(cavalryDamageBoost * 1000)
	end
	for _, v in pairs(gArmyClassRefId) do
		local battleUnit = v.armyTypes[1]
		gametop = nil
		;(nil).battleUnit = battleUnit
		local (nil).battleType, attrFilter = gWarType.arena, nil
		local attrValue = attributeSystem.query(gAttributeEnum.BATTLE_DAMAGE_RATE, attrFilter)
		if 0 ~= attrValue then
			attrValue = attrValue / 10
			ret.dmgPlus[v] = ret.dmgPlus[v] + attrValue
		end
	end
	local chargeDamageBoost = buffCtrl:getBuffEffect(gBuffEffect.CAVALRY_CHARGE, nil, noHero)
	if chargeDamageBoost and 0 < chargeDamageBoost then
		ret.chargeDmgPlus[gArmyClassRefId.cavalry] = ret.chargeDmgPlus[gArmyClassRefId.cavalry] + chargeDamageBoost
	end
	local chariots_damage_add_buff = buffCtrl:getBuffEffect(gBuffEffect.CHARIOTS_SIEGE_DAMAGE, nil, noHero)
	if chariots_damage_add_buff and 0 < chariots_damage_add_buff then
		ret.castleWarDmgPlus[gArmyClassRefId.charists] = ret.castleWarDmgPlus[gArmyClassRefId.charists] + chariots_damage_add_buff
	end
	local damageReduce = buffCtrl:getBuffEffect(gBuffEffect.DAMAGE_REDUCE, nil, noHero)
	if damageReduce and 0 < damageReduce then
		for _, v in pairs(gArmyClassRefId) do
			ret.reduceSelfDmgPlus[v] = ret.reduceSelfDmgPlus[v] + damageReduce
		end
	end
	local techAkPlus = technologyCtrl:getTechnologyPower(gTechnologyType.DEFENDERS_ATTACK)
	if techAkPlus and 0 < techAkPlus then
		techAkPlus = math.floor(techAkPlus * 1000)
		for _, v in pairs(gArmyClassRefId) do
			ret.akPlus4Df[v] = ret.akPlus4Df[v] + techAkPlus
		end
	end
	local techDfPlus = technologyCtrl:getTechnologyPower(gTechnologyType.DEFENDERS_DEFENSE)
	if techDfPlus and 0 < techDfPlus then
		techDfPlus = math.floor(techDfPlus * 1000)
		for _, v in pairs(gArmyClassRefId) do
			ret.dfPlus4Df[v] = ret.dfPlus4Df[v] + techDfPlus
		end
	end
	local techGroupAkPlus = 0
	techGroupAkPlus = techGroupAkPlus + technologyCtrl:getTechnologyPower(gTechnologyType.KINGDOM_ATTACK_UP)
	techGroupAkPlus = techGroupAkPlus + technologyCtrl:getTechnologyPower(gTechnologyType.CONQUEST_WAR_ATTACK_UP)
	techGroupAkPlus = techGroupAkPlus + technologyCtrl:getTechnologyPower(gTechnologyType.PYRAMID_ATTACK_UP)
	techGroupAkPlus = techGroupAkPlus + technologyCtrl:getTechnologyPower(gTechnologyType.LEGEND_ATTACK_UP)
	techGroupAkPlus = techGroupAkPlus + technologyCtrl:getTechnologyPower(gTechnologyType.ALL_SOLDIER_ATTACK_ADD)
	if techGroupAkPlus and 0 < techGroupAkPlus then
		techGroupAkPlus = math.floor(techGroupAkPlus * 1000)
		for _, v in pairs(gArmyClassRefId) do
			ret.akPlus[v] = ret.akPlus[v] + techGroupAkPlus
		end
	end
	local techGroupDefPlus = 0
	techGroupDefPlus = techGroupDefPlus + technologyCtrl:getTechnologyPower(gTechnologyType.KINGDOM_DEF_UP)
	techGroupDefPlus = techGroupDefPlus + technologyCtrl:getTechnologyPower(gTechnologyType.CONQUEST_WAR_DEF_UP)
	techGroupDefPlus = techGroupDefPlus + technologyCtrl:getTechnologyPower(gTechnologyType.PYRAMID_DEF_UP)
	techGroupDefPlus = techGroupDefPlus + technologyCtrl:getTechnologyPower(gTechnologyType.LEGEND_DEF_UP)
	techGroupDefPlus = techGroupDefPlus + technologyCtrl:getTechnologyPower(gTechnologyType.ALL_SOLDIER_DEFENSE_ADD)
	if techGroupDefPlus and 0 < techGroupDefPlus then
		techGroupDefPlus = math.floor(techGroupDefPlus * 1000)
		for _, v in pairs(gArmyClassRefId) do
			ret.dfPlus[v] = ret.dfPlus[v] + techGroupDefPlus
		end
	end
	local techGroupHpPlus = 0
	techGroupHpPlus = techGroupHpPlus + technologyCtrl:getTechnologyPower(gTechnologyType.KINGDOM_HP_UP)
	techGroupHpPlus = techGroupHpPlus + technologyCtrl:getTechnologyPower(gTechnologyType.CONQUEST_WAR_HP_UP)
	techGroupHpPlus = techGroupHpPlus + technologyCtrl:getTechnologyPower(gTechnologyType.PYRAMID_HP_UP)
	techGroupHpPlus = techGroupHpPlus + technologyCtrl:getTechnologyPower(gTechnologyType.LEGEND_HP_UP)
	techGroupHpPlus = techGroupHpPlus + technologyCtrl:getTechnologyPower(gTechnologyType.ALL_SOLDIER_LIFE_ADD)
	if techGroupHpPlus and 0 < techGroupHpPlus then
		techGroupHpPlus = math.floor(techGroupHpPlus * 1000)
		for _, v in pairs(gArmyClassRefId) do
			ret.hpPlus[v] = ret.hpPlus[v] + techGroupHpPlus
		end
	end
	local buff_group_add_atk = buffCtrl:getBuffEffect(gBuffEffect.LEGEND_ATTACK_UP, nil, noHero) or 0
	if buff_group_add_atk and 0 < buff_group_add_atk then
		for _, v in pairs(gArmyClassRefId) do
			ret.akPlus[v] = ret.akPlus[v] + buff_group_add_atk
		end
	end
	local buff_group_add_def = buffCtrl:getBuffEffect(gBuffEffect.LEGEND_DEF_UP, nil, noHero) or 0
	if buff_group_add_def and 0 < buff_group_add_def then
		for _, v in pairs(gArmyClassRefId) do
			ret.dfPlus[v] = ret.dfPlus[v] + buff_group_add_def
		end
	end
	local infantryAkPlus = technologyCtrl:getTechnologyPower(gTechnologyType.INFANTRY_ATTACK)
	local cavalryAkPlus = technologyCtrl:getTechnologyPower(gTechnologyType.CAVALRY_ATTACK)
	local archerAkPlus = technologyCtrl:getTechnologyPower(gTechnologyType.ARCHER_ATTACK)
	local charistsAkPlus = technologyCtrl:getTechnologyPower(gTechnologyType.CHARIOTS_ATTACK)
	local eliteAkPlus = technologyCtrl:getTechnologyPower(gTechnologyType.SOLDIER_ATTACK)
	local infantryDfPlus = technologyCtrl:getTechnologyPower(gTechnologyType.INFANTRY_DEFENSE)
	local cavalryDfPlus = technologyCtrl:getTechnologyPower(gTechnologyType.CAVALRY_DEFENSE)
	local archerDfPlus = technologyCtrl:getTechnologyPower(gTechnologyType.ARCHER_DEFENSE)
	local charistsDfPlus = technologyCtrl:getTechnologyPower(gTechnologyType.CHARIOTS_DEFENSE)
	local eliteDfPlus = technologyCtrl:getTechnologyPower(gTechnologyType.SOLDIER_DEFENSE)
	local infantryHpPlus = technologyCtrl:getTechnologyPower(gTechnologyType.INFANTRY_HEALTH)
	local cavalryHpPlus = technologyCtrl:getTechnologyPower(gTechnologyType.CAVALRY_HEALTH)
	local archerHpPlus = technologyCtrl:getTechnologyPower(gTechnologyType.ARCHER_HEALTH)
	local charistsHpPlus = technologyCtrl:getTechnologyPower(gTechnologyType.CHARIOTS_HEALTH)
	local eliteHpPlus = technologyCtrl:getTechnologyPower(gTechnologyType.SOLDIER_LIFE)
	infantryAkPlus = serviceFunctions.getIntPart(infantryAkPlus * 1000)
	cavalryAkPlus = serviceFunctions.getIntPart(cavalryAkPlus * 1000)
	archerAkPlus = serviceFunctions.getIntPart(archerAkPlus * 1000)
	charistsAkPlus = serviceFunctions.getIntPart(charistsAkPlus * 1000)
	eliteAkPlus = serviceFunctions.getIntPart(eliteAkPlus * 1000)
	infantryDfPlus = serviceFunctions.getIntPart(infantryDfPlus * 1000)
	cavalryDfPlus = serviceFunctions.getIntPart(cavalryDfPlus * 1000)
	archerDfPlus = serviceFunctions.getIntPart(archerDfPlus * 1000)
	charistsDfPlus = serviceFunctions.getIntPart(charistsDfPlus * 1000)
	eliteDfPlus = serviceFunctions.getIntPart(eliteDfPlus * 1000)
	infantryHpPlus = serviceFunctions.getIntPart(infantryHpPlus * 1000)
	cavalryHpPlus = serviceFunctions.getIntPart(cavalryHpPlus * 1000)
	archerHpPlus = serviceFunctions.getIntPart(archerHpPlus * 1000)
	charistsHpPlus = serviceFunctions.getIntPart(charistsHpPlus * 1000)
	eliteHpPlus = serviceFunctions.getIntPart(eliteHpPlus * 1000)
	eliteAkPlus = eliteAkPlus + (buffCtrl:getBuffEffect(gBuffEffect.ELITE_SOLDIER_ATTACK_BOOST, gBuffSource.WAR_GEM) or 0)
	eliteDfPlus = eliteDfPlus + (buffCtrl:getBuffEffect(gBuffEffect.ELITE_SOLDIER_DEFENSE_BOOST, gBuffSource.WAR_GEM) or 0)
	eliteHpPlus = eliteHpPlus + (buffCtrl:getBuffEffect(gBuffEffect.ELITE_SOLDIER_HP_BOOST, gBuffSource.WAR_GEM) or 0)
	if petElitePlus then
		eliteAkPlus = eliteAkPlus + petElitePlus
		eliteDfPlus = eliteDfPlus + petElitePlus
		eliteHpPlus = eliteHpPlus + petElitePlus
	end
	ret.akPlus[gArmyClassRefId.infantry] = ret.akPlus[gArmyClassRefId.infantry] + infantryAkPlus
	ret.akPlus[gArmyClassRefId.cavalry] = ret.akPlus[gArmyClassRefId.cavalry] + cavalryAkPlus
	ret.akPlus[gArmyClassRefId.archer] = ret.akPlus[gArmyClassRefId.archer] + archerAkPlus
	ret.akPlus[gArmyClassRefId.charists] = ret.akPlus[gArmyClassRefId.charists] + charistsAkPlus
	ret.akPlus[gArmyClassRefId.elite] = ret.akPlus[gArmyClassRefId.elite] + eliteAkPlus
	ret.dfPlus[gArmyClassRefId.infantry] = ret.dfPlus[gArmyClassRefId.infantry] + infantryDfPlus
	ret.dfPlus[gArmyClassRefId.cavalry] = ret.dfPlus[gArmyClassRefId.cavalry] + cavalryDfPlus
	ret.dfPlus[gArmyClassRefId.archer] = ret.dfPlus[gArmyClassRefId.archer] + archerDfPlus
	ret.dfPlus[gArmyClassRefId.charists] = ret.dfPlus[gArmyClassRefId.charists] + charistsDfPlus
	ret.dfPlus[gArmyClassRefId.elite] = ret.dfPlus[gArmyClassRefId.elite] + eliteDfPlus
	ret.hpPlus[gArmyClassRefId.infantry] = ret.hpPlus[gArmyClassRefId.infantry] + infantryHpPlus
	ret.hpPlus[gArmyClassRefId.cavalry] = ret.hpPlus[gArmyClassRefId.cavalry] + cavalryHpPlus
	ret.hpPlus[gArmyClassRefId.archer] = ret.hpPlus[gArmyClassRefId.archer] + archerHpPlus
	ret.hpPlus[gArmyClassRefId.charists] = ret.hpPlus[gArmyClassRefId.charists] + charistsHpPlus
	ret.hpPlus[gArmyClassRefId.elite] = ret.hpPlus[gArmyClassRefId.elite] + eliteHpPlus
	local techTrapAkPlus = technologyCtrl:getTechnologyPower(gTechnologyType.TRAP_ATTACK)
	techTrapAkPlus = math.floor(techTrapAkPlus * 1000)
	ret.trapAkPlus = ret.trapAkPlus + techTrapAkPlus
	local dmgPlus2Target = technologyCtrl:getTechnologyPower(gTechnologyType.ROCKETS_CAVALRY_INJURY)
	dmgPlus2Target = math.floor(dmgPlus2Target * 1000)
	ret.dmgPlus2Target[gArmyClassRefId.rockets], gametop = nil, nil
	ret.dmgPlus2Target[gArmyClassRefId.rockets][gArmyClassRefId.cavalry] = dmgPlus2Target
	dmgPlus2Target = technologyCtrl:getTechnologyPower(gTechnologyType.ROCKFALL_DAMAGE_INFANTRY)
	dmgPlus2Target = math.floor(dmgPlus2Target * 1000)
	ret.dmgPlus2Target[gArmyClassRefId.rockfall], gametop = gTechnologyType.ROCKFALL_DAMAGE_INFANTRY, gTechnologyType.ROCKFALL_DAMAGE_INFANTRY
	ret.dmgPlus2Target[gArmyClassRefId.rockfall][gArmyClassRefId.infantry] = dmgPlus2Target
	dmgPlus2Target = technologyCtrl:getTechnologyPower(gTechnologyType.BOWLS_ARCHER_INJURY)
	dmgPlus2Target = math.floor(dmgPlus2Target * 1000)
	ret.dmgPlus2Target[gArmyClassRefId.bowls], gametop = gTechnologyType.BOWLS_ARCHER_INJURY, gTechnologyType.BOWLS_ARCHER_INJURY
	ret.dmgPlus2Target[gArmyClassRefId.bowls][gArmyClassRefId.archer] = dmgPlus2Target
	local infantryAkPlus = lordInfoCtrl:getTechnologyPower(gLordTechnologyType.INFANTRY_ATTACK)
	local cavalryAkPlus = lordInfoCtrl:getTechnologyPower(gLordTechnologyType.CAVALRY_ATTACK)
	local archerAkPlus = lordInfoCtrl:getTechnologyPower(gLordTechnologyType.ARCHER_ATTACK)
	local charistsAkPlus = lordInfoCtrl:getTechnologyPower(gLordTechnologyType.CHARIOTS_ATTACK)
	local infantryDfPlus = lordInfoCtrl:getTechnologyPower(gLordTechnologyType.INFANTRY_DEFENSE)
	local cavalryDfPlus = lordInfoCtrl:getTechnologyPower(gLordTechnologyType.CAVALRY_DEFENSE)
	local archerDfPlus = lordInfoCtrl:getTechnologyPower(gLordTechnologyType.ARCHER_DEFENSE)
	local charistsDfPlus = lordInfoCtrl:getTechnologyPower(gLordTechnologyType.CHARIOTS_DEFENSE)
	local infantryHpPlus = lordInfoCtrl:getTechnologyPower(gLordTechnologyType.INFANTRY_LIFE)
	local cavalryHpPlus = lordInfoCtrl:getTechnologyPower(gLordTechnologyType.CAVALRY_LIFE)
	local archerHpPlus = lordInfoCtrl:getTechnologyPower(gLordTechnologyType.ARCHER_LIFE)
	local charistsHpPlus = lordInfoCtrl:getTechnologyPower(gLordTechnologyType.CHARIOTS_LIFE)
	infantryAkPlus = math.floor(infantryAkPlus * 1000)
	cavalryAkPlus = math.floor(cavalryAkPlus * 1000)
	archerAkPlus = math.floor(archerAkPlus * 1000)
	charistsAkPlus = math.floor(charistsAkPlus * 1000)
	infantryDfPlus = math.floor(infantryDfPlus * 1000)
	cavalryDfPlus = math.floor(cavalryDfPlus * 1000)
	archerDfPlus = math.floor(archerDfPlus * 1000)
	charistsDfPlus = math.floor(charistsDfPlus * 1000)
	infantryHpPlus = math.floor(infantryHpPlus * 1000)
	cavalryHpPlus = math.floor(cavalryHpPlus * 1000)
	archerHpPlus = math.floor(archerHpPlus * 1000)
	charistsHpPlus = math.floor(charistsHpPlus * 1000)
	ret.akPlus[gArmyClassRefId.infantry] = ret.akPlus[gArmyClassRefId.infantry] + infantryAkPlus
	ret.akPlus[gArmyClassRefId.cavalry] = ret.akPlus[gArmyClassRefId.cavalry] + cavalryAkPlus
	ret.akPlus[gArmyClassRefId.archer] = ret.akPlus[gArmyClassRefId.archer] + archerAkPlus
	ret.akPlus[gArmyClassRefId.charists] = ret.akPlus[gArmyClassRefId.charists] + charistsAkPlus
	ret.dfPlus[gArmyClassRefId.infantry] = ret.dfPlus[gArmyClassRefId.infantry] + infantryDfPlus
	ret.dfPlus[gArmyClassRefId.cavalry] = ret.dfPlus[gArmyClassRefId.cavalry] + cavalryDfPlus
	ret.dfPlus[gArmyClassRefId.archer] = ret.dfPlus[gArmyClassRefId.archer] + archerDfPlus
	ret.dfPlus[gArmyClassRefId.charists] = ret.dfPlus[gArmyClassRefId.charists] + charistsDfPlus
	ret.hpPlus[gArmyClassRefId.infantry] = ret.hpPlus[gArmyClassRefId.infantry] + infantryHpPlus
	ret.hpPlus[gArmyClassRefId.cavalry] = ret.hpPlus[gArmyClassRefId.cavalry] + cavalryHpPlus
	ret.hpPlus[gArmyClassRefId.archer] = ret.hpPlus[gArmyClassRefId.archer] + archerHpPlus
	ret.hpPlus[gArmyClassRefId.charists] = ret.hpPlus[gArmyClassRefId.charists] + charistsHpPlus
	local allSoldierPlus = technologyCtrl:getTechnologyPower(gTechnologyType.SOLDIER_ALL_ATTR)
	allSoldierPlus = math.floor(allSoldierPlus * 1000)
	for _, v in pairs(gArmyClassRefId) do
		ret.akPlus[v] = ret.akPlus[v] + allSoldierPlus
		ret.dfPlus[v] = ret.dfPlus[v] + allSoldierPlus
		ret.hpPlus[v] = ret.hpPlus[v] + allSoldierPlus
	end
	local infantryReduceSelfDmgPlusBuff = buffCtrl:getBuffEffect(gBuffEffect.INFANTRY_DMG_REDUCTION, noHero) or 0
	local infantryReduceSelfDmgPlus = lordInfoCtrl:getTechnologyPower(gLordTechnologyType.INFANTRY_REDUCE_INJURY)
	infantryReduceSelfDmgPlus = math.floor(infantryReduceSelfDmgPlus * 1000)
	ret.reduceSelfDmgPlus[gArmyClassRefId.infantry] = ret.reduceSelfDmgPlus[gArmyClassRefId.infantry] + infantryReduceSelfDmgPlus + infantryReduceSelfDmgPlusBuff
	infantryReduceSelfDmgPlus = technologyCtrl:getTechnologyPower(gTechnologyType.INFANTRY_DMG_REDUCTION)
	infantryReduceSelfDmgPlus = math.floor(infantryReduceSelfDmgPlus * 1000)
	ret.reduceSelfDmgPlus[gArmyClassRefId.infantry] = ret.reduceSelfDmgPlus[gArmyClassRefId.infantry] + infantryReduceSelfDmgPlus
	local cavalryChargeDmgPlus = lordInfoCtrl:getTechnologyPower(gLordTechnologyType.CAVALRY_CHARGE)
	cavalryChargeDmgPlus = math.floor(cavalryChargeDmgPlus * 1000)
	ret.chargeDmgPlus[gArmyClassRefId.cavalry] = ret.chargeDmgPlus[gArmyClassRefId.cavalry] + cavalryChargeDmgPlus
	local archerDmgPlus = lordInfoCtrl:getTechnologyPower(gLordTechnologyType.ARCHER_PLUS_INJURY)
	archerDmgPlus = archerDmgPlus + technologyCtrl:getTechnologyPower(gTechnologyType.ARCHER_DAMAGE_BOOST)
	archerDmgPlus = math.floor(archerDmgPlus * 1000)
	ret.dmgPlus[gArmyClassRefId.archer] = ret.dmgPlus[gArmyClassRefId.archer] + archerDmgPlus
	local charistsCastleWarDmgPlus = lordInfoCtrl:getTechnologyPower(gLordTechnologyType.CHARIOTS_SIEGE_DAMAGE)
	charistsCastleWarDmgPlus = math.floor(charistsCastleWarDmgPlus * 1000)
	ret.castleWarDmgPlus[gArmyClassRefId.charists] = ret.castleWarDmgPlus[gArmyClassRefId.charists] + charistsCastleWarDmgPlus
	local techTrapAkPlus = lordInfoCtrl:getTechnologyPower(gLordTechnologyType.ATK_TRAP)
	techTrapAkPlus = math.floor(techTrapAkPlus * 1000)
	ret.trapAkPlus = ret.trapAkPlus + techTrapAkPlus
	local towerAkPlus = lordInfoCtrl:getTechnologyPower(gLordTechnologyType.TOWER_ATTACK)
	towerAkPlus = math.floor(towerAkPlus * 1000)
	ret.towerAkPlus = ret.towerAkPlus + towerAkPlus
	local towerInvReducePlus = lordInfoCtrl:getTechnologyPower(gLordTechnologyType.TOWER_ATTACK_SPEED)
	towerInvReducePlus = math.floor(towerInvReducePlus * 1000)
	ret.towerInvReducePlus = ret.towerInvReducePlus + towerInvReducePlus
	local isResProtect = buffCtrl:getBuffEffect(gBuffEffect.RESOURCE_PROTECT, nil, noHero)
	ret.isResProtect = isResProtect
	local equTrapAkPlus = buffCtrl:getBuffEffect(gBuffEffect.TRAP_ATTACK, nil, noHero) or 0
	ret.trapAkPlus = ret.trapAkPlus + equTrapAkPlus
	local equInfantryAkPlus = buffCtrl:getBuffEffect(gBuffEffect.INFANTRY_ATTACK_BOOST, nil, noHero) or 0
	ret.akPlus[gArmyClassRefId.infantry] = ret.akPlus[gArmyClassRefId.infantry] + equInfantryAkPlus
	local equCavalryAkPlus = buffCtrl:getBuffEffect(gBuffEffect.CAVALRY_ATTACK_BOOST, nil, noHero) or 0
	ret.akPlus[gArmyClassRefId.cavalry] = ret.akPlus[gArmyClassRefId.cavalry] + equCavalryAkPlus
	local equArcherAkPlus = buffCtrl:getBuffEffect(gBuffEffect.ARCHER_ATTACK_BOOST, nil, noHero) or 0
	ret.akPlus[gArmyClassRefId.archer] = ret.akPlus[gArmyClassRefId.archer] + equArcherAkPlus
	local equCharistsAkPlus = buffCtrl:getBuffEffect(gBuffEffect.SIEGE_VEHICLES_ATTACK_BOOST, nil, noHero) or 0
	ret.akPlus[gArmyClassRefId.charists] = ret.akPlus[gArmyClassRefId.charists] + equCharistsAkPlus
	local equInfantryDfPlus = buffCtrl:getBuffEffect(gBuffEffect.INFANTRY_DEFENSE_BOOST, nil, noHero) or 0
	ret.dfPlus[gArmyClassRefId.infantry] = ret.dfPlus[gArmyClassRefId.infantry] + equInfantryDfPlus
	local equCavalryDfPlus = buffCtrl:getBuffEffect(gBuffEffect.CAVALRY_DEFENSE_BOOST, nil, noHero) or 0
	ret.dfPlus[gArmyClassRefId.cavalry] = ret.dfPlus[gArmyClassRefId.cavalry] + equCavalryDfPlus
	local equArcherDfPlus = buffCtrl:getBuffEffect(gBuffEffect.ARCHER_DEFENSE_BOOST, nil, noHero) or 0
	ret.dfPlus[gArmyClassRefId.archer] = ret.dfPlus[gArmyClassRefId.archer] + equArcherDfPlus
	local equCharistsDfPlus = buffCtrl:getBuffEffect(gBuffEffect.SIEGE_VEHICLES_DEFENSE_BOOST, nil, noHero) or 0
	ret.dfPlus[gArmyClassRefId.charists] = ret.dfPlus[gArmyClassRefId.charists] + equCharistsDfPlus
	local equInfantryHpPlus = buffCtrl:getBuffEffect(gBuffEffect.INFANTRY_HP_BOOST, nil, noHero) or 0
	ret.hpPlus[gArmyClassRefId.infantry] = ret.hpPlus[gArmyClassRefId.infantry] + equInfantryHpPlus
	local equCavalryHpPlus = buffCtrl:getBuffEffect(gBuffEffect.CAVALRY_HP_BOOST, nil, noHero) or 0
	ret.hpPlus[gArmyClassRefId.cavalry] = ret.hpPlus[gArmyClassRefId.cavalry] + equCavalryHpPlus
	local equArcherHpPlus = buffCtrl:getBuffEffect(gBuffEffect.ARCHER_HP_BOOST, nil, noHero) or 0
	ret.hpPlus[gArmyClassRefId.archer] = ret.hpPlus[gArmyClassRefId.archer] + equArcherHpPlus
	local equCharistsHpPlus = buffCtrl:getBuffEffect(gBuffEffect.SIEGE_VEHICLES_HP_BOOST, nil, noHero) or 0
	ret.hpPlus[gArmyClassRefId.charists] = ret.hpPlus[gArmyClassRefId.charists] + equCharistsHpPlus
	local addAll = buffCtrl:getBuffEffect(gBuffEffect.TROOP_ATTACK_DEFENSE_HP_BOOST) or 0
	ret.akPlus[gArmyClassRefId.infantry] = ret.akPlus[gArmyClassRefId.infantry] + addAll
	ret.akPlus[gArmyClassRefId.cavalry] = ret.akPlus[gArmyClassRefId.cavalry] + addAll
	ret.akPlus[gArmyClassRefId.archer] = ret.akPlus[gArmyClassRefId.archer] + addAll
	ret.akPlus[gArmyClassRefId.charists] = ret.akPlus[gArmyClassRefId.charists] + addAll
	ret.akPlus[gArmyClassRefId.elite] = ret.akPlus[gArmyClassRefId.elite] + addAll
	ret.dfPlus[gArmyClassRefId.infantry] = ret.dfPlus[gArmyClassRefId.infantry] + addAll
	ret.dfPlus[gArmyClassRefId.cavalry] = ret.dfPlus[gArmyClassRefId.cavalry] + addAll
	ret.dfPlus[gArmyClassRefId.archer] = ret.dfPlus[gArmyClassRefId.archer] + addAll
	ret.dfPlus[gArmyClassRefId.charists] = ret.dfPlus[gArmyClassRefId.charists] + addAll
	ret.dfPlus[gArmyClassRefId.elite] = ret.dfPlus[gArmyClassRefId.elite] + addAll
	ret.hpPlus[gArmyClassRefId.infantry] = ret.hpPlus[gArmyClassRefId.infantry] + addAll
	ret.hpPlus[gArmyClassRefId.cavalry] = ret.hpPlus[gArmyClassRefId.cavalry] + addAll
	ret.hpPlus[gArmyClassRefId.archer] = ret.hpPlus[gArmyClassRefId.archer] + addAll
	ret.hpPlus[gArmyClassRefId.charists] = ret.hpPlus[gArmyClassRefId.charists] + addAll
	ret.hpPlus[gArmyClassRefId.elite] = ret.hpPlus[gArmyClassRefId.elite] + addAll
	ret.officialAllPlus = 0
	local plus = buffCtrl:getBuffEffect(gBuffEffect.TROOP_ATTACK_BOOST, gBuffSource.OFFICIAL) or 0
	ret.officialAllPlus = ret.officialAllPlus + plus
	plus = buffCtrl:getBuffEffect(gBuffEffect.TROOP_DEFENSE_BOOST, gBuffSource.OFFICIAL) or 0
	ret.officialAllPlus = ret.officialAllPlus + plus
	plus = buffCtrl:getBuffEffect(gBuffEffect.TROOP_ATTACK_REDUCE, gBuffSource.OFFICIAL) or 0
	ret.officialAllPlus = ret.officialAllPlus - plus
	plus = buffCtrl:getBuffEffect(gBuffEffect.TROOP_DEFENSE_REDUCE, gBuffSource.OFFICIAL) or 0
	ret.officialAllPlus = ret.officialAllPlus - plus
	ret.vipAllPlus = 0
	plus = buffCtrl:getBuffEffect(gBuffEffect.TROOP_ATTACK_BOOST, gBuffSource.VIP) or 0
	ret.vipAllPlus = ret.vipAllPlus + plus
	plus = buffCtrl:getBuffEffect(gBuffEffect.TROOP_DEFENSE_BOOST, gBuffSource.VIP) or 0
	ret.vipAllPlus = ret.vipAllPlus + plus
	plus = buffCtrl:getBuffEffect(gBuffEffect.MARCH_LIMIT_BOOST, gBuffSource.VIP) or 0
	ret.vipAllPlus = ret.vipAllPlus + plus
	ret.itemAllPlus = 0
	plus = buffCtrl:getBuffEffect(gBuffEffect.TROOP_ATTACK_BOOST, gBuffSource.CITY) or 0
	ret.itemAllPlus = ret.itemAllPlus + plus
	plus = buffCtrl:getBuffEffect(gBuffEffect.TROOP_DEFENSE_BOOST, gBuffSource.CITY) or 0
	ret.itemAllPlus = ret.itemAllPlus + plus
	plus = buffCtrl:getBuffEffect(gBuffEffect.MARCH_LIMIT_BOOST, gBuffSource.CITY) or 0
	ret.itemAllPlus = ret.itemAllPlus + plus
	ret.robPlus = (technologyCtrl:getTechnologyPower(gTechnologyType.SIEGE_PLUNDER) or 0) * 1000
	ret.killWoundPlus = (technologyCtrl:getTechnologyPower(gTechnologyType.SIEGE_KO) or 0) * 1000
	local siegeBuff = buffCtrl:getBuffEffect(gBuffEffect.SIEGE_LORE, gBuffSource.SKILL) or 0
	ret.killWoundPlus = ret.killWoundPlus + siegeBuff
	local allianceScience = gametop.playertop_:getModule("allianceScience")
	local woundPlus_tech = technologyCtrl:getTechnologyPower(gTechnologyType.EXPEDITION_LOSS) or 0
	local woundPlus_buff = buffCtrl:getBuffEffect(gBuffEffect.TRANDFORM_WOUNDED, nil, noHero) or 0
	local expedition_plus_buff = buffCtrl:getBuffEffect(gBuffEffect.EXPEDITION_LOSS, nil, noHero) or 0
	local woundPlus_sci = allianceScience:getScienceAddValue(gAScienceType.INSTANCY_CURE) or 0
	ret.woundPlus = (woundPlus_tech + woundPlus_buff / 1000 + woundPlus_sci + expedition_plus_buff / 1000) * 1000
	local arrArmyId = armyLogic.getArmyIDListCanTrain(BUILDID.BARRACKS)
	ret.cityWarAkPlus = 0
	for _, armyId in pairs(arrArmyId) do
		local cityWarAkPlus = armyltCtrl.getArmySp(armyId).cityWarAkPlus
		if cityWarAkPlus > ret.cityWarAkPlus then
			ret.cityWarAkPlus = cityWarAkPlus
		end
	end
	ret.cityWarDfPlus = 0
	for _, armyId in pairs(arrArmyId) do
		local cityWarDfPlus = armyltCtrl.getArmySp(armyId).cityWarDfPlus
		if cityWarDfPlus > ret.cityWarDfPlus then
			ret.cityWarDfPlus = cityWarDfPlus
		end
	end
	return ret
end
function warUtil.getOtherWarPlus()
	local allianceScience = gametop.playertop_:getModule("allianceScience")
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
	local buildLogic = include("buildLogic")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local armyLogic = include("armyLogic")
	local gametop, ret = "armyLogic", "armyLogic"
	ret.trapAkPlus = 0
	if lordInfoCtrl:getLordLevel() > CASTLE_LV7_LIMITED then
		local buildCell = cityCtrl:getBuildCell(BUILDID.TURRET, 0)
		local buildCell2 = cityCtrl:getBuildCell(BUILDID.TURRET, 1)
		local akSpeed = buildLogic.getTurretSpeed(buildCell)
		local akAttack = buildLogic.getTurretAtk(buildCell).total
		local akSpeed2 = buildLogic.getTurretSpeed(buildCell2)
		local akAttack2 = buildLogic.getTurretAtk(buildCell2).total
		ret.towerAkPlus = akAttack
		ret.towerInvReducePlus = akSpeed.add + akSpeed.base * 1000
		ret.towerAkPlus2 = akAttack2
		ret.towerInvReducePlus2 = akSpeed2.add + akSpeed2.base * 1000
	else
		ret.towerAkPlus = 0
		ret.towerInvReducePlus = 0
	end
	local dmgPlus2Target = technologyCtrl:getTechnologyPower(gTechnologyType.ROCKETS_CAVALRY_INJURY)
	dmgPlus2Target = math.floor(dmgPlus2Target * 1000)
	ret.trapDmgPlus2Cavalry = dmgPlus2Target
	dmgPlus2Target = technologyCtrl:getTechnologyPower(gTechnologyType.ROCKFALL_DAMAGE_INFANTRY)
	dmgPlus2Target = math.floor(dmgPlus2Target * 1000)
	ret.trapDmgPlus2Infantry = dmgPlus2Target
	dmgPlus2Target = technologyCtrl:getTechnologyPower(gTechnologyType.BOWLS_ARCHER_INJURY)
	dmgPlus2Target = math.floor(dmgPlus2Target * 1000)
	ret.trapDmgPlus2Archer = dmgPlus2Target
	local techTrapAkPlus = technologyCtrl:getTechnologyPower(gTechnologyType.TRAP_ATTACK)
	techTrapAkPlus = math.floor(techTrapAkPlus * 1000)
	ret.trapAkPlus = ret.trapAkPlus + techTrapAkPlus
	local techTrapAkPlus = lordInfoCtrl:getTechnologyPower(gLordTechnologyType.ATK_TRAP)
	techTrapAkPlus = math.floor(techTrapAkPlus * 1000)
	ret.trapAkPlus = ret.trapAkPlus + techTrapAkPlus
	local equTrapAkPlus = buffCtrl:getBuffEffect(gBuffEffect.TRAP_ATTACK) or 0
	ret.trapAkPlus = ret.trapAkPlus + equTrapAkPlus
	ret.akPlus4Df = 0
	local techAkPlus = technologyCtrl:getTechnologyPower(gTechnologyType.DEFENDERS_ATTACK)
	if techAkPlus and 0 < techAkPlus then
		ret.akPlus4Df = math.floor(techAkPlus * 1000)
	end
	ret.dfPlus4Df = 0
	local techDfPlus = technologyCtrl:getTechnologyPower(gTechnologyType.DEFENDERS_DEFENSE)
	if techDfPlus and 0 < techDfPlus then
		ret.dfPlus4Df = math.floor(techDfPlus * 1000)
	end
	return ret
end
function warUtil.getArmyWeightPlus()
	local allianceScience = gametop.playertop_:getModule("allianceScience")
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
	local armyLogic = include("armyLogic")
	local ret = 0
	local armyWeightPlus = technologyCtrl:getTechnologyPower(gTechnologyType.FORCE_LOAD)
	armyWeightPlus = math.floor(armyWeightPlus * 1000)
	ret = ret + armyWeightPlus
	armyWeightPlus = lordInfoCtrl:getTechnologyPower(gLordTechnologyType.FORCE_LOAD)
	armyWeightPlus = math.floor(armyWeightPlus * 1000)
	ret = ret + armyWeightPlus
	armyWeightPlus = buffCtrl:getBuffEffect(gBuffEffect.SOLDIER_LOAD_BOOST)
	if armyWeightPlus then
		ret = ret + armyWeightPlus
	end
	local attributeSystem = include("attributeSystem")
	local attrAdd = attributeSystem.query(gAttributeEnum.TROOP_LOAD_RATE)
	if attrAdd and 0 ~= attrAdd then
		attrAdd = attrAdd / 10
		ret = ret + attrAdd
	end
	return ret
end
function warUtil.getCollPlus()
	local allianceScience = gametop.playertop_:getModule("allianceScience")
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
	local armyLogic = include("armyLogic")
	local attributeSystem = include("attributeSystem")
	local gametop, ret = "attributeSystem", "attributeSystem"
	local allPlus = buffCtrl:getBuffEffect(gBuffEffect.GATHER_SPEED_BOOST) or 0
	local allReduce = buffCtrl:getBuffEffect(gBuffEffect.GATHER_SPEED_REDUCE) or 0
	allPlus = allPlus - allReduce
	print("warUtil.getCollPlus()   allPlus ------", allPlus)
	local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
	allPlus = allPlus + (conquestWarCtrl:getConquestWarWinBuffList(gBuffEffect.GATHER_SPEED_BOOST).totalEffect or 0) * 1000
	ret[gIDDef.FOOD] = allPlus
	ret[gIDDef.WOOD] = allPlus
	ret[gIDDef.GOLD] = 0
	ret[gIDDef.IRON] = allPlus
	ret[gIDDef.MITHRIL] = allPlus
	ret[gIDDef.CRYSTAL] = allPlus
	local buff_food_add = buffCtrl:getBuffEffect(gBuffEffect.FOOD_GATHER_SPEED_BOOST) or 0
	local buff_wood_add = buffCtrl:getBuffEffect(gBuffEffect.WOOD_GATHER_SPEED_BOOST) or 0
	local buff_iron_add = buffCtrl:getBuffEffect(gBuffEffect.IRON_GATHER_SPEED_BOOST) or 0
	local buff_mithril_add = buffCtrl:getBuffEffect(gBuffEffect.MITHRIL_GATHER_SPEED_BOOST) or 0
	gametop = nil
	;(nil).resourceID = gIDDef.FOOD
	local attr_food_plus = attributeSystem.query(gAttributeEnum.GATHER_RESOURCE_SPEED_RATE, nil) or 0
	gametop = gIDDef.FOOD
	gIDDef.FOOD.resourceID = gIDDef.WOOD
	local attr_wood_add = attributeSystem.query(gAttributeEnum.GATHER_RESOURCE_SPEED_RATE, gIDDef.FOOD) or 0
	gametop = gIDDef.WOOD
	gIDDef.WOOD.resourceID = gIDDef.IRON
	local attr_iron_plus = attributeSystem.query(gAttributeEnum.GATHER_RESOURCE_SPEED_RATE, gIDDef.WOOD) or 0
	gametop = gIDDef.IRON
	gIDDef.IRON.resourceID = gIDDef.MITHRIL
	local attr_mithril_plus = attributeSystem.query(gAttributeEnum.GATHER_RESOURCE_SPEED_RATE, gIDDef.IRON) or 0
	gametop = gIDDef.MITHRIL
	gIDDef.MITHRIL.resourceID = gIDDef.GOLD
	local attr_gold_plus = attributeSystem.query(gAttributeEnum.GATHER_RESOURCE_SPEED_RATE, gIDDef.MITHRIL) or 0
	gametop = gIDDef.GOLD
	gIDDef.GOLD.resourceID = gIDDef.CRYSTAL
	local attr_crystal_plus = attributeSystem.query(gAttributeEnum.GATHER_RESOURCE_SPEED_RATE, gIDDef.GOLD) or 0
	attr_food_plus = attr_food_plus / 10
	attr_wood_add = attr_wood_add / 10
	attr_iron_plus = attr_iron_plus / 10
	attr_mithril_plus = attr_mithril_plus / 10
	attr_gold_plus = attr_gold_plus / 10
	attr_crystal_plus = attr_crystal_plus / 10
	print("attr_food_plus, attr_wood_add, attr_iron_plus, attr_mithril_plus, attr_gold_plus", attr_food_plus, attr_wood_add, attr_iron_plus, attr_mithril_plus, attr_gold_plus)
	local buff_gold_add = buffCtrl:getBuffEffect(gBuffEffect.GATHER_GOLD_SPEED_UP) or 0
	local warTechAdd = (technologyCtrl:getTechnologyPower(gTechnologyType.RES_COLLECTION_SPEED_BOOST) or 0) * 1000
	ret[gIDDef.FOOD] = ret[gIDDef.FOOD] + technologyCtrl:getTechnologyPower(gTechnologyType.FOOD_COLLECTION) * 1000
	ret[gIDDef.FOOD] = ret[gIDDef.FOOD] + lordInfoCtrl:getTechnologyPower(gLordTechnologyType.FOOD_COLLECTION) * 1000
	ret[gIDDef.FOOD] = ret[gIDDef.FOOD] + buff_food_add
	ret[gIDDef.FOOD] = ret[gIDDef.FOOD] + warTechAdd
	ret[gIDDef.FOOD] = ret[gIDDef.FOOD] + attr_food_plus
	ret[gIDDef.WOOD] = ret[gIDDef.WOOD] + technologyCtrl:getTechnologyPower(gTechnologyType.WOOD_COLLECTION) * 1000
	ret[gIDDef.WOOD] = ret[gIDDef.WOOD] + lordInfoCtrl:getTechnologyPower(gLordTechnologyType.WOOD_ACQUISITION) * 1000
	ret[gIDDef.WOOD] = ret[gIDDef.WOOD] + buff_wood_add
	ret[gIDDef.WOOD] = ret[gIDDef.WOOD] + warTechAdd
	ret[gIDDef.WOOD] = ret[gIDDef.WOOD] + attr_wood_add
	ret[gIDDef.GOLD] = ret[gIDDef.GOLD] + technologyCtrl:getTechnologyPower(gTechnologyType.GOLD_COLLECTION) * 1000
	ret[gIDDef.GOLD] = ret[gIDDef.GOLD] + lordInfoCtrl:getTechnologyPower(gLordTechnologyType.GOLD_COLLECTION) * 1000
	ret[gIDDef.GOLD] = ret[gIDDef.GOLD] + buff_gold_add
	ret[gIDDef.GOLD] = ret[gIDDef.GOLD] + attr_gold_plus
	ret[gIDDef.IRON] = ret[gIDDef.IRON] + technologyCtrl:getTechnologyPower(gTechnologyType.IRON_COLLECTION) * 1000
	ret[gIDDef.IRON] = ret[gIDDef.IRON] + lordInfoCtrl:getTechnologyPower(gLordTechnologyType.IRON_ORE_ACQUISITION) * 1000
	ret[gIDDef.IRON] = ret[gIDDef.IRON] + buff_iron_add
	ret[gIDDef.IRON] = ret[gIDDef.IRON] + warTechAdd
	ret[gIDDef.IRON] = ret[gIDDef.IRON] + attr_iron_plus
	ret[gIDDef.MITHRIL] = ret[gIDDef.MITHRIL] + technologyCtrl:getTechnologyPower(gTechnologyType.MITHRIL_COLLECTION) * 1000
	ret[gIDDef.MITHRIL] = ret[gIDDef.MITHRIL] + lordInfoCtrl:getTechnologyPower(gLordTechnologyType.MITHRIL_COLLECTION) * 1000
	ret[gIDDef.MITHRIL] = ret[gIDDef.MITHRIL] + buff_mithril_add
	ret[gIDDef.MITHRIL] = ret[gIDDef.MITHRIL] + warTechAdd
	ret[gIDDef.MITHRIL] = ret[gIDDef.MITHRIL] + attr_mithril_plus
	ret[gIDDef.CRYSTAL] = ret[gIDDef.CRYSTAL] + warTechAdd
	ret[gIDDef.CRYSTAL] = ret[gIDDef.CRYSTAL] + attr_crystal_plus
	return ret
end
return warUtil

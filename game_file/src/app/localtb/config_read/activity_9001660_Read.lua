local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local activity_9001660_Read = include("aAReadClass").new()
_ENV = "aAReadClass"
;("aAReadClass").NORMAL_BATTLE = 1
_ENV, activity_9001660_Read.gMutantTentaclesBattletype, ("aAReadClass").ELITE_BATTLE = "aAReadClass", "aAReadClass", 2
;("aAReadClass").ATKTYPE_NORMAL = 1
_UPVALUE3_, activity_9001660_Read.gMutantTentaclesAtkType, ("aAReadClass").ATKTYPE_CRITICAL = "aAReadClass", "aAReadClass", 2
activity_9001660_Read.gMutantTentaclesItem, ("aAReadClass")[1] = "aAReadClass", 870501
activity_9001660_Read.gMutantTentaclesItem, ("aAReadClass")[2] = "aAReadClass", 870601
activity_9001660_Read.gMutantTentaclesItem, ("aAReadClass")[3] = "aAReadClass", 870701
activity_9001660_Read.MUTANT_TENTACLES_ELITE_MAXHP = 10
activity_9001660_Read.MUTANT_TENTACLES_NORMAL_MAXHP = 10
activity_9001660_Read.MUTANT_TENTACLES_NORMAL_COSTHORN = 5
activity_9001660_Read.MUTANT_TENTACLES_ELITE_COSTHORN = 20
activity_9001660_Read.MUTANT_TENTACLES_USERKILL_ELITEMAX = 200
activity_9001660_Read.MUTANT_TENTACLES_USERKILL_NORMALMAX = 200
activity_9001660_Read.MUTANT_TENTACLES_NEED_CASTLE_LEV = 6
activity_9001660_Read.MUTANT_TENTACLES_ELITE_GETANLAHBLESS = 220
activity_9001660_Read.MUTANT_TENTACLES_NORMAL_GETANLAHBLESS = 55
activity_9001660_Read.MUTANT_TENTACLES_NORMAL_ANLAH_RATE = 8
activity_9001660_Read.MUTANT_TENTACLES_ELITE_ANLAH_RATE = 8
activity_9001660_Read.MONSTERPALACE_ELITE_STATUS_OPEN = 1
activity_9001660_Read.MONSTERPALACE_ELITE_STATUS_CLOSE = 2
activity_9001660_Read:defineValue("featheraward", function()
	local _ENV, ret
	local tentacles_feather_award = require_once("app." .. LocalTblPath .. ".config_server.tentacles_feather_award")
	for k, v in pairs(tentacles_feather_award) do
		local classType = v.classType or 1
		if not ret[classType] then
			ret[classType], _ENV = ret[classType], ret[classType]
		end
		if not ret[classType][v.battletype] then
			ret[classType][v.battletype], _ENV = nil, nil
		end
		table.insert(ret[classType][v.battletype], v)
	end
	return ret
end)
local createData = function(name)
	local battle_atk_award = require_once("app." .. LocalTblPath .. ".config_server.tentacles_attack_award")
	local _ENV, attackaward = "app." .. LocalTblPath .. ".config_server.tentacles_attack_award", "app." .. LocalTblPath .. ".config_server.tentacles_attack_award"
	local _ENV, monsterReward = LocalTblPath, LocalTblPath
	local _ENV, activityTypes = ".config_server.tentacles_attack_award", ".config_server.tentacles_attack_award"
	local _ENV, superReward
	local _ENV, goldReward
	local _ENV, normalReward
	for k, v in pairs(battle_atk_award) do
		local classType = v.classType or 1
		if not activityTypes[classType] then
			_ENV = activityTypes[classType]
		end
		activityTypes[classType] = activityTypes[classType]
		if not superReward[classType] then
			_ENV = superReward[classType]
		end
		superReward[classType] = superReward[classType]
		if not superReward[classType][v.activityType] then
			_ENV = superReward[classType][v.activityType]
		end
		superReward[classType][v.activityType] = superReward[classType][v.activityType]
		if not goldReward[classType] then
			_ENV = goldReward[classType]
		end
		goldReward[classType] = goldReward[classType]
		if not goldReward[classType][v.activityType] then
			_ENV = goldReward[classType][v.activityType]
		end
		goldReward[classType][v.activityType] = goldReward[classType][v.activityType]
		if not normalReward[classType] then
			_ENV = normalReward[classType]
		end
		normalReward[classType] = normalReward[classType]
		if not normalReward[classType][v.activityType] then
			_ENV = normalReward[classType][v.activityType]
		end
		normalReward[classType][v.activityType] = normalReward[classType][v.activityType]
		if next(v.reward) then
			if v.reward[1] == gIDDef.GOLD then
				table.insert(goldReward[classType][v.activityType], v)
			else
				table.insert(normalReward[classType][v.activityType], v)
			end
		elseif next(v.superReward) then
			table.insert(superReward[classType][v.activityType], v)
		end
		activityTypes[classType][v.activityType] = v.activityType
	end
	for k, w in pairs(activityTypes) do
		if not monsterReward[k] then
			_ENV = monsterReward[k]
		end
		monsterReward[k] = monsterReward[k]
		if not attackaward[k] then
			_ENV = attackaward[k]
		end
		attackaward[k] = attackaward[k]
		for _, v in pairs(w) do
			if not monsterReward[k][v] then
				monsterReward[k][v], _ENV = nil, nil
			end
			table.sort(goldReward[k][v], function(a, b)
				return a.reward[2] > b.reward[2]
			end)
			table.sort(normalReward[k][v], function(a, b)
				local qualitya = backpackltCtrl:getItemQuality(a.reward[1]) or 0
				local qualityb = backpackltCtrl:getItemQuality(b.reward[1]) or 0
				return qualitya > qualityb
			end)
			table.sort(activity_9001660_Read.featheraward[k][v], function(a, b)
				return backpackltCtrl:getItemQuality(a.feather[1]) > backpackltCtrl:getItemQuality(b.feather[1])
			end)
			for index, value in ipairs(superReward[k][v]) do
				if not attackaward[k][v] then
					_ENV = attackaward[k][v]
				end
				attackaward[k][v] = attackaward[k][v]
				table.insert(attackaward[k][v], value)
				_ENV = value
				value.id = value.superReward[1]
				value.num = value.superReward[2]
				value.serverLv = value.serverLv
				table.insert(monsterReward[k][v], value)
			end
			for index, value in ipairs(activity_9001660_Read.featheraward[k][v]) do
				_ENV = value
				value.id = value.feather[1]
				value.num = value.feather[2]
				value.serverLv = value.serverLv
				table.insert(monsterReward[k][v], value)
			end
			for index, value in ipairs(goldReward[k][v]) do
				if not attackaward[k][v] then
					_ENV = attackaward[k][v]
				end
				attackaward[k][v] = attackaward[k][v]
				table.insert(attackaward[k][v], value)
				_ENV = value
				value.id = value.reward[1]
				value.num = value.reward[2]
				value.serverLv = value.serverLv
				table.insert(monsterReward[k][v], value)
			end
			for index, value in ipairs(normalReward[k][v]) do
				if not attackaward[k][v] then
					_ENV = attackaward[k][v]
				end
				attackaward[k][v] = attackaward[k][v]
				table.insert(attackaward[k][v], value)
				_ENV = value
				value.id = value.reward[1]
				value.num = value.reward[2]
				value.serverLv = value.serverLv
				table.insert(monsterReward[k][v], value)
			end
		end
	end
	if name == "attackaward" then
		return attackaward
	elseif name == "monsterReward" then
		return monsterReward
	end
end
activity_9001660_Read:defineValue("attackaward", createData)
activity_9001660_Read:defineValue("monsterReward", createData)
activity_9001660_Read:defineValue("tentacles_feathershop", function()
	local _ENV, ret
	local cfg = require_once("app." .. LocalTblPath .. ".config_server.tentacles_feathershop")
	local index = 1
	for k, v in ipairs(cfg) do
		if not ret[v.classType] then
			ret[v.classType], _ENV = nil, nil
			index = 1
		end
		v.index = index
		table.insert(ret[v.classType], v)
		index = index + 1
	end
	return ret
end)
function activity_9001660_Read.getAttackAward(battletype, classType)
	classType = classType or 1
	local battletype = tonumber(battletype)
	return activity_9001660_Read.attackaward[classType][battletype]
end
function activity_9001660_Read.getFeatherAward(battletype, classType)
	classType = classType or 1
	local battletype = tonumber(battletype)
	return activity_9001660_Read.featheraward[classType][battletype]
end
function activity_9001660_Read.getMonsterAward(battletype, classType, lv)
	classType = classType or 1
	lv = lv or 1
	local battletype = tonumber(battletype)
	local _ENV, tb = battletype, battletype
	for index, value in ipairs(activity_9001660_Read.monsterReward[classType][battletype]) do
		local min = value.serverLv[1]
		local max = value.serverLv[2]
		if lv >= min and lv <= max then
			table.insert(tb, value)
		end
	end
	return tb
end
function activity_9001660_Read.get_feahtershop(lv, classType)
	if lv then
		return activity_9001660_Read.get_feahtershopByZeroLv(lv, classType)
	else
		return activity_9001660_Read.tentacles_feathershop[classType]
	end
end
function activity_9001660_Read.get_feahtershopByZeroLv(lv, classType)
	local _ENV, tb
	for index, value in ipairs(activity_9001660_Read.tentacles_feathershop[classType]) do
		local min = value.serverLv[1]
		local max = value.serverLv[2]
		if lv >= min and lv <= max then
			table.insert(tb, value)
		end
	end
	return tb
end
return activity_9001660_Read

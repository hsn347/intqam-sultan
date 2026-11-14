local romeActivityltCtrl = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_ENV = nil
	;(nil)[1] = "rome_activity_allrank_reward"
	;(nil)[2] = true
	romeActivityltCtrl:defineValue("rome_activity_allrank_reward", nil)
	_ENV = nil
	;(nil)[1] = "rome_activity_memrank_reward"
	;(nil)[2] = true
	romeActivityltCtrl:defineValue("rome_activity_memrank_reward", nil)
	romeActivityltCtrl:defineValue("rome_activity_armyconf", function()
		romeActivityltCtrl.rome_activity_armyconf, romeActivityltCtrl = nil, nil
		local armyconf = require_once("app." .. LocalTblPath .. ".config_server.rome_activity_armyconf")
		local romeActivityltCtrl, ret = "app." .. LocalTblPath .. ".config_server.rome_activity_armyconf", "app." .. LocalTblPath .. ".config_server.rome_activity_armyconf"
		for k, v in pairs(armyconf) do
			local level = v.level
			local times = v.times
			if not ret[level] then
				ret[level], romeActivityltCtrl = ret[level], ret[level]
			end
			ret[level][times] = v
		end
		romeActivityltCtrl.rome_activity_armyconf = ret
		return romeActivityltCtrl.rome_activity_armyconf
	end)
	romeActivityltCtrl:defineValue("rome_activity_armyscore", function()
		romeActivityltCtrl.rome_activity_armyscore, romeActivityltCtrl = nil, nil
		local armyscore = require_once("app." .. LocalTblPath .. ".config_server.rome_activity_armyscore")
		for k, v in pairs(armyscore) do
			romeActivityltCtrl.rome_activity_armyscore[v.armyid] = v
		end
		return romeActivityltCtrl.rome_activity_armyscore
	end)
	romeActivityltCtrl:defineValue("rome_activity_level_reward", function()
		romeActivityltCtrl.rome_activity_level_reward, romeActivityltCtrl = nil, nil
		local reward = require_once("app." .. LocalTblPath .. ".config_server.rome_activity_level_reward")
		local romeActivityltCtrl, ret = "app." .. LocalTblPath .. ".config_server.rome_activity_level_reward", "app." .. LocalTblPath .. ".config_server.rome_activity_level_reward"
		for k, v in pairs(reward) do
			local level = v.level
			local giftlevel = v.giftlevel
			if not ret[level] then
				ret[level], romeActivityltCtrl = ret[level], ret[level]
			end
			ret[level][giftlevel] = v
		end
		romeActivityltCtrl.rome_activity_level_reward = ret
		return romeActivityltCtrl.rome_activity_level_reward
	end)
end
init()
function romeActivityltCtrl.getRomeActivityAllRankReward(rank, serverLv)
	for _, v in pairs(romeActivityltCtrl.rome_activity_allrank_reward) do
		if serverLv >= v.serverPhase[1] and serverLv <= v.serverPhase[2] then
			if v.rankstart and v.rankend and rank >= v.rankstart and rank <= v.rankend then
				_UPVALUE2_ = nil
				;(nil)[1] = "id"
				;(nil)[2] = "num"
				local ret = serviceFunctions.tableFormat(v.reward, nil)
				return ret, v.rankstart, v.rankend
			elseif v.rank and rank == v.rank then
				_UPVALUE2_ = v.rankstart
				v.rankstart[1] = "id"
				v.rankstart[2] = "num"
				local ret = serviceFunctions.tableFormat(v.reward, v.rankstart)
				return ret, v.rank, v.rank
			end
		end
	end
end
function romeActivityltCtrl.getRomeActivityMemRankReward(rank, serverLv)
	for _, v in pairs(romeActivityltCtrl.rome_activity_memrank_reward) do
		if serverLv >= v.serverPhase[1] and serverLv <= v.serverPhase[2] then
			if v.rankstart and v.rankend and rank >= v.rankstart and rank <= v.rankend then
				_UPVALUE2_ = nil
				;(nil)[1] = "id"
				;(nil)[2] = "num"
				local ret = serviceFunctions.tableFormat(v.reward, nil)
				return ret, v.rankstart, v.rankend
			elseif v.rank and rank == v.rank then
				_UPVALUE2_ = v.rankstart
				v.rankstart[1] = "id"
				v.rankstart[2] = "num"
				local ret = serviceFunctions.tableFormat(v.reward, v.rankstart)
				return ret, v.rank, v.rank
			end
		end
	end
end
function romeActivityltCtrl.getWholeRomeActivityAllRankReward(serverLv)
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	local (nil)[2], keys = "count", nil
	local _ENV, ret = "id", "id"
	for _, v in ipairs(romeActivityltCtrl.rome_activity_allrank_reward) do
		if serverLv >= v.serverPhase[1] and serverLv <= v.serverPhase[2] then
			local copy = clone(v)
			copy.reward = serviceFunctions.tableFormat(copy.reward, keys)
			table.insert(ret, copy)
		end
	end
	return ret
end
function romeActivityltCtrl.getWholeRomeActivityMemRankReward(serverLv)
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	local (nil)[2], keys = "count", nil
	local _ENV, ret = "id", "id"
	for _, v in ipairs(romeActivityltCtrl.rome_activity_memrank_reward) do
		if serverLv >= v.serverPhase[1] and serverLv <= v.serverPhase[2] then
			local copy = clone(v)
			copy.reward = serviceFunctions.tableFormat(copy.reward, keys)
			table.insert(ret, copy)
		end
	end
	return ret
end
function romeActivityltCtrl.getRomeActivityArmyConf(level, times)
	local levelconf = romeActivityltCtrl.rome_activity_armyconf[level]
	if levelconf then
		local conf = levelconf[times]
		if conf then
			local totalcount = conf.totalcount
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			local (nil)[2], keys = "num", nil
			local armyconf = serviceFunctions.tableFormat(conf.armyconf, keys)
			return totalcount, armyconf
		end
	end
end
function romeActivityltCtrl.getRomeActivityArmyScore(armyid)
	local score = 0
	local conf = romeActivityltCtrl.rome_activity_armyscore[armyid]
	if conf then
		score = conf.score
	end
	return score
end
function romeActivityltCtrl.getRomeActivityLevelReward(level, giftlevel)
	local levelconf = romeActivityltCtrl.rome_activity_level_reward[level]
	if levelconf then
		local conf = levelconf[giftlevel]
		if conf then
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			local (nil)[2], keys = "num", nil
			local reward = serviceFunctions.tableFormat(conf.reward, keys)
			local needscore = conf.needscore
			return reward, needscore
		end
	end
end
function romeActivityltCtrl.getRomeActivityArmyTotalScore(level, times)
	local totalscore = 0
	local levelconf = romeActivityltCtrl.rome_activity_armyconf[level]
	if levelconf then
		local conf = levelconf[times]
		if conf then
			totalscore = conf.totalscore
		end
	end
	return totalscore
end
return romeActivityltCtrl

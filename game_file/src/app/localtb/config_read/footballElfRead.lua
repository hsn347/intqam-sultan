local footballElfRead = include("aAReadClass").new()
function footballElfRead.init()
	footballElfRead:defineValue("rank", function()
		footballElfRead.rank, footballElfRead = nil, nil
		local rank_cfg = require_once("app." .. LocalTblPath .. ".config_server.footballelf_rank")
		for k, v in ipairs(rank_cfg) do
			if not footballElfRead.rank[v.group] then
				footballElfRead.rank[v.group], footballElfRead = nil, nil
			end
			table.insert(footballElfRead.rank[v.group], v)
		end
		return footballElfRead.rank
	end)
	function _UPVALUE2_()
		footballElfRead.rank, footballElfRead = nil, nil
		local rank_cfg = require_once("app." .. LocalTblPath .. ".config_server.footballelf_rank")
		for k, v in ipairs(rank_cfg) do
			if not footballElfRead.rank[v.group] then
				footballElfRead.rank[v.group], footballElfRead = nil, nil
			end
			table.insert(footballElfRead.rank[v.group], v)
		end
		return footballElfRead.rank
	end
	;(function()
		footballElfRead.rank, footballElfRead = nil, nil
		local rank_cfg = require_once("app." .. LocalTblPath .. ".config_server.footballelf_rank")
		for k, v in ipairs(rank_cfg) do
			if not footballElfRead.rank[v.group] then
				footballElfRead.rank[v.group], footballElfRead = nil, nil
			end
			table.insert(footballElfRead.rank[v.group], v)
		end
		return footballElfRead.rank
	end)[1] = "footballelf_reward"
	;(function()
		footballElfRead.rank, footballElfRead = nil, nil
		local rank_cfg = require_once("app." .. LocalTblPath .. ".config_server.footballelf_rank")
		for k, v in ipairs(rank_cfg) do
			if not footballElfRead.rank[v.group] then
				footballElfRead.rank[v.group], footballElfRead = nil, nil
			end
			table.insert(footballElfRead.rank[v.group], v)
		end
		return footballElfRead.rank
	end)[2] = true
	footballElfRead:defineValue("reward", function()
		footballElfRead.rank, footballElfRead = nil, nil
		local rank_cfg = require_once("app." .. LocalTblPath .. ".config_server.footballelf_rank")
		for k, v in ipairs(rank_cfg) do
			if not footballElfRead.rank[v.group] then
				footballElfRead.rank[v.group], footballElfRead = nil, nil
			end
			table.insert(footballElfRead.rank[v.group], v)
		end
		return footballElfRead.rank
	end)
	function _UPVALUE2_()
		footballElfRead.rank, footballElfRead = nil, nil
		local rank_cfg = require_once("app." .. LocalTblPath .. ".config_server.footballelf_rank")
		for k, v in ipairs(rank_cfg) do
			if not footballElfRead.rank[v.group] then
				footballElfRead.rank[v.group], footballElfRead = nil, nil
			end
			table.insert(footballElfRead.rank[v.group], v)
		end
		return footballElfRead.rank
	end
	;(function()
		footballElfRead.rank, footballElfRead = nil, nil
		local rank_cfg = require_once("app." .. LocalTblPath .. ".config_server.footballelf_rank")
		for k, v in ipairs(rank_cfg) do
			if not footballElfRead.rank[v.group] then
				footballElfRead.rank[v.group], footballElfRead = nil, nil
			end
			table.insert(footballElfRead.rank[v.group], v)
		end
		return footballElfRead.rank
	end)[1] = "footballelf_recharge"
	;(function()
		footballElfRead.rank, footballElfRead = nil, nil
		local rank_cfg = require_once("app." .. LocalTblPath .. ".config_server.footballelf_rank")
		for k, v in ipairs(rank_cfg) do
			if not footballElfRead.rank[v.group] then
				footballElfRead.rank[v.group], footballElfRead = nil, nil
			end
			table.insert(footballElfRead.rank[v.group], v)
		end
		return footballElfRead.rank
	end)[2] = true
	footballElfRead:defineValue("rechargeCfg", function()
		footballElfRead.rank, footballElfRead = nil, nil
		local rank_cfg = require_once("app." .. LocalTblPath .. ".config_server.footballelf_rank")
		for k, v in ipairs(rank_cfg) do
			if not footballElfRead.rank[v.group] then
				footballElfRead.rank[v.group], footballElfRead = nil, nil
			end
			table.insert(footballElfRead.rank[v.group], v)
		end
		return footballElfRead.rank
	end)
end
footballElfRead.init()
function footballElfRead.getRechargeCfg(index)
	return footballElfRead.rechargeCfg[index]
end
function footballElfRead.getItemCount()
	local count = 0
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	local rewards = serviceFunctions.tableFormat(footballElfRead.rechargeCfg[2].Rewards, nil)
	for k, v in ipairs(rewards) do
		if v.id == 858801 then
			count = v.count
			break
		end
	end
	return count
end
function footballElfRead.getRankAward()
	return footballElfRead.reward
end
function footballElfRead.getRankTop2Arawd()
	local _ENV, ret
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	local rewardList = serviceFunctions.tableFormat(footballElfRead.reward[1].reward, nil)
	for i = 1, 2 do
		table.insert(ret, rewardList[i])
	end
	return ret
end
function footballElfRead.getExpCfg(classType)
	return footballElfRead.rank[classType]
end
function footballElfRead.getMaxExpCfgLv(classType)
	local cfg = footballElfRead.rank[classType]
	return cfg[#cfg].level
end
function footballElfRead.getExpLv(exp, classType)
	local leftExp = exp
	local nextExp = 0
	local lv = 0
	local classType = classType or 1
	local cfg = footballElfRead.rank[classType]
	local isToMax = false
	for k, v in ipairs(cfg) do
		if leftExp < v.exp then
			lv = v.level - 1
			nextExp = v.exp
			break
		else
			leftExp = leftExp - v.exp
			if k == #cfg then
				lv = v.level
				nextExp = v.exp
				isToMax = true
			end
		end
	end
	if isToMax then
		local maxCfg = cfg[#cfg]
		nextExp = maxCfg.exp
		while leftExp >= maxCfg.exp do
			leftExp = leftExp - maxCfg.exp
			lv = lv + 1
		end
	end
	print("lv,leftExp,nextExp====", lv, leftExp, nextExp)
	return lv, leftExp, nextExp
end
return footballElfRead

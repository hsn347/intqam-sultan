local lordOfDessertRead = include("aAReadClass").new()
function lordOfDessertRead.init()
	lordOfDessertRead:defineValue("eidaladha_king_reward", function()
		local config = require_once("app." .. LocalTblPath .. ".config_server.eidaladha_king_reward")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_server.eidaladha_king_reward", "app." .. LocalTblPath .. ".config_server.eidaladha_king_reward"
		for i, v in ipairs(config) do
			_ENV = nil
			;(nil).NeedIntegral = v.NeedIntegral
			;(nil).BoxItem = v.BoxItem
			ret[v.group], (nil).BoxMax = nil, v.BoxMax
		end
		return ret
	end)
	function _UPVALUE2_()
		local config = require_once("app." .. LocalTblPath .. ".config_server.eidaladha_king_reward")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_server.eidaladha_king_reward", "app." .. LocalTblPath .. ".config_server.eidaladha_king_reward"
		for i, v in ipairs(config) do
			_ENV = nil
			;(nil).NeedIntegral = v.NeedIntegral
			;(nil).BoxItem = v.BoxItem
			ret[v.group], (nil).BoxMax = nil, v.BoxMax
		end
		return ret
	end
	;(function()
		local config = require_once("app." .. LocalTblPath .. ".config_server.eidaladha_king_reward")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_server.eidaladha_king_reward", "app." .. LocalTblPath .. ".config_server.eidaladha_king_reward"
		for i, v in ipairs(config) do
			_ENV = nil
			;(nil).NeedIntegral = v.NeedIntegral
			;(nil).BoxItem = v.BoxItem
			ret[v.group], (nil).BoxMax = nil, v.BoxMax
		end
		return ret
	end)[1] = "eidaladha_king_donate"
	;(function()
		local config = require_once("app." .. LocalTblPath .. ".config_server.eidaladha_king_reward")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_server.eidaladha_king_reward", "app." .. LocalTblPath .. ".config_server.eidaladha_king_reward"
		for i, v in ipairs(config) do
			_ENV = nil
			;(nil).NeedIntegral = v.NeedIntegral
			;(nil).BoxItem = v.BoxItem
			ret[v.group], (nil).BoxMax = nil, v.BoxMax
		end
		return ret
	end)[2] = true
	lordOfDessertRead:defineValue("eidaladha_king_donate", function()
		local config = require_once("app." .. LocalTblPath .. ".config_server.eidaladha_king_reward")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_server.eidaladha_king_reward", "app." .. LocalTblPath .. ".config_server.eidaladha_king_reward"
		for i, v in ipairs(config) do
			_ENV = nil
			;(nil).NeedIntegral = v.NeedIntegral
			;(nil).BoxItem = v.BoxItem
			ret[v.group], (nil).BoxMax = nil, v.BoxMax
		end
		return ret
	end)
	lordOfDessertRead:defineValue("eidaladha_king_rank", function()
		local config = require_once("app." .. LocalTblPath .. ".config_server.eidaladha_king_rank")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_server.eidaladha_king_rank", "app." .. LocalTblPath .. ".config_server.eidaladha_king_rank"
		for i, v in ipairs(config) do
			if not ret[v.group] then
				ret[v.group], _ENV = nil, nil
			end
			_ENV = nil
			;(nil).RankNum = v.RankNum
			;(nil).RankItem = v.RankItem
			table.insert(ret[v.group], nil)
		end
		return ret
	end)
end
function lordOfDessertRead.getNeedItemByIndex(index)
	return lordOfDessertRead.eidaladha_king_donate[index].NeedItem
end
function lordOfDessertRead.getGetItemByIndex(index)
	return lordOfDessertRead.eidaladha_king_donate[index].GetItem
end
function lordOfDessertRead.getGetIntegralByIndex(index)
	return lordOfDessertRead.eidaladha_king_donate[index].GetIntegral
end
function lordOfDessertRead.getSingleMaxByIndex(index)
	return lordOfDessertRead.eidaladha_king_donate[index].SingleMax
end
function lordOfDessertRead.getNeedIntegral(group)
	return lordOfDessertRead.eidaladha_king_reward[group].NeedIntegral
end
function lordOfDessertRead.getBoxMax(group)
	return lordOfDessertRead.eidaladha_king_reward[group].BoxMax
end
function lordOfDessertRead.getBoxItem(group)
	return lordOfDessertRead.eidaladha_king_reward[group].BoxItem
end
function lordOfDessertRead.getNeedMinMultipleByIndex(index)
	local data = lordOfDessertRead.eidaladha_king_donate[index].IntegralMultiples
	return data[1]
end
function lordOfDessertRead.getNeedMaxMultipleByIndex(index)
	local data = lordOfDessertRead.eidaladha_king_donate[index].IntegralMultiples
	return data[table.nums(data) - 1]
end
function lordOfDessertRead.getRankRewardByRank(group, rank)
	for i, v in ipairs(lordOfDessertRead.eidaladha_king_rank[group]) do
		if rank >= v.RankNum[1] and rank <= v.RankNum[2] then
			return v.RankItem
		end
	end
	_ENV = (for generator)
	return ipairs(lordOfDessertRead.eidaladha_king_rank[group])
end
function lordOfDessertRead.getRewardFront2ByIndex(group, index)
	if index == -1 then
		return nil
	end
	index = index or 101
	_UPVALUE2_ = group
	group[1] = "id"
	group[2] = "count"
	local rankItem = serviceFunctions.tableFormat(lordOfDessertRead.getRankRewardByRank(group, index), group)
	local _ENV, data = lordOfDessertRead.getRankRewardByRank(group, index), lordOfDessertRead.getRankRewardByRank(group, index)
	for i = 1, 2 do
		if rankItem then
			table.insert(data, rankItem[i])
		end
	end
	return data
end
lordOfDessertRead.init()
return lordOfDessertRead

local rocketRushRead = include("aAReadClass").new()
function rocketRushRead.init()
	rocketRushRead:defineValue("expand", function()
		rocketRushRead.expand, rocketRushRead = nil, nil
		local expand_cfg = require_once("app." .. LocalTblPath .. ".config_server.rocketrush_expand")
		for k, v in ipairs(expand_cfg) do
			if not rocketRushRead.expand[v.group] then
				rocketRushRead.expand[v.group], rocketRushRead = nil, nil
			end
			rocketRushRead.expand[v.group][v.expandType] = v
		end
		return rocketRushRead.expand
	end)
	function _UPVALUE2_()
		rocketRushRead.expand, rocketRushRead = nil, nil
		local expand_cfg = require_once("app." .. LocalTblPath .. ".config_server.rocketrush_expand")
		for k, v in ipairs(expand_cfg) do
			if not rocketRushRead.expand[v.group] then
				rocketRushRead.expand[v.group], rocketRushRead = nil, nil
			end
			rocketRushRead.expand[v.group][v.expandType] = v
		end
		return rocketRushRead.expand
	end
	;(function()
		rocketRushRead.expand, rocketRushRead = nil, nil
		local expand_cfg = require_once("app." .. LocalTblPath .. ".config_server.rocketrush_expand")
		for k, v in ipairs(expand_cfg) do
			if not rocketRushRead.expand[v.group] then
				rocketRushRead.expand[v.group], rocketRushRead = nil, nil
			end
			rocketRushRead.expand[v.group][v.expandType] = v
		end
		return rocketRushRead.expand
	end)[1] = "rocketrush_rank"
	;(function()
		rocketRushRead.expand, rocketRushRead = nil, nil
		local expand_cfg = require_once("app." .. LocalTblPath .. ".config_server.rocketrush_expand")
		for k, v in ipairs(expand_cfg) do
			if not rocketRushRead.expand[v.group] then
				rocketRushRead.expand[v.group], rocketRushRead = nil, nil
			end
			rocketRushRead.expand[v.group][v.expandType] = v
		end
		return rocketRushRead.expand
	end)[2] = true
	rocketRushRead:defineValue("rank", function()
		rocketRushRead.expand, rocketRushRead = nil, nil
		local expand_cfg = require_once("app." .. LocalTblPath .. ".config_server.rocketrush_expand")
		for k, v in ipairs(expand_cfg) do
			if not rocketRushRead.expand[v.group] then
				rocketRushRead.expand[v.group], rocketRushRead = nil, nil
			end
			rocketRushRead.expand[v.group][v.expandType] = v
		end
		return rocketRushRead.expand
	end)
	rocketRushRead:defineValue("reward", function()
		rocketRushRead.reward, rocketRushRead = nil, nil
		local reward_cfg = require_once("app." .. LocalTblPath .. ".config_server.rocketrush_reward")
		for k, v in ipairs(reward_cfg) do
			if not rocketRushRead.reward[v.group] then
				rocketRushRead.reward[v.group], rocketRushRead = nil, nil
			end
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.reward = serviceFunctions.tableFormat(v.reward, nil)
			table.insert(rocketRushRead.reward[v.group], v)
		end
		return rocketRushRead.reward
	end)
end
rocketRushRead.init()
function rocketRushRead.getExpandItemCfg(group, expandType)
	local expandItem = rocketRushRead.expand[group][expandType].expandItem
	return expandItem[1], expandItem[2]
end
function rocketRushRead.getExpandRewardCfg(group, expandType)
	local getReward = rocketRushRead.expand[group][expandType].getReward
	return getReward[1], getReward[2]
end
function rocketRushRead.getExpandPoint(group, expandType)
	return rocketRushRead.expand[group][expandType].getPoint
end
function rocketRushRead.getExpandLimit(group, expandType)
	return rocketRushRead.expand[group][expandType].limit
end
function rocketRushRead.getChestPoint(group, level)
	local level = math.min(level, #rocketRushRead.reward[group])
	return rocketRushRead.reward[group][level].chestPoint
end
function rocketRushRead.getChestReward(group, level)
	local level = math.min(level, #rocketRushRead.reward[group])
	return rocketRushRead.reward[group][level].reward
end
function rocketRushRead.getChestLimit(group)
	return #rocketRushRead.reward[group]
end
function rocketRushRead.getRankReward(group, rank)
	for k, v in ipairs(rocketRushRead.rank) do
		if v.group == group and rank >= v.rankNum[1] and rank <= v.rankNum[2] then
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			return serviceFunctions.tableFormat(v.reward, nil)
		end
	end
end
return rocketRushRead

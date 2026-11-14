local kingStarWarltCtrl = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	local createData = function(name)
		kingStarWarltCtrl.posRefLegendLordWarBuilding, kingStarWarltCtrl, kingStarWarltCtrl.type2bid, kingStarWarltCtrl, kingStarWarltCtrl.legendLordWarBuilding, kingStarWarltCtrl = nil, nil, nil, nil, nil, nil
		local legendLordWarBuilding = require_once("app." .. LocalTblPath .. ".config_server.kingstarbattle_building_cost")
		for id, build in pairs(legendLordWarBuilding) do
			local build = clone(build)
			build.x = build.x - gPointClientPointPlus
			build.y = build.y - gPointClientPointPlus
			kingStarWarltCtrl.legendLordWarBuilding[id] = build
			kingStarWarltCtrl.type2bid[build.type] = id
		end
		for id, v in pairs(legendLordWarBuilding) do
			v.id = id
			v.objId = id
			local x, y = v.x - 1, v.y - 1
			v.x = v.x - 1
			v.y = v.y - 1
			if not kingStarWarltCtrl.posRefLegendLordWarBuilding[x] then
				kingStarWarltCtrl.posRefLegendLordWarBuilding[x], kingStarWarltCtrl = nil, nil
			end
			kingStarWarltCtrl.posRefLegendLordWarBuilding[x][y] = v
		end
		if name == "legendLordWarBuilding" then
			return kingStarWarltCtrl.legendLordWarBuilding
		elseif name == "type2bid" then
			return kingStarWarltCtrl.type2bid
		elseif name == "posRefLegendLordWarBuilding" then
			return kingStarWarltCtrl.posRefLegendLordWarBuilding
		end
	end
	kingStarWarltCtrl:defineValue("legendLordWarBuilding", createData)
	kingStarWarltCtrl:defineValue("type2bid", createData)
	kingStarWarltCtrl:defineValue("posRefLegendLordWarBuilding", createData)
	kingStarWarltCtrl:defineValue("legendLordWarRewards", function()
		local kingstarbattle_rewards = require_once("app." .. LocalTblPath .. ".config_server.kingstarbattle_rewards")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_server.kingstarbattle_rewards", "app." .. LocalTblPath .. ".config_server.kingstarbattle_rewards"
		for _, v in pairs(kingstarbattle_rewards) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			local reward = serviceFunctions.tableFormat(v.rewards, nil)
			local rewardsType = tostring(v.rewardsType)
			local condition = tostring(v.condition)
			if not ret[rewardsType] then
				_ENV = ret[rewardsType]
			end
			ret[rewardsType] = ret[rewardsType]
			ret[rewardsType][condition] = reward
		end
		return ret
	end)
	function kingStarWarltCtrl()
		local kingstarbattle_rewards = require_once("app." .. LocalTblPath .. ".config_server.kingstarbattle_rewards")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_server.kingstarbattle_rewards", "app." .. LocalTblPath .. ".config_server.kingstarbattle_rewards"
		for _, v in pairs(kingstarbattle_rewards) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			local reward = serviceFunctions.tableFormat(v.rewards, nil)
			local rewardsType = tostring(v.rewardsType)
			local condition = tostring(v.condition)
			if not ret[rewardsType] then
				_ENV = ret[rewardsType]
			end
			ret[rewardsType] = ret[rewardsType]
			ret[rewardsType][condition] = reward
		end
		return ret
	end
	;(function()
		local kingstarbattle_rewards = require_once("app." .. LocalTblPath .. ".config_server.kingstarbattle_rewards")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_server.kingstarbattle_rewards", "app." .. LocalTblPath .. ".config_server.kingstarbattle_rewards"
		for _, v in pairs(kingstarbattle_rewards) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			local reward = serviceFunctions.tableFormat(v.rewards, nil)
			local rewardsType = tostring(v.rewardsType)
			local condition = tostring(v.condition)
			if not ret[rewardsType] then
				_ENV = ret[rewardsType]
			end
			ret[rewardsType] = ret[rewardsType]
			ret[rewardsType][condition] = reward
		end
		return ret
	end)[1] = "kingstarbattle_shop_pointconfig"
	kingStarWarltCtrl:defineValue("legendPointConfig", function()
		local kingstarbattle_rewards = require_once("app." .. LocalTblPath .. ".config_server.kingstarbattle_rewards")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_server.kingstarbattle_rewards", "app." .. LocalTblPath .. ".config_server.kingstarbattle_rewards"
		for _, v in pairs(kingstarbattle_rewards) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			local reward = serviceFunctions.tableFormat(v.rewards, nil)
			local rewardsType = tostring(v.rewardsType)
			local condition = tostring(v.condition)
			if not ret[rewardsType] then
				_ENV = ret[rewardsType]
			end
			ret[rewardsType] = ret[rewardsType]
			ret[rewardsType][condition] = reward
		end
		return ret
	end)
	local createData = function(name)
		kingStarWarltCtrl.posRefLegendLordWarBuilding2, kingStarWarltCtrl, kingStarWarltCtrl.type2bid2, kingStarWarltCtrl, kingStarWarltCtrl.legendLordWarBuilding2, kingStarWarltCtrl = nil, nil, nil, nil, nil, nil
		local legendLordWarBuilding = require_once("app." .. LocalTblPath .. ".config_server.kingstarrank_building_cost")
		for id, build in pairs(legendLordWarBuilding) do
			local build = clone(build)
			build.x = build.x - gPointClientPointPlus
			build.y = build.y - gPointClientPointPlus
			kingStarWarltCtrl.legendLordWarBuilding2[id] = build
			kingStarWarltCtrl.type2bid2[build.type] = id
		end
		for id, v in pairs(legendLordWarBuilding) do
			v.id = id
			v.objId = id
			local x, y = v.x - 1, v.y - 1
			v.x = v.x - 1
			v.y = v.y - 1
			if not kingStarWarltCtrl.posRefLegendLordWarBuilding2[x] then
				kingStarWarltCtrl.posRefLegendLordWarBuilding2[x], kingStarWarltCtrl = nil, nil
			end
			kingStarWarltCtrl.posRefLegendLordWarBuilding2[x][y] = v
		end
		if name == "legendLordWarBuilding2" then
			return kingStarWarltCtrl.legendLordWarBuilding2
		elseif name == "type2bid2" then
			return kingStarWarltCtrl.type2bid2
		elseif name == "posRefLegendLordWarBuilding2" then
			return kingStarWarltCtrl.posRefLegendLordWarBuilding2
		end
	end
	kingStarWarltCtrl:defineValue("legendLordWarBuilding2", createData)
	kingStarWarltCtrl:defineValue("type2bid2", createData)
	kingStarWarltCtrl:defineValue("posRefLegendLordWarBuilding2", createData)
	kingStarWarltCtrl:defineValue("legendLordWarRewards2", function()
		local kingstarrank_rewards = require_once("app." .. LocalTblPath .. ".config_server.kingstarrank_rewards")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_server.kingstarrank_rewards", "app." .. LocalTblPath .. ".config_server.kingstarrank_rewards"
		for _, v in pairs(kingstarrank_rewards) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			local reward = serviceFunctions.tableFormat(v.rewards, nil)
			if not ret[v.servertype] then
				local _ENV, _ret = ret[v.servertype], ret[v.servertype]
			end
			local rewardsType = tostring(v.rewardsType)
			local condition = tostring(v.condition)
			if not _ret[rewardsType] then
				_ENV = _ret[rewardsType]
			end
			_ret[rewardsType] = _ret[rewardsType]
			_ret[rewardsType][condition] = reward
			ret[v.servertype] = _ret
		end
		return ret
	end)
	function kingStarWarltCtrl()
		local kingstarrank_rewards = require_once("app." .. LocalTblPath .. ".config_server.kingstarrank_rewards")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_server.kingstarrank_rewards", "app." .. LocalTblPath .. ".config_server.kingstarrank_rewards"
		for _, v in pairs(kingstarrank_rewards) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			local reward = serviceFunctions.tableFormat(v.rewards, nil)
			if not ret[v.servertype] then
				local _ENV, _ret = ret[v.servertype], ret[v.servertype]
			end
			local rewardsType = tostring(v.rewardsType)
			local condition = tostring(v.condition)
			if not _ret[rewardsType] then
				_ENV = _ret[rewardsType]
			end
			_ret[rewardsType] = _ret[rewardsType]
			_ret[rewardsType][condition] = reward
			ret[v.servertype] = _ret
		end
		return ret
	end
	;(function()
		local kingstarrank_rewards = require_once("app." .. LocalTblPath .. ".config_server.kingstarrank_rewards")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_server.kingstarrank_rewards", "app." .. LocalTblPath .. ".config_server.kingstarrank_rewards"
		for _, v in pairs(kingstarrank_rewards) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			local reward = serviceFunctions.tableFormat(v.rewards, nil)
			if not ret[v.servertype] then
				local _ENV, _ret = ret[v.servertype], ret[v.servertype]
			end
			local rewardsType = tostring(v.rewardsType)
			local condition = tostring(v.condition)
			if not _ret[rewardsType] then
				_ENV = _ret[rewardsType]
			end
			_ret[rewardsType] = _ret[rewardsType]
			_ret[rewardsType][condition] = reward
			ret[v.servertype] = _ret
		end
		return ret
	end)[1] = "kingstarrank_shop_pointconfig"
	kingStarWarltCtrl:defineValue("legendPointConfig2", function()
		local kingstarrank_rewards = require_once("app." .. LocalTblPath .. ".config_server.kingstarrank_rewards")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_server.kingstarrank_rewards", "app." .. LocalTblPath .. ".config_server.kingstarrank_rewards"
		for _, v in pairs(kingstarrank_rewards) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			local reward = serviceFunctions.tableFormat(v.rewards, nil)
			if not ret[v.servertype] then
				local _ENV, _ret = ret[v.servertype], ret[v.servertype]
			end
			local rewardsType = tostring(v.rewardsType)
			local condition = tostring(v.condition)
			if not _ret[rewardsType] then
				_ENV = _ret[rewardsType]
			end
			_ret[rewardsType] = _ret[rewardsType]
			_ret[rewardsType][condition] = reward
			ret[v.servertype] = _ret
		end
		return ret
	end)
end
init()
function kingStarWarltCtrl.getBidByType(subMapType, mapid)
	print("kingStarWarltCtrl.getBidByType subMapType = ", subMapType)
	return kingStarWarltCtrl.type2bid[subMapType]
end
function kingStarWarltCtrl.updateLegendReward(rewardInfo, mapid)
	if rewardInfo then
		if mapid == worldMapDefine.KINGSTAR_KINGDOM_ID then
			kingStarWarltCtrl.legendLordWarRewards = rewardInfo
		else
			local activityID = worldMapDefine.getKingStarActivityID(mapid)
			kingStarWarltCtrl.legendLordWarRewards2[activityID] = rewardInfo
		end
	end
end
function kingStarWarltCtrl.getLegendLordWarBuilding(mapid)
	if mapid == worldMapDefine.KINGSTAR_KINGDOM_ID then
		return kingStarWarltCtrl.legendLordWarBuilding
	else
		return kingStarWarltCtrl.legendLordWarBuilding2
	end
end
function kingStarWarltCtrl.getLegendLordWarBuildingById(id, mapid)
	local config = kingStarWarltCtrl.getLegendLordWarBuilding(mapid)
	return config[id]
end
function kingStarWarltCtrl.getLegendLordWarBuildingByPos(x, y, mapid)
	if mapid == worldMapDefine.KINGSTAR_KINGDOM_ID then
		local cofig = kingStarWarltCtrl.posRefLegendLordWarBuilding
		if cofig[x] then
			return cofig[x][y]
		end
	else
		local cofig = kingStarWarltCtrl.posRefLegendLordWarBuilding2
		if cofig[x] then
			return cofig[x][y]
		end
	end
end
function kingStarWarltCtrl.getRewardsConfig(mapid)
	if mapid == worldMapDefine.KINGSTAR_KINGDOM_ID then
		return kingStarWarltCtrl.legendLordWarRewards
	else
		local activityID = worldMapDefine.getKingStarActivityID(mapid)
		return kingStarWarltCtrl.legendLordWarRewards2[activityID]
	end
end
function kingStarWarltCtrl.getLegendLordWarFirstKillReward(occupySecs, mapid)
	local config = kingStarWarltCtrl.getRewardsConfig(mapid)
	local condition = occupySecs or LLW_OCCUPY_FIRST_KILL_TIME
	return config["1"][tostring(condition)]
end
function kingStarWarltCtrl.getLegendLordWarRankReward(rank, mapid)
	local config = kingStarWarltCtrl.getRewardsConfig(mapid)
	return config["2"][tostring(rank)]
end
function kingStarWarltCtrl.getLegendLordWarRankRewards(mapid)
	local config = kingStarWarltCtrl.getRewardsConfig(mapid)
	return config["2"]
end
function kingStarWarltCtrl.getLegendLordWarParticipationReward(mapid)
	local config = kingStarWarltCtrl.getRewardsConfig(mapid)
	return config["3"]["1"]
end
function kingStarWarltCtrl.getLegendBestReward(rewardType, mapid)
	local config = kingStarWarltCtrl.getRewardsConfig(mapid)
	local award = config[tostring(rewardType)]
	if not award or not award["1"] then
		kingStarWarltCtrl = award["1"]
	end
	return award["1"]
end
function kingStarWarltCtrl.getPointConfig(mapid)
	if mapid == worldMapDefine.KINGSTAR_KINGDOM_ID then
		return kingStarWarltCtrl.legendPointConfig
	else
		return kingStarWarltCtrl.legendPointConfig2
	end
end
return kingStarWarltCtrl

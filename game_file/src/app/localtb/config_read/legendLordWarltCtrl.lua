local legendLordWarltCtrl = include("aAReadClass").new()
local kingStarWarltCtrl = include("kingStarWarltCtrl")
local isInited = false
local init = function()
	if isInited then
		return
	end
	local createData = function(name)
		legendLordWarltCtrl.posRefLegendLordWarBuilding, legendLordWarltCtrl, legendLordWarltCtrl.type2bid, legendLordWarltCtrl, legendLordWarltCtrl.legendLordWarBuilding, legendLordWarltCtrl = nil, nil, nil, nil, nil, nil
		local legendLordWarBuilding = require_once("app." .. LocalTblPath .. ".config_server.legendaryking_building_cost")
		for id, build in pairs(legendLordWarBuilding) do
			local build = clone(build)
			build.x = build.x - gPointClientPointPlus
			build.y = build.y - gPointClientPointPlus
			legendLordWarltCtrl.legendLordWarBuilding[id] = build
			legendLordWarltCtrl.type2bid[build.type] = id
		end
		for id, v in pairs(legendLordWarBuilding) do
			v.id = id
			v.objId = id
			local x, y = v.x - 1, v.y - 1
			v.x = v.x - 1
			v.y = v.y - 1
			if not legendLordWarltCtrl.posRefLegendLordWarBuilding[x] then
				legendLordWarltCtrl.posRefLegendLordWarBuilding[x], legendLordWarltCtrl = nil, nil
			end
			legendLordWarltCtrl.posRefLegendLordWarBuilding[x][y] = v
		end
		if name == "legendLordWarBuilding" then
			return legendLordWarltCtrl.legendLordWarBuilding
		elseif name == "type2bid" then
			return legendLordWarltCtrl.type2bid
		elseif name == "posRefLegendLordWarBuilding" then
			return legendLordWarltCtrl.posRefLegendLordWarBuilding
		end
	end
	legendLordWarltCtrl:defineValue("legendLordWarBuilding", createData)
	legendLordWarltCtrl:defineValue("type2bid", createData)
	legendLordWarltCtrl:defineValue("posRefLegendLordWarBuilding", createData)
	legendLordWarltCtrl:defineValue("legendLordWarRewards", function()
		legendLordWarltCtrl.legendLordWarRewards, legendLordWarltCtrl = nil, nil
		local legendLordWarRewards = require_once("app." .. LocalTblPath .. ".config_server.legendaryking_rewards")
		local legendLordWarltCtrl, ret = "app." .. LocalTblPath .. ".config_server.legendaryking_rewards", "app." .. LocalTblPath .. ".config_server.legendaryking_rewards"
		for _, v in pairs(legendLordWarRewards) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			local reward = serviceFunctions.tableFormat(v.rewards, nil)
			if not ret[tostring(v.rewardsType)] then
				ret[tostring(v.rewardsType)], legendLordWarltCtrl = v.rewardsType, v.rewardsType
			end
			if not ret[tostring(v.rewardsType)][tostring(v.condition)] then
				ret[tostring(v.rewardsType)][tostring(v.condition)], legendLordWarltCtrl = v.condition, v.condition
			end
			ret[tostring(v.rewardsType)][tostring(v.condition)] = reward
		end
		legendLordWarltCtrl.legendLordWarRewards = ret
		return legendLordWarltCtrl.legendLordWarRewards
	end)
	function legendLordWarltCtrl()
		legendLordWarltCtrl.legendLordWarRewards, legendLordWarltCtrl = nil, nil
		local legendLordWarRewards = require_once("app." .. LocalTblPath .. ".config_server.legendaryking_rewards")
		local legendLordWarltCtrl, ret = "app." .. LocalTblPath .. ".config_server.legendaryking_rewards", "app." .. LocalTblPath .. ".config_server.legendaryking_rewards"
		for _, v in pairs(legendLordWarRewards) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			local reward = serviceFunctions.tableFormat(v.rewards, nil)
			if not ret[tostring(v.rewardsType)] then
				ret[tostring(v.rewardsType)], legendLordWarltCtrl = v.rewardsType, v.rewardsType
			end
			if not ret[tostring(v.rewardsType)][tostring(v.condition)] then
				ret[tostring(v.rewardsType)][tostring(v.condition)], legendLordWarltCtrl = v.condition, v.condition
			end
			ret[tostring(v.rewardsType)][tostring(v.condition)] = reward
		end
		legendLordWarltCtrl.legendLordWarRewards = ret
		return legendLordWarltCtrl.legendLordWarRewards
	end
	;(function()
		legendLordWarltCtrl.legendLordWarRewards, legendLordWarltCtrl = nil, nil
		local legendLordWarRewards = require_once("app." .. LocalTblPath .. ".config_server.legendaryking_rewards")
		local legendLordWarltCtrl, ret = "app." .. LocalTblPath .. ".config_server.legendaryking_rewards", "app." .. LocalTblPath .. ".config_server.legendaryking_rewards"
		for _, v in pairs(legendLordWarRewards) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			local reward = serviceFunctions.tableFormat(v.rewards, nil)
			if not ret[tostring(v.rewardsType)] then
				ret[tostring(v.rewardsType)], legendLordWarltCtrl = v.rewardsType, v.rewardsType
			end
			if not ret[tostring(v.rewardsType)][tostring(v.condition)] then
				ret[tostring(v.rewardsType)][tostring(v.condition)], legendLordWarltCtrl = v.condition, v.condition
			end
			ret[tostring(v.rewardsType)][tostring(v.condition)] = reward
		end
		legendLordWarltCtrl.legendLordWarRewards = ret
		return legendLordWarltCtrl.legendLordWarRewards
	end)[1] = "legendaryking_shop_point_config"
	legendLordWarltCtrl:defineValue("legendPointConfig", function()
		legendLordWarltCtrl.legendLordWarRewards, legendLordWarltCtrl = nil, nil
		local legendLordWarRewards = require_once("app." .. LocalTblPath .. ".config_server.legendaryking_rewards")
		local legendLordWarltCtrl, ret = "app." .. LocalTblPath .. ".config_server.legendaryking_rewards", "app." .. LocalTblPath .. ".config_server.legendaryking_rewards"
		for _, v in pairs(legendLordWarRewards) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			local reward = serviceFunctions.tableFormat(v.rewards, nil)
			if not ret[tostring(v.rewardsType)] then
				ret[tostring(v.rewardsType)], legendLordWarltCtrl = v.rewardsType, v.rewardsType
			end
			if not ret[tostring(v.rewardsType)][tostring(v.condition)] then
				ret[tostring(v.rewardsType)][tostring(v.condition)], legendLordWarltCtrl = v.condition, v.condition
			end
			ret[tostring(v.rewardsType)][tostring(v.condition)] = reward
		end
		legendLordWarltCtrl.legendLordWarRewards = ret
		return legendLordWarltCtrl.legendLordWarRewards
	end)
end
init()
function legendLordWarltCtrl.getBidByType(subMapType, mapid)
	if worldMapDefine.isKingStarMapId(mapid) then
		return kingStarWarltCtrl.getBidByType(subMapType, mapid)
	end
	print("legendLordWarltCtrl.getBidByType subMapType = ", subMapType)
	return legendLordWarltCtrl.type2bid[subMapType]
end
function legendLordWarltCtrl.updateLegendReward(rewardInfo, mapid)
	if worldMapDefine.isKingStarMapId(mapid) then
		return kingStarWarltCtrl.updateLegendReward(rewardInfo, mapid)
	end
	if rewardInfo then
		legendLordWarltCtrl.legendLordWarRewards = rewardInfo
	end
end
function legendLordWarltCtrl.getLegendLordWarBuilding(mapid)
	if worldMapDefine.isKingStarMapId(mapid) then
		return kingStarWarltCtrl.getLegendLordWarBuilding(mapid)
	end
	return legendLordWarltCtrl.legendLordWarBuilding
end
function legendLordWarltCtrl.getLegendLordWarBuildingById(id, mapid)
	if worldMapDefine.isKingStarMapId(mapid) then
		return kingStarWarltCtrl.getLegendLordWarBuildingById(id, mapid)
	end
	return legendLordWarltCtrl.legendLordWarBuilding[id]
end
function legendLordWarltCtrl.getLegendLordWarBuildingByPos(x, y, mapid)
	if worldMapDefine.isKingStarMapId(mapid) then
		return kingStarWarltCtrl.getLegendLordWarBuildingByPos(x, y, mapid)
	end
	if legendLordWarltCtrl.posRefLegendLordWarBuilding[x] then
		return legendLordWarltCtrl.posRefLegendLordWarBuilding[x][y]
	end
end
function legendLordWarltCtrl.getLegendLordWarFirstKillReward(occupySecs, mapid)
	if worldMapDefine.isKingStarMapId(mapid) then
		return kingStarWarltCtrl.getLegendLordWarFirstKillReward(occupySecs, mapid)
	end
	local condition = occupySecs or LLW_OCCUPY_FIRST_KILL_TIME
	return legendLordWarltCtrl.legendLordWarRewards["1"][tostring(condition)]
end
function legendLordWarltCtrl.getLegendLordWarRankReward(rank, mapid)
	if worldMapDefine.isKingStarMapId(mapid) then
		return kingStarWarltCtrl.getLegendLordWarRankReward(rank, mapid)
	end
	return legendLordWarltCtrl.legendLordWarRewards["2"][tostring(rank)]
end
function legendLordWarltCtrl.getLegendLordWarRankRewards(mapid)
	if worldMapDefine.isKingStarMapId(mapid) then
		return kingStarWarltCtrl.getLegendLordWarRankRewards(mapid)
	end
	return legendLordWarltCtrl.legendLordWarRewards["2"]
end
function legendLordWarltCtrl.getLegendLordWarParticipationReward(mapid)
	if worldMapDefine.isKingStarMapId(mapid) then
		return kingStarWarltCtrl.getLegendLordWarParticipationReward(mapid)
	end
	return legendLordWarltCtrl.legendLordWarRewards["3"]["1"]
end
function legendLordWarltCtrl.getLegendBestReward(rewardType, mapid)
	if worldMapDefine.isKingStarMapId(mapid) then
		return kingStarWarltCtrl.getLegendBestReward(rewardType, mapid)
	end
	dump(legendLordWarltCtrl.legendLordWarRewards, "legendLordWarRewards", 10)
	local award = legendLordWarltCtrl.legendLordWarRewards[tostring(rewardType)]
	if not award or not award["1"] then
		_ENV = award["1"]
	end
	return award["1"]
end
function legendLordWarltCtrl.getPointConfig(mapid)
	if worldMapDefine.isKingStarMapId(mapid) then
		return kingStarWarltCtrl.getPointConfig(mapid)
	end
	return legendLordWarltCtrl.legendPointConfig
end
return legendLordWarltCtrl

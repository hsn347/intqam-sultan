local sinbadTreasureRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	sinbadTreasureRead:defineValue("ssc", function()
		local sinbadtreasure_stage_config = require_once("app." .. LocalTblPath .. ".config_server.sinbadtreasure_stage_config")
		sinbadTreasureRead.ssc, _ENV = "app." .. LocalTblPath .. ".config_server.sinbadtreasure_stage_config", "app." .. LocalTblPath .. ".config_server.sinbadtreasure_stage_config"
		for _, v in ipairs(sinbadtreasure_stage_config) do
			if not sinbadTreasureRead.ssc[v.classType] then
				sinbadTreasureRead.ssc[v.classType], _ENV = nil, nil
			end
			table.insert(sinbadTreasureRead.ssc[v.classType], v)
		end
		return sinbadTreasureRead.ssc
	end)
	sinbadTreasureRead:defineValue("ssr", function()
		local sinbadtreasure_stage_rank = require_once("app." .. LocalTblPath .. ".config_server.sinbadtreasure_stage_rank")
		sinbadTreasureRead.ssr, _ENV = "app." .. LocalTblPath .. ".config_server.sinbadtreasure_stage_rank", "app." .. LocalTblPath .. ".config_server.sinbadtreasure_stage_rank"
		for _, v in ipairs(sinbadtreasure_stage_rank) do
			if not sinbadTreasureRead.ssr[v.classType] then
				sinbadTreasureRead.ssr[v.classType], _ENV = nil, nil
			end
			table.insert(sinbadTreasureRead.ssr[v.classType], v)
		end
		return sinbadTreasureRead.ssr
	end)
end
init()
function sinbadTreasureRead.getStageRewardInfo(classType)
	return sinbadTreasureRead.ssc[classType]
end
function sinbadTreasureRead.getRankData(rankType, classType)
	local _ENV, rankData
	for i, v in ipairs(sinbadTreasureRead.ssr[classType]) do
		if rankType == v.type then
			table.insert(rankData, v)
		end
	end
	return rankData
end
function sinbadTreasureRead.getDecorateLv(decoratePoint, classType)
	for lv = #sinbadTreasureRead.ssc[classType], 1, -1 do
		if decoratePoint >= sinbadTreasureRead.ssc[classType][lv].num then
			return lv
		end
	end
	return 1
end
return sinbadTreasureRead

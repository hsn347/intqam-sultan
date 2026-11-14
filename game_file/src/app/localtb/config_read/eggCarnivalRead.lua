local eggCarnivalRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	eggCarnivalRead:defineValue("rankConfig", function()
		eggCarnivalRead.rankConfig, eggCarnivalRead = nil, nil
		local configRank = require_once("app." .. LocalTblPath .. ".config_server.esster_eggshare_rank")
		for i, v in ipairs(configRank) do
			local key = v.type
			if not eggCarnivalRead.rankConfig[key] then
				eggCarnivalRead.rankConfig[key], eggCarnivalRead = nil, nil
			end
			table.insert(eggCarnivalRead.rankConfig[key], v)
		end
		return eggCarnivalRead.rankConfig
	end)
	eggCarnivalRead:defineValue("PointConfig", function()
		eggCarnivalRead.PointConfig, eggCarnivalRead = nil, nil
		local configPoint = require_once("app." .. LocalTblPath .. ".config_server.esster_eggshare_score")
		for i, v in ipairs(configPoint) do
			local eggCarnivalRead, tmp
			tmp.score = v.score
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			tmp.reward = serviceFunctions.tableFormat(v.reward, nil)
			local key = v.type
			if not eggCarnivalRead.PointConfig[key] then
				eggCarnivalRead.PointConfig[key], eggCarnivalRead = nil, nil
			end
			table.insert(eggCarnivalRead.PointConfig[key], tmp)
		end
		return eggCarnivalRead.PointConfig
	end)
end
function eggCarnivalRead.getRankOrPointRewardData(nType, dataType)
	local key = nType
	return dataType and eggCarnivalRead.rankConfig[key] or eggCarnivalRead.PointConfig[key]
end
function eggCarnivalRead.getPointNum(nType)
	local key = nType
	return #eggCarnivalRead.PointConfig[key]
end
init()
return eggCarnivalRead

local starCompetitionRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	local createData = function(name)
		starCompetitionRead.config, starCompetitionRead, starCompetitionRead.oriConfig = require_data("star_competition", true, true).data, require_data("star_competition", true, true).data, require_data("star_competition", true, true).data
		for k, v in ipairs(starCompetitionRead.oriConfig) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.reward = serviceFunctions.tableFormat(v.reward, nil)
			v.index = k
			starCompetitionRead.config[v.starlv] = v
		end
		starCompetitionRead = (for generator)
		ipairs(starCompetitionRead.oriConfig).oriConfig = starCompetitionRead.oriConfig
		local ipairs(starCompetitionRead.oriConfig).config, config = starCompetitionRead.config, ipairs(starCompetitionRead.oriConfig)
		return config[name]
	end
	starCompetitionRead:defineValue("oriConfig", createData)
	starCompetitionRead:defineValue("config", createData)
end
function starCompetitionRead.getConfigByLv(lv)
	return starCompetitionRead.config[lv]
end
function starCompetitionRead.getConfigByIndex(index)
	return starCompetitionRead.oriConfig[index]
end
function starCompetitionRead.getConfigMaxLv()
	return starCompetitionRead.oriConfig[#starCompetitionRead.oriConfig].starlv
end
function starCompetitionRead.getNextConfigByLv(lv)
	local index = starCompetitionRead.getConfigMaxLv()
	for k, v in ipairs(starCompetitionRead.oriConfig) do
		if lv < v.starlv then
			index = k
			break
		end
	end
	return index
end
function starCompetitionRead.getIndexByLv(lv)
	return starCompetitionRead.config[lv].index
end
function starCompetitionRead.getConfigNum(klv)
	local cfgNum = 0
	for k, v in ipairs(starCompetitionRead.oriConfig) do
		if klv >= v.kingdomLV then
			cfgNum = cfgNum + 1
		end
	end
	return cfgNum
end
init()
return starCompetitionRead

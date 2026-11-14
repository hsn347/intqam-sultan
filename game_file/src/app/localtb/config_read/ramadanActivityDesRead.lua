local ramadanActivityDesRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	ramadanActivityDesRead:defineValue("pakatial_stage_config", function()
		local pakatial_stage_config = require_once("app." .. LocalTblPath .. ".config_server.pakatial_stage_config")
		ramadanActivityDesRead.pakatial_stage_config, _ENV = "app." .. LocalTblPath .. ".config_server.pakatial_stage_config", "app." .. LocalTblPath .. ".config_server.pakatial_stage_config"
		for _, v in ipairs(pakatial_stage_config) do
			_UPVALUE3_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			;(nil)[3] = "rate"
			v.lotteryValue = serviceFunctions.tableFormat(v.lotteryValue, nil)
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.reward = serviceFunctions.tableFormat(v.reward, nil)
			if not ramadanActivityDesRead.pakatial_stage_config[v.classType] then
				ramadanActivityDesRead.pakatial_stage_config[v.classType], _ENV = nil, nil
			end
			table.insert(ramadanActivityDesRead.pakatial_stage_config[v.classType], v)
		end
		return ramadanActivityDesRead.pakatial_stage_config
	end)
	local createData = function(name)
		ramadanActivityDesRead.pakatial_kingdomRewards, ramadanActivityDesRead, ramadanActivityDesRead.pakatial_serverRewards, ramadanActivityDesRead, ramadanActivityDesRead.pakatial_boxRewards, ramadanActivityDesRead, ramadanActivityDesRead.pakatial_stage_rank = require_data("pakatial_stage_rank", true, true).data, require_data("pakatial_stage_rank", true, true).data, require_data("pakatial_stage_rank", true, true).data, require_data("pakatial_stage_rank", true, true).data, require_data("pakatial_stage_rank", true, true).data, require_data("pakatial_stage_rank", true, true).data, require_data("pakatial_stage_rank", true, true).data
		local boxBlessNum
		for _, v in ipairs(ramadanActivityDesRead.pakatial_stage_rank) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.reward = serviceFunctions.tableFormat(v.reward, nil)
			if v.type == 1 then
				if not ramadanActivityDesRead.pakatial_boxRewards[v.classType] then
					ramadanActivityDesRead.pakatial_boxRewards[v.classType], ramadanActivityDesRead = nil, nil
				end
				table.insert(ramadanActivityDesRead.pakatial_boxRewards[v.classType], v)
				if not boxBlessNum then
					boxBlessNum = v.rank[1]
					gMaxBlessingRewardNum = boxBlessNum
				end
			elseif v.type == 2 then
				if not ramadanActivityDesRead.pakatial_serverRewards[v.classType] then
					ramadanActivityDesRead.pakatial_serverRewards[v.classType], ramadanActivityDesRead = v, v
				end
				table.insert(ramadanActivityDesRead.pakatial_serverRewards[v.classType], v)
			elseif v.type == 3 then
				if not ramadanActivityDesRead.pakatial_kingdomRewards[v.classType] then
					ramadanActivityDesRead.pakatial_kingdomRewards[v.classType], ramadanActivityDesRead = v, v
				end
				table.insert(ramadanActivityDesRead.pakatial_kingdomRewards[v.classType], v)
			end
		end
		return ramadanActivityDesRead[name]
	end
	ramadanActivityDesRead:defineValue("pakatial_stage_rank", createData)
	ramadanActivityDesRead:defineValue("pakatial_boxRewards", createData)
	ramadanActivityDesRead:defineValue("pakatial_serverRewards", createData)
	ramadanActivityDesRead:defineValue("pakatial_kingdomRewards", createData)
end
init()
function ramadanActivityDesRead.getPakatialBoxRewards(classType)
	return ramadanActivityDesRead.pakatial_boxRewards[classType]
end
function ramadanActivityDesRead.getPakatialServerRewards(classType)
	return ramadanActivityDesRead.pakatial_serverRewards[classType]
end
function ramadanActivityDesRead.getPakatialKingdomRewards(classType)
	return ramadanActivityDesRead.pakatial_kingdomRewards[classType]
end
function ramadanActivityDesRead.getPakatialStageItem(stage, classType)
	return ramadanActivityDesRead.pakatial_stage_config[classType][stage]
end
function ramadanActivityDesRead.getPakatialStageConfig(classType)
	return ramadanActivityDesRead.pakatial_stage_config[classType]
end
function ramadanActivityDesRead.getDecorateLv(decoratePoint, classType)
	for lv = #ramadanActivityDesRead.pakatial_stage_config[classType], 1, -1 do
		if decoratePoint >= ramadanActivityDesRead.pakatial_stage_config[classType][lv].score then
			return lv
		end
	end
	return 1
end
function ramadanActivityDesRead.getDecorateMaxLv(classType)
	return #ramadanActivityDesRead.pakatial_stage_config[classType]
end
function ramadanActivityDesRead.getPercent(kingdomDecoratePoint, classType)
	local curLv = ramadanActivityDesRead.getDecorateLv(kingdomDecoratePoint, classType)
	local percent = (curLv - 1) / (ramadanActivityDesRead.getDecorateMaxLv(classType) - 1)
	if curLv < 4 then
		local curStageScore = ramadanActivityDesRead.getPakatialStageItem(curLv, classType).score
		local nextStageScore = ramadanActivityDesRead.getPakatialStageItem(curLv + 1, classType).score
		local percent2 = (kingdomDecoratePoint - curStageScore) / (nextStageScore - curStageScore) / (ramadanActivityDesRead.getDecorateMaxLv(classType) - 1)
		percent = percent + percent2
	end
	return percent
end
return ramadanActivityDesRead

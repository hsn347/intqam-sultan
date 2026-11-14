local activity_9001642_Read = include("aAReadClass").new()
function activity_9001642_Read.getPhoneixStageName(phoenixType)
	_ENV = nil
	;(nil)[1] = i18n("Phonex_Challenge_text_2")
	;(nil)[2] = i18n("Phonex_Challenge_text_3")
	local (nil)[3], cfg = i18n("Phonex_Challenge_text_4"), nil
	return cfg[phoenixType] or ""
end
activity_9001642_Read:defineValue("stageConfig", function()
	local config = require_data("phoenix_challenge_stage_reward", true, true).data
	local _ENV, ret = "phoenix_challenge_stage_reward", "phoenix_challenge_stage_reward"
	for _, v in ipairs(config) do
		if not ret[v.classType] then
			ret[v.classType], _ENV = nil, nil
		end
		if not ret[v.classType][v.phoenixType] then
			ret[v.classType][v.phoenixType], _ENV = nil, nil
		end
		_ENV = v.phoenixType
		v.phoenixType.rankNum = v.rankNum
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.phoenixType.reward = serviceFunctions.tableFormat(v.reward, nil)
		table.insert(ret[v.classType][v.phoenixType], v.phoenixType)
	end
	return ret
end)
function activity_9001642_Read.getStageCfg(classType)
	return activity_9001642_Read.stageConfig[classType]
end
function activity_9001642_Read.getStageList(classType, phoenixType)
	return activity_9001642_Read.stageConfig[classType][phoenixType]
end
activity_9001642_Read:defineValue("rankConfig", function()
	local config = require_data("phoenix_challenge_rank_reward", true, true).data
	local _ENV, ret = "phoenix_challenge_rank_reward", "phoenix_challenge_rank_reward"
	for _, v in ipairs(config) do
		if not ret[v.classType] then
			ret[v.classType], _ENV = nil, nil
		end
		if not ret[v.classType][v.rewardType] then
			ret[v.classType][v.rewardType], _ENV = nil, nil
		end
		_ENV = v.rewardType
		v.rewardType.rank = v.rank
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.rewardType.reward = serviceFunctions.tableFormat(v.reward, nil)
		table.insert(ret[v.classType][v.rewardType], v.rewardType)
	end
	return ret
end)
function activity_9001642_Read.getRankCfg(classType)
	return activity_9001642_Read.rankConfig[classType]
end
return activity_9001642_Read

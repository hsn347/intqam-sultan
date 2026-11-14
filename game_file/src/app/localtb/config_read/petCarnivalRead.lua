local petCarnivalRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	local createData = function(name)
		petCarnivalRead.TasConfig, petCarnivalRead, petCarnivalRead.config = require_data("pet_flip_config", true, true).data, require_data("pet_flip_config", true, true).data, require_data("pet_flip_config", true, true).data
		for k, v in ipairs(petCarnivalRead.config) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.reward = serviceFunctions.tableFormat(v.reward, nil)
			table.insert(petCarnivalRead.TasConfig, v)
		end
		return petCarnivalRead[name]
	end
	petCarnivalRead:defineValue("config", createData)
	petCarnivalRead:defineValue("TasConfig", createData)
	local createData = function(name)
		petCarnivalRead.rewardConfig = require_data("pet_flip_card", true, true).data
		petCarnivalRead.RewardConfig, petCarnivalRead, petCarnivalRead.maxPoint = require_data("pet_flip_card", true, true).data, require_data("pet_flip_card", true, true).data, 0
		for k, v in ipairs(petCarnivalRead.rewardConfig) do
			if v.num > petCarnivalRead.maxPoint then
				petCarnivalRead.maxPoint = v.num
			end
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.reward = serviceFunctions.tableFormat(v.reward, nil)
			table.insert(petCarnivalRead.RewardConfig, v)
		end
		return petCarnivalRead[name]
	end
	petCarnivalRead:defineValue("rewardConfig", createData)
	petCarnivalRead:defineValue("maxPoint", createData)
	petCarnivalRead:defineValue("RewardConfig", createData)
end
init()
function petCarnivalRead.getConfig()
	return petCarnivalRead.TasConfig
end
function petCarnivalRead.getRewardCfg()
	local _ENV, ret
	for k, v in ipairs(petCarnivalRead.rewardConfig) do
		ret[k] = v.num
	end
	return ret
end
function petCarnivalRead.getRewardConfig(index)
	if not index then
		print("阶段奖励配置")
		return petCarnivalRead.RewardConfig
	end
	for k, v in ipairs(petCarnivalRead.RewardConfig) do
		if v.index == index then
			return v
		end
	end
end
function petCarnivalRead.getRewardInfoByIndex(index)
	for k, v in ipairs(petCarnivalRead.RewardConfig) do
		if v.index == index then
			return v
		end
	end
end
function petCarnivalRead.getBiggestPoint()
	return petCarnivalRead.maxPoint
end
return petCarnivalRead

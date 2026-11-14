local newServerPetRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_ENV = nil
	;(nil)[1] = "vicious_cat_exp"
	;(nil)[2] = true
	newServerPetRead:defineValue("returnCatExp", nil)
	_ENV = nil
	;(nil)[1] = "vicious_cat_reward"
	;(nil)[2] = true
	newServerPetRead:defineValue("returnCatReward", nil)
	newServerPetRead:defineValue("returnCatExpConfig", function()
		newServerPetRead.returnCatExpConfig, newServerPetRead = nil, nil
		for i, v in ipairs(newServerPetRead.returnCatExp) do
			local tempTable = v
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			tempTable.lowReward = serviceFunctions.tableFormat(v.lowReward, nil)
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			tempTable.highReward = serviceFunctions.tableFormat(v.highReward, nil)
			tempTable.type = 1
			table.insert(newServerPetRead.returnCatExpConfig, tempTable)
		end
		return newServerPetRead.returnCatExpConfig
	end)
	newServerPetRead:defineValue("returnCatRewardConfig", function()
		newServerPetRead.returnCatRewardConfig, newServerPetRead = nil, nil
		for i, v in ipairs(newServerPetRead.returnCatReward) do
			local tempTable = v
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			tempTable.uplvReward = serviceFunctions.tableFormat(v.uplvReward, nil)
			_UPVALUE3_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			;(nil)[3] = "weight"
			tempTable.lowWalkReward = serviceFunctions.tableFormat(v.lowWalkReward, nil)
			_UPVALUE3_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			;(nil)[3] = "weight"
			tempTable.highWalkReward = serviceFunctions.tableFormat(v.highWalkReward, nil)
			table.insert(newServerPetRead.returnCatRewardConfig, tempTable)
			local newServerPetRead, tempTable = table.insert, table.insert
			tempTable.type = 2
			tempTable.lv = #newServerPetRead.returnCatExpConfig
			tempTable.exp = v.exp
			tempTable.uplvReward = v.uplvReward
			table.insert(newServerPetRead.returnCatExpConfig, tempTable)
		end
		return newServerPetRead.returnCatRewardConfig
	end)
end
init()
function newServerPetRead.getReturnCatExpConfig(...)
	return newServerPetRead.returnCatExpConfig
end
function newServerPetRead.getReturnCatRewardConfig(...)
	return newServerPetRead.returnCatRewardConfig[1]
end
function newServerPetRead.getLvNeedExp(lv)
	local config = newServerPetRead.returnCatExpConfig[lv]
	if config then
		return config.exp
	else
		return newServerPetRead.returnCatRewardConfig[1].exp
	end
end
return newServerPetRead

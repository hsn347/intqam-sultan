local _ENV, newBuffltCtrl
local config = include("new_buff_config")
local excludeConfig = include("new_buff_unique_exclude")
local _ENV, excludeConfigMap = "new_buff_unique_exclude", "new_buff_unique_exclude"
function newBuffltCtrl.init()
	for i, v in ipairs(excludeConfig) do
		local excludes = v.exclude
		for _, buffID in ipairs(excludes) do
			excludeConfigMap[buffID] = i
		end
	end
end
function newBuffltCtrl.buffIDValid(buffID)
	if config[buffID] then
		return true
	else
		return false
	end
end
function newBuffltCtrl.getSource(buffID)
	return config[buffID].source
end
function newBuffltCtrl.getAttrID(buffID)
	return config[buffID].attributeID
end
function newBuffltCtrl.getAttrValue(buffID)
	return config[buffID].attributeValue
end
function newBuffltCtrl.getLifeType(buffID)
	return config[buffID].lifeType
end
function newBuffltCtrl.getLifeParams(buffID)
	return config[buffID].lifeParams
end
function newBuffltCtrl.getIsExclude(buffID1, buffID2)
	local index1 = excludeConfigMap[buffID1]
	local index2 = excludeConfigMap[buffID2]
	if index1 ~= nil and index1 == index2 then
		return true
	end
	return false
end
function newBuffltCtrl.getExclude(buffID)
	local index = excludeConfigMap[buffID]
	if index and excludeConfig[index] then
		return excludeConfig[index].exclude
	end
end
newBuffltCtrl.init()
return newBuffltCtrl

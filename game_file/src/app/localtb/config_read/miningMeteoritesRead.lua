local miningMeteoritesRead = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "mining_meteorites"
;(nil)[2] = true
miningMeteoritesRead:defineValue("config", nil)
_UPVALUE1_ = nil
;(nil)[1] = "mining_meteorites_doubled"
miningMeteoritesRead:defineValue("double", nil)
function miningMeteoritesRead.getConfigs()
	return miningMeteoritesRead.config
end
function miningMeteoritesRead.getConfig(groupData)
	local _ENV, configs
	for i, v in pairs(groupData) do
		for k2, v2 in pairs(miningMeteoritesRead.config) do
			if tonumber(i) == v2.type and v.curStage == v2.stage then
				configs[v2.type] = v2
			end
		end
	end
	for i, v in ipairs(miningMeteoritesRead.config) do
		if v.stage == 1 and configs[v.type] == nil then
			configs[v.type] = v
		end
	end
	return configs
end
function miningMeteoritesRead.getDoubles()
	return miningMeteoritesRead.double
end
return miningMeteoritesRead

local actCommonltCtrl = include("aAReadClass").new()
actCommonltCtrl.isInit = false
function actCommonltCtrl.init()
	if actCommonltCtrl.isInit then
		return
	end
	actCommonltCtrl.isInit = true
	actCommonltCtrl:defineValue("actConfig", function(config)
		local config = require_once("app." .. LocalTblPath .. ".config_server.act_common_config")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_server.act_common_config", "app." .. LocalTblPath .. ".config_server.act_common_config"
		for actID, data in pairs(config) do
			ret[actID], _ENV = nil, nil
			for k, v in pairs(data) do
				if "string" == type(v) and "" ~= v then
					local temp = string.split(v, ";")
					if temp then
						for i = 1, #temp do
							local n = tonumber(temp[i])
							if n then
								temp[i] = n
							end
						end
					end
					ret[actID][k] = serviceFunctions.tableFormatToMap(temp)
				end
			end
		end
		return ret
	end)
	actCommonltCtrl.actListOfBoost = nil
end
actCommonltCtrl.init()
function actCommonltCtrl.getConfig(actID, key1, key2)
	if not actID then
		return
	end
	local config = actCommonltCtrl.actConfig[actID]
	if nil == key1 or nil == config then
		return config
	end
	config = config[key1]
	if nil == key2 or nil == config then
		return config
	end
	return config[key2]
end
function actCommonltCtrl.getActBoostList()
	if not actCommonltCtrl.actListOfBoost then
		local actCommonltCtrl, ret = actCommonltCtrl.actListOfBoost, actCommonltCtrl.actListOfBoost
		for actID, v in pairs(actCommonltCtrl.actConfig) do
			if v.boost then
				ret[actID] = true
			end
		end
		actCommonltCtrl.actListOfBoost = ret
	end
	return actCommonltCtrl.actListOfBoost
end
function actCommonltCtrl.isActOfBoost(actID)
	local list = actCommonltCtrl.getActBoostList()
	if list[actID] then
		return true
	end
	return false
end
return actCommonltCtrl

local dailyResLimitltCtrl = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	dailyResLimitltCtrl:defineValue("data", function()
		local config = require_once("app." .. LocalTblPath .. ".config_server.resource_limit_config")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_server.resource_limit_config", "app." .. LocalTblPath .. ".config_server.resource_limit_config"
		for k, v in pairs(config) do
			local source = v.source
			if not ret[source] then
				_ENV = ret[source]
			end
			ret[source] = ret[source]
			local lv = v.lv
			local resource = serviceFunctions.tableFormatToMap(v.resource)
			_ENV = nil
			;(nil).resource = resource
			;(nil).castleLVMin = lv[1]
			;(nil).castleLVMax = lv[2]
			table.insert(ret[source], nil)
		end
		return ret
	end)
	dailyResLimitltCtrl:defineValue("glory_data", function()
		local config = require_once("app." .. LocalTblPath .. ".config_server.resource_limit_glory_config")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_server.resource_limit_glory_config", "app." .. LocalTblPath .. ".config_server.resource_limit_glory_config"
		for k, v in pairs(config) do
			local source = v.source
			if not ret[source] then
				_ENV = ret[source]
			end
			ret[source] = ret[source]
			local lv = v.lv
			local resource = serviceFunctions.tableFormatToMap(v.resource)
			_ENV = nil
			;(nil).resource = resource
			;(nil).gloryLVMin = lv[1]
			;(nil).gloryLVMax = lv[2]
			table.insert(ret[source], nil)
		end
		return ret
	end)
end
init()
function dailyResLimitltCtrl:isSource(source)
	local sourceNum = tonumber(source)
	if sourceNum >= gResSourceEnum.MIN and sourceNum <= gResSourceEnum.MAX then
		return true
	end
	return false
end
function dailyResLimitltCtrl:getResLimit(resID, source, castleLV)
	source = source or gResSourceEnum.OTHER
	if not self:isSource(source) then
		return
	end
	castleLV = tonumber(castleLV)
	if "number" ~= type(castleLV) or castleLV <= 0 then
		return
	end
	resID = tonumber(resID)
	if not serviceFunctions.isResourceID(resID) and gIDDef.GOLD ~= resID then
		return
	end
	local config = self:getConfig(source, castleLV)
	if config[resID] then
		return config[resID]
	end
	local gloriousLevel = SoraDGetBuildStarLv(BUILDID.GLORIOUS_STATUE)
	if not self.glory_data[source] then
		_ENV = self.glory_data[source]
	end
	for k, v in pairs(self.glory_data[source]) do
		if v.gloryLVMin == 0 and v.gloryLVMax == 0 then
			return v.resource[resID]
		end
		if gloriousLevel >= v.gloryLVMin and gloriousLevel <= v.gloryLVMax then
			return v.resource[resID]
		end
	end
	return
end
function dailyResLimitltCtrl:getConfig(source, castleLV)
	local config = self.data[source]
	if config then
		for k, v in pairs(config) do
			local castleLVMin = v.castleLVMin
			local castleLVMax = v.castleLVMax
			if 0 == castleLVMin and 0 == castleLVMax then
				return v.resource
			end
			if castleLV >= castleLVMin and castleLV <= castleLVMax then
				return v.resource
			end
		end
	end
end
return dailyResLimitltCtrl

local treviFountainLocalData = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	treviFountainLocalData.init()
end
function treviFountainLocalData.init()
	treviFountainLocalData:defineValue("geocachingData", function()
		treviFountainLocalData.geocachingData, treviFountainLocalData = nil, nil
		local geocaching = require_once("app." .. LocalTblPath .. ".config_client.geocaching")
		for _, var in ipairs(geocaching) do
			treviFountainLocalData.geocachingData[tostring(var.level)] = var
		end
		return treviFountainLocalData.geocachingData
	end)
	treviFountainLocalData:defineValue("geocachingcritData", function()
		treviFountainLocalData.geocachingcritData, treviFountainLocalData = nil, nil
		local geocachingcrit = require_once("app." .. LocalTblPath .. ".config_server.geocachingcrit")
		for _, var in ipairs(geocachingcrit) do
			treviFountainLocalData.geocachingcritData[tostring(var.multiple)] = var
		end
		return treviFountainLocalData.geocachingcritData
	end)
end
init()
return treviFountainLocalData

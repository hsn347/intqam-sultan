local starLampRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	if userSDKManager.isAR() then
		_ENV = nil
		;(nil)[1] = "star_lamp_config"
		starLampRead:defineValue("info", nil)
	else
		_ENV = nil
		;(nil)[1] = "star_lamp_config_en"
		starLampRead:defineValue("info", nil)
	end
end
function starLampRead.getLampInfo(lid)
	lid = tonumber(lid)
	return starLampRead.info[lid]
end
init()
return starLampRead

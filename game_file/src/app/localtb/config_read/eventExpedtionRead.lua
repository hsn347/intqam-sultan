local eventExpedtionRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "battlefield_war_config"
	;(nil)[2] = true
	eventExpedtionRead:defineValue("warconfig", nil)
end
init()
function eventExpedtionRead.getWarConfig()
	return eventExpedtionRead.warconfig
end
return eventExpedtionRead

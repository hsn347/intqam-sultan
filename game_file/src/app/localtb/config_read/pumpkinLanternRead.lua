local pumpkinLanternRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "allsaintsday_pumpkin_cofig"
	;(nil)[2] = true
	pumpkinLanternRead:defineValue("config", nil)
end
init()
function pumpkinLanternRead.getFinalAward()
	return pumpkinLanternRead.config[1] and pumpkinLanternRead.config[1].award
end
return pumpkinLanternRead

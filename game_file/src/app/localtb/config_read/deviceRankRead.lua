local deviceRankRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	deviceRankRead = nil
	;(nil)[1] = "acyivity_rank_des"
	deviceRankRead:defineValue("eventInfo", nil)
end
function deviceRankRead.getEventInfo(eid)
	init()
	eid = tonumber(eid)
	return deviceRankRead.eventInfo[eid]
end
return deviceRankRead

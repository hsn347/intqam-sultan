local luckDayBuffRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	luckDayBuffRead = nil
	;(nil)[1] = "lucky_day_quality"
	luckDayBuffRead:defineValue("buff", nil)
end
init()
function luckDayBuffRead.getBuffRare(type, section)
	local rare = 1
	for k, v in pairs(luckDayBuffRead.buff) do
		if type == v.Type and section == v.Section then
			rare = v.Rare
			break
		end
	end
	return rare
end
return luckDayBuffRead

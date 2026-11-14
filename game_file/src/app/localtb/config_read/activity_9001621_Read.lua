local activity_9001621_Read = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "army_subtidy"
;(nil)[2] = true
activity_9001621_Read:defineValue("army_subtidy", nil)
activity_9001621_Read:defineValue("army", function()
	local _ENV, ret
	for _, v in ipairs(activity_9001621_Read.army_subtidy) do
		_UPVALUE2_ = nil
		;(nil)[1] = "time"
		;(nil)[2] = "count"
		v.trainNum = serviceFunctions.tableFormat(v.trainNum, nil)
		ret[v.days] = v
	end
	return ret
end)
function activity_9001621_Read.getArmyCfg(backDay)
	return activity_9001621_Read.army[backDay]
end
return activity_9001621_Read

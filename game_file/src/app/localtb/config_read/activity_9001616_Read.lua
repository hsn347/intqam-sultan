local activity_9001616_Read = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "summon_ghoul_purify_points"
;(nil)[2] = true
activity_9001616_Read:defineValue("summon_ghoul_purify_points", nil)
function activity_9001616_Read.getBuffConfig(...)
	return activity_9001616_Read.summon_ghoul_purify_points
end
function activity_9001616_Read.getBuffConfigByIndex(index)
	return activity_9001616_Read.summon_ghoul_purify_points[index]
end
function activity_9001616_Read.getBuffPoint(index)
	local cfg = activity_9001616_Read.getBuffConfigByIndex(index)
	return cfg and cfg.Point or 0
end
function activity_9001616_Read.getBuffList(index)
	local cfg = activity_9001616_Read.getBuffConfigByIndex(index)
	if not cfg or not cfg.BuffList then
		activity_9001616_Read = cfg.BuffList
	end
	return cfg.BuffList
end
function activity_9001616_Read.getBuffIcon(index)
	local cfg = activity_9001616_Read.getBuffConfigByIndex(index)
	return cfg and cfg.buffIcon
end
function activity_9001616_Read.getBuffIndexByPoint(point)
	local config = activity_9001616_Read.getBuffConfig()
	for i, v in ipairs(config) do
		if point < v.Point then
			return i - 1
		end
	end
	return #config
end
function activity_9001616_Read.getBuffPointList(...)
	local activity_9001616_Read, ret
	local config = activity_9001616_Read.getBuffConfig()
	for __, v in ipairs(config) do
		table.insert(ret, v.Point)
	end
	return ret
end
return activity_9001616_Read

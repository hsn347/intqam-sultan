local activity_9001531_Read = include("aAReadClass").new()
activity_9001531_Read:defineValue("useItemList", function()
	local bright_fireworks = require_data("bright_fireworks", true).data
	local _ENV, ret = "bright_fireworks", "bright_fireworks"
	for __, v in ipairs(bright_fireworks) do
		if v.classType == 1 then
			table.insert(ret, v.item)
		end
	end
	return ret
end)
function activity_9001531_Read.getUseItemList()
	return activity_9001531_Read.useItemList
end
function _UPVALUE2_()
	local bright_fireworks = require_data("bright_fireworks", true).data
	local _ENV, ret = "bright_fireworks", "bright_fireworks"
	for __, v in ipairs(bright_fireworks) do
		if v.classType == 1 then
			table.insert(ret, v.item)
		end
	end
	return ret
end
;(function()
	local bright_fireworks = require_data("bright_fireworks", true).data
	local _ENV, ret = "bright_fireworks", "bright_fireworks"
	for __, v in ipairs(bright_fireworks) do
		if v.classType == 1 then
			table.insert(ret, v.item)
		end
	end
	return ret
end)[1] = "bright_fireworks_cycle"
;(function()
	local bright_fireworks = require_data("bright_fireworks", true).data
	local _ENV, ret = "bright_fireworks", "bright_fireworks"
	for __, v in ipairs(bright_fireworks) do
		if v.classType == 1 then
			table.insert(ret, v.item)
		end
	end
	return ret
end)[2] = true
activity_9001531_Read:defineValue("bright_fireworks_cycle", function()
	local bright_fireworks = require_data("bright_fireworks", true).data
	local _ENV, ret = "bright_fireworks", "bright_fireworks"
	for __, v in ipairs(bright_fireworks) do
		if v.classType == 1 then
			table.insert(ret, v.item)
		end
	end
	return ret
end)
function activity_9001531_Read.getCycleConfig(stage)
	return activity_9001531_Read.bright_fireworks_cycle[stage]
end
function activity_9001531_Read.getPointsByStage(stage)
	local cfg = activity_9001531_Read.getCycleConfig(stage)
	return cfg.points
end
function activity_9001531_Read.getRewardByStage(stage)
	local cfg = activity_9001531_Read.getCycleConfig(stage)
	return cfg.reward
end
function activity_9001531_Read.getRewardIDByStage(stage)
	local reward = activity_9001531_Read.getRewardByStage(stage)
	return reward[1]
end
return activity_9001531_Read

local activity_9001706_Read = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "sultan_peresent_personal"
;(nil)[2] = true
activity_9001706_Read:defineValue("sultan_peresent_personal", nil)
function activity_9001706_Read.getPersonalCfg()
	return activity_9001706_Read.sultan_peresent_personal
end
_UPVALUE2_ = nil
;(nil)[1] = "sultan_peresent_server"
;(nil)[2] = true
activity_9001706_Read:defineValue("sultan_peresent_server", nil)
function activity_9001706_Read.getServerCfg()
	return activity_9001706_Read.sultan_peresent_server
end
function activity_9001706_Read.getServerCfgByIndex(index)
	return activity_9001706_Read.sultan_peresent_server[index]
end
function activity_9001706_Read.getServerIndex(num, real)
	local index = real and 0 or 1
	for k, v in ipairs(activity_9001706_Read.sultan_peresent_server) do
		if num >= v.num then
			index = v.index
		end
	end
	return index
end
_UPVALUE2_ = nil
;(nil)[1] = "sultan_peresent_stage_reward"
;(nil)[2] = true
activity_9001706_Read:defineValue("sultan_peresent_stage_reward", nil)
function activity_9001706_Read.getStageCfg()
	return activity_9001706_Read.sultan_peresent_stage_reward
end
return activity_9001706_Read

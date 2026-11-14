local activity_9001620_Read = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "glory_return_preview"
;(nil)[2] = true
activity_9001620_Read:defineValue("glory_return_preview", nil)
function activity_9001620_Read.getPreviewCfg(classType)
	local _ENV, cfg
	for k, v in ipairs(activity_9001620_Read.glory_return_preview) do
		if v.classType == classType then
			table.insert(cfg, v)
		end
	end
	return cfg
end
return activity_9001620_Read

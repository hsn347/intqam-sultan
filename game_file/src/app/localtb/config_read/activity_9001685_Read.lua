local activity_9001685_Read = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "weapon_special_box"
;(nil)[2] = true
activity_9001685_Read:defineValue("weapon_special_box", nil)
function activity_9001685_Read.getDrawCfg(drawType)
	return activity_9001685_Read.weapon_special_box[drawType]
end
return activity_9001685_Read

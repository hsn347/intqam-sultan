local constantRead = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "constantarray"
;(nil)[2] = true
constantRead:defineValue("constantArray", nil)
function constantRead.getConstValueArray(key, defaultValue)
	local info = constantRead.constantArray[key]
	if info and info.value then
		return info.value
	end
	return defaultValue
end
_UPVALUE2_ = nil
;(nil)[1] = "constant"
;(nil)[2] = true
constantRead:defineValue("constantTable", nil)
function constantRead.getConstValue(key, defaultValue)
	local info = constantRead.constantTable[key]
	if info then
		local value = info.value
		if value then
			return value
		end
	end
	return defaultValue
end
function constantRead.getConstValuePercent(key, defaultValue)
	local info = constantRead.constantTable[key]
	if info then
		local value = info.value
		if value then
			return value * 100
		end
	end
	return defaultValue
end
function constantRead.getConstResDiscount_legend()
	return constantRead.getConstValue("LEGEND_LORD_WAR_COST_RES_DISCOUNT", 1)
end
function constantRead.getConstResDiscount_hegemon()
	return constantRead.getConstValue("LEGEND_HEGEMON_WAR_COST_RES_DISCOUNT", 1)
end
function constantRead.getConstCureSpeed_lgeend()
	return constantRead.getConstValue("LEGEND_LORD_WAR_CURE_SPEED", 0.2)
end
function constantRead.getConstCureSpeed_hegemon()
	return constantRead.getConstValue("LEGEND_HEGEMON_WAR_CURE_SPEED", 0.2)
end
function constantRead.getConstCureSpeed_remains()
	return constantRead.getConstValue("RUINS_WAR_CURE_SPEED", 0.5)
end
function constantRead.getConstCureSpeed_radiance()
	return constantRead.getConstValue("RADIANCE_WAR_CURE_SPEED", 0.5)
end
function constantRead.getConstArmyMax_radiance()
	return constantRead.getConstValue("RADIANCE_WAR_MAX_ARMY_NUM", 4000000)
end
function constantRead.checkLegendLordMeteorCrystal(...)
	local value = constantRead.getConstValue("LEGEND_LORD_METEOR_CRYSTAL", 0.0)
	return value == 1
end
function constantRead.checkNebulaEmperorMeteorCrystal(...)
	local value = constantRead.getConstValue("NEBULA_EMPEROR_METEOR_CRYSTAL", 1.0)
	return value == 1
end
function constantRead.checkRamadanBlessBuffSwitch(...)
	if IsArClient then
		return false
	end
	local value = constantRead.getConstValue("RAMADAN_BLESS_BUFF_SWITCH", 1.0)
	return value == 1
end
return constantRead

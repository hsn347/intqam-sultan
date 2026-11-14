local magicLampHatchRead = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "jinn_hatch_type"
;(nil)[2] = true
magicLampHatchRead:defineValue("hatch_type", nil)
_UPVALUE2_ = nil
;(nil)[1] = "jinn_hatch_desire"
;(nil)[2] = true
magicLampHatchRead:defineValue("hatch_desire", nil)
_UPVALUE2_ = nil
;(nil)[1] = "jinn_hatch_getint"
;(nil)[2] = true
magicLampHatchRead:defineValue("hatch_getint", nil)
_UPVALUE2_ = nil
;(nil)[1] = "jinn_desire_wish"
;(nil)[2] = true
magicLampHatchRead:defineValue("jinn_desire_wish", nil)
magicLampHatchRead:defineValue("typeCfg", function()
	magicLampHatchRead.typeCfg, magicLampHatchRead = nil, nil
	for i, v in ipairs(magicLampHatchRead.hatch_type) do
		if magicLampHatchRead.typeCfg[v.type] == nil then
			magicLampHatchRead.typeCfg[v.type], magicLampHatchRead = nil, nil
		end
		magicLampHatchRead.typeCfg[v.type] = v
	end
	return magicLampHatchRead.typeCfg
end)
magicLampHatchRead:defineValue("desireCfg", function()
	magicLampHatchRead.desireCfg, magicLampHatchRead = nil, nil
	for i, v in ipairs(magicLampHatchRead.hatch_desire) do
		if magicLampHatchRead.desireCfg[v.type] == nil then
			magicLampHatchRead.desireCfg[v.type], magicLampHatchRead = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "bid"
		;(nil)[2] = "lv"
		v.buildLv = serviceFunctions.tableFormat(v.buildLv, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "jinnType"
		;(nil)[2] = "lv"
		v.jinnLv = serviceFunctions.tableFormat(v.jinnLv, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "num"
		v.costItem = serviceFunctions.tableFormat(v.costItem, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "num"
		v.costRes = serviceFunctions.tableFormat(v.costRes, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "num"
		v.getItem = serviceFunctions.tableFormat(v.getItem, nil)
		magicLampHatchRead.desireCfg[v.type][v.lv] = v
	end
	return magicLampHatchRead.desireCfg
end)
function magicLampHatchRead.getHatchCfg(type)
	return magicLampHatchRead.typeCfg[tonumber(type)]
end
function magicLampHatchRead.getDesireCfg(type, lv)
	return magicLampHatchRead.desireCfg[tonumber(type)][lv]
end
function magicLampHatchRead.getGetInitCfgs()
	return magicLampHatchRead.hatch_getint
end
function magicLampHatchRead.getHatchName(type)
	return i18n(magicLampHatchRead.typeCfg[tonumber(type)].name)
end
function magicLampHatchRead.getHatchIcon(type)
	return i18n(magicLampHatchRead.typeCfg[tonumber(type)].icon)
end
function magicLampHatchRead.getMaxLv(type)
	local desireCfgs = magicLampHatchRead.desireCfg[tonumber(type)]
	if desireCfgs == nil then
		return 0
	end
	return #desireCfgs
end
function magicLampHatchRead.getDesireItems(type)
	return magicLampHatchRead.desireItems[tonumber(type)]
end
function magicLampHatchRead.isSkillUnlock(type, lv)
	local desireCfgs = magicLampHatchRead.desireCfg[tonumber(type)]
	for i, v in ipairs(desireCfgs) do
		if lv >= v.lv and v.skillSlot == 2 then
			return true
		elseif lv < v.lv then
			return false
		end
	end
end
function magicLampHatchRead.getHatchTypeByJinnType(jinnType)
	for i, v in ipairs(magicLampHatchRead.hatch_type) do
		if v.jinnType[1] == jinnType then
			return v
		end
	end
end
function magicLampHatchRead.getWishCfg()
	return magicLampHatchRead.jinn_desire_wish[1]
end
return magicLampHatchRead

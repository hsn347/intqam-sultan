local landOfSoulRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "legendaryking_soul"
	;(nil)[2] = true
	landOfSoulRead:defineValue("lks", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "kingstarbattle_soul"
	;(nil)[2] = true
	landOfSoulRead:defineValue("ksbs", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "hegemon_soul"
	;(nil)[2] = true
	landOfSoulRead:defineValue("hs", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "kingstarrank_soul"
	;(nil)[2] = true
	landOfSoulRead:defineValue("ksrs", nil)
end
init()
function landOfSoulRead:getNeedSoulNum(lv)
	local needSoulNum = 0
	local config = landOfSoulRead.lks[lv]
	if config then
		needSoulNum = config.soulnum / config.condition[2]
	end
	return needSoulNum
end
function landOfSoulRead:getNeedBless(needSoulNum)
	local addBless = 0
	local bless = include("constantRead").getConstValue("LEGENDARYKING_SOUL_BLESS")
	addBless = bless * needSoulNum
	return addBless
end
function landOfSoulRead:getNeedSoulNumKingStar(lv)
	local needSoulNum = 0
	local config = landOfSoulRead.ksbs[lv]
	if config then
		needSoulNum = config.soulnum / config.condition[2]
	end
	return needSoulNum
end
function landOfSoulRead:getNeedSoulNumKingStar_new(lv)
	local needSoulNum = 0
	local config = landOfSoulRead.ksrs[lv]
	if config then
		needSoulNum = config.soulnum / config.condition[2]
	end
	return needSoulNum
end
function landOfSoulRead:getNeedSoulNumHegemon(lv)
	local needSoulNum = 0
	local config = landOfSoulRead.hs[lv]
	if config then
		needSoulNum = config.soulnum / config.condition[2]
	end
	return needSoulNum
end
function landOfSoulRead:getNeedBlessHegemon(needSoulNum)
	local addBless = 0
	local bless = include("constantRead").getConstValue("LEGENDHEGEMON_SOUL_BLESS")
	addBless = bless * needSoulNum
	return addBless
end
return landOfSoulRead

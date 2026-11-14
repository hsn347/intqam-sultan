local divineProtectionRead = include("aAReadClass").new()
divineProtectionRead.isInit = false
function divineProtectionRead.init()
	if divineProtectionRead.isInit then
		return
	end
	divineProtectionRead.isInit = true
	_UPVALUE2_ = nil
	;(nil)[1] = "divine_protection_config"
	;(nil)[2] = true
	divineProtectionRead:defineValue("divine_protection_config", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "divine_protection_pool"
	;(nil)[2] = true
	divineProtectionRead:defineValue("divine_protection_pool", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "divine_protection_accrued"
	;(nil)[2] = true
	divineProtectionRead:defineValue("divine_protection_accrued", nil)
	_UPVALUE1_ = nil
	;(nil)[1] = "divine_protection_show"
	divineProtectionRead:defineValue("divine_protection_show", nil)
	_UPVALUE1_ = nil
	;(nil)[1] = "divine_protection_view"
	divineProtectionRead:defineValue("divine_protection_view", nil)
end
divineProtectionRead.init()
function divineProtectionRead.getAccruedCfgList()
	return divineProtectionRead.divine_protection_accrued
end
function divineProtectionRead.getAccruedStageList()
	local _ENV, ret
	for k, v in ipairs(divineProtectionRead.divine_protection_accrued) do
		table.insert(ret, v.Integral)
	end
	return ret
end
function divineProtectionRead.getPoolCfg(poolID)
	local poolID = poolID or include("constantRead").getConstValue("DIVINE_PROTECTION_POOLID", 1)
	return divineProtectionRead.divine_protection_pool[poolID]
end
function divineProtectionRead.getShowType(index)
	return divineProtectionRead.divine_protection_show[index].showType
end
function divineProtectionRead.getShowData(index)
	return divineProtectionRead.divine_protection_view[index or 1].data
end
return divineProtectionRead

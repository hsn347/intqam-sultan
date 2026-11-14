local rechargePresentRead = include("aAReadClass").new()
function rechargePresentRead:init()
	_UPVALUE2_ = nil
	;(nil)[1] = "recharge_sudan_gift"
	;(nil)[2] = true
	rechargePresentRead:defineValue("rechargeGift", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "recharge_newyear_gift"
	;(nil)[2] = true
	rechargePresentRead:defineValue("rechargeNewyearGift", nil)
end
function rechargePresentRead.getRecargeGiftNum(rid, activityID)
	local value = 0
	local info = rechargePresentRead.rechargeGift[rid]
	if info then
		return info.vatGift and info.vatGift[2]
	end
	return value
end
rechargePresentRead:init()
return rechargePresentRead

local newYearSignInRead = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "newyear_sign_in_2021"
;(nil)[2] = true
newYearSignInRead:defineValue("dayAward", nil)
_UPVALUE2_ = nil
;(nil)[1] = "remedy_sign_price_2021"
;(nil)[2] = true
newYearSignInRead:defineValue("daySignCost", nil)
function newYearSignInRead.getAwardByDay(day)
	return newYearSignInRead.dayAward[day].reward
end
function newYearSignInRead.getCostGoldSignByDay(day)
	return newYearSignInRead.daySignCost[day].price
end
return newYearSignInRead

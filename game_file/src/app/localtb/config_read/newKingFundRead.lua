local newKingFundRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "new_lord_fund_invest.lua"
	;(nil)[2] = true
	newKingFundRead:defineValue("investConfig", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "new_lord_fund_return.lua"
	;(nil)[2] = true
	newKingFundRead:defineValue("returnConfig", nil)
end
init()
function newKingFundRead.getInvestGold(day)
	return newKingFundRead.investConfig[day] and newKingFundRead.investConfig[day].Deposit or 0
end
function newKingFundRead.getInvestReturn(day)
	return newKingFundRead.investConfig[day] and newKingFundRead.investConfig[day].Return or 0
end
function newKingFundRead.getInvestRewards(day)
	if not newKingFundRead.investConfig[day] or not newKingFundRead.investConfig[day].Rewards then
		newKingFundRead = newKingFundRead.investConfig[day].Rewards
	end
	return newKingFundRead.investConfig[day].Rewards
end
function newKingFundRead.getReturnRate(totalDay)
	return newKingFundRead.returnConfig[totalDay] and newKingFundRead.returnConfig[totalDay].Rate or 0
end
return newKingFundRead

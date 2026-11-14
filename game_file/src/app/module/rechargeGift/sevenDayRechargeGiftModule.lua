local sevenDayRechargeGiftModule = class("sevenDayRechargeGiftModule")
function sevenDayRechargeGiftModule:ctor()
	_UPVALUE0_ = nil
	self.data, (nil).alreadyBuy, _UPVALUE0_, (nil).beginTime = nil, nil, nil, 0
end
function sevenDayRechargeGiftModule:destroy()
	_UPVALUE0_ = nil
	self.data, (nil).alreadyBuy, _UPVALUE0_, (nil).beginTime = nil, nil, nil, 0
end
function sevenDayRechargeGiftModule:initialize(data)
	self.data = data
end
function sevenDayRechargeGiftModule:alreadyBuy(rid)
	if rid and self.data.alreadyBuy[tostring(rid)] then
		return true
	end
end
function sevenDayRechargeGiftModule:canBuy(rid)
	local currentTime = serviceFunctions.systemTime()
	local finishTime = self:getFinishTime()
	if currentTime > finishTime then
		return false
	end
	if self.data.alreadyBuy[tostring(rid)] then
		return false
	end
	return true
end
function sevenDayRechargeGiftModule:getFinishTime()
	local beginTime = self.data.beginTime
	local zeroHourUTC = serviceFunctions.getTodayZeroHourUTC(beginTime)
	local secondsOf7d = 1209600
	local secondsOf8d = 1296000
	local addTime = 0
	if beginTime and zeroHourUTC and beginTime == zeroHourUTC then
		addTime = secondsOf7d
	else
		addTime = secondsOf8d
	end
	local finishTime = zeroHourUTC + addTime
	return finishTime
end
function sevenDayRechargeGiftModule:buySuccess(rid)
	self.data.alreadyBuy[tostring(rid)] = 1
	return gErrDef.Err_None
end
return sevenDayRechargeGiftModule

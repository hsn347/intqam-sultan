commonCheck, _ENV = nil, nil
local FODD = require_data("func_open_def_data", true)
local FUNC_TARGET_PROJECT = "koh"
_ENV, commonCheck.init = commonCheck, function()
	if not getmetatable(commonCheck) then
		local FUNC_TARGET_PROJECT, mt = getmetatable(commonCheck), getmetatable(commonCheck)
	end
	function mt.__index(t, k)
		local v = rawget(t, k)
		if not v then
			return commonCheck.checkFuncOpen(k)
		end
		return v
	end
	setmetatable(commonCheck, mt)
end
commonCheck.DAILY_DISCOUNT_GIFT = 1
commonCheck.VIP_PRIVILEGE_GIFT = 1
commonCheck.SCREEN_SHOT = 1
local commonCheck.OUTAPPPURCHASE, CLOSE_IN_REVIEW = 1, commonCheck
function commonCheck.checkFuncOpen(enum)
	if gSvrConfig.isReview and CLOSE_IN_REVIEW[enum] then
		return false
	end
	if FODD.data[enum] then
		local cfg = FODD.data[enum][FUNC_TARGET_PROJECT] or 0
		return cfg == 1
	end
	return false
end
commonCheck.init()
return commonCheck

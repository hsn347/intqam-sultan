local _ENV, dailyResetValue
local serviceFunctions = serviceFunctions
local type = type
local string = string
local setmetatable = setmetatable
local _ENV, meta
meta.__index = meta
function meta:setResetValue(val)
	if "number" == type(val) then
		self.resetValue = val
	end
end
function meta:increase(val)
	if serviceFunctions.greaterThan0(val) then
		local ret = self.value + val
		self.value = ret
		return ret
	end
end
function meta:decrease(val)
	if serviceFunctions.greaterThan0(val) then
		local ret = self.value - val
		self.value = ret
		return ret
	end
end
function meta:set(val)
	if "number" == type(val) then
		self.value = val
	end
end
local reset = function(ti, self)
	self.resetTime = ti
	self.value = self.resetValue
end
function meta:refresh()
	serviceFunctions.notSameDayDo(self.resetTime, reset, self)
end
function meta:current()
	self:refresh()
	return self.value
end
local formatStr = [[
----------dailyResetValue----------
RESET_VALUE     : %d
CURRENT_VALUE   : %d
RESET_TIME      : %s
CURRENT_TIME    : %s
-----------------------------------
]]
function meta:__tostring()
	local currentDateStr = os.date("%Y-%m-%d %H:%M:%S", serviceFunctions.systemTime())
	local resetDateStr = os.date("%Y-%m-%d %H:%M:%S", self.resetTime)
	return string.format(formatStr, self.resetValue, self.value, resetDateStr, currentDateStr)
end
function dailyResetValue.new(initialValue, resetValue)
	if "number" == type(initialValue) and "number" == type(resetValue) then
		type = type(resetValue)
		type(resetValue).resetValue = resetValue
		type(resetValue).value = initialValue
		local type(resetValue).resetTime, data = serviceFunctions.systemTime(), type(resetValue)
		dailyResetValue.init(data)
		return data
	end
end
function dailyResetValue.init(data)
	setmetatable(data, meta)
end
return dailyResetValue

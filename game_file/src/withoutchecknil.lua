local _ENV, m
local _ENV, mt
local trackback = _G.__G__TRACKBACK__
function mt.__add(a, b)
	if a == nil then
		a = 0
	end
	if b == nil then
		b = 0
	end
	return a + b
end
function mt.__sub(a, b)
	if a == nil then
		a = 0
	end
	if b == nil then
		b = 0
	end
	return a - b
end
function mt.__mul(a, b)
	if a == nil then
		a = 0
	end
	if b == nil then
		b = 0
	end
	return a * b
end
function mt.__div(a, b)
	if a == nil then
		a = 0
	end
	if b == nil then
		b = 0
	end
	return a / b
end
function mt.__mod(a, b)
	if a == nil then
		a = 0
	end
	if b == nil then
		b = 0
	end
	return a % b
end
function mt.__pow(a, b)
	if a == nil then
		a = 0
	end
	if b == nil then
		b = 0
	end
	return a ^ b
end
function mt.__unm()
	return 0
end
function mt.__concat(a, b)
	if a == nil then
		a = ""
	end
	if b == nil then
		b = ""
	end
	return a .. b
end
function mt.__len()
	return 0
end
function mt.__lt(a, b)
	if a == nil then
		a = 0
	end
	if b == nil then
		b = 0
	end
	return a < b
end
function mt.__le(a, b)
	if a == nil then
		a = 0
	end
	if b == nil then
		b = 0
	end
	return a <= b
end
function mt.__index(t, key)
	trackback("index " .. key, 3)
end
function mt.__newindex(t, key, value)
	trackback("newindex " .. key, 3)
end
function mt.__call()
	trackback("call", 3)
end
function mt.__pairs()
	trackback("pairs", 3)
end
function mt.__ipairs()
	trackback("ipairs", 3)
end
if _VERSION == "Lua 5.3" or _VERSION == "Lua 5.4" then
	mt.__idiv = load([[
        local a, b = ...
        if a == nil then a = 0 end
        if b == nil then b = 0 end
        return a // b
    ]])
	mt.__band = load([[
        local a, b = ...
        if a == nil then a = 0 end
        if b == nil then b = 0 end
        return a & b
    ]])
	mt.__bor = load([[
        local a, b = ...
        if a == nil then a = 0 end
        if b == nil then b = 0 end
        return a | b
    ]])
	mt.__bxor = load([[
        local a, b = ...
        if a == nil then a = 0 end
        if b == nil then b = 0 end
        return a ~ b
    ]])
	mt.__bnot = load([[
        return ~ 0
    ]])
	mt.__shl = load([[
        local a, b = ...
        if a == nil then a = 0 end
        if b == nil then b = 0 end
        return a << b
    ]])
	mt.__shr = load([[
        local a, b = ...
        if a == nil then a = 0 end
        if b == nil then b = 0 end
        return a >> b
    ]])
end
for event, func in pairs(mt) do
	mt[event] = function(...)
		local watch = m.watch
		if not watch then
			return func(...)
		end
		local care, result = watch(event, ...)
		if not care then
			return func(...)
		end
		return result
	end
end
function m.enable()
	debug.setmetatable(nil, mt)
end
function m.disable()
	if debug.getmetatable(nil) == mt then
		debug.setmetatable(nil, nil)
	end
end
function m.isEnable()
	return debug.getmetatable(nil) == mt
end
return m

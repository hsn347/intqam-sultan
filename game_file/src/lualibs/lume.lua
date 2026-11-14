_ENV = nil
local (nil)._version, lume = "2.2.3", nil
local pairs, ipairs = pairs, ipairs
local type, assert, unpack = type, assert, unpack or table.unpack
local tostring, tonumber = tostring, tonumber
local math_floor = math.floor
local math_ceil = math.ceil
local math_random = math.random
local math_atan2 = math.atan2 or math.atan
local math_sqrt = math.sqrt
local math_abs = math.abs
local noop = function()
end
local identity = function(x)
	return x
end
local patternescape = function(str)
	return str:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%1")
end
local absindex = function(len, i)
	return i < 0 and len + i + 1 or i
end
local iscallable = function(x)
	if type(x) == "function" then
		return true
	end
	local mt = getmetatable(x)
	return mt and mt.__call ~= nil
end
local getiter = function(x)
	if lume.isarray(x) then
		return ipairs
	elseif type(x) == "table" then
		return pairs
	end
	error("expected table", 3)
end
local iteratee = function(x)
	if x == nil then
		return identity
	end
	if iscallable(x) then
		return x
	end
	if type(x) == "table" then
		return function(z)
			for k, v in pairs(x) do
				if z[k] ~= v then
					return false
				end
			end
			return true
		end
	end
	return function(z)
		return z[x]
	end
end
function lume.round(x, increment)
	if increment then
		return lume.round(x / increment) * increment
	end
	return 0 <= x and math_floor(x + 0.5) or math_ceil(x - 0.5)
end
function lume.pingpong(x)
	return 1 - math_abs(1 - x % 2)
end
function lume.angle(x1, y1, x2, y2)
	return math_atan2(y2 - y1, x2 - x1)
end
function lume.random(a, b)
	if not a then
		a, b = 0, 1
	end
	b = b or 0
	return a + math_random() * (b - a)
end
function lume.randomchoice(t)
	return t[math_random(#t)]
end
function lume.weightedchoice(t)
	local sum = 0
	for _, v in pairs(t) do
		assert(0 <= v, "weight value less than zero")
		sum = sum + v
	end
	assert(sum ~= 0, "all weights are zero")
	local rnd = lume.random(sum)
	for k, v in pairs(t) do
		if v > rnd then
			return k
		end
		rnd = rnd - v
	end
end
function lume.isarray(x)
	return type(x) == "table" and x[1] ~= nil and true or false
end
function lume.push(t, ...)
	local n = select("#", ...)
	for i = 1, n do
		t[#t + 1] = select(i, ...)
	end
	return ...
end
function lume.remove(t, x)
	local iter = getiter(t)
	for i, v in iter(t) do
		if v == x then
			if lume.isarray(t) then
				table.remove(t, i)
				break
			else
				t[i] = nil
				break
			end
		end
	end
	return x
end
function lume.clear(t)
	local iter = getiter(t)
	for k in iter(t) do
		t[k] = nil
	end
	return t
end
function lume.extend(t, ...)
	for i = 1, select("#", ...) do
		local x = select(i, ...)
		if x then
			for k, v in pairs(x) do
				t[k] = v
			end
		end
	end
	return t
end
function lume.shuffle(t)
	local math_random, rtn
	for i = 1, #t do
		local r = math_random(i)
		if r ~= i then
			rtn[i] = rtn[r]
		end
		rtn[r] = t[i]
	end
	return rtn
end
function lume.sort(t, comp)
	local rtn = lume.clone(t)
	if comp then
		if type(comp) == "string" then
			table.sort(rtn, function(a, b)
				return a[comp] < b[comp]
			end)
		else
			table.sort(rtn, comp)
		end
	else
		table.sort(rtn)
	end
	return rtn
end
function lume.array(...)
	local _UPVALUE0_, t
	for x in ... do
		t[#t + 1] = x
	end
	return t
end
function lume.each(t, fn, ...)
	local iter = getiter(t)
	if type(fn) == "string" then
		for _, v in iter(t) do
			v[fn](v, ...)
		end
	else
		for _, v in iter(t) do
			fn(v, ...)
		end
	end
	return t
end
function lume.map(t, fn)
	fn = iteratee(fn)
	local iter = getiter(t)
	local iteratee, rtn = t, t
	for k, v in iter(t) do
		rtn[k] = fn(v)
	end
	return rtn
end
function lume.all(t, fn)
	fn = iteratee(fn)
	local iter = getiter(t)
	for _, v in iter(t) do
		if not fn(v) then
			return false
		end
	end
	return true
end
function lume.any(t, fn)
	fn = iteratee(fn)
	local iter = getiter(t)
	for _, v in iter(t) do
		if fn(v) then
			return true
		end
	end
	return false
end
function lume.reduce(t, fn, first)
	local acc = first
	local started = first and true or false
	local iter = getiter(t)
	for _, v in iter(t) do
		if started then
			acc = fn(acc, v)
		else
			acc = v
			started = true
		end
	end
	assert(started, "reduce of an empty table with no first value")
	return acc
end
function lume.set(t)
	local pairs, rtn
	for k in pairs(lume.invert(t)) do
		rtn[#rtn + 1] = k
	end
	return rtn
end
function lume.filter(t, fn, retainkeys)
	fn = iteratee(fn)
	local iter = getiter(t)
	local iteratee, rtn = t, t
	if retainkeys then
		for k, v in iter(t) do
			if fn(v) then
				rtn[k] = v
			end
		end
	else
		for _, v in iter(t) do
			if fn(v) then
				rtn[#rtn + 1] = v
			end
		end
	end
	return rtn
end
function lume.reject(t, fn, retainkeys)
	fn = iteratee(fn)
	local iter = getiter(t)
	local iteratee, rtn = t, t
	if retainkeys then
		for k, v in iter(t) do
			if not fn(v) then
				rtn[k] = v
			end
		end
	else
		for _, v in iter(t) do
			if not fn(v) then
				rtn[#rtn + 1] = v
			end
		end
	end
	return rtn
end
function lume.merge(...)
	local _ENV, rtn
	for i = 1, select("#", ...) do
		local t = select(i, ...)
		local iter = getiter(t)
		for k, v in iter(t) do
			rtn[k] = v
		end
	end
	return rtn
end
function lume.concat(...)
	local _ENV, rtn
	for i = 1, select("#", ...) do
		local t = select(i, ...)
		if t ~= nil then
			local iter = getiter(t)
			for _, v in iter(t) do
				rtn[#rtn + 1] = v
			end
		end
	end
	return rtn
end
function lume.find(t, value)
	local iter = getiter(t)
	for k, v in iter(t) do
		if v == value then
			return k
		end
	end
	return nil
end
function lume.match(t, fn)
	fn = iteratee(fn)
	local iter = getiter(t)
	for k, v in iter(t) do
		if fn(v) then
			return v, k
		end
	end
	return nil
end
function lume.count(t, fn)
	local count = 0
	local iter = getiter(t)
	if fn then
		fn = iteratee(fn)
		for _, v in iter(t) do
			if fn(v) then
				count = count + 1
			end
		end
	else
		if lume.isarray(t) then
			return #t
		end
		for _ in iter(t) do
			count = count + 1
		end
	end
	return count
end
function lume.slice(t, i, j)
	i = i and absindex(#t, i) or 1
	j = j and absindex(#t, j) or #t
	local absindex, rtn = absindex(#t, j), absindex(#t, j)
	for x = i < 1 and 1 or i, j > #t and #t or j do
		rtn[#rtn + 1] = t[x]
	end
	return rtn
end
function lume.first(t, n)
	if not n then
		return t[1]
	end
	return lume.slice(t, 1, n)
end
function lume.last(t, n)
	if not n then
		return t[#t]
	end
	return lume.slice(t, -n, -1)
end
function lume.invert(t)
	local pairs, rtn
	for k, v in pairs(t) do
		rtn[v] = k
	end
	return rtn
end
function lume.pick(t, ...)
	local _ENV, rtn
	for i = 1, select("#", ...) do
		local k = select(i, ...)
		rtn[k] = t[k]
	end
	return rtn
end
function lume.keys(t)
	local getiter, rtn
	local iter = getiter(t)
	for k in iter(t) do
		rtn[#rtn + 1] = k
	end
	return rtn
end
function lume.clone(t)
	local pairs, rtn
	for k, v in pairs(t) do
		rtn[k] = v
	end
	return rtn
end
function lume.fn(fn, ...)
	assert(iscallable(fn), "expected a function as the first argument")
	assert = assert
	assert[1] = ...
	local assert[2], args = ...
	return function(...)
		lume = nil
		;(nil)[1] = ...
		local a = lume.concat(args, nil)
		return fn(unpack(a))
	end
end
function lume.once(fn, ...)
	local f = lume.fn(fn, ...)
	local done = false
	return function(...)
		if done then
			return
		end
		return f(...)
	end
end
local _ENV, memoize_fnkey = function(fn, ...)
	local f = lume.fn(fn, ...)
	local done = false
	return function(...)
		if done then
			return
		end
		return f(...)
	end
end, function(fn, ...)
	local f = lume.fn(fn, ...)
	local done = false
	return function(...)
		if done then
			return
		end
		return f(...)
	end
end
local _ENV, memoize_nil
function lume.memoize(fn)
	local _ENV, cache
	return function(...)
		local c = cache
		for i = 1, select("#", ...) do
			local a = select(i, ...) or memoize_nil
			if not c[a] then
				cache = c[a]
			end
			c[a] = c[a]
			c = c[a]
		end
		if not c[memoize_fnkey] then
			cache = c[memoize_fnkey]
			c[memoize_fnkey][1] = fn(...)
			c[memoize_fnkey][2] = fn(...)
			c[memoize_fnkey][3] = fn(...)
			c[memoize_fnkey][4] = fn(...)
			c[memoize_fnkey][5] = fn(...)
		end
		c[memoize_fnkey] = c[memoize_fnkey]
		return unpack(c[memoize_fnkey])
	end
end
function lume.combine(...)
	local n = select("#", ...)
	if n == 0 then
		return noop
	end
	if n == 1 then
		local fn = select(1, ...)
		if not fn then
			return noop
		end
		assert(iscallable(fn), "expected a function or nil")
		return fn
	end
	local _ENV, funcs = fn, select(1, ...)
	for i = 1, n do
		local fn = select(i, ...)
		if fn ~= nil then
			assert(iscallable(fn), "expected a function or nil")
			funcs[#funcs + 1] = fn
		end
	end
	return function(...)
		for _, f in ipairs(funcs) do
			f(...)
		end
	end
end
function lume.call(fn, ...)
	if fn then
		return fn(...)
	end
end
function lume.time(fn, ...)
	local start = os.clock()
	_ENV = nil
	;(nil)[1] = fn(...)
	;(nil)[2] = fn(...)
	local (nil)[3], rtn = fn(...)
	return os.clock() - start, unpack(rtn)
end
local _ENV, lambda_cache = function(fn, ...)
	local start = os.clock()
	_ENV = nil
	;(nil)[1] = fn(...)
	;(nil)[2] = fn(...)
	local (nil)[3], rtn = fn(...)
	return os.clock() - start, unpack(rtn)
end, function(fn, ...)
	local start = os.clock()
	_ENV = nil
	;(nil)[1] = fn(...)
	;(nil)[2] = fn(...)
	local (nil)[3], rtn = fn(...)
	return os.clock() - start, unpack(rtn)
end
function lume.lambda(str)
	if not lambda_cache[str] then
		local args, body = str:match("^([%w,_ ]-)%->(.-)$")
		assert(args and body, "bad string lambda")
		local s = "return function(" .. args .. [[
)
return ]] .. body .. [[

end]]
		lambda_cache[str] = lume.dostring(s)
	end
	return lambda_cache[str]
end
local serialize
_ENV = nil
;(nil).boolean = tostring
;(nil)["nil"] = tostring
;(nil).string = function(v)
	return string.format("%q", v)
end
;(nil).number = function(v)
	if v ~= v then
		return "0/0"
	elseif v == 1 / 0 then
		return "1/0"
	elseif v == -1 / 0 then
		return "-1/0"
	end
	return tostring(v)
end
local (nil).table, serialize_map = function(t, stk)
	if not stk then
		stk, _ENV = nil, nil
	end
	if stk[t] then
		error("circular reference")
	end
	local _ENV, rtn = error, error
	stk[t] = true
	for k, v in pairs(t) do
		rtn[#rtn + 1] = "[" .. serialize(k, stk) .. "]=" .. serialize(v, stk)
	end
	stk[t] = nil
	return "{" .. table.concat(rtn, ",") .. "}"
end, nil
_ENV = nil
;(nil).__index = function(_, k)
	error("unsupported serialize type: " .. k)
end
setmetatable(serialize_map, nil)
function serialize(x, stk)
	return serialize_map[type(x)](x, stk)
end
function lume.serialize(x)
	return serialize(x)
end
function lume.deserialize(str)
	return lume.dostring("return " .. str)
end
function lume.split(str, sep)
	if not sep then
		return lume.array(str:gmatch("([%S]+)"))
	else
		assert(sep ~= "", "empty separator")
		local psep = patternescape(sep)
		return lume.array((str .. sep):gmatch("(.-)(" .. psep .. ")"))
	end
end
function lume.trim(str, chars)
	if not chars then
		return str:match("^[%s]*(.-)[%s]*$")
	end
	chars = patternescape(chars)
	return str:match("^[" .. chars .. "]*(.-)[" .. chars .. "]*$")
end
function lume.wordwrap(str, limit)
	limit = limit or 72
	local check
	if type(limit) == "number" then
		function check(s)
			return #s >= limit
		end
	else
		check = limit
	end
	local type, rtn = function(s)
		return #s >= limit
	end, function(s)
		return #s >= limit
	end
	local line = ""
	for word, spaces in str:gmatch("(%S+)(%s*)") do
		local s = line .. word
		if check(s) then
			table.insert(rtn, line .. "\n")
			line = word
		else
			line = s
		end
		for c in spaces:gmatch(".") do
			if c == "\n" then
				table.insert(rtn, line .. "\n")
				line = ""
			else
				line = line .. c
			end
		end
	end
	table.insert(rtn, line)
	return table.concat(rtn)
end
function lume.format(str, vars)
	if not vars then
		return str
	end
	local f = function(x)
		return tostring(vars[x] or vars[tonumber(x)] or "{" .. x .. "}")
	end
	return (str:gsub("{(.-)}", f))
end
function lume.trace(...)
	local info = debug.getinfo(2, "Sl")
	type = 2
	local (2)[1], t = info.short_src .. ":" .. info.currentline .. ":", 2
	for i = 1, select("#", ...) do
		local x = select(i, ...)
		if type(x) == "number" then
			x = string.format("%g", lume.round(x, 0.01))
		end
		t[#t + 1] = tostring(x)
	end
	print(table.concat(t, " "))
end
function lume.dostring(str)
	return assert((loadstring or load)(str))()
end
function lume.uuid()
	local fn = function(x)
		local r = math_random(16) - 1
		r = x == "x" and r + 1 or r % 4 + 9
		return ("0123456789abcdef"):sub(r, r)
	end
	return (("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"):gsub("[xy]", fn))
end
function lume.hotswap(modname)
	local oldglobal = lume.clone(_G)
	local lume, updated = _G, _G
	local function update(old, new)
		if updated[old] then
			return
		end
		updated[old] = true
		local oldmt, newmt = getmetatable(old), getmetatable(new)
		if oldmt and newmt then
			update(oldmt, newmt)
		end
		for k, v in pairs(new) do
			if type(v) == "table" then
				update(old[k], v)
			else
				old[k] = v
			end
		end
	end
	local err
	local onerror = function(e)
		for k in pairs(_G) do
			_G[k] = oldglobal[k]
		end
	end
	local ok, oldmod = pcall(require, modname)
	oldmod = ok and oldmod or nil
	xpcall(function()
		package.loaded[modname] = nil
		local newmod = require(modname)
		if type(oldmod) == "table" then
			update(oldmod, newmod)
		end
		for k, v in pairs(oldglobal) do
			if v ~= _G[k] and type(v) == "table" then
				update(v, _G[k])
				_G[k] = v
			end
		end
	end, onerror)
	package.loaded[modname] = oldmod
	if err then
		return nil, err
	end
	return oldmod
end
local ripairs_iter = function(t, i)
	i = i - 1
	local v = t[i]
	if v then
		return i, v
	end
end
function lume.ripairs(t)
	return ripairs_iter, t, #t + 1
end
function lume.color(str, mul)
	mul = mul or 1
	local r, g, b, a
	r, g, b = str:match("#(%x%x)(%x%x)(%x%x)")
	if r then
		r = tonumber(r, 16) / 255
		g = tonumber(g, 16) / 255
		b = tonumber(b, 16) / 255
		a = 1
	elseif str:match("rgba?%s*%([%d%s%.,]+%)") then
		local f = str:gmatch("[%d.]+")
		r = (f() or 0) / 255
		g = (f() or 0) / 255
		b = (f() or 0) / 255
		a = f() or 1
	else
		error(("bad color string '%s'"):format(str))
	end
	return r * mul, g * mul, b * mul, a * mul
end
function lume.rgba(color)
	local a = math_floor(color / 16777216 % 256)
	local r = math_floor(color / 65536 % 256)
	local g = math_floor(color / 256 % 256)
	local b = math_floor(color % 256)
	return r, g, b, a
end
local _ENV, chain_mt = function(color)
	local a = math_floor(color / 16777216 % 256)
	local r = math_floor(color / 65536 % 256)
	local g = math_floor(color / 256 % 256)
	local b = math_floor(color % 256)
	return r, g, b, a
end, function(color)
	local a = math_floor(color / 16777216 % 256)
	local r = math_floor(color / 65536 % 256)
	local g = math_floor(color / 256 % 256)
	local b = math_floor(color % 256)
	return r, g, b, a
end
chain_mt.__index = lume.map(lume.filter(lume, iscallable, true), function(fn)
	return function(self, ...)
		self._value = fn(self._value, ...)
		return self
	end
end)
function chain_mt.__index.result(x)
	return x._value
end
function lume.chain(value)
	_ENV = nil
	;(nil)._value = value
	return setmetatable(nil, chain_mt)
end
function _ENV(fn)
	return function(self, ...)
		self._value = fn(self._value, ...)
		return self
	end
end
;(function(fn)
	return function(self, ...)
		self._value = fn(self._value, ...)
		return self
	end
end).__call = function(_, ...)
	return lume.chain(...)
end
setmetatable(lume, function(fn)
	return function(self, ...)
		self._value = fn(self._value, ...)
		return self
	end
end)
return lume

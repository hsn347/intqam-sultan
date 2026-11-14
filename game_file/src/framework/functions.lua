function printf(fmt, ...)
	print(string.format(tostring(fmt), ...))
end
function checknumber(value, base)
	return tonumber(value, base) or 0
end
function checkint(value)
	return math.round(checknumber(value))
end
function checkbool(value)
	return value ~= nil and value ~= false
end
function checktable(value)
	if type(value) ~= "table" then
		value, _ENV = type(value), type(value)
	end
	return value
end
function isset(hashtable, key)
	local t = type(hashtable)
	return (t == "table" or t == "userdata") and hashtable[key] ~= nil
end
function clone(object, skipMeta)
	local _ENV, lookup_table
	local function _copy(object, _skipMeta)
		local _skipMeta = _skipMeta or false
		if type(object) ~= "table" then
			return object
		elseif lookup_table[object] then
			return lookup_table[object]
		end
		local _ENV, new_table = lookup_table[object], lookup_table[object]
		lookup_table[object] = new_table
		for key, value in pairs(object) do
			new_table[_copy(key, skipMeta)] = _copy(value, skipMeta)
		end
		if _skipMeta then
			return new_table
		else
			return setmetatable(new_table, getmetatable(object))
		end
	end
	return _copy(object, skipMeta)
end
local iskindof_
function iskindof_(cls, name)
	local __index = rawget(cls, "__index")
	if type(__index) == "table" and rawget(__index, "__cname") == name then
		return true
	end
	if rawget(cls, "__cname") == name then
		return true
	end
	local __supers = rawget(cls, "__supers")
	if not __supers then
		return false
	end
	for _, super in ipairs(__supers) do
		if iskindof_(super, name) then
			return true
		end
	end
	return false
end
function iskindof(obj, classname)
	local t = type(obj)
	local mt
	if t == "table" then
		mt = getmetatable(obj)
	elseif t == "userdata" then
		mt = tolua.getpeer(obj)
	end
	if mt then
		return iskindof_(mt, classname)
	end
	return false
end
function requireLocal(moduleName, currentModuleName)
	local currentModuleNameParts
	local moduleFullName = moduleName
	local offset = 1
	while true do
		if string.byte(moduleName, offset) ~= 46 then
			moduleFullName = string.sub(moduleName, offset)
			if currentModuleNameParts and 0 < #currentModuleNameParts then
				moduleFullName = table.concat(currentModuleNameParts, ".") .. "." .. moduleFullName
			end
			break
		end
		offset = offset + 1
		if not currentModuleNameParts then
			if not currentModuleName then
				local n, v = debug.getlocal(3, 1)
				currentModuleName = v
			end
			currentModuleNameParts = string.split(currentModuleName, ".")
		end
		table.remove(currentModuleNameParts, #currentModuleNameParts)
	end
	return require(moduleFullName)
end
function handler(obj, method)
	if nil == method then
		if device.platform == "mac" then
			assert(false, "method is nil")
		end
		return function(...)
		end
	end
	return function(...)
		return method(obj, ...)
	end
end
function handlerEx(obj, method, ...)
	local str = ""
	_ENV = nil
	local (nil)[1], newArgs = ...
	return function(...)
		obj = nil
		;(nil)[1] = ...
		;(nil)[2] = ...
		;(nil)[3] = ...
		;(nil)[4] = ...
		;(nil)[5] = ...
		;(nil)[6] = ...
		;(nil)[7] = ...
		local (nil)[8], arg = ...
		local obj, outArgs = ...
		local curName = 1
		outArgs[curName] = obj
		curName = 2
		for i, v in ipairs(newArgs) do
			outArgs[curName] = v
			curName = curName + 1
		end
		for i, v in ipairs(arg) do
			outArgs[curName] = v
			curName = curName + 1
		end
		return method(unpack(outArgs))
	end
end
function math.newrandomseed()
	local ok, socket = pcall(function()
		return require("socket")
	end)
	if ok then
		math.randomseed(socket.gettime() * 1000)
	else
		math.randomseed(os.time())
	end
	math.random()
	math.random()
	math.random()
	math.random()
end
function math.round(value)
	value = checknumber(value)
	return math.floor(value + 0.5)
end
function math.angle2radian(angle)
	return angle * math.pi / 180
end
function math.radian2angle(radian)
	return radian / math.pi * 180
end
function math.clamp(x, min, max)
	return math.min(max, math.max(min, x))
end
local _random = math.random
function math.random(m, n)
	if n then
		n = math.floor(n)
		return _random(m, n)
	elseif m then
		m = math.floor(m)
		return _random(m)
	else
		return _random()
	end
end
function io.exists(path)
	local file = io.open(path, "r")
	if file then
		io.close(file)
		return true
	end
	return false
end
function io.readfile(path)
	local file = io.open(path, "r")
	if file then
		local content = file:read("*a")
		io.close(file)
		return content
	end
	return nil
end
function io.writefile(path, content, mode)
	mode = mode or "w+b"
	local file = io.open(path, mode)
	if file then
		if file:write(content) == nil then
			return false
		end
		io.close(file)
		return true
	else
		return false
	end
end
function io.pathinfo(path)
	local pos = string.len(path)
	local extpos = pos + 1
	while 0 < pos do
		local b = string.byte(path, pos)
		if b == 46 then
			extpos = pos
		elseif b == 47 then
			break
		end
		pos = pos - 1
	end
	local dirname = string.sub(path, 1, pos)
	local filename = string.sub(path, pos + 1)
	extpos = extpos - pos
	local basename = string.sub(filename, 1, extpos - 1)
	local extname = string.sub(filename, extpos)
	_ENV = filename
	filename.dirname = dirname
	filename.filename = filename
	filename.basename = basename
	filename.extname = extname
	return filename
end
function io.filesize(path)
	local size = false
	local file = io.open(path, "r")
	if file then
		local current = file:seek()
		size = file:seek("end")
		file:seek("set", current)
		io.close(file)
	end
	return size
end
function table.nums(t)
	local count = 0
	for k, v in pairs(t) do
		count = count + 1
	end
	return count
end
function table.keys(hashtable)
	local _ENV, keys
	for k, v in pairs(hashtable) do
		keys[#keys + 1] = k
	end
	return keys
end
function table.ikeys(array)
	local _ENV, keys
	for i, v in ipairs(array) do
		keys[#keys + 1] = i
	end
	return keys
end
function table.values(hashtable)
	local _ENV, values
	for k, v in pairs(hashtable) do
		values[#values + 1] = v
	end
	return values
end
if _G.MClass and _G.MClass.tableNew then
	table.new = _G.MClass.tableNew
else
	function table.new(narr, nrec)
		_UPVALUE0_ = nil
		return nil
	end
end
function table.merge(dest, src)
	for k, v in pairs(src) do
		dest[k] = v
	end
end
function table.easymerge(fillTbl, dest, src)
	if fillTbl and src then
		for k, v in pairs(src) do
			fillTbl[k] = v
		end
		for k, v in pairs(dest) do
			fillTbl[k] = v
		end
		return fillTbl
	else
		return dest
	end
end
function table.insertto(dest, src, begin)
	begin = checkint(begin)
	if begin <= 0 then
		begin = #dest + 1
	end
	local len = #src
	for i = 0, len - 1 do
		dest[i + begin] = src[i + 1]
	end
end
function table.indexof(array, value, begin)
	for i = begin or 1, #array do
		if array[i] == value then
			return i
		end
	end
	return false
end
function table.keyof(hashtable, value)
	for k, v in pairs(hashtable) do
		if v == value then
			return k
		end
	end
	return nil
end
function table.removebyvalue(array, value, removeall)
	local c, i, max = 0, 1, #array
	while i <= max do
		if array[i] == value then
			table.remove(array, i)
			c = c + 1
			i = i - 1
			max = max - 1
			if not removeall then
				break
			end
		end
		i = i + 1
	end
	return c
end
function table.map(t, fn)
	for k, v in pairs(t) do
		t[k] = fn(v, k)
	end
end
function table.walk(t, fn)
	for k, v in pairs(t) do
		fn(v, k)
	end
end
function table.filter(t, fn)
	for k, v in pairs(t) do
		if not fn(v, k) then
			t[k] = nil
		end
	end
end
function table.unique(t, bArray)
	local _ENV, check
	local _ENV, n
	local idx = 1
	for k, v in pairs(t) do
		if not check[v] then
			if bArray then
				n[idx] = v
				idx = idx + 1
			else
				n[k] = v
			end
			check[v] = true
		end
	end
	return n
end
function _ENV(t, bArray)
	local _ENV, check
	local _ENV, n
	local idx = 1
	for k, v in pairs(t) do
		if not check[v] then
			if bArray then
				n[idx] = v
				idx = idx + 1
			else
				n[k] = v
			end
			check[v] = true
		end
	end
	return n
end
;(function(t, bArray)
	local _ENV, check
	local _ENV, n
	local idx = 1
	for k, v in pairs(t) do
		if not check[v] then
			if bArray then
				n[idx] = v
				idx = idx + 1
			else
				n[k] = v
			end
			check[v] = true
		end
	end
	return n
end)["&"] = "&amp;"
;(function(t, bArray)
	local _ENV, check
	local _ENV, n
	local idx = 1
	for k, v in pairs(t) do
		if not check[v] then
			if bArray then
				n[idx] = v
				idx = idx + 1
			else
				n[k] = v
			end
			check[v] = true
		end
	end
	return n
end)["\""] = "&quot;"
;(function(t, bArray)
	local _ENV, check
	local _ENV, n
	local idx = 1
	for k, v in pairs(t) do
		if not check[v] then
			if bArray then
				n[idx] = v
				idx = idx + 1
			else
				n[k] = v
			end
			check[v] = true
		end
	end
	return n
end)["'"] = "&#039;"
;(function(t, bArray)
	local _ENV, check
	local _ENV, n
	local idx = 1
	for k, v in pairs(t) do
		if not check[v] then
			if bArray then
				n[idx] = v
				idx = idx + 1
			else
				n[k] = v
			end
			check[v] = true
		end
	end
	return n
end)["<"] = "&lt;"
;(function(t, bArray)
	local _ENV, check
	local _ENV, n
	local idx = 1
	for k, v in pairs(t) do
		if not check[v] then
			if bArray then
				n[idx] = v
				idx = idx + 1
			else
				n[k] = v
			end
			check[v] = true
		end
	end
	return n
end)[">"] = "&gt;"
;(function(t, bArray)
	local _ENV, check
	local _ENV, n
	local idx = 1
	for k, v in pairs(t) do
		if not check[v] then
			if bArray then
				n[idx] = v
				idx = idx + 1
			else
				n[k] = v
			end
			check[v] = true
		end
	end
	return n
end)["["] = "&#91;"
string._htmlspecialchars_set, (function(t, bArray)
	local _ENV, check
	local _ENV, n
	local idx = 1
	for k, v in pairs(t) do
		if not check[v] then
			if bArray then
				n[idx] = v
				idx = idx + 1
			else
				n[k] = v
			end
			check[v] = true
		end
	end
	return n
end)["]"] = function(t, bArray)
	local _ENV, check
	local _ENV, n
	local idx = 1
	for k, v in pairs(t) do
		if not check[v] then
			if bArray then
				n[idx] = v
				idx = idx + 1
			else
				n[k] = v
			end
			check[v] = true
		end
	end
	return n
end, "&#93;"
string._htmlspecialchars_set_keys_pattern = "([&<>'\"%[%]])"
function string.htmlspecialchars(input)
	input = string.gsub(input, string._htmlspecialchars_set_keys_pattern, string._htmlspecialchars_set)
	return input
end
function string.restorehtmlspecialchars(input)
	for k, v in pairs(string._htmlspecialchars_set) do
		input = string.gsub(input, v, k)
	end
	return input
end
function string.nl2br(input)
	return string.gsub(input, "\n", "<br />")
end
function string.text2html(input)
	input = string.gsub(input, "\t", "    ")
	input = string.htmlspecialchars(input)
	input = string.gsub(input, " ", "&nbsp;")
	input = string.nl2br(input)
	return input
end
function string.split(input, delimiter)
	input = tostring(input)
	delimiter = tostring(delimiter)
	if delimiter == "" then
		return false
	end
	local _ENV, pos, arr = delimiter, 0, delimiter
	for st, sp in function()
		return string.find(input, delimiter, pos, true)
	end, nil, nil do
		table.insert(arr, string.sub(input, pos, st - 1))
		pos = sp + 1
	end
	table.insert(arr, string.sub(input, pos))
	return arr
end
function string.ltrim(input)
	return string.gsub(input, "^[ \t\n\r]+", "")
end
function string.rtrim(input)
	return string.gsub(input, "[ \t\n\r]+$", "")
end
function string.trim(input)
	input = string.gsub(input, "^[ \t\n\r]+", "")
	return string.gsub(input, "[ \t\n\r]+$", "")
end
function string.ucfirst(input)
	return string.upper(string.sub(input, 1, 1)) .. string.sub(input, 2)
end
local urlencodechar = function(char)
	return "%" .. string.format("%02X", string.byte(char))
end
function string.urlencode(input)
	input = string.gsub(tostring(input), "\n", "\r\n")
	input = string.gsub(input, "([^%w%.%- ])", urlencodechar)
	return string.gsub(input, " ", "+")
end
function string.urldecode(input)
	input = string.gsub(input, "+", " ")
	input = string.gsub(input, "%%(%x%x)", function(h)
		return string.char(checknumber(h, 16))
	end)
	input = string.gsub(input, "\r\n", "\n")
	return input
end
function string.utf8len(input)
	local len = string.len(input)
	local left = len
	local cnt = 0
	_UPVALUE6_ = nil
	;(nil)[1] = 0
	;(nil)[2] = 192
	;(nil)[3] = 224
	;(nil)[4] = 240
	;(nil)[5] = 248
	local (nil)[6], arr = 252, nil
	while 0 < left do
		local tmp = string.byte(input, -left)
		local i = #arr
		while arr[i] do
			if tmp >= arr[i] then
				left = left - i
				break
			end
			i = i - 1
		end
		cnt = cnt + 1
	end
	return cnt
end
function string.utf16len(input)
	local len = string.len(input)
	local left = len
	local cnt = 0
	_UPVALUE6_ = nil
	;(nil)[1] = 0
	;(nil)[2] = 192
	;(nil)[3] = 224
	;(nil)[4] = 240
	;(nil)[5] = 248
	local (nil)[6], arr = 252, nil
	while 0 < left do
		local tmp = string.byte(input, -left)
		local i = #arr
		while arr[i] do
			if tmp >= arr[i] then
				left = left - i
				break
			end
			i = i - 1
		end
		if 4 <= i then
			cnt = cnt + 2
		else
			cnt = cnt + 1
		end
	end
	return cnt
end
function string.formatnumberthousands(num)
	local formatted = tostring(checknumber(num))
	local k
	while true do
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1,%2")
		if k == 0 then
			break
		end
	end
	return formatted
end

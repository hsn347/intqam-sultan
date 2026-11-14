if not util then
	_ENV = util
end
util = util
local TAG = "[fw.util]"
local type = type
local ipairs = ipairs
local pairs = pairs
local error = error
local loadstring = loadstring
local tostring = tostring
local tonumber = tonumber
local rawset = rawset
local rawget = rawget
local setmetatable = setmetatable
local string_lower = string.lower
local string_find = string.find
local string_sub = string.sub
local string_match = string.match
local string_format = string.format
local string_len = string.len
local string_split = string.split
local math_random = math.random
local table_insert = table.insert
local table_remove = table.remove
local table_sort = table.sort
local table_nums = table.nums
local lfs = require("lfs")
function try(f, catch_f, finally_f)
	local throw_err
	local catch_err = function(err)
	end
	local ok, result = xpcall(f, catch_err)
	if ok then
		if finally_f then
			finally_f()
		end
		return result
	elseif throw_err then
		error(throw_err)
	end
end
function isnil(v)
	return v == nil
end
local isnil = isnil
function isnotnil(v)
	return v ~= nil
end
local isnotnil = isnotnil
function iff(cond, trueValue, falseValue)
	if cond then
		return trueValue
	else
		return falseValue
	end
end
function ifnil(v, default)
	if isnil(v) then
		return default
	else
		return v
	end
end
function isnumber(v)
	return type(v) == "number"
end
local isnumber = isnumber
function isstring(v)
	return type(v) == "string"
end
local isstring = isstring
function isboolean(v)
	return type(v) == "boolean"
end
local isboolean = isboolean
function istable(v)
	return type(v) == "table"
end
local istable = istable
function isfunction(v)
	return type(v) == "function"
end
local isfunction = isfunction
function util.callFun(fn, ...)
	_ENV = nil
	local (nil)[1], args = ...
	return function()
		fn(unpack(args))
	end
end
function util.copyfile(src, dest, overwrite)
	Log.a(io.exists(src), TAG, "copyFile() src file %s is not exist.", src)
	if io.exists(dest) then
		Log.w(TAG, "copyFile() dest file %s is exist.", dest)
		if not ifnil(overwrite, true) then
			return false
		end
	end
	local inputFile = io.open(src, "rb")
	if inputFile then
		local content = inputFile:read("*all")
		io.close(inputFile)
		io.mkdir(dest)
		local outputFile = io.open(dest, "wb")
		if outputFile then
			local result = outputFile:write(content) ~= nil
			io.close(outputFile)
			return result
		end
	end
	return false
end
io.copyfile = util.copyfile
function io.mkdir(dirpath)
	local pathInfo = io.pathinfo(dirpath)
	if "" ~= pathInfo.extname then
		dirpath = pathInfo.dirname
	end
	local function mkdir_(path)
		if not io.exists(path) then
			if string_find(path, "/$") then
				path = string_sub(path, 1, -2)
			end
			path = string_match(path, ".+/")
			mkdir_(path)
			return lfs.mkdir(path)
		end
		return false
	end
	mkdir_(dirpath)
	return lfs.mkdir(dirpath)
end
os.mkdir = io.mkdir
function io.remove(fullPath)
	os.execute("rm -r -f \"" .. fullPath .. "\"")
end
function os.rmdir(path)
	if os.exists(path) then
		local function _rmdir(path)
			local iter, dir_obj = lfs.dir(path)
			while true do
				local dir = iter(dir_obj)
				if dir == nil then
					break
				end
				if dir ~= "." and dir ~= ".." then
					local curDir = path .. dir
					local mode = lfs.attributes(curDir, "mode")
					if mode == "directory" then
						_rmdir(curDir .. "/")
					elseif mode == "file" then
						os.remove(curDir)
					end
				end
			end
			local succ, des = os.remove(path)
			return succ
		end
		_rmdir(path)
	end
	return true
end
function os.dir(rootpath, recursion, match, count, paths)
	if not paths then
		paths, lfs = nil, nil
	end
	for entry in lfs.dir(rootpath) do
		if entry ~= "." and entry ~= ".." and not string.startwith(entry, "%.") then
			local path
			if string_find(rootpath, "/$") then
				path = rootpath .. entry
			else
				path = rootpath .. device.directorySeparator .. entry
			end
			local attr = lfs.attributes(path)
			assert(type(attr) == "table")
			if recursion and attr.mode == "directory" then
				os.dir(path, recursion, match, count, paths)
			elseif match then
				if (not count or count > #paths) and string_find(path, match) then
					table_insert(paths, path)
				end
			else
				table_insert(paths, path)
			end
		end
	end
	return paths
end
do
	local ok, socket = pcall(function()
		return require("socket")
	end)
	local getTimestamp_
	if ok then
		function getTimestamp_()
			return socket:gettime()
		end
		util.sleep = socket.sleep
	else
		function getTimestamp_()
			return os.time()
		end
	end
	util.gettime = getTimestamp_
end
function table.compare(t1, t2)
	if t1 == t2 then
		return true
	end
	if table_nums(t1) ~= table_nums(t2) then
		return false
	end
	for k, v in pairs(t1) do
		local v2 = t2[k]
		if type(v) == "table" and type(v2) == "table" then
			if not table.compare(v, v2) then
				return false
			end
		elseif v ~= v2 then
			return false
		end
	end
	return true
end
function table.slice(t, start, count)
	local istable, result
	if not istable(t) or not isnumber(start) then
		return result
	end
	count = count or #t
	local endIndex = start + count - 1
	if endIndex > #t then
		endIndex = #t
	end
	if t and start <= endIndex then
		for i = start, endIndex do
			result[#result + 1] = t[i]
		end
	end
	return result
end
function table.removeAll(t)
	for k, v in pairs(t) do
		t[k] = nil
	end
end
function table.reverse(t)
	local ipairs, result
	local count = #t
	for i, v in ipairs(t) do
		result[i] = t[count + 1 - i]
	end
	return result
end
function table.isnotempty(t)
	local result = false
	if istable(t) then
		for k, v in pairs(t) do
			result = true
			break
		end
	end
	return result
end
function table.isempty(t)
	return not table.isnotempty(t)
end
function table.merge(dest, src)
	local function merge_(dest, src)
		for k, v in pairs(src) do
			if istable(v) then
				if dest[k] == nil then
					dest[k], pairs = dest[k], dest[k]
				end
				merge_(dest[k], v)
			else
				dest[k] = v
			end
		end
	end
	merge_(dest, src)
	return dest
end
function table.pickupkv(t, keyname, valuename)
	local _ENV, result
	if table.isnotempty(t) then
		for i, v in ipairs(t) do
			if istable(v) and v[keyname] and v[valuename] then
				result[v[keyname]] = v[valuename]
			end
		end
	end
	return result
end
function table.replaceSameKey(src, dest)
	if table.isnotempty(src) and table.isnotempty(dest) then
		for k, v in pairs(dest) do
			if src[k] then
				src[k] = dest[k]
			end
		end
	end
	return src
end
function table.getByPath(t, path)
	if not path then
		return t
	elseif string_find(path, "%.") then
		local paths = string.split(path, ".")
		local cur = t
		local hasN = string.find(path, "%[") ~= nil
		for i, keyname in ipairs(paths) do
			local v
			if hasN then
				local n = tonumber(string.match(keyname, "^%[(.+)%]$"))
				if n then
					v = cur[n]
				end
			end
			v = v or cur[keyname]
			if v then
				cur = v
			else
				return nil
			end
		end
		return cur
	else
		return t[path]
	end
end
function table.setByPath(t, path, value)
	if not path then
		t = value
	elseif string_find(path, "%.") then
		local paths = string.split(path, ".")
		local cur = t
		local count = #paths
		local hasN = string.find(path, "%[") ~= nil
		for i = 1, count - 1 do
			local keyname = paths[i]
			local v
			if hasN then
				local n = tonumber(string.match(keyname, "^%[(.+)%]$"))
				if n then
					v = cur[n]
					keyname = n
				end
			end
			v = v or cur[keyname]
			if v then
				cur = v
			else
				cur[keyname], string_find = tonumber(string.match(keyname, "^%[(.+)%]$")), tonumber(string.match(keyname, "^%[(.+)%]$"))
				cur = cur[keyname]
			end
		end
		local lastKeyname = paths[count]
		lastKeyname = hasN and tonumber(string.match(lastKeyname, "^%[(.+)%]$")) or lastKeyname
		cur[lastKeyname] = value
	else
		t[path] = value
	end
end
function table.monitor_(tb, callback, path)
	local type, data = nil, tb or nil
	local subpath = path
	local createKey = function(key)
		if "number" == type(key) then
			return "[" .. key .. "]"
		else
			return key
		end
	end
	type = nil
	;(nil).__index = function(t, k)
		local v = rawget(t, k)
		if v then
			return v
		else
			if "__ismonitor__" == k then
				return true
			end
			local result = data[k]
			if type(result) == "table" then
				local newMonitor = table.monitor_(result, callback, subpath and subpath .. "." .. createKey(k) or createKey(k))
				rawset(t, k, newMonitor)
				return newMonitor
			else
				return result
			end
		end
	end
	;(nil).__newindex = function(t, k, v)
		local oldValue = data[k]
		if oldValue ~= v then
			data[k] = v
			if callback and not istable(v) then
				callback(subpath and subpath .. "." .. createKey(k) or createKey(k), v, oldValue)
			end
		end
	end
	local (nil).__call, mt = function(t, k, v)
		if "[path]" == k then
			return subpath
		elseif "string" == type(k) then
			if v then
				table.setByPath(t, k, v)
			else
				return table.getByPath(t, k)
			end
		else
			return data
		end
	end, nil
	type = nil
	return setmetatable(nil, mt)
end
function table.monitor(tb, callback, path)
	local _ENV, callbacks
	if callback then
		callbacks[#callbacks + 1] = callback
	end
	local addCallback = function(self, cb)
		callbacks[#callbacks + 1] = cb
	end
	local removeCallback = function(self, cb)
		table.removebyvalue(callbacks, cb, true)
	end
	local cb = function(path, value, oldValue)
		for k, listener in pairs(callbacks) do
			listener(path, value, oldValue)
		end
	end
	local result = table.monitor_(tb, cb, path)
	local mt = getmetatable(result)
	local index_fn = mt.__index
	function mt.__index(t, k)
		if k == "addCallback" then
			return addCallback
		elseif k == "removeCallback" then
			return removeCallback
		else
			return index_fn(t, k)
		end
	end
	setmetatable(result, mt)
	return result
end
local function diffWithGroup_(dest, src, temp_add, temp_modify, temp_delete, ignorDelete)
	for k, v in pairs(src) do
		if istable(v) and istable(dest[k]) then
			temp_add[k], temp_modify[k], temp_delete[k], pairs, pairs, pairs = istable(dest[k]), dest[k], nil, nil, dest[k], istable(dest[k])
			diffWithGroup_(dest[k], src[k], temp_add[k], temp_modify[k], temp_delete[k], ignorDelete)
		elseif dest[k] == nil then
			temp_add[k] = v
		elseif dest[k] ~= v then
			temp_modify[k] = v
		end
	end
	if not ignorDelete then
		for k, v in pairs(dest) do
			if istable(v) and istable(src[k]) then
				if not temp_add[k] then
					pairs = temp_add[k]
				end
				if not temp_modify[k] then
					pairs = temp_modify[k]
				end
				if not temp_delete[k] then
					pairs = temp_delete[k]
				end
				temp_add[k], temp_modify[k], temp_delete[k] = temp_add[k], temp_modify[k], temp_delete[k]
				diffWithGroup_(dest[k], src[k], temp_add[k], temp_modify[k], temp_delete[k], ignorDelete)
			elseif src[k] == nil then
				temp_delete[k] = v
			end
		end
	end
end
local function diff_(dest, src, temp)
	for k, v in pairs(src) do
		if istable(v) and istable(dest[k]) then
			temp[k], pairs = istable(dest[k]), istable(dest[k])
			diff_(dest[k], src[k], temp[k])
		else
			temp[k] = v
		end
	end
end
function table.diff(dest, src, group, ignorDelete)
	local result
	if group then
		result, (nil).delete, diffWithGroup_, (nil).modify, diffWithGroup_, (nil).add, diffWithGroup_, diffWithGroup_ = nil, nil, nil, nil, nil, nil, nil, nil
		diffWithGroup_(dest, src, result.add, result.modify, result.delete, ignorDelete)
	else
		result, diffWithGroup_ = diffWithGroup_, diffWithGroup_
		diff_(dest, src, result)
	end
	return table.removeEmpty(result)
end
local TableStream = requireLocal(".TableStream")
function table.stream(t)
	return TableStream.new(t)
end
function table.randomset(t, num, stilltable)
	num = num or 1
	local result = t
	if istable(t) and isnumber(num) and num < #t then
		result, istable = #t, #t
		if num < #t then
			local istable, tt = #t, #t
			for k, v in pairs(t) do
				tt[k] = v
			end
			local count = #tt + 1
			for i = 1, num do
				local index = math_random(1, count - i)
				table_insert(result, tt[index])
				table_remove(tt, index)
			end
		elseif num > #t then
			local count = #t
			for i = 1, num do
				table_insert(result, t[math_random(1, count)])
			end
		end
	end
	if not stilltable and num == 1 and result and #result == 1 then
		result = result[1]
	end
	return result
end
local deepcopy = function(object)
	local type, lookup_table
	local function _copy(object)
		if type(object) ~= "table" then
			return object
		elseif lookup_table[object] then
			return lookup_table[object]
		end
		local type, new_table = lookup_table[object], lookup_table[object]
		lookup_table[object] = new_table
		for key, value in pairs(object) do
			new_table[_copy(key)] = _copy(value)
		end
		return setmetatable(new_table, getmetatable(object))
	end
	return _copy(object)
end
function string.startwith(str, startStr, ignorCase)
	if isstring(str) and isstring(startStr) then
		if ignorCase == true then
			str = string_lower(str)
			startStr = string_lower(startStr)
		end
		return string_find(str, "^" .. startStr) ~= nil
	else
		return false
	end
end
function string.endwith(str, endStr, ignorCase)
	if isstring(str) and isstring(endStr) then
		if ignorCase == true then
			str = string_lower(str)
			startStr = string_lower(startStr)
		end
		return string_find(str, endStr .. "$") ~= nil
	else
		return false
	end
end
function string.lcfirst(str)
	return string_lower(string_sub(str, 1, 1)) .. string_sub(str, 2)
end
function string.splitlast(str, sp)
	return string_match(str, string_format("(.+)%s(.+)", sp))
end
function string.findlast(str, subStr)
	local startIndex, length = nil, string_len(subStr)
	local i = 1
	while true do
		local index, len = string_find(str, subStr, i)
		if not index then
			break
		end
		startIndex = index
		i = index + length
	end
	local endIndex
	if startIndex then
		endIndex = startIndex + length - 1
	end
	return startIndex, endIndex
end
function string.isalnum(str)
	if not str then
		return nil
	end
	local len = string_len(str)
	for i = 1, len do
		local ch = string_sub(str, i, i)
		if (not ("a" <= ch) or not (ch <= "z")) and (not ("A" <= ch) or not (ch <= "Z")) and (not ("0" <= ch) or not (ch <= "9")) then
			return false
		end
	end
	return true
end
local createLog = function(logType, tag, fmt, ...)
	return string_format("[LUA:%s]%s %s", logType, tag, string_format(fmt, ...))
end
local containsTag = function(tag)
	if not (LOG_TAGS and istable(LOG_TAGS)) or #LOG_TAGS == 0 then
		return true
	end
	for i, v in ipairs(LOG_TAGS) do
		if string_find(tag, v) then
			return true
		end
	end
	return false
end
if type(LOG_LEVEL) ~= "number" then
	LOG_LEVEL = 0
end
Log, _ENV = type(LOG_LEVEL), type(LOG_LEVEL)
local emptyFunction = function()
end
Log.d = emptyFunction
Log.d_CCArray = emptyFunction
Log.i = emptyFunction
Log.w = emptyFunction
if LOG_LEVEL >= 3 then
	function Log.d(TAG, fmt, ...)
		if containsTag(TAG) then
			print(createLog("DEBUG", TAG, fmt, ...))
		end
	end
	function Log.d_CCArray(TAG, ccarray, callback, fmt, ...)
		if containsTag(TAG) then
			Log.d(TAG, fmt, ...)
			print("============CCARRAY============")
			for i = 0, ccarray:count() - 1 do
				local obj = ccarray:objectAtIndex(i)
				local str
				if callback then
					str = callback(obj)
				else
					local node = util.toCCNode(obj)
					str = node:getTag()
				end
				print("[" .. i .. "]", str)
			end
			print("===============================")
		end
	end
end
if LOG_LEVEL >= 1 and LOG_LEVEL ~= 4 then
	function Log.i(TAG, fmt, ...)
		if containsTag(TAG) then
			print(createLog("INFO", TAG, fmt, ...))
		end
	end
end
if LOG_LEVEL >= 2 and LOG_LEVEL ~= 4 then
	function Log.w(TAG, fmt, ...)
		if containsTag(TAG) then
			print(createLog("WARNING", TAG, fmt, ...))
		end
	end
end
function Log.e(TAG, fmt, ...)
	assert(nil, createLog("ERROR", TAG, fmt, ...))
	print(debug.traceback("", 2))
end
function Log.a(cond, TAG, fmt, ...)
	assert(cond, createLog("ERROR", TAG, fmt, ...))
end
function util.checkParams(TAG, methodName, params)
	for i = 1, #params do
		local p = params[i]
		local cond, info = p[1], p[2]
		if not cond then
			if not info then
				info = " invalid params"
			else
				info = " invalid params " .. info
			end
			info = methodName .. info
			Log.a(cond, TAG, info)
		end
	end
end
util.langStrings, _ENV = function(TAG, methodName, params)
	for i = 1, #params do
		local p = params[i]
		local cond, info = p[1], p[2]
		if not cond then
			if not info then
				info = " invalid params"
			else
				info = " invalid params " .. info
			end
			info = methodName .. info
			Log.a(cond, TAG, info)
		end
	end
end, function(TAG, methodName, params)
	for i = 1, #params do
		local p = params[i]
		local cond, info = p[1], p[2]
		if not cond then
			if not info then
				info = " invalid params"
			else
				info = " invalid params " .. info
			end
			info = methodName .. info
			Log.a(cond, TAG, info)
		end
	end
end
function util.loadLanguage(fileRequirePath, language, default)
	if fileRequirePath then
		language = language or device.language
		xpcall(function(...)
			util.langStrings = require(fileRequirePath .. "_" .. language)
		end, function(...)
			util.langStrings = require(fileRequirePath .. (default or "_default"))
		end)
	end
end
function _s(key, ...)
	if isnumber(key) then
		key = tostring(key)
	end
	local result = util.langStrings[key] or key
	if not (...) then
		return result
	else
		return string_format(result, ...)
	end
end
function vardump(object, label)
	local type, lookupTable
	local type, result
	local _v = function(v)
		if type(v) == "string" then
			v = "\"" .. v .. "\""
		end
		return tostring(v)
	end
	local function _vardump(object, label, indent, nest)
		label = label or "<var>"
		local postfix = ""
		if 1 < nest then
			postfix = ","
		end
		if type(object) ~= "table" then
			if type(label) == "string" then
				result[#result + 1] = string_format("%s%s = %s%s", indent, label, _v(object), postfix)
			else
				result[#result + 1] = string_format("%s%s%s", indent, _v(object), postfix)
			end
		elseif not lookupTable[object] then
			lookupTable[object] = true
			if type(label) == "string" then
				result[#result + 1] = string_format("%s%s = {", indent, label)
			else
				result[#result + 1] = string_format("%s{", indent)
			end
			local indent2 = indent .. "    "
			local type, keys = "    ", "    "
			local type, values = "%s{", "%s{"
			for k, v in pairs(object) do
				keys[#keys + 1] = k
				values[k] = v
			end
			table_sort(keys, function(a, b)
				if type(a) == "number" and type(b) == "number" then
					return a < b
				else
					return tostring(a) < tostring(b)
				end
			end)
			for i, k in ipairs(keys) do
				_vardump(values[k], k, indent2, nest + 1)
			end
			result[#result + 1] = string_format("%s}%s", indent, postfix)
		end
	end
	_vardump(object, label, "", 1)
	return result
end
local function util_filter_(fun, index, params, results)
	local data = params[index]
	if not data then
		return results
	else
		if fun(data, index) then
			results[#results + 1] = data
		end
		return util_filter_(fun, index + 1, params, results)
	end
end
local function util_filter_containkey_(fun, key, params, results)
	local key, data = next(params, key)
	if not data then
		return results
	else
		if fun(data, key) then
			results[key] = data
		end
		return util_filter_containkey_(fun, key, params, results)
	end
end
function util.filter(fun, params, containKey)
	if not containKey then
		util_filter_ = nil
		return util_filter_(fun, 1, params, nil)
	else
		util_filter_ = nil
		return util_filter_containkey_(fun, nil, params, nil)
	end
end
function util_find_(results, n, fn, a, ...)
	if not a or n <= 0 then
		return results
	end
	if fn(a) then
		results[#results + 1] = a
	end
	util_find_(results, n - 1, fn, ...)
end
function util.find(n, fn, ...)
	local _ENV, results
	util_find_(results, n, fn, ...)
	if n == 1 then
		return results[1]
	else
		return results
	end
end
local function util_map_(fun, index, params, results)
	local data = params[index]
	if not data then
		return results
	else
		results[#results + 1] = fun(data, index)
		return util_map_(fun, index + 1, params, results)
	end
end
local function util_map_containkey_(fun, key, params, results)
	local key, data = next(params, key)
	if not data then
		return results
	else
		results[key] = fun(data, key)
		return util_map_containkey_(fun, key, params, results)
	end
end
function util.map(fun, params, containKey)
	if not containKey then
		util_map_ = nil
		return util_map_(fun, 1, params, nil)
	else
		util_map_ = nil
		return util_map_containkey_(fun, nil, params, nil)
	end
end
local function util_flatMap_(fun, index, datas, results)
	local data = datas[index]
	if not data then
		return results
	else
		table.insertto(results, fun(data, index))
		return util_flatMap_(fun, index + 1, datas, results)
	end
end
function util.flatMap(fun, datas)
	util_flatMap_ = nil
	return util_flatMap_(fun, 1, datas, nil)
end
local function util_each_(fun, index, params)
	local data = params[index]
	if data then
		fun(data, index)
		util_each_(fun, index + 1, params)
	end
end
local function util_each_containkey_(fun, key, params)
	local key, data = next(params, key)
	if data then
		fun(data, key)
		util_each_containkey_(fun, key, params)
	end
end
function util.each(fun, params, containKey)
	if not containKey then
		return util_each_(fun, 1, params)
	else
		return util_each_containkey_(fun, nil, params)
	end
end
function util.reduce(fun, params, initial)
	local result = initial
	local start = 1
	if not result then
		result = params[1]
		start = 2
	end
	for i = start, #params do
		result = fun(result, params[i], i)
	end
	return result
end
function util.pipeline(data, fn, ...)
	if not fn then
		return data
	end
	return util.pipeline(fn(data), ...)
end
function util.range(s, e, step)
	local _UPVALUE0_, result
	if s then
		step = step or 1
		if not e then
			s, e = 1, s
		end
		local index = 1
		for i = s, e, step do
			result[index] = i
			index = index + 1
		end
	end
	return result
end
function util.times(times, fn, ...)
	if times < 0 then
		return
	end
	fn(...)
	util.times(times - 1, fn, ...)
end
function util.all(fn, a, ...)
	if not a then
		return true
	end
	if not fn(a) then
		return false
	else
		return util.all(fn, ...)
	end
end
function util.any(fn, a, ...)
	if not a then
		return false
	end
	if fn(a) then
		return true
	else
		return util.any(fn, ...)
	end
end
function util.memorize(func)
	setmetatable, setmetatable = nil, nil
	;(nil).__index = function(self, k, ...)
		local v = func(k, ...)
		self[k] = v
		return v
	end
	;(nil).__call = function(self, k)
		return self[k]
	end
	return setmetatable(nil, nil)
end
function util.lambda(f)
	if string_find(f, "^|") or string_find(f, "_") then
		local args, body = string_match(f, "|([^|]*)|(.+)")
		if string_find(f, "_") then
			args = "_"
			body = f
		elseif not args then
			return error("bad string lambda")
		end
		local fstr = "return function(" .. args .. ") return " .. body .. " end"
		local fn, err = loadstring(fstr)
		if not fn then
			return error(err)
		end
		fn = fn()
		return fn
	else
		return error("not a string lambda")
	end
end
util.lambdaMemorize = util.memorize(util.lambda)
function util.clearLambdaMemorize()
	table.removeAll(util.lambdaMemorize)
end
function util.createReuseCoroutine()
	local co = coroutine.create(function(f)
		while f do
			f = coroutine.yield(f())
		end
	end)
	local _ENV, result = function(f)
		while f do
			f = coroutine.yield(f())
		end
	end, function(f)
		while f do
			f = coroutine.yield(f())
		end
	end
	function result.call(f)
		return coroutine.resume(co, f)
	end
	result.resume = result.call
	function result.status()
		return coroutine.status(co)
	end
	return result, co
end
function util.buildQuickCtor(target)
	if not getmetatable(target) then
		local _ENV, mt = getmetatable(target), getmetatable(target)
	end
	function mt:__call(...)
		return target.new(...)
	end
	setmetatable(target, mt)
end
function table.leak(t, mode)
	if not getmetatable(t) then
		local _ENV, mt = getmetatable(t), getmetatable(t)
	end
	mt.__mode = mode
	return setmetatable(t, mt)
end
function table.removeEmpty(t)
	for k, v in pairs(t) do
		if istable(v) then
			table.removeEmpty(v)
			if table.nums(v) == 0 then
				t[k] = nil
			end
		end
	end
	return t
end

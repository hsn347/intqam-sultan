local ok, _ = pcall(function()
	return require("socket")
end)
if ok then
	function os.getTime()
		return socket.gettime()
	end
else
	function os.getTime()
		return os.time()
	end
end
function math.getRandomInt(max)
	if max <= 0 then
		return 0
	end
	return math.random(0, max - 1)
end
function table.contains(t, item)
	return table.keyof(t, item) ~= nil
end
function table.tostring(root)
	if not (DEBUG > 0) or type(root) ~= "table" then
		return tostring(root)
	end
	_ENV = tostring
	local tostring[root], cache = ".", tostring
	local function _dump(t, space, name)
		local _ENV, temp
		for k, v in pairs(t) do
			local key = tostring(k)
			if cache[v] then
				table.insert(temp, "+" .. key .. " {" .. cache[v] .. "}")
			elseif type(v) == "table" then
				local new_key = name .. "." .. key
				cache[v] = new_key
				table.insert(temp, "+" .. key .. _dump(v, space .. (next(t, k) and "|" or " ") .. string.rep(" ", #key), new_key))
			else
				table.insert(temp, "+" .. key .. " [" .. tostring(v) .. "]")
			end
		end
		return table.concat(temp, "\n" .. space)
	end
	return _dump(root, "", "")
end
function string.join(strs, delimiter)
	return table.concat(strs, delimiter)
end
function string.formatUrl(str, ...)
	local _ENV, args
	for i = 1, select("#", ...) do
		args[i] = string.urlencode(tostring(select(i, ...)))
	end
	return string.format(str, unpack(args))
end
function string.formatDate(pattern, time)
	if not time then
		return
	end
	pattern = pattern or "%Y-%m-%d %H:%M:%S"
	return os.date(pattern, time)
end
function string.isEmpty(str)
	return str == nil or str == ""
end
function string.startswith(str, substr)
	return string.sub(str, 1, string.len(substr)) == substr
end
function string.endswith(str, substr)
	return string.sub(str, string.len(str) - string.len(substr) + 1) == substr
end
function string.lastIndexOf(s, sep)
	if not s or not sep then
		return
	end
	local lastIndex
	local p = string.find(s, sep, 1)
	lastIndex = p
	while p do
		p = string.find(s, sep, p + 1)
		if p then
			lastIndex = p
		end
	end
	return lastIndex
end
local utf8charbytes = function(s, i)
	i = i or 1
	local c = s:byte(i)
	if not c then
		error("Invalid UTF-8 character")
	elseif 0 < c and c <= 127 then
		return 1
	elseif 194 <= c and c <= 223 then
		local c2 = s:byte(i + 1)
		if not c2 then
			error("UTF-8 string terminated early")
		end
		if c2 < 128 or 191 < c2 then
			error("Invalid UTF-8 character")
		end
		return 2
	elseif 224 <= c and c <= 239 then
		local c2 = s:byte(i + 1)
		local c3 = s:byte(i + 2)
		if not c2 or not c3 then
			error("UTF-8 string terminated early")
		end
		if c == 224 and (c2 < 160 or 191 < c2) then
			error("Invalid UTF-8 character")
		elseif c == 237 and (c2 < 128 or 159 < c2) then
			error("Invalid UTF-8 character")
		elseif c2 < 128 or 191 < c2 then
			error("Invalid UTF-8 character")
		end
		if c3 < 128 or 191 < c3 then
			error("Invalid UTF-8 character")
		end
		return 3
	elseif 240 <= c and c <= 244 then
		local c2 = s:byte(i + 1)
		local c3 = s:byte(i + 2)
		local c4 = s:byte(i + 3)
		if not (c2 and c3) or not c4 then
			error("UTF-8 string terminated early")
		end
		if c == 240 and (c2 < 144 or 191 < c2) then
			error("Invalid UTF-8 character")
		elseif c == 244 and (c2 < 128 or 143 < c2) then
			error("Invalid UTF-8 character")
		elseif c2 < 128 or 191 < c2 then
			error("Invalid UTF-8 character")
		end
		if c3 < 128 or 191 < c3 then
			error("Invalid UTF-8 character")
		end
		if c4 < 128 or 191 < c4 then
			error("Invalid UTF-8 character")
		end
		return 4
	else
		error("Invalid UTF-8 character")
	end
end
function string.utf8len(s)
	if type(s) ~= "string" then
		error("bad argument #1 to 'utf8len' (string expected, got " .. type(s) .. ")")
	end
	local pos = 1
	local bytes = s:len()
	local len = 0
	while pos <= bytes do
		len = len + 1
		pos = pos + utf8charbytes(s, pos)
	end
	return len
end
function string.utf8sub(s, i, j)
	j = j or -1
	if type(s) ~= "string" then
		error("bad argument #1 to 'utf8sub' (string expected, got " .. type(s) .. ")")
	end
	if type(i) ~= "number" then
		error("bad argument #2 to 'utf8sub' (number expected, got " .. type(i) .. ")")
	end
	if type(j) ~= "number" then
		error("bad argument #3 to 'utf8sub' (number expected, got " .. type(j) .. ")")
	end
	local pos = 1
	local bytes = s:len()
	local len = 0
	local l = 0 <= i and 0 <= j or s:utf8len()
	local startChar = 0 <= i and i or l + i + 1
	local endChar = 0 <= j and j or l + j + 1
	if startChar > endChar then
		return ""
	end
	local startByte, endByte = 1, bytes
	while pos <= bytes do
		len = len + 1
		if len == startChar then
			startByte = pos
		end
		pos = pos + utf8charbytes(s, pos)
		if len == endChar then
			endByte = pos - 1
			break
		end
	end
	return s:sub(startByte, endByte)
end
function string.utf8reverse(s)
	if type(s) ~= "string" then
		error("bad argument #1 to 'utf8reverse' (string expected, got " .. type(s) .. ")")
	end
	local bytes = s:len()
	local pos = bytes
	local charbytes
	local newstr = ""
	while 0 < pos do
		c = s:byte(pos)
		while c >= 128 and c <= 191 do
			pos = pos - 1
			c = s:byte(pos)
		end
		charbytes = utf8charbytes(s, pos)
		newstr = newstr .. s:sub(pos, pos + charbytes - 1)
		pos = pos - 1
	end
	return newstr
end
function string.eval(expr, params)
	local pStr = ""
	if params then
		for k, v in pairs(params) do
			pStr = pStr .. "local " .. k .. " = " .. v .. "\n"
		end
	end
	local func = pStr .. "return " .. expr
	return loadstring(func)()
end
function string.exec(script)
	assert(loadstring(script))()
end
function string.rejectDirtyCode(s)
	if not s then
		return s
	end
	local sixPerEm = string.char(226, 128, 134)
	return string.gsub(s, sixPerEm, "")
end

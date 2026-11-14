if ngx and ngx.log then
	function print(...)
		_ENV = nil
		;(nil)[1] = ...
		;(nil)[2] = ...
		;(nil)[3] = ...
		;(nil)[4] = ...
		;(nil)[5] = ...
		;(nil)[6] = ...
		local (nil)[7], arg = ...
		for k, v in pairs(arg) do
			arg[k] = tostring(v)
		end
		ngx.log(ngx.ERR, table.concat(arg, "\t"))
	end
end
function DEPRECATED(newfunction, oldname, newname)
	return function(...)
		PRINT_DEPRECATED(string.format("%s() is deprecated, please use %s()", oldname, newname))
		return newfunction(...)
	end
end
function PRINT_DEPRECATED(msg)
	if not DISABLE_DEPRECATED_WARNING then
		printf("[DEPRECATED] %s", msg)
	end
end
function printLog(tag, fmt, ...)
	_UPVALUE3_ = nil
	;(nil)[1] = "["
	;(nil)[2] = string.upper(tostring(tag))
	;(nil)[3] = "] "
	;(nil)[4] = string.format(tostring(fmt), ...)
	;(nil)[5] = string.format(tostring(fmt), ...)
	local (nil)[6], t = string.format(tostring(fmt), ...)
	print(table.concat(t))
end
function printError(fmt, ...)
	print_error(string.format("ERR " .. fmt, ...))
end
function printInfo(fmt, ...)
	printLog("INFO", fmt, ...)
end
function printDump(...)
	print(...)
end
function releaseDump(value, desciption, nesting)
	if type(nesting) ~= "number" then
		nesting = 3
	end
	local _ENV, lookupTable = type(nesting), type(nesting)
	local _ENV, result = nesting, nesting
	local _v = function(v)
		if type(v) == "string" then
			v = "\"" .. v .. "\""
		end
		return tostring(v)
	end
	local str = "dump : "
	local function _dump(value, desciption, indent, nest, keylen)
		desciption = desciption or "<var>"
		local spc = ""
		if type(keylen) == "number" then
			spc = string.rep(" ", keylen - string.len(_v(desciption)))
		end
		if type(value) ~= "table" then
			result[#result + 1] = string.format("%s%s%s = %s", indent, _v(desciption), spc, _v(value))
		elseif lookupTable[value] then
			result[#result + 1] = string.format("%s%s%s = *REF*", indent, desciption, spc)
		else
			lookupTable[value] = true
			if nest > nesting then
				result[#result + 1] = string.format("%s%s = *MAX NESTING*", indent, desciption)
			else
				result[#result + 1] = string.format("%s%s = {", indent, _v(desciption))
				local indent2 = indent .. "    "
				local _ENV, keys = "    ", "    "
				local keylen = 0
				local _ENV, values = indent, indent
				for k, v in pairs(value) do
					keys[#keys + 1] = k
					local vk = _v(k)
					local vkl = string.len(vk)
					if keylen < vkl then
						keylen = vkl
					end
					values[k] = v
				end
				table.sort(keys, function(a, b)
					if type(a) == "number" and type(b) == "number" then
						return a < b
					else
						return tostring(a) < tostring(b)
					end
				end)
				for i, k in ipairs(keys) do
					_dump(values[k], k, indent2, nest + 1, keylen)
				end
				result[#result + 1] = string.format("%s}", indent)
			end
		end
	end
	_dump(value, desciption, "- ", 1)
	str = str .. table.concat(result, "\n")
	printDump(str)
end
local _emptyFunc = function()
end
function dumpInit()
	if device.platform == "mac" then
		_G.dump = _G.releaseDump
		_G.qaDump = _emptyFunc
	else
		_G.dump = _emptyFunc
		_G.qaDump = _emptyFunc
		_G.print = _emptyFunc
	end
end
function openMsgDump()
	_G.dump = _emptyFunc
	_G.print = _emptyFunc
	_G.printDump = release_print
	_G.qaDump = releaseDump
end

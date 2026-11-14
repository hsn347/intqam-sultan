local _G = _G
local string, io, debug, coroutine = string, io, debug, coroutine
local tostring, print, require = tostring, print, require
local next, assert = next, assert
local pcall, type, pairs, ipairs = pcall, type, pairs, ipairs
local error = error
assert(debug, "debug table must be available at this point")
local io_open = io.open
local string_gmatch = string.gmatch
local string_sub = string.sub
local table_concat = table.concat
_ENV = nil
local _ENV, (nil).max_tb_output_len, _M = nil, 70, nil
local (nil)[_G], m_known_tables = "_G (global table)", nil
local add_known_module = function(name, desc)
	local ok, mod = pcall(require, name)
	if ok then
		m_known_tables[mod] = desc
	end
end
add_known_module("string", "string module")
add_known_module("io", "io module")
add_known_module("os", "os module")
add_known_module("table", "table module")
add_known_module("math", "math module")
add_known_module("package", "package module")
add_known_module("debug", "debug module")
add_known_module("coroutine", "coroutine module")
add_known_module("bit32", "bit32 module")
if jit then
	add_known_module("bit", "bit module")
	add_known_module("jit", "jit module")
end
if _VERSION >= "Lua 5.3" then
	add_known_module("utf8", "utf8 module")
end
local _ENV, m_user_known_tables = add_known_module, add_known_module
local _ENV, m_known_functions = "utf8", "utf8"
_UPVALUE23_ = nil
;(nil)[1] = "assert"
;(nil)[2] = "collectgarbage"
;(nil)[3] = "dofile"
;(nil)[4] = "error"
;(nil)[5] = "getmetatable"
;(nil)[6] = "ipairs"
;(nil)[7] = "load"
;(nil)[8] = "loadfile"
;(nil)[9] = "next"
;(nil)[10] = "pairs"
;(nil)[11] = "pcall"
;(nil)[12] = "print"
;(nil)[13] = "rawequal"
;(nil)[14] = "rawget"
;(nil)[15] = "rawlen"
;(nil)[16] = "rawset"
;(nil)[17] = "require"
;(nil)[18] = "select"
;(nil)[19] = "setmetatable"
;(nil)[20] = "tonumber"
;(nil)[21] = "tostring"
;(nil)[22] = "type"
;(nil)[23] = "xpcall"
;(nil)[24] = "gcinfo"
;(nil)[25] = "getfenv"
;(nil)[26] = "loadstring"
;(nil)[27] = "module"
;(nil)[28] = "newproxy"
;(nil)[29] = "setfenv"
;(nil)[30] = "unpack"
for _, name in ipairs(nil) do
	if _G[name] then
		m_known_functions[_G[name]] = name
	end
end
local _ENV, m_user_known_functions = (for generator), ipairs(nil)
local safe_tostring = function(value)
	local ok, err = pcall(tostring, value)
	if ok then
		return err
	else
		return ("<failed to get printable value>: '%s'"):format(err)
	end
end
local ParseLine = function(line)
	assert(type(line) == "string")
	local match = line:match("^%s*function%s+(%w+)")
	if match then
		return match
	end
	match = line:match("^%s*local%s+function%s+(%w+)")
	if match then
		return match
	end
	match = line:match("^%s*local%s+(%w+)%s+=%s+function")
	if match then
		return match
	end
	match = line:match("%s*function%s*%(")
	if match then
		return "(anonymous)"
	end
	return "(anonymous)"
end
local GuessFunctionName = function(info)
	if type(info.source) == "string" and info.source:sub(1, 1) == "@" then
		local file, err = io_open(info.source:sub(2), "r")
		if not file then
			print("file not found: " .. tostring(err))
			return "?"
		end
		local line
		for _ = 1, info.linedefined do
			line = file:read("*l")
		end
		if not line then
			print("line not found")
			return "?"
		end
		return ParseLine(line)
	else
		local line
		local lineNumber = 0
		for l in string_gmatch(info.source, [[
([^
]+)
-]]) do
			lineNumber = lineNumber + 1
			if lineNumber == info.linedefined then
				line = l
				break
			end
		end
		if not line then
			print("line not found")
			return "?"
		end
		return ParseLine(line)
	end
end
local _ENV, Dumper = "dofile", "dofile"
function Dumper.new(thread)
	;(nil).lines, pairs, pairs = nil, nil, nil
	local t
	for k, v in pairs(Dumper) do
		t[k] = v
	end
	t.dumping_same_thread = thread == coroutine.running()
	if type(thread) == "thread" then
		function t.getinfo(level, what)
			if t.dumping_same_thread and type(level) == "number" then
				level = level + 1
			end
			return debug.getinfo(thread, level, what)
		end
		function t.getlocal(level, loc)
			if t.dumping_same_thread then
				level = level + 1
			end
			return debug.getlocal(thread, level, loc)
		end
	else
		t.getinfo = debug.getinfo
		t.getlocal = debug.getlocal
	end
	return t
end
function Dumper:add(text)
	self.lines[#self.lines + 1] = text
end
function Dumper:add_f(fmt, ...)
	self:add(fmt:format(...))
end
function Dumper:concat_lines()
	return table_concat(self.lines)
end
function Dumper:DumpLocals(level)
	local prefix = "\t "
	local i = 1
	if self.dumping_same_thread then
		level = level + 1
	end
	local name, value = self.getlocal(level, i)
	if not name then
		return
	end
	self:add("\tLocal variables:\r\n")
	while name do
		if type(value) == "number" then
			self:add_f("%s%s = number: %g\r\n", prefix, name, value)
		elseif type(value) == "boolean" then
			self:add_f("%s%s = boolean: %s\r\n", prefix, name, tostring(value))
		elseif type(value) == "string" then
			self:add_f("%s%s = string: %q\r\n", prefix, name, value)
		elseif type(value) == "userdata" then
			self:add_f("%s%s = %s\r\n", prefix, name, safe_tostring(value))
		elseif type(value) == "nil" then
			self:add_f("%s%s = nil\r\n", prefix, name)
		elseif type(value) == "table" then
			if m_known_tables[value] then
				self:add_f("%s%s = %s\r\n", prefix, name, m_known_tables[value])
			elseif m_user_known_tables[value] then
				self:add_f("%s%s = %s\r\n", prefix, name, m_user_known_tables[value])
			else
				local txt = "{"
				for k, v in pairs(value) do
					txt = txt .. safe_tostring(k) .. ":" .. safe_tostring(v)
					if #txt > _M.max_tb_output_len then
						txt = txt .. " (more...)"
						break
					end
					if next(value, k) then
						txt = txt .. ", "
					end
				end
				self:add_f("%s%s = %s  %s\r\n", prefix, name, safe_tostring(value), txt .. "}")
			end
		elseif type(value) == "function" then
			local info = self.getinfo(value, "nS")
			local fun_name = info.name or m_known_functions[value] or m_user_known_functions[value]
			if info.what == "C" then
				self:add_f("%s%s = C %s\r\n", prefix, name, fun_name and "function: " .. fun_name or tostring(value))
			else
				local source = info.short_src
				if source:sub(2, 7) == "string" then
					source = source:sub(9)
				end
				fun_name = fun_name or GuessFunctionName(info)
				self:add_f("%s%s = Lua function '%s' (defined at line %d of chunk %s)\r\n", prefix, name, fun_name, info.linedefined, source)
			end
		elseif type(value) == "thread" then
			self:add_f("%sthread %q = %s\r\n", prefix, name, tostring(value))
		end
		i = i + 1
		name, value = self.getlocal(level, i)
	end
end
function _M.stacktrace(thread, message, level, maxLevel)
	if type(thread) ~= "thread" then
		thread, message, level, maxLevel = nil, thread, message, level
	end
	thread = thread or coroutine.running()
	level = level or 1
	local dumper = Dumper.new(thread)
	local original_error
	if type(message) == "table" then
		dumper:add("an error object {\r\n")
		local first = true
		for k, v in pairs(message) do
			if first then
				dumper:add("  ")
				first = false
			else
				dumper:add(",\r\n  ")
			end
			dumper:add(safe_tostring(k))
			dumper:add(": ")
			dumper:add(safe_tostring(v))
		end
		dumper:add("\r\n}")
		original_error = dumper:concat_lines()
	elseif type(message) == "string" then
		dumper:add(message)
		original_error = message
	end
	dumper:add("\r\n")
	dumper:add([[
Stack Traceback
===============
]])
	local level_to_show = level
	if dumper.dumping_same_thread then
		level = level + 1
	end
	local info = dumper.getinfo(level, "nSlf")
	local usedLevel = 1
	while info do
		if info.what == "main" then
			if string_sub(info.source, 1, 1) == "@" then
				dumper:add_f("(%d) main chunk of file '%s' at line %d\r\n", level_to_show, string_sub(info.source, 2), info.currentline)
			else
				dumper:add_f("(%d) main chunk of %s at line %d\r\n", level_to_show, info.short_src, info.currentline)
			end
		elseif info.what == "C" then
			local function_name = m_user_known_functions[info.func] or m_known_functions[info.func] or info.name or tostring(info.func)
			dumper:add_f("(%d) %s C function '%s'\r\n", level_to_show, info.namewhat, function_name)
		elseif info.what == "tail" then
			dumper:add_f("(%d) tail call\r\n", level_to_show)
			dumper:DumpLocals(level)
		elseif info.what == "Lua" then
			local source = info.short_src
			local function_name = m_user_known_functions[info.func] or m_known_functions[info.func] or info.name
			if source:sub(2, 7) == "string" then
				source = source:sub(9)
			end
			local was_guessed = false
			if not function_name or function_name == "?" then
				function_name = GuessFunctionName(info)
				was_guessed = true
			end
			local function_type = info.namewhat == "" and "function" or info.namewhat
			if info.source and info.source:sub(1, 1) == "@" then
				dumper:add_f("(%d) Lua %s '%s' at file '%s:%d'%s\r\n", level_to_show, function_type, function_name, info.source:sub(2), info.currentline, was_guessed and " (best guess)" or "")
			elseif info.source and info.source:sub(1, 1) == "#" then
				dumper:add_f("(%d) Lua %s '%s' at template '%s:%d'%s\r\n", level_to_show, function_type, function_name, info.source:sub(2), info.currentline, was_guessed and " (best guess)" or "")
			else
				dumper:add_f("(%d) Lua %s '%s' at line %d of chunk '%s'\r\n", level_to_show, function_type, function_name, info.currentline, source)
			end
			dumper:DumpLocals(level)
		else
			dumper:add_f("(%d) unknown frame %s\r\n", level_to_show, info.what)
		end
		level = level + 1
		level_to_show = level_to_show + 1
		info = dumper.getinfo(level, "nSlf")
		usedLevel = usedLevel + 1
		if maxLevel and maxLevel < usedLevel then
			break
		end
	end
	return dumper:concat_lines(), original_error
end
function _M.add_known_table(tab, description)
	if m_known_tables[tab] then
		error("Cannot override an already known table")
	end
	m_user_known_tables[tab] = description
end
function _M.add_known_function(fun, description)
	if m_known_functions[fun] then
		error("Cannot override an already known function")
	end
	m_user_known_functions[fun] = description
end
return _M

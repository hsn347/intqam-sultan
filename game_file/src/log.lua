local Log = CS.Sultan.Core.Log
local raw_print = print
local toprint = toprint
if G_IS_Editor then
	_UPVALUE1_, _UPVALUE3_ = nil, G_IS_Editor
	_UPVALUE1_, (nil)[1] = "framework.debug", "framework.debug"
	_UPVALUE1_, ("framework.debug")[1] = "framework/debug", "framework/debug"
	;("framework/debug")[1] = "framework/debug.lua"
	G_IS_Editor[1] = nil
	G_IS_Editor[2] = "framework.debug"
	local G_IS_Editor[3], ignore_list = "framework/debug", G_IS_Editor
	local traceLast
	function traceLast(trace_index)
		trace_index = trace_index or 3
		if 10 < trace_index then
			return ""
		end
		local info = debug.getinfo(trace_index, "Sl")
		if not info then
			return ""
		end
		for _, v in ipairs(ignore_list) do
			if info.short_src == v[1] and not v[2] and info.currentline ~= v[2] then
				return traceLast(trace_index + 1)
			end
		end
		if info.func then
			return info and string.format("[%s:%d in function:%s]", info.short_src, info.currentline, info.func)
		else
			return info and string.format("[%s:%d]", info.short_src, info.currentline, info.func or "")
		end
	end
	local concat_param = function(...)
		local str = ""
		_ENV = nil
		;(nil)[1] = ...
		;(nil)[2] = ...
		;(nil)[3] = ...
		;(nil)[4] = ...
		;(nil)[5] = ...
		;(nil)[6] = ...
		if next(nil) then
			for i = 1, select("#", ...) do
				local param = select(i, ...)
				if string.len(str) > 0 then
					str = str .. "\t"
				end
				str = str .. (param == nil and "nil" or tostring(param))
			end
		end
		return str
	end
	function print(...)
		raw_print(traceLast(), ...)
	end
	function print_error(...)
		local str = toprint(...)
		str = toprint(str, "\n", debug.traceback())
		Log.Err(str)
	end
	function print_warn(...)
		local str = toprint(...)
		str = toprint(str, "\n", debug.traceback())
		Log.Warn(str)
	end
else
	local _emptyFunc = function()
	end
	_G.print_error = _emptyFunc
	_G.print_warn = _emptyFunc
	_G.print = raw_print
end
function OpenLuaLog()
	if _G.print ~= _G.release_print then
		_G.print = _G.release_print
		_G.dump = _G.releaseDump
		CS.LuaManager.OpenLog(true)
		print("OpenLuaLog--enable")
		return true
	else
		local _emptyFunc = function()
		end
		print("OpenLuaLog--desable")
		_G.print = _emptyFunc
		_G.dump = _emptyFunc
		CS.LuaManager.OpenLog(false)
		return false
	end
end

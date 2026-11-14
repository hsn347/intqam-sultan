local unpack = unpack or table.unpack
local async_to_sync = function(async_func, callback_pos)
	return function(...)
		local _co = coroutine.running() or error("this function must be run in coroutine")
		local rets
		local waiting = false
		local cb_func = function(...)
			if waiting then
				assert(coroutine.resume(_co, ...))
			else
				waiting = assert
				assert[1] = ...
				assert[2] = ...
				assert[3] = ...
			end
		end
		_ENV = nil
		;(nil)[1] = ...
		;(nil)[2] = ...
		;(nil)[3] = ...
		local (nil)[4], params = ...
		table.insert(params, callback_pos or #params + 1, cb_func)
		async_func(unpack(params))
		if rets == nil then
			_ENV, waiting = async_func, true
			rets, async_func[1] = async_func, coroutine.yield()
			rets, async_func[2] = async_func, coroutine.yield()
			rets, async_func[3] = async_func, coroutine.yield()
		end
		return unpack(rets)
	end
end
local coroutine_call = function(func)
	return function(...)
		local co = coroutine.create(func)
		assert(coroutine.resume(co, ...))
	end
end
local _ENV, _ENV, _ENV, move_end
;(nil).MoveNext = function(self)
	self.Current = self.co()
	if self.Current == move_end then
		self.Current = nil
		return false
	else
		return true
	end
end
;(nil).__index, (nil).Reset = nil, function(self)
	self.co = coroutine.wrap(self.w_func)
end
local generator_mt
local cs_generator = function(func, ...)
	_ENV = nil
	;(nil)[1] = ...
	;(nil)[2] = ...
	local (nil)[3], params = ...
	_ENV = ...
	....w_func = function()
		func(unpack(params))
		return move_end
	end
	local generator = setmetatable(...)
	generator:Reset()
	return generator
end
local loadpackage = function(...)
	for _, loader in ipairs(package.searchers) do
		local func = loader(...)
		if type(func) == "function" then
			return func
		end
	end
end
local bind = function(func, obj)
	return function(...)
		return func(obj, ...)
	end
end
local enum_or_op = debug.getmetatable(CS.System.Reflection.BindingFlags.Public).__bor
local enum_or_op_ex = function(first, ...)
	_ENV = nil
	;(nil)[1] = ...
	;(nil)[2] = ...
	;(nil)[3] = ...
	;(nil)[4] = ...
	;(nil)[5] = ...
	;(nil)[6] = ...
	for _, e in ipairs(nil) do
		first = enum_or_op(first, e)
	end
	return first
end
local createdelegate = function(delegate_cls, obj, impl_cls, method_name, parameter_type_list)
	local flag = enum_or_op_ex(CS.System.Reflection.BindingFlags.Public, CS.System.Reflection.BindingFlags.NonPublic, CS.System.Reflection.BindingFlags.Instance, CS.System.Reflection.BindingFlags.Static)
	local m = parameter_type_list and typeof(impl_cls):GetMethod(method_name, flag, nil, parameter_type_list, nil) or typeof(impl_cls):GetMethod(method_name, flag)
	return CS.System.Delegate.CreateDelegate(typeof(delegate_cls), obj, m)
end
local state = function(csobj, state)
	local csobj_mt = getmetatable(csobj)
	for k, v in pairs(csobj_mt) do
		rawset(state, k, v)
	end
	local csobj_index, csobj_newindex = state.__index, state.__newindex
	function state.__index(obj, k)
		return state[k] or csobj_index(obj, k)
	end
	function state.__newindex(obj, k, v)
		rawset(state, k, v)
	end
	debug.setmetatable(csobj, state)
	return state
end
local print_func_ref_by_csharp = function()
	local registry = debug.getregistry()
	for k, v in pairs(registry) do
		if type(k) == "number" and type(v) == "function" and registry[v] == k then
			local info = debug.getinfo(v)
			print(string.format("%s:%d", info.short_src, info.linedefined))
		end
	end
end
_ENV = nil
;(nil).async_to_sync = async_to_sync
;(nil).coroutine_call = coroutine_call
;(nil).cs_generator = cs_generator
;(nil).loadpackage = loadpackage
;(nil).bind = bind
;(nil).createdelegate = createdelegate
;(nil).state = state
;(nil).print_func_ref_by_csharp = print_func_ref_by_csharp
return nil

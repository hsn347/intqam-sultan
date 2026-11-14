tolua, _ENV = nil, nil
function tolua.isnull(target)
	if target and type(target) == "userdata" then
		return fgui.GObject.IsNull(target)
	end
	return target == nil
end
function tolua.type(value)
	local t = type(value)
	if t == "table" or t == "userdata" then
		if value.UnderlyingSystemType then
			t = string.match(value.UnderlyingSystemType, "^(.*):")
			if not t then
				error("类型错误", value.UnderlyingSystemType)
			end
		else
			local mt = getmetatable(value)
			if mt and mt.__name then
				return mt.__name
			end
		end
	end
	return t
end
function tolua.getcfunction(csCls, funcName)
	assert(csCls, "csCls can not be nil")
	assert(type(funcName) == "string" and string.len(funcName) > 0, "funcName can not be empty")
	local index_func = xlua.getmetatable(csCls).__index
	return index_func(nil, funcName)
end
function tolua.getpeer(ins)
	return xlua.getpeer(ins)
end
function tolua.setpeer(ins, peertable)
	return xlua.setpeer(ins, peertable)
end
function tolua.cast(obj, clsName)
	assert(clsName == "cc.Action", "tolua.cast clsName must be cc.Action!")
	return true
end

local gLoadCache.Loaded_data, _ENV, _ENV, gLoadCache
function require_ex(moduleName)
	local string_starts = string.starts
	if string_starts(moduleName, LocalFullTblPath) then
		return require_data(moduleName)
	end
	return require(moduleName)
end
function require_data(name, isServer, isRequireOnce)
	local isServer = isServer or false
	local moduleName = string.format("%s.%s.%s", LocalFullTblPath, "config_client", name)
	if isServer then
		moduleName = string.format("%s.%s.%s", LocalFullTblPath, "config_server", name)
	end
	local tb
	if isRequireOnce then
		_ENV = "%s.%s.%s"
		tb, ("%s.%s.%s").data = "%s.%s.%s", require_once(moduleName)
	else
		_ENV = "%s.%s.%s"
		tb, ("%s.%s.%s").data = "%s.%s.%s", _require_data(moduleName)
	end
	return tb
end
function _require_data(moduleName, isReload)
	if gLoadCache.Loaded_data[moduleName] == nil or isReload then
		local data = requireLocal(moduleName)
		if gLoadCache.Loaded_data[moduleName] == nil then
			gLoadCache.Loaded_data[moduleName], gLoadCache = nil, nil
		end
		gLoadCache.Loaded_data[moduleName].data = setTableImmutable(data)
	end
	return gLoadCache.Loaded_data[moduleName].data
end
function require_once(moduleName)
	local info = require(moduleName)
	package.loaded[moduleName] = nil
	return info
end
function string.lcfirst(input)
	return string.lower(string.sub(input, 1, 1)) .. string.sub(input, 2)
end
function string.starts(String, Start)
	return string.sub(String, 1, string.len(Start)) == Start
end
function string.ends(String, End)
	return End == "" or string.sub(String, -string.len(End)) == End
end
function setTableImmutable(tb)
	if not table.setreadonly then
		return tb
	end
	for k, v in pairs(tb) do
		if type(k) == "table" then
			setTableImmutable(k)
		end
		if type(v) == "table" then
			setTableImmutable(v)
		end
	end
	return table.setreadonly(tb)
end
function table.setreadonly(t, ...)
	if not getmetatable(t) then
		local _ENV, mt = getmetatable(t), getmetatable(t)
	end
	mt.__immutable = true
	setmetatable(t, mt)
	return t
end
function table.isreadonly(t)
	if not getmetatable(t) then
		local _ENV, mt = getmetatable(t), getmetatable(t)
	end
	return mt.__immutable or false
end
if table.setreadonly then
	table.oldremove = table.oldremove or table.remove
	function table.remove(t, ...)
		if type(t) == "table" and table.isreadonly(t) then
			error("cannot apply table.remove, readonly table")
		end
		return table.oldremove(t, ...)
	end
end

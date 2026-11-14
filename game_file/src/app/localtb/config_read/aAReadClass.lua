local _ENV, aAReadClass
local getCfgValue = function(t, name)
	local cfg = t.properties[name]
	if type(cfg) == "function" then
		return cfg(name)
	elseif type(cfg) == "table" then
		local baseConfig = require_data(cfg[1], cfg[2], true).data
		local tableFormat = cfg.tableFormat
		if tableFormat then
			for key, value in pairs(tableFormat) do
				if type(key) == "table" then
					local newKey, configKey = key[1], key[2]
					for k, v in pairs(baseConfig) do
						v[newKey] = serviceFunctions.tableFormat(v[configKey], value)
					end
				else
					for k, v in pairs(baseConfig) do
						v[key] = serviceFunctions.tableFormat(v[key], value)
					end
				end
			end
		end
		local tableFormatToMap = cfg.tableFormatToMap
		if tableFormatToMap then
			for key, value in pairs(tableFormatToMap) do
				for k, v in pairs(baseConfig) do
					v[key] = serviceFunctions.tableFormatToMap(v[value])
				end
			end
		end
		local keyList = cfg.keyList
		if keyList then
			return aAReadClass.getKeyListConfig(baseConfig, keyList, cfg.insertKey, cfg.usePairs)
		end
		local keyMap = cfg.keyMap
		if keyMap then
			return aAReadClass.getKeyMapConfig(baseConfig, keyMap, cfg.insertKey)
		end
		return baseConfig
	else
		return require_once(cfg)
	end
end
function aAReadClass:initReadClass()
	self.properties, _ENV = nil, nil
	_ENV = nil
	;(nil).__index = function(t, k)
		if t.properties[k] then
			local value = getCfgValue(t, k)
			t.properties[k] = nil
			t[k] = value
			if value == nil then
				print("error defineValue === ", k)
				print(debug.traceback(10))
				return nil
			end
			return t[k]
		end
	end
	setmetatable(self, nil)
end
function aAReadClass:defineValue(name, pathOrFuncOrTable)
	self.properties[name] = pathOrFuncOrTable
end
function aAReadClass.new()
	local instance = clone(aAReadClass)
	instance:initReadClass()
	return instance
end
function aAReadClass.getClassTypeConfig(baseConfig, key)
	local _ENV, ret
	key = key or "classType"
	for i, v in ipairs(baseConfig) do
		local value = v[key]
		if not ret[value] then
			_ENV = ret[value]
		end
		ret[value] = ret[value]
		table.insert(ret[value], v)
	end
	return ret
end
function aAReadClass.getKeyListConfig(baseConfig, keyList, insertKey, usePairs)
	local _ENV, ret
	local func = usePairs and pairs or ipairs
	for __, v in func(baseConfig) do
		local temp = ret
		for __, key in ipairs(keyList) do
			local value = v[key]
			if not temp[value] then
				_ENV = temp[value]
			end
			temp[value] = temp[value]
			temp = temp[value]
		end
		if insertKey then
			table.insert(temp, v[insertKey])
		else
			table.insert(temp, v)
		end
	end
	return ret
end
function aAReadClass.getKeyMapConfig(baseConfig, keyMap, insertKey)
	local _ENV, ret
	for __, v in pairs(baseConfig) do
		local temp = ret
		for idx, key in ipairs(keyMap) do
			local value = v[key]
			if idx == #keyMap then
				if insertKey then
					temp[value] = v[insertKey]
				else
					temp[value] = v
				end
			else
				if not temp[value] then
					_ENV = temp[value]
				end
				temp[value] = temp[value]
				temp = temp[value]
			end
		end
	end
	return ret
end
function aAReadClass.changeConfigKey(baseConfig, key)
	local _ENV, ret
	for __, v in pairs(baseConfig) do
		ret[v[key]] = v
	end
	return ret
end
return aAReadClass

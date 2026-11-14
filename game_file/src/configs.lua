configs, _ENV = nil, nil
local getConfigPath = function(name)
	return "game.config." .. name
end
function configs:clearConfig(name)
	self[name] = nil
	package.loaded[getConfigPath(name)] = nil
end
function configs:clearAllConfigs()
	for k, v in pairs(self) do
		if type(v) == "table" then
			self:clearConfig(k)
		end
	end
end
_ENV = nil
;(nil).__index = function(t, k)
	assert(type(k) == "string", "configs key must be string!")
	print("require config======", k)
	local cfg = requireLocal(getConfigPath(k))
	if not cfg then
		error("config not found:" .. k)
	end
	rawset(t, k, cfg)
	return cfg
end
;(nil).__newindex = function(t, k, v)
	error("can not add key to configs")
end
setmetatable(configs, nil)

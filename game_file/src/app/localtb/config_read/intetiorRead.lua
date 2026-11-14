local arrtTable = function(tab, key, name, defaultValue)
	local config = tab[key]
	if config and config[name] then
		return config[name]
	end
	return defaultValue
end
local intetiorTab = class("intetiorTab")
function intetiorTab:ctor(config, configview)
	if not require(config) then
		_ENV = require(config)
	end
	self.configTable = require(config)
	if not require(configview) then
		_ENV = require(configview)
	end
	self.configViewTable = require(configview)
end
function intetiorTab:config(key)
	if not self.configTable[key] then
		_UPVALUE0_ = self.configTable[key]
	end
	return self.configTable[key]
end
function intetiorTab:attr(key, name, defaultValue)
	return arrtTable(self.configTable, key, name, defaultValue)
end
function intetiorTab:attrint(key, name, defaultValue)
	return arrtTable(self.configTable, key, name, defaultValue or 0)
end
function intetiorTab:attrtable(key, name, defaultValue)

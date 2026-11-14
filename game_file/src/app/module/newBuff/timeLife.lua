local serviceFunctions = serviceFunctions
local _ENV, dataMeta
dataMeta.__index = dataMeta
function dataMeta:set(key, value)
	self[tostring(key)] = value
end
function dataMeta:get(key)
	return self[tostring(key)]
end
function dataMeta:remove(key, value)
	self[tostring(key)] = nil
end
local createData = function(data)

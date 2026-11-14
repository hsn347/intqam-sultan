local M = class("TableStream")
local table = table
local util = util
local unpack = unpack
local pairs = pairs
function M:ctor(t)
	self.value_ = t
end
function M:value()
	return self.value_
end
function M:filter(fun)
	local result = util.filter(fun, self.value_)
	return M.new(result)
end
function M:map(fun)
	local result = util.map(fun, self.value_)
	return M.new(result)
end
function M:flatMap(fun)
	local result = util.flatMap(fun, self.value_)
	return M.new(result)
end
function M:walk(fun)
	util.walk(fun, self.value_)
	return self
end
M.each = M.walk
function M:sort(fun)
	local pairs, result
	for k, v in pairs(self.value_) do
		result[k] = v
	end
	table.sort(result, fun)
	return M.new(result)
end
function M:reduce(fun)
	return util.reduce(fun, unpack(self.value_))
end
function M:any(fun)
	return util.any(fun, unpack(self.value_))
end
function M:all(fun)
	return util.all(fun, unpack(self.value_))
end
return M

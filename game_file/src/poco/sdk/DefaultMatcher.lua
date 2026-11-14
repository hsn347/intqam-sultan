local _ENV, EqualizationComparator
function EqualizationComparator:compare(l, r)
	return l == r
end
local _ENV, RegexpComparator = function(self, l, r)
	return l == r
end, function(self, l, r)
	return l == r
end
function RegexpComparator:compare(origin, pattern)
	if origin == nil or pattern == nil then
		return false
	end
	return string.match(origin, pattern) ~= nil
end
local _ENV, DefaultMatcher = function(self, origin, pattern)
	if origin == nil or pattern == nil then
		return false
	end
	return string.match(origin, pattern) ~= nil
end, function(self, origin, pattern)
	if origin == nil or pattern == nil then
		return false
	end
	return string.match(origin, pattern) ~= nil
end
_ENV, DefaultMatcher.__index = nil, DefaultMatcher
;(nil)["attr="] = EqualizationComparator
DefaultMatcher.comparators, (nil)["attr.*="] = nil, RegexpComparator
function DefaultMatcher:match(cond, node)
	local op, args = unpack(cond)
	if op == "or" then
		for _, arg in ipairs(args) do
			if self:match(arg, node) then
				return true
			end
		end
		return false
	end
	if op == "and" then
		for _, arg in ipairs(args) do
			if not self:match(arg, node) then
				return false
			end
		end
		return true
	end
	comparator = self.comparators[op]
	if comparator ~= nil then
		local attribute, value = unpack(args)
		local targetValue = node:getAttr(attribute)
		return comparator:compare(targetValue, value)
	end
	return false
end
return DefaultMatcher

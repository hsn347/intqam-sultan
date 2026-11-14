local cloneCache = class("cloneCache")
function cloneCache:ctor()
	self.cache, _UPVALUE0_ = nil, nil
end
function cloneCache:addNode(name, node)
	if name and node then
		node:retain()
		self.cache[name] = node
	end
end
function cloneCache:getNode(name)
	return self.cache[name]
end
function cloneCache:removeNode(name)
	if self.cache[name] then
		self.cache[name]:release()
		self.cache[name] = nil
	end
end
function cloneCache:getClone(name)
	if self.cache[name] then
		return self.cache[name]:clone()
	else
		return nil
	end
end
function cloneCache:clean()
	for name, node in pairs(self.cache) do
		node:release()
	end
	self.cache, _ENV = pairs(self.cache)
end
return cloneCache

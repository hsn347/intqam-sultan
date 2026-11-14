local nodeCache = class("nodeCache")
function nodeCache:ctor()
	self.cache, _UPVALUE0_ = nil, nil
end
function nodeCache:addNode(node)
	if node then
		if self.cache[node] then
			print("[nodeCache]addNode repeat", node)
			return
		end
		node:retain()
		self.cache[node] = node
	end
end
function nodeCache:getNode()
	local index, value = next(self.cache)
	if index and value then
		local node = value
		self.cache[index] = nil
		return node
	end
end
function nodeCache:clean()
	for _, node in pairs(self.cache) do
		node:cleanup()
		node:release()
	end
	self.cache, _ENV = pairs(self.cache)
end
return nodeCache

local chatNodeCache = class("chatNodeCache")
function chatNodeCache:ctor()
	self.cache, _UPVALUE0_ = nil, nil
end
function chatNodeCache:init()
end
function chatNodeCache:add(node)
	if node then
		node:setVisible(false)
		self:addNode(node)
	end
end
function chatNodeCache:get()
	local node, needRelease = self:getNode()
	if tolua.isnull(node) then
		return nil
	end
	if node then
		node:setVisible(true)
	end
	return node, needRelease
end
function chatNodeCache:addNode(node, needRetain)
	if node then
		if self.cache[node] then
			return
		end
		if node and node.retainOnCache then
			node:retain()
		end
		self.cache[node] = node
	end
end
function chatNodeCache:getNode()
	local index, value = next(self.cache)
	if index and value then
		local node = value
		local needReleaes = false
		self.cache[index] = nil
		if node and node.retainOnCache then
			needReleaes = true
		end
		return node, needReleaes
	end
end
function chatNodeCache:clean()
	for _, node in pairs(self.cache) do
		if not tolua.isnull(node) then
			if node.cleanup then
				node:cleanup()
			end
			if node and node.retainOnCache then
				node:release()
			end
		end
	end
	self.cache, _ENV = pairs(self.cache)
end
return chatNodeCache

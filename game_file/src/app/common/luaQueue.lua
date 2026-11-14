local luaQueue = class("luaQueue")
function luaQueue:ctor(...)
	self.key2Node, _UPVALUE0_ = nil, nil
	self.cacheHead = nil
	self.cacheTail = nil
	self.count = 0
end
function luaQueue:get(key)
	if not self.cacheHead then
		return
	end
	local node = self.key2Node[key]
	if node then
		return node.value
	end
end
function luaQueue:head()
	local node = self.cacheHead
	if node then
		return node.key, node.value
	end
end
function luaQueue:tail()
	local node = self.cacheTail
	if node then
		return node.key, node.value
	end
end
function luaQueue:pushFront(key, value)
	if not self.cacheHead then
		_UPVALUE0_ = self.cacheHead
		self.cacheHead.key = key
		local self.cacheHead.value, node = value, self.cacheHead
		self.key2Node[key] = node
		self.cacheHead = node
		self.cacheTail = self.cacheHead
		self.count = self.count + 1
	else
		local node = self.key2Node[key]
		if not node then
			_UPVALUE0_ = self.count + 1
			;(self.count + 1).key = key
			;(self.count + 1).value = value
			;(self.count + 1).nextNode = self.cacheHead
			local (self.count + 1).preNode, node = nil, self.count + 1
			self.cacheHead.preNode = node
			self.cacheHead = node
			self.key2Node[key] = node
			self.count = self.count + 1
		else
			node.value = value
			if node == self.cacheHead then
				return
			end
			if node == self.cacheTail then
				self.cacheTail = node.preNode
			end
			node.preNode.nextNode = node.nextNode
			if node.nextNode then
				node.nextNode.preNode = node.preNode
			end
			node.nextNode = self.cacheHead
			node.preNode = nil
			self.cacheHead.preNode = node
			self.cacheHead = node
		end
	end
end
function luaQueue:popBack()
	local key = self:tail()
	if key then
		return self:remove(key)
	end
end
function luaQueue:remove(key)
	if not self.cacheHead then
		return
	end
	local node = self.key2Node[key]
	if not node then
		return
	end
	if node == self.cacheHead then
		self.cacheHead = node.nextNode
	end
	if node == self.cacheTail then
		self.cacheTail = node.preNode
	end
	if node.nextNode then
		node.nextNode.preNode = node.preNode
	end
	if node.preNode then
		node.preNode.nextNode = node.nextNode
	end
	self.key2Node[key] = nil
	self.count = self.count - 1
	return node.value
end
function luaQueue:size()
	return self.count
end
function luaQueue:printCache()
	local node = self.cacheTail
	while node do
		print(node.key)
		print(node.value)
		node = node.preNode
	end
	print("------------------------------", self.count)
end
return luaQueue

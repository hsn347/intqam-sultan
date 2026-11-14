local _ENV, panelLRUCache
panelLRUCache.__index = panelLRUCache
local _ENV, NodeLRU
NodeLRU.__index = NodeLRU
function NodeLRU:new(panelName, panel)
	_ENV = nil
	;(nil).panelName = panelName
	;(nil).prev = nil
	;(nil).next = nil
	local node = setmetatable(nil, NodeLRU)
	node:setPanel(panel)
	return node
end
function NodeLRU:setPanel(panel)
	panel:setIsKeepReference(true)
	panel:oldRemoveFromParent()
	self.panel = panel
end
function panelLRUCache:new(capacity)
	_ENV = nil
	;(nil).cache, _ENV, (nil).capacity = nil, nil, capacity
	;(nil).head = nil
	;(nil).tail = nil
	local instance = setmetatable(nil, panelLRUCache)
	return instance
end
function panelLRUCache:get(panelName)
	local node = self.cache[panelName]
	if not node then
		return nil
	end
	self:remove(node)
	return node.panel
end
function panelLRUCache:put(panelName, panel)
	local node = self.cache[panelName]
	if node then
		self:remove(node, true)
	end
	if table.nums(self.cache) >= self.capacity then
		self:removeTail()
	end
	node = NodeLRU:new(panelName, panel)
	self:addToHead(node)
	self.cache[panelName] = node
end
function panelLRUCache:moveToHead(node)
	self:remove(node)
	self:addToHead(node)
end
function panelLRUCache:addToHead(node)
	node.prev = nil
	node.next = self.head
	if self.head then
		self.head.prev = node
	end
	self.head = node
	if not self.tail then
		self.tail = node
	end
end
function panelLRUCache:remove(node, clean)
	if node.prev then
		node.prev.next = node.next
	else
		self.head = node.next
	end
	if node.next then
		node.next.prev = node.prev
	else
		self.tail = node.prev
	end
	self.cache[node.panelName] = nil
	if clean and not tolua.isnull(node.panel) then
		if node.panel.onCleanByCache then
			node.panel:onCleanByCache()
		end
		node.panel:setIsKeepReference(false)
	end
end
function panelLRUCache:removeTail()
	if self.tail then
		self:remove(self.tail, true)
	end
end
function panelLRUCache:setCapacity(newCapacity)
	self.capacity = newCapacity
	while table.nums(self.cache) > self.capacity do
		self:removeTail()
	end
end
function panelLRUCache:clear()
	for _, node in pairs(self.cache) do
		if not tolua.isnull(node.panel) then
			if node.panel.onCleanByCache then
				node.panel:onCleanByCache()
			end
			node.panel:setIsKeepReference(false)
		end
	end
	self.cache, _ENV = pairs(self.cache)
	self.head = nil
	self.tail = nil
end
return panelLRUCache

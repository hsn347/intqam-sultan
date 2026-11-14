local linkList = class("linkList")
function linkList:ctor(datakey, comp)
	self.datakey = datakey or "data"
	self.compare_ = comp
	self.size_ = 0
end
local insertNodePre = function(self, newNode, node)
	newNode.pre = node.pre
	newNode.next = node
	local preNode = node.pre
	node.pre = newNode
	if preNode then
		preNode.next = newNode
	else
		self.first_ = newNode
	end
end
local insertNodeNext = function(self, newNode, node)
	newNode.pre = node
	local nextNode = node.next
	newNode.next = nextNode
	node.next = newNode
	if nextNode then
		nextNode.pre = newNode
	else
		self.last_ = newNode
	end
end
local callCompare = function(self, newNode, oldNode)
	if "function" == type(self.compare_) then
		return self.compare_(newNode, oldNode)
	end
end
function linkList.createNode(data, datakey)
	local _UPVALUE0_, key = nil, datakey or "data"
	;(nil).pre = nil
	;(nil).next = nil
	;(nil)[key] = data
	;(nil).tag = nil
	return nil
end
function linkList:newNode(data, datakey)
	local _UPVALUE0_, key = nil, datakey or self.datakey
	;(nil).pre = nil
	;(nil).next = nil
	;(nil)[key] = data
	return nil
end
function linkList:setCompare(com)
	self.compare_ = com
end
function linkList:insert(node)
	if node.pre or node.next or node == self:front() then
		serviceFunctions.exception("linklist:insert: invalid node!")
		return
	end
	local isInsert = false
	local newNode = node
	if not self:empty() then
		local curNode = self:front()
		while curNode do
			if callCompare(self, newNode, curNode) then
				insertNodePre(self, newNode, curNode)
				self.size_ = self.size_ + 1
				isInsert = true
				break
			elseif curNode.next then
				curNode = curNode.next
			else
				break
			end
		end
		if not isInsert then
			insertNodeNext(self, newNode, curNode)
			self.size_ = self.size_ + 1
		end
	else
		self.first_ = newNode
		self.last_ = newNode
		self.size_ = 1
		return newNode
	end
end
function linkList:remove(node)
	local preNode = node.pre
	local nextNode = node.next
	node.pre = nil
	node.next = nil
	if preNode and nextNode then
		preNode.next = nextNode
		nextNode.pre = preNode
		self.size_ = self.size_ - 1
	elseif preNode and not nextNode then
		preNode.next = nil
		self.last_ = preNode
		self.size_ = self.size_ - 1
	elseif not preNode and nextNode then
		nextNode.pre = nil
		self.first_ = nextNode
		self.size_ = self.size_ - 1
	elseif self.first_ == node then
		self.first_ = nil
		self.last_ = nil
		self.size_ = 0
	elseif not node.pre and not node.next then
		serviceFunctions.exception("linklist:remove: invalid node!")
		return
	end
end
function linkList:clean()
	self.first_ = nil
	self.last_ = nil
	self.size_ = 0
end
function linkList:front()
	return self.first_
end
function linkList:last()
	return self.last_
end
function linkList:pop()
	local node = self.first_
	self:remove(self.first_)
	return node
end
function linkList:sort()
	local nextNode = self.first_
	self:clean()
	while nextNode do
		local node = nextNode
		nextNode = nextNode.next
		node.pre = nil
		node.next = nil
		self:insert(node)
	end
end
function linkList:getNode(pos)
	if pos and pos <= self:size() then
		local i = 1
		local node = self:front()
		while node do
			if pos == i then
				return node
			end
			i = i + 1
			node = node.next
		end
	end
end
function linkList:getPos(node)
	if node and not self:empty() then
		local curNode = self:front()
		local i = 1
		while curNode do
			if node == curNode then
				return i
			end
			i = i + 1
			curNode = curNode.next
		end
	end
end
function linkList:removePos(pos)
	local node = self:getNode(pos)
	if node then
		self:remove(node)
	end
	return node
end
function linkList:empty()
	if not self.first_ and self.size_ > 0 then
		self.size_ = 0
	end
	if not self.first_ and self.size_ <= 0 then
		return true
	end
	return false
end
function linkList:size()
	return self.size_
end
function linkList:dump(title)
	print("============" .. (title or "linklist") .. "===========")
	local dumpNode = function(node, title)
		if not node then
			print("node is nil")
		elseif node[self.datakey].dump then
			node[self.datakey]:dump(title)
		else
			title = title and title .. ":" or ""
			print(title, node)
			print("\n")
		end
	end
	if not self.first_ then
		print([[
list is empty!


]])
		return
	end
	dumpNode(self.first_, "first node")
	local node = self.first_
	local i = 2
	while node and node.next do
		node = node.next
		dumpNode(node, "the " .. i .. " node!")
		i = i + 1
	end
	print([[



]])
end
return linkList

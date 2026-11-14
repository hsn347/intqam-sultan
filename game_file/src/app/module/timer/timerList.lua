local linkList = include("linkList")
local timerClass = include("timer")
local timerList = class("timerList")
local timerCount = 0
local compare = function(newNode, oldNode)
	local newTimer, oldTimer = newNode.timer, oldNode.timer
	return newTimer:getRemainTime() < oldTimer:getRemainTime()
end
local instance
function timerList.sharedInstance()
	return instance
end
function timerList:ctor()
	self.timerList_ = linkList.new("timer")
	self.timerList_:setCompare(compare)
	self.cache, linkList = self.timerList_.setCompare, self.timerList_.setCompare
end
function timerList:insertNode(node)
	if node.timer:getRemainTime() <= 35 then
		self.timerList_:insert(node)
	else
		self.cache[node] = 1
	end
end
function timerList:createTimer(time, listener, count)
	if "number" ~= type(time) then
		serviceFunctions.exception("timerList:createTimer: time ~= number!")
		return
	end
	if "function" ~= type(listener) then
		serviceFunctions.exception("timerList:createTimer: listener ~= function")
	end
	if count then
		if "number" == type(count) then
			if count <= 0 then
				serviceFunctions.exception("timerList:createTimer: count <= 0")
				return
			end
		else
			serviceFunctions.exception("timerList:createTimer: count ~= number!")
			return
		end
	end
	local timer = timerClass.new(time, listener, count)
	if not timer then
		serviceFunctions.exception("timerList:createTimer: create timer failed")
		return
	end
	local node = self.timerList_:newNode(timer, "timer")
	if not node then
		serviceFunctions.exception("timerList:createTimer: create node failed")
		return
	end
	self:insertNode(node)
	return true, node
end
function timerList:restartTimer(node, time, count)
	if not node then
		serviceFunctions.exception("timerList:cancelTimer: node == nil!")
		return
	end
	if node.next or node.pre or node == self.timerList_:front() then
		self.timerList_:remove(node)
	end
	self.cache[node] = nil
	local timer = node.timer
	timer:modifyTime(time)
	timer:setCount(count or 1)
	self:insertNode(node)
	return true
end
function timerList:cancelTimer(node)
	if not node then
		serviceFunctions.exception("timerList:cancelTimer: node == nil!")
		return
	end
	if self.cache[node] then
		self.cache[node] = nil
		return true
	end
	if not node.next and not node.pre and node ~= self.timerList_:front() then
		print("timerList:cancelTimer: invalid node!")
		return
	end
	if node.timer:hasDone() then
		node.timer:dump()
		serviceFunctions.exception("timerList:cancelTimer: node has done!")
		return
	end
	self.timerList_:remove(node)
	return true
end
function timerList:dispatchRightNow(node)
	if self:cancelTimer(node) then
		node.timer:dispatchListener()
		if not node.timer:hasDone() then
			node.timer:resetStartTime()
			self:insertNode(node)
		end
	end
end
function timerList:modifyTime(node, time)
	if not node then
		serviceFunctions.exception("timerList:modifyTime: node == nil!")
		return
	end
	if "number" ~= type(time) then
		serviceFunctions.exception("timerList:modifyTime: time ~= number!")
		return
	end
	if node.timer:hasDone() then
		node.timer:dump()
		self:dump()
		serviceFunctions.exception("timerList:modifyTime: node has done!")
		return
	end
	if self.cache[node] then
		self.cache[node] = nil
	else
		self.timerList_:remove(node)
	end
	local timer = node.timer
	timer:modifyTime(time)
	self:insertNode(node)
end
function timerList:increaseTime(node, time)
	if not node then
		serviceFunctions.exception("timerList:increaseTime: node == nil!")
		return
	end
	if "number" ~= type(time) then
		serviceFunctions.exception("timerList:increaseTime: time ~= number!")
		return
	end
	if node.timer:hasDone() then
		node.timer:dump()
		self:dump()
		serviceFunctions.exception("timerList:increaseTime: node has done!")
		return
	end
	if self.cache[node] then
		self.cache[node] = nil
	else
		self.timerList_:remove(node)
	end
	local timer = node.timer
	timer:increaseTime(time)
	self:insertNode(node)
end
function timerList:decreaseTime(node, time)
	if not node then
		serviceFunctions.exception("timerList:decreaseTime: node == nil!")
		return
	end
	if "number" ~= type(time) then
		serviceFunctions.exception("timerList:decreaseTime: time ~= number!")
		return
	end
	if node.timer:hasDone() then
		node.timer:dump()
		self:dump()
		serviceFunctions.exception("timerList:decreaseTime: node has done!")
		return
	end
	if self.cache[node] then
		self.cache[node] = nil
	else
		self.timerList_:remove(node)
	end
	local timer = node.timer
	timer:decreaseTime(time)
	self:insertNode(node)
end
function timerList:initTimer()
	local updateTimeCall = function(dt)
		if 30 <= timerCount then
			if next(self.cache) then
				local timerCount, nodelist = next(self.cache), next(self.cache)
				for node, _ in pairs(self.cache) do
					if node.timer:getRemainTime() <= 35 then
						table.insert(nodelist, node)
					end
				end
				for i, node in ipairs(nodelist) do
					self.cache[node] = nil
					self.timerList_:insert(node)
				end
			end
		end
	end
	if not self.handle_time then
		self.handle_time = SoradCreateTimer(self, updateTimeCall)
	end
end
function timerList:cleanTimers()
	self.timerList_:clean()
	self.cache, _ENV = self.timerList_.clean, self.timerList_.clean
	if self.handle_time then
		SoraDManagerRemoveTimer(self, self.handle_time)
		self.handle_time = nil
	end
end
function timerList:update()
	local curNode = self.timerList_:front()
	if curNode then
		if curNode.timer:hasDone() then
			curNode.timer:dump()
			self:dump()
			serviceFunctions.exception("timerList:update: this node has done!")
			self.timerList_:remove(curNode)
			self:update()
			return
		end
		local remainTime = curNode.timer:getRemainTime()
		if remainTime <= 0 then
			self.timerList_:remove(curNode)
			curNode.timer:dispatchListener()
			if not curNode.timer:hasDone() then
				curNode.timer:resetStartTime()
				self.timerList_:insert(curNode)
			end
			self:update()
		end
	end
end
function timerList:dump(title)
	self.timerList_:dump(title)
end
return timerList

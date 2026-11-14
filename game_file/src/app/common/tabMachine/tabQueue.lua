local cocosContext = require("app.common.tabMachine.cocosContext")
local tabQueue = class("tabQueue", cocosContext)
_ENV = "tabQueue"
;("tabQueue").NONE = 0
;("tabQueue").REPLACE = 1
;("tabQueue").IGNORE = 2
tabQueue.DUPLICATE_ACTION, ("tabQueue").MERGE = "tabQueue", 3
function tabQueue:s1()
	self._queue, _UPVALUE0_ = nil, nil
end
function tabQueue:add(tab)
	local newTab = tab
	if tab.duplicateAction ~= nil and tab.duplicateAction ~= tabQueue.DUPLICATE_ACTION.NONE then
		for index, oldTab in ipairs(self._queue) do
			if oldTab.tag == tab.tag then
				if tab.duplicateAction == tabQueue.DUPLICATE_ACTION.IGNORE then
					return
				elseif tab.duplicateAction == tabQueue.DUPLICATE_ACTION.MERGE or tab.duplicateAction == tabQueue.DUPLICATE_ACTION.REPLACE then
					if tab.duplicateAction == tabQueue.DUPLICATE_ACTION.MERGE then
						newTab = tab.merge(tab, oldTab)
					end
					if newTab.priority == oldTab.priority then
						self._queue[index] = newTab
						newTab = nil
						break
					end
					table.remove(self._queue, index)
					break
				end
			end
		end
	end
	if newTab then
		self:_addToQueueByPriority(newTab)
	end
	if self:getCurTask() == nil then
		self:_startNextTask()
	end
end
function tabQueue:removeAllByTag(tag)
	local index = 1
	while index <= #self._queue do
		local tab = self._queue
		if tab.tag == tag then
			table.remove(self._queue, index)
		else
			index = index + 1
		end
	end
end
function tabQueue:_startNextTask()
	local len = #self._queue
	if 0 < len then
		local tab = self._queue[len]
		tab.remove(self._queue)
		self:call(tab, "t1")
	end
end
function tabQueue:t2()
	self:_startNextTask()
end
function tabQueue:getCurTask()
	return self:getSub("t1")
end
function tabQueue:_addToQueueByPriority(tab)
	local index = 1
	while index <= #self._queue do
		local oldTab = self._queue[index]
		if tab.priority > oldTab.priority then
			index = index + 1
		end
	end
	table.insert(self._queue, tab, index)
end
return tabQueue

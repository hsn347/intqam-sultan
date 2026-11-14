local Scheduler = class("Scheduler")
local _ENV, handler_pool = "Scheduler", "Scheduler"
local createHandler = function()
	local handler
	if 0 < #handler_pool then
		handler = table.remove(handler_pool)
	else
		handler, handler_pool = table.remove(handler_pool), table.remove(handler_pool)
	end
	return handler
end
local recycleHandler = function(handler)
	handler.callback = nil
	handler.isMarkDelete = nil
	table.insert(handler_pool, handler)
end
function Scheduler:ctor()
	self.toDelete, _UPVALUE0_, self.dicHandlers, _UPVALUE0_, self.handlers, _UPVALUE0_, self.currentEntryId = nil, nil, nil, nil, nil, nil, 0
end
function Scheduler:scheduleScriptFunc(callback, interval, paused, autostoperror)
	assert(not paused, "Scheduler:scheduleScriptFunc() - paused not supported")
	local entryId = self.currentEntryId + 1
	self.currentEntryId = entryId
	local handler = createHandler()
	handler.entryId = entryId
	handler.callback = callback
	handler.interval = interval or 0
	handler.elapsed = 0
	handler.autostop = autostoperror or false
	table.insert(self.handlers, handler)
	self.dicHandlers[entryId] = handler
	return entryId
end
function Scheduler:unscheduleScriptEntry(entryId)
	if entryId then
		local handler = self.dicHandlers[entryId]
		if handler then
			handler.isMarkDelete = true
		end
	else
		print_error("Scheduler:unscheduleScriptEntry timer is nil")
	end
end
local __traceback
local __G__TRACKBACK__TIMER = function(errorMessage)
	if __traceback then
		__traceback(errorMessage)
	end
end
function Scheduler:update(dt)
	if self.timeScale then
		dt = dt * self.timeScale
	end
	for i = #self.toDelete, 1, -1 do
		self.toDelete[i] = nil
	end
	for i = 1, #self.handlers do
		local handler = self.handlers[i]
		if handler.isMarkDelete then
			table.insert(self.toDelete, i)
		else
			handler.elapsed = handler.elapsed + dt
			if handler.elapsed >= handler.interval then
				local status, err = xpcall(handler.callback, __G__TRACKBACK__TIMER, dt)
				if not status and handler.autostop then
					handler.isMarkDelete = true
					table.insert(self.toDelete, i)
				end
				handler.elapsed = handler.elapsed - handler.interval
			end
		end
	end
	for i = #self.toDelete, 1, -1 do
		local deleteIndex = self.toDelete[i]
		local handler = self.handlers[deleteIndex]
		self.dicHandlers[handler.entryId] = nil
		recycleHandler(handler)
		table.remove(self.handlers, deleteIndex)
		self.toDelete[i] = nil
	end
end
function Scheduler:getTimerScale()
	return self.timeScale
end
function Scheduler:setTimeScale(timeScale)
	self.timeScale = timeScale
end
function Scheduler:startTimer()
	local timerManager = require("framework.timer.timerManager")
	local timer = timerManager:getTimer(0, function(dt)
		self:update(dt)
	end)
	timer:start()
	self.__timer = timer
end
function Scheduler:retain()
end
function Scheduler:release()
end
return Scheduler

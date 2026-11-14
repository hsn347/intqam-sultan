local _ENV, scheduler
local sharedScheduler = cc.Director:getInstance():getScheduler()
if not sharedScheduler.scheduleScriptFuncNew then
	function sharedScheduler:scheduleScriptFuncNew(listener, interval, pause, priority, autostoperror)
		return self:scheduleScriptFunc(listener, interval, pause, autostoperror)
	end
end
function scheduler.scheduleUpdateGlobal(listener, priority, autostoperror)
	if priority then
		return sharedScheduler:scheduleScriptFuncNew(listener, 0, false, priority, autostoperror)
	end
	return sharedScheduler:scheduleScriptFunc(listener, 0, false, autostoperror)
end
function scheduler.scheduleUpdateGlobalCustom(customScheduler, listener)
	print("scheduler.scheduleUpdateGlobalCustom(customScheduler, listener)")
	print("customScheduler = ", customScheduler, ", sharedScheduler = ", sharedScheduler)
	return customScheduler:scheduleScriptFunc(listener, 0, false)
end
function scheduler.scheduleGlobal(listener, interval, priority, autostoperror)
	if priority then
		return sharedScheduler:scheduleScriptFuncNew(listener, interval, false, priority, autostoperror)
	end
	return sharedScheduler:scheduleScriptFunc(listener, interval, false, autostoperror)
end
function scheduler.scheduleGlobalCustom(customScheduler, listener, interval, autostoperror)
	print("scheduler.scheduleGlobalCustom(customScheduler, listener)")
	print("customScheduler = ", customScheduler, ", sharedScheduler = ", sharedScheduler)
	return customScheduler:scheduleScriptFunc(listener, interval, false, autostoperror)
end
function scheduler.unscheduleGlobal(handle)
	sharedScheduler:unscheduleScriptEntry(handle)
end
function scheduler.unscheduleGlobalCustom(customScheduler, handle)
	customScheduler:unscheduleScriptEntry(handle)
end
function scheduler.performWithDelayGlobal(listener, time)
	local handle
	handle = scheduler.scheduleGlobal(function()
		scheduler.unscheduleGlobal(handle)
		listener()
	end, time, false)
	return handle
end
return scheduler

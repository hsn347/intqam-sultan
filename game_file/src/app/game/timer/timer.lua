local schedulerTime = require(cc.PACKAGE_NAME .. ".scheduler")
local timer = class("timer", function(timeUpdateListener)
	local timeHandle = schedulerTime.scheduleGlobal(function(dt)
		timeUpdateListener()
	end, 1.0)
	return timeHandle
end)
function timer:ctor()
	self.timeNumber = 0
	self.timeEndListener = nil
	self.timeUpdateListener = nil
end
return timer

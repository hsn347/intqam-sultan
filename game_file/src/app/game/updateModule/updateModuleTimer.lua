local updateModuleTimer = class("updateModuleTimer")
function updateModuleTimer:ctor()
end
function updateModuleTimer:resetData()
	if self.schedulerId ~= nil then
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerId)
		self.schedulerId = nil
	end
end
function updateModuleTimer:retry(callBackHandler, time)
	assert(callBackHandler and type(callBackHandler) == "function")
	self:resetData()
	local callBackTimer = function()
		self:resetData()
		callBackHandler()
	end
	self.schedulerId = cc.Director:getInstance():getScheduler():scheduleScriptFunc(callBackTimer, time or 2, false)
end
return updateModuleTimer

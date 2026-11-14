local _ENV, timerManager
local Time = require("framework.timer.Time")
local Timer = require("framework.timer.timer")
function timerManager:init()
	self:startup()
end
function timerManager:delayRecycle(timerList)
	timerList:delayRecycle(self.__pool)
end
function timerManager:updateTimer(timerList, is_fixed)
	timerList:update(is_fixed)
	timerList:delayRecycle(self.__pool)
end
function timerManager:updateBeat()
	self:updateTimer(self.__update_timer, false)
end
function timerManager:lateUpdateBeat()
	self:updateTimer(self.__lateupdate_timer, false)
end
function timerManager:fixedUpdateBeat()
	self:updateTimer(self.__fixedupdate_timer, true)
end
function timerManager:coUpdateBeat()
	self:updateTimer(self.__coupdate_timer, false)
end
function timerManager:coLateUpdateBeat()
	self:updateTimer(self.__colateupdate_timer, false)
end
function timerManager:coFixedUpdateBeat()
	self:updateTimer(self.__cofixedupdate_timer, true)
end
function timerManager:startup()
	local timerList = require("framework.timer.timerList")
	self.__update_timer = timerList.new()
	self.__lateupdate_timer = timerList.new()
	self.__fixedupdate_timer = timerList.new()
	self.__coupdate_timer = timerList.new()
	self.__colateupdate_timer = timerList.new()
	self.__pool, _ENV, self.__cofixedupdate_timer = timerList.new(), timerList.new(), timerList.new()
end
function timerManager:dispose()
	if self.__update_timer ~= nil then
		self.__update_timer:dispose()
		self.__update_timer = nil
	end
	if self.__lateupdate_timer ~= nil then
		self.__lateupdate_timer:dispose()
		self.__lateupdate_timer = nil
	end
	if self.__fixedupdate_timer ~= nil then
		self.__fixedupdate_timer:dispose()
		self.__fixedupdate_timer = nil
	end
	if self.__coupdate_timer ~= nil then
		self.__coupdate_timer:dispose()
		self.__coupdate_timer = nil
	end
	if self.__colateupdate_timer ~= nil then
		self.__colateupdate_timer:dispose()
		self.__colateupdate_timer = nil
	end
	if self.__cofixedupdate_timer ~= nil then
		self.__cofixedupdate_timer:dispose()
		self.__cofixedupdate_timer = nil
	end
end
function timerManager:cleanup()
	self.__update_timer = nil
	self.__lateupdate_timer = nil
	self.__fixedupdate_timer = nil
	self.__coupdate_timer = nil
	self.__colateupdate_timer = nil
	self.__pool, _UPVALUE0_, self.__cofixedupdate_timer = nil, nil, nil
end
function timerManager:innerGetTimer(delay, func, params)
	local timer
	if #self.__pool > 0 then
		timer = table.remove(self.__pool)
		if delay and func then
			timer:init(delay, func, params)
		end
	else
		timer = Timer.new(delay, func, params)
	end
	return timer
end
function timerManager:getTimer_imp(timerList, delay, func, params)
	local timer = self:innerGetTimer(delay, func, params)
	timerList:addTimer(timer)
	return timer
end
function timerManager:getTimer(delay, func, params)
	return self:getTimer_imp(self.__update_timer, delay, func, params)
end
function timerManager:getLateTimer(delay, func, params)
	return self:getTimer_imp(self.__lateupdate_timer, delay, func, params)
end
function timerManager:getFixedTimer(delay, func, params)
	return self:getTimer_imp(self.__fixedupdate_timer, delay, func, params)
end
function timerManager:getCoTimer(delay, func, params)
	return self:getTimer_imp(self.__coupdate_timer, delay, func, params)
end
function timerManager:getCoLateTimer(delay, func, params)
	return self:getTimer_imp(self.__colateupdate_timer, delay, func, params)
end
function timerManager:getCoFixedTimer(delay, func, params)
	return self:getTimer_imp(self.__cofixedupdate_timer, delay, func, params)
end
function _G.Update(deltaTime, unscaledDeltaTime)
	Time:SetDeltaTime(deltaTime, unscaledDeltaTime)
	timerManager:updateBeat()
	timerManager:coUpdateBeat()
end
function _G.LateUpdate()
	timerManager:lateUpdateBeat()
	timerManager:coLateUpdateBeat()
	Time:SetFrameCount()
end
function _G.FixedUpdate(fixedDeltaTime)
	Time:SetFixedDelta(fixedDeltaTime)
	timerManager:fixedUpdateBeat()
	timerManager:coFixedUpdateBeat()
end
timerManager:init()
return timerManager

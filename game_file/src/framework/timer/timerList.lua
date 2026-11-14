local timerList = class("timerList")
function timerList:ctor()
	self.__update_toadd, _UPVALUE0_, self.__update_timer, _UPVALUE0_ = nil, nil, nil, nil
end
function timerList:delayRecycle(pool)
	for timer, _ in pairs(self.__update_timer) do
		if timer:isOver() then
			timer:stop()
			self.__update_timer[timer] = nil
		end
	end
end
function timerList:update(is_fixed)
	for timer, _ in pairs(self.__update_toadd) do
		self.__update_timer[timer] = true
		self.__update_toadd[timer] = nil
	end
	for timer, _ in pairs(self.__update_timer) do
		timer:update(is_fixed)
	end
end
function timerList:dispose()
end
function timerList:cleanup()
	self.__update_toadd, _UPVALUE0_, self.__update_timer, _UPVALUE0_ = nil, nil, nil, nil
end
function timerList:addTimer(timer)
	self.__update_toadd[timer] = true
	return timer
end
return timerList

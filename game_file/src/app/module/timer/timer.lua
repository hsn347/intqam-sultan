local timer = class("timer")
timer.totalTime_ = nil
timer.startTime_ = nil
timer.listener_ = nil
timer.count_ = nil
function timer:ctor(time, listener, count)
	self:modifyTime(time)
	self:resetStartTime()
	self:setListener(listener)
	count = count or 1
	self:setCount(count)
end
function timer:getRemainTime(curTime)
	curTime = curTime or serviceFunctions.systemTime()
	local passTime = curTime - self.startTime_
	local remainTime = self.totalTime_ - passTime
	if remainTime < 0 then
		remainTime = 0
	end
	return remainTime
end
function timer:getFinishTime()
	return self.totalTime_ + self.startTime_
end
function timer:modifyTime(time)
	assert("number" == type(time), "the time is not a number! it is the " .. type(time))
	self:resetStartTime()
	self.totalTime_ = time
end
function timer:resetStartTime(time)
	self.startTime_ = time or serviceFunctions.systemTime()
end
function timer:getStartTime()
	return self.startTime_
end
function timer:getTotalTime()
	return self.totalTime_
end
function timer:increaseTime(time)
	assert("number" == type(time), "the time is not a number! it is the " .. type(time))
	self.totalTime_ = self.totalTime_ + time
end
function timer:decreaseTime(time)
	assert("number" == type(time), "the time is not a number! it is the " .. type(time))
	self.totalTime_ = self.totalTime_ - time
end
function timer:setListener(listener)
	self.listener_ = listener
end
function timer:dispatchListener()
	self.count_ = self.count_ - 1
	if "function" == type(self.listener_) then
		self.listener_(self.count_)
	else
		print("timer listener is not the function!")
	end
end
function timer:setCount(count)
	if count and 0 <= count then
		self.count_ = count
	end
end
function timer:getCount()
	return self.count_
end
function timer:hasDone()
	if self.count_ and self.count_ >= 1 then
		return false
	end
	return true
end
function timer:dump(title)
	print("========" .. (title or "timer") .. "=======")
	print("totalTime = ", self.totalTime_)
	print("startTime = ", self.startTime_)
	print("remainTime = ", self:getRemainTime())
	print("listener = ", self.listener_)
	print("count = ", self.count_)
	print("\n")
end
return timer

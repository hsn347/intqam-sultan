local Log = CS.Sultan.Core.Log
local Time = require("framework.timer.Time")
local Timer = class("Timer")
local _ENV, default_params = "Timer", "Timer"
function Timer:ctor(delay, func, params)
	self.target, _UPVALUE0_ = nil, nil
	if delay and func then
		self:init(delay, func, params)
	end
end
function Timer:init(delay, func, params)
	assert(type(delay) == "number" and 0 <= delay)
	assert(func ~= nil)
	params = params or default_params
	self.delay = delay
	self.target.func = func
	self.target.obj = params.obj
	self.one_shot = params.one_shot
	self.use_frame = params.use_frame
	self.unscaled = params.unscaled
	self.started = params.started or false
	self.left = delay
	self.over = false
	self.obj_not_nil = params.obj and true or false
	self.start_frame_count = Time.frameCount
end
local __traceback
local __G__TRACKBACK__TIMER = function(errorMessage)
	if __traceback then
		__traceback(errorMessage)
	end
end
function Timer:update(is_fixed)
	if not self.started or self.over then
		return
	end
	local timeup, delta
	if self.use_frame then
		timeup = Time.frameCount >= self.start_frame_count + self.delay
	else
		if is_fixed then
			delta = Time.fixedDeltaTime
		else
			delta = not self.unscaled and Time.deltaTime or Time.unscaledDeltaTime
		end
		self.left = self.left - delta
		timeup = self.left <= 0
	end
	if timeup then
		if self.target.func ~= nil then
			if not self.one_shot then
				if not self.use_frame then
					self.left = self.delay + self.left
				end
				self.start_frame_count = Time.frameCount
			else
				self.over = true
			end
			local status, err
			if self.obj_not_nil then
				status, err = xpcall(self.target.func, __G__TRACKBACK__TIMER, self.target.obj, delta)
			else
				status, err = xpcall(self.target.func, __G__TRACKBACK__TIMER, delta)
			end
			if not status then
				Log.Err(err)
			end
		else
			self.over = true
		end
	end
end
function Timer:start()
	if self.over then
		print("You can't start a overed timer, try add a new one!")
	end
	if not self.started then
		self.left = self.delay
		self.started = true
		self.start_frame_count = Time.frameCount
	end
end
function Timer:pause()
	self.started = false
end
function Timer:resume()
	self.started = true
end
function Timer:stop()
	self.left = 0
	self.one_shot = false
	self.target.func = nil
	self.target.obj = nil
	self.use_frame = false
	self.unscaled = false
	self.started = false
	self.over = true
end
function Timer:reset()
	self.left = self.delay
	self.start_frame_count = Time.frameCount
end
function Timer:isOver()
	if self.target.func == nil then
		return true
	end
	if self.obj_not_nil and self.target.obj == nil then
		return true
	end
	return self.over
end
return Timer

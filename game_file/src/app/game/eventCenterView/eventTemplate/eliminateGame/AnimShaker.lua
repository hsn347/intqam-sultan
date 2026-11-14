local AnimShaker = class("AnimShaker")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
function AnimShaker:ctor(target, time, params)
	self.init_x = 0
	self.init_y = 0
	self.diff_x = 0
	self.diff_y = 0
	self.diff_max = 8
	self.interval = 0.01
	self.totalTime = 0
	self.time = 0
	if params then
		if params.diff_max then
			self.diff_max = params.diff_max
		end
		if params.interval then
			self.interval = params.interval
		end
	end
	self.target = target
	self.init_x = target:getPositionX()
	self.init_y = target:getPositionY()
	self.totalTime = time
	self.target.animShaker = self
end
function AnimShaker:run()
	self.scheduler = scheduler.scheduleGlobal(function(ft)
		self:shake(ft)
	end, self.interval)
end
function AnimShaker:shake(ft)
	if self.time >= self.totalTime or tolua.isnull(self.target) then
		self:stop()
		return
	end
	self.time = self.time + ft
	self.diff_x = math.random(-self.diff_max, self.diff_max) * math.random()
	self.diff_y = math.random(-self.diff_max, self.diff_max) * math.random()
	self.target:setPosition(cc.p(self.init_x + self.diff_x, self.init_y + self.diff_y))
end
function AnimShaker:stop()
	if self.scheduler then
		self.time = 0
		scheduler.unscheduleGlobal(self.scheduler)
		if not tolua.isnull(self.target) then
			self.target:setPosition(cc.p(self.init_x, self.init_y))
		end
		self.scheduler = nil
		self.target.animShaker = nil
	end
end
return AnimShaker

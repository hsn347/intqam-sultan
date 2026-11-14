local easeFunctions = include("easeFunctions")
local commonScoreBar = class("commonScoreBar", function(target)
	if target == nil then
		print("该类只用于控制")
	end
	return target
end)
function commonScoreBar:ctor()
	self:setNodeEventEnabled(true)
	self.numFrom = 0
	self.numTo = 0
	self.duration = 0
	self.from = 0
	self.to = 0
	self.accuTime = 0
	self.easeType = "outSine"
end
function commonScoreBar:runScoreAnimation(numFrom, numTo, numMax, duration)
	self.numFrom = numFrom
	self.numTo = numTo
	self.numMax = numMax
	self.from = math.floor(self.numFrom / self.numMax * 100)
	self.to = math.ceil(self.numTo / self.numMax * 100)
	self.from = math.min(math.max(self.from, 0), 100)
	self.to = math.min(math.max(self.to, 0), 100)
	self.duration = duration
	self.accuTime = 0
	self:beginTime()
end
function commonScoreBar:beginTime()
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
	end
	self.timeHandler = SoradCreateTimer(self, handler(self, self.updateTime), true)
	self:updateTime(0.0)
end
function commonScoreBar:setEaseType(easeType)
	self.easeType = easeType
end
function commonScoreBar:updateTime(dt)
	self.accuTime = self.accuTime + dt
	if self.accuTime > self.duration then
		self.accuTime = self.duration
	end
	local t = self.accuTime
	local b = 0
	local c = self.duration
	local d = self.duration
	local easeFunc = easeFunctions[self.easeType]
	easeFunc = easeFunc or easeFunctions.linear
	local timeFactor = easeFunc(t, b, c, d)
	local percent = timeFactor / (b + c)
	local numPercent = self.from + (self.to - self.from) * percent
	self:setPercent(numPercent)
	if 1 <= percent then
		self:endTime()
	end
end
function commonScoreBar:endTime()
	SoraDManagerRemoveTimer(self, self.timeHandler)
	self.timeHandler = nil
end
function commonScoreBar:onExit()
	print("commonScoreBar:onExit()")
	self:endTime()
end
function commonScoreBar:onCleanUp()
	print("commonScoreBar:onCleanUp()")
	SoraDManagerRemoveTimerByTarget(self)
end
return commonScoreBar

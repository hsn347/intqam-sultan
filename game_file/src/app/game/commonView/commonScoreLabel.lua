local easeFunctions = include("easeFunctions")
local commonScoreLabel = class("commonScoreLabel", function(target)
	if target == nil then
		print("该类只用于控制")
	end
	return target
end)
function commonScoreLabel:ctor()
	if self.setNodeEventEnabled then
		self:setNodeEventEnabled(true)
	else
		self:addEventListener(fgui.UIEventType.Exit, handler(self, self.onExit))
	end
	self.numFrom = 0
	self.numTo = 0
	self.duration = 0
	self.accuTime = 0
	self.easeType = "outSine"
	self.isFormatThousands = false
end
function commonScoreLabel:setEaseType(easeType)
	self.easeType = easeType
end
function commonScoreLabel:setIsFormatThousands(value)
	self.isFormatThousands = value
	if self.isFormatThousands then
		self.formatHandle = string.formatnumberthousands
	else
		self.formatHandle = tostring
	end
end
function commonScoreLabel:setUpdateHandler(handler)
	self.updateHandler = handler
end
function commonScoreLabel:runScoreAnimation(numFrom, numTo, duration)
	self.numFrom = numFrom
	self.numTo = numTo
	if self.numFrom == nil or self.numTo == nil then
		return
	end
	self.duration = duration or 0
	self.accuTime = 0
	self:beginTime()
end
function commonScoreLabel:beginTime()
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
	end
	self.timeHandler = SoradCreateTimer(self, handler(self, self.updateTime), true)
	self:updateTime(0.0)
end
function commonScoreLabel:updateTime(dt)
	self.accuTime = self.accuTime or 0
	self.duration = self.duration or 0
	self.accuTime = self.accuTime + dt
	self.numFrom = self.numFrom or 0
	self.numTo = self.numTo or 0
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
	local numText = math.floor(self.numFrom + (self.numTo - self.numFrom) * percent)
	if self.isFormatThousands then
		self:setString(string.formatnumberthousands(numText))
	else
		self:setString(tostring(numText))
	end
	if self.updateHandler then
		self.updateHandler(numText)
	end
	if 1 <= percent then
		self:endTime()
	end
end
function commonScoreLabel:setFormatHandle(formatHandle)
	self.formatHandle = formatHandle
end
function commonScoreLabel:endTime()
	SoraDManagerRemoveTimer(self, self.timeHandler)
	self.timeHandler = nil
end
function commonScoreLabel:onExit()
	print("commonScoreLabel:onExit()")
	self:endTime()
end
return commonScoreLabel

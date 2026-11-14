local baseComponent = require("fgui.base.baseComponent")
local ComMeter = fgui.extension_class(fgui.GProgressBar, baseComponent)
fgui.register_extension("ui://Activity_9001733/ComMeter", ComMeter)
local applyMeterState = function(self, value, rotation)
	self:setValue(math.max(0, math.min(value, 100)))
	self.fields.pointer:setRotation(rotation)
	self.currentValue = value
	self.currentRotation = rotation
end
function ComMeter:onInit()
	self:setMin(0)
	self:setMax(100)
	self.currentFactoryStage = 0
	self.targetFactoryStage = 0
	self.currentValue = 0
	self.currentRotation = -15
	self.progressHandle = nil
end
function ComMeter:onShow()
end
function ComMeter:stopMeterAnimation()
	if not self.progressHandle then
		return
	end
	SoraDManagerRemoveTimer(self, self.progressHandle)
	self.progressHandle = nil
end
function ComMeter:getMeterState(factoryStage)
	if factoryStage <= 0 then
		return 0, -15
	end
	factoryStage = math.max(1, math.min(factoryStage, 9))
	local progress = (factoryStage - 1) / 8
	local value = 28 + 52 * progress
	local rotation = -15 + -165 * progress
	return math.floor(value + 0.5), rotation
end
function ComMeter:playMeterAnimation(fromValue, fromRotation, toValue, toRotation)
	local valueDelta = math.abs(toValue - fromValue)
	local rotationDelta = math.abs(toRotation - fromRotation)
	if valueDelta <= 0 and rotationDelta <= 0 then
		applyMeterState(self, toValue, toRotation)
		return
	end
	local elapsed = 0
	local duration = math.max(0.18, 0.32 * math.max(valueDelta / 52, rotationDelta / 165))
	applyMeterState(self, fromValue, fromRotation)
	self.progressHandle = SoraDCreateTimerEx(self, function(dt)
		local progress = math.min(elapsed / duration, 1)
		local easedProgress = 1 - math.pow(1 - progress, 2)
		local value = fromValue + (toValue - fromValue) * easedProgress
		local rotation = fromRotation + (toRotation - fromRotation) * easedProgress
		applyMeterState(self, value, rotation)
		if 1 <= progress then
			self:stopMeterAnimation()
			applyMeterState(self, toValue, toRotation)
		end
	end, 0.02)
end
function ComMeter:initData(factoryStage)
	local value, rotation = self:getMeterState(factoryStage)
	self:setMin(0)
	self:setMax(100)
	if self.progressHandle and self.targetFactoryStage == factoryStage then
		return
	end
	local previousStage = self.targetFactoryStage
	self:stopMeterAnimation()
	if 0 < previousStage and factoryStage > previousStage then
		self.targetFactoryStage = factoryStage
		self:playMeterAnimation(self.currentValue, self.currentRotation, value, rotation)
	else
		applyMeterState(self, value, rotation)
		self.targetFactoryStage = factoryStage
	end
	self.currentFactoryStage = factoryStage
end
function ComMeter:onHide()
	self:stopMeterAnimation()
end
return ComMeter

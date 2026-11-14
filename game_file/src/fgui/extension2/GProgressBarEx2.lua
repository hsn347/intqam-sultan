local m = fgui.GProgressBar
function m:getBar()
	return self:getChild("bar") or self:getChild("bar_v")
end
function m:getDescription()
	return "GProgressBar"
end
function m:getPercent()
	local max = self:getMax()
	if max ~= 0 then
		return 100 * self:getValue() / max
	end
	return 0
end
function m:getPercentage(...)
	local max = self:getMax()
	if max ~= 0 then
		return self:getValue() / max
	end
	return 0
end
function m:getVirtualRenderer()
	return self:getBar()
end
function m:loadTexture(texture, texType)
	self:getChild("bar"):loadTexture(texture, texType)
end
function m:setDirection(direction)
	self.reverse = direction == 1
end
function m:setPercent(percent)
	if self.isCocos then
		self:setValue(percent / 100 * self:getMax())
	else
		self:setValue(percent * self:getMax())
	end
end
function m:setType(barType)
	local bar = self:getChild("bar")
	if barType == display.PROGRESS_TIMER_BAR then
		self:setScale9Enabled(true)
		bar:setFillClockwise(true)
		bar:setFillMethod(fgui.FillMethod.Horizontal)
	elseif barType == display.PROGRESS_TIMER_RADIAL then
		self:setScale9Enabled(false)
		bar:setFillClockwise(false)
		bar:setFillMethod(fgui.FillMethod.Radial360)
	else
		error("undefined ProgressBar type" .. barType)
	end
end
function m:setPercentage(perc)
	self:setValue(perc / 100 * self:getMax())
end
function m:setClipEnabled(value)
	self:setScale9Enabled(value)
end

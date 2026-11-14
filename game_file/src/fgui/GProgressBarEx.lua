local m = fgui.GProgressBar
function m:setPercent(value)
	self:setValue(value * self:getMax())
end

local m = fgui.Transition
function m:gotoFrameAndPlay(frameIndex, loop)
	local times = loop and -1 or 1
	local startTime = frameIndex / 60
	self:play(times, 0, startTime, -1)
end
function m:setValue(label, values)
	self:SetValue(label, table.unpack(values))
end
function m:setHook(label, callback)
	self:SetHook(label, callback)
end
return m

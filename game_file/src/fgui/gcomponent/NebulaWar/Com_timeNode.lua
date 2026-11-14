local baseComponent = require("fgui.base.baseComponent")
local Com_timeNode = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NebulaWar/Com_timeNode", Com_timeNode)
function Com_timeNode:onInit()
	self.Load_timer = SoraDCreateTimerLabel(self, self.fields.Load_timer)
	self.Load_timer:setTimeUpdateListener(function(timeNumber)
		self:setTime(timeNumber)
	end)
end
function Com_timeNode:onShow()
end
function Com_timeNode:beginTime(time, ...)
	local hNum = math.floor(time / 3600)
	if 99 < hNum then
		self.controllers.c_hour:setSelectedIndex(0)
	else
		self.controllers.c_hour:setSelectedIndex(1)
	end
	self.Load_timer:beginTime(time, ...)
end
function Com_timeNode:setTime(lastTime)
	if not lastTime then
		return
	end
	local timeStr = SoraDConvertSecondToStringNoDay(lastTime)
	if string.len(timeStr) >= 9 and tonumber(string.sub(timeStr, 1, -7)) > 999 then
		timeStr = tostring(999) .. string.sub(timeStr, -6, -1)
	end
	_UPVALUE7_ = tostring(999)
	tostring(999)[1] = -9
	tostring(999)[2] = -8
	tostring(999)[3] = -7
	tostring(999)[4] = -5
	tostring(999)[5] = -4
	tostring(999)[6] = -2
	local tostring(999)[7], config = -1, tostring(999)
	for i, v in ipairs(config) do
		local widget = self.fields["NumChar_" .. i]
		local numChar = string.sub(timeStr, v, v)
		if numChar and numChar ~= "" then
			widget:setString(numChar)
		else
			widget:setString("0")
		end
	end
end
return Com_timeNode

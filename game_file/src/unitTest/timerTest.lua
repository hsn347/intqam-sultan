local timerManager = require("framework.timer.timerManager")
timerManager:getTimer(1, function()
	print("Test")
end):start()
_ENV = nil
;(nil).one_shot = true
timerManager:getTimer(1, function()
	print("Test--one_shot")
end, nil):start()
local _ENV, obj = timerManager:getTimer(1, function()
	print("Test--one_shot")
end, nil).start, timerManager:getTimer(1, function()
	print("Test--one_shot")
end, nil).start
function obj:log()
	print("obj--timer", self)
end
_ENV = nil
;(nil).obj = obj
timerManager:getTimer(2, obj.log, nil):start()
local _ENV, obj2 = timerManager:getTimer(2, obj.log, nil).start, timerManager:getTimer(2, obj.log, nil).start
function obj2:log()
	print("obj2--timer--auto-remove", self)
	collectgarbage()
end
_ENV = nil
;(nil).obj = obj2
timerManager:getTimer(3, obj2.log, nil):start()
local timer_stop
local i = 0
_ENV = nil
;(nil).started = true
timer_stop = timerManager:getTimer(1, function()
	print("Test--auto stared and stop", i)
	if 5 <= i then
		timer_stop:stop()
	end
end, nil)

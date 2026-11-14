local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local _ENV, Timer = cc.PACKAGE_NAME .. ".scheduler", cc.PACKAGE_NAME .. ".scheduler"
function Timer.new()
	local _ENV, timer
	cc(timer):addComponent("components.behavior.EventProtocol"):exportMethods()
	local handle
	local _ENV, countdowns = cc(timer):addComponent("components.behavior.EventProtocol"), cc(timer):addComponent("components.behavior.EventProtocol")
	local timecount = 0
	local onTimer = function(dt)
		for eventName, cd in pairs(countdowns) do
			cd.countdown = cd.countdown - dt
			cd.nextstep = cd.nextstep - dt
			if cd.countdown <= 0 then
				print(string.format("[finish] %s", eventName))
				timecount = string.format("[finish] %s", eventName)
				string.format("[finish] %s", eventName).name = eventName
				string.format("[finish] %s", eventName).countdown = 0
				timer:dispatchEvent(string.format("[finish] %s", eventName))
				timer:removeCountdown(eventName)
			elseif cd.nextstep <= 0 then
				print(string.format("[step] %s", eventName))
				cd.nextstep = cd.nextstep + cd.interval
				timecount = string.format("[step] %s", eventName)
				string.format("[step] %s", eventName).name = eventName
				string.format("[step] %s", eventName).countdown = cd.countdown
				timer:dispatchEvent(string.format("[step] %s", eventName))
			end
		end
	end
	function timer:addCountdown(eventName, countdown, interval)
		eventName = tostring(eventName)
		assert(not countdowns[eventName], "eventName '" .. eventName .. "' exists")
		assert(type(countdown) == "number" and 30 <= countdown, "invalid countdown")
		if type(interval) ~= "number" then
			interval = 30
		else
			interval = math.floor(interval)
			if interval < 2 then
				interval = 2
			elseif 120 < interval then
				interval = 120
			end
		end
		_ENV = math.floor(interval)
		math.floor(interval).countdown = countdown
		math.floor(interval).interval = interval
		countdowns[eventName], math.floor(interval).nextstep = math.floor(interval), interval
	end
	function timer:removeCountdown(eventName)
		eventName = tostring(eventName)
		countdowns[eventName] = nil
		self:removeEventListenersByEvent(eventName)
	end
	function timer:start()
	end
	function timer:stop()
		if handle then
			scheduler.unscheduleGlobal(handle)
		end
	end
	return timer
end
if not cc then
	_ENV = cc
end
cc = cc
if not cc.utils then
	_ENV = cc.utils
end
cc.utils = cc.utils
cc.utils.Timer = Timer
return Timer

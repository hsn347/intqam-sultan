local cocosTabMachine = require("app.common.tabMachine.cocosTabMachine")
local tabDebugger = require("app.common.tabMachine.tabDebugger")
local _ENV, test = "app.common.tabMachine.tabDebugger", "app.common.tabMachine.tabDebugger"
_ENV, test.empty, _ENV, test.testTab = function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end
_ENV, test.helloWorld, (function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s1 = function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(c)
	print("hello world")
end
_ENV, test.helloWorldEx, (function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s1 = function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(c)
	c:call(test.tickPrint, "s1", nil, "Hello World Ex")
end
;(function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s1 = function(c)
end
;(function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s1_catch = function(c)
	print("catch s1")
	return true
end
;(function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s2 = function(c)
	local a = 5
	a = a + nil
end
;(function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s2_catch = function(c, e)
	print("catch s2")
	return false
end
;(function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s3 = function(c)
	c.v.m = 0
end
;(function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s3_tick = function(c, dt)
	c.v.m = c.v.m + 1
	print("s3 ", 10 - c.v.m)
	if c.v.m >= 10 then
		c:getSub("s3"):throw("error s3")
	end
end
;(function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s3_catch = function(c, e)
	print("catch s3")
	if e.isCustom then
		return false
	end
end
_ENV, test.except1, (function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).catch = function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(c, e)
	print("catch")
	if e.isCustom then
		c:stop("s3")
	end
	return true
end
;(function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s1 = function(c)
	c:call(c.t1, "t1")
	c:call(c.u1, "u1")
end
_ENV, (function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s1_catch = function(c, e)
	print("final catch")
	c:stop("s1")
	return true
end, function(c, e)
	print("final catch")
	c:stop("s1")
	return true
end
_ENV, (function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).t1, (function(c, e)
	print("final catch")
	c:stop("s1")
	return true
end).s1 = function(c, e)
	print("final catch")
	c:stop("s1")
	return true
end, function(c, e)
	print("final catch")
	c:stop("s1")
	return true
end, function(c)
	c:start("m1")
end
;(function(c, e)
	print("final catch")
	c:stop("s1")
	return true
end).s1 = function(c)
	print("u1 start1")
	local a
	local b = a + 1
	c.v.t = 0
end
;(function(c, e)
	print("final catch")
	c:stop("s1")
	return true
end).s1_update = function(c, dt)
	print("kkk")
end
;(function(c, e)
	print("final catch")
	c:stop("s1")
	return true
end).s1_catch = function(c, e)
	print("s1 catch")
	c:stop("s1")
	return true
end
;(function(c, e)
	print("final catch")
	c:stop("s1")
	return true
end).s2 = function(c)
	c.v.t = 0
end
;(function(c, e)
	print("final catch")
	c:stop("s1")
	return true
end).s2_tick = function(c, dt)
	print("s2 ", 5 - c.v.t)
	c.v.t = c.v.t + dt
	if c.v.t > 5 then
		local k
		local x = k + 5
	end
end
;(function(c, e)
	print("final catch")
	c:stop("s1")
	return true
end).s2_catch = function(c, e)
	print("s2 catched but not receive")
	return false
end
;(function(c, e)
	print("final catch")
	c:stop("s1")
	return true
end).s3 = function(c)
	c.v.index = 0
end
;(function(c, e)
	print("final catch")
	c:stop("s1")
	return true
end).s3_tick = function(c, index)
	print("s3 ", 10 - c.v.index)
	c.v.index = c.v.index + 1
	if c.v.index > 10 then
		c:getSub("s3"):throw("error e3")
	end
end
;(function(c, e)
	print("final catch")
	c:stop("s1")
	return true
end).s3_catch = function(c)
	print("s3 catched")
	return false
end
;(function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).u1, (function(c, e)
	print("final catch")
	c:stop("s1")
	return true
end).catch = function(c, e)
	print("final catch")
	c:stop("s1")
	return true
end, function(c, e)
	print("u1 catched")
	c:stop("s2")
	return false
end
_ENV, test.except2, (function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).catch = function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(c, e)
	if e.isCustom then
		c:stop()
	end
	return true
end
_ENV, (function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s1 = function(c)
	c:call(test.tickPrint, "t1", nil, "s1s1s1s1s1s1s1s1s1s1s1s1s1s1s1s1")
end, function(c)
	c:call(test.tickPrint, "t1", nil, "s1s1s1s1s1s1s1s1s1s1s1s1s1s1s1s1")
end
_ENV, (function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).u1, (function(c)
	c:call(test.tickPrint, "t1", nil, "s1s1s1s1s1s1s1s1s1s1s1s1s1s1s1s1")
end).s1 = function(c)
	c:call(test.tickPrint, "t1", nil, "s1s1s1s1s1s1s1s1s1s1s1s1s1s1s1s1")
end, function(c)
	c:call(test.tickPrint, "t1", nil, "s1s1s1s1s1s1s1s1s1s1s1s1s1s1s1s1")
end, function(c)
	c:call(test.tickPrint, "t1", nil, "u1u1u1u1u1u1u1u1u1u1u1u1u1u1")
end
_ENV, (function(c)
	c:call(test.tickPrint, "t1", nil, "s1s1s1s1s1s1s1s1s1s1s1s1s1s1s1s1")
end).s1 = function(c)
	c:call(c.t1, "t1")
end, function(c)
	c:call(c.t1, "t1")
end
_ENV, (function(c)
	c:call(c.t1, "t1")
end).s1 = function(c)
	c:call(c.t1, "t1")
end, function(c)
	c:call(c.t1, "t1")
end
_ENV, (function(c)
	c:call(c.t1, "t1")
end).s1 = function(c)
	c:call(c.t1, "t1")
end, function(c)
	c:call(c.t1, "t1")
end
;(function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).m1, (function(c)
	c:call(test.tickPrint, "t1", nil, "s1s1s1s1s1s1s1s1s1s1s1s1s1s1s1s1")
end).t1, (function(c)
	c:call(c.t1, "t1")
end).t1, (function(c)
	c:call(c.t1, "t1")
end).t1, (function(c)
	c:call(c.t1, "t1")
end).s1 = function(c)
	c:call(test.tickPrint, "t1", nil, "s1s1s1s1s1s1s1s1s1s1s1s1s1s1s1s1")
end, function(c)
	c:call(c.t1, "t1")
end, function(c)
	c:call(c.t1, "t1")
end, function(c)
	c:call(c.t1, "t1")
end, function(c)
	c:call(test.tickPrint, "t1", nil, "m1m1m1m1m1m1m1m1m1m1m1m1m1m1")
end
_ENV, test.updateOpt, (function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).event = function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(c, msg)
	if msg == "s1" then
		c:start("s1")
	elseif msg == "u1" then
		c:call(c.u1, "u1")
	elseif msg == "m1" then
		c:call(c.m1, "m1")
	end
end
;(function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s1 = function(c)
	c.v.t = 0
end
;(function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s1_update = function(c, dt)
	c.v.t = c.v.t + dt
	if c.v.t > 5 then
		c:start("t1")
		c:stop("s1")
	end
end
_ENV, test.notifyOpt, (function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).t1_event = function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(c, msg)
	if msg == "s1" then
		c:start("s1")
		c:stop("t1")
	end
end
;(function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s1 = function(c)
	c:start("s3")
end
;(function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s1_event = function(c, msg)
	print("s1 event ", msg)
	if msg == "end_s1" then
		return false
	elseif msg == "end_s2" then
		c:stop("s2")
		return true
	elseif msg == "start_s2" then
		c:call(test.tickPrint, "s2", nil, "Hello world")
	end
	return false
end
;(function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s3_event = function(c, msg)
	print("s3 event ", msg)
end
_ENV, test.notify, (function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).event = function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(c, msg)
	print("total event ", msg)
	if msg == "end" then
		c:stop()
		return true
	elseif msg == "end_s2" then
		print("receive end s2 not captured")
		return false
	end
	return false
end
;(function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s1 = function(c)
	local isSameOrder = math.random(2) == 2
	if isSameOrder then
		c:call(test.tickPrint, "t1", nil, "Hello World")
		c:call(test.tickPrint, "m1", nil, "HaHaHaHaHa HaHaHa")
	else
		c:call(test.tickPrint, "t1", nil, "Hello World long long long long long long")
		c:call(test.tickPrint, "m1", nil, "HaHaHaHaHa HaHaHa")
	end
	_UPVALUE2_ = test.tickPrint
	test.tickPrint[1] = "t1"
	test.tickPrint[2] = "m1"
	c:join(test.tickPrint, "k1")
end
_ENV, test.join, (function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).k2 = function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(c)
	print("t1 m1 joined")
end
;(function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s1 = function(c)
	local isSameOrder = math.random(2) == 2
	if isSameOrder then
		local a = g_t.bind(test.tickPrint, "Hello World")
		local b = g_t.bind(test.tickPrint, "HaHaHaHaHa HaHaHa")
		c:call(g_t.select(a, b), "s2")
	else
		local a = g_t.bind(test.tickPrint, "Hello World long long long long long long")
		local b = g_t.bind(test.tickPrint, "HaHaHaHaHa HaHaHa")
		c:call(g_t.select(a, b), "s2")
	end
end
_ENV, test.select, (function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s3 = function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(c)
	print("select done")
end
;(function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s1 = function(c)
	c._nickName = "lifetime"
	c:call(g_t.delay, "s2", nil, 1)
end
_ENV, test.lifetime, (function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s3 = function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(c)
	_ENV, _UPVALUE2_ = nil, nil
	;(nil)[1] = nil
	;(nil)[2] = g_t.bind(test.tickPrint, "hello")
	;(nil)[3] = g_t.bind(test.tickPrint, "world")
	;(nil)[4] = g_t.bind(test.tickPrint, "world")
	;(nil)[5] = g_t.bind(test.tickPrint, "world")
	;(nil)[6] = g_t.bind(test.tickPrint, "world")
	;(nil)[7] = g_t.bind(test.tickPrint, "world")
	;(nil)[8] = g_t.bind(test.tickPrint, "world")
	;(nil)[9] = g_t.bind(test.tickPrint, "world")
	local (nil)[10], tabs = g_t.bind(test.tickPrint, "world")
	for index, tab in ipairs(tabs) do
		c:call(tab, "kk" .. index)
	end
end
;(function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s1 = function(c)
	c:start("t1")
	c:start("u1")
	c:call(c.m1, "m1")
end
;(function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).t1 = function(c)
	print("00000")
end
;(function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).t1_update = function(c, dt)
	if c.v.a == nil then
		c.v.a = 0
	end
	c.v.a = c.v.a + dt
	if c.v.a > 1 then
		c.v.a = c.v.a - 1
		print("tick")
		c:stop()
	end
end
;(function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).t1_final = function(c)
	print("t1 final")
	local a
	a = a + 3
	print("xxxxx")
end
;(function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).u1 = function(c)
	print("u1")
end
_ENV, (function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).u1_final = function(c)
	print("u1 final")
end, function(c)
	print("u1 final")
end
;(function(c)
	print("u1 final")
end).s1 = function(c)
	print("mmmm")
	c:call(g_t.delay, "d1", nil, 3)
end
;(function(c)
	print("u1 final")
end).s1_final = function(c)
	print("m1.s1 final")
end
;(function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).m1, (function(c)
	print("u1 final")
end).final = function(c)
	print("u1 final")
end, function(c)
	print("m1 final")
end
_ENV, test.final, (function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).final = function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(c)
	print("final")
end
_ENV, test.inputs, (function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s1 = function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(c)
	c:call(test.tickPrint, "s1", nil, "Hello World again")
end
;(function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s1 = function(c)
	_UPVALUE3_ = nil
	;(nil)[1] = "o1"
	;(nil)[2] = "o2"
	;(nil)[3] = "o3"
	c:call(test.tickPrint, "s2", nil, "Hello World again")
end
_ENV, test.outputs, (function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s3 = function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(c)
	print("o1 ", c.v.o1)
	print("o2 ", c.v.o2)
	print("o3 ", c.v.o3)
end
_ENV, test.tick, (function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s1 = function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(c)
	c:call(test.countDown, "t1", nil, 15, "tick")
end
;(function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s1 = function(c, word)
	c.v.word = word
	c.v.index = 0
end
_ENV, test.tickPrint, (function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s1_tick = function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(c, index)
	c.v.index = c.v.index + 1
	if c.v.index <= c.v.word:len() then
		local subWord = c.v.word:sub(1, c.v.index)
		print(subWord)
	else
		c:output("o1-value", "o2-value")
		c:stop()
	end
end
_ENV, test.tabWhile, (function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s1 = function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(c)
	c.v.N = 0
	local condition = function()
		return c.v.N < 10
	end
	_ENV = nil
	;(nil).s1 = function(c1)
		local word = "["
		for i = 1, c.v.N do
			word = word .. tostring(c.v.N)
		end
		word = word .. "]"
		c1:call(test.tickPrint, "s2", nil, word)
	end
	local (nil).s3, loop = function(c1)
		c.v.N = c.v.N + 1
	end, nil
	c:call(g_t.tabWhile(condition, loop), "s2")
end
_ENV, test.tabDoWhile, (function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s1 = function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(c)
	c.v.N = 0
	local condition = function()
		return c.v.N < 10
	end
	_ENV = nil
	;(nil).s1 = function(c1)
		local word = "["
		for i = 1, c.v.N do
			word = word .. tostring(c.v.N)
		end
		word = word .. "]"
		c1:call(test.tickPrint, "s2", nil, word)
	end
	local (nil).s3, loop = function(c1)
		c.v.N = c.v.N + 1
	end, nil
	c:call(g_t.tabDoWhile(loop, condition), "s2")
end
_ENV, test.tabForIndex, (function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s1 = function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(c)
	_ENV = nil
	local (nil).s1, loop = function(c1, index)
		local word = "["
		for i = 1, index do
			word = word .. tostring(index)
		end
		word = word .. "]"
		c1:call(test.tickPrint, "s2", nil, word)
	end, nil
	c:call(g_t.tabForIndex(1, 9, loop), "s2")
end
_ENV, test.tabForIpairs, (function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s1 = function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(c)
	local _ENV, array
	for i = 1, 9 do
		table.insert(array, i)
	end
	_ENV = (for index)
	local (1).s1, loop = function(c1, index, v)
		local word = "["
		for i = 1, index do
			word = word .. tostring(v)
		end
		word = word .. "]"
		c1:call(test.tickPrint, "s2", nil, word)
	end, 1
	c:call(g_t.tabForIpairs(array, loop, "s2"))
end
_ENV, test.tabForPairs, (function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s1 = function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(c)
	test = nil
	;(nil).abc = "99"
	local (nil)[2], map = "mmmmm", nil
	map.kk = 9
	test, map.gg = nil, "This is innevetable"
	local (nil).s1, loop = function(c1, k, v)
		local word = "[" .. k .. "-" .. v .. "]"
		c1:call(test.tickPrint, "s2", nil, word)
	end, nil
	c:call(g_t.tabForPairs(map, loop, "s2"))
end
;(function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s1 = function(c)
	c.v.N = 0
	local condition = function()
		return c.v.N < 10
	end
	_ENV = nil
	;(nil).s1 = function(c1)
		local word = "["
		for i = 1, c.v.N do
			word = word .. tostring(c.v.N)
		end
		word = word .. "]"
		if c.v.N == 4 then
			print("break")
			c1:break_()
			return
		end
		c1:call(test.tickPrint, "s2", nil, word)
	end
	local (nil).s3, loop = function(c1)
		c.v.N = c.v.N + 1
	end, nil
	c:call(g_t.tabWhile(condition, loop), "s2")
end
;(function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s3 = function(c)
	c.v.N = 0
	local condition = function()
		return c.v.N < 10
	end
	_ENV = nil
	;(nil).s1 = function(c1)
		local word = "["
		for i = 1, c.v.N do
			word = word .. tostring(c.v.N)
		end
		word = word .. "]"
		if c.v.N == 5 then
			print("break")
			c1:break_()
			return
		end
		c1:call(test.tickPrint, "s2", nil, word)
	end
	local (nil).s3, loop = function(c1)
		c.v.N = c.v.N + 1
	end, nil
	c:call(g_t.tabDoWhile(loop, condition), "s4")
end
;(function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s5 = function(c)
	_ENV = nil
	local (nil).s1, loop = function(c1, index)
		local word = "["
		for i = 1, index do
			word = word .. tostring(index)
		end
		word = word .. "]"
		if index == 4 then
			print("break")
			c1:break_()
			return
		end
		c1:call(test.tickPrint, "s2", nil, word)
	end, nil
	c:call(g_t.tabForIndex(1, 9, loop), "s6")
end
;(function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s7 = function(c)
	local _ENV, array
	for i = 1, 9 do
		table.insert(array, i)
	end
	_ENV = (for index)
	local (1).s1, loop = function(c1, index, v)
		local word = "["
		for i = 1, index do
			word = word .. tostring(v)
		end
		word = word .. "]"
		if index == 4 then
			print("break")
			c1:break_()
			return
		end
		c1:call(test.tickPrint, "s2", nil, word)
	end, 1
	c:call(g_t.tabForIpairs(array, loop), "s8")
end
_ENV, test.tabBreak, (function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s9 = function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(c)
	_ENV = nil
	;(nil).abc = "99"
	local (nil)[2], map = "mmmmm", nil
	map.kk = 9
	_ENV, map.gg = nil, "This is innevetable"
	local (nil).s1, loop = function(c1, k, v)
		local word = "[" .. k .. "-" .. v .. "]"
		if k == "kk" then
			print("break")
			c1:break_()
			return
		end
		c1:call(test.tickPrint, "s2", nil, word)
	end, nil
	c:call(g_t.tabForPairs(map, loop), "s10")
end
;(function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s1 = function(c)
	c:call(c:tabPrint("A", 20, 1), "A")
	c:call(c:tabPrint("B", 20, 0.5), "B")
	c:call(c:tabPrint("C", 20, 2), "C")
	c:call(g_t.delay, "s2", nil, 3)
end
;(function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s3 = function(c)
	c.v.A = c:getSub("A")
	print("We pause A now")
	c.v.A:getScheduler():pause()
	c:call(g_t.delay, "s4", nil, 2)
end
;(function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s5 = function(c)
	print("After 2 seconds A is resumed, but is executed at half speed")
	local scheduler = c.v.A:getScheduler()
	scheduler:setTimeScale(0.5)
	scheduler:resume()
	print("And B is Speed up to twice speed")
	c:getSub("B"):getScheduler():setTimeScale(2)
end
_ENV, test.timeScale, (function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).tabPrint = function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(c, text, times, timeScale)
	_ENV = nil
	;(nil).s1 = function(c1)
		c1:call(g_t.schedulerCtrl, "scheduleCtrl", nil, c1)
		c1:getScheduler():setTimeScale(timeScale)
		local str = ""
		for i = 1, times do
			str = str .. text
		end
		c1:call(test.tickPrint, "s2", nil, str)
		c1:call(test.tickPrint, "s3", nil, str)
	end
	;(nil).s3 = function(c1)
		c1:stop()
	end
	return nil
end
;(function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s1 = function(c)
	c:call(test.tickPrint, "t1", nil, "ttttttttttttttttt")
	local subT1 = c:getSub("t1")
	c:call(subT1:tabProxy(), "s2")
end
;(function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s3 = function(c)
	c:call(c.m, "m")
	local subM = c:getSub("m")
	c:call(subM:tabProxy("s4"), "s4")
end
_ENV, (function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s5 = function(c)
	c:call(test.tickPrint, "s6", nil, "oooooooooooooo")
end, function(c)
	c:call(test.tickPrint, "s6", nil, "oooooooooooooo")
end
;(function(c)
	c:call(test.tickPrint, "s6", nil, "oooooooooooooo")
end).s1 = function(c)
	c:call(test.tickPrint, "s2", nil, "mmmmmmmmmmmmm")
end
;(function(c)
	c:call(test.tickPrint, "s6", nil, "oooooooooooooo")
end).s3 = function(c)
	c:call(test.tickPrint, "s4", nil, "nnnnnnnnnnnnnn")
end
_ENV, test.proxy, (function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).m, (function(c)
	c:call(test.tickPrint, "s6", nil, "oooooooooooooo")
end).s5 = function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(c)
	c:call(test.tickPrint, "s6", nil, "oooooooooooooo")
end, function(c)
	c:call(test.tickPrint, "s6", nil, "pppppppppppppp")
end
;(function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s1 = function(c)
end
;(function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s1_update = function(c, dt)
	print("s1_update", dt)
end
;(function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s1_updateInterval = 2
;(function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).update = function(c, dt)
	print("self:update", dt)
end
_ENV, test.updateInterval, (function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).updateInterval = function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, 0.5
;(function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s1 = function(c, num, tag)
	c.v.num = num
	c.v.tag = tag and tag or "countDown"
end
_ENV, test.countDown, (function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s1_tick = function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(c, index)
	print(c.v.tag .. ":" .. c.v.num, " ", index)
	c.v.num = c.v.num - 1
	if c.v.num <= 0 then
		c:stop()
	end
end
;(function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s1 = function(c)
	c:call(g_t.delay, "t0", nil, 10)
end
;(function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).t1 = function(c)
	print("hello world")
end
;(function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).t2 = function(c)
	c.v.a = 0
	c.v.t = 0
	print("test next call")
end
;(function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).t2_update = function(c, dt)
	c.v.a = c.v.a + dt
	if c.v.a > 1 then
		c.v.t = c.v.t + 1
		c.v.a = c.v.a - 1
		print("tick ", c.v.t)
	end
	if c.v.t >= 5 and not c:hasSub("m1") then
		if c.v.m == nil then
			c.v.m = 0
		end
		c.v.m = c.v.m + 1
		c:call(c.m1, "m1")
	end
	if c.v.t >= 100 then
		c:stop("t2")
	end
end
_ENV, (function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).t3 = function(c)
	print("t3")
end, function(c)
	print("t3")
end
;(function(c)
	print("t3")
end).s1 = function(c)
	c.v.word = "Hello World"
	c.v.index = 0
	c.v.t = 0
end
;(function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).m1, (function(c)
	print("t3")
end).s1_update = function(c)
	print("t3")
end, function(c, dt)
	c.v.t = c.v.t + dt
	if c.v.t > 1 then
		c.v.t = c.v.t - 1
		c.v.index = c.v.index + 1
		if c.v.index <= c.v.word:len() then
			print(c.v.word:sub(1, c.v.index))
		else
			c:stop()
		end
	end
end
_ENV, test.all, (function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).m2 = function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(c)
	if c.v.m >= 5 then
		c:stop()
	end
end
;(function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s1 = function(c)
	print("hello")
	c:call(test.all, "s2")
	c:call(test.all, "s4")
end
;(function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s3 = function(c)
	print("s3 call all return")
end
_ENV, test.call_all, (function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s5 = function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(c)
	print("s5 call all return")
end
_ENV, (function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).s1 = function(c)
	c:call(c.t1, "t1")
end, function(c)
	c:call(c.t1, "t1")
end
_ENV, (function(c)
	c:call(c.t1, "t1")
end).s1 = function(c)
	c:call(c.m1, "m1")
end, function(c)
	c:call(c.m1, "m1")
end
;(function(c)
	c:call(c.m1, "m1")
end).s1 = function(c)
	print("inner s1")
	g_head = c
end
;(function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).t1, (function(c)
	c:call(c.t1, "t1")
end).m1, (function(c)
	c:call(c.m1, "m1")
end).s1_event = function(c)
	c:call(c.t1, "t1")
end, function(c)
	c:call(c.m1, "m1")
end, function(c)
end
test.extTrigger, (function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end).t2 = function(tabName)
	if g_tabMachine and g_tabMachine:isRunning() then
		g_tabMachine:stop()
		g_tabMachine = nil
	end
	g_tabMachine = cocosTabMachine.new()
	g_tabMachine:setDebugger(tabDebugger.new())
	g_tabMachine:installTab(test[tabName])
	g_tabMachine:start()
end, function(c)
	c:start("s1")
end
return test

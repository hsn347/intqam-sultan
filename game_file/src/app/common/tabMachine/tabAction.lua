_ENV = nil
;(nil).s1 = function(c, act)
	if g_t.debug then
		c._nickName = "waitForLastFrame"
	end
	c.v.act = act
	act:setLastFrameCallFunc(function()
		c:stop()
	end)
end
;(nil).final = function(c)
	local act = c.v.act
	if not tolua.isnull(act) then
		act:setLastFrameCallFunc(g_t.empty_frame)
	end
end
g_t.waitForLastFrame, (nil).event = nil, g_t.empty_event
_ENV = nil
;(nil).s1 = function(c, node, act)
	if g_t.debug then
		c._nickName = "waitForAct"
	end
	_ENV = nil
	;(nil).onComplete = function()
		c:stop()
	end
	transition.execute(node, act, nil)
	if act.getDuration then
		c:call(g_t.delay, "s2", nil, act:getDuration())
	end
end
;(nil).s3 = function(c)
	c:stop()
end
g_t.waitForAct, (nil).event = nil, g_t.empty_event
_ENV = nil
;(nil).s1 = function(c, spine, animationName)
	c.v.spine = spine
	spine:registerSpineEventHandler(function(data)
		c:stop()
	end, spEventType.SP_ANIMATION_COMPLETE)
	spine:setAnimation(0, animationName, false)
end
;(nil).final = function(c)
	local spine = c.v.spine
	if not tolua.isnull(spine) then
		spine:unregisterSpineEventHandler(sp.EventType.ANIMATION_COMPLETE)
	end
end
g_t.playSpineAnimation, (nil).event = nil, g_t.empty_event
g_t.curve, _ENV = nil, nil
function g_t.curve.circleEaseOut(k)
	local value = k - 1
	return math.sqrt(1 - value * value)
end
function g_t.curve.circleEaseIn(k)
	local value = k
	return -1 * (math.sqrt(1 - value * value) - 1)
end
function g_t.curve.circleEaseInOut(k)
	local value = k * 2
	if value < 1 then
		return -0.5 * (math.sqrt(1 - value * value) - 1)
	end
	value = value - 2
	return 0.5 * (math.sqrt(1 - value * value) + 1)
end
function g_t.curve.quadEaseOut(k)
	local value = k
	return -1 * value * (value - 2)
end
function g_t.curve.quadEaseIn(k)
	local value = k
	return value * value
end
function g_t.curve.quadEaseInOut(k)
	local value = k * 2
	if value < 1 then
		return 0.5 * value * value
	end
	value = value - 1
	return -0.5 * (value * (value - 2) - 1)
end
function g_t.curve.cubicEaseIn(k)
	local value = k
	return k * value * value
end
function g_t.curve.cubicEaseOut(k)
	local value = k - 1
	return value * value * value + 1
end
function g_t.curve.cubicEaseInOut(k)
	local value = k * 2
	if value < 1 then
		return 0.5 * value * value * value
	end
	value = value - 2
	return 0.5 * (value * value * value + 2)
end
function g_t.curve.sineEaseIn(k)
	return -1 * math.cos(k * math.pi / 2) + 1
end
function g_t.curve.sineEaseOut(k)
	return math.sin(k * math.pi / 2)
end
function g_t.curve.sineEaseInOut(k)
	return -0.5 * (math.cos(math.pi * k) - 1)
end
function g_t.curve.expoEaseIn(k)
	return math.pow(2, 10 * (k - 1))
end
function g_t.curve.expoEaseOut(k)
	return math.sin(k * math.pi / 2)
end
function g_t.curve.expoEaseInOut(k)
	return -0.5 * (math.cos(math.pi * k) - 1)
end
function g_t.curve.quintEaseIn(k)
	return k * k * k * k * k
end
function g_t.curve.quintEaseOut(k)
	k = k - 1
	return k * k * k * k * k + 1
end
function g_t.curve.quintEaseInOut(k)
	k = k * 2
	if k < 1 then
		return 0.5 * k * k * k * k * k
	end
	k = k - 2
	return 0.5 * (k * k * k * k * k + 2)
end
function g_t.curve.defaultLine(k)
	return k
end
function _ENV(k)
	return k
end
;(function(k)
	return k
end).s1 = function(c, fun, v1, v2, duration, curve)
	if g_t.debug then
		c._nickName = "tween"
	end
	fun(v1)
	c.v.time = 0
	c.v.duration = duration
	c.v.v1 = v1
	c.v.v2 = v2
	c.v.fun = fun
	c.v.curve = curve
end
;(function(k)
	return k
end).s1_update = function(c, dt)
	c.v.time = c.v.time + dt
	if c.v.time > c.v.duration then
		c:stop("s1")
		return
	end
	local rate = c.v.time / c.v.duration
	local v
	if c.v.curve and type(c.v.curve) == "function" then
		local tempRate = c.v.curve(rate)
		v = (c.v.v2 - c.v.v1) * tempRate + c.v.v1
	else
		v = c.v.v1 * (1.0 - rate) + c.v.v2 * rate
	end
	c.v.fun(v)
end
;(function(k)
	return k
end).s2 = function(c)
	c.v.fun(c.v.v2)
end
g_t.tween, (function(k)
	return k
end)._preCal = function(k)
	return k
end, function(v1, v2, curDuration, duration, curve)
	local rate = curDuration / duration
	local v
	if curve and type(curve) == "function" then
		local tempRate = curve(rate)
		v = (v2 - v1) * tempRate + v1
	else
		v = v1 * (1.0 - rate) + v2 * rate
	end
	return v
end
function _ENV(k)
	return k
end
;(function(k)
	return k
end).s1 = function(c, labNode, word, interval)
	print("tabPrintText==========", word, interval)
	c.v.word = word or ""
	c.v.index = 0
	c.v.t = 0
	c.v.interval = interval or 0.1
	c.v.wordCount = SubStringGetTotalIndex(word)
	c.v.labelNode = labNode
	dump(c.v.wordCount, "c.v.wordCountc.v.wordCount")
	if c.v.wordCount > 1 then
		local subWord = SubStringUTF8(c.v.word, 1, 1)
		c.v.labelNode:setString(subWord)
	end
end
;(function(k)
	return k
end).s1_update = function(c, dt)
	c.v.t = c.v.t + dt
	if c.v.t >= c.v.interval then
		c.v.t = c.v.t - c.v.interval
		c.v.index = c.v.index + 1
		print(c.v.index, "c.v.index c.v.index ")
		if c.v.index <= c.v.wordCount then
			local subWord = SubStringUTF8(c.v.word, 1, c.v.index)
			if not tolua.isnull(c.v.labelNode) then
				c.v.labelNode:setString(subWord)
			end
		else
			c:stop()
		end
	end
end
g_t.printText, (function(k)
	return k
end).final = function(k)
	return k
end, function(c)
end
local getNodeAttribute, parseTimeLineData, setNodeAttribute
function g_t.timeLine(node, timeStr, eParam)
	_ENV = nil
	;(nil).s1 = function(c)
		if g_t.debug then
			c._nickName = "timeLine"
		end
		if not c.v.lineData then
			c.v.lineData = parseTimeLineData(timeStr, node, eParam)
		end
		if not c.v.time then
			c.v.time = 0
		end
		c.v.curData = table.remove(c.v.lineData, 1)
		if not c.v.curData then
			c:stop()
		end
	end
	;(nil).s2 = function(c)
		c.v.nodeAttribute = getNodeAttribute(node, c.v.curData)
	end
	;(nil).s2_update = function(c, dt)
		c.v.time = c.v.time + dt
		setNodeAttribute(node, c.v.nodeAttribute, c.v.curData, c.v.time)
		if c.v.time >= c.v.curData.t then
			if c.v.curData.e then
				if type(c.v.curData.e) == "function" then
					c.v.curData.e()
				elseif type(c.v.curData.e) == "table" then
					c:call(c.v.curData.e, "e")
				end
			end
			c:stop("s2")
		end
	end
	;(nil).s3 = function(c)
		c:start("s1")
	end
	return nil
end
function setNodeAttribute(node, oldAttribute, finalAttribute, curTime)
	local rate = 1
	if finalAttribute.time > 0 then
		rate = (finalAttribute.time - math.max(finalAttribute.t - curTime, 0)) / finalAttribute.time
		if finalAttribute.curve and g_t.curve[finalAttribute.curve] then
			rate = g_t.curve[finalAttribute.curve](rate)
		end
	end
	if finalAttribute.x or finalAttribute["+x"] then
		local addX = finalAttribute.x and finalAttribute.x - oldAttribute.x or finalAttribute["+x"]
		local x = oldAttribute.x + addX * rate
		node:setPositionX(x)
	end
	if finalAttribute.y or finalAttribute["+y"] then
		local addY = finalAttribute.y and finalAttribute.y - oldAttribute.y or finalAttribute["+y"]
		local y = oldAttribute.y + addY * rate
		node:setPositionY(y)
	end
	if finalAttribute.s or finalAttribute["+s"] then
		local addS = finalAttribute.s and finalAttribute.s - oldAttribute.s or finalAttribute["+s"]
		local s = oldAttribute.s + addS * rate
		node:setScale(s)
	end
	if finalAttribute.r or finalAttribute["+r"] then
		local addR = finalAttribute.r and finalAttribute.r - oldAttribute.r or finalAttribute["+r"]
		local r = oldAttribute.r + addR * rate
		node:setRotation(r)
	end
	if finalAttribute.a or finalAttribute["+a"] then
		local addA = finalAttribute.a and finalAttribute.a - oldAttribute.a or finalAttribute["+a"]
		local a = oldAttribute.a + addA * rate
		node:setOpacity(a)
	end
	if finalAttribute.d or finalAttribute["+d"] then
		local addD = finalAttribute.d and finalAttribute.d - oldAttribute.d or finalAttribute["+d"]
		local d = oldAttribute.d + addD * rate
		node:setRotation(d * 180 / 3.1415)
	end
	if finalAttribute.sx or finalAttribute["+sx"] then
		local addSx = finalAttribute.sx and finalAttribute.sx - oldAttribute.sx or finalAttribute["+sx"]
		local sx = oldAttribute.sx + addSx * rate
		node:setScaleX(sx)
	end
	if finalAttribute.sy or finalAttribute["+sy"] then
		local addSy = finalAttribute.sy and finalAttribute.sy - oldAttribute.sy or finalAttribute["+sy"]
		local sy = oldAttribute.sy + addSy * rate
		node:setScaleY(sy)
	end
	if finalAttribute.cr and finalAttribute.cg and finalAttribute.cb then
		local addR = finalAttribute.cr and finalAttribute.cr - oldAttribute.cr
		local addG = finalAttribute.cg and finalAttribute.cg - oldAttribute.cg
		local addB = finalAttribute.cb and finalAttribute.cb - oldAttribute.cb
		local cr = oldAttribute.cr + addR * rate
		local cg = oldAttribute.cg + addG * rate
		local cb = oldAttribute.cb + addB * rate
		node:setColor(cc.c3b(cr, cg, cb))
	end
end
function getNodeAttribute(node, curData)
	local _UPVALUE0_, data
	if curData.x or curData["+x"] then
		data.x = node:getPositionX()
	end
	if curData.y or curData["+y"] then
		data.y = node:getPositionY()
	end
	if curData.s or curData["+s"] then
		data.s = node:getScale()
	end
	if curData.r or curData["+r"] then
		data.r = node:getRotation()
	end
	if curData.a or curData["+a"] then
		data.a = node:getOpacity()
	end
	if curData.d or curData["+d"] then
		data.d = node:getRotation() * 3.1415 / 180
	end
	if curData.sx or curData["+sx"] then
		data.sx = node:getScaleX()
	end
	if curData.sy or curData["+sy"] then
		data.sy = node:getScaleY()
	end
	if curData.cr then
		local color = node:getColor()
		data.cr = color.r
	end
	if curData.cg then
		local color = node:getColor()
		data.cg = color.g
	end
	if curData.cb then
		local color = node:getColor()
		data.cb = color.b
	end
	return data
end
local splitStr = function(inputstr, sep)
	local _ENV, t
	i = 1
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end
function parseTimeLineData(str, node, eParam)
	local tempData = splitStr(str, "|")
	local splitStr, lineData = str, str
	for k, v in ipairs(tempData) do
		local splitStr, result
		local data = splitStr(v, ",")
		for _, str in ipairs(data) do
			local pos = string.find(str, "=")
			local key = string.sub(str, 1, pos - 1)
			local value = string.sub(str, pos + 1, string.len(str))
			if key == "curve" then
			elseif key ~= "e" then
				value = tonumber(value)
			else
				value = eParam[value]
			end
			result[key] = value
		end
		table.insert(lineData, result)
	end
	for k, v in ipairs(lineData) do
		local key = k - 1
		if lineData[key] then
			v.time = v.t - lineData[key].t
		else
			v.time = v.t
		end
	end
	return lineData
end
function g_t.catmullRom(node, duration, points, needAutoRotation)
	assert(type(points) == "table", "points must be array")
	assert(1 < #points, "point num must greater than 1")
	assert(0 < duration, "duration must greater than zero!")
	_ENV = assert
	function assert.s1(c)
		if g_t.debug then
			c._nickName = "catmullRom"
		end
		c.v.deltaT = 1 / (#points - 1)
		c.v.elapsed = 0
		c.v.dir = cc.p(0, 0)
		if node and type(node) == "userdata" then
			local x, y = node:getPosition()
			c.v.pos = cc.p(x, y)
		else
			c.v.pos = points[1]
		end
	end
	function assert.update(c, deltaTime)
		local p, lt
		c.v.elapsed = c.v.elapsed + deltaTime
		local time = c.v.elapsed / (0 < duration and duration or 1.4E-45)
		local reached = false
		if 1 <= time then
			reached = true
			time = 1
		end
		if time == 1 then
			p = #points
			lt = 1
		else
			p = math.floor(time / c.v.deltaT)
			lt = (time - c.v.deltaT * p) / c.v.deltaT
			p = p + 1
		end
		local pp0 = c:_getControlPointAtIndex(p - 1)
		local pp1 = c:_getControlPointAtIndex(p + 0)
		local pp2 = c:_getControlPointAtIndex(p + 1)
		local pp3 = c:_getControlPointAtIndex(p + 2)
		local newPos = c:_cardinalSplineAt(pp0, pp1, pp2, pp3, lt)
		c.v.pos = newPos
		if node and not tolua.isnull(node) then
			node:setPosition(newPos)
		end
		if time ~= 1 and needAutoRotation then
			local dir = c:_dirAt(pp0, pp1, pp2, pp3, lt)
			c.v.dir = dir
			if node and not tolua.isnull(node) then
				local angle = math.radian2angle(math.atan2(dir.y, dir.x))
				node:setRotation(-angle)
			end
		end
		if reached then
			c:stop()
		end
	end
	function assert.getCurPos(c)
		return c.v.pos
	end
	function assert.getDir(c)
		return c.v.dir
	end
	function assert._cardinalSplineAt(c, p0, p1, p2, p3, t)
		local t2 = t * t
		local t3 = t2 * t
		local s = 0.25
		local b1 = s * (-t3 + 2 * t2 - t)
		local b2 = s * (-t3 + t2) + (2 * t3 - 3 * t2 + 1)
		local b3 = s * (t3 - 2 * t2 + t) + (-2 * t3 + 3 * t2)
		local b4 = s * (t3 - t2)
		local x = p0.x * b1 + p1.x * b2 + p2.x * b3 + p3.x * b4
		local y = p0.y * b1 + p1.y * b2 + p2.y * b3 + p3.y * b4
		return cc.p(x, y)
	end
	function assert._dirAt(c, p0, p1, p2, p3, t)
		local t2 = t * t
		local s = 0.25
		local b1 = s * (-3 * t2 + 4 * t - 1)
		local b2 = s * (-3 * t2 + 2 * t) + (6 * t2 - 6 * t)
		local b3 = s * (3 * t2 - 4 * t + 1) + (-6 * t2 + 6 * t)
		local b4 = s * (3 * t2 - 2 * t)
		local x = p0.x * b1 + p1.x * b2 + p2.x * b3 + p3.x * b4
		local y = p0.y * b1 + p1.y * b2 + p2.y * b3 + p3.y * b4
		return cc.p(x, y)
	end
	function assert._getControlPointAtIndex(c, index)
		return points[util.clampf(index, 1, #points)]
	end
	return assert
end
return cocosContext

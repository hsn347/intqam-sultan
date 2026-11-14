if not util then
	_ENV = util
end
util = util
local socket = require("socket")
util.cloneCache = include("cloneCache").new()
function util.calRuntime(func, title)
	local beginTime = socket.gettime()
	func()
	local endTime = socket.gettime()
	title = title or ""
	print(title .. " -------use time " .. endTime - beginTime)
end
function util.convertOriginToAnchor(originPos, node)
	local anchor = node:getAnchorPoint()
	local size = node:getContentSize()
	return cc.p(originPos.x + anchor.x * size.width, originPos.y + anchor.y * size.height)
end
function util.convertAnchorToOrigin(anchorPos, node)
	local anchor = node:getAnchorPoint()
	local size = node:getContentSize()
	return cc.p(anchorPos.x - anchor.x * size.width, anchorPos.y - anchor.y * size.height)
end
function util.convertOriginToAnchorEx(originPos, anchor, size)
	return cc.p(originPos.x + anchor.x * size.width, originPos.y + anchor.y * size.height)
end
function util.calMaxBox(node)
	local minX, minY, maxX, maxY = 0, 0, 0, 0
	local children = node:getChildren()
	local nodeBox = node:getBoundingBox()
	local _ENV, boxList = node, node
	util._getChildBox(node, node:getParent(), boxList)
	if nodeBox.width ~= 0 and nodeBox.height ~= 0 then
		table.insert(boxList, nodeBox)
	end
	for i, v in ipairs(boxList) do
		if i == 1 then
			minX = cc.rectGetMinX(nodeBox)
			minY = cc.rectGetMinY(nodeBox)
			maxX = cc.rectGetMaxX(nodeBox)
			maxY = cc.rectGetMaxY(nodeBox)
		else
			minX = minX > cc.rectGetMinX(v) and cc.rectGetMinX(v) or minX
			minY = minY > cc.rectGetMinY(v) and cc.rectGetMinY(v) or minY
			maxX = maxX < cc.rectGetMaxX(v) and cc.rectGetMaxX(v) or maxX
			maxY = maxY < cc.rectGetMaxY(v) and cc.rectGetMaxY(v) or maxY
		end
	end
	return cc.rect(minX, minY, maxX - minX, maxY - minY)
end
function util._getChildBox(node, parent, list)
	local children = node:getChildren()
	for i, v in ipairs(children) do
		local childBox = v:getBoundingBox()
		if childBox.width ~= 0 and childBox.height ~= 0 then
			local pos = util.switchSpacePos(parent, v:getParent(), cc.p(childBox.x, childBox.y))
			childBox.x = pos.x
			childBox.y = pos.y
			table.insert(list, childBox)
		end
		util._getChildBox(v, parent, list)
	end
end
function util.switchSpacePos(targetSpaceNode, curSpaceNode, curPos)
	if targetSpaceNode == curSpaceNode then
		return curPos
	end
	local worldPos = curSpaceNode:convertToWorldSpace(curPos)
	return targetSpaceNode:convertToNodeSpace(worldPos)
end
function util.getVirtualNode(node)
	local realNode = util.findRealNode(node)
	local box = realNode:getBoundingBox()
	local nodePos = cc.p(node:getPosition())
	local virtualPos = util.switchSpacePos(node:getParent(), realNode:getParent(), cc.p(box.x, box.y))
	local virtualAnchor = cc.p((nodePos.x - virtualPos.x) / box.width, (nodePos.y - virtualPos.y) / box.height)
	_ENV = (nodePos.x - virtualPos.x) / box.width
	;(nodePos.x - virtualPos.x) / box.width.pos = nodePos
	;(nodePos.x - virtualPos.x) / box.width.anchor = virtualAnchor
	;(nodePos.x - virtualPos.x) / box.width.size = cc.size(box.width, box.height)
	return (nodePos.x - virtualPos.x) / box.width
end
function util.findRealNode(node)
	local size = node:getContentSize()
	if size.width ~= 0 and size.height ~= 0 then
		return node
	else
		local children = node:getChildren()
		for i, v in ipairs(children) do
			return util.findRealNode(v)
		end
	end
end
function util.clampf(value, min, max)
	return math.max(math.min(value, max), min)
end
function util.eventListen(eventName, func)
end
function util.eventEmit(eventName)
end
function util.layoutHorizontal(nodeList, space)
	local size = nodeList[1]:getParent():getContentSize()
	local width = 0
	for i, node in ipairs(nodeList) do
		node:setAnchorPoint(cc.p(0, 0))
		node:setPositionX(width)
		width = width + node:getContentSize().width + space
	end
	width = width - space
	local midOffset = size.width / 2 - width / 2
	for i, node in ipairs(nodeList) do
		node:setPositionX(node:getPositionX() + midOffset)
	end
end
function util.vec2Equal(vec1, vec2)
	if vec1.x == vec2.x and vec1.y == vec2.y then
		return true
	end
	return false
end
function util.vec3(_x, _y, _z)
	_UPVALUE0_ = nil
	;(nil).x = _x
	;(nil).y = _y
	;(nil).z = _z
	return nil
end
function util.vec3Add(vec1, vec2)
	_UPVALUE0_ = nil
	;(nil).x = vec1.x + vec2.x
	;(nil).y = vec1.y + vec2.y
	;(nil).z = vec1.z + vec2.z
	return nil
end
function util.vec3Sub(vec1, vec2)
	_UPVALUE0_ = nil
	;(nil).x = vec1.x - vec2.x
	;(nil).y = vec1.y - vec2.y
	;(nil).z = vec1.z - vec2.z
	return nil
end
function util.vec3Mul(vec, factor)
	_UPVALUE0_ = nil
	;(nil).x = vec.x * factor
	;(nil).y = vec.y * factor
	;(nil).z = vec.z * factor
	return nil
end
function util.c3bAdd(vec1, vec2)
	_UPVALUE0_ = nil
	;(nil).r = vec1.r + vec2.r
	;(nil).g = vec1.g + vec2.g
	;(nil).b = vec1.b + vec2.b
	return nil
end
function util.c3bSub(vec1, vec2)
	_UPVALUE0_ = nil
	;(nil).r = vec1.r - vec2.r
	;(nil).g = vec1.g - vec2.g
	;(nil).b = vec1.b - vec2.b
	return nil
end
function util.c3bMul(vec, factor)
	_UPVALUE0_ = nil
	;(nil).r = vec.r * factor
	;(nil).g = vec.g * factor
	;(nil).b = vec.b * factor
	return nil
end
function util.round(v)
	return math.floor(v + 0.5)
end
function util.mod(v, m)
	local result = v % m
	if result == 0 then
		result = m
	end
	return result
end
function util.hueMatrix(radian)
	local xRotateMat = function(rs, rc)
		_UPVALUE9_ = nil
		;(nil)[1] = 1
		;(nil)[2] = 0
		;(nil)[3] = 0
		;(nil)[4] = 0
		;(nil)[5] = rc
		;(nil)[6] = rs
		;(nil)[7] = 0
		;(nil)[8] = -rs
		;(nil)[9] = rc
		return nil
	end
	local yRotateMat = function(rs, rc)
		_UPVALUE9_ = nil
		;(nil)[1] = rc
		;(nil)[2] = 0
		;(nil)[3] = -rs
		;(nil)[4] = 0
		;(nil)[5] = 1
		;(nil)[6] = 0
		;(nil)[7] = rs
		;(nil)[8] = 0
		;(nil)[9] = rc
		return nil
	end
	local zRotateMat = function(rs, rc)
		_UPVALUE9_ = nil
		;(nil)[1] = rc
		;(nil)[2] = rs
		;(nil)[3] = 0
		;(nil)[4] = -rs
		;(nil)[5] = rc
		;(nil)[6] = 0
		;(nil)[7] = 0
		;(nil)[8] = 0
		;(nil)[9] = 1
		return nil
	end
	local matrixMult = function(mat_a, mat_b)
		local x, y
		local _UPVALUE0_, mat
		for y = 1, 3 do
			for x = 1, 3 do
				mat[(y - 1) * 3 + x] = mat_b[(y - 1) * 3 + 1] * mat_a[x] + mat_b[(y - 1) * 3 + 2] * mat_a[3 + x] + mat_b[(y - 1) * 3 + 3] * mat_a[6 + x]
			end
		end
		return mat
	end
	local SQRT_2 = math.sqrt(2)
	local SQRT_3 = math.sqrt(3)
	local _ENV, mat = 3, 3
	local _ENV, mat_rot
	local xrs, xrc, yrs, yrc, zrs, zrc, mag
	mag = SQRT_2
	xrs = 1.0 / mag
	xrc = 1.0 / mag
	mat = xRotateMat(xrs, xrc)
	mag = SQRT_3
	yrs = -1.0 / mag
	yrc = SQRT_2 / mag
	mat_rot = yRotateMat(yrs, yrc)
	mat = matrixMult(mat_rot, mat)
	zrs = math.sin(radian)
	zrc = math.cos(radian)
	mat_rot = zRotateMat(zrs, zrc)
	mat = matrixMult(mat_rot, mat)
	mat_rot = yRotateMat(-yrs, yrc)
	mat = matrixMult(mat_rot, mat)
	mat_rot = xRotateMat(-xrs, xrc)
	mat = matrixMult(mat_rot, mat)
	return mat
end
function util.getEllipsePos(angle, centerPos, a, b)
	local x = centerPos.x + a * math.cos(math.rad(angle))
	local y = centerPos.y + b * math.sin(math.rad(angle))
	return cc.p(x, y)
end
function util.split(str, delimiter)
	if str == nil or str == "" or delimiter == nil then
		return nil
	end
	local _ENV, result
	for match in (str .. delimiter):gmatch("(.-)" .. delimiter) do
		table.insert(result, match)
	end
	return result
end
function util.splitNum(str, delimiter)
	if str == nil or str == "" or delimiter == nil then
		return nil
	end
	local _ENV, result
	for match in (str .. delimiter):gmatch("(.-)" .. delimiter) do
		table.insert(result, tonumber(match))
	end
	return result
end
function util.createRichText(text, width)
	local _ENV, elements
	local _ENV, arr
	if type(text) == "string" then
		_ENV = nil
		;(nil).text = text
		table.insert(arr, nil)
	elseif type(text) == "table" then
		arr = text
	else
		return nil
	end
	_ENV = nil
	;(nil).text = ""
	;(nil).fontColor = cc.c3b(255, 255, 255)
	local (nil).fontSize, default = 16, nil
	if arr.default then
		for key, value in pairs(default) do
			default[key] = arr.default[key] or value
		end
	end
	local richText = ccui.RichText:create()
	for i, v in ipairs(arr) do
		local _ENV, data
		for key, value in pairs(default) do
			data[key] = v[key] or value
		end
		local element = ccui.RichElementText:create(i, data.fontColor, 255, data.text, data.font, data.fontSize)
		richText:pushBackElement(element)
	end
	richText:formatText()
	if width then
		local size = richText:getContentSize()
		local height = math.ceil(size.width / width) * size.height
		richText:ignoreContentAdaptWithSize(false)
		richText:setContentSize(width, height)
	end
	return richText
end
util.Action = class("UtilAction")
function util.Action:ctor()
	self.duration = 0
	self.elapsed = 0
end
function util.Action:setFinishCb(cb)
	self.finishCb = cb
end
function util.Action:startWithDuration(node, duration)
	self.node = node
	self.duration = duration
end
function util.Action:updateByTime(dt)
	self.elapsed = self.elapsed + dt
	if self.elapsed < self.duration then
		local percent = self.elapsed / self.duration
		self:update(self.node, percent)
	else
		self.elapsed = self.duration
		self:update(self.node, 1.0)
		if self.finishCb then
			self.finishCb()
		end
	end
end
function util.Action:isFinish()
	return self.duration == self.elapsed
end
function util.Action:update(node, percent)
end
util.MoveTo = class("UtilMoveTo", util.Action)
function util.MoveTo:ctor(startPos, endPos)
	self.super:ctor()
	self.startPos = startPos
	self.endPos = endPos
	self.deltaPos = cc.pSub(endPos, startPos)
end
function util.MoveTo:update(node, percent)
	local pos = cc.pAdd(self.startPos, cc.pMul(self.deltaPos, percent))
	node:setPosition(pos)
end
util.ScaleTo = class("UtilScaleTo", util.Action)
function util.ScaleTo:ctor(startScale, endScale)
	self.super:ctor()
	self.startScale = startScale
	self.endScale = endScale
	self.deltaScale = endScale - startScale
end
function util.ScaleTo:update(node, percent)
	local scale = self.startScale + self.deltaScale * percent
	if not node.originScale then
		node.originScale = node:getScale()
	end
	node:setScale(scale * node.originScale)
end
util.RotateTo = class("UtilRotateTo", util.Action)
function util.RotateTo:ctor(startAngle, endAngle)
	self.super:ctor()
	self.startAngle = startAngle
	self.endAngle = endAngle
	self.deltaAngle = endAngle - startAngle
end
function util.RotateTo:update(node, percent)
	local angle = self.startAngle + self.deltaAngle * percent
	node:setRotation(angle)
end
util.Rotate3DTo = class("UtilRotate3DTo", util.Action)
function util.Rotate3DTo:ctor(startVec3, endVec3)
	self.super:ctor()
	self.startVec3 = startVec3
	self.endVec3 = endVec3
	self.deltaVec3 = util.vec3Sub(endVec3, startVec3)
end
function util.Rotate3DTo:update(node, percent)
	local vec = util.vec3Add(self.startVec3, util.vec3Mul(self.deltaVec3, percent))
	node:setRotation3D(vec)
end
util.FadeTo = class("UtilFadeTo", util.Action)
function util.FadeTo:ctor(startOpacity, endOpacity)
	self.super:ctor()
	self.startOpacity = startOpacity
	self.endOpacity = endOpacity
	self.deltaOpacity = endOpacity - startOpacity
end
function util.FadeTo:update(node, percent)
	local opacity = self.startOpacity + self.deltaOpacity * percent
	node:setOpacity(opacity)
end
util.FadeTimeTo = class("FadeTimeTo", util.Action)
function util.FadeTimeTo:ctor(startOpacity, midOpacity, endOpacity, time)
	self.super:ctor()
	self.startOpacity = startOpacity
	self.midOpacity = midOpacity
	self.endOpacity = endOpacity
	self.time = time
end
function util.FadeTimeTo:update(node, percent)
	local opacity
	if percent <= self.time then
		percent = percent / self.time
		opacity = self.startOpacity + (self.midOpacity - self.startOpacity) * percent
	else
		percent = (percent - self.time) / (1 - self.time)
		opacity = self.midOpacity + (self.endOpacity - self.midOpacity) * percent
	end
	node:setOpacity(opacity)
end
util.DeepTo = class("UtilDeepTo", util.Action)
function util.DeepTo:ctor(startDeep, endDeep)
	self.super:ctor()
	self.startDeep = startDeep
	self.endDeep = endDeep
	self.deltaDeep = endDeep - startDeep
end
function util.DeepTo:update(node, percent)
	local zOrder = self.startDeep + self.deltaDeep * percent
	node:setLocalZOrder(zOrder)
end
util.ValueTo = class("UtilValueTo", util.Action)
function util.ValueTo:ctor(setValue, startValue, endValue)
	self.super:ctor()
	self.setValue = setValue
	self.startValue = startValue
	self.endValue = endValue
	self.deltaValue = endValue - startValue
end
function util.ValueTo:update(node, percent)
	local value = self.startValue + self.deltaValue * percent
	self.setValue(value)
end
util.ColorTo = class("UtilColorTo", util.Action)
function util.ColorTo:ctor(startColor, endColor)
	self.super:ctor()
	self.startColor = startColor
	self.endColor = endColor
	self.deltaColor = util.c3bSub(endColor, startColor)
end
function util.ColorTo:update(node, percent)
	local color = util.c3bAdd(self.startColor, util.c3bMul(self.deltaColor, percent))
	node:setColor(color)
end
util.EllipseTo = class("UtilEllipseTo", util.Action)
function util.EllipseTo:ctor(startAngle, endAngle, orgin, a, b)
	self.startAngle = startAngle
	self.endAngle = endAngle
	self.deltaAngle = endAngle - startAngle
	self.orgin = orgin
	self.a = a
	self.b = b
end
function util.EllipseTo:update(node, percent)
	local angle = math.rad(self.startAngle + self.deltaAngle * percent)
	local x = self.orgin.x + self.a * math.cos(angle)
	local y = self.orgin.y + self.b * math.sin(angle)
	node:setPosition(cc.p(x, y))
end
function util.hitTest(n, pos)
	if not n then
		return false
	end
	pos = n:convertToNodeSpace(pos)
	local size = n:getContentSize()
	local rect = cc.rect(0, 0, size.width, size.height)
	if cc.rectContainsPoint(rect, pos) then
		return true
	end
	return false
end
function util.hitAlphaTest(n, pos)
	if not n then
		return false
	end
	if n.hitTest then
		return n.hitTest(n, pos)
	end
	local nodePos = n:convertToNodeSpace(pos)
	local size = n:getContentSize()
	local rect = cc.rect(0, 0, size.width, size.height)
	if cc.rectContainsPoint(rect, nodePos) then
		local value = display.getNodePixel(n, pos.x, pos.y, true)
		if 0 < value.a then
			return true
		else
			return false
		end
	else
		return false
	end
end
function util.addTouchByPriority(node, func, swallow, priority)
	local listener = cc.EventListenerTouchOneByOne:create()
	listener:setSwallowTouches(swallow or false)
	local onTouchBegan = function(touch, event)
		local pos = touch:getLocation()
		if node:isVisible() and util.hitTest(node, pos) then
			func(node, ccui.TouchEventType.began, pos)
			return true
		end
		return false
	end
	local onTouchMoved = function(touch, event)
		local pos = touch:getLocation()
		func(node, ccui.TouchEventType.moved, pos)
	end
	local onTouchEnded = function(touch, event)
		local pos = touch:getLocation()
		if util.hitTest(node, pos) then
			func(node, ccui.TouchEventType.ended, pos)
		else
			func(node, ccui.TouchEventType.canceled, pos)
		end
	end
	listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
	listener:registerScriptHandler(onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED)
	listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)
	listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_CANCELLED)
	node:getEventDispatcher():addEventListenerWithFixedPriority(listener, priority or 0)
	node.listener = listener
end
function util.addTouch(node, func, swallow, clip, hitFunc)
	local hitFunc = hitFunc or util.hitTest
	local onTouchBegan = function(sender, type)
		local pos = sender:getTouchBeganPosition()
		local skipClipCheck = true
		if clip then
			skipClipCheck = false
		end
		if node:isVisible() and hitFunc(node, pos) and (skipClipCheck or hitFunc(clip, pos)) then
			func(node, ccui.TouchEventType.began, pos)
			return true
		end
		return false
	end
	local onTouchMoved = function(sender, type)
		local pos = sender:getTouchMovePosition()
		func(node, ccui.TouchEventType.moved, pos)
	end
	local onTouchEnded = function(sender, type)
		local pos = sender:getTouchEndPosition()
		if util.hitTest(node, pos) then
			func(node, ccui.TouchEventType.ended, pos)
		else
			func(node, ccui.TouchEventType.canceled, pos)
		end
	end
	node:setTouchEnabled(true)
	node:addTouchEventListener(function(sender, type)
		if type == ccui.TouchEventType.began then
			onTouchBegan(sender, type)
		elseif type == ccui.TouchEventType.moved then
			onTouchMoved(sender, type)
		elseif type == ccui.TouchEventType.ended or type == ccui.TouchEventType.canceled then
			onTouchEnded(sender, type)
		end
	end)
end
function util.delTouch(node)
	if node.listener then
		node:getEventDispatcher():removeEventListener(node.listener)
		node.listener = nil
	end
end
function util.getRadian(a, b)
	local radian = math.atan2(b.x - a.x, b.y - a.y)
	if radian < 0 then
		radian = 2 * math.pi + radian
	end
	return radian
end
function util.getAngle(a, b)
	return math.radian2angle(util.getRadian(a, b))
end
function util.correctZero(num)
	if math.abs(num) >= 0 and math.abs(num) <= 1.0E-14 then
		return 0
	else
		return num
	end
end
function util.rotatePoint(point, anchorPoint, angle)
	return cc.pRotateByAngle(point, anchorPoint, math.pi * 2 - math.angle2radian(angle))
end
function util.createParticle(v)
	local plist = v.plist
	if not v.pos then
		_ENV = v.pos
		v.pos.x = 0
		local v.pos.y, pos = 0, v.pos
	end
	if not v.scale then
		_ENV = v.scale
		v.scale.x = 1
		local v.scale.y, scale = 1, v.scale
	end
	local posType = v.posType or cc.POSITION_TYPE_RELATIVE
	local rotate = v.rotate or 0
	local particle = cc.ParticleSystemQuad:create(plist)
	particle:setPosition(cc.p(pos.x, pos.y))
	particle:setScaleX(scale.x)
	particle:setScaleY(scale.y)
	particle:setPositionType(posType)
	particle:setRotation(rotate)
	return particle
end
function util.serialize(t)
	local _ENV, mark
	local _ENV, assign
	local function ser_table(tbl, parent)
		mark[tbl] = parent
		local mark, tmp
		for k, v in pairs(tbl) do
			local key = type(k) == "number" and "[" .. k .. "]" or "[" .. string.format("%q", k) .. "]"
			if type(v) == "table" then
				local dotkey = parent .. (type(k) == "number" and key or "." .. key)
				if mark[v] then
					table.insert(assign, dotkey .. "=" .. mark[v])
				else
					table.insert(tmp, key .. "=" .. ser_table(v, dotkey))
				end
			else
				if type(v) == "string" then
					v = string.format("%q", v)
				elseif type(v) == "boolean" then
					v = v and "true" or "false"
				end
				table.insert(tmp, key .. "=" .. v)
			end
		end
		return "{" .. table.concat(tmp, ",") .. "}"
	end
	return ser_table(t, "ret") .. table.concat(assign, " ")
end
function util.unserialize(str)
	str = "return " .. str
	local fun = loadstring(str)
	if fun then
		return fun()
	end
end

local commonRedPointLayer = class("commonRedPointLayer", function()
	return ccui.Layout:create()
end)
function commonRedPointLayer:ctor()
	self.redPointTarget = nil
	self.raidusValid = 10000.0
	self.redPointSourcePos = cc.p(0, 0)
	self.redPointBeginPos = cc.p(0, 0)
	self.redPointMovePos = cc.p(0, 0)
	self.redPointEndPos = cc.p(0, 0)
	self.isNeedDraw = false
	self.otherData = nil
	self.numberBgNode = nil
	self.zOrderNumberBg = 2
	self.zOrderDrawNode = 1
	self.minr = 8
	self.maxr = 14
	self.R = 18
	self.minr1 = 8
	self.maxr1 = 14
	self.R1 = 18
	self.minr2 = 8
	self.maxr2 = 14
	self.R2 = 18
	self.drawColor = cc.c4f(0.8235294117647058, 0.043137254901960784, 0.043137254901960784, 1.0)
	self:setContentSize(display.size)
	self.time = 0
	local layerUpdate = function(fTime)
		self.time = self.time + fTime
		if self.numberBgNode then
			self.redPointMovePos = cc.p(self.numberBgNode:getPosition())
			if self.isNeedDraw and self.labelNumber then
				local dSQ = cc.pDistanceSQ(self.redPointSourcePos, self.redPointMovePos)
				if dSQ <= self.raidusValid then
					self.labelNumber:setVisible(true)
				else
				end
			end
		end
	end
	self:scheduleUpdateWithPriorityLua(layerUpdate, 0)
	self:createDrawNode(self)
end
function commonRedPointLayer:initWithData(data)
	self.number = data.number
	self:createRedPoint(self.number)
	self.redPointSender = data.sender
	self.callBack = data.callBack
	self.autoEnableTouch = data.autoEnableTouch
	self.otherData = data.otherData
	self.numberBg = data.imgNumberBg
	self.minr = data.minr or self.minr
	self.maxr = data.maxr or self.maxr
	self.R = data.R or self.R
	self.minr = self.minr2
	self.maxr = self.maxr2
	self.R = self.R2
	if self.autoEnableTouch then
		self.redPointSender:setSwallowTouches(true)
		self.redPointSender:setTouchEnabled(true)
		self.redPointSender:addTouchEventListener(handler(self, self.onSenderTouch))
	end
	if self.redPointDrawNode then
		self.redPointDrawNode:setVisible(true)
	end
	if self.labelNumber then
		self.labelNumber:setVisible(true)
	end
end
function commonRedPointLayer:onSenderTouch(sender, event)
	if event == ccui.TouchEventType.began then
		local sourcePoint = sender:convertToWorldSpace(cc.p(sender:getContentSize().width / 2, sender:getContentSize().height / 2))
		_ENV = cc.p(sender:getContentSize().width / 2, sender:getContentSize().height / 2)
		cc.p(sender:getContentSize().width / 2, sender:getContentSize().height / 2).sender = sender
		cc.p(sender:getContentSize().width / 2, sender:getContentSize().height / 2).event = event
		cc.p(sender:getContentSize().width / 2, sender:getContentSize().height / 2).number = self.number
		cc.p(sender:getContentSize().width / 2, sender:getContentSize().height / 2).centerPos = sourcePoint
		cc.p(sender:getContentSize().width / 2, sender:getContentSize().height / 2).otherData = self.otherData
		self:touchCallBack(cc.p(sender:getContentSize().width / 2, sender:getContentSize().height / 2))
	elseif event == ccui.TouchEventType.moved then
		_ENV = self
		self.sender = sender
		self.event = event
		self:touchCallBack(self)
	elseif event == ccui.TouchEventType.canceled then
		_ENV = self
		self.sender = sender
		self.event = event
		self:touchCallBack(self)
	elseif event == ccui.TouchEventType.ended then
		_ENV = self
		self.sender = sender
		self.event = event
		self:touchCallBack(self)
	end
end
function commonRedPointLayer:touchCallBack(data)
	local sender = data.sender
	local event = data.event
	if event == ccui.TouchEventType.began then
		local number = data.number
		self:createRedPoint(number)
		local touchBeganPoint = sender:getTouchBeganPosition()
		local nodePos = self:convertToNodeSpace(touchBeganPoint)
		self.redPointBeginPos = nodePos
		self.redPointSourcePos = self:convertToNodeSpace(data.centerPos)
		self.numberBgNode:setPosition(nodePos)
		self.redPointSender = sender
		if self.numberBg then
			self.numberBg:setVisible(false)
		end
		self.isNeedDraw = true
	elseif event == ccui.TouchEventType.moved then
		local touchmovePoint = sender:getTouchMovePosition()
		local nodePos = self:convertToNodeSpace(touchmovePoint)
		self.numberBgNode:setPosition(nodePos)
	elseif event == ccui.TouchEventType.canceled then
		local touchmovePoint = sender:getTouchMovePosition()
		local nodePos = self:convertToNodeSpace(touchmovePoint)
		self.redPointMovePos = nodePos
		local isVanish = self:isVanish()
		if isVanish then
			self:callHandler(REDPOINT_VANISH)
			self:runVanishAnimation()
		elseif self.numberBgNode then
			self:runRedPointAnimation()
		end
	elseif event == ccui.TouchEventType.ended then
		local touchPoint = sender:getTouchEndPosition()
		local nodePos = self:convertToNodeSpace(touchPoint)
		self.redPointMovePos = nodePos
		local isVanish = self:isVanish()
		if isVanish then
			self:callHandler(REDPOINT_VANISH)
			self:runVanishAnimation()
		elseif self.numberBgNode then
			self:runRedPointAnimation()
		end
	end
end
function commonRedPointLayer:callHandler(eventType)
	if self.callBack then
		_UPVALUE0_ = self.callBack
		self.callBack.sender = self.redPointSender
		self.callBack.eventType = eventType
		local self.callBack.otherData, event = self.otherData, self.callBack
		self.callBack(event)
	end
end
function commonRedPointLayer:isVanish()
	local dSQ = cc.pDistanceSQ(self.redPointSourcePos, self.redPointMovePos)
	if dSQ <= self.raidusValid then
		isVanish = false
	else
		return true
	end
end
function commonRedPointLayer:setNumber(number)
	if self.labelNumber then
		number = number or ""
		self.number = number
		self.labelNumber:setString(number)
	end
end
function commonRedPointLayer:getNumber()
	return self.number
end
function commonRedPointLayer:createRedPoint(number)
	if self.numberBgNode ~= nil then
		self.labelNumber:setString(number)
		self.numberBgNode:setVisible(true)
	else
		self.numberBgNode = display.newNode()
		self.numberBgNode:addTo(self, self.zOrderNumberBg)
		self.numberBgNode:setAnchorPoint(0.5, 0.5)
		self.numberBgNode:setPosition(cc.p(0, 0))
		_ENV = self.numberBgNode
		self.numberBgNode.text = number
		self.numberBgNode.font = "res/Default/defaultBMFont.fnt"
		self.numberBgNode.align = cc.TEXT_ALIGNMENT_CENTER
		self.numberBgNode.x = 0
		self.numberBgNode.y = 0
		self.labelNumber = display.newBMFontLabel(self.numberBgNode)
		self.labelNumber:setScale(0.8)
		self.labelNumber:addTo(self.numberBgNode)
		self.numberBgNode:setLocalZOrder(self.zOrderNumberBg)
	end
end
function commonRedPointLayer:runRedPointAnimation()
	if self.numberBgNode then
		local touchPos = cc.p(self.numberBgNode:getPosition())
		local sourcePos = self.redPointSourcePos
		local vec = cc.pNormalize(cc.pSub(touchPos, sourcePos))
		local rvec = cc.p(-vec.x, -vec.y)
		local speed = 250
		local length = cc.pGetLength(cc.pSub(touchPos, sourcePos))
		local dt = length / speed
		local easeAction = cc.EaseElasticOut:create(cc.MoveTo:create(dt, sourcePos))
		local callEnd = cca.callFunc(function()
			self.isNeedDraw = false
			self.numberBgNode:setVisible(false)
			if self.numberBg then
				self.numberBg:setVisible(true)
			end
		end)
		_UPVALUE2_ = cc.MoveTo:create(dt, sourcePos)
		cc.MoveTo:create(dt, sourcePos)[1] = easeAction
		cc.MoveTo:create(dt, sourcePos)[2] = callEnd
		self.numberBgNode:runAction(cca.seq(cc.MoveTo:create(dt, sourcePos)))
	end
end
function commonRedPointLayer:runVanishAnimation()
	if self.redPointDrawNode then
		self.redPointDrawNode:setVisible(false)
		if self.labelNumber then
			self.labelNumber:setVisible(false)
		end
	end
	if self.effectVanish then
		self.effectVanish:setPosition(self.redPointMovePos)
		if self.effectVanish.resetSystem then
			self.effectVanish:resetSystem()
		end
	else
		local particleFile = "Particle/et_sankai.plist"
		self.effectVanish = cc.ParticleSystemQuad:create(particleFile)
		self.effectVanish:setPosition(self.redPointMovePos)
		self.effectVanish:setPositionType(cc.POSITION_TYPE_RELATIVE)
		self.effectVanish:setAutoRemoveOnFinish(false)
		self.effectVanish:addTo(self)
		self.effectVanish:setLocalZOrder(100)
	end
end
function commonRedPointLayer:createGlNode(parent)
	local glNode = gl.glNodeCreate()
	self.glRedPointNode = glNode
	parent:addChild(glNode, 10)
	local primitivesDraw = function(transform, transformUpdated)
		kmGLPushMatrix()
		kmGLLoadMatrix(transform)
		gl.lineWidth(1)
		cc.DrawPrimitives.drawColor4B(255, 0, 0, 255)
		if not self.isNeedDraw then
			return
		end
		local dSQ = cc.pDistanceSQ(self.redPointSourcePos, self.redPointMovePos)
		if dSQ <= self.raidusValid then
			local maxr = 18
			local minr = maxr / 3
			local factor = dSQ / self.raidusValid
			factor = math.min(1, math.max(factor, 0))
			local r = maxr * (1.0 - factor) + minr * factor
			local R = 26
			local o = self.redPointSourcePos
			local p0 = self.redPointMovePos
			cc.DrawPrimitives.drawSolidCircle(o, r, 0, 20, 1, 1)
			cc.DrawPrimitives.drawSolidCircle(p0, R, 0, 20, 1, 1)
			local ret = self:calcMetaBall(o, r, p0, R)
			cc.DrawPrimitives.setPointSize(2)
			cc.DrawPrimitives.drawQuadBezier(ret.p1, ret.p5, ret.p2, 20)
			cc.DrawPrimitives.drawQuadBezier(ret.p3, ret.p6, ret.p4, 20)
			cc.DrawPrimitives.drawColor4B(255, 255, 0, 255)
			cc.DrawPrimitives.drawPoint(ret.p1)
			cc.DrawPrimitives.drawPoint(ret.p3)
			cc.DrawPrimitives.drawColor4B(255, 0, 255, 255)
			cc.DrawPrimitives.drawPoint(ret.p2)
			cc.DrawPrimitives.drawPoint(ret.p4)
			cc.DrawPrimitives.drawColor4B(0, 255, 255, 255)
			cc.DrawPrimitives.drawPoint(ret.p5)
			cc.DrawPrimitives.drawPoint(ret.p6)
			cc.DrawPrimitives.drawColor4B(0, 255, 0, 255)
			cc.DrawPrimitives.drawCircle(o, ret.d, 0, 30, false)
			local segments = 10
			gl.lineWidth(2)
			local step = 1 / segments
			for t = 0, 1, step do
				local tNext = t + step
				if tNext <= 1 then
					local B1 = self:calcQuadBezier(ret.p1, ret.p5, ret.p2, t)
					local B2 = self:calcQuadBezier(ret.p3, ret.p6, ret.p4, t)
					local B3 = self:calcQuadBezier(ret.p1, ret.p5, ret.p2, tNext)
					local B4 = self:calcQuadBezier(ret.p3, ret.p6, ret.p4, tNext)
					_UPVALUE3_ = ret.p3
					ret.p3[1] = B1
					ret.p3[2] = B2
					ret.p3[3] = B4
					cc.DrawPrimitives.drawSolidPoly(ret.p3, 3, cc.c4f(1, 0, 0, 1))
					_UPVALUE3_ = ret.p3
					ret.p3[1] = B1
					ret.p3[2] = B4
					ret.p3[3] = B3
					cc.DrawPrimitives.drawSolidPoly(ret.p3, 3, cc.c4f(1, 0, 0, 1))
				end
			end
		else
		end
		gl.lineWidth(1)
		cc.DrawPrimitives.drawColor4B(255, 255, 255, 255)
		kmGLPopMatrix()
	end
	local time = 0
	local parentSize = parent:getContentSize()
	glNode:registerScriptDrawHandler(primitivesDraw)
	glNode:ignoreAnchorPointForPosition(false)
	glNode:setAnchorPoint(cc.p(0, 0))
	glNode:setPosition(0, 0)
end
function commonRedPointLayer:createDrawNode(parent)
	local drawNode = cc.DrawNode:create()
	parent:addChild(drawNode, self.zOrderDrawNode)
	self.redPointDrawNode = drawNode
	local circleSegments = 40
	local bezierSegments = 50
	local updateDraw = function()
		local maxr = self.maxr
		local minr = self.minr
		local R = self.R
		local r = self.maxr
		drawNode:clear()
		if not self.isNeedDraw then
			return
		end
		local dSQ = cc.pDistanceSQ(self.redPointSourcePos, self.redPointMovePos)
		if dSQ <= self.raidusValid then
			local factor = dSQ / self.raidusValid
			factor = math.min(1, math.max(factor, 0))
			r = maxr * (1.0 - factor) + minr * factor
			local o = self.redPointSourcePos
			local p0 = self.redPointMovePos
			local ret = self:calcMetaBall(o, r, p0, R)
			drawNode:drawSolidCircle(o, r, 0, circleSegments, self.drawColor)
			drawNode:drawSolidCircle(p0, R, 0, circleSegments, self.drawColor)
			local step = 1 / bezierSegments
			for t = 0, 1, step do
				local tNext = t + step
				if tNext <= 1 then
					local B1 = self:calcQuadBezier(ret.p1, ret.p5, ret.p2, t)
					local B2 = self:calcQuadBezier(ret.p3, ret.p6, ret.p4, t)
					local B3 = self:calcQuadBezier(ret.p1, ret.p5, ret.p2, tNext)
					local B4 = self:calcQuadBezier(ret.p3, ret.p6, ret.p4, tNext)
					drawNode:drawTriangle(B1, B2, B4, self.drawColor)
					drawNode:drawTriangle(B1, B4, B3, self.drawColor)
				end
			end
		else
			local p0 = self.redPointMovePos
			drawNode:drawSolidCircle(p0, R, 0, circleSegments, self.drawColor)
		end
	end
	local drawNodeUpdate = function(fTime)
		updateDraw()
	end
	drawNode:scheduleUpdateWithPriorityLua(drawNodeUpdate, 0)
	drawNode:ignoreAnchorPointForPosition(false)
	drawNode:setAnchorPoint(cc.p(0, 0))
	drawNode:setPosition(0, 0)
end
function commonRedPointLayer:calcMetaBall(o, r, p0, R)
	local _ENV, p1
	local _ENV, p3
	local _ENV, p2
	local _ENV, p4
	local _ENV, p5
	local _ENV, p6
	local d = cc.pGetLength(cc.pSub(p0, o))
	local gamma = math.asin((R - r) / d)
	local alpha = math.atan((p0.y - o.y) / (p0.x - o.x))
	local beta = math.pi / 2 - gamma - alpha
	p1.x = o.x - r * math.cos(beta)
	p1.y = o.y + r * math.sin(beta)
	p2.x = p0.x - R * math.cos(beta)
	p2.y = p0.y + R * math.sin(beta)
	local zerta = math.pi / 2 + gamma - alpha
	p3.x = o.x + math.cos(zerta) * r
	p3.y = o.y - math.sin(zerta) * r
	p4.x = p0.x + math.cos(zerta) * R
	p4.y = p0.y - math.sin(zerta) * R
	p5 = cc.pMidpoint(p1, p4)
	_ENV, p6 = cc.pMidpoint(p3, p2), cc.pMidpoint(p3, p2)
	cc.pMidpoint(p3, p2).p1 = p1
	cc.pMidpoint(p3, p2).p2 = p2
	cc.pMidpoint(p3, p2).p3 = p3
	cc.pMidpoint(p3, p2).p4 = p4
	cc.pMidpoint(p3, p2).p5 = p5
	cc.pMidpoint(p3, p2).p6 = p6
	cc.pMidpoint(p3, p2).d = d
	return (cc.pMidpoint(p3, p2))
end
function commonRedPointLayer:calcQuadBezier(p1, p2, p3, t)
	local c1 = (1 - t) ^ 2
	local c2 = 2 * t * (1 - t)
	local c3 = t ^ 2
	local ret = cc.pAdd(cc.pAdd(cc.pMul(p1, c1), cc.pMul(p2, c2)), cc.pMul(p3, c3))
	return ret
end
function commonRedPointLayer:hideRedPoint()
	if self.numberBgNode then
		self.numberBgNode:setVisible(false)
	end
	if self.redPointDrawNode then
		self.redPointDrawNode:setVisible(false)
	end
	if self.labelNumber then
		self.labelNumber:setVisible(true)
	end
end
return commonRedPointLayer

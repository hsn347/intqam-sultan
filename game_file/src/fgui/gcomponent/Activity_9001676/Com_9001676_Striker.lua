local baseComponent = require("fgui.base.baseComponent")
local Com_9001676_Striker = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001676/Com_9001676_Striker", Com_9001676_Striker)
local MinMagnitudeVelocity = 20
local minDistance = 20
local RedColor = cc.c3b(255, 0, 0)
local NormalColor = cc.c3b(255, 255, 255)
local baseV = 3500
local maxDistancePower = 100
_ENV = 255
;(255).P1 = 0
local (255).P2, PLAYER = 1, 255
function Com_9001676_Striker:onInit()
	self.arrow = self.fields.arrow
	self.striker = self.fields.striker
	self.power = self.fields.power
	self.centerPos = cc.p(0, 0)
	self:addEventListener(fgui.UIEventType.TouchBegin, handler(self, self.onTouchBegin))
	self:addEventListener(fgui.UIEventType.TouchMove, handler(self, self.onTouchMove))
	self:addEventListener(fgui.UIEventType.TouchEnd, handler(self, self.onTouchEnd))
	self.fired = false
	self.isWaitingVelocityStart = false
	self.isMyTurn = true
	self.isCanFire = true
end
function Com_9001676_Striker:setGameComp(game)
	self.Com_9001676_game = game
end
function Com_9001676_Striker:onHide()
	self:stopAllActions()
end
function Com_9001676_Striker:onShow()
	self.arrow:setVisible(false)
	self.power:setVisible(false)
	local circle = cc.TSPhysicsBody:createCircle(self:getWidth() / 2, nil, cc.p(0.5, 0.5))
	circle:setMass(3)
	circle:setCollisionDetectionMode(true)
	circle:setTriggerEventCalback(handler(self, self.onStrikeTriggerEventCallback))
	circle:getShape(0):setFriction(0)
	circle:getShape(0):setRestitution(1.0)
	self:setTSPhysicsBody(circle)
	circle:setLinearDamping(2)
	circle:setCollisionEventCallback(handler(self, self.onBallCollisionEventCallback))
	self.shape = circle:getShape(0)
	self.physicsBody = circle
end
function Com_9001676_Striker:onBallCollisionEventCallback(eventType, name, name2, relativeVelocityMagnitude)
	if eventType == fgui.PhysicsEvent.CollisionEnter and (name == "board1" or name == "board2" or name == "board3" or name == "board4") and 150 < relativeVelocityMagnitude then
		SoraDPlaySound("activity_9001676", "krone_strike")
	end
end
function Com_9001676_Striker:onTouchBegin(eventContext)
	if not self.isCanFire or self.fired or not self.isMyTurn then
		return
	end
	eventContext:captureTouch()
	self.arrow:setVisible(true)
	self.arrow:setRotation(0)
	self.power:setVisible(true)
	self.power:setScale(0.5)
	self.Com_9001676_game:stopGuideTips()
end
function Com_9001676_Striker:resetPos()
	self:setPosition(300, 554)
end
function Com_9001676_Striker:onTouchMove(eventContext)
	if not self.isMyTurn then
		return
	end
	local fromPos = self.centerPos
	local toPos = self:globalToLocal(eventContext:getInput():getPosition())
	minDistance = eventContext:getInput():getPosition()
	eventContext:getInput():getPosition()[1] = fromPos
	eventContext:getInput():getPosition()[2] = toPos
	dump(eventContext:getInput():getPosition())
	toPos.x = -toPos.x
	toPos.y = -toPos.y
	local angle = SoraDGetAngleByPos(fromPos, toPos)
	self.arrow:setRotation(angle + 90)
	local distance = cc.pGetDistance(fromPos, toPos)
	distance = math.min(distance, maxDistancePower)
	print("==dLength1==", distance)
	self.power:setScale(0.5 + distance / maxDistancePower * 1.5)
	self.arrow:setVisible(distance > minDistance)
	self.power:setVisible(distance > minDistance)
end
function Com_9001676_Striker:onTouchEnd(eventContext)
	if not self.isCanFire or self.fired or not self.isMyTurn then
		return
	end
	self.arrow:setVisible(false)
	self.power:setVisible(false)
	local fromPos = self.centerPos
	local toPos = self:globalToLocal(eventContext:getInput():getPosition())
	toPos.x = -toPos.x
	dump(toPos, "Com_9001676_Striker:onTouchEnd")
	local direction = cc.pSub(toPos, fromPos)
	if direction.x == 0 and direction.y == 0 then
		print("random direction")
		direction.x = 0
		direction.y = 1
	end
	self:doReleaseStriker(direction)
end
function Com_9001676_Striker:doReleaseStriker(direction)
	local dLength1 = cc.pGetLength(direction)
	local nd1 = cc.p(direction.x / dLength1, direction.y / dLength1)
	dLength1 = math.min(dLength1, maxDistancePower)
	local velocity1 = cc.p(math.floor(baseV * nd1.x * dLength1 / maxDistancePower), math.floor(baseV * nd1.y * dLength1 / maxDistancePower))
	if dLength1 < minDistance then
		self.Com_9001676_game:startShowGuideAction()
		return
	end
	self:sendFire(self:getPosition(), velocity1)
	self.Com_9001676_game:stopGuideTips()
end
function Com_9001676_Striker:showAITarget(strikePos, velocity, AICfg)
	self.fired = true
	self.isWaitingVelocityStart = true
	self:runAction(ffa.seq(ffa.moveTo(0.2, strikePos.x, strikePos.y), ffa.callFunc(function()
		local distance = math.random(AICfg.aim_power[1], AICfg.aim_power[2]) / 100 * maxDistancePower
		local angleDegrees = math.random(AICfg.aim_angle[1], AICfg.aim_angle[2])
		if angleDegrees % 2 == 0 then
			angleDegrees = -angleDegrees
		end
		local angleRadians = math.rad(angleDegrees)
		local cosAngle = math.cos(angleRadians)
		local sinAngle = math.sin(angleRadians)
		_ENV = angleRadians
		angleRadians.x = velocity.x * cosAngle - velocity.y * sinAngle
		local angleRadians.y, newVelocity = velocity.x * sinAngle + velocity.y * cosAngle, angleRadians
		velocity.x = math.floor(newVelocity.x * baseV * distance / maxDistancePower)
		velocity.y = math.floor(newVelocity.y * baseV * distance / maxDistancePower)
		local toPos = cc.p(-velocity.x, velocity.y)
		local angle = SoraDGetAngleByPos(self.centerPos, toPos)
		self.arrow:setVisible(true)
		self.power:setVisible(true)
		self.arrow:setRotation(angle - 90)
		self.power:setScale(0.5 + distance / maxDistancePower)
	end), ffa.delay(1), ffa.callFunc(function()
		self:sendFire(strikePos, velocity, true)
	end)))
end
function Com_9001676_Striker:resetStriker(isMyTurn, player)
	if not self.physicsBody then
		return
	end
	self.shape:setTrigger(true)
	self.isCanFire = true
	self.striker:setColor(NormalColor)
	self.fired = false
	self.physicsBody:resetCPBody()
	self:updateXYByDisplayObject()
	self:setRotation(0)
	self:setPosition(305, player == PLAYER.P1 and 512 or 98)
	self.isMyTurn = isMyTurn
end
function Com_9001676_Striker:updateTime(dt)
	if self.fired then
		if self.fireVelocity ~= nil then
			self:fireStriker()
			return false
		end
		if self.isWaitingVelocityStart then
			return false
		end
		local value = self.physicsBody:getVelocityMagnitude()
		if value < MinMagnitudeVelocity then
			if value ~= 0 then
				self.physicsBody:resetCPBody()
			end
			return true
		end
	end
	return false
end
function Com_9001676_Striker:onStrikeTriggerEventCallback(eventType, name, triggerName)
	if self.fired then
		return
	end
	if eventType == fgui.PhysicsEvent.TriggerEnter or eventType == fgui.PhysicsEvent.TriggerStay then
		if self.isCanFire then
			self.isCanFire = false
			if self.isMyTurn then
				self.striker:setColor(RedColor)
			end
		end
	elseif eventType == fgui.PhysicsEvent.TriggerExit and not self.isCanFire then
		self.isCanFire = true
		self.striker:setColor(NormalColor)
	end
end
function Com_9001676_Striker:setFireCallback(callback)
	self.fireCallback = callback
end
function Com_9001676_Striker:sendFireData(str)
	if self.fired then
		return
	end
	dump(str, "Com_9001676_Striker:sendFireData")
	local poses = string.split(str, ",")
	if #poses ~= 4 then
		dump(poses, "poses")
		return
	end
	self:sendFire(cc.p(tonumber(poses[1]), tonumber(poses[2])), cc.p(tonumber(poses[3]), tonumber(poses[4])))
end
function Com_9001676_Striker:sendFire(pos, velocity, isAI)
	self.arrow:setVisible(false)
	self.power:setVisible(false)
	if self.isTimeUp then
		return
	end
	if self.fireCallback then
		self.fireCallback(pos, velocity)
	end
	if isAI then
		self:onReqFireSuccess(pos, velocity)
	end
end
function Com_9001676_Striker:onReqFireSuccess(pos, velocity, isNotify)
	self.physicsBody:resetCPBody()
	self:updateXYByDisplayObject()
	self:setRotation(0)
	if isNotify then
		self:runAction(ffa.seq(ffa.moveTo(0.1, pos.x, pos.y), ffa.callFunc(function()
			self:setPosition(pos)
			local toPos = cc.p(-velocity.x, velocity.y)
			local angle = SoraDGetAngleByPos(self.centerPos, toPos)
			self.arrow:setVisible(true)
			self.power:setVisible(true)
			self.arrow:setRotation(angle - 90)
			local mag = math.sqrt(velocity.x ^ 2 + velocity.y ^ 2)
			local distance = mag / baseV * maxDistancePower
			self.power:setScale(0.5 + distance / maxDistancePower)
		end), ffa.delay(0.5), ffa.callFunc(function()
			self.arrow:setVisible(false)
			self.power:setVisible(false)
			self.fireVelocity = velocity
		end)))
	else
		self:setPosition(pos)
		self:runAction(ffa.seq(ffa.delay(0.1), ffa.callFunc(function()
			self.fireVelocity = velocity
		end)))
	end
	self.fired = true
	self.isWaitingVelocityStart = true
end
function Com_9001676_Striker:fireStriker()
	if not self.fireVelocity then
		return
	end
	self.Com_9001676_game:setIsWaitingShotEnd(true)
	self.isWaitingVelocityStart = false
	self.shape:setTrigger(false)
	self.physicsBody:setDynamic(true)
	self.physicsBody:setVelocity(self.fireVelocity)
	self.fireVelocity = nil
end
function Com_9001676_Striker:onTimeUp()
	self.arrow:setVisible(false)
	self.power:setVisible(false)
end
return Com_9001676_Striker

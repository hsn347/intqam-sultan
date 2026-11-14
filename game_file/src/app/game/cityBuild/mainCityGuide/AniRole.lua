local AniRole = class("AniRole", function()
	return display.newNode()
end)
_ENV = "AniRole"
;("AniRole").NONE = 0
;("AniRole").STAND = 1
;("AniRole").MOVE = 2
;("AniRole").MOVE2 = 3
;("AniRole").MOVE3 = 4
;("AniRole").FIX = 5
;("AniRole").ATTACK = 6
;("AniRole").SKILL = 7
;("AniRole").DIE = 8
;("AniRole").STAND2 = 9
;("AniRole").STAND3 = 10
;("AniRole").FIX2 = 11
;("AniRole").STAND4 = 12
;("AniRole").MOVE4 = 13
;("AniRole").DIE2 = 14
local _ENV, ("AniRole").SKILL2, RoleState = function()
	return display.newNode()
end, 15, "AniRole"
_ENV = nil
;(nil).name = "dj"
;(function()
	return display.newNode()
end)[RoleState.STAND], (nil).loop = nil, true
_ENV = nil
;(nil).name = "bzdj"
;(function()
	return display.newNode()
end)[RoleState.STAND2], (nil).loop = nil, true
_ENV = nil
;(nil).name = "ss"
;(function()
	return display.newNode()
end)[RoleState.STAND3], (nil).loop = nil, true
_ENV = nil
;(nil).name = "bbdj"
;(function()
	return display.newNode()
end)[RoleState.STAND4], (nil).loop = nil, true
_ENV = nil
;(nil).name = "yd"
;(nil).loop = true
;(nil).autoStand = true
;(function()
	return display.newNode()
end)[RoleState.MOVE], (nil).speed = nil, 80
_ENV = nil
;(nil).name = "zou"
;(nil).loop = true
;(nil).autoStand = true
;(nil).speed = 50
;(function()
	return display.newNode()
end)[RoleState.MOVE2], (nil).count = nil, 12
_ENV = nil
;(nil).name = "yd"
;(nil).loop = true
;(nil).autoStand = true
;(function()
	return display.newNode()
end)[RoleState.MOVE3], (nil).speed = nil, 50
_ENV = nil
;(nil).name = "bbzou"
;(nil).loop = true
;(nil).autoStand = true
;(nil).speed = 50
;(function()
	return display.newNode()
end)[RoleState.MOVE4], (nil).count = nil, 12
_ENV = nil
;(nil).name = "cq"
;(function()
	return display.newNode()
end)[RoleState.FIX], (nil).loop = nil, true
_ENV = nil
;(nil).name = "zl"
;(function()
	return display.newNode()
end)[RoleState.FIX2], (nil).loop = nil, true
_ENV = nil
;(nil).name = "gj"
;(function()
	return display.newNode()
end)[RoleState.ATTACK], (nil).loop = nil, true
_ENV = nil
;(nil).name = "jn"
;(nil).loop = false
;(nil).autoStand = true
;(function()
	return display.newNode()
end)[RoleState.SKILL], (nil).skill = nil, true
_ENV = nil
;(nil).name = "gj"
;(nil).loop = false
;(nil).autoStand = true
;(function()
	return display.newNode()
end)[RoleState.SKILL2], (nil).skill = nil, true
_ENV = nil
;(nil).name = "sw"
;(function()
	return display.newNode()
end)[RoleState.DIE], (nil).loop = nil, false
_ENV = nil
;(nil).name = "xg"
_ENV, _ENV, (function()
	return display.newNode()
end)[RoleState.DIE2], (nil).loop = nil, RoleState.DIE2, nil, false
local function AniType()
	return display.newNode()
end
;(nil).res = "newplayer_walk01"
;(nil).time = 2.4
;(nil).tag = 100
_ENV, RoleState.DIE2.MOVE, (nil).loop = nil, nil, true
;(nil).res = "newplayer_walk02"
;(nil).time = 2.4
;(nil).tag = 101
_ENV, RoleState.DIE2.MOVE2, (nil).loop = nil, nil, true
;(nil).res = "newplayer_fight"
;(nil).time = 10
;(nil).tag = 102
_ENV, RoleState.DIE2.ATTACK, (nil).loop = nil, nil, true
local SoundType = RoleState.DIE2
;(nil).S = "s"
;(nil).N = "n"
;(nil).W = "w"
;(nil).WS = "ws"
local (nil).WN, FaceType = "wn", nil
local arrowSpace = 1
function AniRole:ctor()
	print("AniRole")
	self.tmpPoint = cc.p(0, 0)
	self.rolePisition = cc.p(0, 0)
	self:setNodeEventEnabled(true)
end
function AniRole:onEnter()
	self:scheduleUpdateWithPriorityLua(handler(self, self.updateRole), 0)
end
function AniRole:onExit()
end
function AniRole:initRole(data)
	self.res = data.res
	self.moveToPosList, RoleState, self.actionList, RoleState, self._roleState = RoleState.STAND, RoleState.STAND, RoleState.STAND, RoleState.STAND, RoleState.STAND
	self.nextDelay = 0
	self.nextActionData = nil
	self.paused = false
	self.actionTime = 0
	self.moveLines, RoleState, self.needMoveLine = data.name == "role1", data.name == "role1", data.name == "role1"
	local aniSp = display.newSprite(filename, x, y, params)
	self:setPos(data.pos and data.pos or cc.p(0, 0))
	aniSp:addTo(self, 1)
	aniSp:setPositionY(17)
	self.roleSp = aniSp
	self.faceType, self.isFlipX = self:getFaceType(self:getRolePosition(), data.face)
	data.ani = data.ani or "dj_w"
	local frames = self:newFrames(self.res .. "_" .. data.ani .. "_%02d.png", 1, 8, isReversed)
	self.roleSp:stopAllActions()
	local animation = display.newAnimation(frames, 0.125)
	self.roleSp:playAnimationForever(animation)
end
function AniRole:playAni(roleState, faceType, isFlipX)
	if self.lastRoleState == roleState and self.lastFaceType == faceType and self.lastIsFlipX == isFlipX then
		return
	end
	self.lastRoleState = roleState
	self.lastIsFlipX = isFlipX
	self.lastFaceType = faceType
	local animation = AniType[roleState].name .. "_" .. faceType
	local isloop = AniType[roleState].loop
	local count = AniType[roleState].count or 8
	local soundType = AniType[roleState].sound
	self.roleSp:stopAllActions()
	if isloop then
		local frames = self:newFrames(self.res .. "_" .. animation .. "_%02d.png", 1, count, isReversed)
		local animation = display.newAnimation(frames, 1.0 / count)
		self.roleSp:playAnimationForever(animation)
	else
		local frames = display.newFrames(self.res .. "_" .. animation .. "_%02d.png", 1, count, isReversed)
		local animation = display.newAnimation(frames, 1.0 / count)
		self.roleSp:playAnimationOnce(animation)
	end
	self.roleSp:setScaleX(isFlipX and -1 or 1)
end
function AniRole:playSound(soundType)
	if not soundType then
		if self.soundId then
			AudioEngine.stopEffect(self.soundId)
			self.soundId = nil
		end
		if self.soundTag then
			self.roleSp:stopActionByTag(self.soundTag)
			self.soundTag = nil
		end
		return
	end
	local sound = SoundType[soundType]
	if not sound then
		print("soundType not found", soundType)
		return
	end
	self.soundId = SoraDPlaySound("mainCityGuide", sound.res)
	if sound.loop then
		self.soundTag = sound.tag
		SoundType = "mainCityGuide"
		;("mainCityGuide")[1] = cca.delay(sound.time)
		;("mainCityGuide")[2] = cca.callFunc(function()
			self:playSound(soundType)
		end)
		;("mainCityGuide")[3] = cca.callFunc(function()
			self:playSound(soundType)
		end)
		local action = cca.seq("mainCityGuide")
		action:setTag(self.soundTag)
		self.roleSp:runAction(action)
	end
end
function AniRole:addAction(actionData, icClear)
	if isClear then
		self.actionList, _ENV = isClear, isClear
		self.nextDelay = 0
	end
	table.insert(self.actionList, actionData)
end
function AniRole:setMoveAni(startPos, moveToPos)
	return SoraDGetAngleByPos1(startPos, moveToPos)
end
function AniRole:setSound()
	if self.nextActionData and self.nextActionData.sound then
		self:playSound(self.nextActionData.sound)
	elseif AniType[self._roleState].speed ~= nil and self.needMoveLine then
		self:playSound("MOVE2")
	else
		self:playSound()
	end
end
function AniRole:updateRole(dt)
	if self.paused then
		return
	end
	local tmpNextDelay = self.nextDelay
	self.nextDelay = self.nextDelay - dt
	if self.nextDelay > 0 then
		return
	elseif self.nextDelay ~= 0 then
		self.nextDelay = 0
	end
	if 0 < tmpNextDelay then
	end
	if self.nextState ~= nil then
		self:setState(self.nextState)
		self:setSound()
		self.nextState = nil
	end
	if AniType[self._roleState].speed == nil and not AniType[self._roleState].skill then
		if self.actionTime == nil or 0 >= self.actionTime then
			self.actionTime = 0
			self:notifyActionEnd(self.nextActionData and self.nextActionData.isContinue or false)
			return
		else
			self.actionTime = self.actionTime - dt
		end
		self:_updateAttack(dt)
	elseif AniType[self._roleState].speed then
		self:_updateMove(dt)
	end
end
function AniRole:setState(state)
	self._roleState = state
	if AniType[self._roleState].speed == nil then
		if self.finalFaceType then
			self.faceType = self.finalFaceType
		end
		if self.finalFlipX ~= nil then
			self.isFlipX = self.finalFlipX
		end
	end
	if AniType[self._roleState].skill then
		local skillEffect = cc.criSprite.createCriSprite("ChengQuXF.usm")
		skillEffect:setCompleteCallback(function()
			skillEffect:removeFromParent()
			self:notifyActionEnd(self.nextActionData and self.nextActionData.isContinue or nil)
		end)
		skillEffect:setPositionX(-30)
		skillEffect:addTo(self, 1)
		skillEffect:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	end
	self:playAni(self._roleState, self.faceType, self.isFlipX)
end
function AniRole:_checkAction(dt)
	if #self.actionList == 0 then
		return false
	end
	self.nextActionData = self.actionList[1]
	table.remove(self.actionList, 1)
	self.nextDelay = self.nextActionData.delay ~= nil and self.nextActionData.delay or 0
	self.finalFaceType = self.nextActionData.face
	self.finalFlipX = self.nextActionData.flipX
	self.finalAction = self.nextActionData.finalAction
	if self.nextActionData.face then
		self.faceType = self.finalFaceType
	elseif self.nextActionData.to ~= nil and self.nextActionData.start ~= nil then
		self.faceType, self.isFlipX = self:getFaceType(self.nextActionData.start, self.nextActionData.to)
	end
	if self.finalFlipX ~= nil then
		self.isFlipX = self.finalFlipX
	end
	self.actionTime = self.nextActionData.time
	local nextState = self.nextActionData.action ~= nil and RoleState[self.nextActionData.action] or RoleState.MOVE
	if AniType[nextState].speed ~= nil then
		local nextsState = nextState
		return self:_checkMove(self.nextActionData, nextsState)
	else
		self.nextState = nextState
	end
	return true
end
function AniRole:_checkMove(moveToData, nextState)
	if moveToData.start then
		self:setPos(moveToData.start.x, moveToData.start.y)
	end
	self.rolePisition = self:getRolePosition()
	self.faceType, self.isFlipX = self:getFaceType(self.rolePisition, moveToData.to)
	self._moveNormalize = cc.pNormalize(cc.pSub(moveToData.to, self.rolePisition))
	self.nextDelay = moveToData.delay ~= nil and moveToData.delay or 0
	if self._moveNormalize.x == 0 and self._moveNormalize.y == 0 then
		return false
	end
	self.nextState = nextState and nextState or RoleState.MOVE
	self:_updateMoveLine()
	return true
end
function AniRole:_updateMove(dt)
	local speed = AniType[self._roleState].speed or 100
	self.rolePisition = self:getRolePosition()
	self.tmpPoint.x = self.rolePisition.x + self._moveNormalize.x * dt * speed
	self.tmpPoint.y = self.rolePisition.y + self._moveNormalize.y * dt * speed
	if self._moveNormalize.x > 0 and 0 >= self.nextActionData.to.x - self.tmpPoint.x or self._moveNormalize.x < 0 and 0 <= self.nextActionData.to.x - self.tmpPoint.x or self._moveNormalize.y > 0 and 0 >= self.nextActionData.to.y - self.tmpPoint.y or self._moveNormalize.y < 0 and 0 <= self.nextActionData.to.y - self.tmpPoint.y then
		self:setPos(self.nextActionData.to.x, self.nextActionData.to.y)
		self:notifyActionEnd(self.nextActionData.isContinue)
		return
	else
		self:setPos(self.tmpPoint.x, self.tmpPoint.y)
	end
end
function AniRole:_updateMoveLine()
	self.movingLineSp = nil
	for i, v in ipairs(self.moveLines) do
		v:removeFromParent()
	end
	self.moveLines, _ENV = ipairs(self.moveLines)
	if not self.needMoveLine or self.nextActionData and self.nextActionData.noline then
		return
	end
	AniType = self.nextActionData.noline
	local self.nextActionData.noline[1], moveActions = self.nextActionData, self.nextActionData.noline
	for i, v in ipairs(self.actionList) do
		if v.action == nil or AniType[RoleState[v.action]].speed ~= nil then
			table.insert(moveActions, v)
		end
	end
	local startPosition = cc.p(self:getPosition())
	for i, v in ipairs(moveActions) do
		local preLength = cc.pGetDistance(startPosition, v.to)
		local lineSp = display.newTilesSprite("SinglePicture/mapfoot2.png", cc.rect(0, 0, preLength, 16))
		lineSp:addTo(self:getParent(), -1)
		lineSp:setColor(cc.c3b(1, 255, 1))
		lineSp:setAnchorPoint(cc.p(0, 0.5))
		lineSp:setPosition(v.to)
		lineSp:setRotation(-SoraDGetAngleByPos(startPosition, v.to) - 180)
		table.insert(self.moveLines, lineSp)
		startPosition = v.to
		if i == 1 then
			self.movingLineSp = lineSp
		end
	end
end
function AniRole:_updateAttack(dt)
	if self._roleState == RoleState.ATTACK and self.nextActionData.arrow ~= nil then
		self.arrowTime = self.arrowTime == nil and arrowSpace or self.arrowTime - dt
		if self.arrowTime <= 0 then
			self:playThrowAction("#icon_battle_jian_4.png", 0.5)
		end
	end
end
function AniRole:notifyActionEnd(isContinue)
	if self.nextActionData then
		self.nextActionData = nil
	end
	local checkAction = self:_checkAction()
	if not checkAction and (AniType[self._roleState].autoStand or self.finalAction) then
		if self.finalAction and AniType[RoleState[self.finalAction]].skill then
			self.finalAction = nil
		end
		self.nextState = self.finalAction and RoleState[self.finalAction] or RoleState.STAND
	end
	if isContinue then
		AniType = nil
		;(nil).msg = "MESSAGE_MAINCITYGUIDE_CONTINUE"
		SoraDSendMessage(nil)
	end
end
local rAdd = 30
local rMin = 15
function AniRole:getFaceType(beginPoint, endPoint)
	if endPoint == nil then
		return FaceType.W, false
	end
	local rotation = -SoraDGetAngleByPos(beginPoint, endPoint)
	local moveAngle = 0
	local isFlipX = false
	local faceType = FaceType.W
	if rotation >= 0 - rMin and rotation < 0 + rMin then
		isFlipX = true
		faceType = FaceType.W
	elseif rotation >= 45 - rAdd and rotation < 45 + rAdd then
		isFlipX = true
		faceType = FaceType.WS
	elseif rotation >= 90 - rMin and rotation < 90 + rMin then
		isFlipX = true
		faceType = FaceType.S
	elseif rotation >= 135 - rAdd and rotation < 135 + rAdd then
		isFlipX = false
		faceType = FaceType.WS
	elseif rotation >= 180 - rMin and rotation <= 180 then
		isFlipX = false
		faceType = FaceType.W
	elseif -180 <= rotation and rotation <= -180 + rMin then
		isFlipX = false
		faceType = FaceType.W
	elseif rotation >= -135 - rAdd and rotation <= -135 + rAdd then
		isFlipX = false
		faceType = FaceType.WN
	elseif rotation >= -90 - rMin and rotation <= -90 + rMin then
		isFlipX = true
		faceType = FaceType.N
	elseif rotation >= -45 - rAdd and rotation <= -45 + rAdd then
		isFlipX = true
		faceType = FaceType.WN
	end
	rAdd = nil
	;(nil)[1] = rotation
	;(nil)[2] = faceType
	;(nil)[3] = isFlipX
	;(nil)[4] = self:getName()
	;(nil)[5] = self:getName()
	dump(nil, "getFaceType")
	return faceType, isFlipX, moveAngle
end
function AniRole:playThrowAction(bulletSpriteName, scale, beginPoint, targetPoint)
	local bulletSprite = display.newSprite(bulletSpriteName)
	if not bulletSprite then
		return
	end
	local reference = self:getParent()
	local zOder = reference:getLocalZOrder()
	bulletSprite:setPosition(beginPoint)
	bulletSprite:setScale(scale)
	reference:getParent():addChild(bulletSprite, zOder)
	math.randomseed(tostring(os.time()):reverse():sub(1, 6))
	local radius = 10
	local angle = math.random(-180, 180)
	local radian = math.angle2radian(angle)
	local pointX = targetPoint.x + radius * math.cos(radian)
	local pointY = targetPoint.y + radius * math.sin(radian)
	worldMapFunction.createThrowAction(bulletSprite, beginPoint, cc.p(pointX, pointY))
end
function AniRole:setPos(x, y)
	if y == nil then
		self:setPosition(x)
		self:setLocalZOrder(10000 - x.y)
	else
		self:setPosition(x, y)
		self:setLocalZOrder(10000 - y)
	end
	if self.movingLineSp and self.nextActionData then
		local preLength = cc.pGetDistance(cc.p(self:getPosition()), self.nextActionData.to)
		if preLength == 0 and #self.moveLines == 1 then
			self.movingLineSp:removeFromParent()
			self.moveLines, _ENV, self.movingLineSp = self.movingLineSp.removeFromParent, self.movingLineSp.removeFromParent, nil
			return
		end
		local rect = cc.rect(0, 0, preLength, 16)
		self.movingLineSp:setTextureRect(rect)
	end
end
function AniRole:getRolePosition()
	self.rolePisition.x, self.rolePisition.y = self:getPosition()
	return self.rolePisition
end
function AniRole:newFrames(pattern, begin, length)
	local _ENV, frames
	local step = 1
	local last = begin + length - 1
	local rdIdx = math.random(begin, length)
	for index = begin + rdIdx, last, step do
		local frameName = string.format(pattern, index)
		local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(frameName)
		if not frame then
			return frames
		end
		frames[#frames + 1] = frame
	end
	for index = begin, begin + rdIdx - 1, step do
		local frameName = string.format(pattern, index)
		local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(frameName)
		if not frame then
			return frames
		end
		frames[#frames + 1] = frame
	end
	return frames
end
return AniRole

local worldMapAnimate = include("worldMapAnimate")
local worldMapAnimateLua = class("worldMapAnimateLua", worldMapAnimate)
local GROU_ID = worldMapDefine.GROU_ID
function worldMapAnimateLua:ctor()
	worldMapAnimateLua.super.ctor(self)
end
function worldMapAnimateLua:initData(configData)
	local id = configData.id
	if id then
		if 0 < id and id <= 7 then
			self:addXiyiAnimation(configData)
		elseif 8 <= id and id <= 14 then
			local ret = SoraDIsFileExistByKey("chengwaiying")
			if ret then
				if 10 == id then
					self:addEagleAnimationRound(configData)
				else
					self:addEagleAnimation(configData)
				end
			end
		end
	end
end
function worldMapAnimateLua:addXiyiAnimation(configData)
	_ENV, _ENV = nil, nil
	;(nil).basePos = cc.p(0, 0)
	;(nil).targetPos = cc.p(397, 217)
	;(nil).rotation = 0
	_ENV, (nil)[1], (nil).isFlippedX = nil, nil, false
	;(nil).basePos = cc.p(0, 0)
	;(nil).targetPos = cc.p(-308, 59)
	;(nil).rotation = 0
	_ENV, (nil)[2], (nil).isFlippedX = nil, nil, true
	;(nil).basePos = cc.p(0, 0)
	;(nil).targetPos = cc.p(500, 219)
	;(nil).rotation = 0
	;(nil)[3], (nil).isFlippedX = nil, false
	local xiyiAnimData
	local xiyiSpeed = 50
	local runXiyiAnimation = function(sprite, xiyiData)
		local distance = cc.pGetDistance(xiyiData.basePos, xiyiData.targetPos)
		local dt = distance / xiyiSpeed
		local callFunc1 = cca.callFunc(function()
			local frames = display.newFrames("xiyi_0%d.png", 1, 8)
			local animation = display.newAnimation(frames, 0.05)
			local animate = cc.Animate:create(animation)
			sprite:setFlippedX(xiyiData.isFlippedX)
			local repeatForever = cca.repeatForever(animate)
			repeatForever:setTag(10)
			sprite:runAction(repeatForever)
		end)
		local moveBy1 = cca.moveBy(dt, xiyiData.targetPos.x - xiyiData.basePos.x, xiyiData.targetPos.y - xiyiData.basePos.y)
		local callFunc2 = cca.callFunc(function()
			local fadeTo = cca.fadeTo(0.3, 0)
			sprite:runAction(fadeTo)
		end)
		local callFuncReset = cca.callFunc(function()
			sprite:setPosition(xiyiData.basePos)
			sprite:setOpacity(255)
			sprite:setVisible(true)
			sprite:stopActionByTag(10)
		end)
		local delay = cca.delay(math.random(3, 5))
		_UPVALUE5_ = math.random(3, 5)
		math.random(3, 5)[1] = callFunc1
		math.random(3, 5)[2] = moveBy1
		math.random(3, 5)[3] = callFunc2
		math.random(3, 5)[4] = delay
		math.random(3, 5)[5] = callFuncReset
		sprite:runAction(cca.repeatForever(cca.seq(math.random(3, 5))))
	end
	local id = configData.id
	if id and xiyiAnimData[id] then
		local sprite = display.newSprite("#" .. "xiyi_01.png")
		self:addChild(sprite)
		sprite:setLocalZOrder(id)
		sprite:setPosition(xiyiAnimData[id].basePos)
		runXiyiAnimation(sprite, xiyiAnimData[id])
		self:setNodeGroupID(sprite, configData)
	end
end
function worldMapAnimateLua:addEagleAnimation(configData)
	_ENV, _ENV = nil, nil
	;(nil).img = "chengwaiying_ws_"
	;(nil).targetPos = cc.p(-10, -10)
	;(nil).time = 2.0
	;(nil).basePos = cc.p(397, 217)
	;(nil).rotation = 0
	_ENV, (nil)[8], (nil).isFlippedX = nil, nil, false
	;(nil).img = "chengwaiying_wn_"
	;(nil).targetPos = cc.p(-10, -10)
	;(nil).time = 1.5
	;(nil).basePos = cc.p(500, -219)
	;(nil).rotation = 0
	;(nil)[9], (nil).isFlippedX = nil, false
	local eagleAnimData
	local eagleSpeed = 50
	local runeagleAnimation = function(sprite, eagleData)
		local distance = cc.pGetDistance(eagleData.basePos, eagleData.targetPos)
		local dt = distance / eagleSpeed
		local callFunc1 = cca.callFunc(function()
			local frames = display.newFrames(eagleData.img .. "0%d.png", 1, 8)
			local animation = display.newAnimation(frames, 0.125)
			local animate = cc.Animate:create(animation)
			sprite:setFlippedX(eagleData.isFlippedX)
			local repeatForever = cca.repeatForever(animate)
			repeatForever:setTag(10)
			sprite:runAction(repeatForever)
		end)
		local moveBy = cca.moveBy(dt, eagleData.targetPos.x - eagleData.basePos.x, eagleData.targetPos.y - eagleData.basePos.y)
		eagleSpeed = eagleData.targetPos.x - eagleData.basePos.x
		;(eagleData.targetPos.x - eagleData.basePos.x)[1] = cca.delay(dt - eagleData.time)
		;(eagleData.targetPos.x - eagleData.basePos.x)[2] = cca.callFunc(function()
			sprite:setGroupID(GROU_ID.group_animate_tmx_bg)
		end)
		;(eagleData.targetPos.x - eagleData.basePos.x)[3] = cca.callFunc(function()
			sprite:setGroupID(GROU_ID.group_animate_tmx_bg)
		end)
		;(eagleData.targetPos.x - eagleData.basePos.x)[4] = cca.callFunc(function()
			sprite:setGroupID(GROU_ID.group_animate_tmx_bg)
		end)
		;(eagleData.targetPos.x - eagleData.basePos.x)[5] = cca.callFunc(function()
			sprite:setGroupID(GROU_ID.group_animate_tmx_bg)
		end)
		;(eagleData.targetPos.x - eagleData.basePos.x)[6] = cca.callFunc(function()
			sprite:setGroupID(GROU_ID.group_animate_tmx_bg)
		end)
		;(eagleData.targetPos.x - eagleData.basePos.x)[7] = cca.callFunc(function()
			sprite:setGroupID(GROU_ID.group_animate_tmx_bg)
		end)
		;(eagleData.targetPos.x - eagleData.basePos.x)[8] = cca.callFunc(function()
			sprite:setGroupID(GROU_ID.group_animate_tmx_bg)
		end)
		;(eagleData.targetPos.x - eagleData.basePos.x)[9] = cca.callFunc(function()
			sprite:setGroupID(GROU_ID.group_animate_tmx_bg)
		end)
		;(eagleData.targetPos.x - eagleData.basePos.x)[10] = cca.callFunc(function()
			sprite:setGroupID(GROU_ID.group_animate_tmx_bg)
		end)
		;(eagleData.targetPos.x - eagleData.basePos.x)[11] = cca.callFunc(function()
			sprite:setGroupID(GROU_ID.group_animate_tmx_bg)
		end)
		;(eagleData.targetPos.x - eagleData.basePos.x)[12] = cca.callFunc(function()
			sprite:setGroupID(GROU_ID.group_animate_tmx_bg)
		end)
		;(eagleData.targetPos.x - eagleData.basePos.x)[13] = cca.callFunc(function()
			sprite:setGroupID(GROU_ID.group_animate_tmx_bg)
		end)
		local seqGroupID = cca.seq(eagleData.targetPos.x - eagleData.basePos.x)
		GROU_ID = cca.delay(dt - eagleData.time)
		cca.delay(dt - eagleData.time)[1] = moveBy
		cca.delay(dt - eagleData.time)[2] = seqGroupID
		local moveBy1 = cca.spawn((cca.delay(dt - eagleData.time)))
		local callFunc2 = cca.callFunc(function()
			local fadeTo = cca.fadeTo(0.3, 0)
			sprite:runAction(fadeTo)
		end)
		local callFuncReset = cca.callFunc(function()
			sprite:setPosition(eagleData.basePos)
			sprite:setOpacity(255)
			sprite:setVisible(true)
			sprite:stopActionByTag(10)
			sprite:setGroupID(GROU_ID.group_animate_object_top)
		end)
		local delay = cca.delay(math.random(3, 5))
		_UPVALUE5_ = math.random(3, 5)
		math.random(3, 5)[1] = callFunc1
		math.random(3, 5)[2] = moveBy1
		math.random(3, 5)[3] = callFunc2
		math.random(3, 5)[4] = delay
		math.random(3, 5)[5] = callFuncReset
		sprite:runAction(cca.repeatForever(cca.seq(math.random(3, 5))))
	end
	local id = configData.id
	if id and eagleAnimData[id] then
		local sprite = display.newSprite("#" .. eagleAnimData[id].img .. "01.png")
		self:addChild(sprite)
		sprite:setLocalZOrder(id)
		sprite:setPosition(eagleAnimData[id].basePos)
		runeagleAnimation(sprite, eagleAnimData[id])
		self:setNodeGroupID(sprite, configData)
	end
end
function worldMapAnimateLua:addEagleAnimationRound(configData)
	local testPosX = 450
	local testPosX2 = testPosX * 0.72
	local testPosX3 = testPosX * 0.36
	local testPosY = 250
	local testPosY2 = testPosY * 0.72
	local testPosY3 = testPosY * 0.36
	_ENV, _ENV = nil, nil
	;(nil).img = "cwying_"
	;(nil).speed = 10
	;(nil).repeatnum = 3
	_ENV, _UPVALUE14_, (nil).basePos = testPosX, cc.p(testPosX, 0), cc.p(testPosX, 0)
	_ENV, testPosX.basePos = cc.p(testPosX, 0), cc.p(testPosX, 0)
	_ENV, cc.p(testPosX, 0).basePos = cc.p(testPosX, testPosY3), cc.p(testPosX, testPosY3)
	_ENV, cc.p(testPosX, testPosY3).basePos = cc.p(testPosX2, testPosY2), cc.p(testPosX2, testPosY2)
	_ENV, cc.p(testPosX2, testPosY2).basePos = cc.p(testPosX3, testPosY), cc.p(testPosX3, testPosY)
	_ENV, cc.p(testPosX3, testPosY).basePos = cc.p(-testPosX3, testPosY), cc.p(-testPosX3, testPosY)
	_ENV, cc.p(-testPosX3, testPosY).basePos = cc.p(-testPosX2, testPosY2), cc.p(-testPosX2, testPosY2)
	_ENV, cc.p(-testPosX2, testPosY2).basePos = cc.p(-testPosX, testPosY3), cc.p(-testPosX, testPosY3)
	_ENV, cc.p(-testPosX, testPosY3).basePos = cc.p(-testPosX, -testPosY3), cc.p(-testPosX, -testPosY3)
	_ENV, cc.p(-testPosX, -testPosY3).basePos = cc.p(-testPosX2, -testPosY2), cc.p(-testPosX2, -testPosY2)
	_ENV, cc.p(-testPosX2, -testPosY2).basePos = cc.p(-testPosX3, -testPosY), cc.p(-testPosX3, -testPosY)
	_ENV, cc.p(-testPosX3, -testPosY).basePos = cc.p(testPosX3, -testPosY), cc.p(testPosX3, -testPosY)
	_ENV, cc.p(testPosX3, -testPosY).basePos = cc.p(testPosX2, -testPosY2), cc.p(testPosX2, -testPosY2)
	_ENV, cc.p(testPosX2, -testPosY2).basePos = cc.p(testPosX, -testPosY3), cc.p(testPosX, -testPosY3)
	cc.p(testPosX, -testPosY3).basePos = cc.p(testPosX, 0)
	;(nil)[10], (nil).pos, cc.p(testPosX, 0)[1] = nil, cc.p(testPosX, 0), testPosX
	;(nil)[10], (nil).pos, cc.p(testPosX, 0)[2] = nil, cc.p(testPosX, 0), cc.p(testPosX, 0)
	;(nil)[10], (nil).pos, cc.p(testPosX, 0)[3] = nil, cc.p(testPosX, 0), cc.p(testPosX, testPosY3)
	;(nil)[10], (nil).pos, cc.p(testPosX, 0)[4] = nil, cc.p(testPosX, 0), cc.p(testPosX2, testPosY2)
	;(nil)[10], (nil).pos, cc.p(testPosX, 0)[5] = nil, cc.p(testPosX, 0), cc.p(testPosX3, testPosY)
	;(nil)[10], (nil).pos, cc.p(testPosX, 0)[6] = nil, cc.p(testPosX, 0), cc.p(-testPosX3, testPosY)
	;(nil)[10], (nil).pos, cc.p(testPosX, 0)[7] = nil, cc.p(testPosX, 0), cc.p(-testPosX2, testPosY2)
	;(nil)[10], (nil).pos, cc.p(testPosX, 0)[8] = nil, cc.p(testPosX, 0), cc.p(-testPosX, testPosY3)
	;(nil)[10], (nil).pos, cc.p(testPosX, 0)[9] = nil, cc.p(testPosX, 0), cc.p(-testPosX, -testPosY3)
	;(nil)[10], (nil).pos, cc.p(testPosX, 0)[10] = nil, cc.p(testPosX, 0), cc.p(-testPosX2, -testPosY2)
	;(nil)[10], (nil).pos, cc.p(testPosX, 0)[11] = nil, cc.p(testPosX, 0), cc.p(-testPosX3, -testPosY)
	;(nil)[10], (nil).pos, cc.p(testPosX, 0)[12] = nil, cc.p(testPosX, 0), cc.p(testPosX3, -testPosY)
	;(nil)[10], (nil).pos, cc.p(testPosX, 0)[13] = nil, cc.p(testPosX, 0), cc.p(testPosX2, -testPosY2)
	;(nil)[10], (nil).pos, cc.p(testPosX, 0)[14] = nil, cc.p(testPosX, 0), cc.p(testPosX, -testPosY3)
	local eagleAnimData
	local eagleSpeed = 50
	local runeagleAnimationAction = function(node, sprite, img, info)
		local basePos = info.basePos
		local targetPos = info.targetPos
		local callFunc1 = cca.callFunc(function()
			sprite:stopActionByTag(10)
			local frames = display.newFrames(img .. info.imgNameAngle .. "_0%d.png", 1, 8, info.reverse)
			local animation = display.newAnimation(frames, 0.125)
			local animate = cc.Animate:create(animation)
			sprite:setFlippedX(info.isFlipX)
			node:setRotation(info.rotation)
			sprite:setRotation(-info.moveAngle)
			local repeatForever = cca.repeatForever(animate)
			repeatForever:setTag(10)
			sprite:runAction(repeatForever)
		end)
		local moveBy = cca.moveBy(info.dt, targetPos.x - basePos.x, targetPos.y - basePos.y)
		_UPVALUE2_ = targetPos.x - basePos.x
		;(targetPos.x - basePos.x)[1] = callFunc1
		;(targetPos.x - basePos.x)[2] = moveBy
		return cca.seq(targetPos.x - basePos.x)
	end
	local getPointInPrecent = function(beginPoint, endPoint, percent)
		local distanceX = endPoint.x - beginPoint.x
		local distanceY = endPoint.y - beginPoint.y
		local currentPointX = beginPoint.x + distanceX * percent
		local currentPointY = beginPoint.y + distanceY * percent
		local currentPoint = cc.p(currentPointX, currentPointY)
		return currentPoint
	end
	local getPointFixTime = function(beginPoint, endPoint, isTrans)
		local distance = cc.pGetDistance(beginPoint, endPoint)
		local dt = distance / eagleSpeed
		local dtFix = math.floor(dt)
		local percent = dtFix / dt
		local pos = getPointInPrecent(beginPoint, endPoint, percent)
		return pos
	end
	local processPosFixTime = function(posArray)
		for i = 2, #posArray - 1 do
			local firstPos = posArray[i - 1].basePos
			local secondPos = posArray[i].basePos
			local fixPos = getPointFixTime(firstPos, secondPos, posArray[i].isTrans)
			posArray[i].basePos = fixPos
		end
	end
	local transLength = 30
	local beginPercent = 0.9
	local endPercent = 1 - beginPercent
	local processPosAddTrans = function(posArray)
		local _ENV, tableInfo
		tableInfo[#tableInfo + 1] = posArray[1]
		for i = 2, #posArray - 1 do
			local firstPos = posArray[i - 1].basePos
			local secondPos = posArray[i].basePos
			local threadPos = posArray[i + 1].basePos
			local distance1 = cc.pGetDistance(firstPos, secondPos)
			local distance2 = cc.pGetDistance(secondPos, threadPos)
			if distance1 > transLength and distance2 > transLength then
				local basePos = getPointInPrecent(firstPos, secondPos, beginPercent)
				local targetPos = getPointInPrecent(secondPos, threadPos, endPercent)
				_ENV = threadPos
				threadPos.basePos = basePos
				tableInfo[#tableInfo + 1], threadPos.isTrans = threadPos, true
				_ENV = threadPos
				tableInfo[#tableInfo + 1], threadPos.basePos = threadPos, targetPos
			else
				tableInfo[#tableInfo + 1] = posArray[i]
			end
		end
		tableInfo[#tableInfo + 1] = posArray[#posArray]
		return tableInfo
	end
	local getPointInfoTrans = function(basePos, targetPos, info)
		_ENV, _ENV = nil, nil
		;(nil).imgNameAngle = "stows"
		_ENV, (nil).s, (nil).isFlipX = nil, nil, true
		;(nil).imgNameAngle = "wstow"
		_ENV, (nil).ws, (nil).isFlipX = nil, nil, true
		;(nil).imgNameAngle = "wtown"
		_ENV, (nil).w, (nil).isFlipX = nil, nil, true
		;(nil).imgNameAngle = "wnton"
		_ENV, (nil).wn, (nil).isFlipX = nil, nil, true
		;(nil).imgNameAngle = "wnton"
		_ENV, (nil).n, (nil).reverse = nil, nil, true
		;(nil).imgNameAngle = "wtown"
		_ENV, (nil).fwn, (nil).reverse = nil, nil, true
		;(nil).imgNameAngle = "wstow"
		_ENV, (nil).fw, (nil).reverse = nil, nil, true
		;(nil).imgNameAngle = "stows"
		;(nil).fws, (nil).reverse = nil, true
		local tableTrans
		local imgKey = info.imgNameAngle
		if not info.isFlipX then
			imgKey = "f" .. imgKey
		end
		local infoTrans = tableTrans[imgKey]
		local imgNameAngle = infoTrans.imgNameAngle
		local isFlipX = infoTrans.isFlipX or false
		local rotation = info.rotation
		local moveAngle = info.moveAngle
		local distance = cc.pGetDistance(basePos, targetPos)
		local dt = distance / eagleSpeed
		_ENV = targetPos
		targetPos.rotation = rotation
		targetPos.imgNameAngle = imgNameAngle
		targetPos.isFlipX = isFlipX
		targetPos.moveAngle = moveAngle
		targetPos.basePos = basePos
		targetPos.targetPos = targetPos
		targetPos.distance = distance
		local targetPos.dt, tablePos = dt, targetPos
		return tablePos
	end
	local getPointInfo = function(basePos, targetPos)
		local rotation, imgNameAngle, isFlipX, moveAngle = worldMapFunction.getSoliderImgAngel(basePos, targetPos)
		local distance = cc.pGetDistance(basePos, targetPos)
		local dt = distance / eagleSpeed
		_ENV = targetPos
		targetPos.rotation = rotation
		targetPos.imgNameAngle = imgNameAngle
		targetPos.isFlipX = isFlipX
		targetPos.moveAngle = moveAngle
		targetPos.basePos = basePos
		targetPos.targetPos = targetPos
		targetPos.distance = distance
		local targetPos.dt, tablePos = dt, targetPos
		return tablePos
	end
	local processPosAddInfo = function(posArray)
		local getPointInfoTrans, tableInfo
		for i = 1, #posArray do
			if i >= #posArray then
				tableInfo[i] = tableInfo[1]
			else
				local basePos = posArray[i].basePos
				local targetPos = posArray[i + 1].basePos
				local tablePos
				if posArray[i].isTrans then
					tablePos = getPointInfoTrans(basePos, targetPos, tableInfo[i - 1])
				else
					tablePos = getPointInfo(basePos, targetPos)
				end
				tableInfo[i] = tablePos
			end
		end
		return tableInfo
	end
	local runeagleAnimation = function(node, sprite, eagleData)
		local processPosAddTrans, actionsArrayMove
		local posArray = eagleData.pos
		posArray = processPosAddTrans(posArray)
		processPosFixTime(posArray)
		posArray = processPosAddInfo(posArray)
		for i = 1, #posArray - 1 do
			local action = runeagleAnimationAction(node, sprite, eagleData.img, posArray[i])
			actionsArrayMove[#actionsArrayMove + 1] = action
		end
		local processPosAddTrans, actionsArray = (for index), 1
		local repeatRound = cca.rep(cca.seq(actionsArrayMove), eagleData.repeatnum)
		actionsArray[#actionsArray + 1] = repeatRound
		local callFunc2 = cca.callFunc(function()
			local fadeTo = cca.fadeTo(0.3, 0)
			sprite:runAction(fadeTo)
		end)
		actionsArray[#actionsArray + 1] = callFunc2
		local delay = cca.delay(math.random(3, 5))
		actionsArray[#actionsArray + 1] = delay
		local callFuncReset = cca.callFunc(function()
			node:setPosition(eagleData.basePos)
			sprite:setOpacity(255)
			sprite:setVisible(true)
			node:setRotation(0)
			sprite:setRotation(0)
		end)
		actionsArray[#actionsArray + 1] = callFuncReset
		node:runAction(cca.repeatForever(cca.seq(actionsArray)))
	end
	local id = configData.id
	if id and eagleAnimData[id] then
		local node = display.newNode()
		local sprite = display.newSprite("#" .. eagleAnimData[id].img .. "ws_01.png")
		node:addChild(sprite)
		self:addChild(node)
		node:setLocalZOrder(id)
		node:setPosition(eagleAnimData[id].basePos)
		runeagleAnimation(node, sprite, eagleAnimData[id])
		self:setNodeGroupID(node, configData, true)
	end
end
function worldMapAnimateLua:debugLine(posArray, color)
	_ENV = nil
	;(nil).fillColor = cc.c4f(0, 1, 0, 0)
	;(nil).borderColor = color
	local (nil).borderWidth, eagleParams = 0, nil
	local _ENV, eaglePoints = cc.c4f(0, 1, 0, 0), cc.c4f(0, 1, 0, 0)
	for i = 1, #posArray do
		_UPVALUE2_ = nil
		;(nil)[1] = posArray[i].basePos.x
		local (nil)[2], pos = posArray[i].basePos.y, nil
		eaglePoints[#eaglePoints + 1] = pos
	end
	local eagleShapNode = display.newPolygon(eaglePoints, eagleParams)
	self:addChild(eagleShapNode, -2)
end
return worldMapAnimateLua

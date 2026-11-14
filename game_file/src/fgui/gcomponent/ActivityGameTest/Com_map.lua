local baseComponent = require("fgui.base.baseComponent")
local Com_map = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ActivityGameTest/Com_map", Com_map)
function Com_map:onInit()
	self.isMoving = false
	self.colorMap, _ENV, self.changeModel = nil, nil, false
	self:addEventListener(fgui.UIEventType.TouchBegin, handler(self, self.onEventTouchBegin))
	self:addEventListener(fgui.UIEventType.TouchMove, handler(self, self.onEventTouchMove))
	self:addEventListener(fgui.UIEventType.TouchEnd, handler(self, self.onEventTouchEnd))
	local drawNode = cc.DrawNode:create()
	drawNode:addTo(self)
	self.drawNode = drawNode
	self.myBubble = self.fields.Com_bubble
	_ENV, self.objSize = self.myBubble:getContentSize(), self.myBubble:getContentSize()
	self.myBubble:getContentSize().x = self.objSize.width
	self.posStep, self.myBubble:getContentSize().y = self.myBubble:getContentSize(), math.ceil(self.objSize.height * 0.866)
	local basePos = self.myBubble:getPosition()
	self.curPos = cc.p(basePos.x + self.objSize.width / 2, basePos.y + self.objSize.height / 2)
end
function Com_map:onShow()
	self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp), true)
end
function Com_map:initMapData(mapData)
	self.bubbleMap, _UPVALUE0_, self.mapData = nil, nil, mapData
	for y = 1, 8 do
		for x = 1, 8 do
			self:initBubbleSingle(x, y)
		end
	end
end
function Com_map:initBubbleSingle(x, y)
	local value = self.mapData[y] and self.mapData[y][x] or 0
	if value == 0 then
		return
	end
	local obj = fgui.UIPackage:createObject("ActivityGameTest", "Com_bubble")
	obj:addTo(self)
	local mapPos = self:tilePos2mapPos(cc.p(x, y))
	obj:setPosition(mapPos)
	local colorType = self.colorMap[y] and self.colorMap[y][x] or math.random(0, 2)
	_ENV = cc.p(x, y)
	cc.p(x, y).x = x
	cc.p(x, y).y = y
	cc.p(x, y).colorType = colorType
	obj:initData(cc.p(x, y))
	if not self.bubbleMap[y] then
		_ENV = self.bubbleMap[y]
	end
	self.bubbleMap[y] = self.bubbleMap[y]
	self.bubbleMap[y][x] = obj
	if not self.colorMap[y] then
		_ENV = self.colorMap[y]
	end
	self.colorMap[y] = self.colorMap[y]
	self.colorMap[y][x] = colorType
end
function Com_map:onEventTouchBegin(context)
	if self.changeModel then
		return
	end
	context:captureTouch()
	self:resetMyBubble()
	local _toPos = context:getInput():getPosition()
	local toPos = self:globalToLocal(_toPos)
	self:drawLine(self.curPos, toPos)
	self.touchBegin = true
end
function Com_map:onEventTouchMove(context)
	if self.changeModel then
		return
	end
	if not self.touchBegin then
		return
	end
	local _toPos = context:getInput():getPosition()
	local toPos = self:globalToLocal(_toPos)
	self:drawLine(self.curPos, toPos)
end
function Com_map:onEventTouchEnd(context)
	if self.changeModel then
		local _toPos = context:getInput():getPosition()
		local toPos = self:globalToLocal(_toPos)
		local tilePos = self:mapPos2tilePos(toPos)
		local obj = self.bubbleMap[tilePos.y] and self.bubbleMap[tilePos.y][tilePos.x]
		if obj then
			local color = (obj:getColorType() + 1) % 3
			obj:setColorType(color)
			self.colorMap[tilePos.y][tilePos.x] = color
		end
		return
	end
	if not self.touchBegin then
		return
	end
	self.touchBegin = false
	self.isMoving = true
	local _toPos = context:getInput():getPosition()
	local toPos = self:globalToLocal(_toPos)
	local dir = cc.pNormalize(cc.pSub(toPos, self.curPos))
	self.myBubble:setDir(dir)
	self.drawNode:clear()
end
function Com_map:drawLine(beginPos, endPos)
	self.drawNode:clear()
	self.posList, _ENV = self.drawNode.clear, self.drawNode.clear
	local mapH = self:getHeight()
	local beginPos_cocos = cc.p(beginPos.x, mapH - beginPos.y)
	local endPos_cocos = cc.p(endPos.x, mapH - endPos.y)
	table.insert(self.posList, beginPos_cocos)
	self:rayCastBack(beginPos_cocos, endPos_cocos)
	for i = 2, #self.posList do
		self.drawNode:drawLine(self.posList[i - 1], self.posList[i], cc.c4b(0, 0, 0, 1))
	end
end
function Com_map:rayCastBack(beginPos, endPos)
	local nextEndPos = self:getNextEndPos(beginPos, endPos)
	table.insert(self.posList, nextEndPos)
	local mapH = self:getHeight()
	if mapH > nextEndPos.y and #self.posList < 10 then
		self:rayCastBack(nextEndPos, cc.p(beginPos.x, nextEndPos.y * 2 - beginPos.y))
	end
end
function Com_map:getNextEndPos(beginPos, endPos)
	local mapH = self:getHeight()
	local mapW = self:getWidth() - self.objSize.width / 2
	local sub = cc.pSub(endPos, beginPos)
	if sub.x == 0 then
		if 0 <= sub.y then
			return cc.p(beginPos.x, mapH)
		else
			return cc.p(beginPos.x, 0)
		end
	end
	local posx = sub.x > 0 and mapW or self.objSize.width / 2
	local posy = (posx - beginPos.x) / sub.x * sub.y + beginPos.y
	if mapH < posy then
		posy = mapH
		posx = (posy - beginPos.y) * sub.x / sub.y + beginPos.x
	end
	return cc.p(posx, posy)
end
function Com_map:openTimeUp(dt)
	if not self.isMoving then
		return
	end
	local pos = self.myBubble:getPosition()
	local dir = self.myBubble:getDir()
	local speed = self.myBubble:getSpeed()
	local newPos = cc.p(pos.x + speed * dt * dir.x, pos.y + speed * dt * dir.y)
	if newPos.x < 0 then
		newPos.x = 0
		dir.x = -dir.x
	elseif newPos.x > self:getWidth() - self.posStep.x then
		newPos.x = self:getWidth() - self.posStep.x
		dir.x = -dir.x
	end
	if newPos.y < 0 then
		newPos.y = 0
		self.isMoving = false
		self:resetMyBubble()
		return
	end
	self.myBubble:setDir(dir)
	self.myBubble:setPosition(newPos)
	local centerPos = cc.p(newPos.x + self.objSize.width / 2, newPos.y + self.objSize.height / 2)
	local tilePos = self:mapPos2tilePos(centerPos)
	local config = self:getBubbleAroundPos(tilePos)
	local min_distance, min_obj
	for __, diff in ipairs(config) do
		local nextPos = cc.pAdd(tilePos, diff)
		local obj = self.bubbleMap[nextPos.y] and self.bubbleMap[nextPos.y][nextPos.x]
		if obj then
			local distance = cc.pDistanceSQ(centerPos, self:tilePos2centerMapPos(nextPos))
			if distance <= self.objSize.width * self.objSize.width and (not min_distance or min_distance > distance) then
				min_distance = distance
				min_obj = obj
			end
		end
	end
	if min_obj then
		self.isMoving = false
		self:resetMyBubble()
		if min_obj:checkSameColor(self.myBubble:getColorType()) then
			min_obj:setIsSelect(true)
			self.curSelectObj = min_obj
			self:checkBubble()
		end
	end
end
function Com_map:mapPos2tilePos(mapPos)
	local mapPos2tilePos = function(mapPos)
		local tileY = math.ceil(mapPos.y / self.posStep.y)
		local tileX = 0
		if tileY % 2 == 0 then
			tileX = math.ceil(mapPos.x / self.posStep.x - 0.5)
		else
			tileX = math.ceil(mapPos.x / self.posStep.x)
		end
		return cc.p(tileX, tileY)
	end
	local tilePos1 = mapPos2tilePos(mapPos)
	local distance1 = cc.pDistanceSQ(mapPos, self:tilePos2centerMapPos(tilePos1))
	local tilePos2 = mapPos2tilePos(cc.p(mapPos.x, mapPos.y - self.objSize.height / 2))
	local distance2 = cc.pDistanceSQ(mapPos, self:tilePos2centerMapPos(tilePos2))
	if distance1 < distance2 then
		return tilePos1
	else
		return tilePos2
	end
end
function Com_map:tilePos2mapPos(tilePos)
	local mapx = self.posStep.x * (tilePos.x - 1) + 0.5 * self.posStep.x * ((tilePos.y - 1) % 2)
	local mapy = self.posStep.y * (tilePos.y - 1)
	return cc.p(mapx, mapy)
end
function Com_map:tilePos2centerMapPos(tilePos)
	local mapPos = self:tilePos2mapPos(tilePos)
	return cc.p(mapPos.x + self.objSize.width / 2, mapPos.y + self.objSize.height / 2)
end
function Com_map:reverseChangeModel()
	self.changeModel = not self.changeModel
end
function Com_map:getIsChangeModel(...)
	return self.changeModel
end
function Com_map:resetMyBubble(...)
	self.isMoving = false
	self.myBubble:setPosition(cc.p(self.curPos.x - self.objSize.width / 2, self.curPos.y - self.objSize.height / 2))
end
function Com_map:exhcangeMyBubble(...)
	local color = (self.myBubble:getColorType() + 1) % 3
	self.myBubble:setColorType(color)
end
function Com_map:walk(func)
	for __, v in pairs(self.bubbleMap) do
		for __, obj in pairs(v) do
			func(obj)
		end
	end
end
function Com_map:resetBubbleSelect(...)
	self:walk(function(obj)
		obj:reset()
	end)
end
function Com_map:resetBubbleColor(...)
	self:walk(function(obj)
		local color = math.random(0, 2)
		obj:setColorType(color)
	end)
end
function Com_map:recoverMap(...)
	self:walk(function(obj)
		obj:removeFromParent()
	end)
	self:initMapData(self.mapData)
end
function Com_map:getBubbleAroundPos(tilePos)
	_UPVALUE5_ = nil
	_UPVALUE5_, (nil)[1] = cc.p(1, 0), cc.p(1, 0)
	_UPVALUE5_, (nil)[2] = cc.p(1, 0), cc.p(0, 1)
	_UPVALUE5_, (nil)[3] = cc.p(1, 0), cc.p(-1, 1)
	_UPVALUE5_, (nil)[4] = cc.p(1, 0), cc.p(-1, 0)
	_UPVALUE5_, (nil)[5] = cc.p(1, 0), cc.p(-1, -1)
	_UPVALUE5_, (nil)[6] = cc.p(1, 0), cc.p(0, -1)
	_UPVALUE5_, (nil)[7] = cc.p(1, 0), cc.p(0, -1)
	_UPVALUE5_, (nil)[8] = cc.p(1, 0), cc.p(0, -1)
	local _UPVALUE5_, (nil)[9], config1 = cc.p(1, 0), cc.p(0, -1)
	cc.p(1, 0)[1] = cc.p(1, 0)
	cc.p(1, 0)[2] = cc.p(1, 1)
	cc.p(1, 0)[3] = cc.p(0, 1)
	cc.p(1, 0)[4] = cc.p(-1, 0)
	cc.p(1, 0)[5] = cc.p(0, -1)
	cc.p(1, 0)[6] = cc.p(1, -1)
	cc.p(1, 0)[7] = cc.p(1, -1)
	local cc.p(1, 0)[8], config2 = cc.p(1, -1)
	if tilePos.y % 2 == 0 then
		return config2
	else
		return config1
	end
end
function Com_map:checkBubble(...)
	self:walk(function(obj)
		obj:setIsConnect(false)
	end)
	self:checkSameColorBubble()
	self:checkDropBubble()
	self:clearDieBubble()
end
function Com_map:checkSameColorBubble(...)
	_UPVALUE1_ = nil
	local (nil)[1], checkList = self.curSelectObj, nil
	local checkMap = clone(self.bubbleMap)
	local function checkSingleObj(checkObj)
		local tilePos = checkObj:getTilePos()
		local config = self:getBubbleAroundPos(tilePos)
		for __, diff in ipairs(config) do
			local nextPos = cc.pAdd(tilePos, diff)
			local obj = checkMap[nextPos.y] and checkMap[nextPos.y][nextPos.x]
			if obj and obj:checkSameColor(self.curSelectObj:getColorType()) then
				obj:setIsSelect(true)
				table.insert(checkList, obj)
				checkMap[nextPos.y][nextPos.x] = nil
			end
		end
		local nextObj = table.remove(checkList, 1)
		if nextObj then
			checkSingleObj(nextObj)
		end
	end
	local checkObj = table.remove(checkList, 1)
	checkSingleObj(checkObj)
end
function Com_map:checkDropBubble(...)
	local _ENV, checkList
	local checkMap = clone(self.bubbleMap)
	local function checkSingleObj(checkObj)
		local tilePos = checkObj:getTilePos()
		local config = self:getBubbleAroundPos(tilePos)
		for __, diff in ipairs(config) do
			local nextPos = cc.pAdd(tilePos, diff)
			local obj = checkMap[nextPos.y] and checkMap[nextPos.y][nextPos.x]
			if obj and not obj:getIsSelect() then
				obj:setIsConnect(true)
				table.insert(checkList, obj)
				checkMap[nextPos.y][nextPos.x] = nil
			end
		end
		local nextObj = table.remove(checkList, 1)
		if nextObj then
			checkSingleObj(nextObj)
		end
	end
	if not self.bubbleMap[1] then
		_ENV = self.bubbleMap[1]
	end
	for __, obj in pairs(self.bubbleMap[1]) do
		if not obj:getIsSelect() then
			obj:setIsConnect(true)
			table.insert(checkList, obj)
		end
	end
	local checkObj = table.remove(checkList, 1)
	if checkObj then
		checkSingleObj(checkObj)
	end
end
function Com_map:clearDieBubble(...)
	self:walk(function(obj)
		if obj:getIsSelect() or not obj:getIsConnect() then
			local tilePos = obj:getTilePos()
			self.bubbleMap[tilePos.y][tilePos.x] = nil
			obj:removeFromParent()
		end
	end)
end
return Com_map

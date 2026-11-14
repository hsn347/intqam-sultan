local ActionLayer = class("ActionLayer", function(target)
	return target
end)
local _ENV, ActionStyle = "ActionLayer", "ActionLayer"
function ActionLayer:ctor()
	self.cellThrehold = 0
	self.cellBounceRatio = 0
end
function ActionLayer:init(styleType, showNum, dataNum, createCell, updateCell)
	if not (type(createCell) == "function" and type(updateCell) == "function" and not (showNum <= 0) and ActionStyle[styleType]) or dataNum <= 0 then
		print("ActionLayer:init param error!")
		return
	end
	local actionsList = ActionStyle[styleType](self, showNum)
	self.createCell = createCell
	self.updateCell = updateCell
	self.actionsList = actionsList
	self.showNum = #self.actionsList
	self.cellList, _ENV, self.dataNum = #self.actionsList, #self.actionsList, dataNum
	self.isDataRound = false
	self.moveDirection = 1
	self.showStart = 1
	for i = 1, self.showNum do
		self.cellList[i] = self.createCell()
		self.cellList[i].showIdx = i
		self:addChild(self.cellList[i])
		if i > self.dataNum then
			self.cellList[i]:setVisible(false)
		end
	end
	self:updateNode(0)
	self.distance = self:getContentSize().width * 2
	self:setTouchEnabled(true)
	self:addTouchEventListener(handler(self, self.onTouch))
	function self.addTouchEventListener(target, cb)
		self.touchCb = cb
	end
	self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.update))
	self:scheduleUpdate()
end
function ActionLayer:update(dt)
	if self.updateAction and not self.updateAction:isFinish() then
		self.updateAction:updateByTime(dt)
	end
end
function ActionLayer:isActionFinish()
	if self.updateAction then
		return self.updateAction:isFinish()
	else
		return true
	end
end
function ActionLayer:bindDataToShow(showStart)
	if showStart < 1 or showStart > self.showNum then
		return
	end
	self.showStart = showStart
end
function ActionLayer:updateNode(offset)
	if self.isDataRound then
		offset = offset % (self.dataNum * self.showNum)
	else
		offset = util.clampf(offset, 0, self.dataNum - self.showNum + 2 * (self.showStart - 1))
	end
	self.offset = offset
	self:updateShowNode(offset)
	self:updateDataNode(offset)
end
function ActionLayer:updateNum(num)
	self.dataNum = num
	self:updateNode(self.offset)
end
function ActionLayer:updateShowNode(showOffset)
	local actionOffset, actionPercent = math.modf(showOffset)
	for i = 1, self.showNum do
		local index = util.mod(i - actionOffset, self.showNum)
		local actions = self.actionsList[index]
		local cell = self.cellList[i]
		actions.cell = cell
		for j, v in ipairs(actions) do
			v:update(cell, actionPercent)
		end
	end
end
function ActionLayer:updateDataNode(offset)
	for i = 1, self.showNum do
		offset = math.floor(offset)
		local cellIndex = util.mod(i + offset, self.showNum)
		local cell = self.cellList[cellIndex]
		local dataIndex = i + offset - (self.showStart - 1)
		if self.isDataRound then
			dataIndex = util.mod(dataIndex, self.dataNum)
		end
		if dataIndex < 1 or dataIndex > self.dataNum then
			cell:setVisible(false)
		else
			cell:setVisible(true)
			if cell.idx ~= dataIndex then
				cell.idx = dataIndex
				self.updateCell(cell, dataIndex)
			end
		end
	end
end
function ActionLayer:refreshData()
	for i = 1, self.showNum do
		local cell = self.cellList[i]
		if cell.idx then
			self.updateCell(cell, cell.idx)
		end
	end
end
function ActionLayer:scrollToNode(offset, cb, changeDuration)
	if offset and (self.updateAction and self.updateAction:isFinish() or self.updateAction == nil) then
		self.updateAction = util.ValueTo.new(handler(self, self.updateNode), self.offset, offset)
		if changeDuration == true then
			self.updateAction:startWithDuration(self, 0.1)
		else
			self.updateAction:startWithDuration(self, 0.3)
		end
		if cb then
			self.updateAction:setFinishCb(cb)
		end
	end
end
function ActionLayer:scrollToIndex(dataIndex, showIndex, cb, changeDuration)
	local offset = self:indexToOffset(dataIndex, showIndex)
	self:scrollToNode(offset, cb, changeDuration)
end
function ActionLayer:jumpToIndex(dataIndex, showIndex)
	local offset = self:indexToOffset(dataIndex, showIndex)
	if offset then
		self:updateNode(offset)
	end
end
function ActionLayer:indexToOffset(dataIndex, showIndex)
	if dataIndex and showIndex then
		dataIndex = util.clampf(dataIndex, 1, self.dataNum)
		showIndex = util.clampf(showIndex, 1, self.showNum)
	else
		return nil
	end
	if self.isDataRound then
		local showOffset = math.floor(self.offset)
		local realShowIndex = util.mod(showIndex + showOffset, self.showNum)
		local offset = dataIndex - self.cellList[realShowIndex].idx
		local delta = math.abs(offset)
		local reverse = self.dataNum - delta
		if delta > reverse then
			if 0 < offset then
				offset = -reverse
			else
				offset = reverse
			end
		end
		offset = showOffset + offset
	else
		offset = dataIndex - 1 - (showIndex - 1) + (self.showStart - 1)
	end
	return offset
end
function ActionLayer:setDataRound(isRound)
	self.isDataRound = isRound
end
function ActionLayer:setCellBounceThreshold(value)
	self.cellThrehold = value
end
function ActionLayer:setCellBounceRatio(ratio)
	self.cellBounceRatio = ratio
end
function ActionLayer:setBoundBounceRatio(ratio)
	self.boundBounceRatio = ratio
end
function ActionLayer:setCellBounceCb(cb)
	self.cellBounceCb = cb
end
function ActionLayer:doBounce()
	if self.cellBounceRatio ~= 0 then
		local delta = math.abs(self.bounceEnd - self.bounceBegin)
		if delta >= self.cellThrehold then
			if self.bounceEnd > self.bounceBegin then
				self:scrollToNode(math.ceil(self.bounceEnd), self.cellBounceCb)
			else
				self:scrollToNode(math.floor(self.bounceEnd), self.cellBounceCb)
			end
		elseif 0 < delta then
			self:scrollToNode(math.ceil(self.bounceBegin))
		end
	end
end
function ActionLayer:reverseMoveDirection()
	self.moveDirection = -self.moveDirection
end
_ENV, ActionLayer.onTouch = function(self, sender, type)
	local pos, percent
	if type == ccui.TouchEventType.began then
		self.prePos = self:getTouchBeganPosition()
		self.moveDis = 0
		self.bounceBegin = math.ceil(self.offset)
	elseif type == ccui.TouchEventType.moved then
		self.nextPos = self:getTouchMovePosition()
		local distance = self.nextPos.x - self.prePos.x
		self.prePos = self.nextPos
		self.moveDis = self.moveDis + distance
		local offset = distance / self.distance * self.dataNum
		self:updateNode(self.offset + offset * self.moveDirection)
	elseif type == ccui.TouchEventType.ended or type == ccui.TouchEventType.canceled then
		self.bounceEnd = self.offset
		self:doBounce()
	end
	if self.touchCb then
		self.touchCb(sender, type)
	end
end, function(self, sender, type)
	local pos, percent
	if type == ccui.TouchEventType.began then
		self.prePos = self:getTouchBeganPosition()
		self.moveDis = 0
		self.bounceBegin = math.ceil(self.offset)
	elseif type == ccui.TouchEventType.moved then
		self.nextPos = self:getTouchMovePosition()
		local distance = self.nextPos.x - self.prePos.x
		self.prePos = self.nextPos
		self.moveDis = self.moveDis + distance
		local offset = distance / self.distance * self.dataNum
		self:updateNode(self.offset + offset * self.moveDirection)
	elseif type == ccui.TouchEventType.ended or type == ccui.TouchEventType.canceled then
		self.bounceEnd = self.offset
		self:doBounce()
	end
	if self.touchCb then
		self.touchCb(sender, type)
	end
end
;(function(self, sender, type)
	local pos, percent
	if type == ccui.TouchEventType.began then
		self.prePos = self:getTouchBeganPosition()
		self.moveDis = 0
		self.bounceBegin = math.ceil(self.offset)
	elseif type == ccui.TouchEventType.moved then
		self.nextPos = self:getTouchMovePosition()
		local distance = self.nextPos.x - self.prePos.x
		self.prePos = self.nextPos
		self.moveDis = self.moveDis + distance
		local offset = distance / self.distance * self.dataNum
		self:updateNode(self.offset + offset * self.moveDirection)
	elseif type == ccui.TouchEventType.ended or type == ccui.TouchEventType.canceled then
		self.bounceEnd = self.offset
		self:doBounce()
	end
	if self.touchCb then
		self.touchCb(sender, type)
	end
end).moveScale = "createMoveScale"
;(function(self, sender, type)
	local pos, percent
	if type == ccui.TouchEventType.began then
		self.prePos = self:getTouchBeganPosition()
		self.moveDis = 0
		self.bounceBegin = math.ceil(self.offset)
	elseif type == ccui.TouchEventType.moved then
		self.nextPos = self:getTouchMovePosition()
		local distance = self.nextPos.x - self.prePos.x
		self.prePos = self.nextPos
		self.moveDis = self.moveDis + distance
		local offset = distance / self.distance * self.dataNum
		self:updateNode(self.offset + offset * self.moveDirection)
	elseif type == ccui.TouchEventType.ended or type == ccui.TouchEventType.canceled then
		self.bounceEnd = self.offset
		self:doBounce()
	end
	if self.touchCb then
		self.touchCb(sender, type)
	end
end).ellipseMove = "createEllipseMove"
;(function(self, sender, type)
	local pos, percent
	if type == ccui.TouchEventType.began then
		self.prePos = self:getTouchBeganPosition()
		self.moveDis = 0
		self.bounceBegin = math.ceil(self.offset)
	elseif type == ccui.TouchEventType.moved then
		self.nextPos = self:getTouchMovePosition()
		local distance = self.nextPos.x - self.prePos.x
		self.prePos = self.nextPos
		self.moveDis = self.moveDis + distance
		local offset = distance / self.distance * self.dataNum
		self:updateNode(self.offset + offset * self.moveDirection)
	elseif type == ccui.TouchEventType.ended or type == ccui.TouchEventType.canceled then
		self.bounceEnd = self.offset
		self:doBounce()
	end
	if self.touchCb then
		self.touchCb(sender, type)
	end
end).rotate3DMove = "createRotate3DMove"
;(function(self, sender, type)
	local pos, percent
	if type == ccui.TouchEventType.began then
		self.prePos = self:getTouchBeganPosition()
		self.moveDis = 0
		self.bounceBegin = math.ceil(self.offset)
	elseif type == ccui.TouchEventType.moved then
		self.nextPos = self:getTouchMovePosition()
		local distance = self.nextPos.x - self.prePos.x
		self.prePos = self.nextPos
		self.moveDis = self.moveDis + distance
		local offset = distance / self.distance * self.dataNum
		self:updateNode(self.offset + offset * self.moveDirection)
	elseif type == ccui.TouchEventType.ended or type == ccui.TouchEventType.canceled then
		self.bounceEnd = self.offset
		self:doBounce()
	end
	if self.touchCb then
		self.touchCb(sender, type)
	end
end).cardMove = "createCardMove"
ActionLayer.Style, (function(self, sender, type)
	local pos, percent
	if type == ccui.TouchEventType.began then
		self.prePos = self:getTouchBeganPosition()
		self.moveDis = 0
		self.bounceBegin = math.ceil(self.offset)
	elseif type == ccui.TouchEventType.moved then
		self.nextPos = self:getTouchMovePosition()
		local distance = self.nextPos.x - self.prePos.x
		self.prePos = self.nextPos
		self.moveDis = self.moveDis + distance
		local offset = distance / self.distance * self.dataNum
		self:updateNode(self.offset + offset * self.moveDirection)
	elseif type == ccui.TouchEventType.ended or type == ccui.TouchEventType.canceled then
		self.bounceEnd = self.offset
		self:doBounce()
	end
	if self.touchCb then
		self.touchCb(sender, type)
	end
end).petCardMove = function(self, sender, type)
	local pos, percent
	if type == ccui.TouchEventType.began then
		self.prePos = self:getTouchBeganPosition()
		self.moveDis = 0
		self.bounceBegin = math.ceil(self.offset)
	elseif type == ccui.TouchEventType.moved then
		self.nextPos = self:getTouchMovePosition()
		local distance = self.nextPos.x - self.prePos.x
		self.prePos = self.nextPos
		self.moveDis = self.moveDis + distance
		local offset = distance / self.distance * self.dataNum
		self:updateNode(self.offset + offset * self.moveDirection)
	elseif type == ccui.TouchEventType.ended or type == ccui.TouchEventType.canceled then
		self.bounceEnd = self.offset
		self:doBounce()
	end
	if self.touchCb then
		self.touchCb(sender, type)
	end
end, "createPetCardMove"
function ActionStyle.createMoveScale(panel, showNum)
	local _ENV, actionsList
	local size = panel:getContentSize()
	local centerPos = cc.p(size.width / 2, size.height / 2)
	local centerIndex = math.ceil(showNum / 2)
	local scaleFactor = 0.8
	local opacityFactor = 0.8
	for i = 1, showNum do
		local pos = ActionStyle.horizontalAlign(showNum, i, 150, 0.9, centerPos)
		local scale = math.pow(scaleFactor, math.abs(i - centerIndex))
		local opacity = 255 * math.pow(opacityFactor, math.abs(i - centerIndex))
		local zorder = i <= centerIndex and i or i - centerIndex
		local j = util.mod(i - 1, showNum)
		local nextPos = ActionStyle.horizontalAlign(showNum, j, 150, 0.9, centerPos)
		local nextScale = math.pow(scaleFactor, math.abs(j - centerIndex))
		local nextOpacity = 255 * math.pow(opacityFactor, math.abs(j - centerIndex))
		local nextZorder = centerIndex >= j and j or j - centerIndex
		if i == 1 or i == showNum then
			opacity = 0
		end
		if j == 1 or j == showNum then
			nextOpacity = 0
		end
		local moveAction = util.MoveTo.new(pos, nextPos)
		local scaleAction = util.ScaleTo.new(scale, nextScale)
		local fadeAction = util.FadeTo.new(opacity, nextOpacity)
		local deepAction = util.DeepTo.new(zorder, nextZorder)
		_UPVALUE4_ = zorder
		actionsList[i], zorder[1] = zorder, moveAction
		actionsList[i], zorder[2] = zorder, scaleAction
		actionsList[i], zorder[3] = zorder, fadeAction
		actionsList[i], zorder[4] = zorder, deepAction
	end
	return actionsList
end
function ActionStyle.createEllipseMove(panel, showNum)
	local _ENV, actionsList
	local size = panel:getContentSize()
	local centerPos = cc.p(size.width / 2, size.height / 2)
	local addAngle = 360 / showNum
	for i = 1, showNum do
		local ellipseActin = util.EllipseTo.new((i - 1) * addAngle, (i - 2) * addAngle, centerPos, 300, 100)
		_UPVALUE1_ = (i - 1) * addAngle
		actionsList[i], (i - 1) * addAngle[1] = (i - 1) * addAngle, ellipseActin
	end
	return actionsList
end
function ActionStyle.createCardMove(panel, showNum)
	local _ENV, actionsList
	local size = panel:getContentSize()
	local centerPos = cc.p(size.width / 2, size.height / 2)
	_ENV, _UPVALUE7_ = size.height / 2, size.width / 2
	;(size.height / 2).pos = cc.p(centerPos.x - 360, centerPos.y - 150)
	;(size.height / 2).opacity = 0
	;(size.height / 2).rotate = util.vec3(0, 0, -30)
	;(size.height / 2).zorder = 20
	_ENV, (size.height / 2).color = cc.c3b(77, 77, 77), cc.c3b(77, 77, 77)
	cc.c3b(77, 77, 77).pos = cc.p(centerPos.x - 240, centerPos.y - 100)
	cc.c3b(77, 77, 77).opacity = 255
	cc.c3b(77, 77, 77).rotate = util.vec3(0, 0, -20)
	cc.c3b(77, 77, 77).zorder = 30
	_ENV, cc.c3b(77, 77, 77).color = cc.c3b(77, 77, 77), cc.c3b(77, 77, 77)
	cc.c3b(77, 77, 77).pos = cc.p(centerPos.x - 120, centerPos.y - 40)
	cc.c3b(77, 77, 77).opacity = 255
	cc.c3b(77, 77, 77).rotate = util.vec3(0, 0, -10)
	cc.c3b(77, 77, 77).zorder = 40
	_ENV, cc.c3b(77, 77, 77).color = cc.c3b(77, 77, 77), cc.c3b(77, 77, 77)
	cc.c3b(77, 77, 77).pos = cc.p(centerPos.x, centerPos.y)
	cc.c3b(77, 77, 77).scale = 1
	cc.c3b(77, 77, 77).opacity = 255
	cc.c3b(77, 77, 77).rotate = util.vec3(0, 0, 0)
	cc.c3b(77, 77, 77).zorder = 50
	_ENV, cc.c3b(77, 77, 77).color = cc.c3b(255, 255, 255), cc.c3b(255, 255, 255)
	cc.c3b(255, 255, 255).pos = cc.p(centerPos.x + 120, centerPos.y - 40)
	cc.c3b(255, 255, 255).opacity = 255
	cc.c3b(255, 255, 255).rotate = util.vec3(0, 0, 10)
	cc.c3b(255, 255, 255).zorder = 40
	_ENV, cc.c3b(255, 255, 255).color = cc.c3b(77, 77, 77), cc.c3b(77, 77, 77)
	cc.c3b(77, 77, 77).pos = cc.p(centerPos.x + 240, centerPos.y - 100)
	cc.c3b(77, 77, 77).opacity = 255
	cc.c3b(77, 77, 77).rotate = util.vec3(0, 0, 20)
	cc.c3b(77, 77, 77).zorder = 30
	_ENV, cc.c3b(77, 77, 77).color = cc.c3b(77, 77, 77), cc.c3b(77, 77, 77)
	cc.c3b(77, 77, 77).pos = cc.p(centerPos.x + 360, centerPos.y - 150)
	cc.c3b(77, 77, 77).opacity = 0
	cc.c3b(77, 77, 77).rotate = util.vec3(0, 0, 30)
	cc.c3b(77, 77, 77).zorder = 20
	cc.c3b(77, 77, 77).color = cc.c3b(77, 77, 77)
	;(size.width / 2)[1] = size.height / 2
	;(size.width / 2)[2] = cc.c3b(77, 77, 77)
	;(size.width / 2)[3] = cc.c3b(77, 77, 77)
	;(size.width / 2)[4] = cc.c3b(77, 77, 77)
	;(size.width / 2)[5] = cc.c3b(255, 255, 255)
	;(size.width / 2)[6] = cc.c3b(77, 77, 77)
	local (size.width / 2)[7], data = cc.c3b(77, 77, 77), size.width / 2
	for i, v in ipairs(data) do
		local j = i - 1
		if j == 0 then
			j = 7
		end
		local moveAction = util.MoveTo.new(data[i].pos, data[j].pos)
		local fadeAction = util.FadeTo.new(data[i].opacity, data[j].opacity)
		local deepAction = util.DeepTo.new(data[i].zorder, data[j].zorder)
		local rotateAction = util.Rotate3DTo.new(data[i].rotate, data[j].rotate)
		local colorAction = util.ColorTo.new(data[i].color, data[j].color)
		_UPVALUE5_ = data[i].color
		actionsList[i], data[i].color[1] = data[i].color, moveAction
		actionsList[i], data[i].color[2] = data[i].color, fadeAction
		actionsList[i], data[i].color[3] = data[i].color, rotateAction
		actionsList[i], data[i].color[4] = data[i].color, deepAction
		actionsList[i], data[i].color[5] = data[i].color, colorAction
	end
	actionsList[4][2] = util.FadeTimeTo.new(255, 170, 255, 0.5)
	actionsList[5][2] = util.FadeTimeTo.new(255, 170, 255, 0.5)
	return actionsList
end
function ActionStyle.createPetCardMove(panel, showNum)
	local _ENV, actionsList
	local size = panel:getContentSize()
	local centerPos = cc.p(size.width / 2, size.height / 2)
	_ENV, _UPVALUE7_ = size.height / 2, size.width / 2
	;(size.height / 2).pos = cc.p(centerPos.x - 360, centerPos.y - 160)
	;(size.height / 2).opacity = 0
	;(size.height / 2).rotate = util.vec3(0, 0, -30)
	;(size.height / 2).zorder = 20
	_ENV, (size.height / 2).color = cc.c3b(255, 255, 255), cc.c3b(255, 255, 255)
	cc.c3b(255, 255, 255).pos = cc.p(centerPos.x - 240, centerPos.y - 110)
	cc.c3b(255, 255, 255).opacity = 255
	cc.c3b(255, 255, 255).rotate = util.vec3(0, 0, -20)
	cc.c3b(255, 255, 255).zorder = 30
	_ENV, cc.c3b(255, 255, 255).color = cc.c3b(255, 255, 255), cc.c3b(255, 255, 255)
	cc.c3b(255, 255, 255).pos = cc.p(centerPos.x - 120, centerPos.y - 50)
	cc.c3b(255, 255, 255).opacity = 255
	cc.c3b(255, 255, 255).rotate = util.vec3(0, 0, -10)
	cc.c3b(255, 255, 255).zorder = 40
	_ENV, cc.c3b(255, 255, 255).color = cc.c3b(255, 255, 255), cc.c3b(255, 255, 255)
	cc.c3b(255, 255, 255).pos = cc.p(centerPos.x, centerPos.y - 10)
	cc.c3b(255, 255, 255).scale = 1
	cc.c3b(255, 255, 255).opacity = 255
	cc.c3b(255, 255, 255).rotate = util.vec3(0, 0, 0)
	cc.c3b(255, 255, 255).zorder = 50
	_ENV, cc.c3b(255, 255, 255).color = cc.c3b(255, 255, 255), cc.c3b(255, 255, 255)
	cc.c3b(255, 255, 255).pos = cc.p(centerPos.x + 120, centerPos.y - 50)
	cc.c3b(255, 255, 255).opacity = 255
	cc.c3b(255, 255, 255).rotate = util.vec3(0, 0, 10)
	cc.c3b(255, 255, 255).zorder = 40
	_ENV, cc.c3b(255, 255, 255).color = cc.c3b(255, 255, 255), cc.c3b(255, 255, 255)
	cc.c3b(255, 255, 255).pos = cc.p(centerPos.x + 240, centerPos.y - 110)
	cc.c3b(255, 255, 255).opacity = 255
	cc.c3b(255, 255, 255).rotate = util.vec3(0, 0, 20)
	cc.c3b(255, 255, 255).zorder = 30
	_ENV, cc.c3b(255, 255, 255).color = cc.c3b(255, 255, 255), cc.c3b(255, 255, 255)
	cc.c3b(255, 255, 255).pos = cc.p(centerPos.x + 360, centerPos.y - 160)
	cc.c3b(255, 255, 255).opacity = 0
	cc.c3b(255, 255, 255).rotate = util.vec3(0, 0, 30)
	cc.c3b(255, 255, 255).zorder = 20
	cc.c3b(255, 255, 255).color = cc.c3b(255, 255, 255)
	;(size.width / 2)[1] = size.height / 2
	;(size.width / 2)[2] = cc.c3b(255, 255, 255)
	;(size.width / 2)[3] = cc.c3b(255, 255, 255)
	;(size.width / 2)[4] = cc.c3b(255, 255, 255)
	;(size.width / 2)[5] = cc.c3b(255, 255, 255)
	;(size.width / 2)[6] = cc.c3b(255, 255, 255)
	local (size.width / 2)[7], data = cc.c3b(255, 255, 255), size.width / 2
	for i, v in ipairs(data) do
		local j = i - 1
		if j == 0 then
			j = 7
		end
		local moveAction = util.MoveTo.new(data[i].pos, data[j].pos)
		local fadeAction = util.FadeTo.new(data[i].opacity, data[j].opacity)
		local deepAction = util.DeepTo.new(data[i].zorder, data[j].zorder)
		local rotateAction = util.Rotate3DTo.new(data[i].rotate, data[j].rotate)
		local colorAction = util.ColorTo.new(data[i].color, data[j].color)
		_UPVALUE5_ = data[i].color
		actionsList[i], data[i].color[1] = data[i].color, moveAction
		actionsList[i], data[i].color[2] = data[i].color, fadeAction
		actionsList[i], data[i].color[3] = data[i].color, rotateAction
		actionsList[i], data[i].color[4] = data[i].color, deepAction
		actionsList[i], data[i].color[5] = data[i].color, colorAction
	end
	actionsList[4][2] = util.FadeTimeTo.new(255, 170, 255, 0.1)
	actionsList[5][2] = util.FadeTimeTo.new(255, 170, 255, 0.1)
	return actionsList
end
function ActionStyle.createCardMove1(panel, showNum)
	local _ENV, actionsList
	local size = panel:getContentSize()
	local centerPos = cc.p(size.width / 2, 0)
	_ENV, _UPVALUE7_ = 0, size.width / 2
	;(0).pos = cc.p(centerPos.x, centerPos.y - 60)
	;(0).opacity = 0
	;(0).rotate = util.vec3(0, 0, -90)
	_ENV, (0).zorder = util.vec3(0, 0, -90), 2
	util.vec3(0, 0, -90).pos = cc.p(centerPos.x, centerPos.y - 40)
	util.vec3(0, 0, -90).opacity = 255
	util.vec3(0, 0, -90).rotate = util.vec3(0, 0, -60)
	_ENV, util.vec3(0, 0, -90).zorder = util.vec3(0, 0, -60), 3
	util.vec3(0, 0, -60).pos = cc.p(centerPos.x, centerPos.y - 20)
	util.vec3(0, 0, -60).opacity = 255
	util.vec3(0, 0, -60).rotate = util.vec3(0, 0, -30)
	_ENV, util.vec3(0, 0, -60).zorder = util.vec3(0, 0, -30), 4
	util.vec3(0, 0, -30).pos = cc.p(centerPos.x, centerPos.y)
	util.vec3(0, 0, -30).scale = 1
	util.vec3(0, 0, -30).opacity = 255
	util.vec3(0, 0, -30).rotate = util.vec3(0, 0, 0)
	_ENV, util.vec3(0, 0, -30).zorder = util.vec3(0, 0, 0), 5
	util.vec3(0, 0, 0).pos = cc.p(centerPos.x, centerPos.y - 20)
	util.vec3(0, 0, 0).opacity = 255
	util.vec3(0, 0, 0).rotate = util.vec3(0, 0, 30)
	_ENV, util.vec3(0, 0, 0).zorder = util.vec3(0, 0, 30), 4
	util.vec3(0, 0, 30).pos = cc.p(centerPos.x, centerPos.y - 40)
	util.vec3(0, 0, 30).opacity = 255
	util.vec3(0, 0, 30).rotate = util.vec3(0, 0, 60)
	_ENV, util.vec3(0, 0, 30).zorder = util.vec3(0, 0, 60), 3
	util.vec3(0, 0, 60).pos = cc.p(centerPos.x, centerPos.y - 60)
	util.vec3(0, 0, 60).opacity = 0
	util.vec3(0, 0, 60).rotate = util.vec3(0, 0, 90)
	util.vec3(0, 0, 60).zorder = 2
	;(size.width / 2)[1] = 0
	;(size.width / 2)[2] = util.vec3(0, 0, -90)
	;(size.width / 2)[3] = util.vec3(0, 0, -60)
	;(size.width / 2)[4] = util.vec3(0, 0, -30)
	;(size.width / 2)[5] = util.vec3(0, 0, 0)
	;(size.width / 2)[6] = util.vec3(0, 0, 30)
	local (size.width / 2)[7], data = util.vec3(0, 0, 60), size.width / 2
	for i, v in ipairs(data) do
		local j = i - 1
		if j == 0 then
			j = 7
		end
		local moveAction = util.MoveTo.new(data[i].pos, data[j].pos)
		local fadeAction = util.FadeTo.new(data[i].opacity, data[j].opacity)
		local deepAction = util.DeepTo.new(data[i].zorder, data[j].zorder)
		local rotateAction = util.Rotate3DTo.new(data[i].rotate, data[j].rotate)
		_UPVALUE4_ = data[i].rotate
		actionsList[i], data[i].rotate[1] = data[i].rotate, moveAction
		actionsList[i], data[i].rotate[2] = data[i].rotate, fadeAction
		actionsList[i], data[i].rotate[3] = data[i].rotate, rotateAction
		actionsList[i], data[i].rotate[4] = data[i].rotate, deepAction
	end
	return actionsList
end
function ActionStyle.createRotate3DMove(panel, showNum)
	local _ENV, actionsList
	local size = panel:getContentSize()
	local centerPos = cc.p(size.width / 2, size.height / 2)
	_ENV, _UPVALUE5_ = size.height / 2, size.width / 2
	;(size.height / 2).pos = cc.p(centerPos.x - 400, centerPos.y)
	;(size.height / 2).scale = 0.5
	;(size.height / 2).opacity = 0
	;(size.height / 2).rotate = util.vec3(0, 60, 0)
	_ENV, (size.height / 2).zorder = util.vec3(0, 60, 0), 1
	util.vec3(0, 60, 0).pos = cc.p(centerPos.x - 200, centerPos.y)
	util.vec3(0, 60, 0).scale = 0.8
	util.vec3(0, 60, 0).opacity = 255
	util.vec3(0, 60, 0).rotate = util.vec3(0, 45, 0)
	_ENV, util.vec3(0, 60, 0).zorder = util.vec3(0, 45, 0), 2
	util.vec3(0, 45, 0).pos = cc.p(centerPos.x, centerPos.y)
	util.vec3(0, 45, 0).scale = 1
	util.vec3(0, 45, 0).opacity = 255
	util.vec3(0, 45, 0).rotate = util.vec3(0, 0, 0)
	_ENV, util.vec3(0, 45, 0).zorder = util.vec3(0, 0, 0), 3
	util.vec3(0, 0, 0).pos = cc.p(centerPos.x + 200, centerPos.y)
	util.vec3(0, 0, 0).scale = 0.8
	util.vec3(0, 0, 0).opacity = 255
	util.vec3(0, 0, 0).rotate = util.vec3(0, -45, 0)
	_ENV, util.vec3(0, 0, 0).zorder = util.vec3(0, -45, 0), 2
	util.vec3(0, -45, 0).pos = cc.p(centerPos.x + 400, centerPos.y)
	util.vec3(0, -45, 0).scale = 0.5
	util.vec3(0, -45, 0).opacity = 0
	util.vec3(0, -45, 0).rotate = util.vec3(0, 60, 0)
	util.vec3(0, -45, 0).zorder = 1
	;(size.width / 2)[1] = size.height / 2
	;(size.width / 2)[2] = util.vec3(0, 60, 0)
	;(size.width / 2)[3] = util.vec3(0, 45, 0)
	;(size.width / 2)[4] = util.vec3(0, 0, 0)
	local (size.width / 2)[5], data = util.vec3(0, -45, 0), size.width / 2
	for i, v in ipairs(data) do
		local j = i - 1
		if j == 0 then
			j = 5
		end
		local moveAction = util.MoveTo.new(data[i].pos, data[j].pos)
		local scaleAction = util.ScaleTo.new(data[i].scale, data[j].scale)
		local fadeAction = util.FadeTo.new(data[i].opacity, data[j].opacity)
		local deepAction = util.DeepTo.new(data[i].zorder, data[j].zorder)
		local rotateAction = util.Rotate3DTo.new(data[i].rotate, data[j].rotate)
		_UPVALUE5_ = data[i].rotate
		actionsList[i], data[i].rotate[1] = data[i].rotate, moveAction
		actionsList[i], data[i].rotate[2] = data[i].rotate, scaleAction
		actionsList[i], data[i].rotate[3] = data[i].rotate, fadeAction
		actionsList[i], data[i].rotate[4] = data[i].rotate, rotateAction
		actionsList[i], data[i].rotate[5] = data[i].rotate, deepAction
	end
	return actionsList
end
function ActionStyle.horizontalAlign(showNum, index, space, factor, centerPos)
	local centerIndex = math.ceil(showNum / 2)
	if centerIndex == index then
		return centerPos
	else
		local x
		if index < centerIndex then
			x = centerPos.x - space * (1.0 - math.pow(factor, centerIndex - index)) / (1.0 - factor)
		else
			x = centerPos.x + space * (1.0 - math.pow(factor, index - centerIndex)) / (1.0 - factor)
		end
		return cc.p(x, centerPos.y)
	end
end
function ActionStyle.verticalAlign(showNum, index, space, factor, centerPos)
	local centerIndex = math.ceil(showNum / 2)
	if centerIndex == index then
		return centerPos
	else
		local y
		if index < centerIndex then
			y = centerPos.y - space * (1.0 - math.pow(factor, centerIndex - index)) / (1.0 - factor)
		else
			y = centerPos.y + space * (1.0 - math.pow(factor, index - centerIndex)) / (1.0 - factor)
		end
		return cc.p(centerPos.x, y)
	end
end
return ActionLayer

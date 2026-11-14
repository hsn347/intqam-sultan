local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activityCommonBubbleCtrl = SoraDGetCtrl("activityCommonBubbleCtrl")
local activityCommonBubbleRead = include("activityCommonBubbleRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_map = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001638/Com_map", Com_map)
fgui.register_extension("ui://Activity_9001638/Com_map_9001664", Com_map)
fgui.register_extension("ui://Activity_9001638/Com_map_9001693", Com_map)
_UPVALUE2_, _UPVALUE6_, _ENV = Com_map, "ui://Activity_9001638/Com_map_9001693", fgui.register_extension
_UPVALUE2_, Com_map[1] = 1, 1
_UPVALUE2_, Com_map[2] = 1, 0
_UPVALUE2_, (1)[1] = 0, 0
_UPVALUE2_, (1)[2] = 0, 1
_UPVALUE2_, (0)[1] = -1, -1
_UPVALUE2_, (0)[2] = -1, 1
_UPVALUE2_, (-1)[1] = -1, -1
_UPVALUE2_, (-1)[2] = -1, 0
_UPVALUE2_, (-1)[1] = -1, -1
_UPVALUE2_, (-1)[2] = -1, -1
;(-1)[1] = 0
;(-1)[2] = -1
_UPVALUE2_, _UPVALUE6_, fgui.register_extension[1], ("ui://Activity_9001638/Com_map_9001693")[1] = Com_map, "ui://Activity_9001638/Com_map_9001693", "ui://Activity_9001638/Com_map_9001693", Com_map
_UPVALUE2_, _UPVALUE6_, fgui.register_extension[1], ("ui://Activity_9001638/Com_map_9001693")[2] = Com_map, "ui://Activity_9001638/Com_map_9001693", "ui://Activity_9001638/Com_map_9001693", 1
_UPVALUE2_, _UPVALUE6_, fgui.register_extension[1], ("ui://Activity_9001638/Com_map_9001693")[3] = Com_map, "ui://Activity_9001638/Com_map_9001693", "ui://Activity_9001638/Com_map_9001693", 0
_UPVALUE2_, _UPVALUE6_, fgui.register_extension[1], ("ui://Activity_9001638/Com_map_9001693")[4] = Com_map, "ui://Activity_9001638/Com_map_9001693", "ui://Activity_9001638/Com_map_9001693", -1
_UPVALUE2_, _UPVALUE6_, fgui.register_extension[1], ("ui://Activity_9001638/Com_map_9001693")[5] = Com_map, "ui://Activity_9001638/Com_map_9001693", "ui://Activity_9001638/Com_map_9001693", -1
_UPVALUE2_, _UPVALUE6_, fgui.register_extension[1], ("ui://Activity_9001638/Com_map_9001693")[6] = Com_map, "ui://Activity_9001638/Com_map_9001693", "ui://Activity_9001638/Com_map_9001693", -1
_UPVALUE2_, Com_map[1] = 1, 1
_UPVALUE2_, Com_map[2] = 1, 0
_UPVALUE2_, (1)[1] = 1, 1
_UPVALUE2_, (1)[2] = 1, 1
_UPVALUE2_, (1)[1] = 0, 0
_UPVALUE2_, (1)[2] = 0, 1
_UPVALUE2_, (0)[1] = -1, -1
_UPVALUE2_, (0)[2] = -1, 0
_UPVALUE2_, (-1)[1] = 0, 0
_UPVALUE2_, (-1)[2] = 0, -1
;(0)[1] = 1
;(0)[2] = -1
fgui.register_extension[2], ("ui://Activity_9001638/Com_map_9001693")[1] = "ui://Activity_9001638/Com_map_9001693", Com_map
fgui.register_extension[2], ("ui://Activity_9001638/Com_map_9001693")[2] = "ui://Activity_9001638/Com_map_9001693", 1
fgui.register_extension[2], ("ui://Activity_9001638/Com_map_9001693")[3] = "ui://Activity_9001638/Com_map_9001693", 1
fgui.register_extension[2], ("ui://Activity_9001638/Com_map_9001693")[4] = "ui://Activity_9001638/Com_map_9001693", 0
fgui.register_extension[2], ("ui://Activity_9001638/Com_map_9001693")[5] = "ui://Activity_9001638/Com_map_9001693", -1
fgui.register_extension[2], ("ui://Activity_9001638/Com_map_9001693")[6] = "ui://Activity_9001638/Com_map_9001693", 0
local AROUND_VECTOR = fgui.register_extension
local MAX_X, MAX_Y = 8, 8
local COLOR_MAX = 4
function Com_map:checkSameColorBubble(curSelectObj)
	curSelectObj:setIsSelect(true)
	_UPVALUE1_ = curSelectObj.setIsSelect
	local curSelectObj.setIsSelect[1], checkList = curSelectObj, curSelectObj.setIsSelect
	local _ENV, checkMap = curSelectObj, curSelectObj
	local function checkSingleObj(checkObj)
		local tilePos = checkObj:getTilePos()
		local posList = self:getBubbleAroundPos(tilePos)
		for __, pos in ipairs(posList) do
			local obj = self.bubbleMgr[pos.y] and self.bubbleMgr[pos.y][pos.x]
			local bCheck = checkMap[pos.y] and checkMap[pos.y][pos.x]
			if not bCheck and obj and obj:checkSameColor(curSelectObj:getColor()) then
				obj:setIsSelect(true)
				table.insert(checkList, obj)
				if not checkMap[pos.y] then
					self = checkMap[pos.y]
				end
				checkMap[pos.y] = checkMap[pos.y]
				checkMap[pos.y][pos.x] = true
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
	self:walkMgr(function(obj)
		obj:setIsConnect(false)
	end)
	local _ENV, checkList = self.walkMgr, self.walkMgr
	local _ENV, checkMap = self, self
	local function checkSingleObj(checkObj)
		local tilePos = checkObj:getTilePos()
		local posList = self:getBubbleAroundPos(tilePos)
		for __, pos in ipairs(posList) do
			local obj = self.bubbleMgr[pos.y] and self.bubbleMgr[pos.y][pos.x]
			local bCheck = checkMap[pos.y] and checkMap[pos.y][pos.x]
			if not bCheck and obj and not obj:isDie() and not obj:getIsSelect() then
				obj:setIsConnect(true)
				table.insert(checkList, obj)
				if not checkMap[pos.y] then
					self = checkMap[pos.y]
				end
				checkMap[pos.y] = checkMap[pos.y]
				checkMap[pos.y][pos.x] = true
			end
		end
		local nextObj = table.remove(checkList, 1)
		if nextObj then
			checkSingleObj(nextObj)
		end
	end
	if not self.bubbleMgr[1] then
		_ENV = self.bubbleMgr[1]
	end
	for __, obj in pairs(self.bubbleMgr[1]) do
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
function Com_map:getBubbleAroundPos(pos)
	local MAX_X, ret
	local index = pos.y % 2 == 0 and 2 or 1
	local maxX, maxY = MAX_X, MAX_Y
	for k, v in ipairs(AROUND_VECTOR[index]) do
		local x = pos.x + v[1]
		local y = pos.y + v[2]
		if not (x < 1) and not (y < 1) and not (maxX < x) and not (maxY < y) then
			MAX_X = nil
			;(nil).x = x
			;(nil).y = y
			table.insert(ret, nil)
		end
	end
	return ret
end
function Com_map:walkMgr(func)
	for __, v in pairs(self.bubbleMgr) do
		for __, obj in pairs(v) do
			func(obj)
		end
	end
end
function Com_map:onInit()
	self.isMoving = false
	self.colorMap, _ENV, self.changeModel = nil, nil, false
	self.dottedPool, _ENV, self.dottedList, _ENV, self.tranIndex = nil, nil, nil, nil, 1
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001638
	self.itemID = activityCommonBubbleCtrl:getItemID(self.activityID)
	self.fields.Panel_move:addEventListener(fgui.UIEventType.TouchBegin, handler(self, self.onEventTouchBegin))
	self.fields.Panel_move:addEventListener(fgui.UIEventType.TouchMove, handler(self, self.onEventTouchMove))
	self.fields.Panel_move:addEventListener(fgui.UIEventType.TouchEnd, handler(self, self.onEventTouchEnd))
	local showDrawNode = false
	if showDrawNode then
		local drawNode = cc.DrawNode:create()
		drawNode:addTo(self)
		self.drawNode = drawNode
	end
	local _fields = fguiHelper.get_fields(self.fields.Com_battery)
	self.Com_battery = _fields.Com_battery
	self.showBubble = self.Com_battery:getChild("Com_bubble")
	_fields.Button_left:addClickListener(handler(self, self.onClickBtnLeft))
	_fields.Button_right:addClickListener(handler(self, self.onClickBtnRight))
	self.mv_pao01 = self.Com_battery:getChild("mv_pao01")
	if self.mv_pao01 then
		self.mv_pao01:setAllFrameName("G_9001638_pao01_%02d.png", 1)
		self.mv_pao01:setVisible(false)
	end
	self.mv_pao02 = _fields.mv_pao02
	if self.mv_pao02 then
		self.mv_pao02:setAllFrameName("G_9001638_pao02_%02d.png", 1)
		self.mv_pao02:setVisible(false)
	end
	local _transitions = fguiHelper.get_transitions(self.fields.Com_battery)
	_UPVALUE4_ = self.fields.Com_battery
	_UPVALUE4_, self.t_changeList, self.fields.Com_battery[1] = self.fields.Com_battery, self.fields.Com_battery, _transitions.t_change1
	_UPVALUE4_, self.t_changeList, self.fields.Com_battery[2] = self.fields.Com_battery, self.fields.Com_battery, _transitions.t_change2
	_UPVALUE4_, self.t_changeList, self.fields.Com_battery[3] = self.fields.Com_battery, self.fields.Com_battery, _transitions.t_change3
	_UPVALUE4_, self.t_changeList, self.fields.Com_battery[4] = self.fields.Com_battery, self.fields.Com_battery, _transitions.t_change4
	self.bubbleCfgList, _ENV, self.bubbleList, self.fields.Com_battery[1] = self.fields.Com_battery, self.fields.Com_battery, self.fields.Com_battery, _fields.Com_bubble1
	self.bubbleCfgList, _ENV, self.bubbleList, self.fields.Com_battery[2] = self.fields.Com_battery, self.fields.Com_battery, self.fields.Com_battery, _fields.Com_bubble2
	self.bubbleCfgList, _ENV, self.bubbleList, self.fields.Com_battery[3] = self.fields.Com_battery, self.fields.Com_battery, self.fields.Com_battery, _fields.Com_bubble3
	self.bubbleCfgList, _ENV, self.bubbleList, self.fields.Com_battery[4] = self.fields.Com_battery, self.fields.Com_battery, self.fields.Com_battery, _fields.Com_bubble4
	for __, bubble in ipairs(self.bubbleList) do
		_ENV = handler(self, self.onClickBtnRight)
		handler(self, self.onClickBtnRight).pos = bubble:getPosition()
		handler(self, self.onClickBtnRight).scale = bubble:getScale()
		table.insert(self.bubbleCfgList, handler(self, self.onClickBtnRight))
	end
	self.myBubble = self.fields.Com_bubble
	self.myBubble:setAllFrameName()
	_ENV, self.objSize = self.myBubble:getContentSize(), self.myBubble:getContentSize()
	self.myBubble:getContentSize().x = self.objSize.width
	self.posStep, self.myBubble:getContentSize().y = self.myBubble:getContentSize(), math.ceil(self.objSize.height * 0.866)
end
function Com_map:onShow()
	local basePos = self.myBubble:getPosition()
	self.curPos = cc.p(basePos.x + self.objSize.width / 2, basePos.y + self.objSize.height / 2)
	self.maxY = self.fields.Panel_move:getContentSize().height
	self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp), true)
end
function Com_map:initMapData(mapData)
	self.bubbleMgr, MAX_Y, self.mapData = nil, nil, mapData
	for y = 1, MAX_Y do
		for x = 1, MAX_X do
			self:initBubbleSingle(x, y)
		end
	end
	for i, obj in ipairs(self.bubbleList) do
		obj:setColorType(i)
		local cfg = self.bubbleCfgList[i]
		obj:setPosition(cfg.pos)
		obj:setScale(cfg.scale)
	end
	self.showBubble:setColorType(self.tranIndex or 1)
end
function Com_map:initBubbleSingle(x, y)
	if not self.mapData[y] or not self.mapData[y][x] then
		local _ENV, data = self.mapData[y][x], self.mapData[y][x]
	end
	local colorType = data.color or 0
	if colorType == 0 then
		return
	end
	local obj = self:createBubbleSingle()
	local mapPos = self:tilePos2mapPos(cc.p(x, y))
	obj:setPosition(mapPos)
	_ENV = mapPos
	mapPos.x = x
	mapPos.y = y
	mapPos.colorType = colorType
	obj:initData(mapPos)
	if not self.bubbleMgr[y] then
		_ENV = self.bubbleMgr[y]
	end
	self.bubbleMgr[y] = self.bubbleMgr[y]
	self.bubbleMgr[y][x] = obj
end
function Com_map:createBubbleSingle(...)
	local obj = fgui.UIPackage:createObject("Activity_9001638", "Com_bubble")
	obj:addTo(self.fields.Panel_map)
	obj:initActivityID(self.activityID)
	return obj
end
function Com_map:onClickBtnLeft(...)
	self.tranIndex = (self.tranIndex - 2) % COLOR_MAX + 1
	local t_change = self.t_changeList[self.tranIndex]
	t_change:playReverse()
	local tranIndex = self.tranIndex
	_UPVALUE4_ = t_change
	t_change[1] = 1
	t_change[2] = 4
	t_change[3] = 3
	local t_change[4], config = 2, t_change
	local _index = config[tranIndex]
	self.showBubble:setColorType(_index)
end
function Com_map:onClickBtnRight(...)
	local t_change = self.t_changeList[self.tranIndex]
	t_change:play()
	self.tranIndex = self.tranIndex % COLOR_MAX + 1
	local tranIndex = (self.tranIndex - 2) % COLOR_MAX + 1
	_UPVALUE4_ = COLOR_MAX
	COLOR_MAX[1] = 4
	COLOR_MAX[2] = 3
	COLOR_MAX[3] = 2
	local COLOR_MAX[4], config = 1, COLOR_MAX
	local _index = config[tranIndex]
	self.showBubble:setColorType(_index)
end
function Com_map:onEventTouchBegin(context)
	if self.changeModel then
		return
	end
	if self.isMoving then
		return
	end
	if not self:checkItemEnough() then
		SoraDShowMsgTip(i18n("notice_0120"))
		return
	end
	context:captureTouch()
	self:resetMyBubble()
	self.touchBegin = true
	local _toPos = context:getInput():getPosition()
	self:updateToPos(_toPos)
end
function Com_map:onEventTouchMove(context)
	if self.changeModel then
		return
	end
	self.touchBegin = true
	local _toPos = context:getInput():getPosition()
	self:updateToPos(_toPos)
end
function Com_map:onEventTouchEnd(context)
	if self.changeModel then
		local _toPos = context:getInput():getPosition()
		local toPos = self:globalToLocal(_toPos)
		local tilePos = self:mapPos2tilePos(toPos)
		local obj = self.bubbleMgr[tilePos.y] and self.bubbleMgr[tilePos.y][tilePos.x]
		if obj then
			local color = obj:getColorType() % COLOR_MAX + 1
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
	self.myBubble:setColorType(self.showBubble:getColorType())
	self.showBubble:setVisible(false)
	self:recycleDotted()
end
function Com_map:updateToPos(_toPos)
	local toPos = self:globalToLocal(_toPos)
	local checkPos = toPos.y <= self.maxY
	local angle = SoraDGetAngleByPos(self.curPos, toPos)
	local checkAngle = -150 <= angle and angle <= -30
	if not checkPos or not checkAngle then
		self:recycleDotted()
		self.touchBegin = false
	end
	if checkAngle and checkPos then
		self:drawLine(self.curPos, toPos)
	end
	if checkAngle then
		self.Com_battery:setRotation(angle + 90)
	end
end
function Com_map:recycleDotted(...)
	for __, v in ipairs(self.dottedList) do
		v:setVisible(false)
		table.insert(self.dottedPool, v)
	end
	self.dottedList, _ENV = ipairs(self.dottedList)
	if self.drawNode then
		self.drawNode:clear()
	end
end
function Com_map:drawLine(beginPos, endPos)
	self:recycleDotted()
	self.posList, _ENV = self.recycleDotted, self.recycleDotted
	local mapH = self:getHeight()
	table.insert(self.posList, beginPos)
	self:rayCastBack(beginPos, endPos)
	for i = 2, #self.posList do
		if self.drawNode then
			local pos1 = self.posList[i - 1]
			local pos2 = self.posList[i]
			self.drawNode:drawLine(cc.p(pos1.x, mapH - pos1.y), cc.p(pos2.x, mapH - pos2.y), cc.c4b(1, 1, 1, 1))
		end
		local obj = table.remove(self.dottedPool)
		if obj then
			obj:setVisible(true)
		else
			obj = fgui.UIPackage:createObject("Activity_9001638", "Com_dottedLine")
			obj:addTo(self.fields.Panel_line)
		end
		table.insert(self.dottedList, obj)
		local colorType = self.showBubble:getColorType()
		obj:setIcon(activityCommonBubbleRead.getLinePointURL(colorType, self.activityID))
		local pos1 = self.posList[i - 1]
		local pos2 = self.posList[i]
		obj:setPosition(pos1)
		local distance = cc.pGetDistance(pos1, pos2)
		obj:setHeight(distance)
		local angle = SoraDGetAngleByPos(pos1, pos2)
		obj:setRotation(90 + angle)
	end
end
function Com_map:rayCastBack(beginPos, endPos)
	local nextEndPos = self:getNextEndPos(beginPos, endPos)
	local interPos = self:rayCastBubble(beginPos, nextEndPos)
	if interPos then
		table.insert(self.posList, interPos)
	else
		table.insert(self.posList, nextEndPos)
		local mapH = self:getHeight()
		if nextEndPos.y > 0 and mapH > nextEndPos.y and #self.posList < 10 then
			self:rayCastBack(nextEndPos, cc.p(beginPos.x, nextEndPos.y * 2 - beginPos.y))
		end
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
	elseif posy < 0 then
		posy = 0
		posx = beginPos.x - (beginPos.y - posy) * sub.x / sub.y
	end
	return cc.p(posx, posy)
end
function Com_map:rayCastBubble(beginPos, endPos)
	local oldTime = SoraDGetSocketTime()
	local count = 0
	local mapH = self:getHeight()
	local x1, y1 = endPos.x, endPos.y
	local x2, y2 = beginPos.x, beginPos.y
	local r = self.objSize.width / 2
	local obj, objPos, cx, cy, interX, interY
	local bubbleMgr = self.bubbleMgr
	local objSize = self.objSize
	local calculateIntersectionPoint = SoraDCalculateIntersectionPoint
	local _x
	for y = MAX_Y, 1, -1 do
		for x = 1, MAX_X do
			if x1 < x2 then
				_x = MAX_X - x + 1
			else
				_x = x
			end
			obj = bubbleMgr[y] and bubbleMgr[y][_x]
			if obj then
				count = count + 1
				objPos = obj:getPosition()
				cx, cy = objPos.x + objSize.width / 2, objPos.y + objSize.height / 2
				interX, interY = calculateIntersectionPoint(x1, y1, x2, y2, cx, cy, r)
				if interX and interY then
					return cc.p(interX, interY)
				end
			end
		end
	end
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
		local colorType = self.myBubble:getColorType()
		local needCount = self.checkTickSelected and 10 or 1
		self:reqShoot(0, 0, colorType, needCount)
		self:doDieingAnimation(newPos)
		return
	end
	self.myBubble:setDir(dir)
	self.myBubble:setPosition(newPos)
	local centerPos = cc.p(newPos.x + self.objSize.width / 2, newPos.y + self.objSize.height / 2)
	local tilePos = self:mapPos2tilePos(centerPos)
	local posList = self:getBubbleAroundPos(tilePos)
	local min_distance, min_obj
	for __, pos in ipairs(posList) do
		local obj = self.bubbleMgr[pos.y] and self.bubbleMgr[pos.y][pos.x]
		if obj then
			local distance = cc.pDistanceSQ(centerPos, self:tilePos2centerMapPos(pos))
			if distance <= self.objSize.width * self.objSize.width and (not min_distance or min_distance > distance) then
				min_distance = distance
				min_obj = obj
			end
		end
	end
	if min_obj then
		if min_obj:checkSameColor(self.myBubble:getColorType()) then
			self:checkBubble(min_obj)
		end
		local tilePos = min_obj:getTilePos()
		local colorType = self.myBubble:getColorType()
		local needCount = self.checkTickSelected and 10 or 1
		self:reqShoot(tilePos.x, tilePos.y, colorType, needCount)
		self:doDieingAnimation(newPos)
	end
end
function Com_map:doDieingAnimation(newPos)
	local obj = self:createBubbleSingle()
	obj:setPosition(newPos)
	local centerPos = cc.p(newPos.x + self.objSize.width / 2, newPos.y + self.objSize.height / 2)
	local tilePos = self:mapPos2tilePos(centerPos)
	_ENV = nil
	;(nil).x = tilePos.x
	;(nil).y = tilePos.y
	;(nil).colorType = self.myBubble:getColorType()
	obj:initData(nil)
	obj:setIsSelect(true)
	obj:doDieingAnimation()
	self:resetMyBubble()
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
	self.showBubble:setVisible(true)
end
function Com_map:resetBubbleSelect(...)
	self:walkMgr(function(obj)
		obj:reset()
	end)
end
function Com_map:resetBubbleColor(...)
	self:walkMgr(function(obj)
		local color = math.random(1, COLOR_MAX)
		obj:setColorType(color)
	end)
end
function Com_map:recoverMap(...)
	self:walkMgr(function(obj)
		obj:removeFromParent()
	end)
	self:initMapData(self.mapData)
end
function Com_map:checkBubble(curSelectObj)
	self:checkSameColorBubble(curSelectObj)
	self:checkDropBubble(curSelectObj)
	self:clearDieBubble()
end
function Com_map:clearDieBubble(...)
	local isGameOver = true
	self:walkMgr(function(obj)
		if obj:getIsSelect() or not obj:getIsConnect() then
			local tilePos = obj:getTilePos()
			self.bubbleMgr[tilePos.y][tilePos.x] = nil
			obj:doDieingAnimation()
		else
		end
	end)
	self.isGameOver = isGameOver
end
function Com_map:updateMapData(...)
	if self.isGameOver then
		self.isGameOver = false
		self.tranIndex = 1
		local mapData = self:getBubbleMap()
		self:initMapData(mapData)
	end
end
function Com_map:setCheckTickSelected(selected)
	self.checkTickSelected = selected
	if self.mv_pao01 then
		self.mv_pao01:setVisible(selected)
	end
	if self.mv_pao01 then
		self.mv_pao02:setVisible(selected)
	end
end
function Com_map:checkItemEnough(...)
	local itemCount = backpackCtrl:getItemCount(self.itemID)
	local needCount = self.checkTickSelected and 10 or 1
	return itemCount >= needCount
end
function Com_map:initActivityID(activityID)
	self.activityID = activityID
	if self.activityID ~= gActivityTimeActivityID.NORMAL_ACTIVITY_9001638 then
		self.itemID = activityCommonBubbleCtrl:getItemID(self.activityID)
		self.showBubble:initActivityID(self.activityID)
		self.myBubble:initActivityID(self.activityID)
		for i, obj in ipairs(self.bubbleList) do
			obj:initActivityID(self.activityID)
		end
		local mapData = activityCommonBubbleCtrl:getBubbleMap(self.activityID)
		self:initMapData(mapData)
	end
end
function Com_map:getBubbleMap(...)
	return activityCommonBubbleCtrl:getBubbleMap(self.activityID)
end
function Com_map:reqShoot(...)
	return activityCommonBubbleCtrl:reqShoot(self.activityID, ...)
end
function Com_map:gameGuide_getTarget(itemName, parameters)
	print("==Com_map:gameGuide_getTarget==", itemName, parameters)
	if itemName == "Button_right" then
		local _fields = fguiHelper.get_fields(self.fields.Com_battery)
		return _fields.Button_right
	end
	return self.fields[itemName]
end
return Com_map

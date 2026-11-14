local baseComponent = require("fgui.base.baseComponent")
local Com_9001680_game = fgui.extension_class(fgui.GComponent, baseComponent)
local activity_9001680_Ctrl = SoraDGetCtrl("activity_9001680_Ctrl")
local constantRead = include("constantRead")
local publicRead = include("publicRead")
local guideCtrl = SoraDGetCtrl("guideCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
fgui.register_extension("ui://Activity_9001680/Com_9001680_game", Com_9001680_game)
local activity_9001680_Read = include("activity_9001680_Read")
local MAP_OBJ_TYPE = activity_9001680_Read.MAP_OBJ_TYPE
local MAP_OBJ = activity_9001680_Read.MAP_OBJ
local cellW = 122
local cellH = 116
local sYFix = 200
local mapSizeW = 300
local mapSizeH = 300
local debugPos = false
_UPVALUE2_, _UPVALUE13_ = nil, nil
_UPVALUE2_, (nil)[1] = 0, 0
_UPVALUE2_, (nil)[2] = 0, -2
_UPVALUE2_, (0)[1] = -1, -1
_UPVALUE2_, (0)[2] = -1, -1
_UPVALUE2_, (-1)[1] = 0, 0
_UPVALUE2_, (-1)[2] = 0, -1
_UPVALUE2_, (0)[1] = 1, 1
_UPVALUE2_, (0)[2] = 1, -1
_UPVALUE2_, (1)[1] = -2, -2
_UPVALUE2_, (1)[2] = -2, 0
_UPVALUE2_, (-2)[1] = -1, -1
_UPVALUE2_, (-2)[2] = -1, 0
_UPVALUE2_, (-1)[1] = 0, 0
_UPVALUE2_, (-1)[2] = 0, 0
_UPVALUE2_, (0)[1] = 1, 1
_UPVALUE2_, (0)[2] = 1, 0
_UPVALUE2_, (1)[1] = 2, 2
_UPVALUE2_, (1)[2] = 2, 0
_UPVALUE2_, (2)[1] = -1, -1
_UPVALUE2_, (2)[2] = -1, 1
_UPVALUE2_, (-1)[1] = 0, 0
_UPVALUE2_, (-1)[2] = 0, 1
_UPVALUE2_, (0)[1] = 1, 1
_UPVALUE2_, (0)[2] = 1, 1
;(1)[1] = 0
;(1)[2] = 2
;(nil)[1] = nil
;(nil)[2] = 0
;(nil)[3] = -1
;(nil)[4] = 0
;(nil)[5] = 1
;(nil)[6] = -2
;(nil)[7] = -1
;(nil)[8] = 0
;(nil)[9] = 1
;(nil)[10] = 2
;(nil)[11] = -1
;(nil)[12] = 0
local (nil)[13], NEIGHBORS_13 = 1, nil
function Com_9001680_game:onInit()
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001680
	self.itemID = 1698
	self:setZoomEnable(true)
	self:setMinScale(0.55)
	self:setMaxScale(1.0)
	self.scrollPane = self:getScrollPane()
	self.scrollPane:AddEventListener1(fgui.UIEventType.Scroll, handler(self, self.onScroll))
	self.scrollPane:AddEventListener1(fgui.UIEventType.onScrollViewDidZoom, handler(self, self.onZoomScale))
	fguiHelper.registMouseEvent(self)
	_UPVALUE2_ = fgui.UIEventType.onScrollViewDidZoom
	fgui.UIEventType.onScrollViewDidZoom[1] = 150
	fgui.UIEventType.onScrollViewDidZoom[2] = 1
	self.starPosArray = constantRead.getConstValueArray("GOLDMINER_INITIAL_ROAD", fgui.UIEventType.onScrollViewDidZoom)
	self.fields.selectFlag:setSortingOrder(1000)
	self.fields.selectPos:setSortingOrder(1001)
	self.objIds, _ENV, self.cells, _ENV, self.otherPool, _ENV, self.cellPool, _ENV = self.fields.selectPos.setSortingOrder, self.fields.selectPos.setSortingOrder, self.fields.selectPos.setSortingOrder, self.fields.selectPos.setSortingOrder, self.fields.selectPos.setSortingOrder, self.fields.selectPos.setSortingOrder, self.fields.selectPos.setSortingOrder, self.fields.selectPos.setSortingOrder
end
function Com_9001680_game:onShow()
	self.activityBeginTime = activityShowCtrl:getBeginTimeSecond(self.activityID)
	self.isOnShow = false
	self.viewSize = self:getSize()
	self.posY = self:getY() - self.viewSize.height / 2
	self.showRect = cc.rect(0, 0, self.viewSize.width, self.viewSize.height)
	self.maxContentSize = cc.size(mapSizeW * cellW, mapSizeH * cellH + sYFix)
	self.fields.BgSize:setSize(self.maxContentSize.width, self.maxContentSize.height)
	local saveData = self:getRecordData()
	if saveData then
		self.zoomScale = saveData.s
		self:setZoomScale(self.zoomScale)
		self.scrollPane:setContentOffset(cc.p(saveData.x, saveData.y), false)
	else
		self.zoomScale = 1.0
		self:setZoomScale(self.zoomScale)
		self:gotoCell(self.starPosArray[#self.starPosArray / 2], nil, true, false, false)
	end
	self.isOnShow = true
	self.isPicking = false
	self:setSelectedCell()
	self:updateView()
	if self.visibleCellCount == 0 then
		self:gotoCell(self.starPosArray[#self.starPosArray / 2], nil, true, false, false)
	end
	guideCtrl:updateGuideModule(gGuideModule.GOLD_MINER)
end
function Com_9001680_game:debugSwitch()
	self:onScroll()
end
function Com_9001680_game:onZoomScale()
	local zoomScale = self:getZoomScale()
	if self.zoomScale == self:getZoomScale() then
		return
	end
	self.zoomScale = zoomScale
end
function Com_9001680_game:onScroll()
	if not self.isOnShow then
		print("Com_9001680_game:onScroll", not self.isOnShow)
		return
	end
	local scrollPosX = self.scrollPane:getPosX()
	local scrollPosY = self.scrollPane:getPosY()
	local zoomScale = self:getZoomScale()
	local rectX = scrollPosX / zoomScale
	local rectY = scrollPosY / zoomScale - sYFix
	local rectW = self.viewSize.width / zoomScale
	local rectH = self.viewSize.height / zoomScale
	local sX = math.floor(rectX / cellW) + 1
	local sY = math.max(0, math.floor(rectY / cellH)) + 1
	local countX = math.ceil(rectW / cellW)
	local countY = math.ceil(rectH / cellH)
	local countXFix = (sX + countX) * cellW - math.min(rectX + rectW, self.maxContentSize.width)
	local countYFix = (sY + countY) * cellH - math.min(rectY + rectH, self.maxContentSize.height)
	countX = countX - math.floor(countXFix / cellW)
	countY = countY - math.floor(countYFix / cellH)
	local cells = self.cells
	local objIds = self.objIds
	local mapData = self.mapData
	local getCell = self.getCell
	local putCellToPool = self.putCellToPool
	local cellPool = self.cellPool
	local getCellFromPool = self.getCellFromPool
	local getCellObjId = self.getCellObjId
	local cellToPos = self.cellToPos
	local visibleCellCount = 0
	if self.lastSX ~= nil then
		local lastSX = self.lastSX
		local lastSY = self.lastSY
		local lastCountX = self.lastCountX
		local lastCountY = self.lastCountY
		for i = lastSX, sX - 1 do
			for j = lastSY, lastSY + lastCountY do
				local cell = getCell(self, cells, i, j)
				if cell ~= nil then
					putCellToPool(self, cellPool, cell, true)
					cells[i][j] = nil
				end
			end
		end
		for i = sX + countX + 1, lastSX + lastCountX do
			for j = lastSY, lastSY + lastCountY do
				local cell = getCell(self, cells, i, j)
				if cell ~= nil then
					putCellToPool(self, cellPool, cell, true)
					cells[i][j] = nil
				end
			end
		end
		for i = lastSY, sY - 1 do
			for j = lastSX, lastSX + lastCountX do
				local cell = getCell(self, cells, j, i)
				if cell ~= nil then
					putCellToPool(self, cellPool, cell, true)
					cells[j][i] = nil
				end
			end
		end
		for i = sY + countY + 1, lastSY + lastCountY do
			for j = lastSX, lastSX + lastCountX do
				local cell = getCell(self, cells, j, i)
				if cell ~= nil then
					putCellToPool(self, cellPool, cell, true)
					cells[j][i] = nil
				end
			end
		end
	end
	self.isBossInSight = false
	self.isMonsterInSight = false
	for i = sX, sX + countX do
		for j = sY, sY + countY do
			local cell = getCell(self, cells, i, j)
			local objId = getCellObjId(self, i, j, mapData, objIds)
			if objId == MAP_OBJ.UNKNOWN and not debugPos then
				if cell ~= nil then
					putCellToPool(self, cellPool, cell, true)
					cells[i][j] = nil
				end
			elseif objId == MAP_OBJ.TREASURE and not self:canShow(i, j) then
				if cell ~= nil then
					putCellToPool(self, cellPool, cell, true)
					cells[i][j] = nil
				end
			else
				if cell == nil then
					cell = getCellFromPool(self, cellPool)
					local posX, posY = cellToPos(self, i, j)
					cell:setXY(posX, posY)
					if not cells[i] then
						_ENV = cells[i]
					end
					cells[i] = cells[i]
					cells[i][j] = cell
				end
				visibleCellCount = visibleCellCount + 1
				cell:debugPos(debugPos, i, j, objId)
				cell:setData(i, j, objId)
				if objId == MAP_OBJ.BOSS and not self.isBossInSight then
					self.isBossInSight = true
				elseif objId == MAP_OBJ.MONSTER and not self.isMonsterInSight then
					self.isMonsterInSight = true
				end
			end
		end
	end
	self.lastSX = sX
	self.lastSY = sY
	self.lastCountX = countX
	self.lastCountY = countY
	self.centerX = sX + countX / 2
	self.centerY = sY + countY / 2
	self.showRect.x = rectX
	self.showRect.y = rectY
	self.showRect.width = rectW
	self.showRect.height = rectH
	self.visibleCellCount = visibleCellCount
	self:updateBossAndMonster()
end
function Com_9001680_game:setBossAndMonsterHead(bossHead, monsterHead)
	self.bossHead = bossHead
	self.bossHead:addClickEventListener(handler(self, self.onHeadClick), 1)
	self.monsterHead = monsterHead
	self.monsterHead:addClickEventListener(handler(self, self.onHeadClick), 2)
end
function Com_9001680_game:onHeadClick(sender, headType)
	SoraDPlaySound()
	if headType == 1 then
		print("点击了boss")
		local bossPos = activity_9001680_Ctrl:getBossPos()
		dump(bossPos, "bossPos")
		self:gotoCell(bossPos[1], bossPos[2], true, true, false)
	elseif headType == 2 and self.minMonsterPos then
		print("点击了怪物")
		self:gotoCell(self.minMonsterPos[1], self.minMonsterPos[2], true, true, false)
	end
end
function Com_9001680_game:pointToRectDistance(pos, rect)
	local nearestX, nearestY
	if pos.x < rect.x then
		nearestX = rect.x
	elseif pos.x > rect.x + rect.width then
		nearestX = rect.x + rect.width
	else
		nearestX = pos.x
	end
	if pos.y < rect.y then
		nearestY = rect.y
	elseif pos.y > rect.y + rect.height then
		nearestY = rect.y + rect.height
	else
		nearestY = pos.y
	end
	local dx = pos.x - nearestX
	local dy = pos.y - nearestY
	return dx * dx + dy * dy
end
function Com_9001680_game:updateBossAndMonster()
	local bossPos = activity_9001680_Ctrl:getBossPos()
	local monsterPosList = activity_9001680_Ctrl:getMonsterPosList()
	local isBossHeadVisible = not self.isBossInSight and bossPos ~= nil
	local isMonsterHeadVisible = not self.isMonsterInSight and 0 < #monsterPosList
	self.bossHead:setVisible(isBossHeadVisible)
	self.monsterHead:setVisible(isMonsterHeadVisible)
	if isBossHeadVisible or isMonsterHeadVisible then
		local zoomScale = self:getZoomScale()
		local fixW = 70 / zoomScale
		local curRect = cc.rect(self.showRect.x + fixW, self.showRect.y + fixW, self.showRect.width - fixW * 2, self.showRect.height - fixW * 2)
		local centerPos = cc.p(curRect.x + curRect.width / 2, curRect.y + curRect.height / 2)
		if isBossHeadVisible then
			local tmpBossPos = cc.p(bossPos[1] * cellW, bossPos[2] * cellH)
			local isIntersect, intersectPointArray = SoraDLineIntersectRect(tmpBossPos, centerPos, curRect)
			if isIntersect and 0 < #intersectPointArray then
				local intersectPoint = intersectPointArray[1]
				intersectPoint.y = intersectPoint.y + self.posY
				intersectPoint.x = intersectPoint.x
				local rotation = SoraDGetAngleByPos(intersectPoint, tmpBossPos) - 90
				intersectPoint.x = (intersectPoint.x - self.showRect.x) * zoomScale
				intersectPoint.y = (intersectPoint.y - self.showRect.y) * zoomScale
				self.bossHead:setPosition(intersectPoint)
				self.bossHead:setRotation(rotation)
			else
				self.bossHead:setVisible(false)
			end
		end
		if isMonsterHeadVisible then
			local minDistance, minDistancePos
			for _, pos in ipairs(monsterPosList) do
				local distance = self:pointToRectDistance(cc.p(pos[1] * cellW, pos[2] * cellH), self.showRect)
				if minDistance == nil or minDistance > distance then
					minDistance = distance
					minDistancePos = pos
				end
			end
			local tmpMonsterPos = cc.p(minDistancePos[1] * cellW, minDistancePos[2] * cellH)
			local isIntersect, intersectPointArray = SoraDLineIntersectRect(tmpMonsterPos, centerPos, curRect)
			if isIntersect and 0 < #intersectPointArray then
				local intersectPoint = intersectPointArray[1]
				intersectPoint.y = intersectPoint.y + self.posY
				intersectPoint.x = intersectPoint.x
				local rotation = SoraDGetAngleByPos(intersectPoint, tmpMonsterPos) - 90
				intersectPoint.x = (intersectPoint.x - self.showRect.x) * zoomScale
				intersectPoint.y = (intersectPoint.y - self.showRect.y) * zoomScale
				self.monsterHead:setPosition(intersectPoint)
				self.monsterHead:setRotation(rotation)
				self.minMonsterPos = minDistancePos
			else
				self.monsterHead:setVisible(false)
			end
		end
	end
end
function Com_9001680_game:pickResult(msgData, keepMap)
	MAP_OBJ_TYPE = nil
	;(nil)[1] = msgData
	;(nil)[2] = keepMap
	dump(nil, "Com_9001680_game:pickResult")
	if msgData == nil and not keepMap then
		self:updateMap()
		return
	end
	SoraDShowLoading(nil, nil, nil, true, 2)
	local reward = msgData.reward
	local param = msgData.param
	local err = msgData.err
	local objId = param.objId
	local cellX = param.x
	local cellY = param.y
	local explode = param.explode
	local objCfg = activity_9001680_Read.getElement(objId)
	local cell = self:getCell(nil, cellX, cellY)
	local normalPick = function(callback)
		local callback = callback and callback or function()
			self:showPickEndCallback(cellX, cellY, reward, keepMap)
		end
		if param.explode then
			self:playBoom(cellX, cellY, callback)
		else
			self:playPick(cellX, cellY, callback)
		end
	end
	if objCfg.type == MAP_OBJ_TYPE.SOIL then
		normalPick()
	elseif objCfg.type == MAP_OBJ_TYPE.ROCK then
		normalPick()
	elseif objCfg.type == MAP_OBJ_TYPE.MONSTER then
		_ENV = nil
		;(nil).x = cellX
		;(nil).y = cellY
		;(nil).objCfg = objCfg
		;(nil).rewards = reward
		;(nil).isWin = err == gErrDef.Err_None
		uiManager:show("Activity_9001680_BattleResult", nil)
		self:showPickEndCallback(cellX, cellY, nil, keepMap)
	elseif objCfg.type == MAP_OBJ_TYPE.BOSS then
		_ENV = cellY
		cellY.x = cellX
		cellY.y = cellY
		cellY.objCfg = objCfg
		cellY.rewards = reward
		cellY.isWin = err == gErrDef.Err_None
		uiManager:show("Activity_9001680_BattleResult", cellY)
		self:showPickEndCallback(cellX, cellY, nil, keepMap)
	elseif objCfg.type == MAP_OBJ_TYPE.TREASURE_CLEW then
		normalPick(function()
			_ENV = nil
			;(nil).x = cellX
			;(nil).y = cellY
			;(nil).objCfg = objCfg
			uiManager:show("Activity_9001680_Tip", nil)
			self:showPickEndCallback(cellX, cellY, reward, keepMap)
		end)
	elseif objCfg.type == MAP_OBJ_TYPE.TREASURE then
		normalPick()
	elseif objCfg.type == MAP_OBJ_TYPE.BOX then
		normalPick()
	elseif objCfg.type == MAP_OBJ_TYPE.ORE then
		normalPick()
	elseif objCfg.type == MAP_OBJ_TYPE.GEM then
		if not explode and cell then
			cell:updateEffect()
			SoraDCloseLoading()
		else
			normalPick()
		end
	else
		SoraDCloseLoading()
	end
	local needPickNum = objCfg.minepick
	if not explode and needPickNum == 1 then
		needPickNum = objCfg.minepick * (self.monsterCountInClick + 1)
		if 1 < needPickNum then
			if self.animShaker then
				self.animShaker:stop()
			end
			local AnimShaker = include("AnimShaker")
			_ENV = keepMap
			keepMap.diff_max = 10
			keepMap.interval = 0.03
			local animShaker = AnimShaker.new(self, 0.1, keepMap)
			self.animShaker = animShaker
			animShaker:run()
		end
	end
end
function Com_9001680_game:showPickEndCallback(x, y, reward, keepMap)
	self:setSelectedCell(x, y)
	SoraDCloseLoading()
	if reward then
		SoraDMailGainItems(reward, true)
	end
	print("Com_9001680_game:showPickEndCallback", keepMap)
	if keepMap then
		self:updateBossAndMonster()
		return
	end
	self:updateMap()
end
function Com_9001680_game:updateView(data)
	if data == nil then
		self:updateMap()
		return
	end
	if data.msgType == "pick" then
		self:pickResult(data.msgData, data.keepMap)
		return
	end
	if data.keepMap then
		self:updateBossAndMonster()
		return
	end
	if data.msgType == "reset" then
		self:gotoCell(self.starPosArray[#self.starPosArray / 2], nil, true, false, false)
		self:setSelectedCell()
		self:recordLastPos()
	end
	self:updateMap()
end
function Com_9001680_game:updateMap()
	self.objIds, activity_9001680_Ctrl = nil, nil
	self.mapData = activity_9001680_Ctrl:getMapData()
	self.itemNum = activity_9001680_Ctrl:getItemCount()
	self:onScroll()
end
function Com_9001680_game:isNearRoad(x, y)
	local objId = self:getCellObjId(x, y - 1)
	if objId == MAP_OBJ.NONE then
		return true
	end
	objId = self:getCellObjId(x, y + 1)
	if objId == MAP_OBJ.NONE then
		return true
	end
	objId = self:getCellObjId(x - 1, y)
	if objId == MAP_OBJ.NONE then
		return true
	end
	objId = self:getCellObjId(x + 1, y)
	if objId == MAP_OBJ.NONE then
		return true
	end
	return false
end
function Com_9001680_game:canShow(x, y)
	for _, v in ipairs(NEIGHBORS_13) do
		local objID = self:getCellObjId(x + v[1], y + v[2])
		if self:getCellObjId(x + v[1], y + v[2]) == MAP_OBJ.NONE then
			return true
		end
	end
end
function Com_9001680_game:setPicking()
	self.isPicking = true
	local seq = ffa.seq(ffa.delay(0.7), ffa.callFunc(function()
		self.isPicking = false
	end))
	seq:setTag(990)
	self:stopActionByTag(990)
	self:runAction(seq)
end
function Com_9001680_game:onCellClick(cell, cellX, cellY, objId)
	if objId == MAP_OBJ.UNKNOW then
		return
	end
	self:recordLastPos()
	if objId == MAP_OBJ.NONE then
		self:setSelectedCell(cellX, cellY)
		return
	end
	self:setSelectedCell()
	local isNearRoad = self:isNearRoad(cellX, cellY)
	if not isNearRoad then
		self:setSelectedCell(cellX, cellY)
		return
	end
	local objCfg = activity_9001680_Read.getElement(objId)
	if objCfg == nil then
		print("error objId", objId)
		self:setSelectedCell(cellX, cellY)
		return
	end
	self.monsterCountInClick = activity_9001680_Ctrl:getMonsterCount()
	local needPickNum = objCfg.minepick
	if needPickNum == 1 and objCfg.type ~= MAP_OBJ_TYPE.GEM then
		needPickNum = objCfg.minepick * (self.monsterCountInClick + 1)
		if needPickNum > activity_9001680_Ctrl:getItemCount() then
			MAP_OBJ = nil
			;(nil).item = publicRead.getName(self.itemID)
			SoraDShowMsgTip(i18n("Glory_text_19", nil))
			self:setSelectedCell(cellX, cellY)
			return
		end
	end
	if self.isPicking then
		return
	end
	if objCfg.type == MAP_OBJ_TYPE.SOIL then
		self:setPicking()
		activity_9001680_Ctrl:reqGoldMinerPick(objId, cellX, cellY)
	elseif objCfg.type == MAP_OBJ_TYPE.ROCK then
		MAP_OBJ = cellX
		cellX.x = cellX
		cellX.y = cellY
		cellX.objCfg = objCfg
		uiManager:show("Activity_9001680_Tip", cellX)
		self:setSelectedCell(cellX, cellY)
	elseif objCfg.type == MAP_OBJ_TYPE.MONSTER then
		MAP_OBJ = cellY
		cellY.x = cellX
		cellY.y = cellY
		cellY.objCfg = objCfg
		uiManager:show("Activity_9001680_Monster", cellY)
		self:setSelectedCell(cellX, cellY)
	elseif objCfg.type == MAP_OBJ_TYPE.BOSS then
		MAP_OBJ = cellY
		cellY.x = cellX
		cellY.y = cellY
		cellY.objCfg = objCfg
		uiManager:show("Activity_9001680_Monster", cellY)
		self:setSelectedCell(cellX, cellY)
	elseif objCfg.type == MAP_OBJ_TYPE.TREASURE_CLEW then
		self:setPicking()
		activity_9001680_Ctrl:reqGoldMinerPick(objId, cellX, cellY)
	elseif objCfg.type == MAP_OBJ_TYPE.TREASURE then
		self:setPicking()
		activity_9001680_Ctrl:reqGoldMinerPick(objId, cellX, cellY)
	elseif objCfg.type == MAP_OBJ_TYPE.BOX then
		self:setPicking()
		activity_9001680_Ctrl:reqGoldMinerPick(objId, cellX, cellY)
	elseif objCfg.type == MAP_OBJ_TYPE.ORE then
		self:setPicking()
		activity_9001680_Ctrl:reqGoldMinerPick(objId, cellX, cellY)
	elseif objCfg.type == MAP_OBJ_TYPE.GEM then
		self:setSelectedCell(cellX, cellY)
		MAP_OBJ = cellY
		cellY.x = cellX
		cellY.y = cellY
		cellY.objCfg = objCfg
		uiManager:show("Activity_9001680_Tip", cellY)
	end
end
function Com_9001680_game:setSelectedCell(x, y)
	if x == nil then
		self.fields.selectFlag:setVisible(false)
		self.fields.selectPos:setVisible(false)
		return
	end
	self.fields.selectFlag:setVisible(true)
	local posX, posY = self:cellToPos(x, y, true)
	self.fields.selectFlag:setPosition(posX, posY)
	self.fields.selectPos:setVisible(true)
	self.fields.selectPos:setString(string.format("X:%d Y:%d", x, y))
end
function Com_9001680_game:playBoom(x, y, callback)
	local boomAni = self:getComFromPool("Ani_boom", 1003)
	boomAni:stopAllActions()
	boomAni:setAllFrameName("activity_9001680_boom_%02d.png", 1)
	local posX, posY = self:cellToPos(x, y, true)
	boomAni:setAnchorPoint(cc.p(0.5, 0.5))
	boomAni:setPosition(posX, posY)
	boomAni:setScale(1.8)
	boomAni:setPlaySettings(0, -1, 1, -1, function()
		self:putComToPool(boomAni, "Ani_boom")
	end)
	boomAni:runAction(ffa.seq(ffa.delay(0.1), ffa.callFunc(callback)))
end
function Com_9001680_game:playPick(x, y, callback)
	local Com_9001680_PickAni = self:getComFromPool("Com_9001680_PickAni", 1002)
	local pickAni = Com_9001680_PickAni:getTransition("t0")
	local posX, posY = self:cellToPos(x, y, true)
	Com_9001680_PickAni:setPosition(posX, posY)
	pickAni:play(function()
		self:putComToPool(Com_9001680_PickAni, "Com_9001680_PickAni")
	end)
	if callback then
		local action = ffa.seq(ffa.delay(0.6), ffa.callFunc(callback))
		Com_9001680_PickAni:runAction(action)
	end
end
function Com_9001680_game:gotoCell(x, y, iscx, iscy, isAni)
	local zoomScale = self:getZoomScale()
	local posX = iscx and (x * cellW - cellW / 2) * zoomScale - self.viewSize.width / 2 or x * cellW * zoomScale
	local posY = 0
	if y then
		y = y - 1
		posY = iscy and (y * cellH - cellH / 2) * zoomScale + sYFix - self.viewSize.height / 2 or y * cellH * zoomScale + sYFix
	end
	self.scrollPane:setContentOffset(cc.p(posX, posY), isAni)
end
function Com_9001680_game:cellToPos(x, y, isCenter)
	if isCenter then
		return (x - 0.5) * cellW, (y - 0.5) * cellH + sYFix
	else
		return (x - 1) * cellW, (y - 1) * cellH + sYFix
	end
end
function Com_9001680_game:getCellObjId(x, y, mapData, objIds)
	mapData = mapData or self.mapData
	objIds = objIds or self.objIds
	local objId = objIds[x] and objIds[x][y] or nil
	if objId == nil then
		objId = activity_9001680_Read.getMap(mapData, x, y)
		if not objIds[x] then
			activity_9001680_Read = objIds[x]
		end
		objIds[x] = objIds[x]
		objIds[x][y] = objId
	end
	return objId
end
function Com_9001680_game:getCell(cells, x, y)
	cells = cells or self.cells
	if cells[x] then
		return cells[x][y]
	end
end
function Com_9001680_game:getCellFromPool(cellPool)
	local cell = cellPool[1]
	if cell ~= nil then
		table.remove(cellPool, 1)
		if cell.needShow then
			cell.needShow = false
			cell:setVisible(true)
		end
		return cell
	end
	cell = fgui.UIPackage:createObject("Activity_9001680", "Com_9001680_Cell")
	cell:setClickCallback(handler(self, self.onCellClick))
	cell:setGameView(self)
	self:addChild(cell)
	return cell
end
function Com_9001680_game:putCellToPool(cellPool, cell, needHide)
	if needHide then
		cell:setVisible(false)
		cell:putAllEffectToPool()
		cell.needShow = true
	end
	table.insert(cellPool, cell)
end
function Com_9001680_game:getComFromPool(compName, sortOrder)
	local otherPool = self.otherPool
	local curPool = otherPool[compName]
	local comp = curPool and curPool[1] or nil
	if comp ~= nil then
		table.remove(curPool, 1)
		comp:setVisible(true)
		return comp
	end
	comp = fgui.UIPackage:createObject("Activity_9001680", compName)
	if sortOrder then
		comp:setSortingOrder(sortOrder)
	end
	self:addChild(comp)
	return comp
end
function Com_9001680_game:putComToPool(comp, compName)
	local otherPool = self.otherPool
	if comp.onPutToPool then
		comp:onPutToPool()
	else
		comp:setVisible(false)
	end
	if not otherPool[compName] then
		_ENV = otherPool[compName]
	end
	otherPool[compName] = otherPool[compName]
	table.insert(otherPool[compName], comp)
end
function Com_9001680_game:recordLastPos()
	local pos = self.scrollPane:getPosition()
	_ENV = self.scrollPane
	self.scrollPane.t = self.activityBeginTime
	self.scrollPane.x = pos.x
	self.scrollPane.y = pos.y
	local self.scrollPane.s, saveData = self.zoomScale, self.scrollPane
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:Com_9001680_game:recordLastPos~table", saveData, nil)
end
function Com_9001680_game:getRecordData()
	_ENV = nil
	;(nil).byUID = true
	local saveData = SoraDConfigGet("Game:Com_9001680_game:recordLastPos~table", nil)
	if saveData and saveData.t == self.activityBeginTime then
		return saveData
	end
	return nil
end
return Com_9001680_game

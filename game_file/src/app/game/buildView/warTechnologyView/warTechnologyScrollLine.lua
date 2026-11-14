local gametop = gModuleMgr.getObject("gametop")
local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
local warTechnologyScrollLine = class("warTechnologyScrollLine", function(target)
	if target == nil then
		return display.newNode()
	end
	return target
end)
function warTechnologyScrollLine:ctor()
	self:setNodeEventEnabled(true)
	self.tableLightLine, _UPVALUE0_, self.tableData, _UPVALUE0_ = self.setNodeEventEnabled, self.setNodeEventEnabled, self.setNodeEventEnabled, self.setNodeEventEnabled
	self.lineLight = false
	self:setNodeEventEnabled(true)
end
function warTechnologyScrollLine:onEnter()
	SoraDAddMessage(self, "MESSAGE_UPDATE_TECHNOLOGY", function(...)
		if self.updateLine then
			self:updateLine()
		end
	end)
end
function warTechnologyScrollLine:onExit()
	SoraDRemoveMessageByTarget(self)
	SoraDManagerRemoveTimerByTarget(self)
end
function warTechnologyScrollLine:onExit()
	SoraDRemoveMessageByTarget(self)
	SoraDManagerRemoveTimerByTarget(self)
end
local CENTER_Y = 0.45
local OFFSET_Y = 50
local OFFSET_TEXT = -50
local BORDER_WIDTH = 3
local COLOR_GAY = cc.c4f(0.34, 0.34, 0.34, 1.0)
local COLOR_HIGHT = cc.c4f(0.96, 0.67, 0.0, 1.0)
function warTechnologyScrollLine:addLine(posX, posY, lineLight, frame_line, frame_line_hl)
	if tolua.isnull(self) then
		return
	end
	local x = self:getPositionX()
	local y = self:getPositionY()
	local resourcePoints
	if self.beeLine then
		OFFSET_Y, OFFSET_Y = nil, self.beeLine
		OFFSET_Y, (nil)[1] = x + posX, x + posX
		OFFSET_Y, (nil)[2] = x + posX, y + posY
		;(x + posX)[1] = x
		;(x + posX)[2] = y
		resourcePoints, self.beeLine[1] = self.beeLine
		resourcePoints, self.beeLine[2] = self.beeLine, x + posX
	else
		local centerY = posY * CENTER_Y
		OFFSET_Y, COLOR_HIGHT = x + posX
		OFFSET_Y, (x + posX)[1] = x + posX, x + posX
		OFFSET_Y, (x + posX)[2] = x + posX, y + posY - OFFSET_Y - OFFSET_TEXT
		OFFSET_Y, (x + posX)[1] = x + posX, x + posX
		OFFSET_Y, (x + posX)[2] = x + posX, y + centerY
		OFFSET_Y, (x + posX)[1] = x, x
		OFFSET_Y, (x + posX)[2] = x, y + centerY
		x[1] = x
		x[2] = y + OFFSET_Y
		resourcePoints, (nil)[1] = nil, x + posX
		resourcePoints, (nil)[2] = nil, x + posX
		resourcePoints, (nil)[3] = nil, x + posX
		resourcePoints, (nil)[4] = nil, x
	end
	local createGayLine = function(pos1, pos2)
		local color
		if lineLight then
			color = COLOR_HIGHT
			frame_line_hl:drawSegment(cc.p(pos1[1], pos1[2]), cc.p(pos2[1], pos2[2]), BORDER_WIDTH / 2, color)
		else
			color = COLOR_GAY
			frame_line:drawSegment(cc.p(pos1[1], pos1[2]), cc.p(pos2[1], pos2[2]), BORDER_WIDTH / 2, color)
		end
	end
	if 2 <= #resourcePoints then
		for i = 2, #resourcePoints do
			createGayLine(resourcePoints[i - 1], resourcePoints[i])
		end
	end
end
function warTechnologyScrollLine:addHightlight(posX, posY, actionTime)
	local resourcePoints
	if self.beeLine then
		OFFSET_TEXT, OFFSET_TEXT = nil, self.beeLine
		OFFSET_TEXT, (nil)[1] = posX, posX
		OFFSET_TEXT, (nil)[2] = posX, posY
		posX[1] = 0
		posX[2] = 0
		resourcePoints, self.beeLine[1] = self.beeLine
		resourcePoints, self.beeLine[2] = self.beeLine, posX
	else
		local centerY = posY * CENTER_Y
		OFFSET_TEXT, COLOR_HIGHT = posX
		OFFSET_TEXT, posX[1] = posX, posX
		OFFSET_TEXT, posX[2] = posX, posY - OFFSET_Y - OFFSET_TEXT
		OFFSET_TEXT, posX[1] = posX, posX
		OFFSET_TEXT, posX[2] = posX, centerY
		OFFSET_TEXT, posX[1] = 0, 0
		OFFSET_TEXT, posX[2] = 0, centerY
		;(0)[1] = 0
		;(0)[2] = OFFSET_Y
		resourcePoints, (nil)[1] = nil, posX
		resourcePoints, (nil)[2] = nil, posX
		resourcePoints, (nil)[3] = nil, posX
		resourcePoints, (nil)[4] = nil, 0
	end
	local createLine = function(pos1, pos2)
		local node = display.newNode()
		local posFrom = cc.p(pos1[1], pos1[2])
		local posTo = cc.p(pos2[1], pos2[2])
		local posSub = cc.pSub(posTo, posFrom)
		local length = cc.pGetLength(posSub)
		local angle = cc.pGetAngle(posSub, cc.p(0, 0))
		BORDER_WIDTH, BORDER_WIDTH = cc.p(0, 0)
		BORDER_WIDTH, cc.p(0, 0)[1] = 0, 0
		BORDER_WIDTH, cc.p(0, 0)[2] = 0, 0
		;(0)[1] = length
		;(0)[2] = 0
		_ENV, cc.p(0, 0)[1] = cc.p(0, 0)
		_ENV, cc.p(0, 0)[2] = cc.p(0, 0)
		cc.p(0, 0).borderColor = COLOR_HIGHT
		cc.p(0, 0).borderWidth = BORDER_WIDTH
		local line = display.newLine(cc.p(0, 0))
		line:addTo(node)
		node:setRotation(math.radian2angle(angle))
		node:setPosition(posFrom)
		node:addTo(self)
		return node
	end
	local lineNum = 0
	if 2 <= #resourcePoints then
		for i = 2, #resourcePoints do
			local line = createLine(resourcePoints[i - 1], resourcePoints[i])
			line:setScaleX(0.0)
			table.insert(self.tableLightLine, line)
			lineNum = lineNum + 1
		end
	end
	if 1 < lineNum then
		actionTime = actionTime / lineNum
	end
	if #self.tableLightLine == 1 then
		self.tableLightLine[1]:runAction(cca.scaleTo(actionTime, 1))
	else
		_ENV = self.tableLightLine[1].runAction
		_ENV, self.tableLightLine[1].runAction[1] = actionTime * 2, actionTime * 2
		_ENV, self.tableLightLine[1].runAction[2] = actionTime * 2, 0
		local _ENV, self.tableLightLine[1].runAction[3], delayArrayOne = actionTime * 2, actionTime, self.tableLightLine[1].runAction
		;(actionTime * 2)[1] = actionTime
		;(actionTime * 2)[2] = actionTime
		local (actionTime * 2)[3], delayArrayThree = actionTime, actionTime * 2
		local delayArray = delayArrayThree
		if resourcePoints[2][1] == resourcePoints[3][1] and resourcePoints[2][2] == resourcePoints[3][2] then
			delayArray = delayArrayOne
		end
		local accuDelay = 0.0
		for i, v in ipairs(self.tableLightLine) do
			OFFSET_Y = cca.scaleTo(actionTime, 1)
			cca.scaleTo(actionTime, 1)[1] = cca.delay(accuDelay)
			cca.scaleTo(actionTime, 1)[2] = cca.scaleTo(delayArray[i], 1)
			cca.scaleTo(actionTime, 1)[3] = cca.scaleTo(delayArray[i], 1)
			cca.scaleTo(actionTime, 1)[4] = cca.scaleTo(delayArray[i], 1)
			v:runAction(cca.seq(cca.scaleTo(actionTime, 1)))
			accuDelay = accuDelay + delayArray[i]
		end
	end
	OFFSET_Y = accuDelay + delayArray[i]
	;(accuDelay + delayArray[i])[1] = cca.delay(actionTime * lineNum)
	;(accuDelay + delayArray[i])[2] = cca.callFunc(function()
		for _, v in ipairs(self.tableLightLine) do
			v:removeFromParent()
		end
		self.tableLightLine, _ENV = ipairs(self.tableLightLine)
		self:addLine(self.tableData.posX, self.tableData.posY, true, self.frame_line, self.frame_line_hl)
	end)
	;(accuDelay + delayArray[i])[3] = cca.callFunc(function()
		for _, v in ipairs(self.tableLightLine) do
			v:removeFromParent()
		end
		self.tableLightLine, _ENV = ipairs(self.tableLightLine)
		self:addLine(self.tableData.posX, self.tableData.posY, true, self.frame_line, self.frame_line_hl)
	end)
	;(accuDelay + delayArray[i])[4] = cca.callFunc(function()
		for _, v in ipairs(self.tableLightLine) do
			v:removeFromParent()
		end
		self.tableLightLine, _ENV = ipairs(self.tableLightLine)
		self:addLine(self.tableData.posX, self.tableData.posY, true, self.frame_line, self.frame_line_hl)
	end)
	;(accuDelay + delayArray[i])[5] = cca.callFunc(function()
		for _, v in ipairs(self.tableLightLine) do
			v:removeFromParent()
		end
		self.tableLightLine, _ENV = ipairs(self.tableLightLine)
		self:addLine(self.tableData.posX, self.tableData.posY, true, self.frame_line, self.frame_line_hl)
	end)
	;(accuDelay + delayArray[i])[6] = cca.callFunc(function()
		for _, v in ipairs(self.tableLightLine) do
			v:removeFromParent()
		end
		self.tableLightLine, _ENV = ipairs(self.tableLightLine)
		self:addLine(self.tableData.posX, self.tableData.posY, true, self.frame_line, self.frame_line_hl)
	end)
	;(accuDelay + delayArray[i])[7] = cca.callFunc(function()
		for _, v in ipairs(self.tableLightLine) do
			v:removeFromParent()
		end
		self.tableLightLine, _ENV = ipairs(self.tableLightLine)
		self:addLine(self.tableData.posX, self.tableData.posY, true, self.frame_line, self.frame_line_hl)
	end)
	;(accuDelay + delayArray[i])[8] = cca.callFunc(function()
		for _, v in ipairs(self.tableLightLine) do
			v:removeFromParent()
		end
		self.tableLightLine, _ENV = ipairs(self.tableLightLine)
		self:addLine(self.tableData.posX, self.tableData.posY, true, self.frame_line, self.frame_line_hl)
	end)
	;(accuDelay + delayArray[i])[9] = cca.callFunc(function()
		for _, v in ipairs(self.tableLightLine) do
			v:removeFromParent()
		end
		self.tableLightLine, _ENV = ipairs(self.tableLightLine)
		self:addLine(self.tableData.posX, self.tableData.posY, true, self.frame_line, self.frame_line_hl)
	end)
	;(accuDelay + delayArray[i])[10] = cca.callFunc(function()
		for _, v in ipairs(self.tableLightLine) do
			v:removeFromParent()
		end
		self.tableLightLine, _ENV = ipairs(self.tableLightLine)
		self:addLine(self.tableData.posX, self.tableData.posY, true, self.frame_line, self.frame_line_hl)
	end)
	;(accuDelay + delayArray[i])[11] = cca.callFunc(function()
		for _, v in ipairs(self.tableLightLine) do
			v:removeFromParent()
		end
		self.tableLightLine, _ENV = ipairs(self.tableLightLine)
		self:addLine(self.tableData.posX, self.tableData.posY, true, self.frame_line, self.frame_line_hl)
	end)
	;(accuDelay + delayArray[i])[12] = cca.callFunc(function()
		for _, v in ipairs(self.tableLightLine) do
			v:removeFromParent()
		end
		self.tableLightLine, _ENV = ipairs(self.tableLightLine)
		self:addLine(self.tableData.posX, self.tableData.posY, true, self.frame_line, self.frame_line_hl)
	end)
	;(accuDelay + delayArray[i])[13] = cca.callFunc(function()
		for _, v in ipairs(self.tableLightLine) do
			v:removeFromParent()
		end
		self.tableLightLine, _ENV = ipairs(self.tableLightLine)
		self:addLine(self.tableData.posX, self.tableData.posY, true, self.frame_line, self.frame_line_hl)
	end)
	self:runAction(cca.seq(accuDelay + delayArray[i]))
end
function warTechnologyScrollLine:initData(skillLineData, frame_line, frame_line_hl, beeLine)
	self.tableData = skillLineData
	self.frame_line = frame_line
	self.frame_line_hl = frame_line_hl
	self.beeLine = beeLine
	local singleData = technologyCtrl:getTechnoDataByID(self.tableData.toid, self.tableData.type)
	local lineLight = singleData.isOpened and singleData.currentLevel > 0
	self.lineLight = lineLight
	self:addLine(self.tableData.posX, self.tableData.posY, lineLight, frame_line, frame_line_hl)
end
function warTechnologyScrollLine:updateLine()
	local singleData = technologyCtrl:getTechnoDataByID(self.tableData.toid, self.tableData.type)
	local lineLight = singleData.isOpened and singleData.currentLevel > 0
	if lineLight ~= self.lineLight and lineLight then
		self.tableLightLine, technologyCtrl, self.lineLight = self.lineLight, self.lineLight, lineLight
		self:addLine(self.tableData.posX, self.tableData.posY, true, self.frame_line, self.frame_line_hl)
	end
end
return warTechnologyScrollLine

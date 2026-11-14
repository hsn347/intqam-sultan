local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local lordSkillModuleAPI = include("lordSkillModuleAPI")
local skillScrollLine = class("skillScrollLine", function(target)
	if target == nil then
		return display.newNode()
	end
	return target
end)
function skillScrollLine:ctor()
	self.tableLightLine, _UPVALUE0_, self.tableData, _UPVALUE0_ = nil, nil, nil, nil
	self.lineLight = false
end
local CENTER_Y = 0.45
local OFFSET_Y = 50
local OFFSET_TEXT = -50
local BORDER_WIDTH = 4
local COLOR_GAY = cc.c4f(0.34, 0.34, 0.34, 1.0)
local COLOR_HIGHT = cc.c4f(0.96, 0.67, 0.0, 1.0)
function skillScrollLine:addLine(posX, posY, lineLight, frame_line, frame_line_hl)
	local centerY = posY * CENTER_Y
	local x = self:getPositionX()
	local y = self:getPositionY()
	OFFSET_TEXT, _ENV = nil, self
	OFFSET_TEXT, (nil)[1] = x + posX, x + posX
	OFFSET_TEXT, (nil)[2] = x + posX, y + posY - OFFSET_Y - OFFSET_TEXT
	OFFSET_TEXT, (x + posX)[1] = x + posX, x + posX
	OFFSET_TEXT, (x + posX)[2] = x + posX, y + centerY
	OFFSET_TEXT, (x + posX)[1] = x, x
	OFFSET_TEXT, (x + posX)[2] = x, y + centerY
	x[1] = x
	x[2] = y + OFFSET_Y
	self[1] = nil
	self[2] = x + posX
	self[3] = x + posX
	local self[4], resourcePoints = x, self
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
	createGayLine(resourcePoints[1], resourcePoints[2])
	if posX ~= 0 then
		createGayLine(resourcePoints[2], resourcePoints[3])
	end
	createGayLine(resourcePoints[3], resourcePoints[4])
end
function skillScrollLine:addHightlight(posX, posY, actionTime)
	local centerY = posY * CENTER_Y
	OFFSET_TEXT, COLOR_HIGHT = nil, nil
	OFFSET_TEXT, (nil)[1] = posX, posX
	OFFSET_TEXT, (nil)[2] = posX, posY - OFFSET_Y - OFFSET_TEXT
	OFFSET_TEXT, posX[1] = posX, posX
	OFFSET_TEXT, posX[2] = posX, centerY
	OFFSET_TEXT, posX[1] = 0, 0
	OFFSET_TEXT, posX[2] = 0, centerY
	;(0)[1] = 0
	;(0)[2] = OFFSET_Y
	;(nil)[1] = nil
	;(nil)[2] = posX
	;(nil)[3] = posX
	local (nil)[4], resourcePoints = 0, nil
	local createLine = function(pos1, pos2)
		local node = display.newNode()
		BORDER_WIDTH, BORDER_WIDTH = nil, nil
		BORDER_WIDTH, (nil)[1] = 0, 0
		BORDER_WIDTH, (nil)[2] = 0, 0
		;(0)[1] = pos2[1] - pos1[1]
		;(0)[2] = pos2[2] - pos1[2]
		_ENV, (nil)[1] = nil, nil
		_ENV, (nil)[2] = nil, 0
		;(nil).borderColor = COLOR_HIGHT
		;(nil).borderWidth = BORDER_WIDTH
		local line = display.newLine(nil, nil)
		line:addTo(node)
		node:setPosition(cc.p(pos1[1], pos1[2]))
		node:addTo(self)
		return node
	end
	local line1 = createLine(resourcePoints[1], resourcePoints[2])
	table.insert(self.tableLightLine, line1)
	if posX ~= 0 then
		local line2 = createLine(resourcePoints[2], resourcePoints[3])
		table.insert(self.tableLightLine, line2)
	end
	local line3 = createLine(resourcePoints[3], resourcePoints[4])
	table.insert(self.tableLightLine, line3)
	local num = #self.tableLightLine
	actionTime = actionTime / num
	for i, v in ipairs(self.tableLightLine) do
		if i % 2 == 0 then
			v:setScaleX(0)
		else
			v:setScaleY(0)
		end
	end
	if #self.tableLightLine == 1 then
		OFFSET_Y = nil
		;(nil)[1] = cca.scaleTo(2 * actionTime, 0.5, 1)
		;(nil)[2] = cca.scaleTo(actionTime, 1)
		;(nil)[3] = cca.scaleTo(actionTime, 1)
		;(nil)[4] = cca.scaleTo(actionTime, 1)
		;(nil)[5] = cca.scaleTo(actionTime, 1)
		;(nil)[6] = cca.scaleTo(actionTime, 1)
		;(nil)[7] = cca.scaleTo(actionTime, 1)
		;(nil)[8] = cca.scaleTo(actionTime, 1)
		;(nil)[9] = cca.scaleTo(actionTime, 1)
		;(nil)[10] = cca.scaleTo(actionTime, 1)
		;(nil)[11] = cca.scaleTo(actionTime, 1)
		;(nil)[12] = cca.scaleTo(actionTime, 1)
		;(nil)[13] = cca.scaleTo(actionTime, 1)
		self.tableLightLine[1]:runAction(cca.seq(nil))
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
			OFFSET_Y = cca.seq(nil)
			cca.seq(nil)[1] = cca.delay(accuDelay)
			cca.seq(nil)[2] = cca.scaleTo(delayArray[i], 1)
			cca.seq(nil)[3] = cca.scaleTo(delayArray[i], 1)
			cca.seq(nil)[4] = cca.scaleTo(delayArray[i], 1)
			v:runAction(cca.seq(cca.seq(nil)))
			accuDelay = accuDelay + delayArray[i]
		end
	end
	OFFSET_Y = accuDelay + delayArray[i]
	;(accuDelay + delayArray[i])[1] = cca.delay(actionTime * num)
	;(accuDelay + delayArray[i])[2] = cca.callFunc(function()
		for i, v in ipairs(self.tableLightLine) do
			v:removeFromParent()
		end
		self.tableLightLine, _ENV = ipairs(self.tableLightLine)
		self:addLine(self.tableData.posX, self.tableData.posY, true, self.frame_line, self.frame_line_hl)
	end)
	;(accuDelay + delayArray[i])[3] = cca.callFunc(function()
		for i, v in ipairs(self.tableLightLine) do
			v:removeFromParent()
		end
		self.tableLightLine, _ENV = ipairs(self.tableLightLine)
		self:addLine(self.tableData.posX, self.tableData.posY, true, self.frame_line, self.frame_line_hl)
	end)
	;(accuDelay + delayArray[i])[4] = cca.callFunc(function()
		for i, v in ipairs(self.tableLightLine) do
			v:removeFromParent()
		end
		self.tableLightLine, _ENV = ipairs(self.tableLightLine)
		self:addLine(self.tableData.posX, self.tableData.posY, true, self.frame_line, self.frame_line_hl)
	end)
	;(accuDelay + delayArray[i])[5] = cca.callFunc(function()
		for i, v in ipairs(self.tableLightLine) do
			v:removeFromParent()
		end
		self.tableLightLine, _ENV = ipairs(self.tableLightLine)
		self:addLine(self.tableData.posX, self.tableData.posY, true, self.frame_line, self.frame_line_hl)
	end)
	;(accuDelay + delayArray[i])[6] = cca.callFunc(function()
		for i, v in ipairs(self.tableLightLine) do
			v:removeFromParent()
		end
		self.tableLightLine, _ENV = ipairs(self.tableLightLine)
		self:addLine(self.tableData.posX, self.tableData.posY, true, self.frame_line, self.frame_line_hl)
	end)
	;(accuDelay + delayArray[i])[7] = cca.callFunc(function()
		for i, v in ipairs(self.tableLightLine) do
			v:removeFromParent()
		end
		self.tableLightLine, _ENV = ipairs(self.tableLightLine)
		self:addLine(self.tableData.posX, self.tableData.posY, true, self.frame_line, self.frame_line_hl)
	end)
	;(accuDelay + delayArray[i])[8] = cca.callFunc(function()
		for i, v in ipairs(self.tableLightLine) do
			v:removeFromParent()
		end
		self.tableLightLine, _ENV = ipairs(self.tableLightLine)
		self:addLine(self.tableData.posX, self.tableData.posY, true, self.frame_line, self.frame_line_hl)
	end)
	;(accuDelay + delayArray[i])[9] = cca.callFunc(function()
		for i, v in ipairs(self.tableLightLine) do
			v:removeFromParent()
		end
		self.tableLightLine, _ENV = ipairs(self.tableLightLine)
		self:addLine(self.tableData.posX, self.tableData.posY, true, self.frame_line, self.frame_line_hl)
	end)
	;(accuDelay + delayArray[i])[10] = cca.callFunc(function()
		for i, v in ipairs(self.tableLightLine) do
			v:removeFromParent()
		end
		self.tableLightLine, _ENV = ipairs(self.tableLightLine)
		self:addLine(self.tableData.posX, self.tableData.posY, true, self.frame_line, self.frame_line_hl)
	end)
	;(accuDelay + delayArray[i])[11] = cca.callFunc(function()
		for i, v in ipairs(self.tableLightLine) do
			v:removeFromParent()
		end
		self.tableLightLine, _ENV = ipairs(self.tableLightLine)
		self:addLine(self.tableData.posX, self.tableData.posY, true, self.frame_line, self.frame_line_hl)
	end)
	;(accuDelay + delayArray[i])[12] = cca.callFunc(function()
		for i, v in ipairs(self.tableLightLine) do
			v:removeFromParent()
		end
		self.tableLightLine, _ENV = ipairs(self.tableLightLine)
		self:addLine(self.tableData.posX, self.tableData.posY, true, self.frame_line, self.frame_line_hl)
	end)
	;(accuDelay + delayArray[i])[13] = cca.callFunc(function()
		for i, v in ipairs(self.tableLightLine) do
			v:removeFromParent()
		end
		self.tableLightLine, _ENV = ipairs(self.tableLightLine)
		self:addLine(self.tableData.posX, self.tableData.posY, true, self.frame_line, self.frame_line_hl)
	end)
	self:runAction(cca.seq(accuDelay + delayArray[i]))
end
function skillScrollLine:initData(skillLineData, frame_line, frame_line_hl, _color)
	self.tableData = skillLineData
	self.setID = skillLineData.setID
	self.frame_line = frame_line
	self.frame_line_hl = frame_line_hl
	local singleData = lordSkillModuleAPI:getSkillDetail(self.setID, self.tableData.toid)
	local lineLight = singleData.isOpened and tonumber(singleData.currentLevel) >= tonumber(singleData.maxLevel)
	self.lineLight = lineLight
	self:addLine(self.tableData.posX, self.tableData.posY, lineLight, frame_line, frame_line_hl)
end
function skillScrollLine:updateLine(delay)
	local singleData = lordSkillModuleAPI:getSkillDetail(self.setID, self.tableData.toid)
	local lineLight = singleData.isOpened and tonumber(singleData.currentLevel) >= tonumber(singleData.maxLevel)
	if lineLight ~= self.lineLight and lineLight then
		self.lineLight = lineLight
		self:addHightlight(self.tableData.posX, self.tableData.posY, 1 or delay)
	end
end
return skillScrollLine

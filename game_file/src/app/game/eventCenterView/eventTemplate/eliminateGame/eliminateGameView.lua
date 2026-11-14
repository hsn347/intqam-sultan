local gametop = gModuleMgr.getObject("gametop")
local siegeCombatCtrl = gametop.playertop_:getModule("siegeCombatCtrl")
local guideCtrl = gametop.playertop_:getModule("guideCtrl")
local worldMapFunction = include("worldMapFunction")
local eliminateGameCommon = include("eliminateGameCommon")
local msgNotice = include("msgNotice")
local Swap_Distance_Value = 50
_ENV = nil
;(nil).red = 1
;(nil).yellow = 2
;(nil).purple = 3
local _ENV, (nil).green, ChessColorDef = nil, 4, nil
;(nil).NONE = -1
;(nil).LEFT = 0
;(nil).UP = 1
;(nil).RIGHT = 2
;(nil).DOWN = 3
;(nil).UP_LEFT = 4
;(nil).UP_RIGHT = 5
;(nil).DOWN_RIGHT = 6
local _ENV, (nil).DOWN_LEFT, SwapDirection = nil, 7, nil
_ENV = nil
;(nil).judgeType = 0
;(nil).min = SoraDGetAngleByPos(cc.p(0, 0), cc.p(-2, -1))
_UPVALUE2_, (nil).max = SoraDGetAngleByPos(cc.p(0, 0), cc.p(-2, 1)), SoraDGetAngleByPos(cc.p(0, 0), cc.p(-2, 1))
;(nil).directionVec, SoraDGetAngleByPos(cc.p(0, 0), cc.p(-2, 1))[1] = SoraDGetAngleByPos(cc.p(0, 0), cc.p(-2, 1)), 0
;(nil).directionVec, SoraDGetAngleByPos(cc.p(0, 0), cc.p(-2, 1))[2] = SoraDGetAngleByPos(cc.p(0, 0), cc.p(-2, 1)), -1
;(nil)[SwapDirection.LEFT], (nil).desc = nil, "SwapDirection.LEFT"
_ENV = nil
;(nil).judgeType = 1
;(nil).min = SoraDGetAngleByPos(cc.p(0, 0), cc.p(1, 2))
_UPVALUE2_, (nil).max = SoraDGetAngleByPos(cc.p(0, 0), cc.p(-1, 2)), SoraDGetAngleByPos(cc.p(0, 0), cc.p(-1, 2))
;(nil).directionVec, SoraDGetAngleByPos(cc.p(0, 0), cc.p(-1, 2))[1] = SoraDGetAngleByPos(cc.p(0, 0), cc.p(-1, 2)), -1
;(nil).directionVec, SoraDGetAngleByPos(cc.p(0, 0), cc.p(-1, 2))[2] = SoraDGetAngleByPos(cc.p(0, 0), cc.p(-1, 2)), 0
;(nil)[SwapDirection.UP], (nil).desc = nil, "SwapDirection.UP"
_ENV = nil
;(nil).judgeType = 1
;(nil).min = SoraDGetAngleByPos(cc.p(0, 0), cc.p(2, -1))
_UPVALUE2_, (nil).max = SoraDGetAngleByPos(cc.p(0, 0), cc.p(2, 1)), SoraDGetAngleByPos(cc.p(0, 0), cc.p(2, 1))
;(nil).directionVec, SoraDGetAngleByPos(cc.p(0, 0), cc.p(2, 1))[1] = SoraDGetAngleByPos(cc.p(0, 0), cc.p(2, 1)), 0
;(nil).directionVec, SoraDGetAngleByPos(cc.p(0, 0), cc.p(2, 1))[2] = SoraDGetAngleByPos(cc.p(0, 0), cc.p(2, 1)), 1
;(nil)[SwapDirection.RIGHT], (nil).desc = nil, "SwapDirection.RIGHT"
_ENV = nil
;(nil).judgeType = 1
;(nil).min = SoraDGetAngleByPos(cc.p(0, 0), cc.p(-1, -2))
_UPVALUE2_, (nil).max = SoraDGetAngleByPos(cc.p(0, 0), cc.p(1, -2)), SoraDGetAngleByPos(cc.p(0, 0), cc.p(1, -2))
;(nil).directionVec, SoraDGetAngleByPos(cc.p(0, 0), cc.p(1, -2))[1] = SoraDGetAngleByPos(cc.p(0, 0), cc.p(1, -2)), 1
;(nil).directionVec, SoraDGetAngleByPos(cc.p(0, 0), cc.p(1, -2))[2] = SoraDGetAngleByPos(cc.p(0, 0), cc.p(1, -2)), 0
;(nil)[SwapDirection.DOWN], (nil).desc = nil, "SwapDirection.DOWN"
_ENV = nil
;(nil).judgeType = 1
;(nil).min = SoraDGetAngleByPos(cc.p(0, 0), cc.p(-1, 2))
_UPVALUE2_, (nil).max = SoraDGetAngleByPos(cc.p(0, 0), cc.p(-2, 1)), SoraDGetAngleByPos(cc.p(0, 0), cc.p(-2, 1))
;(nil).directionVec, SoraDGetAngleByPos(cc.p(0, 0), cc.p(-2, 1))[1] = SoraDGetAngleByPos(cc.p(0, 0), cc.p(-2, 1)), -1
;(nil).directionVec, SoraDGetAngleByPos(cc.p(0, 0), cc.p(-2, 1))[2] = SoraDGetAngleByPos(cc.p(0, 0), cc.p(-2, 1)), -1
;(nil)[SwapDirection.UP_LEFT], (nil).desc = nil, "SwapDirection.UP_LEFT"
_ENV = nil
;(nil).judgeType = 1
;(nil).min = SoraDGetAngleByPos(cc.p(0, 0), cc.p(2, 1))
_UPVALUE2_, (nil).max = SoraDGetAngleByPos(cc.p(0, 0), cc.p(1, 2)), SoraDGetAngleByPos(cc.p(0, 0), cc.p(1, 2))
;(nil).directionVec, SoraDGetAngleByPos(cc.p(0, 0), cc.p(1, 2))[1] = SoraDGetAngleByPos(cc.p(0, 0), cc.p(1, 2)), -1
;(nil).directionVec, SoraDGetAngleByPos(cc.p(0, 0), cc.p(1, 2))[2] = SoraDGetAngleByPos(cc.p(0, 0), cc.p(1, 2)), 1
;(nil)[SwapDirection.UP_RIGHT], (nil).desc = nil, "SwapDirection.UP_RIGHT"
_ENV = nil
;(nil).judgeType = 1
;(nil).min = SoraDGetAngleByPos(cc.p(0, 0), cc.p(1, -2))
_UPVALUE2_, (nil).max = SoraDGetAngleByPos(cc.p(0, 0), cc.p(2, -1)), SoraDGetAngleByPos(cc.p(0, 0), cc.p(2, -1))
;(nil).directionVec, SoraDGetAngleByPos(cc.p(0, 0), cc.p(2, -1))[1] = SoraDGetAngleByPos(cc.p(0, 0), cc.p(2, -1)), 1
;(nil).directionVec, SoraDGetAngleByPos(cc.p(0, 0), cc.p(2, -1))[2] = SoraDGetAngleByPos(cc.p(0, 0), cc.p(2, -1)), 1
;(nil)[SwapDirection.DOWN_RIGHT], (nil).desc = nil, "SwapDirection.DOWN_RIGHT"
_ENV = nil
;(nil).judgeType = 1
;(nil).min = SoraDGetAngleByPos(cc.p(0, 0), cc.p(-2, -1))
_UPVALUE2_, (nil).max = SoraDGetAngleByPos(cc.p(0, 0), cc.p(-1, -2)), SoraDGetAngleByPos(cc.p(0, 0), cc.p(-1, -2))
;(nil).directionVec, SoraDGetAngleByPos(cc.p(0, 0), cc.p(-1, -2))[1] = SoraDGetAngleByPos(cc.p(0, 0), cc.p(-1, -2)), 1
;(nil).directionVec, SoraDGetAngleByPos(cc.p(0, 0), cc.p(-1, -2))[2] = SoraDGetAngleByPos(cc.p(0, 0), cc.p(-1, -2)), -1
;(nil)[SwapDirection.DOWN_LEFT], (nil).desc = nil, "SwapDirection.DOWN_LEFT"
local AngleSec
local EliminateGameView = class("eliminateGameView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("eliminateGameView")
	end
	return target
end)
function EliminateGameView:ctor()
	self.chessboard, _ENV, self.needCallBack2SDK = nil, nil, true
	self.row = 5
	self.col = 5
	self.chessKind = 4
	self.atkDetail, _ENV, self.damageList, _ENV, self.emptyList, _ENV, self.chessList, _ENV, self.closeList, _ENV, self.openList, _ENV, self.rightSlantChain, _ENV, self.leftSlantChain, _ENV, self.colChain, _ENV, self.rowChain, _ENV, self.minNum = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 4
	self.stepNum = 30
	self.level = 1
	self.atk = 0
	self.mulNum = 1
	self.freeDoubleTimes = 3
	self.deltaHeight = 0
	self:setBackGround(255)
	self.isHideCurrentSceneView = true
	math.randomseed(tostring(os.time()):reverse():sub(1, 6))
	SoraDAddMessage(self, "MESSAGE_SERVER_ELIMINATEGAME_KO", self.onKO)
	SoraDAddMessage(self, "MESSAGE_SERVER_ELIMINATEGAME_DOUBLE", self.onDoubleBack)
	SoraDAddMessage(self, "MESSAGE_SERVER_ELIMINATEGAME_STEP", self.onStepBack)
	SoraDAddMessage(self, "MESSAGE_SERVER_ELIMINATEGAME_HURT", self.onHurtBack)
	SoraDAddMessage(self, "MESSAGE_SERVER_ELIMINATEGAME_OLD_DAMAGE", self.onOldDamageBack)
	SoraDAddMessage(self, "MESSAGE_SERVER_ELIMINATEGAME_USESTEP", self.onUseStepBack)
	SoraDAddMessage(self, "MESSAGE_SERVER_ELIMINATEGAME_CLOSE", self.onCloseActivity)
	self:fitDevice()
	guideCtrl:updateGuideModule(gGuideModule.SIEGE_COMBAT)
end
function EliminateGameView:fitDevice()
	self.monster = SoraDGetChildByName(self, "node_monster")
	self.nodeMain = SoraDGetChildByName(self, "Node_main")
	self.Node_bar = SoraDGetChildByName(self, "Node_bar")
	self.Top_Image_1 = SoraDGetChildByName(self, "Top_Image_1")
	self.touchMask = SoraDGetChildByName(self, "touchMask")
	self.Panel_monster = SoraDGetChildByName(self, "Panel_monster")
	local designHeight = 1136
	local deltaHeight = display.height - designHeight
	if deltaHeight < 0 then
		local scaleM = display.height / designHeight
		self.nodeMain:setScale(scaleM)
		self.touchMask:setScale(scaleM)
		local posy = self.nodeMain:getPositionY()
		self.Node_bar:setPositionY(posy + (self.Node_bar:getPositionY() - posy) * scaleM)
		self.Panel_monster:setPositionY(posy + (self.Panel_monster:getPositionY() - posy) * scaleM)
		self.Panel_monster:setScale(0.7)
	else
		self.Panel_monster:setScale(1.2)
	end
	local iScale = display.height / self.Top_Image_1:getContentSize().height
	if 1 < iScale then
		self.Top_Image_1:setScale(iScale)
	end
end
function EliminateGameView:initChessboard()
	self.chessboard, _ENV = nil, nil
	for i = 1, self.row do
		for j = 1, self.col do
			self.chessboard[self:conv(i, j)] = math.random(1, self.chessKind)
		end
	end
	self:scanLinks()
	self:breakLink()
end
function EliminateGameView:initFirstFightChessboard()
	self.chessboard, _ENV = nil, nil
	for row, rowData in ipairs(self.firstFightConfig) do
		for col = 1, #rowData do
			self.chessboard[self:conv(row, col)] = rowData[col]
		end
	end
end
function EliminateGameView:scanLinks()
	self.rightSlantChain, _UPVALUE0_, self.leftSlantChain, _UPVALUE0_, self.colChain, _UPVALUE0_, self.rowChain, _UPVALUE0_ = nil, nil, nil, nil, nil, nil, nil, nil
	self:scanRow()
	self:scanCol()
	self:scanLeftSlant()
	self:scanRightSlant()
end
function EliminateGameView:dumpLinks()
	dump(self.colChain, "self.colChain", 10)
	dump(self.rowChain, "self.rowChain", 10)
	dump(self.leftSlantChain, "self.leftSlantChain", 10)
	dump(self.rightSlantChain, "self.rightSlantChain", 10)
end
function EliminateGameView:scanRow()
	local _ENV, start
	local _ENV, list
	local count = 1
	for i = 1, self.row do
		_ENV, count = nil, 0
		;(nil).row = i
		list, _ENV, start, (nil).col = nil, nil, nil, 1
		for j = 1, self.col do
			if self.chessboard[self:conv(i, j)] == self.chessboard[self:conv(start)] then
				count = count + 1
				_ENV = self:conv(start)
				self:conv(start).row = i
				self:conv(start).col = j
				table.insert(list, (self:conv(start)))
			end
			if self.chessboard[self:conv(i, j)] ~= self.chessboard[self:conv(start)] or j == self.col then
				if count >= self.minNum then
					if not self.rowChain[count] then
						self.rowChain[count], _ENV = self.chessboard[self:conv(start)], self.chessboard[self:conv(start)]
					end
					table.insert(self.rowChain[count], list)
				end
				_ENV = table.insert
				table.insert.row = i
				start, table.insert.col = table.insert, j
				list, _ENV, count = table.insert, table.insert, 1
				table.insert(list, start)
			end
		end
	end
end
function EliminateGameView:scanCol()
	local _ENV, start
	local _ENV, list
	local count = 1
	for j = 1, self.col do
		_ENV = nil
		;(nil).row = 1
		list, _ENV, start, (nil).col = nil, nil, nil, j
		count = 0
		for i = 1, self.row do
			if self.chessboard[self:conv(i, j)] == self.chessboard[self:conv(start)] then
				count = count + 1
				_ENV = self:conv(start)
				self:conv(start).row = i
				self:conv(start).col = j
				table.insert(list, (self:conv(start)))
			end
			if self.chessboard[self:conv(i, j)] ~= self.chessboard[self:conv(start)] or i == self.row then
				if count >= self.minNum then
					if not self.colChain[count] then
						self.colChain[count], _ENV = self.chessboard[self:conv(start)], self.chessboard[self:conv(start)]
					end
					table.insert(self.colChain[count], list)
				end
				_ENV = table.insert
				table.insert.row = i
				start, table.insert.col = table.insert, j
				list, _ENV, count = table.insert, table.insert, 1
				table.insert(list, start)
			end
		end
	end
end
function EliminateGameView:scanLeftSlant()
	local _ENV, start
	local _ENV, list
	local count = 1
	local row, col
	for colNum = self.minNum, self.col do
		count = 0
		row = 1
		_ENV, col = nil, colNum
		;(nil).row = row
		list, _ENV, start, (nil).col = nil, nil, nil, col
		for rowNum = 1, self.row do
			if self.chessboard[self:conv(row, col)] == self.chessboard[self:conv(start)] then
				count = count + 1
				_ENV = self:conv(start)
				self:conv(start).row = row
				self:conv(start).col = col
				table.insert(list, (self:conv(start)))
			end
			if self.chessboard[self:conv(row, col)] ~= self.chessboard[self:conv(start)] or rowNum == self.row or col == 1 then
				if count >= self.minNum then
					if not self.leftSlantChain[count] then
						self.leftSlantChain[count], _ENV = self.chessboard[self:conv(start)], self.chessboard[self:conv(start)]
					end
					table.insert(self.leftSlantChain[count], list)
				end
				_ENV = table.insert
				table.insert.row = row
				start, table.insert.col = table.insert, col
				list, _ENV, count = table.insert, table.insert, 1
				table.insert(list, start)
			end
			row = row + 1
			col = col - 1
			if col < 1 then
				break
			end
		end
	end
	for rowNum = 2, self.minNum do
		count = 0
		row = rowNum
		_ENV, col = 1, self.col
		;(1).row = row
		list, _ENV, start, (1).col = 1, 1, 1, col
		for colNum = self.col, 1, -1 do
			if self.chessboard[self:conv(row, col)] == self.chessboard[self:conv(start)] then
				count = count + 1
				_ENV = self:conv(start)
				self:conv(start).row = row
				self:conv(start).col = col
				table.insert(list, (self:conv(start)))
			end
			if self.chessboard[self:conv(row, col)] ~= self.chessboard[self:conv(start)] or colNum == 1 or row == self.row then
				if count >= self.minNum then
					if not self.leftSlantChain[count] then
						self.leftSlantChain[count], _ENV = self.chessboard[self:conv(start)], self.chessboard[self:conv(start)]
					end
					table.insert(self.leftSlantChain[count], list)
				end
				_ENV = table.insert
				table.insert.row = row
				start, table.insert.col = table.insert, col
				list, _ENV, count = table.insert, table.insert, 1
				table.insert(list, start)
			end
			row = row + 1
			col = col - 1
			if row > self.row then
				break
			end
		end
	end
end
function EliminateGameView:scanRightSlant()
	local _ENV, start
	local _ENV, list
	local count = 1
	local row, col
	for colNum = 1, self.minNum do
		count = 0
		row = 1
		_ENV, col = nil, colNum
		;(nil).row = row
		list, _ENV, start, (nil).col = nil, nil, nil, col
		for rowNum = 1, self.row do
			if self.chessboard[self:conv(row, col)] == self.chessboard[self:conv(start)] then
				count = count + 1
				_ENV = self:conv(start)
				self:conv(start).row = row
				self:conv(start).col = col
				table.insert(list, (self:conv(start)))
			end
			if self.chessboard[self:conv(row, col)] ~= self.chessboard[self:conv(start)] or rowNum == self.row or col == self.col then
				if count >= self.minNum then
					if not self.rightSlantChain[count] then
						self.rightSlantChain[count], _ENV = self.chessboard[self:conv(start)], self.chessboard[self:conv(start)]
					end
					table.insert(self.rightSlantChain[count], list)
				end
				_ENV = table.insert
				table.insert.row = row
				start, table.insert.col = table.insert, col
				list, _ENV, count = table.insert, table.insert, 1
				table.insert(list, start)
			end
			row = row + 1
			col = col + 1
			if col > self.col then
				break
			end
		end
	end
	for rowNum = 2, self.row do
		count = 0
		row = rowNum
		_ENV, col = 1, 1
		;(1).row = row
		list, _ENV, start, (1).col = 1, 1, 1, col
		for colNum = 1, self.col do
			if self.chessboard[self:conv(row, col)] == self.chessboard[self:conv(start)] then
				count = count + 1
				_ENV = self:conv(start)
				self:conv(start).row = row
				self:conv(start).col = col
				table.insert(list, (self:conv(start)))
			end
			if self.chessboard[self:conv(row, col)] ~= self.chessboard[self:conv(start)] or colNum == self.col or row == self.row then
				if count >= self.minNum then
					if not self.rightSlantChain[count] then
						self.rightSlantChain[count], _ENV = self.chessboard[self:conv(start)], self.chessboard[self:conv(start)]
					end
					table.insert(self.rightSlantChain[count], list)
				end
				_ENV = table.insert
				table.insert.row = row
				start, table.insert.col = table.insert, col
				list, _ENV, count = table.insert, table.insert, 1
				table.insert(list, start)
			end
			row = row + 1
			col = col + 1
			if row > self.row then
				break
			end
		end
	end
end
function EliminateGameView:breakLink()
	_UPVALUE4_, self.closeList, _ENV, self.openList, _ENV = nil, nil, nil, nil, nil
	;(nil)[1] = self.rowChain
	;(nil)[2] = self.colChain
	;(nil)[3] = self.leftSlantChain
	local (nil)[4], chainList = self.rightSlantChain, nil
	for i, chain in ipairs(chainList) do
		for key, linkList in pairs(chain) do
			for j, link in ipairs(linkList) do
				local middleIndex = math.ceil(tonumber(key) / 2)
				table.insert(self.openList, link[middleIndex])
			end
		end
	end
	local i = 1
	self.openListLen = #self.openList
	while i <= self.openListLen do
		self:breakPoint(self.openList[i].row, self.openList[i].col)
		self.openListLen = #self.openList
		i = i + 1
	end
end
function EliminateGameView:getSamePoint(row, col)
	local _ENV, selectColors
	local color = self.chessboard[self:conv(row, col)]
	local color1, color2
	_ENV = row
	row.row = row
	local row.col, p = col, row
	local _ENV, p1 = col, col
	local _UPVALUE4_, _UPVALUE4_, _ENV, p2
	_UPVALUE4_, (nil)[1] = 0, 0
	_UPVALUE4_, (nil)[2] = 0, -1
	_UPVALUE4_, (nil)[3] = 0, 0
	_UPVALUE4_, (nil)[4] = 0, 1
	_UPVALUE4_, (0)[1] = -1, -1
	_UPVALUE4_, (0)[2] = -1, 0
	_UPVALUE4_, (0)[3] = -1, 1
	_UPVALUE4_, (0)[4] = -1, 0
	_UPVALUE4_, (-1)[1] = -1, -1
	_UPVALUE4_, (-1)[2] = -1, -1
	_UPVALUE4_, (-1)[3] = -1, 1
	_UPVALUE4_, (-1)[4] = -1, 1
	;(-1)[1] = -1
	;(-1)[2] = 1
	;(-1)[3] = 1
	;(-1)[4] = -1
	;(nil)[1] = nil
	;(nil)[2] = 0
	;(nil)[3] = -1
	local (nil)[4], directions = -1, nil
	for _, direction in ipairs(directions) do
		color1 = 0
		_ENV, color2 = 1, 0
		;(1).row = direction[1] + row
		_ENV, p1, (1).col = 1, 1, direction[2] + col
		;(1).row = direction[3] + row
		p2, (1).col = 1, direction[4] + col
		color1 = self.chessboard[self:conv(p1)] or 0
		color2 = self.chessboard[self:conv(p2)] or 0
		if color1 ~= 0 then
			if selectColors[color1] == nil then
				selectColors[color1], _ENV = selectColors[color1], selectColors[color1]
			end
			table.insert(selectColors[color1], p1)
		end
		if color2 ~= 0 then
			if selectColors[color2] == nil then
				selectColors[color2], _ENV = selectColors[color2], selectColors[color2]
			end
			table.insert(selectColors[color2], p2)
		end
	end
	return selectColors[color]
end
function EliminateGameView:breakPoint(row, col)
	if self.closeList[self:conv(row, col)] then
		return
	end
	local findDiff = false
	local _ENV, diffColors = self:conv(row, col), self:conv(row, col)
	local _ENV, selectColors = self, self
	local _ENV, sameColors = row, row
	local link
	local color = self.chessboard[self:conv(row, col)]
	local color1, color2
	_ENV = row
	row.row = row
	local row.col, p = col, row
	local _ENV, p1 = col, col
	local _UPVALUE4_, _UPVALUE4_, _ENV, p2
	_UPVALUE4_, (nil)[1] = 0, 0
	_UPVALUE4_, (nil)[2] = 0, -1
	_UPVALUE4_, (nil)[3] = 0, 0
	_UPVALUE4_, (nil)[4] = 0, 1
	_UPVALUE4_, (0)[1] = -1, -1
	_UPVALUE4_, (0)[2] = -1, 0
	_UPVALUE4_, (0)[3] = -1, 1
	_UPVALUE4_, (0)[4] = -1, 0
	_UPVALUE4_, (-1)[1] = -1, -1
	_UPVALUE4_, (-1)[2] = -1, -1
	_UPVALUE4_, (-1)[3] = -1, 1
	_UPVALUE4_, (-1)[4] = -1, 1
	;(-1)[1] = -1
	;(-1)[2] = 1
	;(-1)[3] = 1
	;(-1)[4] = -1
	;(nil)[1] = nil
	;(nil)[2] = 0
	;(nil)[3] = -1
	local (nil)[4], directions = -1, nil
	for _, direction in ipairs(directions) do
		color1 = 0
		_ENV, color2 = 1, 0
		;(1).row = direction[1] + row
		_ENV, p1, (1).col = 1, 1, direction[2] + col
		;(1).row = direction[3] + row
		p2, (1).col = 1, direction[4] + col
		color1 = self.chessboard[self:conv(p1)] or 0
		color2 = self.chessboard[self:conv(p2)] or 0
		if color1 ~= 0 then
			if selectColors[color1] == nil then
				selectColors[color1], _ENV = selectColors[color1], selectColors[color1]
			end
			table.insert(selectColors[color1], p1)
		end
		if color2 ~= 0 then
			if selectColors[color2] == nil then
				selectColors[color2], _ENV = selectColors[color2], selectColors[color2]
			end
			table.insert(selectColors[color2], p2)
		end
		if color == color1 and color1 == color2 then
			_UPVALUE3_ = table.insert
			link, table.insert[1] = table.insert, p1
			link, table.insert[2] = table.insert, p
			link, table.insert[3] = table.insert, p2
			sameColors[color1] = true
		elseif color1 == color2 and color1 ~= 0 then
			sameColors[color1] = true
		elseif color1 ~= color2 then
			findDiff = true
			if color1 ~= 0 then
				diffColors[color1] = true
			end
			if color2 ~= 0 then
				diffColors[color2] = true
			end
		end
	end
	if link then
		for i = 1, self.chessKind do
			if selectColors[i] == nil then
				self.chessboard[self:conv(row, col)] = i
				self.closeList[self:conv(row, col)] = true
				return
			end
		end
		if findDiff then
			local diffColor = 0
			local min = 9
			for key, v in pairs(diffColors) do
				if not sameColors[key] and min > #selectColors[key] then
					min = #selectColors[key]
					diffColor = key
				end
			end
			self.chessboard[self:conv(row, col)] = diffColor
			self.closeList[self:conv(row, col)] = true
			for _, point in ipairs(selectColors[diffColor]) do
				self.closeList[self:conv(point.row, point.col)] = false
				table.insert(self.openList, point)
			end
			return
		end
		if not findDiff then
			selectColors, _ENV = key, key
			for i = 1, self.chessKind do
				if i ~= color then
					table.insert(selectColors, i)
				end
			end
			self.closeList[self:conv(row, col)] = true
			self.chessboard[self:conv(link[1])] = selectColors[math.random(#selectColors)]
			self.chessboard[self:conv(link[3])] = selectColors[math.random(#selectColors)]
			table.insert(self.openList, link[1])
			table.insert(self.openList, link[3])
			self.closeList[self:conv(link[1].row, link[1].col)] = false
			self.closeList[self:conv(link[3].row, link[3].col)] = false
			local samePoints = self:getSamePoint(link[1].row, link[1].col)
			if samePoints then
				for _, point in ipairs(samePoints) do
					self.closeList[self:conv(point.row, point.col)] = false
					table.insert(self.openList, point)
				end
			end
			samePoints = self:getSamePoint(link[3].row, link[3].col)
			if samePoints then
				for _, point in ipairs(samePoints) do
					self.closeList[self:conv(point.row, point.col)] = false
					table.insert(self.openList, point)
				end
			end
			return
		end
	else
		self.closeList[self:conv(row, col)] = true
		if not selectColors[color] then
			local _ENV, points = selectColors[color], selectColors[color]
		end
		for _, point in ipairs(points) do
			table.insert(self.openList, point)
		end
	end
end
function EliminateGameView:conv(row, col)
	if type(row) == "table" then
		return row.row .. "," .. row.col
	end
	return row .. "," .. col
end
function EliminateGameView:swap(p1, p2)
	local color = self.chessboard[self:conv(p1)]
	self.chessboard[self:conv(p1)] = self.chessboard[self:conv(p2)]
	self.chessboard[self:conv(p2)] = color
end
function EliminateGameView:removeLinks()
	_UPVALUE4_, self.emptyList, _ENV = nil, nil, nil
	;(nil)[1] = self.rowChain
	;(nil)[2] = self.colChain
	;(nil)[3] = self.leftSlantChain
	local (nil)[4], chainList = self.rightSlantChain, nil
	for i, chain in ipairs(chainList) do
		for key, linkList in pairs(chain) do
			for j, link in ipairs(linkList) do
				self:removeLink(link)
			end
		end
	end
end
function EliminateGameView:removeLink(link)
	for i, v in ipairs(link) do
		local color = self.chessboard[self:conv(v)]
		if color and color ~= 0 then
			self.chessboard[self:conv(v)] = 0
			_ENV = self
			self.row = v.row
			self.col = v.col
			table.insert(self.emptyList, self)
		end
	end
end
function EliminateGameView:fillEmpty()
	local _ENV, moveList
	for j = 1, self.col do
		local emptyNum = 0
		local _ENV, originRow
		for i = 1, self.row do
			if not originRow[i] then
				originRow[i] = i
			end
			if self.chessboard[self:conv(i, j)] == 0 then
				emptyNum = emptyNum + 1
				for row = i, 2, -1 do
					if self.chessboard[self:conv(row - 1, j)] == 0 then
						break
					end
					self.chessboard[self:conv(row, j)] = self.chessboard[self:conv(row - 1, j)]
					self.chessboard[self:conv(row - 1, j)] = 0
					local tempRow = originRow[row]
					originRow[row] = originRow[row - 1]
					originRow[row - 1] = tempRow
				end
			end
		end
		if 0 < emptyNum then
			for row = self.row, emptyNum + 1, -1 do
				if row ~= originRow[row] then
					_ENV, _UPVALUE2_ = i, -1
					i.row = originRow[row]
					_ENV, i.col = originRow[row], j
					originRow[row].row = row
					originRow[row].col = j
					;(-1)[1] = i
					;(-1)[2] = originRow[row]
					table.insert(moveList, -1)
				end
			end
			for row = 1, emptyNum do
				self.chessboard[self:conv(row, j)] = math.random(self.chessKind)
				_ENV, _UPVALUE2_ = self.chessKind, math.random(self.chessKind)
				self.chessKind.row = row - emptyNum
				_ENV, self.chessKind.col = row - emptyNum, j
				;(row - emptyNum).row = row
				;(row - emptyNum).col = j
				math.random(self.chessKind)[1] = self.chessKind
				math.random(self.chessKind)[2] = row - emptyNum
				table.insert(moveList, (math.random(self.chessKind)))
			end
		end
	end
	return moveList
end
function EliminateGameView:initUI()
	self:adaptUI()
	self.frameTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_node")
	self.frameTitle:setTitle(i18n("activityname_15"))
	self.frameTitle:setBtnHelpClickCallBack(handler(self, self.onHelp))
	self.stepBtn = SoraDGetChildByName(self, "stepBtn")
	self.stepWord = SoraDGetChildByName(self, "stepWord")
	self.stepGoldTip = SoraDGetChildByName(self, "stepGoldTip")
	self.stepGoldIcon = SoraDGetChildByName(self, "stepGoldIcon")
	self.doubleBtn = SoraDGetChildByName(self, "doubleBtn")
	self.doubleTip = SoraDGetChildByName(self, "doubleTip")
	self.doubleGoldTip = SoraDGetChildByName(self, "doubleGoldTip")
	self.doubleGoldIcon = SoraDGetChildByName(self, "doubleGoldIcon")
	self.LoadingBar_exp = SoraDGetChildByName(self, "LoadingBar_exp")
	self.monsterHp = SoraDGetChildByName(self, "monsterHp")
	self.hpBarMask = SoraDGetChildByName(self, "hpBarMask")
	self.hpPoint = SoraDGetChildByName(self, "hpPoint")
	self.touchMask = SoraDGetChildByName(self, "touchMask")
	self.topNode = SoraDGetChildByName(self, "Top_Node")
	self.hpNode = SoraDGetChildByName(self, "hpNode")
	self.monster = SoraDGetChildByName(self, "node_monster")
	self.layout = SoraDGetChildByName(self, "panel_chessboard")
	self.retryBtn = SoraDGetChildByName(self, "Button_replay")
	self.btnAward = SoraDGetChildByName(self, "Button_award")
	self.bgMonster = SoraDGetChildByName(self, "bg_monster")
	self.txtMonsterLv = SoraDGetChildByName(self, "txt_monster_lv")
	self.nodeMiddle = SoraDGetChildByName(self, "Node_Middle")
	self.nodeMain = SoraDGetChildByName(self, "Node_main")
	self.nodeMonsterInfo = SoraDGetChildByName(self, "node_monster_info")
	self.Node_bar = SoraDGetChildByName(self, "Node_bar")
	self.stepTip = SoraDGetChildByName(self, "stepTip")
	self.Text_replay = SoraDGetChildByName(self, "Text_replay")
	self.Node_stepGold = SoraDGetChildByName(self, "Node_stepGold")
	self.Node_doubleGold = SoraDGetChildByName(self, "Node_doubleGold")
	self.Bottom_Node = SoraDGetChildByName(self, "Bottom_Node")
	local effect_normal = SoraDGetChildByName(self, "effect_normal")
	local effect = SoraDCreatAnimation("gwdzz_normal")
	effect:addTo(effect_normal)
	self.et_btn_double = SoraDGetChildByName(effect, "Node_double")
	self.et_btn_double:setVisible(false)
	self.boomNode, _ENV, self.shootNode, _ENV = self.et_btn_double.setVisible, self.et_btn_double.setVisible, self.et_btn_double.setVisible, self.et_btn_double.setVisible
	for i = 1, 3 do
		self.shootNode[i] = SoraDGetChildByName(self, "shootPoint" .. i)
		self.boomNode[i] = SoraDGetChildByName(self, "boom" .. i)
	end
	self.stepWord:setString(self.stepNum)
	self:layoutChessboard()
	self.touchMask:setTouchEnabled(false)
	self.doubleBtn:addTouchEventListener(handler(self, self.onDouble))
	self.stepBtn:addTouchEventListener(handler(self, self.onStep))
	self.retryBtn:addTouchEventListener(handler(self, self.onRetry))
	self.btnAward:addTouchEventListener(handler(self, self.onBtnAward))
	self.stepTip:setString(i18n("common_text_2545"))
	self.Text_replay:setString(i18n("common_text_2541"))
	_ENV, _ENV = self.Text_replay, self.Text_replay.setString
	_ENV, self.Text_replay.plist = i18n("common_text_2541")
	i18n("common_text_2541").x = 30
	_ENV, self.Text_replay.pos, i18n("common_text_2541").y = i18n("common_text_2541")
	i18n("common_text_2541").x = 4
	self.Text_replay.scale, i18n("common_text_2541").y = i18n("common_text_2541")
	self.Text_replay.setString[1], self.Text_replay.rotate = self.Text_replay, -15
	local effectParam = self.Text_replay.setString
	local effectNode = SoraDCreateEffectNode(effectParam)
	effectNode:addTo(self.Panel_monster, -1)
	effectNode:setPosition(self.Panel_monster:getContentSize().width / 2, 0)
	self:updateUI()
end
function EliminateGameView:addSize(widget, addSize)
	local size = widget:getContentSize()
	size.width = size.width + addSize.width
	size.height = size.height + addSize.height
	widget:setContentSize(size)
end
function EliminateGameView:adaptUI()
	self.deltaHeight = 0
	self.deltaTopHeight = 0
	self.deltaBottomHeight = 0
	self.scale = 1
	self.chessScale = 1
end
function EliminateGameView:updateUI()
	self.stepWord:setString(self.stepNum)
	if self.stepNum == 0 then
		self:stepZeroEffect()
	else
		self:stepZeroEffect(true)
	end
	if self.stepNum <= 3 and self.stepNum > 0 then
		self:stepLessEffect()
	else
		self:stepLessEffect(true)
	end
	if self.mulNum > 1 then
		self:doubleAttackEffect()
		self:doubleChessEffect()
		if not self.soundLightning then
			self.soundLightning = AudioEngine.playEffect(getAudioFileNameByPlatform("game_chargeLightning", "Sound"), true)
		end
	else
		self:doubleAttackEffect(true)
		self:doubleChessEffect(true)
		if self.soundLightning then
			AudioEngine.stopEffect(self.soundLightning)
			self.soundLightning = nil
		end
	end
	local curDoubles = siegeCombatCtrl:getCurDoubles()
	if curDoubles < 1 then
		self.doubleTip:setVisible(false)
		self.Node_doubleGold:setVisible(true)
		self.doubleGoldTip:setString(eliminateGameCommon.getDoubleCost())
		SoraDToCenter(self.Node_doubleGold)
	else
		_ENV = eliminateGameCommon.getDoubleCost()
		eliminateGameCommon.getDoubleCost().times = curDoubles
		self.doubleTip:setString(i18n("common_text_2544", eliminateGameCommon.getDoubleCost()))
		self.doubleTip:setVisible(true)
		self.Node_doubleGold:setVisible(false)
	end
	if self.stepNum > 0 then
		self.stepTip:setString(i18n("common_text_2545"))
		self.stepTip:setVisible(true)
		self.Node_stepGold:setVisible(false)
	else
		self.stepTip:setVisible(false)
		self.Node_stepGold:setVisible(true)
		self.stepGoldTip:setString(siegeCombatCtrl:getStepsCost())
		SoraDToCenter(self.Node_stepGold, 0)
	end
end
function EliminateGameView:initData(data)
	self.levelConfig = require("app." .. LocalTblPath .. ".config_client.attack_activity_config_data")
	self.enterCostConfig = require("app." .. LocalTblPath .. ".config_server.attack_activity_enter")
	self.doubleCostConfig = require("app." .. LocalTblPath .. ".config_server.attack_activity_exp")
	self.stepCostConfig = require("app." .. LocalTblPath .. ".config_server.attack_activity_step")
	self.monsterAreaConfig = require("app." .. LocalTblPath .. ".config_client.attack_monster_area_cfg")
	self.atkHarmConfig = require("app." .. LocalTblPath .. ".config_server.attack_activity_harm")
	_ENV, self.firstFightConfig = require("app." .. LocalTblPath .. ".config_client.attack_monster_first_fight"), require("app." .. LocalTblPath .. ".config_client.attack_monster_first_fight")
	require("app." .. LocalTblPath .. ".config_client.attack_monster_first_fight")[4] = self.atkHarmConfig[4].harm or 2000
	self.atkConfig, require("app." .. LocalTblPath .. ".config_client.attack_monster_first_fight")[5] = require("app." .. LocalTblPath .. ".config_client.attack_monster_first_fight"), self.atkHarmConfig[5].harm or 3000
	if data then
		self.level = data.level or 1
		self.stepNum = data.mysteps or 30
		if data.atkPlusID ~= 0 then
			self.mulNum = 2
		else
			self.mulNum = 1
		end
	end
	self.totalHP = self.levelConfig[self.level].score
	self.curHP = self.totalHP
	self:loadData(data)
end
function EliminateGameView:saveData(isExit)
	_ENV = nil
	;(nil).level = self.level
	local (nil).chessboard, data = self.chessboard, nil
	if isExit then
		data, _ENV = self.chessboard, self.chessboard
	end
	local key = "Game:EliminateGameView:saveData~table"
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet(key, data, nil)
end
function EliminateGameView:checkValid(chessboard)
	for i = 1, self.row do
		for j = 1, self.col do
			local color = chessboard[self:conv(i, j)]
			if not (color and 1 <= color) or not (color <= self.chessKind) then
				return false
			end
		end
	end
	return true
end
function EliminateGameView:loadData(serverData)
	local key = "Game:EliminateGameView:saveData~table"
	_ENV = nil
	;(nil).byUID = true
	local data = SoraDConfigGet(key, nil)
	local guideStep = SoraDIsGameGuide()
	local isFirstFight = guideStep == 18001
	if isFirstFight then
		self:initFirstFightChessboard()
	elseif data and data.level and data.level == self.level and data.chessboard and self:checkValid(data.chessboard) then
		self.chessboard = data.chessboard
	else
		self:initChessboard()
	end
	self:initUI()
	self:enterLevel(self.level)
	if data and data.hp and data.damageList then
		self.curHP = data.hp
		siegeCombatCtrl:sendDamageList(data.damageList)
	else
		self.curHP = serverData.hp or self.totalHP
	end
	self.curHpPercent = self.curHP / self.totalHP
	self:_updateHpBar(self.curHpPercent)
end
function EliminateGameView:calculateAtk()
	local atk = 0
	local _ENV, cache
	local _UPVALUE4_, _ENV, list
	;(nil)[1] = self.rowChain
	;(nil)[2] = self.colChain
	;(nil)[3] = self.leftSlantChain
	local (nil)[4], chainList = self.rightSlantChain, nil
	for i, chain in ipairs(chainList) do
		for num, linkList in pairs(chain) do
			for j, link in ipairs(linkList) do
				table.insert(list, num)
			end
		end
	end
	for i, v in ipairs(list) do
		atk = atk + self.atkConfig[v]
		table.insert(self.atkDetail, v)
	end
	return atk
end
function EliminateGameView:createFireStone()
	_ENV = nil
	_ENV, (nil).plist = nil, "Particle/et_gongchenghp_01.plist"
	;(nil).x = 4
	_ENV, (nil).pos, (nil).y = nil, nil, 3
	;(nil).x = 0.45
	;(nil).scale, (nil).y = nil, 0.8
	;(nil).rotate = 180
	local particle1 = util.createParticle(nil)
	_ENV = nil
	_ENV, (nil).plist = nil, "Particle/et_gongchenghp_02.plist"
	;(nil).x = 0
	_ENV, (nil).pos, (nil).y = nil, nil, 0
	;(nil).x = 0.14
	;(nil).scale, (nil).y = nil, 0.14
	local particle2 = util.createParticle(nil)
	_ENV = nil
	_ENV, (nil).plist = nil, "Particle/et_gongchenghp_03.plist"
	;(nil).x = 0
	_ENV, (nil).pos, (nil).y = nil, nil, 0
	;(nil).x = 0.45
	;(nil).scale, (nil).y = nil, 0.8
	;(nil).rotate = 180
	local particle3 = util.createParticle(nil)
	_ENV = nil
	_ENV, (nil).plist = nil, "Particle/et_gongchenghp_04.plist"
	;(nil).x = 0
	_ENV, (nil).pos, (nil).y = nil, nil, 0
	;(nil).x = 0.18
	;(nil).scale, (nil).y = nil, 0.18
	local particle4 = util.createParticle(nil)
	local node = cc.Node:create()
	node:addChild(particle1)
	node:addChild(particle2)
	node:addChild(particle3)
	node:addChild(particle4)
	return node
end
function EliminateGameView:playAttack(atk, moveTime, attackTime)
	do return end
	local num = 1
	if 8000 <= atk then
		num = 3
	elseif 4000 <= atk then
		num = 2
	end
	for i = 1, num do
		do
			local batteryNode = self.batteryNode[i]
			local beginPos = cc.p(self.shootNode[i]:getPosition())
			local endPos = cc.p(self.boomNode[i]:getPosition())
			beginPos = self.batteryNode[i]:convertToWorldSpace(beginPos)
			endPos = self.tower:convertToWorldSpace(endPos)
			local speed = cc.pGetDistance(beginPos, endPos) / attackTime
			local sprite = self:createFireStone()
			sprite:setPosition(beginPos)
			sprite:setVisible(false)
			self:addChild(sprite, 999)
			local cb = function()
				local node = cc.Node:create()
				_ENV = nil
				_ENV, (nil).plist = nil, "Particle/et_paotaijizhong_01.plist"
				;(nil).x = 0
				_ENV, (nil).pos, (nil).y = nil, nil, 0
				;(nil).x = 1.5
				;(nil).scale, (nil).y = nil, 1.5
				local particle1 = util.createParticle(nil)
				_ENV = nil
				_ENV, (nil).plist = nil, "Particle/et_paotaijizhong_02.plist"
				;(nil).x = 0
				_ENV, (nil).pos, (nil).y = nil, nil, 0
				;(nil).x = 1.5
				;(nil).scale, (nil).y = nil, 1.5
				local particle2 = util.createParticle(nil)
				particle1:setAutoRemoveOnFinish(true)
				particle2:setAutoRemoveOnFinish(true)
				node:addChild(particle1)
				node:addChild(particle2)
				node:setPosition(endPos)
				sprite:removeFromParent(true)
				self:addChild(node, 999)
				endPos = 999
				;(999)[1] = cca.moveBy(moveTime / 2, cc.p(20, 0))
				;(999)[2] = cca.moveBy(moveTime / 2, cc.p(-20, 0))
				;(999)[3] = cca.moveBy(moveTime / 2, cc.p(-20, 0))
				;(999)[4] = cca.moveBy(moveTime / 2, cc.p(-20, 0))
				;(999)[5] = cca.moveBy(moveTime / 2, cc.p(-20, 0))
				;(999)[6] = cca.moveBy(moveTime / 2, cc.p(-20, 0))
				self.tower:runAction(cca.seq(999))
			end
			_UPVALUE2_ = self.boomNode[i]:getPosition()
			self.boomNode[i]:getPosition()[1] = cca.moveBy(moveTime / 2, cc.p(20, 0))
			self.boomNode[i]:getPosition()[2] = cca.moveBy(moveTime / 2, cc.p(-20, 0))
			self.boomNode[i]:getPosition()[3] = cca.callFunc(function()
				_ENV = nil
				_ENV, (nil).plist = nil, "Particle/et_gongchenghp_05.plist"
				;(nil).x = -4
				_ENV, (nil).pos, (nil).y = nil, nil, -2
				;(nil).x = 3
				;(nil).scale, (nil).y = nil, 3
				local particle5 = util.createParticle(nil)
				sprite:setVisible(true)
				sprite:addChild(particle5)
				worldMapFunction.createThrowAction(sprite, beginPos, endPos, 0, speed, cb)
			end)
			self.boomNode[i]:getPosition()[4] = cca.callFunc(function()
				_ENV = nil
				_ENV, (nil).plist = nil, "Particle/et_gongchenghp_05.plist"
				;(nil).x = -4
				_ENV, (nil).pos, (nil).y = nil, nil, -2
				;(nil).x = 3
				;(nil).scale, (nil).y = nil, 3
				local particle5 = util.createParticle(nil)
				sprite:setVisible(true)
				sprite:addChild(particle5)
				worldMapFunction.createThrowAction(sprite, beginPos, endPos, 0, speed, cb)
			end)
			self.boomNode[i]:getPosition()[5] = cca.callFunc(function()
				_ENV = nil
				_ENV, (nil).plist = nil, "Particle/et_gongchenghp_05.plist"
				;(nil).x = -4
				_ENV, (nil).pos, (nil).y = nil, nil, -2
				;(nil).x = 3
				;(nil).scale, (nil).y = nil, 3
				local particle5 = util.createParticle(nil)
				sprite:setVisible(true)
				sprite:addChild(particle5)
				worldMapFunction.createThrowAction(sprite, beginPos, endPos, 0, speed, cb)
			end)
			self.boomNode[i]:getPosition()[6] = cca.callFunc(function()
				_ENV = nil
				_ENV, (nil).plist = nil, "Particle/et_gongchenghp_05.plist"
				;(nil).x = -4
				_ENV, (nil).pos, (nil).y = nil, nil, -2
				;(nil).x = 3
				;(nil).scale, (nil).y = nil, 3
				local particle5 = util.createParticle(nil)
				sprite:setVisible(true)
				sprite:addChild(particle5)
				worldMapFunction.createThrowAction(sprite, beginPos, endPos, 0, speed, cb)
			end)
			batteryNode:runAction(cca.seq(self.boomNode[i]:getPosition()))
			SoraDPlaySound("elimiateGame", 3)
		end
	end
end
function EliminateGameView:enterLevel(level)
	self.level = level
	self:initMonster(self.level)
	self.totalHP = self.levelConfig[self.level].score
	self.atkDetail, _ENV, self.damageList, _ENV, self.curHP = self.totalHP, self.totalHP, self.totalHP, self.totalHP, self.totalHP
	self:setHpBar(1)
	_ENV = nil
	;(nil).lv = self.level
	self.txtMonsterLv:setString(i18n("common_text_100", nil))
end
function EliminateGameView:initMonster(level)
	local monsterImg = self.levelConfig[self.level].monster
	if self.preMonster and self.preMonster == monsterImg then
		return
	end
	self.preMonster = monsterImg
	local _ENV, config = self.preMonster, self.preMonster
	if display.height <= 900 then
		_ENV, _ENV = nil, display.height
		_ENV, display.height["gwdzz_b_bust.png"], (nil).pos = nil, nil, cc.p(0, -20)
		_ENV, display.height["gwdzz_anbs_bust.png"], (nil).pos = nil, nil, cc.p(0, -20)
		_ENV, display.height["gwdzz_bjlsk_bust.png"], (nil).pos = nil, nil, cc.p(0, 0)
		config, display.height["gwdzz_bhnt_bust.png"], (nil).pos = display.height, nil, cc.p(0, -20)
	elseif display.height <= 960 then
		_ENV, _ENV = nil, display.height
		;(nil).pos = cc.p(0, -10)
		_ENV, display.height["gwdzz_b_bust.png"], (nil).scale = nil, nil, 1
		;(nil).pos = cc.p(0, -10)
		_ENV, display.height["gwdzz_anbs_bust.png"], (nil).scale = nil, nil, 1
		;(nil).pos = cc.p(0, 0)
		_ENV, display.height["gwdzz_bjlsk_bust.png"], (nil).scale = nil, nil, 1.1
		;(nil).pos = cc.p(0, -20)
		config, display.height["gwdzz_bhnt_bust.png"], (nil).scale = display.height, nil, 1.1
	elseif display.height > 1200 then
		_ENV, _ENV = nil, display.height
		_ENV, display.height["gwdzz_b_bust.png"], (nil).pos = nil, nil, cc.p(0, 40)
		_ENV, display.height["gwdzz_anbs_bust.png"], (nil).pos = nil, nil, cc.p(0, 20)
		;(nil).pos = cc.p(0, 30)
		_ENV, display.height["gwdzz_bjlsk_bust.png"], (nil).scale = nil, nil, 0.9
		;(nil).pos = cc.p(0, 0)
		config, display.height["gwdzz_bhnt_bust.png"], (nil).scale = display.height, nil, 1.0
	end
	local data = config[monsterImg]
	if data then
		local pos = cc.p(self.Panel_monster:getContentSize().width / 2 + data.pos.x, data.pos.y)
		self.monster:setPosition(pos)
		if data.scale then
			self.monster:setScale(data.scale)
		end
	end
	self.monster:ignoreContentAdaptWithSize(true)
	self.monster:loadTexture(monsterImg, ccui.TextureResType.plistType)
	self.monster:setVisible(false)
	if self.spine_npc then
		if self.spine_npc.animShaker then
			self.spine_npc.animShaker:stop()
			self.spine_npc.animShaker = nil
		end
		self.spine_npc:removeFromParent()
		self.spine_npc = nil
	end
	local _ENV, config = self.spine_npc.removeFromParent, self.spine_npc.removeFromParent
	if display.height <= 900 then
		_ENV, _ENV = false, display.height
		_ENV, display.height["gwdzz_b_bust.png"], (false).pos = false, false, cc.p(0, -20)
		_ENV, display.height["gwdzz_anbs_bust.png"], (false).pos = false, false, cc.p(0, 25)
		_ENV, display.height["gwdzz_bjlsk_bust.png"], (false).pos = false, false, cc.p(0, 40)
		config, display.height["gwdzz_bhnt_bust.png"], (false).pos = display.height, false, cc.p(0, 35)
	elseif display.height <= 960 then
		_ENV, _ENV = false, display.height
		;(false).pos = cc.p(0, -10)
		_ENV, display.height["gwdzz_b_bust.png"], (false).scale = false, false, 1
		;(false).pos = cc.p(0, 40)
		_ENV, display.height["gwdzz_anbs_bust.png"], (false).scale = false, false, 1
		;(false).pos = cc.p(0, 40)
		_ENV, display.height["gwdzz_bjlsk_bust.png"], (false).scale = false, false, 1.1
		;(false).pos = cc.p(0, 40)
		config, display.height["gwdzz_bhnt_bust.png"], (false).scale = display.height, false, 1.1
	elseif display.height <= 1200 then
		_ENV, _ENV = false, display.height
		_ENV, display.height["gwdzz_b_bust.png"], (false).pos = false, false, cc.p(0, 0)
		_ENV, display.height["gwdzz_anbs_bust.png"], (false).pos = false, false, cc.p(0, 40)
		_ENV, display.height["gwdzz_bjlsk_bust.png"], (false).pos = false, false, cc.p(0, 40)
		config, display.height["gwdzz_bhnt_bust.png"], (false).pos = display.height, false, cc.p(0, 50)
	elseif display.height > 1200 then
		_ENV, _ENV = false, display.height
		_ENV, display.height["gwdzz_b_bust.png"], (false).pos = false, false, cc.p(0, 40)
		_ENV, display.height["gwdzz_anbs_bust.png"], (false).pos = false, false, cc.p(0, 65)
		;(false).pos = cc.p(0, 70)
		_ENV, display.height["gwdzz_bjlsk_bust.png"], (false).scale = false, false, 0.9
		;(false).pos = cc.p(0, 65)
		config, display.height["gwdzz_bhnt_bust.png"], (false).scale = display.height, false, 1.0
	end
	local data = config[monsterImg]
	_ENV, _ENV = cc.p(0, 65), false
	cc.p(0, 65).skel = "spine/gwdzz_b_bust.skel"
	_ENV, (false)["gwdzz_b_bust.png"], cc.p(0, 65).atlas = cc.p(0, 65), cc.p(0, 65), "spine/gwdzz_b_bust.atlas"
	cc.p(0, 65).skel = "spine/gwdzz_anubisi.skel"
	_ENV, (false)["gwdzz_anbs_bust.png"], cc.p(0, 65).atlas = cc.p(0, 65), cc.p(0, 65), "spine/gwdzz_anubisi.atlas"
	cc.p(0, 65).skel = "spine/gwdzz_bajilisike.skel"
	_ENV, (false)["gwdzz_bjlsk_bust.png"], cc.p(0, 65).atlas = cc.p(0, 65), cc.p(0, 65), "spine/gwdzz_bajilisike.atlas"
	cc.p(0, 65).skel = "spine/gwdzz_shendeng.skel"
	;(false)["gwdzz_bhnt_bust.png"], cc.p(0, 65).atlas = cc.p(0, 65), "spine/gwdzz_shendeng.atlas"
	local spineConfig = false
	local spine_npc = sp.SkeletonAnimation:create(spineConfig[monsterImg].skel, spineConfig[monsterImg].atlas, 1)
	spine_npc:setAnimation(0, "animation", true)
	spine_npc:setScale(0.8)
	if data then
		local pos = cc.p(self.Panel_monster:getContentSize().width / 2 + data.pos.x, data.pos.y)
		spine_npc:setPosition(pos)
		if data.scale then
			spine_npc:setScale(data.scale)
		end
	else
		spine_npc:setPosition(cc.p(self.Panel_monster:getContentSize().width / 2, 0))
	end
	spine_npc:addTo(self.Panel_monster)
	self.spine_npc = spine_npc
end
function EliminateGameView:updateStep()
	self:scanLinks()
	self:removeLinks()
	if #self.emptyList > 0 then
		self.touchMask:setTouchEnabled(true)
		self.doubleBtn:setTouchEnabled(false)
		_UPVALUE5_ = self.doubleBtn
		self.doubleBtn[1] = cca.callFunc(function()
			self:playDispose(0.5)
		end)
		self.doubleBtn[2] = cca.delay(0.5)
		self.doubleBtn[3] = cca.callFunc(function()
			local moveList = self:fillEmpty()
			self:fillChessboard(moveList, 0.3)
		end)
		self.doubleBtn[4] = cca.delay(0.3)
		self.doubleBtn[5] = cca.callFunc(function()
			self.atk = self.atk + self:calculateAtk()
		end)
		self.doubleBtn[6] = cca.callFunc(function()
			self:updateStep()
		end)
		self.doubleBtn[7] = cca.callFunc(function()
			self:updateStep()
		end)
		local action = cca.seq(self.doubleBtn)
		self:runAction(action)
	elseif 0 < self.atk then
		self:saveData()
		_ENV = self
		self.atkDetail = self.atkDetail
		siegeCombatCtrl:sendAttackDetail(self)
		self.atkDetail, _ENV = siegeCombatCtrl.sendAttackDetail, siegeCombatCtrl.sendAttackDetail
		self:playAttack(self.atk, 0.2, 0.7)
		self.atk = 0
		self.playHurtFinish = false
		siegeCombatCtrl = 0.2
		;(0.2)[1] = cca.delay(0.5)
		;(0.2)[2] = cca.callFunc(function()
			self.playHurtFinish = true
			self:playHurt()
			self.touchMask:setTouchEnabled(false)
			self.doubleBtn:setTouchEnabled(true)
		end)
		;(0.2)[3] = cca.callFunc(function()
			self.playHurtFinish = true
			self:playHurt()
			self.touchMask:setTouchEnabled(false)
			self.doubleBtn:setTouchEnabled(true)
		end)
		;(0.2)[4] = cca.callFunc(function()
			self.playHurtFinish = true
			self:playHurt()
			self.touchMask:setTouchEnabled(false)
			self.doubleBtn:setTouchEnabled(true)
		end)
		;(0.2)[5] = cca.callFunc(function()
			self.playHurtFinish = true
			self:playHurt()
			self.touchMask:setTouchEnabled(false)
			self.doubleBtn:setTouchEnabled(true)
		end)
		self:runAction(cca.seq(0.2))
	else
		self.touchMask:setTouchEnabled(false)
		self.doubleBtn:setTouchEnabled(true)
		self:saveData()
	end
end
function EliminateGameView:createChess(color)
	_UPVALUE4_ = nil
	;(nil)[1] = "icon_attack_monster_red.png"
	;(nil)[2] = "icon_attack_monster_yellow.png"
	;(nil)[3] = "icon_attack_monster_purple.png"
	local (nil)[4], icons = "icon_attack_monster_green.png", nil
	local chess = display.newSprite("#" .. icons[color])
	chess.color = color
	chess:setScale(self.chessScale)
	self.layout:addChild(chess)
	util.addTouch(chess, handler(self, self.touch))
	return chess
end
function EliminateGameView:layoutChessboard()
	_UPVALUE4_ = nil
	;(nil)[1] = "icon_attack_monster_red.png"
	;(nil)[2] = "icon_attack_monster_yellow.png"
	;(nil)[3] = "icon_attack_monster_purple.png"
	local (nil)[4], icons = "icon_attack_monster_green.png", nil
	local chess
	for i = 1, self.row do
		for j = 1, self.col do
			if not self.chessList[self:conv(i, j)] then
				chess = self:createChess(self.chessboard[self:conv(i, j)])
				self.chessList[self:conv(i, j)] = chess
			else
				chess = self.chessList[self:conv(i, j)]
				chess:setSpriteFrame(icons[self.chessboard[self:conv(i, j)]])
				chess.color = self.chessboard[self:conv(i, j)]
			end
			_ENV = self.chessboard[self:conv(i, j)]
			self.chessboard[self:conv(i, j)].row = i
			chess.point, self.chessboard[self:conv(i, j)].col = self.chessboard[self:conv(i, j)], j
			chess:setPosition(self:convertToPos(chess.point))
		end
	end
	if self.isBlackChessBoardInit == nil then
		local size = self.layout:getContentSize()
		local cellSize = cc.size(size.width / self.col, size.height / self.row)
		for i = 1, self.row do
			for j = 1, self.col do
				local isBlack = false
				if i % 2 == 1 and j % 2 == 1 or i % 2 == 0 and j % 2 == 0 then
					local blackChessBg = display.newSprite("#frame_gwdzz_04.png")
					blackChessBg:addTo(self.layout, -2)
					blackChessBg:setPosition(self:convertToPos(i, j))
					blackChessBg:setScale(cellSize.width / blackChessBg:getContentSize().width)
				end
			end
		end
		self.isBlackChessBoardInit = true
	end
	self.layout:stopAllActions()
	local posy = self.layout:getPositionY()
	self.layout:setPositionY(-self.layout:getContentSize().height)
	_ENV = self.layout
	self.layout[1] = cca.moveTo(0.25, self.layout:getPositionX(), posy)
	self.layout[2] = cca.moveTo(0.25, self.layout:getPositionX(), posy)
	self.layout[3] = cca.moveTo(0.25, self.layout:getPositionX(), posy)
	self.layout[4] = cca.moveTo(0.25, self.layout:getPositionX(), posy)
	self.layout[5] = cca.moveTo(0.25, self.layout:getPositionX(), posy)
	self.layout[6] = cca.moveTo(0.25, self.layout:getPositionX(), posy)
	self.layout[7] = cca.moveTo(0.25, self.layout:getPositionX(), posy)
	self.layout[8] = cca.moveTo(0.25, self.layout:getPositionX(), posy)
	self.layout[9] = cca.moveTo(0.25, self.layout:getPositionX(), posy)
	self.layout[10] = cca.moveTo(0.25, self.layout:getPositionX(), posy)
	self.layout[11] = cca.moveTo(0.25, self.layout:getPositionX(), posy)
	self.layout[12] = cca.moveTo(0.25, self.layout:getPositionX(), posy)
	self.layout[13] = cca.moveTo(0.25, self.layout:getPositionX(), posy)
	self.layout:runAction(cca.seq(self.layout))
end
function EliminateGameView:convertToPos(row, col)
	local rowNum, colNum
	if type(row) == "table" then
		rowNum = row.row
		colNum = row.col
	else
		rowNum = row
		colNum = col
	end
	local size = self.layout:getContentSize()
	local cellSize = cc.size(size.width / self.col, size.height / self.row)
	local x = cellSize.width * colNum - cellSize.width / 2
	local y = cellSize.height * rowNum - cellSize.height / 2
	return cc.p(x, size.height - y)
end
function EliminateGameView:isNeighbour(p1, p2)
	if math.abs(p1.row - p2.row) <= 1 and 1 >= math.abs(p1.col - p2.col) then
		return true
	else
		return false
	end
end
function EliminateGameView:touch(sender, type, pos)
	if type == ccui.TouchEventType.began then
		self.isMoved = false
		self.touchBeginPos = pos
		if self.curChess and self.curChess == sender then
			self.curChess:stopAllActions()
			self.curChess = nil
		elseif self.curChess == nil then
			Swap_Distance_Value = nil
			;(nil)[1] = cca.rotateTo(0.6, 15)
			;(nil)[2] = cca.rotateTo(0.6, -15)
			;(nil)[3] = cca.rotateTo(0.6, -15)
			;(nil)[4] = cca.rotateTo(0.6, -15)
			;(nil)[5] = cca.rotateTo(0.6, -15)
			;(nil)[6] = cca.rotateTo(0.6, -15)
			;(nil)[7] = cca.rotateTo(0.6, -15)
			sender:runAction(cca.repeatForever(cca.seq(nil)))
			self.curChess = sender
		elseif self:isNeighbour(self.curChess.point, sender.point) then
			self.curChess:stopAllActions()
			self:swapChess(sender, self.curChess)
			self.curChess = nil
		else
			self.curChess:stopAllActions()
			Swap_Distance_Value = cca.repeatForever(cca.seq(nil))
			cca.repeatForever(cca.seq(nil))[1] = cca.rotateTo(0.6, 15)
			cca.repeatForever(cca.seq(nil))[2] = cca.rotateTo(0.6, -15)
			cca.repeatForever(cca.seq(nil))[3] = cca.rotateTo(0.6, -15)
			cca.repeatForever(cca.seq(nil))[4] = cca.rotateTo(0.6, -15)
			cca.repeatForever(cca.seq(nil))[5] = cca.rotateTo(0.6, -15)
			cca.repeatForever(cca.seq(nil))[6] = cca.rotateTo(0.6, -15)
			cca.repeatForever(cca.seq(nil))[7] = cca.rotateTo(0.6, -15)
			sender:runAction(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(nil)))))
			self.curChess = sender
		end
	elseif type == ccui.TouchEventType.moved and self.curChess == sender then
		self.touchMovePos = pos
		local touchBeganPoint = self.touchBeginPos
		local touchMovePoint = self.touchMovePos
		local distance = cc.pGetDistance(touchBeganPoint, touchMovePoint)
		if tonumber(distance) < Swap_Distance_Value then
			return
		end
		local angle = SoraDGetAngleByPos(touchBeganPoint, touchMovePoint)
		local direction = self:judgeDirection(angle)
		if direction == SwapDirection.NONE then
			return
		end
		local dstVec = AngleSec[direction].directionVec
		local dst
		_ENV = cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(nil))))
		cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(nil)))).row = dstVec[1] + sender.point.row
		dst, cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(nil)))).col = cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(nil))))
		local chess = self.chessList[self:conv(dst.row, dst.col)]
		if util.hitTest(chess, pos) then
			self.curChess:stopAllActions()
			self:swapChess(sender, chess)
			self.curChess = nil
			return
		end
	end
end
function EliminateGameView:swapChess(chess1, chess2)
	if self.stepNum < 1 then
		self:buyStepBox()
		return
	end
	if SoraDIsGameGuide() == 18001 then
		local spriteHand = SoraDGetChildByName(self, "spriteHand")
		if spriteHand then
			spriteHand:stopAllActions()
			spriteHand:removeFromParent()
		end
		_ENV = spriteHand
		spriteHand.msg = "MESSAGE_SERVER_GUIDE_STEP_END"
		spriteHand.step = 18001
		SoraDSendMessage(spriteHand)
	end
	self.touchMask:setTouchEnabled(true)
	siegeCombatCtrl:sendUseStep()
	self.stepNum = self.stepNum - 1
	self.stepWord:setString(self.stepNum)
	local pos1 = cc.p(chess1:getPosition())
	local pos2 = cc.p(chess2:getPosition())
	local point = chess1.point
	local moveTime = 0.2
	chess1.point = chess2.point
	chess2.point = point
	self.chessList[self:conv(chess1.point)] = chess1
	self.chessList[self:conv(chess2.point)] = chess2
	chess1:runAction(cca.moveTo(moveTime, pos2))
	chess1:runAction(cca.rotateTo(moveTime, 0))
	chess2:runAction(cca.moveTo(moveTime, pos1))
	chess2:runAction(cca.rotateTo(moveTime, 0))
	siegeCombatCtrl = cca.rotateTo(moveTime, 0)
	cca.rotateTo(moveTime, 0)[1] = cca.delay(moveTime)
	cca.rotateTo(moveTime, 0)[2] = cca.callFunc(function()
		self:swap(chess1.point, chess2.point)
		self.touchMask:setTouchEnabled(false)
		self:updateStep()
	end)
	cca.rotateTo(moveTime, 0)[3] = cca.callFunc(function()
		self:swap(chess1.point, chess2.point)
		self.touchMask:setTouchEnabled(false)
		self:updateStep()
	end)
	self:runAction(cca.seq(cca.rotateTo(moveTime, 0)))
	SoraDPlaySound("elimiateGame", 1)
	self:updateUI()
end
function EliminateGameView:fillChessboard(moveList, time)
	local chess, pos
	for i, v in ipairs(moveList) do
		if not self.chessList[self:conv(v[1])] then
			chess = self:createChess(self.chessboard[self:conv(v[2])])
			pos = self:convertToPos(v[2])
			chess:setPosition(self:convertToPos(v[1]))
			chess:runAction(cca.moveTo(time, pos))
			chess.point = v[2]
			self.chessList[self:conv(v[2])] = chess
		else
			chess = self.chessList[self:conv(v[1])]
			pos = self:convertToPos(v[2])
			chess:runAction(cca.moveTo(time, pos))
			chess.point = v[2]
			self.chessList[self:conv(v[2])] = chess
		end
	end
end
function EliminateGameView:playDispose(time)
	for i, v in ipairs(self.emptyList) do
		local chess = self.chessList[self:conv(v)]
		local effect = self:getDisposeEffectSingle()
		effect:setPosition(cc.p(chess:getPosition()))
		effect.showColor(chess.color)
		_UPVALUE1_ = cc.p(chess:getPosition())
		cc.p(chess:getPosition())[1] = cca.delay(0.8833333333333333)
		cc.p(chess:getPosition())[2] = cca.callFunc(function()
			effect.recycleSingle()
		end)
		cc.p(chess:getPosition())[3] = cca.callFunc(function()
			effect.recycleSingle()
		end)
		effect:runAction(cca.seq(cc.p(chess:getPosition())))
		chess:removeFromParent(true)
		SoraDPlaySound("elimiateGame", 2)
	end
	_UPVALUE3_ = nil
	;(nil)[1] = cca.delay(0.5)
	;(nil)[2] = cca.callFunc(function()
		self:showMonsterEffect(self.monster)
	end)
	;(nil)[3] = cca.delay(0.16666666666666666)
	;(nil)[4] = cca.callFunc(function()
		self = nil
		;(nil).diff_max = 10
		;(nil).interval = 0.01
		self:shakeEffect(self.spine_npc, 0.5, nil)
	end)
	;(nil)[5] = cca.callFunc(function()
		self = nil
		;(nil).diff_max = 10
		;(nil).interval = 0.01
		self:shakeEffect(self.spine_npc, 0.5, nil)
	end)
	;(nil)[6] = cca.callFunc(function()
		self = nil
		;(nil).diff_max = 10
		;(nil).interval = 0.01
		self:shakeEffect(self.spine_npc, 0.5, nil)
	end)
	;(nil)[7] = cca.callFunc(function()
		self = nil
		;(nil).diff_max = 10
		;(nil).interval = 0.01
		self:shakeEffect(self.spine_npc, 0.5, nil)
	end)
	;(nil)[8] = cca.callFunc(function()
		self = nil
		;(nil).diff_max = 10
		;(nil).interval = 0.01
		self:shakeEffect(self.spine_npc, 0.5, nil)
	end)
	;(nil)[9] = cca.callFunc(function()
		self = nil
		;(nil).diff_max = 10
		;(nil).interval = 0.01
		self:shakeEffect(self.spine_npc, 0.5, nil)
	end)
	;(nil)[10] = cca.callFunc(function()
		self = nil
		;(nil).diff_max = 10
		;(nil).interval = 0.01
		self:shakeEffect(self.spine_npc, 0.5, nil)
	end)
	self.spine_npc:runAction(cca.seq(nil))
	SoraDPlaySound("elimiateGame", 3)
end
function EliminateGameView:onKO(data)
	SoraDCloseLoading(self)
	if data.errCode == gErrDef.Err_None then
		self.level = self.level + 1
		if self.level > #self.levelConfig then
			self:playWin(data.rewards)
		else
			self:playNext(data.rewards)
		end
	else
		self.stepNum = siegeCombatCtrl.dataTable.mysteps
		self:enterLevel(self.level)
		self:updateUI()
		self:saveData(true)
		local errStr = msgNotice.getTipCode(data.errCode)
		if not errStr then
			errStr = data.errCode
		else
			errStr = i18n(errStr)
		end
		SoraDShowMsgTip(errStr)
	end
end
function EliminateGameView:setHpBar(percent)
	if not self.curHpPercent then
		self.curHpPercent = percent
		self:_updateHpBar(self.curHpPercent)
	end
	if self.hpTimer then
		SoraDManagerRemoveTimer(self, self.hpTimer)
		self.hpTimer = nil
	end
	if percent < self.curHpPercent then
		local updateAction = util.ValueTo.new(handler(self, self._updateHpBar), self.curHpPercent, percent)
		updateAction:startWithDuration(self, 0.5)
		self.hpTimer = SoradCreateTimer(self, function(dt)
			if updateAction:isFinish() then
				SoraDManagerRemoveTimer(self, self.hpTimer)
				self.hpTimer = nil
			else
				updateAction:updateByTime(dt)
			end
		end, true)
		self.curHpPercent = percent
	else
		self.curHpPercent = percent
		self:_updateHpBar(self.curHpPercent)
	end
end
function EliminateGameView:_updateHpBar(percent)
	if 0 < percent then
		self:bloodEffect()
	else
		self:bloodEffect(true)
	end
	self.LoadingBar_exp:setPercent(self.curHP / self.totalHP * 100)
	self.monsterHp:setString(self.curHP .. "/" .. self.totalHP)
end
function EliminateGameView:playNext(rewards)
	local panel = SoraDCreatePanel("eliminateGamePopView")
	panel:initData(rewards)
	panel:setConfirmHandle(function()
		self:enterLevel(self.level)
		self:saveData()
	end)
	panel:show()
end
function EliminateGameView:playWin(rewards)
	local panel = SoraDCreatePanel("eliminateGamePopView")
	local retryCb = function()
		self:resetGame()
	end
	local exitCb = function()
		self:saveData(true)
		self:close(self, ccui.TouchEventType.ended)
	end
	panel:initData(rewards, "winView")
	panel:setRetryHandle(retryCb)
	panel:setExitHandle(exitCb)
	panel:show()
end
function EliminateGameView:playBlood(atk)
	_ENV = nil
	;(nil).color = cc.c3b(255, 0, 0)
	;(nil).fontSize = 50
	;(nil).pos = cc.p(0, 0)
	;(nil).zOrder = 1
	;(nil).duration = 1
	;(nil).moveH = 120
	;(nil).scale = 1.5
	local (nil).font, param = "res/fonts/Arial_Bold_Border.fnt", nil
	self:SoraDCreateWaveBMP("-" .. atk, self.boomNode[1], param)
end
function EliminateGameView:onDouble(sender, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.mulNum == 1 then
			local curDoubles = siegeCombatCtrl:getCurDoubles()
			if curDoubles < 1 then
				if SoraDEnoughGold(eliminateGameCommon.getDoubleCost()) then
					local number = eliminateGameCommon.getAddDouble()
					_ENV = eliminateGameCommon.getDoubleCost()
					eliminateGameCommon.getDoubleCost().gold = eliminateGameCommon.getDoubleCost()
					eliminateGameCommon.getDoubleCost().times = number
					local text = i18n("common_text_2546", eliminateGameCommon.getDoubleCost())
					local gold = eliminateGameCommon.getDoubleCost()
					SoraDShowBuyBox(text, gold, i18n("common_text_204"), function(event)
						if event == MSGBOX_CALLBACK_YES then
							siegeCombatCtrl:sendDouble()
							sender:setTouchEnabled(false)
						end
					end)
				end
			else
				siegeCombatCtrl:sendUseDouble()
				self.mulNum = 2
				self:updateUI()
				self:saveData()
			end
		else
			siegeCombatCtrl:sendUseDouble()
			self.mulNum = 1
			self:updateUI()
			self:saveData()
		end
	end
end
function EliminateGameView:onDoubleBack(data)
	self.doubleBtn:setTouchEnabled(true)
	if data.errCode == gErrDef.Err_None then
		self.mulNum = 2
		siegeCombatCtrl:sendUseDouble()
		self:updateUI()
		self:saveData()
	else
		local errStr = msgNotice.getTipCode(data.errCode)
		if not errStr then
			errStr = data.errCode
		else
			errStr = i18n(errStr)
		end
		SoraDShowMsgTip(errStr)
	end
end
function EliminateGameView:onStep(sender, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:buyStepBox()
	end
end
function EliminateGameView:buyStepBox()
	if self.stepBtn:isTouchEnabled() == false then
		return
	end
	local addStep = eliminateGameCommon.getAddStep()
	eliminateGameCommon = nil
	;(nil).remainStep = self.stepNum
	;(nil).gold = siegeCombatCtrl:getStepsCost()
	;(nil).addStep = addStep
	local text = i18n("common_text_2547", nil)
	text = text .. "\n" .. i18n("common_text_2625")
	local gold = siegeCombatCtrl:getStepsCost()
	SoraDShowBuyBox(text, gold, i18n("common_text_204"), function(event)
		if event == MSGBOX_CALLBACK_YES then
			siegeCombatCtrl:sendPlusStep(self.stepNum)
		end
	end)
end
function EliminateGameView:onStepBack(data)
	if data.errCode == gErrDef.Err_None then
		self.stepNum = self.stepNum + 20
		self:updateUI()
		self:saveData()
	else
		local errStr = msgNotice.getTipCode(data.errCode)
		if not errStr then
			errStr = data.errCode
		else
			errStr = i18n(errStr)
		end
	end
end
function EliminateGameView:onRetry(sender, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if siegeCombatCtrl:getIsDayLimit() then
			SoraDShowMsgTip(i18n("common_text_2538"))
			return
		end
		eliminateGameCommon.restartGame(handler(self, self.resetGame))
	end
end
function EliminateGameView:onHelp(sender, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "common_text_2548"
		;("common_text_2548").float = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("common_text_2548"), "common_text_2548")
	end
end
function EliminateGameView:onBtnAward(sender, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("TODO: 打开奖励预览界面-------")
		local panel = SoraDCreatePanel("eliminateGameReward")
		local Rewards = self.levelConfig[self.level].Rewards
		local _ENV, rewards = self.level, self.level
		local i = 1
		while i <= #Rewards - 1 do
			_ENV = nil
			;(nil).id = Rewards[i]
			;(nil).count = Rewards[i + 1]
			table.insert(rewards, #rewards + 1, nil)
			i = i + 2
		end
		dump(rewards, "rewardsrewardsrewards", 10)
		panel:initData(rewards)
		panel:show()
	end
end
function EliminateGameView:playKO(rewards)
	self.level = self.level + 1
	if self.level > #self.levelConfig then
		self:playWin(rewards)
	else
		self:playNext(rewards)
	end
end
function EliminateGameView:playHurt()
	if self.hurtRewards then
		local hurtRewards = self.hurtRewards
		SoraDShowLoading()
		_UPVALUE1_ = nil
		;(nil)[1] = cca.delay(0.3)
		;(nil)[2] = cca.callFunc(function()
			SoraDCloseLoading()
			self:playKO(hurtRewards)
		end)
		;(nil)[3] = cca.callFunc(function()
			SoraDCloseLoading()
			self:playKO(hurtRewards)
		end)
		self:runAction(cca.seq(nil))
	end
	if self.killSum then
		self:playBlood(self.killSum)
		local percent = self.curHP / self.totalHP
		self:setHpBar(percent)
		self.mulNum = 1
		self:updateUI()
	end
	self.hurtRewards = nil
	self.killSum = nil
end
function EliminateGameView:onHurtBack(data)
	if data.errCode == gErrDef.Err_None then
		self.killSum = data.killSum
		self.curHP = siegeCombatCtrl.dataTable.hp
		local curDoubles = data.curDoubles
		if data.rewards then
			self.hurtRewards = data.rewards
			self.curHP = 0
		end
		if self.playHurtFinish then
			self:playHurt()
			self.playHurtFinish = false
		end
	else
		self.stepNum = siegeCombatCtrl.dataTable.mysteps
		self:enterLevel(self.level)
		self:updateUI()
		self:saveData(true)
		local errStr = msgNotice.getTipCode(data.errCode)
		if not errStr then
			errStr = data.errCode
		else
			errStr = i18n(errStr)
		end
		SoraDShowMsgTip(errStr)
	end
end
function EliminateGameView:onUseStepBack(data)
	if data.errCode == gErrDef.Err_SIEGE_COMBAT_CHECK_ERROR or data.errCode == gErrDef.Err_SIEGE_COMBAT_CHECK_STEPS_ERROR then
		self.stepNum = siegeCombatCtrl.dataTable.mysteps
		self:enterLevel(self.level)
		self:updateUI()
		self:saveData(true)
		local errStr = msgNotice.getTipCode(data.errCode)
		if not errStr then
			errStr = data.errCode
		else
			errStr = i18n(errStr)
		end
		SoraDShowMsgTip(errStr)
	end
end
function EliminateGameView:onOldDamageBack(data)
	if data.errCode == gErrDef.Err_None then
		self:saveData()
	end
end
function EliminateGameView:resetGame()
	self.stepNum = 30
	self.mulNum = 1
	self:initChessboard()
	self:layoutChessboard()
	self:enterLevel(1)
	self:updateUI()
	self:saveData()
end
function EliminateGameView:onExitPanel()
	if self.spine_npc.animShaker then
		self.spine_npc.animShaker:stop()
	end
	if self.soundLightning then
		AudioEngine.stopEffect(self.soundLightning)
		self.soundLightning = nil
	end
	_ENV = self.soundLightning
	self.soundLightning.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	self.soundLightning.eventID = gActivityTimeActivityID.SIEGE_COMBAT
	SoraDSendMessage(self.soundLightning)
end
function EliminateGameView:SoraDCreateWaveBMP(text, parent, params)
	local text = text or "NA"
	if params == nil then
		params, _ENV = nil, nil
	end
	local color = params.color or display.COLOR_GREEN
	local pos = params.pos or cc.p(0, 0)
	local zOrder = params.zOrder or 1
	local scale = params.scale or 1
	local dt = params.duration or 1
	local moveH = params.moveH or 80
	local font = params.font
	if not font then
		return nil
	end
	_ENV = nil
	;(nil).text = text
	;(nil).font = font
	local waveLabel = display.newBMFontLabel(nil)
	waveLabel:setColor(color)
	waveLabel:setScale(scale)
	waveLabel:addTo(parent, zOrder)
	waveLabel:setPosition(pos)
	local moveBy = cca.moveBy(dt, 0, moveH)
	local callFunc = cca.callFunc(function()
		waveLabel:removeFromParent()
	end)
	_UPVALUE2_ = moveH
	moveH[1] = moveBy
	moveH[2] = callFunc
	local seq = cca.seq(moveH)
	waveLabel:runAction(seq)
	return waveLabel
end
function EliminateGameView:doubleAttackChessBgEffect(isHide)
	if not self.nodeMain then
		return
	end
	local et_node = self.nodeMain:getChildByName("et_node_double_bg")
	if isHide then
		if et_node then
			et_node:setVisible(false)
		end
		return
	end
	if et_node then
		et_node:setVisible(true)
		return
	end
	local et_node = SoraDCreatAnimation("gwdzz_double")
	et_node:setName("et_node_double_bg")
	et_node:setPosition(cc.p(0, self.layout:getContentSize().height / 2))
	et_node:addTo(self.nodeMain, 11)
end
function EliminateGameView:stepZeroEffect(isHide)
	if not self.stepBtn then
		return
	end
	local et_node_bg = self.stepBtn:getChildByName("et_node_bg_zero")
	local et_node_top = self.stepBtn:getChildByName("et_node_top_zero")
	if isHide == true then
		if et_node_bg then
			et_node_bg:setVisible(false)
		end
		if et_node_top then
			et_node_top:setVisible(false)
		end
		return
	end
	local size = self.stepBtn:getContentSize()
	_ENV, _ENV = false, self.stepBtn
	;(false).plist = "et_monsterfight06_01.plist"
	_ENV, _ENV, self.stepBtn[1], (false).scale = nil, false, false, 1.9
	local param_bg = self.stepBtn
	;(nil).plist = "et_monsterfight06_02.plist"
	;(nil).scale = 1.7
	_ENV, (false)[1], (nil).zorder = nil, nil, 1
	;(nil).plist = "et_monsterfight06_03.plist"
	;(nil).scale = 1.26
	;(false)[2], (nil).zorder = nil, 2
	local param_top = false
	if et_node_bg then
		et_node_bg:setVisible(true)
	else
		et_node_bg = SoraDCreateEffectNode(param_bg)
		et_node_bg:setPosition(cc.p(size.width / 2, size.height / 2))
		et_node_bg:addTo(self.stepBtn, -1)
		et_node_bg:setName("et_node_bg_zero")
	end
	if et_node_top then
		et_node_top:setVisible(true)
	else
		et_node_top = SoraDCreateEffectNode(param_top)
		et_node_top:setPosition(cc.p(size.width / 2, size.height / 2))
		et_node_top:addTo(self.stepBtn, 1)
		et_node_top:setName("et_node_top_zero")
	end
end
function EliminateGameView:stepLessEffect(isHide)
	if not self.stepBtn then
		return
	end
	local et_node_bg = self.stepBtn:getChildByName("et_node_bg_less")
	local et_node_top = self.stepBtn:getChildByName("et_node_top_less")
	if isHide == true then
		if et_node_bg then
			et_node_bg:setVisible(false)
		end
		if et_node_top then
			et_node_top:setVisible(false)
		end
		return
	end
	local size = self.stepBtn:getContentSize()
	_ENV, _ENV = false, self.stepBtn
	;(false).plist = "et_monsterfight05_01.plist"
	_ENV, _ENV, self.stepBtn[1], (false).scale = nil, false, false, 1.26
	local param_bg = self.stepBtn
	;(nil).plist = "et_monsterfight05_02.plist"
	;(nil).scale = 1.7
	_ENV, (false)[1], (nil).zorder = nil, nil, 1
	;(nil).plist = "et_monsterfight05_03.plist"
	;(nil).scale = 1.26
	;(false)[2], (nil).zorder = nil, 2
	local param_top = false
	if et_node_bg then
		et_node_bg:setVisible(true)
	else
		et_node_bg = SoraDCreateEffectNode(param_bg)
		et_node_bg:setPosition(cc.p(size.width / 2, size.height / 2))
		et_node_bg:addTo(self.stepBtn, -1)
		et_node_bg:setName("et_node_bg_less")
	end
	if et_node_top then
		et_node_top:setVisible(true)
	else
		et_node_top = SoraDCreateEffectNode(param_top)
		et_node_top:setPosition(cc.p(size.width / 2, size.height / 2))
		et_node_top:addTo(self.stepBtn, 1)
		et_node_top:setName("et_node_top_less")
	end
end
function EliminateGameView:doubleAttackEffect(isHide)
	if not self.doubleBtn then
		return
	end
	self.et_btn_double:setVisible(not isHide)
end
function EliminateGameView:bloodEffect(isHide)
	if not self.hpPoint then
		return
	end
	local et_node = self.hpPoint:getChildByName("hp_effect")
	if isHide == true then
		if et_node then
			et_node:setVisible(false)
		end
		return
	end
	_ENV, _ENV = et_node, et_node.setVisible
	et_node.plist = "et_monsterfight03_01.plist"
	et_node.scale = 1.452
	_ENV, et_node.rotate = false, 90
	;(false).x = 16
	_ENV, et_node.setVisible[1], et_node.pos, (false).y = et_node, et_node, false, -2
	et_node.plist = "et_monsterfight03_02.plist"
	et_node.scale = 0.972
	_ENV, et_node.rotate = false, 90
	;(false).x = 4
	_ENV, et_node.setVisible[2], et_node.pos, (false).y = et_node, et_node, false, -2
	et_node.plist = "et_monsterfight03_03.plist"
	et_node.scale = 3.168
	et_node.setVisible[3], et_node.rotate = et_node, -90
	local param = et_node.setVisible
	if et_node == nil then
		local et_node = SoraDCreateEffectNode(param)
		local posX = SoraDFIsRA() and self.hpPoint:getContentSize().width / 2 + 5 or self.hpPoint:getContentSize().width / 2 - 4.5
		et_node:setPosition(cc.p(posX, 0))
		if not SoraDFIsRA() then
			et_node:setScaleX(-1)
		end
		et_node:addTo(self.hpPoint, 1)
		et_node:setName("hp_effect")
	else
		et_node:setVisible(true)
	end
end
function EliminateGameView:doubleChessSingleEffect(target, isHide)
	if not target then
		return
	end
	local et_node = target:getChildByName("double_effect")
	if isHide == true then
		et_node:setVisible(false)
		return
	end
	local size = target:getContentSize()
	_ENV, _ENV = false, target
	;(false).plist = "et_monsterfight02_01.plist"
	target[1], (false).scale = false, 1.35
	local param = target
	if et_node == nil then
		et_node = SoraDCreateEffectNode(param)
		et_node:setName("double_effect")
		et_node:setPosition(cc.p(size.width / 2, size.height / 2))
		et_node:addTo(target, -1)
	else
		et_node:setVisible(true)
	end
end
function EliminateGameView:doubleChessEffect(isRemove)
	if isRemove == nil then
		self:doubleAttackChessBgEffect()
	else
		self:doubleAttackChessBgEffect(true)
	end
end
function EliminateGameView:shakeEffect(target, time, params)
	if target.animShaker then
		target.animShaker:stop()
	end
	local AnimShaker = include("AnimShaker")
	local animShaker = AnimShaker.new(target, time, params)
	target.animShaker = animShaker
	animShaker:run()
end
function EliminateGameView:showMonsterEffect(target)
	local posy = self.Panel_monster:getPositionY() + self.Panel_monster:getScale() * self.monster:getScale() * self.monster:getContentSize().height / 2
	_ENV, _ENV = self.monster:getContentSize().height, self.Panel_monster:getScale() * self.monster:getScale() * self.monster:getContentSize().height / 2
	self.monster:getContentSize().height.name = "gwdzz_gj"
	self.monster:getContentSize().height.pos = cc.p(320, posy)
	_ENV, (self.Panel_monster:getScale() * self.monster:getScale() * self.monster:getContentSize().height / 2)[1], self.monster:getContentSize().height.time = self.monster:getContentSize().height, self.monster:getContentSize().height, 1.4
	self.monster:getContentSize().height.name = "gwdzz_bj"
	self.monster:getContentSize().height.pos = cc.p(320, posy - 290)
	;(self.Panel_monster:getScale() * self.monster:getScale() * self.monster:getContentSize().height / 2)[2], self.monster:getContentSize().height.time = self.monster:getContentSize().height, 1.4
	local tab = self.Panel_monster:getScale() * self.monster:getScale() * self.monster:getContentSize().height / 2
	local config = 1 < self.mulNum and tab[2] or tab[1]
	local effect = SoraDCreatAnimationEx(config.name, nil, false)
	effect:addTo(self.Bottom_Node)
	effect:setPosition(config.pos)
	_UPVALUE1_ = nil
	;(nil)[1] = cca.delay(config.time)
	;(nil)[2] = cca.callFunc(function()
		effect:removeFromParent()
	end)
	;(nil)[3] = cca.callFunc(function()
		effect:removeFromParent()
	end)
	effect:runAction(cca.seq(nil))
end
function EliminateGameView:judgeDirection(angle)
	for k, v in pairs(SwapDirection) do
		local angleSec = AngleSec[v]
		if angleSec then
			local min = angleSec.min
			local max = angleSec.max
			local judgeType = angleSec.judgeType
			if judgeType == 0 then
				if angle < min or angle >= max then
					return v
				end
			elseif angle < max and angle >= min then
				return v
			end
		end
	end
	return SwapDirection.NONE
end
function EliminateGameView:clickEffect(target)
	_ENV, _ENV = nil, nil
	;(nil)[1], (nil).plist = nil, "et_dianji_display.plist"
	local param
	local parNode = SoraDCreateEffectNode(param)
	parNode:setName("particle_click_node")
	parNode:setPosition(cc.p(target:getContentSize().width / 2 - 30, target:getContentSize().height / 2 - 30))
	parNode:addTo(target, -1)
end
function EliminateGameView:onCloseActivity(target, data)
	SoraDRemoveAllPanelFromManager()
	SoraDShowMsgTip(i18n("common_text_1859"))
end
function EliminateGameView:getDisposeEffectSingle(...)
	if not self.disposeEffectList then
		self.disposeEffectList, _ENV = self.disposeEffectList, self.disposeEffectList
	end
	if #self.disposeEffectList > 0 then
		local effect = table.remove(self.disposeEffectList)
		effect:setVisible(true)
		return effect
	end
	local effect = SoraDCreatAnimationEx("gwdzz_xiaochu", nil, false)
	effect:addTo(self.layout)
	effect.nodeList, _ENV = effect.addTo, effect.addTo
	for i, v in ipairs(effect:getChildren()) do
		v:setVisible(false)
	end
	_ENV = (for generator)
	ipairs(effect:getChildren())[ChessColorDef.red] = "red"
	ipairs(effect:getChildren())[ChessColorDef.yellow] = "yellow"
	ipairs(effect:getChildren())[ChessColorDef.purple] = "purple"
	local ipairs(effect:getChildren())[ChessColorDef.green], nodeNameTab = "green", ipairs(effect:getChildren())
	for k, v in pairs(nodeNameTab) do
		local node = effect:getChildByName(v)
		node:setPosition(cc.p(0, 0))
		effect.nodeList[k] = node
	end
	function effect.showColor(color)
		effect.action:gotoFrameAndPlay(0, false)
		for k, node in pairs(effect.nodeList) do
			node:setVisible(k == color)
		end
	end
	function effect.recycleSingle()
		effect:setVisible(false)
		table.insert(self.disposeEffectList, effect)
	end
	return effect
end
function EliminateGameView:gameGuide_getTarget(itemName, parameters)
	local chess1, chess2
	if itemName == "chessListSingle" then
		chess1 = self.chessList[self:conv(parameters.chessPos[1][1], parameters.chessPos[1][2])]
		chess2 = self.chessList[self:conv(parameters.chessPos[2][1], parameters.chessPos[2][2])]
		if chess1 and chess2 and chess1:getParent():getChildByName("spriteHand") == nil then
			local chess1Pos = cc.p(chess1:getPositionX(), chess1:getPositionY())
			local chess2Pos = cc.p(chess2:getPositionX(), chess2:getPositionY())
			local spriteHand = SoraDFingerAction(true, true)
			spriteHand:setName("spriteHand")
			spriteHand:addTo(chess1:getParent(), 1)
			_UPVALUE7_ = chess2:getPositionY()
			chess2:getPositionY()[1] = cca.callFunc(function(...)
				spriteHand:setPosition(cc.p(chess1Pos.x, chess1Pos.y))
				spriteHand:setVisible(true)
			end)
			chess2:getPositionY()[2] = cca.fadeIn(0.1)
			chess2:getPositionY()[3] = cca.moveTo(1, chess2Pos.x, chess2Pos.y)
			chess2:getPositionY()[4] = cca.delay(0.2)
			chess2:getPositionY()[5] = cca.fadeOut(0.1)
			chess2:getPositionY()[6] = cca.callFunc(function(...)
				spriteHand:setVisible(false)
			end)
			chess2:getPositionY()[7] = cca.delay(0.5)
			chess2:getPositionY()[8] = cca.callFunc(function(target)
				if SoraDIsGameGuide() ~= 18001 then
					spriteHand:removeFromParent()
				end
			end)
			chess2:getPositionY()[9] = cca.callFunc(function(target)
				if SoraDIsGameGuide() ~= 18001 then
					spriteHand:removeFromParent()
				end
			end)
			spriteHand:runAction(cca.repeatForever(cca.seq(chess2:getPositionY())))
		end
	end
	return self.touchMask
end
return EliminateGameView

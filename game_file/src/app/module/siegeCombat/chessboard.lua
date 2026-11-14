local chessboard = class("chessboard")
function chessboard:conv(...)
	return self.gameCommon.conv(...)
end
function chessboard:getProperties(key)
	return self[key]
end
function chessboard:setProperties(key, value)
	self[key] = value
end
function chessboard:ctor(param)
	if not param then
		param, _ENV = nil, nil
	end
	self.chessboard, _ENV, self.gameCommon = param.gameCommon or include("eliminateGameCommon"), param.gameCommon or include("eliminateGameCommon"), param.gameCommon or include("eliminateGameCommon")
	self.row = 5
	self.col = 5
	self.chessKind = 4
	self.emptyList, _ENV, self.closeList, _ENV, self.openList, _ENV, self.rightSlantChain, _ENV, self.leftSlantChain, _ENV, self.colChain, _ENV, self.rowChain, _ENV, self.minNum = param.minNum or 4, param.minNum or 4, param.minNum or 4, param.minNum or 4, param.minNum or 4, param.minNum or 4, param.minNum or 4, param.minNum or 4, param.minNum or 4, param.minNum or 4, param.minNum or 4, param.minNum or 4, param.minNum or 4, param.minNum or 4, param.minNum or 4
	self.isNeedSlant = param.isNeedSlant == nil and true or param.isNeedSlant
end
function chessboard:dumpLinks()
	_ENV = nil
	;(nil).colChain = self.colChain
	;(nil).rowChain = self.rowChain
	;(nil).leftSlantChain = self.leftSlantChain
	;(nil).rightSlantChain = self.rightSlantChain
	dump(nil, "==chessboard:dumpLinks==", 10)
end
function chessboard:initData()
end
function chessboard:getChessboard(row, col)
	return self.chessboard[self:conv(row, col)]
end
function chessboard:initChessboard(...)
	local _ENV, chessboard
	for i = 1, self.row do
		for j = 1, self.col do
			chessboard[self:conv(i, j)] = math.random(1, self.chessKind)
		end
	end
	self:update(chessboard)
	self:scanLinks()
	self:breakLink()
end
function chessboard:update(data)
	self.chessboard = data
end
function chessboard:scanLinks()
	self.rightSlantChain, _UPVALUE0_, self.leftSlantChain, _UPVALUE0_, self.colChain, _UPVALUE0_, self.rowChain, _UPVALUE0_ = nil, nil, nil, nil, nil, nil, nil, nil
	self:scanRow()
	self:scanCol()
	if self.isNeedSlant then
		self:scanLeftSlant()
		self:scanRightSlant()
	end
end
function chessboard:scanRow()
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
function chessboard:scanCol()
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
function chessboard:scanLeftSlant()
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
function chessboard:scanRightSlant()
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
function chessboard:breakLink()
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
function chessboard:getSamePoint(row, col)
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
function chessboard:breakPoint(row, col)
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
function chessboard:swap(p1, p2)
	local color = self.chessboard[self:conv(p1)]
	self.chessboard[self:conv(p1)] = self.chessboard[self:conv(p2)]
	self.chessboard[self:conv(p2)] = color
end
function chessboard:removeLinks()
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
function chessboard:removeLink(link)
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
function chessboard:fillEmpty(...)
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
function chessboard:calculateAtk(...)
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
	return list
end
function chessboard:checkValid(chessboard)
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
return chessboard

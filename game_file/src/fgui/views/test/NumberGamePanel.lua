local SUDOKU_SIZE = 9
local SUDOKU_SHOW = 36
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NumberGamePanel = class("NumberGamePanel", baseFguiPanel)
function NumberGamePanel:ctor(...)
	self.isLRU = true
	NumberGamePanel.super.ctor(self, ...)
	print("NumberGamePanel:ctor", self.viewName)
end
function NumberGamePanel:onInit()
	print("=======NumberGamePanel:onInit")
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.Com_title:initData(i18n("数独游戏"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Btn_refresh:setString(i18n("刷新"))
	self.fields.Btn_refresh:addClickListener(handler(self, self.onClick_Btn_refresh))
	self.fields.Btn_notice:setString(i18n("提示"))
	self.fields.Btn_notice:addClickListener(handler(self, self.onClick_Btn_notice))
	self.fields.Btn_set:setTitle(i18n("设置"))
	self.fields.Btn_set:addClickListener(handler(self, self.onClick_Btn_set))
	self.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
	self.fields.Text_tip:setString(i18n("可以修改默认显示数字数量"))
end
function NumberGamePanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).title = "玩法规则"
	;(nil).content = "1.数独大小为9x9的矩阵\n2.数独数字范围为1-9\n3.数独数字每行不能重复\n4.数独数字每列不能重复\n5.数独数字每个3x3的宫格不能重复\n6.填充完所有数字且符合规则即为数独成功"
	uiManager:show("RuleView", nil)
end
function NumberGamePanel:endShow()
	print("=======NumberGamePanel:endShow")
	self.sudokuNum = SUDOKU_SHOW
	self:initSudokuData()
end
function NumberGamePanel:initSudokuData()
	self.sudokuData, SUDOKU_SIZE = nil, nil
	self.sudokuRecordData, SUDOKU_SIZE, self.sudokuData = self:generateSudokuData(), self:generateSudokuData(), self:generateSudokuData()
	self.sudokuRecordData = self:randomShowSudokuData(self.sudokuNum)
	self.fields.List:setNumItems(SUDOKU_SIZE * SUDOKU_SIZE)
	self.fields.input:setText(self.sudokuNum)
	self.Text_time:beginTime(0, true)
end
function NumberGamePanel:randomShowSudokuData(num)
	local n = math.min(math.max(tonumber(num) or 0, 0), SUDOKU_SIZE * SUDOKU_SIZE)
	local _ENV, showData = math.max(tonumber(num) or 0, 0), math.max(tonumber(num) or 0, 0)
	for r = 1, SUDOKU_SIZE do
		showData[r], _ENV = nil, nil
		for c = 1, SUDOKU_SIZE do
			showData[r][c] = 0
		end
	end
	local _ENV, positions = (for index), 1
	for r = 1, SUDOKU_SIZE do
		for c = 1, SUDOKU_SIZE do
			_UPVALUE2_ = nil
			positions[#positions + 1], (nil)[1] = nil, r
			positions[#positions + 1], (nil)[2] = nil, c
		end
	end
	for i = #positions, 2, -1 do
		local j = math.random(1, i)
		positions[i], positions[j] = positions[j], positions[i]
	end
	for k = 1, n do
		local p = positions[k]
		showData[p[1]][p[2]] = -1
	end
	return showData
end
function NumberGamePanel:generateSudokuData()
	local SUDOKU_SIZE, sudokuData
	for r = 1, SUDOKU_SIZE do
		sudokuData[r], SUDOKU_SIZE = nil, nil
		for c = 1, SUDOKU_SIZE do
			sudokuData[r][c] = 0
		end
	end
	local shuffle = function(t)
		for i = #t, 2, -1 do
			local j = math.random(1, i)
			t[i], t[j] = t[j], t[i]
		end
	end
	local fillBlock3 = function(topRow, leftCol)
		_UPVALUE9_ = nil
		;(nil)[1] = 1
		;(nil)[2] = 2
		;(nil)[3] = 3
		;(nil)[4] = 4
		;(nil)[5] = 5
		;(nil)[6] = 6
		;(nil)[7] = 7
		;(nil)[8] = 8
		local (nil)[9], nums = 9, nil
		shuffle(nums)
		local k = 1
		for rr = topRow, topRow + 2 do
			for cc = leftCol, leftCol + 2 do
				sudokuData[rr][cc] = nums[k]
				k = k + 1
			end
		end
	end
	fillBlock3(1, 1)
	fillBlock3(4, 4)
	fillBlock3(7, 7)
	local canPlace = function(r, c, n)
		for i = 1, SUDOKU_SIZE do
			if sudokuData[r][i] == n and i ~= c then
				return false
			end
			if sudokuData[i][c] == n and i ~= r then
				return false
			end
		end
		local br = math.floor((r - 1) / 3) * 3 + 1
		local bc = math.floor((c - 1) / 3) * 3 + 1
		for rr = br, br + 2 do
			for cc = bc, bc + 2 do
				if sudokuData[rr][cc] == n and (rr ~= r or cc ~= c) then
					return false
				end
			end
		end
		return true
	end
	local function solveFrom(pos)
		if pos > SUDOKU_SIZE * SUDOKU_SIZE then
			return true
		end
		local r = math.floor((pos - 1) / SUDOKU_SIZE) + 1
		local c = (pos - 1) % SUDOKU_SIZE + 1
		if sudokuData[r][c] ~= 0 then
			return solveFrom(pos + 1)
		end
		_UPVALUE9_ = solveFrom
		solveFrom[1] = 1
		solveFrom[2] = 2
		solveFrom[3] = 3
		solveFrom[4] = 4
		solveFrom[5] = 5
		solveFrom[6] = 6
		solveFrom[7] = 7
		solveFrom[8] = 8
		local solveFrom[9], nums = 9, solveFrom
		shuffle(nums)
		for _, n in ipairs(nums) do
			if canPlace(r, c, n) then
				sudokuData[r][c] = n
				if solveFrom(pos + 1) then
					return true
				end
				sudokuData[r][c] = 0
			end
		end
		return false
	end
	if not solveFrom(1) then
		for r = 1, SUDOKU_SIZE do
			for c = 1, SUDOKU_SIZE do
				sudokuData[r][c] = 0
			end
		end
		solveFrom(1)
	end
	return sudokuData
end
function NumberGamePanel:itemRenderer_List(index, obj)
	local row = math.ceil((index + 1) / SUDOKU_SIZE)
	local col = (index + 1) % SUDOKU_SIZE == 0 and SUDOKU_SIZE or (index + 1) % SUDOKU_SIZE
	local sudokuRecordData = self.sudokuRecordData[row][col]
	local sudokuData = self.sudokuData[row][col]
	obj:initData(sudokuData, sudokuRecordData, row, col)
end
function NumberGamePanel:onDataUpdate(target, data)
	local row = data.row
	local col = data.col
	local num = data.num
	self.sudokuRecordData[row][col] = num
	self.fields.List:setNumItems(SUDOKU_SIZE * SUDOKU_SIZE)
	if self:checkSudokuComplete() then
		self.Text_time:endTime()
		SUDOKU_SIZE = SUDOKU_SIZE
		SUDOKU_SIZE.time = self.Text_time:getString()
		SoraDShowMsgTip(i18n("数独填充完成,用时:%{time}", SUDOKU_SIZE))
		return
	end
	if num ~= self.sudokuData[row][col] then
		SoraDShowMsgTip(i18n("数独填充错误"))
		return
	end
end
function NumberGamePanel:checkSudokuComplete()
	for r = 1, SUDOKU_SIZE do
		for c = 1, SUDOKU_SIZE do
			if self.sudokuRecordData[r][c] == 0 then
				return false
			end
			if 1 <= self.sudokuRecordData[r][c] and self.sudokuRecordData[r][c] <= 9 and self.sudokuRecordData[r][c] ~= self.sudokuData[r][c] then
				return false
			end
		end
	end
	return true
end
function NumberGamePanel:onClick_Btn_refresh(context)
	SoraDPlaySound()
	self:initSudokuData()
end
function NumberGamePanel:onClick_Btn_notice(context)
	SoraDPlaySound()
	local _ENV, candidates = SoraDPlaySound, SoraDPlaySound
	for r = 1, SUDOKU_SIZE do
		for c = 1, SUDOKU_SIZE do
			if self.sudokuRecordData[r][c] == 0 then
				_UPVALUE2_ = nil
				candidates[#candidates + 1], (nil)[1] = nil, r
				candidates[#candidates + 1], (nil)[2] = nil, c
			end
		end
	end
	if #candidates == 0 then
		SoraDShowMsgTip(i18n("暂无可提示的格子"))
		return
	end
	local pick = candidates[math.random(1, #candidates)]
	self.sudokuRecordData[pick[1]][pick[2]] = -2
	self.fields.List:setNumItems(SUDOKU_SIZE * SUDOKU_SIZE)
	if self:checkSudokuComplete() then
		self.Text_time:endTime()
		_ENV = SUDOKU_SIZE
		SUDOKU_SIZE.time = self.Text_time:getString()
		SoraDShowMsgTip(i18n("数独填充完成,用时:%{time}", SUDOKU_SIZE))
		return
	end
end
function NumberGamePanel:onClick_Btn_set(context)
	SoraDPlaySound()
	local num = tonumber(self.fields.input:getText())
	if num and 0 < num and num <= SUDOKU_SIZE * SUDOKU_SIZE then
		self.sudokuNum = num
		self.sudokuRecordData = self:randomShowSudokuData(self.sudokuNum)
		self.fields.List:setNumItems(SUDOKU_SIZE * SUDOKU_SIZE)
	else
		SoraDShowMsgTip(i18n("请输入正确的数字1~81"))
		self.fields.input:setText(self.sudokuNum)
	end
end
return NumberGamePanel

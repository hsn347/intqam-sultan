local GridScrollView = class("GridScrollView", function(target)
	return target
end)
function GridScrollView:ctor()
end
function GridScrollView:init(gridData, num, createCell, updateCell)
	if type(createCell) ~= "function" or type(updateCell) ~= "function" or num < 0 then
		print("GridScrollView:init param error!")
		return
	end
	_UPVALUE4_ = print
	self.tmpInitData, print[1] = print, gridData
	self.tmpInitData, print[2] = print, num
	self.tmpInitData, print[3] = print, createCell
	self.tmpInitData, print[4] = print, updateCell
end
function GridScrollView:realInit()
	local gridData, num, createCell, updateCell = self.tmpInitData[1], self.tmpInitData[2], self.tmpInitData[3], self.tmpInitData[4]
	self.tmpInitData = nil
	if not self.margin then
		self.margin, _ENV = self.margin, self.margin
	end
	self.createCell = createCell
	self.updateCell = updateCell
	self.row = gridData.row or 0
	self.col = gridData.col or 0
	_ENV, self.cellNum = gridData.col or 0, num
	;(gridData.col or 0).left = gridData.left or 0
	;(gridData.col or 0).top = gridData.top or 0
	;(gridData.col or 0).row = gridData.h or 0
	self.cellList, _ENV, self.idleCells, _ENV, self.margin, (gridData.col or 0).col = gridData.col or 0, gridData.col or 0, gridData.col or 0, gridData.col or 0, gridData.col or 0, gridData.w or 0
	local cell = self.createCell()
	cell:setVisible(false)
	if gridData.isUseParent and self:getParent() ~= nil then
		self:getParent():addChild(cell)
	else
		self:addChild(cell)
	end
	self.virtualNode = util.getVirtualNode(cell)
	self.cellSize = self.virtualNode.size
	cell:removeFromParent()
	self:calPreloadSize()
	self:resetSize(num)
	if not self._addEventListener then
		self._addEventListener = self.addEventListener
		self:_addEventListener(handler(self, self.scrollEventCallBack))
		function self.addEventListener(target, cb)
			target.scrollEventCb = cb
		end
		self:setListenAllScrollingEnabled(true)
	end
end
function GridScrollView:calPreloadSize()
	local row, col
	local contentSize = self:getContentSize()
	if self.row == 0 then
		col = self.col
		row = math.ceil(contentSize.height / (self.cellSize.height + self.margin.row))
	elseif self.col == 0 then
		row = self.row
		col = math.ceil(contentSize.width / (self.cellSize.width + self.margin.col))
	end
	self.preloadSize = cc.size(col * (self.cellSize.height + self.margin.row), row * (self.cellSize.height + self.margin.row))
end
function GridScrollView:resetSize(num)
	if self.row == 0 then
		self.rowNum = math.ceil(num / self.col)
		self.colNum = self.col
		self:setDirection(ccui.ScrollViewDir.vertical)
	elseif self.col == 0 then
		self.colNum = math.ceil(num / self.row)
		self.rowNum = self.row
		self:setDirection(ccui.ScrollViewDir.horizontal)
	else
		self:setDirection(ccui.ScrollViewDir.both)
	end
	self.idleCells, _ENV = self.setDirection, self.setDirection
	if self.cellList then
		for i, cell in ipairs(self.cellList) do
			cell.idx = 0
			cell:setVisible(false)
			table.insert(self.idleCells, cell)
		end
	end
	local innerWidth = self.margin.left + self.colNum * (self.cellSize.width + self.margin.col) - self.margin.col
	local innerHeight = self.margin.top + self.rowNum * (self.cellSize.height + self.margin.row) - self.margin.row
	self:setInnerContainerSize(cc.size(innerWidth, innerHeight))
	self:updateFrame()
end
function GridScrollView:layout(index)
	local curRow, curCol
	index = index - 1
	if self.col == 0 then
		curRow = self.row ~= 0 and index % self.row or index
		curCol = self.row ~= 0 and math.floor(index / self.row) or index
	else
		curCol = self.col ~= 0 and index % self.col or index
		curRow = self.col ~= 0 and math.floor(index / self.col) or index
	end
	local innerSize = self:getInnerContainerSize()
	local x = curCol * (self.cellSize.width + self.margin.col) + self.margin.left
	local y = innerSize.height - curRow * (self.cellSize.height + self.margin.row) - self.cellSize.height - self.margin.top
	return cc.p(x, y)
end
function GridScrollView:findPos(pos)
	local innerSize = self:getInnerContainerSize()
	local col = math.floor((pos.x - self.margin.left) / (self.cellSize.width + self.margin.col))
	local row = math.floor((innerSize.height - pos.y - self.margin.top) / (self.cellSize.height + self.margin.row))
	local index
	if self.col == 0 then
		index = col * self.row + row
	else
		index = row * self.col + col
	end
	return util.clampf(index + 1, 1, self.cellNum)
end
function GridScrollView:updateFrame()
	if self.cellNum == 0 then
		return
	end
	local contentSize = self:getContentSize()
	local innerPos = cc.p(self:getInnerContainer():getPosition())
	local showRect = cc.rect(-innerPos.x, -innerPos.y + contentSize.height - self.preloadSize.height, self.preloadSize.width, self.preloadSize.height)
	local startIndex = self:findPos(cc.p(showRect.x, showRect.y + self.preloadSize.height))
	local endIndex = self:findPos(cc.p(showRect.x + showRect.width, showRect.y))
	local _ENV, cache = self, self
	for i, cell in ipairs(self.cellList) do
		if startIndex <= cell.idx and endIndex >= cell.idx and cell:isVisible() then
			cache[cell.idx] = true
		elseif cell:isVisible() then
			cell:setVisible(false)
			table.insert(self.idleCells, cell)
		end
	end
	for i = startIndex, endIndex do
		if not cache[i] then
			local cell = table.remove(self.idleCells)
			if not cell then
				cell = self.createCell()
				self:addChild(cell)
				table.insert(self.cellList, cell)
			else
				cell:setVisible(true)
			end
			local pos = self:layout(i)
			pos = util.convertOriginToAnchorEx(pos, self.virtualNode.anchor, self.virtualNode.size)
			cell:setPosition(pos)
			cell.idx = i
			self.updateCell(cell, i)
		end
	end
end
function GridScrollView:refreshData()
	for i, cell in ipairs(self.cellList) do
		self.updateCell(cell, cell.idx)
	end
end
function GridScrollView:clean()
	self:removeAllChildren()
	self.cellList, _UPVALUE0_, self.idleCells, _UPVALUE0_ = self.removeAllChildren, self.removeAllChildren, self.removeAllChildren, self.removeAllChildren
	self.cellNum = 0
	self:setInnerContainerSize(self:getContentSize())
end
function GridScrollView:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved then
		self:updateFrame()
	end
	if self.scrollEventCb then
		self.scrollEventCb(target, event)
	end
end
function GridScrollView:updateNum(num)
	if self.tmpInitData then
		self:realInit()
	end
	if 0 <= num then
		self.cellNum = num
		self:resetSize(num)
	end
end
function GridScrollView:jumpToIndex(index)
	if self.cellNum == 0 then
		return
	end
	index = util.clampf(index, 1, self.cellNum)
	local percent
	local pos = self:layout(index)
	local innerSize = self:getInnerContainerSize()
	local contentSize = self:getContentSize()
	local width = innerSize.width - contentSize.width
	local height = innerSize.height - contentSize.height
	if self.col == 0 then
		local centerX = pos.x - contentSize.width / 2 + self.cellSize.width / 2
		percent = centerX * 100 / width
		percent = util.clampf(percent, 0, 100)
		self:jumpToPercentHorizontal(percent)
	else
		local centerY = pos.y - contentSize.height / 2 + self.cellSize.height / 2
		percent = (height - centerY) * 100 / height
		percent = util.clampf(percent, 0, 100)
		self:jumpToPercentVertical(percent)
	end
	self:updateFrame()
end
function GridScrollView:scrollToIndex(index)
	if self.cellNum == 0 then
		return
	end
	index = util.clampf(index, 1, self.cellNum)
	local percent
	local pos = self:layout(index)
	local innerSize = self:getInnerContainerSize()
	local contentSize = self:getContentSize()
	local width = innerSize.width - contentSize.width
	local height = innerSize.height - contentSize.height
	if self.col == 0 and width == 0 or self.row == 0 and height == 0 then
		return
	end
	if self.col == 0 then
		local centerX = pos.x - contentSize.width / 2 + self.cellSize.width / 2
		percent = centerX * 100 / width
		percent = util.clampf(percent, 0, 100)
		self:scrollToPercentHorizontal(percent, 1, true)
	else
		local centerY = pos.y - contentSize.height / 2 + self.cellSize.height / 2
		percent = (height - centerY) * 100 / height
		print("percent = " .. percent .. " pos.y ＝ " .. pos.y .. " centerY " .. centerY .. " index = " .. index)
		percent = util.clampf(percent, 0, 100)
		self:scrollToPercentVertical(percent, 1, true)
	end
end
return GridScrollView

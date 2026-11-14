local timeLimitedItemCtrl = SoraDGetCtrl("timeLimitedItemCtrl")
local MAX_CELL_NUM = 60
local ITEM_UNIT = 126
local LINE_NUM = 5
local INFO_HEIGHT = 425
local baseComponent = require("fgui.base.baseComponent")
local Com_MC_bag = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MythicalCreatures/Com_MC_bag", Com_MC_bag)
function Com_MC_bag:createItemSingle(...)
	_UPVALUE2_ = nil
	;(nil)[1] = "MythicalCreatures"
	local (nil)[2], cfg = "Com_MC_Mark120", nil
	return fgui.UIPackage:createObject(cfg[1], cfg[2])
end
function Com_MC_bag:getMinBagCapacity(...)
	return 40
end
function Com_MC_bag:onInit()
	self.tableSpare, _ENV, self.tableSingle, _ENV, self.tableData, _ENV = nil, nil, nil, nil, nil, nil
	self.curItemID = nil
	self.curItemPos = nil
	self.curItem = nil
	self.tableNewItems, _ENV, self.isEffectRunning = nil, nil, false
	self:addEventListener(fgui.UIEventType.Scroll, function()
		self:refreshScroll()
	end)
end
function Com_MC_bag:onShow()
	if self.curItemID == nil and self.tableData[1] ~= nil then
		_ENV = nil
		;(nil).msg = "MESSAGE_UI_BAG_ITEM_CHOOSE"
		;(nil).pos = self.tableData[1].itemPos
		;(nil).data = self.tableData[1].data
		SoraDSendMessage(nil)
	end
end
function Com_MC_bag:onMarkUpdate(target, data)
	if self.fields.info:isVisible() then
		self.fields.info:updateMark()
	end
	dump(data, "Com_MC_bag:onMarkUpdate")
	if data.type == "upgrade" or data.type == "element" or data.type == "lock" then
		for i, v in ipairs(self.tableData) do
			if v.data.bagMarkId == data.bagMarkId and v.point ~= nil then
				v.point:updateMark()
			end
		end
	end
end
function Com_MC_bag:registerEvent()
	SoraDAddMessage(self, "MESSAGE_UPDATE_DIVINEBEAST_MARK", handler(self, self.onMarkUpdate))
	SoraDAddMessage(self, "MESSAGE_UI_BAG_ITEM_CHOOSE", function(target, retData)
		local line = retData.pos[2]
		local index = retData.pos[1]
		if self.fields.info:isVisible() then
			if self.curItemID and self.tableNewItems[self.curItemID] then
				self.tableNewItems[self.curItemID] = nil
			end
			if retData.data and (self.curItemPos[1] ~= retData.pos[1] or self.curItemPos[2] ~= retData.pos[2]) then
				self.curItemID = retData.data.bagMarkId
				self.curItemPos = retData.pos
				self:showSingleInfo(retData.data, line, index)
			else
				self.curItemID = nil
				self.curItemPos = nil
				self.curItem = nil
				self:updateScrollSize()
				self:refreshScroll()
				print("self.fields.info:setVisible========= 1")
				self.fields.info:setVisible(false)
				self.fields.info:setPosition(0, 0)
				if line >= math.ceil(#self.tableData / LINE_NUM) - 1 then
					self:getScrollPane():setPositionY(line * ITEM_UNIT)
					self:getScrollPane():updatePositionImmediately()
				end
			end
		elseif retData.data then
			self.curItemID = retData.data.bagMarkId
			self.curItemPos = retData.pos
			self:showSingleInfo(retData.data, line, index)
			local scrollInnerH = self:getInnerContainerSize().height
			local itemInfoYPos = self.fields.info:getPositionY() + INFO_HEIGHT
			if scrollInnerH < itemInfoYPos then
				self:getScrollPane():setPositionY(scrollInnerH)
				self:getScrollPane():updatePositionImmediately()
			end
		end
	end)
end
function Com_MC_bag:showSingleInfo(data, line, index, isJumpTo)
	self:updateScrollSize(line)
	self:refreshScroll()
	self.fields.info:initData(data, index)
	self.fields.info:setPositionY((line + 1) * ITEM_UNIT + 10)
	self.fields.info:setVisible(true)
	if isJumpTo then
		self:getScrollPane():setPositionY(line * ITEM_UNIT)
		self:getScrollPane():updatePositionImmediately()
	end
end
function Com_MC_bag:initData(data, curItemID)
	self:recyclingAll()
	self.tableNewItems, _ENV, self.tableData = self.recyclingAll, self.recyclingAll, data
	self:updateScrollSize()
	self:refreshScroll()
	self.fields.info:setVisible(false)
	self.fields.info:setPosition(0, 0)
	self.isEffectRunning = false
	if curItemID ~= nil then
		for i, v in ipairs(self.tableData) do
			if v.data.bagMarkId == tostring(curItemID) then
				_ENV = tostring(curItemID)
				tostring(curItemID).msg = "MESSAGE_UI_BAG_ITEM_CHOOSE"
				tostring(curItemID).pos = v.itemPos
				tostring(curItemID).data = v.data
				SoraDSendMessage((tostring(curItemID)))
			end
		end
	end
end
function Com_MC_bag:recyclingAll()
	for i, v in ipairs(self.tableData) do
		if v.point then
			v.point:setVisible(false)
			v.point:setPosition(0, 0)
			table.insert(self.tableSpare, v.point)
		end
	end
	timeLimitedItemCtrl:resetIndex()
	self.fields.info:setVisible(false)
	print("self.fields.info:setVisible========= 3")
	self.fields.info:setPosition(0, 0)
	self.curItemID = nil
	self.curItemPos = nil
	self.curItem = nil
	self.isEffectRunning = false
end
function Com_MC_bag:updateScrollSize(line)
	local scrollW = self:getContentSize().width
	local scrollH = math.max(math.ceil(#self.tableData / LINE_NUM) * ITEM_UNIT + (line and INFO_HEIGHT or 0), self:getContentSize().height) + 15
	for i = 1, #self.tableData do
		local _index = i % LINE_NUM == 0 and LINE_NUM or i % LINE_NUM
		local _line = math.ceil(i / LINE_NUM) - 1
		ITEM_UNIT = nil
		self.tableData[i].itemPos, (nil)[1] = nil, _index
		self.tableData[i].itemPos, (nil)[2] = nil, _line
		self.tableData[i].pos = cc.p(SoraDFPosX(ITEM_UNIT * (LINE_NUM - _index) + 3, scrollW - ITEM_UNIT + 1), _line * ITEM_UNIT + 15)
		if line and line < _line then
			self.tableData[i].pos.y = _line * ITEM_UNIT + INFO_HEIGHT + 15
		end
	end
	self:setInnerContainerSize(cc.size(scrollW, scrollH))
end
function Com_MC_bag:getItemPointByID(itemID)
	for i, v in ipairs(self.tableData) do
		if v.point and v.data and v.data.bagMarkId == itemID then
			return v.point
		end
	end
end
function Com_MC_bag:getItemInfoBtnUse()
	return self.fields.info:getBtnUse()
end
function Com_MC_bag:jumpTop()
	self:getScrollPane():scrollTop()
	self:getScrollPane():updatePositionImmediately()
	self:jumpToTop()
end
function Com_MC_bag:runJumpTop()
	self:getScrollPane():scrollTop()
	self:getScrollPane():updatePositionImmediately()
	self:setPositionY(120)
	self:runAction(ffa.exponentialOut(ffa.moveTo(0.3, self:getPositionX(), 50)))
end
function Com_MC_bag:addItemUseEffect(target, data)
	if self.curItem then
		self.isEffectRunning = true
		self.curItem:addItemUseEffect()
	end
end
function Com_MC_bag:getCurItem()
	return self.curItem
end
function Com_MC_bag:isEffect()
	return self.isEffectRunning
end
function Com_MC_bag:refreshScroll()
	local scrollH = self:getContentSize().height
	local offsetY = self:getScrollPane():getPositionY()
	_ENV = self:getScrollPane()
	self:getScrollPane().beginY = math.max(0, offsetY - 2 * ITEM_UNIT)
	local self:getScrollPane().endY, tableShowH = offsetY + scrollH + 2 * ITEM_UNIT, self:getScrollPane()
	for i, v in ipairs(self.tableData) do
		if v.pos.y < tableShowH.beginY or v.pos.y > tableShowH.endY then
			if v.point then
				v.point:setVisible(false)
				v.point:setPosition(0, 0)
				table.insert(self.tableSpare, v.point)
				v.point = nil
			end
		elseif v.point then
			v.point:setVisible(true)
			v.point:setPosition(v.pos.x, v.pos.y)
		elseif 0 < #self.tableSpare then
			v.point = table.remove(self.tableSpare)
			v.point:setVisible(true)
			v.point:initData(v.data, v.itemPos)
			v.point:setPosition(v.pos.x, v.pos.y)
		else
			local single = self:createItemSingle()
			self:addChild(single)
			v.point = single
			v.point:initData(v.data, v.itemPos)
			v.point:setPosition(v.pos.x, v.pos.y)
		end
		if v.point and v.point:isVisible() then
			if v.data and self.curItemID and self.curItemID == v.data.bagMarkId and self.curItemPos and self.curItemPos[1] == v.itemPos[1] and self.curItemPos[2] == v.itemPos[2] then
				self.curItem = v.point
				v.point:setSelected(true)
			else
				v.point:setSelected(false)
			end
		end
	end
end
function Com_MC_bag:getTableItemsSingle(data)
	local _ENV, tableItemsSingle
	for i, v in ipairs(data) do
		_ENV = nil
		tableItemsSingle[i], (nil).data = nil, v
	end
	local total = 0
	local capacity = self:getMinBagCapacity()
	if capacity and capacity > #tableItemsSingle then
		total = capacity
	elseif #tableItemsSingle % LINE_NUM ~= 0 then
		total = math.ceil(#tableItemsSingle / LINE_NUM) * LINE_NUM
	end
	for i = #tableItemsSingle + 1, total do
		tableItemsSingle[i], _ENV = nil, nil
	end
	return tableItemsSingle
end
return Com_MC_bag

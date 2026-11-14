local timeLimitedItemCtrl = SoraDGetCtrl("timeLimitedItemCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local MAX_CELL_NUM = 60
local ITEM_UNIT = 126
local LINE_NUM = 5
local baseComponent = require("fgui.base.baseComponent")
local ScrollView_bag = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://bagView/ScrollView_bag", ScrollView_bag)
local MIN_BAG_CAPACITY = 40
_ENV = "ui://bagView/ScrollView_bag"
;("ui://bagView/ScrollView_bag").NORMAL = 1
;("ui://bagView/ScrollView_bag").WARGEM = 2
;("ui://bagView/ScrollView_bag").WARFRAME = 3
local _ENV, ("ui://bagView/ScrollView_bag").HEROCHIP, BAG_TYPE = ScrollView_bag, 4, "ui://bagView/ScrollView_bag"
_UPVALUE2_ = nil
ScrollView_bag[BAG_TYPE.NORMAL], (nil)[1] = nil, "bagView"
ScrollView_bag[BAG_TYPE.NORMAL], (nil)[2] = nil, "itemSingleView"
_UPVALUE2_ = nil
ScrollView_bag[BAG_TYPE.WARGEM], (nil)[1] = nil, "WarGem"
ScrollView_bag[BAG_TYPE.WARGEM], (nil)[2] = nil, "WarGemItemSingle"
_UPVALUE2_ = nil
ScrollView_bag[BAG_TYPE.WARFRAME], (nil)[1] = nil, "BrilliantBrave"
ScrollView_bag[BAG_TYPE.WARFRAME], (nil)[2] = nil, "WarframeBagItemSingle"
_UPVALUE2_ = nil
ScrollView_bag[BAG_TYPE.HEROCHIP], (nil)[1] = nil, "NewHeroView"
ScrollView_bag[BAG_TYPE.HEROCHIP], (nil)[2] = nil, "Com_exChipItem"
local config = ScrollView_bag
function ScrollView_bag:createItemSingle(...)
	local cfg = config[self.bagType]
	return fgui.UIPackage:createObject(cfg[1], cfg[2])
end
function ScrollView_bag:getMinBagCapacity(...)
	BAG_TYPE = nil
	;(nil)[BAG_TYPE.NORMAL] = MIN_BAG_CAPACITY
	;(nil)[BAG_TYPE.WARGEM] = WAR_GEM_BAG_CELL_MAX_SHOW
	local (nil)[BAG_TYPE.WARFRAME], config = 40, nil
	return config[self.bagType]
end
function ScrollView_bag:onInit()
	self.tableSpare, BAG_TYPE, self.tableSingle, BAG_TYPE, self.tableData, BAG_TYPE = nil, nil, nil, nil, nil, nil
	self.curItemID = nil
	self.curItemPos = nil
	self.curItem = nil
	self.tableNewItems, BAG_TYPE, self.isEffectRunning = nil, nil, false
	self.bagType = BAG_TYPE.NORMAL
	self:getScrollPane():AddEventListener1(fgui.UIEventType.Scroll, function()
		self:refreshScroll()
	end)
end
function ScrollView_bag:onShow()
end
function ScrollView_bag:registerEvent()
	SoraDAddMessage(self, "MESSAGE_UI_BAG_ITEM_CHOOSE", function(target, retData)
		local line = retData.pos[2]
		local index = retData.pos[1]
		if self.fields.info:isVisible() then
			if self.curItemID and self.tableNewItems[self.curItemID] then
				self.tableNewItems[self.curItemID] = nil
			end
			if retData.data and (self.curItemPos[1] ~= retData.pos[1] or self.curItemPos[2] ~= retData.pos[2]) then
				self.curItemID = retData.data.id
				self.curItemPos = retData.pos
				self:showSingleInfo(retData.data, line, index)
				self:checkItemInfoPos()
			else
				self.curItemID = nil
				self.curItemPos = nil
				self.curItem = nil
				self:updateScrollSize()
				self:refreshScroll()
				self.fields.info:setVisible(false)
				self.fields.info:setPosition(0, 0)
				if line >= math.ceil(#self.tableData / LINE_NUM) - 1 then
					self:getScrollPane():setPositionY(line * ITEM_UNIT)
					self:getScrollPane():updatePositionImmediately()
				end
			end
		elseif retData.data then
			self.curItemID = retData.data.id
			self.curItemPos = retData.pos
			self:showSingleInfo(retData.data, line, index)
			self:checkItemInfoPos()
		end
	end)
end
function ScrollView_bag:checkItemInfoPos(...)
	local scrollH = self:getContentSize().height
	local offsetY = self:getScrollPane():getPositionY()
	local itemInfoYPos = self.fields.info:getPositionY()
	local itemInfoH = self.fields.info:getHeight()
	local _offsetY = itemInfoYPos + itemInfoH - scrollH
	print("==itemInfoYPos==", itemInfoYPos, itemInfoH, scrollH, _offsetY, offsetY)
	if offsetY < _offsetY then
		self:getScrollPane():setPositionY(_offsetY)
		self:getScrollPane():updatePositionImmediately()
	end
end
function ScrollView_bag:showSingleInfo(data, line, index, isJumpTo)
	self:updateScrollSize(line)
	self:refreshScroll()
	ITEM_UNIT = nil
	;(nil).bagType = self.bagType
	self.fields.info:initData(data, index, nil)
	self.fields.info:setPositionY((line + 1) * ITEM_UNIT + 10)
	self.fields.info:setVisible(true)
	if isJumpTo then
		self:getScrollPane():setPositionY(line * ITEM_UNIT)
		self:getScrollPane():updatePositionImmediately()
	end
end
function ScrollView_bag:initData(data, tag)
	self:recyclingAll()
	self.tableData = data
	self.tag = tag
	self.tableNewItems = backpackCtrl:getNewItemInfoByType(self.tag)
	self:updateScrollSize()
	self:refreshScroll()
	self.fields.info:setVisible(false)
	self.fields.info:setPosition(0, 0)
	self.isEffectRunning = false
end
function ScrollView_bag:recyclingAll()
	for i, v in ipairs(self.tableData) do
		if v.point then
			v.point:setVisible(false)
			v.point:setPosition(0, 0)
			table.insert(self.tableSpare, v.point)
		end
	end
	timeLimitedItemCtrl:resetIndex()
	self.fields.info:setVisible(false)
	self.fields.info:setPosition(0, 0)
	self.curItemID = nil
	self.curItemPos = nil
	self.curItem = nil
	self.isEffectRunning = false
end
function ScrollView_bag:updateScrollSize(line)
	local scrollW = self:getContentSize().width
	local scrollH = math.max(math.ceil(#self.tableData / LINE_NUM) * ITEM_UNIT + (line and 230 or 0), self:getContentSize().height) + 15
	for i = 1, #self.tableData do
		local _index = i % LINE_NUM == 0 and LINE_NUM or i % LINE_NUM
		local _line = math.ceil(i / LINE_NUM) - 1
		ITEM_UNIT = nil
		self.tableData[i].itemPos, (nil)[1] = nil, _index
		self.tableData[i].itemPos, (nil)[2] = nil, _line
		self.tableData[i].pos = cc.p(SoraDFPosX(ITEM_UNIT * (LINE_NUM - _index) + 3, scrollW - ITEM_UNIT + 16), _line * ITEM_UNIT + 15)
		if line and line < _line then
			self.tableData[i].pos.y = _line * ITEM_UNIT + 230 + 15
		end
	end
	self:setInnerContainerSize(cc.size(scrollW, scrollH))
end
function ScrollView_bag:getItemPointByID(itemID)
	for i, v in ipairs(self.tableData) do
		if v.point and v.data and v.data.id == itemID then
			return v.point
		end
	end
end
function ScrollView_bag:getItemInfoBtnUse()
	return self.fields.info:getBtnUse()
end
function ScrollView_bag:jumpTop()
	self:getScrollPane():scrollTop()
	self:getScrollPane():updatePositionImmediately()
	self:jumpToTop()
end
function ScrollView_bag:runJumpTop()
	self:getScrollPane():scrollTop()
	self:getScrollPane():updatePositionImmediately()
	self:setPositionY(120)
	self:runAction(ffa.exponentialOut(ffa.moveTo(0.3, self:getPositionX(), 50)))
end
function ScrollView_bag:addItemUseEffect(target, data)
	if self.curItem then
		self.isEffectRunning = true
		self.curItem:addItemUseEffect()
	end
end
function ScrollView_bag:getCurItem()
	return self.curItem
end
function ScrollView_bag:isEffect()
	return self.isEffectRunning
end
function ScrollView_bag:refreshScroll()
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
				local itemData = v.point:getItemData()
				if itemData then
					local itemType = backpackltCtrl:getItemType(itemData.id)
					if itemType == gItemType.TREASURE_CRYSTAL or itemType == gItemType.PANDORABOX or itemType == gItemType.TREASURE_MAP then
						if itemData.isLimitedItem then
							timeLimitedItemCtrl:addtLimitedItem(itemData.id, itemData.isLimitedItem)
						else
							timeLimitedItemCtrl:addtInUseLimitedItem(itemData.id, itemData.isInUseLimitedItem)
						end
						if itemType == gItemType.PANDORABOX then
							timeLimitedItemCtrl:addtBoxIndex(itemData.id, itemData.pandoraIndex)
						end
					end
				end
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
			v.point = self:createItemSingle()
			self:addChild(v.point)
			v.point:initData(v.data, v.itemPos)
			v.point:setPosition(v.pos.x, v.pos.y)
		end
		if not tolua.isnull(v.point) and v.point:isVisible() then
			if v.data and self.tableNewItems[v.data.id] then
				v.point:setNewVisible(true)
			else
				v.point:setNewVisible(false)
			end
			if v.data and self.curItemID and self.curItemID == v.data.id and self.curItemPos and self.curItemPos[1] == v.itemPos[1] and self.curItemPos[2] == v.itemPos[2] then
				self.curItem = v.point
				v.point:setSelected(true)
				backpackCtrl:clickNewItem(self.curItemID)
				_ENV = backpackCtrl
				backpackCtrl.msg = "MESSAGE_UI_BAG_TAB_UPDATE"
				SoraDSendMessage(backpackCtrl)
			else
				v.point:setSelected(false)
			end
		end
	end
end
function ScrollView_bag:initWarGemData(data, bagType)
	self.bagType = bagType or BAG_TYPE.WARGEM
	self:recyclingAll()
	self.tableData = self:getTableItemsSingle(data)
	self:updateScrollSize()
	self:refreshScroll()
end
function ScrollView_bag:initHeroChipData(data, bagType)
	self.bagType = bagType or BAG_TYPE.HEROCHIP
	self:recyclingAll()
	self.tableData = self:getTableItemsSingle(data)
	self:updateScrollSize()
	self:refreshScroll()
end
function ScrollView_bag:getTableItemsSingle(data)
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
return ScrollView_bag

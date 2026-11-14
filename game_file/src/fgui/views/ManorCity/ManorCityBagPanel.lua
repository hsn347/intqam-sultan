local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local manorCityRead = include("manorCityRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ManorCityBagPanel = class("ManorCityBagPanel", baseFguiPanel)
local LINE_NUM = 5
local MIN_BAG_CAPACITY = 40
local ITEM_INFO_HEIGHT = 296
_ENV = nil
;(nil).SINGLE = 1
local (nil).INFO, ITEM_TYPE = 2, nil
function ManorCityBagPanel:ctor(...)
	self.isLRU = true
	ManorCityBagPanel.super.ctor(self, ...)
	print("ManorCityBagPanel:ctor", self.viewName)
end
function ManorCityBagPanel:onInit()
	print("=======ManorCityBagPanel:onInit")
	self.fields.Com_title:initData(i18n("decoration_btn_01"), handler(self, self.onClickClose))
	self.fields.List:setVirtual()
	self.fields.List:setItemProvider(handler(self, self.onItemProvider))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem))
	self.fields.Button_merge:setString(i18n("decoration_btn_02"))
	self.fields.Button_merge:addClickListener(handler(self, self.onClickBtnMerge))
end
function ManorCityBagPanel:endShow()
	print("=======ManorCityBagPanel:endShow")
	self.curSelectIndex = nil
	_ENV, self.allData, _ENV, self.curItemIndex = print, print, print, nil
	_ENV, _ENV, print.defaultClick = nil, "=======ManorCityBagPanel:endShow", 1
	;(nil).title = i18n("common_text_635")
	_ENV, ("=======ManorCityBagPanel:endShow")[1], (nil).quality = nil, nil, 0
	;(nil).title = i18n("decoration_text_01")
	_ENV, ("=======ManorCityBagPanel:endShow")[2], (nil).quality = nil, nil, 4
	;(nil).title = i18n("atlantiswar_skill_text_018")
	_ENV, ("=======ManorCityBagPanel:endShow")[3], (nil).quality = nil, nil, 3
	;(nil).title = i18n("begging_text_03")
	_ENV, ("=======ManorCityBagPanel:endShow")[4], (nil).quality = nil, nil, 2
	;(nil).title = i18n("common_text_2697")
	print.tabsetArray, ("=======ManorCityBagPanel:endShow")[5], (nil).quality = "=======ManorCityBagPanel:endShow", nil, 1
	local print.callback, param = handler(self, self.onClickTab), print
	self.tabsetArray = param.tabsetArray
	self.fields.Com_title:initTab(param)
	manorCityCtrl:reqDressInit()
end
function ManorCityBagPanel:onClickTab(tag)
	self.curTag = tag
	self:updateItemList()
end
function ManorCityBagPanel:updateItemList()
	local quality = self.tabsetArray[self.curTag].quality
	if not self.allData[quality] then
		_UPVALUE0_ = self.allData[quality]
	end
	self.itemData = self.allData[quality]
	self.fields.List:setNumItems(#self.itemData)
end
function ManorCityBagPanel:onItemProvider(index)
	local data = self.itemData[index + 1]
	if data.type == ITEM_TYPE.INFO then
		if index == self.curItemIndex then
			return "ui://ManorCity/Com_bagItemInfo"
		else
			return "ui://CommonNew/Com_empty"
		end
	else
		return "ui://ManorCity/Com_bagItemSingle"
	end
end
function ManorCityBagPanel:onItemRenderer(index, obj)
	local data = self.itemData[index + 1]
	if data.type == ITEM_TYPE.INFO then
		local _data = self.itemData[self.curSelectIndex + 1]
		self:initItemInfo(index, obj, _data.data)
	else
		self:initItemSingle(index, obj, data.data)
	end
end
function ManorCityBagPanel:initItemInfo(index, obj, data)
	obj:setHeight(ITEM_INFO_HEIGHT)
	if index ~= self.curItemIndex then
		obj:setVisible(false)
		return
	end
	local curSelectObj = self.fields.List:getChildAt(self.curSelectIndex)
	local curPosX = curSelectObj:getPositionX() + curSelectObj:getWidth() / 2
	ITEM_INFO_HEIGHT = nil
	;(nil).dressId = data.id
	;(nil).curPosX = curPosX
	obj:initData(nil)
end
function ManorCityBagPanel:initItemSingle(index, obj, data)
	local c_empty = obj:getController("c_empty")
	if not data then
		c_empty:setSelectedIndex(1)
	else
		c_empty:setSelectedIndex(0)
		local item = obj:getChild("item")
		item:initData(data.id, data.count)
	end
end
function ManorCityBagPanel:onClickItem(EventContext)
	SoraDPlaySound()
	local obj = EventContext:getGObjectData()
	local childIndex = self.fields.List:getChildIndex(obj)
	local itemIndex = self.fields.List:childIndexToItemIndex(childIndex)
	print("==ManorCityBagPanel:onClickItem==", childIndex, itemIndex, self.curItemIndex)
	if self.curItemIndex and self.curItemIndex == itemIndex then
		return
	end
	if self.curSelectIndex and self.curSelectIndex == itemIndex then
		self:hideItemInfo()
		return
	end
	local data = self.itemData[itemIndex + 1]
	if data.data then
		self:showItemInfo(itemIndex)
	else
		self:hideItemInfo()
	end
end
function ManorCityBagPanel:showItemInfo(itemIndex)
	if self.curSelectIndex then
		if itemIndex > self.curItemIndex then
			itemIndex = itemIndex - LINE_NUM
		end
		self:hideItemInfo()
	end
	self.curSelectIndex = itemIndex
	local idx = math.ceil((itemIndex + 1) / LINE_NUM) * LINE_NUM
	self.curItemIndex = idx
	for i = 1, LINE_NUM do
		LINE_NUM = nil
		;(nil).type = ITEM_TYPE.INFO
		table.insert(self.itemData, idx + i, nil)
	end
	self.fields.List:setNumItems(#self.itemData)
	self.fields.List:scrollToView(idx)
end
function ManorCityBagPanel:hideItemInfo()
	if not self.curItemIndex then
		return
	end
	for i = 1, LINE_NUM do
		table.remove(self.itemData, self.curItemIndex + 1)
	end
	self.fields.List:setNumItems(#self.itemData)
	self.curItemIndex = nil
	self.curSelectIndex = nil
end
function ManorCityBagPanel:getItemData(data)
	local _ENV, itemData
	for i, v in ipairs(data) do
		_ENV = nil
		itemData[i], (nil).data = nil, v
	end
	local total = 0
	local capacity = MIN_BAG_CAPACITY
	if capacity and capacity > #itemData then
		total = capacity
	elseif #itemData % LINE_NUM ~= 0 then
		total = math.ceil(#itemData / LINE_NUM) * LINE_NUM
	end
	for i = #itemData + 1, total do
		itemData[i], _ENV = nil, nil
	end
	return itemData
end
function ManorCityBagPanel:onClickBtnMerge(context)
	SoraDPlaySound()
	uiManager:show("ManorCityMerge")
end
function ManorCityBagPanel:updateBackpackData()
	local manorCityCtrl, allData
	local bagData = manorCityCtrl:getBackpackData()
	allData[0] = bagData
	for i, v in ipairs(bagData) do
		local dressId = v.id
		local quality = manorCityRead.getDressQuality(dressId)
		if not allData[quality] then
			manorCityCtrl = allData[quality]
		end
		allData[quality] = allData[quality]
		table.insert(allData[quality], v)
	end
	self.allData = allData
	for k, v in pairs(self.allData) do
		self.allData[k] = self:getItemData(v)
	end
end
function ManorCityBagPanel:onMsgBackpackUpdate(target, event)
	self.curSelectIndex = nil
	self.curItemIndex = nil
	self:updateBackpackData()
	self:updateItemList()
end
return ManorCityBagPanel

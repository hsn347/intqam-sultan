local baseComponent = require("fgui.base.baseComponent")
local UI_Panel_tabList = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonUI/UI_Panel_tabList", UI_Panel_tabList)
fgui.register_extension("ui://CommonUI/UI_Panel_tabListW", UI_Panel_tabList)
fgui.register_extension("ui://CommonUI/UI_Panel_tabList_new", UI_Panel_tabList)
function UI_Panel_tabList:onInit()
	self.maxTabNum = 5
	self.curTab = 1
	self.fields.List:setItemRenderer(handler(self, self.onItemRenerer))
	self.fields.List:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem))
end
function UI_Panel_tabList:onShow()
	self.fields.List:setNumItems(self.tabNum or 0)
end
function UI_Panel_tabList:initView(param, maxTabNum)
	if not param.tabsetArray then
		local _ENV, paramArray = param.tabsetArray, param.tabsetArray
	end
	self.paramArray = paramArray
	self.tabNum = #paramArray
	self.isAutoSize = param.isAutoSize or true
	self.maxTabNum = maxTabNum and maxTabNum or 5
	self.fields.List:setNumItems(self.tabNum)
	self:setListScroll(self.tabNum > self.maxTabNum)
	for i, v in ipairs(paramArray) do
		local button = self:getBtn(i)
		if button then
			button:setString(v.title)
			button:setTag(v.tag or i)
			if button.isShowLock then
				button:isShowLock(v.isLock or false)
			end
			if v.isBright ~= nil then
				button:setBright(v.isBright)
			end
			if v.isGrayed ~= nil then
				button:setGrayed(v.isGrayed)
			end
			if v.isEnabled ~= nil then
				button:setEnabled(v.isEnabled)
			end
		end
	end
	local callback = param.callback
	if callback then
		self:setBtnCallback(callback)
	end
	local defaultClick = param.defaultClick or 1
	self.curTab = defaultClick
	if param.unDefaultClick == nil then
		for i, v in ipairs(paramArray) do
			local tag = v.tag or i
			if tag == defaultClick then
				self:setDefaultClick(i, defaultClick)
				break
			end
		end
	end
end
function UI_Panel_tabList:onItemRenerer(index, obj)
	obj:setTag(self:getBtnTag(index + 1))
	if self.isAutoSize then
		obj:setWidth(self:getItemWidth())
	end
end
function UI_Panel_tabList:onClickItem()
	local index = self.fields.List:getSelectedIndex() + 1
	SoraDPlaySound()
	self:clickTab(index)
end
function UI_Panel_tabList:clickTab(index)
	if self.callback then
		if self:getBtnTag(index) ~= self.curTab then
			self.callback(self:getBtnTag(index))
		end
		if not tolua.isnull(self) then
			self.curTab = self:getBtnTag(self.fields.List:getSelectedIndex() + 1)
		end
	end
end
function UI_Panel_tabList:getBtnTag(index)
	if self.paramArray and self.paramArray[index] then
		return self.paramArray[index].tag or index
	end
	return index
end
function UI_Panel_tabList:getItemWidth()
	local num = self.tabNum > self.maxTabNum and self.maxTabNum or self.tabNum
	return (self.fields.List:getWidth() - self.fields.List:getColumnGap() * (num - 1)) / num
end
function UI_Panel_tabList:setBtnRedDot(index, visible, num)
	local btn = self:getBtn(index)
	if btn then
		btn:setReddot(visible, num)
	end
end
function UI_Panel_tabList:setBtnTitle(index, str)
	local btn = self:getBtn(index)
	if btn then
		btn:setString(str)
	end
end
function UI_Panel_tabList:getBtn(index)
	if index <= self.fields.List:getChildrenCount() then
		return self.fields.List:getChildAt(index - 1)
	end
end
function UI_Panel_tabList:setTabIndex(index, fireEvent)
	self.fields.List:setSelectedIndex(index - 1)
	self.fields.List:scrollToView(index - 1)
	if fireEvent and self.callback then
		local tab = self:getBtnTag(index)
		self.callback(tab)
		self.curTab = tab
	end
end
function UI_Panel_tabList:setTabByTag(tag, fireEvent)
	for i, v in ipairs(self.paramArray) do
		if v.tag == tag then
			self:setTabIndex(i, fireEvent)
			return
		end
	end
end
function UI_Panel_tabList:setToTab(index)
	self.fields.List:setSelectedIndex(index - 1)
end
function UI_Panel_tabList:setTabNum(num, startIndex, isAutoSize)
	self.tabNum = num
	self.isAutoSize = isAutoSize or true
	self:updateList()
	self:setTabIndex(startIndex or 1)
	if self.tabNum <= self.maxTabNum then
		self:setListScroll(false)
	else
		self:setListScroll(true)
	end
end
function UI_Panel_tabList:setDefaultClick(index, tag)
	self:setTabIndex(index, true)
end
function UI_Panel_tabList:updateList()
	self.fields.List:setNumItems(self.tabNum)
end
function UI_Panel_tabList:setBtnCallback(callback)
	self.callback = callback
end
function UI_Panel_tabList:setListScroll(value)
	self.fields.List:setScrollEnable(value)
	self.fields.List:setScrollItemToViewOnClick(value)
end
function UI_Panel_tabList:setNewState(index, isVisible)
	local button = self:getBtn(index)
	button:setNewState(isVisible)
end
function UI_Panel_tabList:getTabNum()
	return self.tabNum
end
return UI_Panel_tabList

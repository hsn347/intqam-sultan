local baseComponent = require("fgui.base.baseComponent")
local Panel_tabList = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonNew/Panel_tabList", Panel_tabList)
fgui.register_extension("ui://CommonNew/Panel_tabList2", Panel_tabList)
fgui.register_extension("ui://CommonNew/Panel_tabListW", Panel_tabList)
fgui.register_extension("ui://CommonNew/Panel_tabListW2", Panel_tabList)
fgui.register_extension("ui://EventCenterView/EventCenter_tabList", Panel_tabList)
fgui.register_extension("ui://Activity_9001643/Panel_tabList", Panel_tabList)
fgui.register_extension("ui://Activity_9001665/Panel_tabList", Panel_tabList)
function Panel_tabList:onInit()
	self.maxTabNum = 5
	self.curTab = 1
	self.fields.List:setItemRenderer(handler(self, self.onItemRenerer))
	self.fields.List:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem))
end
function Panel_tabList:onClickItem()
	local index = self.fields.List:getSelectedIndex() + 1
	SoraDPlaySound()
	self:clickTab(index)
end
function Panel_tabList:clickTab(index)
	if self.callback then
		if self:getBtnTag(index) ~= self.curTab then
			self.callback(self:getBtnTag(index))
		end
		if not tolua.isnull(self) then
			self.curTab = self:getBtnTag(self.fields.List:getSelectedIndex() + 1)
		end
	end
end
function Panel_tabList:setLineVisible(ret)
	self.controllers.c2:setSelectedIndex(ret and 0 or 1)
end
function Panel_tabList:onItemRenerer(index, obj)
	obj:setTag(self:getBtnTag(index + 1))
	if self.isAutoSize then
		obj:setWidth(self:getItemWidth())
	end
end
function Panel_tabList:getBtnTag(index)
	if self.paramArray and self.paramArray[index] then
		return self.paramArray[index].tag or index
	end
	return index
end
function Panel_tabList:getItemWidth()
	local num = self.tabNum > self.maxTabNum and self.maxTabNum or self.tabNum
	return (self.fields.List:getWidth() - 2 - self.fields.List:getColumnGap() * (num - 1)) / num
end
function Panel_tabList:setBtnRedDot(index, visible, num)
	local btn = self:getBtn(index)
	if btn then
		btn:setReddot(visible, num)
	end
end
function Panel_tabList:setBtnTitle(index, str)
	local btn = self:getBtn(index)
	if btn then
		btn:setString(str)
	end
end
function Panel_tabList:setBtnShowYes(index, isShow)
	local btn = self:getBtn(index)
	if btn and btn.showYes then
		btn:showYes(isShow)
	end
end
function Panel_tabList:getBtn(index)
	if index <= self.fields.List:getChildrenCount() then
		return self.fields.List:getChildAt(index - 1)
	end
end
function Panel_tabList:setTabIndex(index, fireEvent)
	self.fields.List:setSelectedIndex(index - 1)
	self.fields.List:scrollToView(index - 1)
	if fireEvent and self.callback then
		local tab = self:getBtnTag(index)
		self.callback(tab)
		self.curTab = tab
	end
end
function Panel_tabList:setTabByTag(tag, fireEvent)
	for i, v in ipairs(self.paramArray) do
		if v.tag == tag then
			self:setTabIndex(i, fireEvent)
			return
		end
	end
end
function Panel_tabList:setToTab(index)
	self.fields.List:setSelectedIndex(index - 1)
end
function Panel_tabList:onShow()
	self.fields.List:setNumItems(self.tabNum or 0)
end
function Panel_tabList:initView(param, maxTabNum)
	if not param.tabsetArray then
		local _ENV, paramArray = param.tabsetArray, param.tabsetArray
	end
	self.paramArray = paramArray
	self.tabNum = #paramArray
	if param.isAutoSize ~= nil then
		self.isAutoSize = param.isAutoSize
	else
		self.isAutoSize = true
	end
	self.maxTabNum = maxTabNum and maxTabNum or 5
	self.fields.List:setNumItems(self.tabNum)
	if self.tabNum <= self.maxTabNum then
		self:setListScroll(false)
	else
		self:setListScroll(true)
	end
	for i, v in ipairs(paramArray) do
		local button = self:getBtn(i)
		if button then
			button:setString(v.title)
			button:setTag(v.tag or i)
			if button.isShowLock then
				button:isShowLock(v.isLock or false)
			end
			if button.showYes then
				button:showYes(v.isYes or false)
			end
			if v.isBright ~= nil then
				button:setBright(v.isBright)
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
function Panel_tabList:setTabNum(num, startIndex, isAutoSize)
	self.tabNum = num
	self.isAutoSize = isAutoSize or true
	self:_updateList()
	self:setTabIndex(startIndex or 1)
	if self.tabNum <= self.maxTabNum then
		self:setListScroll(false)
	else
		self:setListScroll(true)
	end
end
function Panel_tabList:setDefaultClick(index, tag)
	self:setTabIndex(index, true)
end
function Panel_tabList:_updateList()
	self.fields.List:setNumItems(self.tabNum)
end
function Panel_tabList:setBtnCallback(callback)
	self.callback = callback
end
function Panel_tabList:setBtnTitle1(str)
	self:setBtnTitle(1, str)
end
function Panel_tabList:setBtnTitle2(str)
	self:setBtnTitle(2, str)
end
function Panel_tabList:setBtnTitle3(str)
	self:setBtnTitle(3, str)
end
function Panel_tabList:setBtnTitle4(str)
	self:setBtnTitle(4, str)
end
function Panel_tabList:setBtnTitle5(str)
	self:setBtnTitle(5, str)
end
function Panel_tabList:setListScroll(value)
	self.fields.List:setScrollEnable(value)
	self.fields.List:setScrollItemToViewOnClick(value)
end
function Panel_tabList:setTimeLimitState(index, isVisible, offset)
	offset = offset or cc.p(-10, -10)
	local button = self:getBtn(index)
	local Sprite_limit = button:getChild("Sprite_limit")
	if Sprite_limit then
		Sprite_limit:setVisible(isVisible)
	end
end
function Panel_tabList:setNewState(index, isVisible)
	local button = self:getBtn(index)
	local Sprite_new = button:getChild("Sprite_new")
	if Sprite_new then
		Sprite_new:setVisible(isVisible)
	end
end
function Panel_tabList:getTabNum()
	return self.tabNum
end
return Panel_tabList

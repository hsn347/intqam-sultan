local baseComponent = require("fgui.base.baseComponent")
local Com_tab = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://resourceBuy/Com_tab", Com_tab)
function Com_tab:onInit()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenerer))
	self.fields.List:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem))
end
function Com_tab:onItemRenerer(index, obj)
	obj:setTag(self:getBtnTag(index + 1))
	obj:setWidth(self:getItemWidth())
end
function Com_tab:onClickItem()
	SoraDPlaySound()
	self:clickTab(self.fields.List:getSelectedIndex() + 1)
end
function Com_tab:clickTab(index)
	if self.callback then
		self.callback(self:getBtnTag(index))
	end
end
function Com_tab:getBtnTag(index)
	if self.paramArray and self.paramArray[index] then
		return self.paramArray[index].tag or index
	end
	return index
end
function Com_tab:getItemWidth()
	local num = self.tabNum > 5 and 5 or self.tabNum
	return (self.fields.List:getWidth() - self.fields.List:getColumnGap() * (num - 1)) / num
end
function Com_tab:onShow()
end
function Com_tab:initView(param)
	self.paramArray = param.tabsetArray
	self.tabNum = #param.tabsetArray
	self.fields.List:setNumItems(self.tabNum)
	if self.tabNum <= 5 then
		self:setListScroll(false)
	else
		self:setListScroll(true)
	end
	for i, v in ipairs(self.paramArray) do
		local button = self:getBtn(i)
		if button then
			button:initData(v.resID)
			button:setTag(v.tag or i)
		end
	end
	local callback = param.callback
	if callback then
		self:setBtnCallback(callback)
	end
	local defaultClick = param.defaultClick or 1
	for i, v in ipairs(self.paramArray) do
		local tag = v.tag or i
		if tag == defaultClick then
			self:setDefaultClick(i, defaultClick)
			break
		end
	end
end
function Com_tab:updateRes(needResList)
	for i, v in ipairs(self.paramArray) do
		local button = self:getBtn(i)
		if button then
			button:initData(v.resID, needResList)
		end
	end
end
function Com_tab:setDefaultClick(index, tag)
	self:setTabIndex(index, true)
end
function Com_tab:setTabIndex(index, fireEvent)
	self.fields.List:setSelectedIndex(index - 1)
	self.fields.List:scrollToView(index - 1)
	if fireEvent and self.callback then
		local tab = self:getBtnTag(index)
		self.callback(tab)
	end
end
function Com_tab:getBtn(index)
	return self.fields.List:getChildAt(index - 1)
end
function Com_tab:setBtnCallback(callback)
	self.callback = callback
end
function Com_tab:setListScroll(value)
	self.fields.List:setScrollEnable(value)
	self.fields.List:setScrollItemToViewOnClick(value)
end
return Com_tab

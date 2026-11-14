local baseComponent = require("fgui.base.baseComponent")
local Panel_tabTwo = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonNew/Panel_tabTwo", Panel_tabTwo)
fgui.register_extension("ui://CommonNew/Panel_tabThree", Panel_tabTwo)
fgui.register_extension("ui://CommonNew/Panel_tabFour", Panel_tabTwo)
fgui.register_extension("ui://CommonNew/Panel_tabFive", Panel_tabTwo)
fgui.register_extension("ui://CommonNew/Panel_tabTwo2", Panel_tabTwo)
fgui.register_extension("ui://CommonNew/Panel_tabTwo3", Panel_tabTwo)
fgui.register_extension("ui://ArtisanHouse/Panel_tabTwo", Panel_tabTwo)
fgui.register_extension("ui://RadiantDecree/Panel_tabTwo", Panel_tabTwo)
function Panel_tabTwo:ctor(...)
	self.super.ctor(self, ...)
end
function Panel_tabTwo:onInit()
	self.curTab = 1
	for i = 1, 5 do
		local button = self:getBtn(i)
		if button then
			button:setTag(i)
			button:addClickListener(handler(self, self.onClickTab))
			button:fixPos()
		end
	end
end
function Panel_tabTwo:onClickTab(eventContext)
	SoraDPlaySound()
	self:clickTab(eventContext:getSender():getTag())
end
function Panel_tabTwo:clickTab(index, isDefault)
	if self.callback then
		if isDefault then
			self.callback(index)
		elseif index ~= self.curTab and self.callback(index) then
			return
		end
		self.curTab = index
	end
end
function Panel_tabTwo:setBtnRedDot(index, visible, num)
	self:getBtn(index):setReddot(visible, num)
end
function Panel_tabTwo:getBtn(index)
	return self.fields["Button_tab" .. index]
end
function Panel_tabTwo:onShow()
end
function Panel_tabTwo:setBtnTitle(index, str)
	self:getBtn(index):setString(str)
end
function Panel_tabTwo:setBtnTitle1(str)
	self.fields.Button_tab1:setString(str)
end
function Panel_tabTwo:setBtnTitle2(str)
	self.fields.Button_tab2:setString(str)
end
function Panel_tabTwo:setBtnTitle3(str)
	self.fields.Button_tab3:setString(str)
end
function Panel_tabTwo:setBtnTitle4(str)
	self.fields.Button_tab4:setString(str)
end
function Panel_tabTwo:setBtnTitle5(str)
	self.fields.Button_tab5:setString(str)
end
function Panel_tabTwo:setBtnCallback(callback)
	self.callback = callback
end
function Panel_tabTwo:initView(param)
	if not param.tabsetArray then
		local _ENV, paramArray = param.tabsetArray, param.tabsetArray
	end
	for i, v in ipairs(paramArray) do
		local button = self:getBtn(i)
		if button then
			button:setString(v.title)
			button:setTag(v.tag or i)
		end
	end
	local callback = param.callback
	if callback then
		self:setBtnCallback(callback)
	end
	local defaultClick = param.defaultClick or 1
	self.curTab = defaultClick
	for i, v in ipairs(paramArray) do
		local tag = v.tag or i
		if tag == defaultClick then
			self:setDefaultClick(i, defaultClick)
			break
		end
	end
end
function Panel_tabTwo:setDefaultClick(index, tag)
	self.controllers.c1:setSelectedIndex(index - 1)
	self:clickTab(tag, true)
end
function Panel_tabTwo:setToTag(index, isSetTab)
	self.controllers.c1:setSelectedIndex(index - 1)
	if isSetTab then
		self.curTab = index
	end
end
function Panel_tabTwo:setBtnLock1(value)
	self:setBtnLock(1, value)
end
function Panel_tabTwo:setBtnLock2(value)
	self:setBtnLock(2, value)
end
function Panel_tabTwo:setBtnLock3(value)
	self:setBtnLock(3, value)
end
function Panel_tabTwo:setBtnLock4(value)
	self:setBtnLock(4, value)
end
function Panel_tabTwo:setBtnLock5(value)
	self:setBtnLock(5, value)
end
function Panel_tabTwo:setBtnLock(index, value)
	local btn = self:getBtn(index)
	if btn.isShowLock then
		btn:isShowLock(value)
	end
end
return Panel_tabTwo

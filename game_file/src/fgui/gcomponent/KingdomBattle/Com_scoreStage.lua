local baseComponent = require("fgui.base.baseComponent")
local Com_scoreStage = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://KingdomBattle/Com_scoreStage", Com_scoreStage)
function Com_scoreStage:onInit()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenerer))
	self.fields.List:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem))
end
function Com_scoreStage:onShow()
end
function Com_scoreStage:onItemRenerer(index, obj)
	obj:setTag(index + 1)
	obj:setWidth(self:getItemWidth())
end
function Com_scoreStage:onClickItem()
	local index = self.fields.List:getSelectedIndex() + 1
	SoraDPlaySound()
	if self.callback then
		self.callback(index)
	end
end
function Com_scoreStage:initView(param)
	if not param.tabsetArray then
		local _ENV, paramArray = param.tabsetArray, param.tabsetArray
	end
	self.paramArray = paramArray
	self.tabNum = #paramArray
	self.fields.List:setNumItems(self.tabNum)
	for i, v in ipairs(paramArray) do
		local button = self:getBtn(i)
		if button then
			button:setString(v.title)
			button:setTag(i)
		end
	end
	local callback = param.callback
	if callback then
		self:setBtnCallback(callback)
	end
	local defaultClick = param.defaultClick or 1
	if param.unDefaultClick == nil then
		for i, v in ipairs(paramArray) do
			if i == defaultClick then
				self:setDefaultClick(i, defaultClick)
				break
			end
		end
	end
end
function Com_scoreStage:getItemWidth()
	return (self.fields.List:getWidth() - self.fields.List:getColumnGap() * (self.tabNum - 1)) / self.tabNum
end
function Com_scoreStage:getBtn(index)
	if index <= self.fields.List:getChildrenCount() then
		return self.fields.List:getChildAt(index - 1)
	end
end
function Com_scoreStage:setBtnCallback(callback)
	self.callback = callback
end
function Com_scoreStage:setDefaultClick(index, tag)
	self:setTabIndex(index, true)
end
function Com_scoreStage:setTabIndex(index, fireEvent)
	self.fields.List:setSelectedIndex(index - 1)
	self.fields.List:scrollToView(index - 1)
	if fireEvent and self.callback then
		self.callback(index)
	end
end
return Com_scoreStage

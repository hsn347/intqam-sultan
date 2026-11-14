local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local Button_withItemInfo = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity2112/Button_withItemInfo", Button_withItemInfo)
fgui.register_extension("ui://Activity2112/Button_WithItem", Button_withItemInfo)
function Button_withItemInfo:onInit()
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_detail:addClickListener(handler(self, self.onClickHandle))
end
function Button_withItemInfo:initData(data)
	self.data = data.data
	self.otherData = data.otherData
	self.handle = data.handle
	self.fields.Text_title:setString(data.title)
	self:setRewardShow(self.data)
	if self.otherData then
		self.fields.List_count:setItemRenderer(handler(self, self.onItemRendererCount))
		if not self.otherData then
			_ENV = self.otherData
		end
		self.fields.List_count:setNumItems(table.nums(self.otherData))
		if not self.otherData then
			_ENV = self.otherData
		end
		self.fields.List_count:resizeToFit(table.nums(self.otherData), 50)
	end
end
function Button_withItemInfo:onItemRenderer(index, object)
	object:initData(self.data[index + 1].id, self.data[index + 1].count)
end
function Button_withItemInfo:onItemRendererCount(index, object)
	object:setIcon(publicRead.getIcon(self.otherData[index + 1].id))
	object:setText(self.otherData[index + 1].count)
end
function Button_withItemInfo:refreshCount(data)
	self.otherData = data
	if not self.otherData then
		_ENV = self.otherData
	end
	self.fields.List_count:setNumItems(table.nums(self.otherData))
	if not self.otherData then
		_ENV = self.otherData
	end
	self.fields.List_count:resizeToFit(table.nums(self.otherData), 50)
end
function Button_withItemInfo:setRewardShow(data)
	if data then
		self.data = data
	end
	if data then
		if not self.data then
			_ENV = self.data
		end
		self.fields.List_reward:setNumItems(table.nums(self.data))
		if self.controllers.state then
			self.controllers.state:setSelectedIndex(1)
		end
	elseif self.controllers.state then
		self.controllers.state:setSelectedIndex(0)
	end
end
function Button_withItemInfo:onClickHandle()
	self.handle()
end
function Button_withItemInfo:onShow()
end
return Button_withItemInfo

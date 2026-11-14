local baseComponent = require("fgui.base.baseComponent")
local Com_recordItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_recordItem", Com_recordItem)
function Com_recordItem:onInit()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function Com_recordItem:onItemRenderer(index, obj)
	obj:initData(self.list[index + 1], self.msgType)
end
function Com_recordItem:onShow()
end
function Com_recordItem:initData(data, msgType)
	self.list = data.list
	self.msgType = msgType
	self.fields.Text_time:setString(data.dateStr)
	table.sort(self.list, function(a, b)
		return a.date > b.date
	end)
	self.fields.List:setNumItems(#self.list)
	self.fields.List:setHeight(#self.list * 72 + (#self.list - 1) * 3)
end
return Com_recordItem

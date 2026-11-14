local baseComponent = require("fgui.base.baseComponent")
local Com_options = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceCreateView/Com_options", Com_options)
function Com_options:onInit()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function Com_options:onShow()
end
function Com_options:onItemRenderer(index, obj)
	obj:initData(self.list[index + 1], self.index)
end
function Com_options:initData(data, index)
	self.index = index
	self.fields.title:setString(data.title)
	self.list = data.list
	self.fields.List:setNumItems(#self.list)
	local line = math.ceil(#self.list / 2)
	local listH = math.max(160, line * 40 + (line - 1) * 20 + 60)
	self.fields.List:setHeight(listH)
	self:setHeight(listH + 40)
end
return Com_options

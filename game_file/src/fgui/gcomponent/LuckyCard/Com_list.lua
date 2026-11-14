local baseComponent = require("fgui.base.baseComponent")
local Com_list = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://LuckyCard/Com_list", Com_list)
function Com_list:onInit()
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
end
function Com_list:onShow()
end
function Com_list:initData(index)
	self.beginIndex = (index - 1) * 5 + 1
	self.fields.List:setNumItems(5)
end
function Com_list:onItemRederer(index, target)
	target:initData(self.beginIndex + index)
end
return Com_list

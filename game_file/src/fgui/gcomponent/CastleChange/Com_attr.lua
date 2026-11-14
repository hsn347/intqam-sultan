local baseComponent = require("fgui.base.baseComponent")
local Com_attr = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CastleChange/Com_attr", Com_attr)
function Com_attr:onInit()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function Com_attr:onItemRenderer(index, obj)
	obj:initData(self.list[index + 1], index + 1)
end
function Com_attr:onShow()
end
function Com_attr:initData(data)
	self.fields.Label_title:setString(data.title)
	self.list = data.list
	self.fields.List:setNumItems(#self.list)
	self.fields.List:setHeight(#self.list * 40)
end
return Com_attr

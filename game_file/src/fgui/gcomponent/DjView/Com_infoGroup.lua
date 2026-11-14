local baseComponent = require("fgui.base.baseComponent")
local Com_infoGroup = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://DjView/Com_infoGroup", Com_infoGroup)
function Com_infoGroup:onInit()
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
end
function Com_infoGroup:onShow()
end
function Com_infoGroup:initData(data)
	self.ListData = data
	self.fields.List:setNumItems(#self.ListData)
	self.fields.List:setHeight(#self.ListData * 54 - 6)
end
function Com_infoGroup:itemRenderer_List(index, obj)
	obj:initData(self.ListData[index + 1], index + 1 == #self.ListData)
end
return Com_infoGroup

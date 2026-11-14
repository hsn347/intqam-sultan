local baseComponent = require("fgui.base.baseComponent")
local medalScrollSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/medalScrollSingle", medalScrollSingle)
function medalScrollSingle:onInit()
	self.fields.List_medal:setItemRenderer(handler(self, self.onItemRenderer))
end
function medalScrollSingle:onShow()
end
function medalScrollSingle:onItemRenderer(index, obj)
	obj:initData(self.data[index + 1], self.index == 1, self.isOther)
end
function medalScrollSingle:initData(data, index, isOther)
	self.data = data
	self.index = index
	self.isOther = isOther
	self.controllers.c1:setSelectedIndex(self.index == 1 and 1 or 0)
	self.fields.List_medal:setNumItems(#self.data)
end
return medalScrollSingle

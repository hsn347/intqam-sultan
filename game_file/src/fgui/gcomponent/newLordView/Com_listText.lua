local baseComponent = require("fgui.base.baseComponent")
local Com_listText = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_listText", Com_listText)
function Com_listText:onInit()
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
end
function Com_listText:onShow()
end
function Com_listText:onItemRenderer(index, obj)
	obj:initData(self.listArray[index + 1], index + 1, self.fcInfo)
end
function Com_listText:initData(listArray, fcInfo)
	self.fcInfo = fcInfo
	self.listArray = listArray
	self.fields.list:setNumItems(#self.listArray)
	self:setHeight(#self.listArray * 39)
end
function Com_listText:getRealHeight()
	return #self.listArray * 39
end
return Com_listText

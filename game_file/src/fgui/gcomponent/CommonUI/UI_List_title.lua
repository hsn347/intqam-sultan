local baseComponent = require("fgui.base.baseComponent")
local UI_List_title = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonUI/UI_List_title", UI_List_title)
function UI_List_title:onInit()
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
end
function UI_List_title:onShow()
end
function UI_List_title:initData(data, minH, noScroll)
	self.ListData = data
	self.fields.List:setNumItems(#self.ListData)
	if noScroll then
		self:setHeight(math.max(minH, #self.ListData * 29))
	else
		self:setHeight(minH)
	end
	self.fields.List:setScrollEnable(#self.ListData * 29 > self.fields.List:getHeight())
end
function UI_List_title:itemRenderer_List(index, obj)
	local title = self.ListData[index + 1]
	obj:setWidth(self.fields.List:getWidth())
	obj:setTitle(title)
end
return UI_List_title

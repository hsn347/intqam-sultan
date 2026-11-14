local baseComponent = require("fgui.base.baseComponent")
local Com_levelPoint = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RomanSoulNew/Com_levelPoint", Com_levelPoint)
function Com_levelPoint:onInit()
	self.fields.Text_point:fixPos()
	self.fields.Text_level:fixPos()
end
function Com_levelPoint:initData(data)
	self.fields.Text_title:setString(data.title)
	self.fields.Text_point:setString(i18n("common_text_1764"))
	self.fields.Text_level:setString(i18n("common_text_748"))
	self.listData = data.subData
	self.fields.List_level:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_level:setNumItems(table.nums(self.listData))
end
function Com_levelPoint:onItemRenderer(index, object)
	object:initData(bit.band(index, 1) == 1 and true or false, self.listData[index + 1])
end
function Com_levelPoint:onShow()
end
return Com_levelPoint

local baseComponent = require("fgui.base.baseComponent")
local List_5 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SmithyView/List_5", List_5)
function List_5:onInit()
	self:fixChildrenPos()
	self.fields.arrow:setRotation(SoraDFIsRA() and 90 or -90)
end
function List_5:onShow()
end
function List_5:initData(data)
	self.fields.Text_name:setString(data.name)
	self.fields.Text_name:setColor(data.color)
	self.fields.Text_curVal:setString(data.curVal)
	self.fields.Text_curVal:setColor(data.color)
	self.fields.Text_toVal:setString(data.toVal)
	self.fields.Text_toVal:setColor(data.color)
end
return List_5

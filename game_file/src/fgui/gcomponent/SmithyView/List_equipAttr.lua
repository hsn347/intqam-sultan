local baseComponent = require("fgui.base.baseComponent")
local List_equipAttr = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SmithyView/List_equipAttr", List_equipAttr)
function List_equipAttr:onInit()
	self:fixChildrenPos()
end
function List_equipAttr:onShow()
end
function List_equipAttr:initData(data)
	self.fields.Text_name:setString(data.name)
	self.fields.Text_name:setColor(SoraDHtmlColor2RGB(data.color))
	self.fields.Text_value:setString(data.value)
	self.fields.Text_value:setColor(SoraDHtmlColor2RGB(data.color))
end
return List_equipAttr

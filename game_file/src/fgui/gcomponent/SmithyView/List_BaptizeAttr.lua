local baseComponent = require("fgui.base.baseComponent")
local List_BaptizeAttr = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SmithyView/List_BaptizeAttr", List_BaptizeAttr)
function List_BaptizeAttr:onInit()
	self:fixChildrenPos()
end
function List_BaptizeAttr:onShow()
end
function List_BaptizeAttr:initData(data)
	self.fields.Text_name:setString(data.name)
	self.fields.Text_name:setColor(data.color)
	self.fields.Text_val:setString(data.value)
	self.fields.Text_val:setColor(data.color)
end
return List_BaptizeAttr

local baseComponent = require("fgui.base.baseComponent")
local List_suit = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SmithyView/List_suit", List_suit)
fgui.register_extension("ui://SmithyView/List_suit2", List_suit)
function List_suit:onInit()
	self:fixChildrenPos()
end
function List_suit:onShow()
end
function List_suit:initData(data)
	self.fields.Text_name:setString(data.name)
	self.fields.Text_val:setString(data.value)
end
return List_suit

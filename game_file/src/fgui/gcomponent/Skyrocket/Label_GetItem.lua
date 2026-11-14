local baseComponent = require("fgui.base.baseComponent")
local Label_GetItem = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://Skyrocket/Label_GetItem", Label_GetItem)
function Label_GetItem:onInit()
	self:fixChildrenPos()
	self.fields.nbg:fix()
end
function Label_GetItem:onShow()
end
function Label_GetItem:setTextName(name)
	self.fields.Text_Name:setString(name)
end
return Label_GetItem

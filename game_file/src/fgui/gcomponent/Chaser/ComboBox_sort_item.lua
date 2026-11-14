local baseComponent = require("fgui.base.baseComponent")
local ComboBox_sort_item = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Chaser/ComboBox_sort_item", ComboBox_sort_item)
function ComboBox_sort_item:onInit()
	self:fixChildrenPos()
end
function ComboBox_sort_item:onShow()
end
return ComboBox_sort_item

local baseComponent = require("fgui.base.baseComponent")
local ComboBox_sort = fgui.extension_class(fgui.GComboBox, baseComponent)
fgui.register_extension("ui://Chaser/ComboBox_sort", ComboBox_sort)
function ComboBox_sort:onInit()
	self:fixChildrenPos()
end
function ComboBox_sort:onShow()
end
return ComboBox_sort

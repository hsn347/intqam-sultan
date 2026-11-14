local baseComponent = require("fgui.base.baseComponent")
local Com_label = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://AllianceManageView/Com_label", Com_label)
function Com_label:onInit()
	self:fixChildrenPos()
end
function Com_label:onShow()
end
return Com_label

local baseComponent = require("fgui.base.baseComponent")
local Com_itemLab = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://Activity_9001602/Com_itemLab", Com_itemLab)
function Com_itemLab:onInit()
	self:fixChildrenPos()
end
function Com_itemLab:onShow()
end
return Com_itemLab

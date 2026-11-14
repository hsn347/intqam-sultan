local baseComponent = require("fgui.base.baseComponent")
local Com_data = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://newLordView/Com_data", Com_data)
function Com_data:onInit()
	self:fixChildrenPos()
end
function Com_data:onShow()
end
return Com_data

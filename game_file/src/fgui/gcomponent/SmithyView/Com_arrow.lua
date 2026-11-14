local baseComponent = require("fgui.base.baseComponent")
local Com_arrow = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SmithyView/Com_arrow", Com_arrow)
function Com_arrow:onInit()
end
function Com_arrow:onShow()
end
function Com_arrow:setMode(mode)
	self.controllers.c1:setSelectedIndex(mode)
end
return Com_arrow

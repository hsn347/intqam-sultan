local baseComponent = require("fgui.base.baseComponent")
local Com_bg = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://StarryNightCarnival/Com_bg", Com_bg)
function Com_bg:onInit()
	self:fixChildrenPos()
end
function Com_bg:onShow()
end
return Com_bg

local baseComponent = require("fgui.base.baseComponent")
local Com_spBox = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://vipCenterView/Com_spBox", Com_spBox)
function Com_spBox:onInit()
end
function Com_spBox:onShow()
end
function Com_spBox:setStatus(status)
	self.controllers.c1:setSelectedIndex(status and 1 or 0)
end
return Com_spBox

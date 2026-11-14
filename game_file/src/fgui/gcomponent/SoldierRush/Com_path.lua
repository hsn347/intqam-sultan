local baseComponent = require("fgui.base.baseComponent")
local Com_path = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SoldierRush/Com_path", Com_path)
function Com_path:onInit()
end
function Com_path:onShow()
end
function Com_path:setPath(ret)
	self.controllers.c1:setSelectedIndex(ret and 1 or 0)
end
return Com_path

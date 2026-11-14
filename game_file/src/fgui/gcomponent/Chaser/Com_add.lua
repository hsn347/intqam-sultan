local baseComponent = require("fgui.base.baseComponent")
local Com_add = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Chaser/Com_add", Com_add)
function Com_add:onInit()
	self:fixChildrenPos()
	self.fields.n64:fix()
end
function Com_add:onShow()
end
return Com_add

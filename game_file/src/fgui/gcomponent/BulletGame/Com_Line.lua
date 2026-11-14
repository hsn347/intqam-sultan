local baseComponent = require("fgui.base.baseComponent")
local Com_Line = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BulletGame/Com_Line", Com_Line)
function Com_Line:onInit()
end
function Com_Line:onShow()
end
function Com_Line:setLineSize(size)
	self:setContentSize(size)
	self.fields.list:setNumItems(size.width / 12)
end
return Com_Line

local baseComponent = require("fgui.base.baseComponent")
local Btn_up = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Chaser/Btn_up", Btn_up)
function Btn_up:onInit()
	self:fixChildrenPos()
end
function Btn_up:onShow()
end
function Btn_up:setShowType(index)
	self.controllers.c1:setSelectedIndex(index)
end
return Btn_up

local baseComponent = require("fgui.base.baseComponent")
local Btn_box = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://vipCenterView/Btn_box", Btn_box)
function Btn_box:onInit()
end
function Btn_box:onShow()
end
function Btn_box:setBoxStatus(status)
	self.controllers.c1:setSelectedIndex(status)
end
return Btn_box

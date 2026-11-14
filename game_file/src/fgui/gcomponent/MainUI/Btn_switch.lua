local baseComponent = require("fgui.base.baseComponent")
local Btn_switch = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_switch", Btn_switch)
function Btn_switch:onInit()
end
function Btn_switch:onShow()
end
function Btn_switch:initData(sType, num)
	self.controllers.c1:setSelectedIndex(sType)
	self.fields.lab_red:setString(num)
end
return Btn_switch

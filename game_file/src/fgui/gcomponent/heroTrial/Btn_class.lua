local baseComponent = require("fgui.base.baseComponent")
local Btn_class = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://heroTrial/Btn_class", Btn_class)
function Btn_class:onInit()
end
function Btn_class:onShow()
end
function Btn_class:setSelect(ret)
	self.fields.select:setVisible(ret)
end
return Btn_class

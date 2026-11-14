local baseComponent = require("fgui.base.baseComponent")
local Btn_pandect = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_pandect", Btn_pandect)
function Btn_pandect:onInit()
end
function Btn_pandect:onShow()
end
function Btn_pandect:setFlipped(ret)
	self.controllers.c1:setSelectedIndex(ret and 1 or 0)
end
return Btn_pandect

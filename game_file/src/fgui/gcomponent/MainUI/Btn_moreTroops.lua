local baseComponent = require("fgui.base.baseComponent")
local Btn_moreTroops = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_moreTroops", Btn_moreTroops)
function Btn_moreTroops:onInit()
end
function Btn_moreTroops:onShow()
end
function Btn_moreTroops:setShowModel(ret)
	self.controllers.c1:setSelectedIndex(ret and 0 or 1)
end
return Btn_moreTroops

local baseComponent = require("fgui.base.baseComponent")
local Button_topup = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://ThemTake/Button_topup", Button_topup)
function Button_topup:onInit()
	self.fields.n3:setAllFrameName("dh_chongzhisc_%.2d.png", 1)
end
function Button_topup:onShow()
end
return Button_topup

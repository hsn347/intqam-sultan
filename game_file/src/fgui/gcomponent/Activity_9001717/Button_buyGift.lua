local baseComponent = require("fgui.base.baseComponent")
local Button_buyGift = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Activity_9001717/Button_buyGift", Button_buyGift)
function Button_buyGift:onInit()
	self.fields.mv_effect:setAllFrameName("icon_9001717_lp_%.2d.png", 1)
end
function Button_buyGift:onShow()
end
return Button_buyGift

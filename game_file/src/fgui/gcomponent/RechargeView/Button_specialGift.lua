local baseComponent = require("fgui.base.baseComponent")
local Button_specialGift = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://RechargeView/Button_specialGift", Button_specialGift)
function Button_specialGift:onInit()
end
function Button_specialGift:onShow()
end
function Button_specialGift:setStatus(index)
	self.controllers.c1:setSelectedIndex(index)
end
return Button_specialGift

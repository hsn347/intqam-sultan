local baseComponent = require("fgui.base.baseComponent")
local Button_BRT_normal = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://BuildResurrectionTree/Button_BRT_normal", Button_BRT_normal)
function Button_BRT_normal:onInit()
end
function Button_BRT_normal:onShow()
end
function Button_BRT_normal:setTitleColor(color)
	self.fields.title:setColor(color)
end
return Button_BRT_normal

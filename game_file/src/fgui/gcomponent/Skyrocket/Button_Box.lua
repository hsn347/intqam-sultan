local baseComponent = require("fgui.base.baseComponent")
local Button_Box = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Skyrocket/Button_Box", Button_Box)
function Button_Box:onInit()
end
function Button_Box:onShow()
end
function Button_Box:setStatus(mayGetCount)
	self.controllers.c1:setSelectedIndex(0 < mayGetCount and 1 or 0)
	self.fields.Label_reddot:initData(0 < mayGetCount, mayGetCount)
end
return Button_Box

local baseComponent = require("fgui.base.baseComponent")
local Label_log = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://PickupStarsAgain/Label_log", Label_log)
function Label_log:onInit()
end
function Label_log:onShow()
end
function Label_log:showBg(value)
	self.fields.bg:setVisible(value)
end
return Label_log

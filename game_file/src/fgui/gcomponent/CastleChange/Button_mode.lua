local baseComponent = require("fgui.base.baseComponent")
local Button_mode = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://CastleChange/Button_mode", Button_mode)
function Button_mode:onInit()
	self.fields.Label_reddot:fixPos()
end
function Button_mode:onShow()
end
function Button_mode:setRed(ret)
	self.fields.Label_reddot:initData(ret)
end
return Button_mode

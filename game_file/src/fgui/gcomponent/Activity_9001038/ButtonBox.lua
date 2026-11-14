local baseComponent = require("fgui.base.baseComponent")
local ButtonBox = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001038/ButtonBox", ButtonBox)
function ButtonBox:onInit()
end
function ButtonBox:onShow()
end
function ButtonBox:setState(index)
	self.controllers.state:setSelectedIndex(index)
end
return ButtonBox

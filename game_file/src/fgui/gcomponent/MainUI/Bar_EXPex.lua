local baseComponent = require("fgui.base.baseComponent")
local Bar_EXPex = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MainUI/Bar_EXPex", Bar_EXPex)
function Bar_EXPex:onInit()
end
function Bar_EXPex:onShow()
	self.fields.bar:setPivot(SoraDFIsRA() and 1 or 0, 0, true)
	self.fields.bar:setPosition(cc.p(SoraDFIsRA() and 80 or 0, 0))
end
return Bar_EXPex

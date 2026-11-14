local baseComponent = require("fgui.base.baseComponent")
local Bar_HPex = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MainUI/Bar_HPex", Bar_HPex)
function Bar_HPex:onInit()
end
function Bar_HPex:onShow()
	self.fields.bar:setPivot(SoraDFIsRA() and 1 or 0, 0, true)
	self.fields.bar:setPosition(cc.p(SoraDFIsRA() and 80 or 0, 0))
end
return Bar_HPex

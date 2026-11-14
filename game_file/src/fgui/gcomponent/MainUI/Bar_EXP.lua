local baseComponent = require("fgui.base.baseComponent")
local Bar_EXP = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MainUI/Bar_EXP", Bar_EXP)
function Bar_EXP:onInit()
end
function Bar_EXP:onShow()
	self.fields.bar:setPivot(SoraDFIsRA() and 1 or 0, 0, true)
	self.fields.bar:setPosition(cc.p(SoraDFIsRA() and 79 or 2, 2))
end
function Bar_EXP:setValue(val)
	val = math.min(val, 100)
	self.fields.bar:setWidth(val * 80 / 100)
end
return Bar_EXP

local baseComponent = require("fgui.base.baseComponent")
local Bar_HP = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MainUI/Bar_HP", Bar_HP)
function Bar_HP:onInit()
end
function Bar_HP:onShow()
	self.fields.bar:setPivot(SoraDFIsRA() and 1 or 0, 0, true)
	self.fields.bar:setPosition(cc.p(SoraDFIsRA() and 79 or 2, 2))
end
function Bar_HP:setValue(val)
	val = math.min(val, 100)
	self.fields.bar:setWidth(val * 80 / 100)
end
return Bar_HP

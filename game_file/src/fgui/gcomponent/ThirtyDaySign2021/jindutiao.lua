local baseComponent = require("fgui.base.baseComponent")
local jindutiao = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ThirtyDaySign2021/jindutiao", jindutiao)
function jindutiao:onInit()
	self.fields.n1:setBlendFunc(gl.ONE, gl.ONE)
end
function jindutiao:onShow()
end
return jindutiao

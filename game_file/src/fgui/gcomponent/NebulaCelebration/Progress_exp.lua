local baseComponent = require("fgui.base.baseComponent")
local Progress_exp = fgui.extension_class(fgui.GProgressBar, baseComponent)
fgui.register_extension("ui://NebulaCelebration/Progress_exp", Progress_exp)
function Progress_exp:onInit()
	self:fixChildrenPos()
	self.fields.bar:getChild("bar"):fixPos()
end
function Progress_exp:onShow()
end
return Progress_exp

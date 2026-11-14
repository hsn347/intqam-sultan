local baseComponent = require("fgui.base.baseComponent")
local ComScore = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://LegendaryKing/ComScore", ComScore)
function ComScore:onInit()
end
function ComScore:onShow()
end
function ComScore:initData(index)
	self.controllers.ctrlLight:setSelectedIndex(index % 2 == 1 and 0 or 1)
end
return ComScore

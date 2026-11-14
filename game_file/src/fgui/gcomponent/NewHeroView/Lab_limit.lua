local baseComponent = require("fgui.base.baseComponent")
local Lab_limit = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://NewHeroView/Lab_limit", Lab_limit)
function Lab_limit:onInit()
	self:fixChildrenPos()
end
function Lab_limit:onShow()
end
return Lab_limit

local baseComponent = require("fgui.base.baseComponent")
local Leb_res = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://QuestView/Leb_res", Leb_res)
function Leb_res:onInit()
	self:fixChildrenPos()
end
function Leb_res:onShow()
end
return Leb_res

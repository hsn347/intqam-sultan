local baseComponent = require("fgui.base.baseComponent")
local Lab_item = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://ShopSingleBuy/Lab_item", Lab_item)
function Lab_item:onInit()
	self:fixChildrenPos()
end
function Lab_item:onShow()
end
return Lab_item

local baseComponent = require("fgui.base.baseComponent")
local Com_star = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SoldierRush/Com_star", Com_star)
function Com_star:onInit()
	self:fixChildrenPos()
end
function Com_star:onShow()
end
function Com_star:initData(num)
	self.controllers.c1:setSelectedIndex(num)
end
return Com_star

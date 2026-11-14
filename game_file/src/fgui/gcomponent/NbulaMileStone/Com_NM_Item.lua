local baseComponent = require("fgui.base.baseComponent")
local Com_NM_Item = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NbulaMileStone/Com_NM_Item", Com_NM_Item)
function Com_NM_Item:onInit()
end
function Com_NM_Item:onShow()
end
function Com_NM_Item:initData(id, num, isGot)
	self.fields.item:initData(id, num)
	self.controllers.c1:setSelectedIndex(isGot and 1 or 0)
end
return Com_NM_Item

local baseComponent = require("fgui.base.baseComponent")
local Com_item_ice = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://IceDragonLost/Com_item_ice", Com_item_ice)
function Com_item_ice:onInit()
end
function Com_item_ice:onShow()
end
function Com_item_ice:initData(id, count)
	self.fields.item:initData(id, count)
end
return Com_item_ice

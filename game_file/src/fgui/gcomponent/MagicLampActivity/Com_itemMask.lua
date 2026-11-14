local baseComponent = require("fgui.base.baseComponent")
local Com_itemMask = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MagicLampActivity/Com_itemMask", Com_itemMask)
function Com_itemMask:onInit()
end
function Com_itemMask:initData(id, num, index)
	self.fields.Com_item:initData(id, num)
	self.controllers.c1:setSelectedIndex(index or 0)
end
function Com_itemMask:setState(state)
	self.controllers.c1:setSelectedIndex(state)
end
function Com_itemMask:onShow()
end
return Com_itemMask

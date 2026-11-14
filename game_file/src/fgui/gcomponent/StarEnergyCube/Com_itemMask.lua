local baseComponent = require("fgui.base.baseComponent")
local Com_itemMask = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://StarEnergyCube/Com_itemMask", Com_itemMask)
fgui.register_extension("ui://Anniversary2022/Com_itemCheck", Com_itemMask)
function Com_itemMask:onInit()
end
function Com_itemMask:initData(id, num, hadGet)
	self.fields.Com_item:initData(id, num)
	self.controllers.c1:setSelectedIndex(hadGet and 1 or 0)
end
function Com_itemMask:setState(state)
	self.controllers.c1:setSelectedIndex(state)
end
function Com_itemMask:onShow()
end
return Com_itemMask

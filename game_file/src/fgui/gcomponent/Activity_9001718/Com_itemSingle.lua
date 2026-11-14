local baseComponent = require("fgui.base.baseComponent")
local Com_itemSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001718/Com_itemSingle", Com_itemSingle)
function Com_itemSingle:onInit()
	self.fields.mv_paopao:setAllFrameName("9001718_paopao_%.2d.png", 1)
end
function Com_itemSingle:onShow()
end
return Com_itemSingle

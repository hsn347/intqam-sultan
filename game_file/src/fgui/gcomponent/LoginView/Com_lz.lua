local baseComponent = require("fgui.base.baseComponent")
local Com_lz = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://LoginView/Com_lz", Com_lz)
function Com_lz:onInit()
	self.fields.mv_w1:setAllFrameName("dh_loadingjdt1_%.2d.png", 0)
	self.fields.mv_w2:setAllFrameName("dh_loadingjdt1_%.2d.png", 0)
end
function Com_lz:onShow()
end
return Com_lz

local baseComponent = require("fgui.base.baseComponent")
local Com_hd = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001128/Com_hd", Com_hd)
function Com_hd:onInit()
	self.fields.mv_hd1:setAllFrameName("hudie%.2d.png", 0)
	self.fields.mv_hd2:setAllFrameName("hudie%.2d.png", 0)
	self.fields.mv_hd3:setAllFrameName("hudie%.2d.png", 0)
end
function Com_hd:onShow()
end
return Com_hd

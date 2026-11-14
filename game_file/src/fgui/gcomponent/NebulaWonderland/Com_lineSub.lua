local baseComponent = require("fgui.base.baseComponent")
local Com_lineSub = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NebulaWonderland/Com_lineSub", Com_lineSub)
function Com_lineSub:onInit()
	self.fields.Ani_line:setAllFrameName("dh_xingyunqijingx__%.2d.png", 0)
end
function Com_lineSub:onShow()
end
return Com_lineSub

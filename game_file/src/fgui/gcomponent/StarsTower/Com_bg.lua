local baseComponent = require("fgui.base.baseComponent")
local Com_bg = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://StarsTower/Com_bg", Com_bg)
function Com_bg:onInit()
	self.fields.icon:setScaleX(SoraDFIsRA() and 1 or -1)
end
function Com_bg:onShow()
end
return Com_bg

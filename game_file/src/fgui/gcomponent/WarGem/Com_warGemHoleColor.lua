local baseComponent = require("fgui.base.baseComponent")
local Com_warGemHoleColor = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://WarGem/Com_warGemHoleColor", Com_warGemHoleColor)
function Com_warGemHoleColor:onInit()
end
function Com_warGemHoleColor:onShow()
end
function Com_warGemHoleColor:setColor(color)
	self.controllers.c1:setSelectedIndex(color)
end
return Com_warGemHoleColor

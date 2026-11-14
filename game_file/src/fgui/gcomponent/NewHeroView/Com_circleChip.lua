local baseComponent = require("fgui.base.baseComponent")
local Com_circleChip = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://NewHeroView/Com_circleChip", Com_circleChip)
function Com_circleChip:onInit()
	self.fields.n3:setTexture("SinglePicture/G_round.png")
end
function Com_circleChip:onShow()
end
function Com_circleChip:setColor(color)
	self.fields.icon:setColor(color)
end
return Com_circleChip

local baseComponent = require("fgui.base.baseComponent")
local Com_circleHead = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://NewHeroView/Com_circleHead", Com_circleHead)
function Com_circleHead:onInit()
	self.fields.n3:setTexture("SinglePicture/G_round.png")
end
function Com_circleHead:onShow()
end
return Com_circleHead

local baseComponent = require("fgui.base.baseComponent")
local Com_roundQuality = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://CommonNew/Com_roundQuality", Com_roundQuality)
function Com_roundQuality:onInit()
	self.fields.n1:setTexture("SinglePicture/G_round.png")
end
function Com_roundQuality:onShow()
end
return Com_roundQuality

local baseComponent = require("fgui.base.baseComponent")
local Com_roundHead = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://newLordView/Com_roundHead", Com_roundHead)
function Com_roundHead:onInit()
	self.fields.n2:setTexture("SinglePicture/G_round.png")
end
function Com_roundHead:onShow()
end
return Com_roundHead

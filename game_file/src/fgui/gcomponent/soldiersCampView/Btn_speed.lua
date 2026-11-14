local baseComponent = require("fgui.base.baseComponent")
local Btn_speed = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://soldiersCampView/Btn_speed", Btn_speed)
function Btn_speed:onInit()
	self.fields.icon:setSpriteFrame(not SoraDFIsRA() and "5006_flip.png" or "5006.png")
	self:fixChildrenPos()
end
function Btn_speed:onShow()
end
return Btn_speed

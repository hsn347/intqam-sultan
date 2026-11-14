local baseComponent = require("fgui.base.baseComponent")
local Panel_normal = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://CommonNew/Panel_normal", Panel_normal)
fgui.register_extension("ui://CommonUI/UI_Panel_bg", Panel_normal)
fgui.register_extension("ui://CommonUI/UI_Panel_bg384", Panel_normal)
fgui.register_extension("ui://CommonUI/UI_Panel_bg457", Panel_normal)
fgui.register_extension("ui://CommonUI/UI_Panel_bg586", Panel_normal)
fgui.register_extension("ui://CommonUI/UI_Panel_bg723", Panel_normal)
fgui.register_extension("ui://CommonUI/UI_Panel_bg820", Panel_normal)
fgui.register_extension("ui://CommonUI/UI_Panel_bg993", Panel_normal)
function Panel_normal:onInit()
end
function Panel_normal:onShow()
	self:addTextEffect()
end
function Panel_normal:addTextEffect(fromColor, toColor)
	self.fields.title:enableGradient(fromColor or cc.c3b(224, 211, 188), toColor or cc.c3b(225, 200, 144))
	self.fields.title:enableShadow(cc.c3b(0, 0, 0), cc.size(2, -2))
end
function Panel_normal:setString(title)
	self.fields.title:setString(title)
	self:addTextEffect()
end
return Panel_normal

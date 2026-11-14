local baseComponent = require("fgui.base.baseComponent")
local Com_questBg = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MainUI/Com_questBg", Com_questBg)
function Com_questBg:onInit()
	self.fields.effect:fixPos()
	self.fields.effect:setScaleX(SoraDFIsRA() and 1 or -1)
end
function Com_questBg:onShow()
end
function Com_questBg:setShowType(sType)
	self.controllers.c1:setSelectedIndex(sType)
end
return Com_questBg

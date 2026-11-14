local baseComponent = require("fgui.base.baseComponent")
local Com_congratulationsTitle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonBoxSingle/Com_congratulationsTitle", Com_congratulationsTitle)
function Com_congratulationsTitle:onInit()
	self.fields.Load_title:setVisible(false)
	self.fields.Usm_title:setBlendMode(fgui.BlendMode.Normal)
end
function Com_congratulationsTitle:onShow()
	self.fields.Usm_title:setEffectPath(SoraDFIsRA() and "gongxihdwz_ay.usm" or "gongxihdwz_en.usm")
end
return Com_congratulationsTitle

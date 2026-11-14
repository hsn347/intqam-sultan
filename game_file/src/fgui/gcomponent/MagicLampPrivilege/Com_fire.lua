local baseComponent = require("fgui.base.baseComponent")
local Com_fire = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MagicLampPrivilege/Com_fire", Com_fire)
function Com_fire:onInit()
	self.fields.fire:setAllFrameName("dh_dxtanxian_%.2d.png", 1)
end
function Com_fire:onShow()
end
return Com_fire

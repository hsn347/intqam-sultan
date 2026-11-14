local baseComponent = require("fgui.base.baseComponent")
local Com_starSingle = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://MagicLampSkill/Com_starSingle", Com_starSingle)
function Com_starSingle:onInit()
end
function Com_starSingle:onShow()
end
function Com_starSingle:setStar(ret)
	self.controllers.c1:setSelectedIndex(ret and 1 or 0)
end
return Com_starSingle

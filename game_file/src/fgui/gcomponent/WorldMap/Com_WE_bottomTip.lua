local baseComponent = require("fgui.base.baseComponent")
local Com_WE_bottomTip = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://WorldMap/Com_WE_bottomTip", Com_WE_bottomTip)
function Com_WE_bottomTip:onInit()
end
function Com_WE_bottomTip:onShow()
	self.fields.title:setString(i18n("common_text_089"))
end
return Com_WE_bottomTip

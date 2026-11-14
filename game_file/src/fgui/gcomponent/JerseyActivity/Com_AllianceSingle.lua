local baseComponent = require("fgui.base.baseComponent")
local Com_AllianceSingle = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://JerseyActivity/Com_AllianceSingle", Com_AllianceSingle)
function Com_AllianceSingle:onInit()
end
function Com_AllianceSingle:onShow()
end
return Com_AllianceSingle

local baseComponent = require("fgui.base.baseComponent")
local Com_MGC_Dialog = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MainCityGuide/Com_MGC_Dialog", Com_MGC_Dialog)
function Com_MGC_Dialog:onInit()
end
function Com_MGC_Dialog:onShow()
end
return Com_MGC_Dialog

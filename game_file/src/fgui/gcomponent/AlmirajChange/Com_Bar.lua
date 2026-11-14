local baseComponent = require("fgui.base.baseComponent")
local Com_Bar = fgui.extension_class(fgui.GProgressBar, baseComponent)
fgui.register_extension("ui://AlmirajChange/Com_Bar", Com_Bar)
function Com_Bar:onInit()
end
function Com_Bar:onShow()
end
return Com_Bar

local baseComponent = require("fgui.base.baseComponent")
local com_Meteorite_strategy = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MeteoriteMagicCan/com_Meteorite_strategy", com_Meteorite_strategy)
function com_Meteorite_strategy:onInit()
end
function com_Meteorite_strategy:onShow()
end
return com_Meteorite_strategy

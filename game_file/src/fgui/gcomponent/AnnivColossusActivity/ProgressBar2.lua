local baseComponent = require("fgui.base.baseComponent")
local ProgressBar2 = fgui.extension_class(fgui.GProgressBar, baseComponent)
fgui.register_extension("ui://AnnivColossusActivity/ProgressBar2", ProgressBar2)
function ProgressBar2:onInit()
end
function ProgressBar2:onShow()
end
return ProgressBar2

local baseComponent = require("fgui.base.baseComponent")
local ProgressBar1 = fgui.extension_class(fgui.GProgressBar, baseComponent)
fgui.register_extension("ui://AnnivColossusActivity/ProgressBar1", ProgressBar1)
function ProgressBar1:onInit()
end
function ProgressBar1:onShow()
end
return ProgressBar1

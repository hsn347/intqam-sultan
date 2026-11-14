local baseComponent = require("fgui.base.baseComponent")
local SpineTest = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ForeignPavilion/SpineTest", SpineTest)
function SpineTest:onInit()
end
function SpineTest:onShow()
end
return SpineTest

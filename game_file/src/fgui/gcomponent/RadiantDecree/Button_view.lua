local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local Button_view = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://RadiantDecree/Button_view", Button_view)
function Button_view:onInit()
end
function Button_view:initData()
end
function Button_view:onShow()
end
return Button_view

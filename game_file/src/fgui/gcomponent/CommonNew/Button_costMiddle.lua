local Button_cost = require("fgui.gcomponent.CommonNew.Button_cost")
local Button_costMiddle = fgui.extension_class(fgui.GButton, Button_cost)
fgui.register_extension("ui://CommonNew/Button_costMiddle", Button_costMiddle)
fgui.register_extension("ui://CommonNew/Button_costMiddle2", Button_costMiddle)
fgui.register_extension("ui://pyramidView/Button_costMiddle", Button_costMiddle)
return Button_costMiddle

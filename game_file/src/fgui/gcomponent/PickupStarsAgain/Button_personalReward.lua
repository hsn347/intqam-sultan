local baseComponent = require("fgui.base.baseComponent")
local Button_personalReward = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://PickupStarsAgain/Button_personalReward", Button_personalReward)
function Button_personalReward:onInit()
end
function Button_personalReward:onShow()
end
function Button_personalReward:initData(status)
	self.controllers.c1:setSelectedIndex(status)
end
return Button_personalReward

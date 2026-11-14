local baseComponent = require("fgui.base.baseComponent")
local Button_strength = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Chaser/Button_strength", Button_strength)
function Button_strength:onInit()
end
function Button_strength:onShow()
end
function Button_strength:initData(title, isMax)
	self.fields.title:setString(title)
	self.fields.max:setVisible(isMax)
end
return Button_strength

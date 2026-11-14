local baseComponent = require("fgui.base.baseComponent")
local Button_attack = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://angerSnowWolf/Button_attack", Button_attack)
function Button_attack:onInit()
	self.controllers.c2:setSelectedIndex(SoraDFIsRA() and 0 or 1)
	self.fields.title:fixPos()
	self.fields.icon_tool:fixPos()
end
function Button_attack:onShow()
end
function Button_attack:initData(num)
	self.fields.title:setString(num)
end
return Button_attack

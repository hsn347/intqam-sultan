local publicRead = include("publicRead")
local activity_9001660_Ctrl = SoraDGetCtrl("activity_9001660_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Button_attack = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Activity_9001660/Button_attack", Button_attack)
function Button_attack:onInit()
	self.fields.icon_tool:setSpriteFrame(publicRead.getIcon(activity_9001660_Ctrl:getItemID()))
	self.controllers.c2:setSelectedIndex(SoraDFIsRA() and 0 or 1)
	self.fields.title:fixPos()
	self.fields.icon_tool:fixPos()
end
function Button_attack:onShow()
end
function Button_attack:initData(num)
	self.fields.title:setString(num)
	self:setReddot(num <= activity_9001660_Ctrl:getItemCount())
end
return Button_attack

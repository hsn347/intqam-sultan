local armyDesRead = include("armyDesRead")
local baseComponent = require("fgui.base.baseComponent")
local armyNode = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://TroopsChange/armyNode", armyNode)
function armyNode:onInit()
end
function armyNode:setState(index)
	self.controllers.c1:setSelectedIndex(index)
end
function armyNode:setIcon(armyId)
	self.fields.Sprite_chip:setURL(armyDesRead.getIcon(armyId))
	self.fields.iconLevel:setURL(armyDesRead.getLvImg(armyId))
end
function armyNode:setExchangeHandler(handler)
end
return armyNode

local armyDesRead = include("armyDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_armySingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://troopFlagView/Com_armySingle", Com_armySingle)
function Com_armySingle:onInit()
end
function Com_armySingle:onShow()
end
function Com_armySingle:initData(id)
	self.fields.Sprite_armyHead:setSpriteFrame(armyDesRead.getIcon(id))
	self.fields.Sprite_armyLevel:setSpriteFrame(armyDesRead.getLvImg(id))
	local warLv = armyDesRead.getWarLv(id)
	self.fields.Lab_warLv:setVisible(0 < warLv)
	self.fields.Lab_warLv:setString(warLv)
end
return Com_armySingle

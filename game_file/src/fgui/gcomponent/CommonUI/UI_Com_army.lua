local armyDesRead = include("armyDesRead")
local armyLogic = include("armyLogic")
local baseComponent = require("fgui.base.baseComponent")
local UI_Com_army = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonUI/UI_Com_army", UI_Com_army)
function UI_Com_army:onInit()
end
function UI_Com_army:onShow()
end
function UI_Com_army:initData(armyid)
	self.fields.icon:setSpriteFrame(armyDesRead.getIcon(armyid))
	local armyType = armyLogic.getArmyTypeByID(armyid)
	if armyType == gSoldierType.TRAP_TYPE_STONE or armyType == gSoldierType.TRAP_TYPE_ARROW or armyType == gSoldierType.TRAP_TYPE_WOOD then
		self.fields.lv:setSpriteFrame(armyDesRead.getTrapLvImg(armyid))
	else
		self.fields.lv:setSpriteFrame(armyDesRead.getLvImg(armyid))
	end
	local warLv = armyDesRead.getWarLv(armyid)
	self.fields.warLv:setVisible(0 < warLv)
	self.fields.warLv:setString(warLv)
end
return UI_Com_army

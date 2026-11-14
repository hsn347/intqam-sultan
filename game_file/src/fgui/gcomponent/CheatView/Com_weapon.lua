local heroWeaponRead = include("heroWeaponRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_weapon = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://CheatView/Com_weapon", Com_weapon)
function Com_weapon:onInit()
end
function Com_weapon:onShow()
end
function Com_weapon:initData(weaponID)
	self.fields.Image_quality:setSpriteFrame(heroWeaponRead.getWeaponBasePng(heroWeaponRead.getWeaponStageLimit(weaponID)))
	self.fields.icon:setSpriteFrame(heroWeaponRead.getWeaponIcon(weaponID))
	self.fields.title:setString(heroWeaponRead.getWeaponName(weaponID))
end
return Com_weapon

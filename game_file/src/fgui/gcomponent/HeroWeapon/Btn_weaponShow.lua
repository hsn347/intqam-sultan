local heroWeaponRead = include("heroWeaponRead")
local baseComponent = require("fgui.base.baseComponent")
local Btn_weaponShow = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://HeroWeapon/Btn_weaponShow", Btn_weaponShow)
function Btn_weaponShow:onInit()
end
function Btn_weaponShow:onShow()
end
function Btn_weaponShow:initData(data)
	self.data = data
	self.fields.Image_quality:setSpriteFrame(heroWeaponRead.getWeaponBasePng(self.data.quality))
	local weaponID = self.data.weaponID or self.data.weaponId
	self.fields.icon:setSpriteFrame(heroWeaponRead.getWeaponIcon(weaponID))
end
return Btn_weaponShow

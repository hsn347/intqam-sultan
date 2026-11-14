local baseComponent = require("fgui.base.baseComponent")
local Btn_shop = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://HeroWeapon/Btn_shop", Btn_shop)
function Btn_shop:onInit()
	self.fields.title:setString(i18n("HeroWeapon_2"))
	self.fields.Label_reddot:setVisible(false)
	self.fields.Btn:addClickListener(handler(self, self.btnShopClick))
end
function Btn_shop:onShow()
end
function Btn_shop:btnShopClick()
	SoraDPlaySound()
	uiManager:show("HeroWeaponShop")
end
return Btn_shop

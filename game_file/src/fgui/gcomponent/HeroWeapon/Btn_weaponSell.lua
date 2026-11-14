local baseComponent = require("fgui.base.baseComponent")
local Btn_weaponSell = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://HeroWeapon/Btn_weaponSell", Btn_weaponSell)
function Btn_weaponSell:onInit()
	self:addClickListener(handler(self, self.btnClick))
end
function Btn_weaponSell:onShow()
end
function Btn_weaponSell:initData(data, index, selectList)
	self.data = data
	self.index = index
	self.isChoose = selectList[tostring(self.index)] or false
	self.fields.weapon:initData(self.data)
	self.controllers.c1:setSelectedIndex(self.isChoose and 1 or 0)
end
function Btn_weaponSell:btnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_HERO_WEAPON_UI_SELL_SELECT"
	;(nil).index = self.index
	;(nil).isSelect = not self.isChoose
	SoraDSendMessage(nil)
end
return Btn_weaponSell

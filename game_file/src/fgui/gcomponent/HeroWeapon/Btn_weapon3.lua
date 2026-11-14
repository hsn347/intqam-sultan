local heroWeaponCtrl = SoraDGetCtrl("heroWeaponCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Btn_weapon3 = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://HeroWeapon/Btn_weapon3", Btn_weapon3)
function Btn_weapon3:onInit()
	self:addClickListener(handler(self, self.btnClick))
end
function Btn_weapon3:onShow()
end
function Btn_weapon3:initData(data, uid)
	self.data = data
	self.fields.weapon:initData(data)
	local isSel = uid and self.data.id == uid
	self.controllers.c1:setSelectedIndex(isSel and 1 or 0)
end
function Btn_weapon3:btnClick()
	SoraDPlaySound()
	if heroWeaponCtrl:getWearHeroId(self.data.id) then
		_ENV = nil
		;(nil).content = i18n("HeroWeapon_30")
		;(nil).confirmString = i18n("common_text_204")
		;(nil).confirmFunc = function()
			_ENV = nil
			;(nil).msg = "MESSAGE_HERO_WEAPON_UI_WEAR_SELECT"
			;(nil).uid = self.data.id
			SoraDSendMessage(nil)
		end
		;(nil).cancelString = i18n("common_text_185")
		uiManager:show("MessageBox", nil)
	else
		_ENV = uiManager
		uiManager.msg = "MESSAGE_HERO_WEAPON_UI_WEAR_SELECT"
		uiManager.uid = self.data.id
		SoraDSendMessage(uiManager)
	end
end
return Btn_weapon3

local baseComponent = require("fgui.base.baseComponent")
local Btn_weapon2 = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://HeroWeapon/Btn_weapon2", Btn_weapon2)
function Btn_weapon2:onInit()
	self.fields.select:setVisible(false)
	self:addClickListener(handler(self, self.btnClick))
end
function Btn_weapon2:onShow()
end
function Btn_weapon2:initData(data, selList, isLimit)
	self.data = data
	self.isLimit = isLimit
	self.fields.weapon:initData(self.data)
	self.isSel = selList[self.data.id] and selList[self.data.id] == 1
	self.fields.select:setVisible(self.isSel)
end
function Btn_weapon2:btnClick()
	SoraDPlaySound()
	if not self.isLimit then
		_ENV = nil
		;(nil).msg = "MESSAGE_HERO_WEAPON_UI_COST_SELECT_MORE"
		;(nil).weaponUid = self.data.id
		;(nil).select = not self.isSel
		SoraDSendMessage(nil)
	elseif self.isSel then
		_ENV = nil
		;(nil).msg = "MESSAGE_HERO_WEAPON_UI_COST_SELECT_MORE"
		;(nil).weaponUid = self.data.id
		;(nil).select = not self.isSel
		SoraDSendMessage(nil)
	end
end
return Btn_weapon2

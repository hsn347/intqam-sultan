local heroWeaponCtrl = SoraDGetCtrl("heroWeaponCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Btn_list = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://HeroWeapon/Btn_list", Btn_list)
function Btn_list:onInit()
	self.fields.title:setString(i18n("HeroWeapon_1"))
	self.fields.Label_reddot:initData(false)
	self.fields.Btn:addClickListener(handler(self, self.btnListClick))
end
function Btn_list:onShow()
end
function Btn_list:setRedDot()
	local ret, map = heroWeaponCtrl:isHaveMergeEnable()
	self.fields.Label_reddot:initData(ret, table.nums(map))
end
function Btn_list:btnListClick()
	SoraDPlaySound()
	uiManager:show("HeroWeaponList")
end
return Btn_list

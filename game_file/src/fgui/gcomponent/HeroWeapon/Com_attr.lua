local heroWeaponRead = include("heroWeaponRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_attr = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://HeroWeapon/Com_attr", Com_attr)
function Com_attr:onInit()
	self.attrData, _ENV = nil, nil
	self.fields.Label_base:setString(i18n("Weapon_Rune_tips_007"))
	self.fields.Label_special:setString(i18n("Weapon_Rune_tips_008"))
	self.fields.List_base:setItemRenderer(handler(self, self.onListRenderer))
end
function Com_attr:onShow()
end
function Com_attr:onListRenderer(index, obj)
	obj:initData(self.attrData[index + 1])
end
function Com_attr:initData(data)
	self.data = data
	local attrCfg = heroWeaponRead.getBasicAttr(self.data)
	self.attrData = heroWeaponRead.getBasicRealAttr(self.data)
	self.fields.List_base:setNumItems(#self.attrData)
	self.fields.Text_special:setString(heroWeaponRead.getSpecialAttr(self.data))
end
return Com_attr

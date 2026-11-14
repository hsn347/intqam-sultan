local heroWeaponRead = include("heroWeaponRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_attrsp = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://HeroWeapon/Com_attrsp", Com_attrsp)
function Com_attrsp:onInit()
	self.attrData, _ENV = nil, nil
	self.fields.Label_base:setString(i18n("Weapon_Rune_tips_007"))
	self.fields.Label_special:setString(i18n("Weapon_Rune_tips_008"))
	self.fields.List_base:setItemRenderer(handler(self, self.onListRenderer))
	self.fields.Text_none_base:setString(i18n("hero_appoint_14"))
	self.fields.Text_none_special:setString(i18n("hero_appoint_14"))
	self:fixChildrenPos()
end
function Com_attrsp:onListRenderer(index, obj)
	obj:initData(self.attrData[index + 1])
end
function Com_attrsp:onShow()
end
function Com_attrsp:initData(data)
	self.data = data
	if self.data then
		self.fields.weapon:initData(self.data)
		self.fields.Text_name:setString(heroWeaponRead.getWeaponName(self.data.weaponID))
		local recipientName = heroWeaponRead.getRecipientName(self.data.weaponID, true)
		self.fields.Text_pro:setString(recipientName or "")
		local attrCfg = heroWeaponRead.getBasicAttr(self.data)
		self.attrData = heroWeaponRead.getBasicRealAttr(self.data)
		self.fields.List_base:setNumItems(#self.attrData)
		self.fields.Text_special:setString(heroWeaponRead.getSpecialAttr(self.data))
		self.fields.Text_none_base:setVisible(false)
		self.fields.Text_none_special:setVisible(false)
	else
		self.fields.Text_name:setString("")
		self.fields.Text_pro:setString("")
		self.fields.weapon:initNone()
		self.fields.List_base:setNumItems(0)
		self.fields.Text_special:setString("")
		self.fields.Text_none_base:setVisible(true)
		self.fields.Text_none_special:setVisible(true)
	end
end
return Com_attrsp

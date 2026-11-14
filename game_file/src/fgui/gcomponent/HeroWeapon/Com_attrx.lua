local heroWeaponRead = include("heroWeaponRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_attrx = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://HeroWeapon/Com_attrx", Com_attrx)
function Com_attrx:onInit()
	self.attrData, _ENV = nil, nil
	self.fields.Text_sptitle:setString(i18n("Weapon_Rune_tips_008"))
	self.fields.List_base:setItemRenderer(handler(self, self.onListRenderer))
	self.controllers.c1:setSelectedIndex(0)
end
function Com_attrx:onShow()
end
function Com_attrx:onListRenderer(index, obj)
	obj:initData(self.attrData[index + 1])
end
function Com_attrx:initData(data)
	self.data = data
	local attrCfg = heroWeaponRead.getBasicAttr(self.data)
	self.attrData = heroWeaponRead.getBasicRealAttr(self.data, self.data.preStage, self.data.preLv, self.data.isMax)
	self.fields.List_base:setNumItems(#self.attrData)
	self.controllers.c1:setSelectedIndex(0)
	self.fields.Text_special:setString(heroWeaponRead.getSpecialAttr(self.data))
end
function Com_attrx:initDataEX(data)
	self.data = data
	local attrCfg = heroWeaponRead.getBasicAttr(self.data)
	local attrCfgTo = heroWeaponRead.getBasicAttr(self.data, self.data.preStage)
	self.attrData = heroWeaponRead.getBasicRealAttr(self.data, self.data.preStage, self.data.preLv, self.data.isMax)
	self.fields.List_base:setNumItems(#self.attrData)
	if not self.data.isMax then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Text_special:setString(heroWeaponRead.getSpecialAttr(self.data))
		self.fields.Text_specialTo:setString(heroWeaponRead.getSpecialAttr(self.data, self.data.preStage))
	else
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Text_special:setString(heroWeaponRead.getSpecialAttr(self.data))
	end
end
return Com_attrx

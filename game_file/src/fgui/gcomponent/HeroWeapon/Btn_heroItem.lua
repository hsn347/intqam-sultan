local heroCtrl = SoraDGetCtrl("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Btn_heroItem = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://HeroWeapon/Btn_heroItem", Btn_heroItem)
function Btn_heroItem:onInit()
	self.fields.Sprite_quality:fixPos()
	self.fields.Sprite_heroClass:fixPos()
	self.fields.Text_lv:fixPos()
end
function Btn_heroItem:onShow()
end
function Btn_heroItem:initData(heroID)
	self.heroID = tonumber(heroID)
	local heroInfo = heroCtrl:getHeroInfoByID(self.heroID)
	self.fields.bg:setSpriteFrame(heroltCtrl.getBg(heroInfo.quality))
	local heroCfg = heroltCtrl.getHeroInfo(self.heroID)
	self.fields.icon:setSpriteFrame(heroCfg.herIcon)
	self.fields.Text_lv:setString(heroInfo.level)
	self.fields.Sprite_quality:setSpriteFrame(heroltCtrl:getCardRareImg(self.heroID))
	local heroClassInfo = heroltCtrl.getHeroClassTypeInfo(self.heroID)
	self.fields.Sprite_heroClass:setSpriteFrame(heroClassInfo.icon)
end
return Btn_heroItem
